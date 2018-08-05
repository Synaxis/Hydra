package gs

import (
	"bytes"
	"crypto/tls"
	"errors"
	"fmt"
	"io"
	"net"
	"time"

	"encoding/binary"
	"encoding/hex"

	"github.com/Synaxis/Hydra/inter/core"
	"github.com/Synaxis/Hydra/inter/log"
)

type ClientTLS struct {
	name       string
	conn       *tls.Conn
	recvBuffer []byte
	eventChan  chan ClientTLSEvent
	IsActive   bool
	IpAddr     net.Addr
	RedisState *core.RedisState
	State      ClientTLSState
	FESL       bool
}

type ClientTLSState struct {
	GameName           string
	ServerChallenge    string
	ClientTLSChallenge string
	ClientTLSResponse  string
	BattlelogID        int
	Username           string
	PlyName            string
	PlyEmail           string
	PlyCountry         string
	PlyPid             int
	Sessionkey         int
	Confirmed          bool
	Banned             bool
	IpAddress          net.Addr
	HasLogin           bool
	ProfileSent        bool
	LoggedOut          bool
	HeartTimer        *time.Timer
}

type CommandFESL struct {
	Msg       map[string]string
	Query     string
	PayloadID uint32
}

// ClientTLSEvent is the generic struct for events
// by this ClientTLS
type ClientTLSEvent struct {
	Name string
	Data interface{}
}

// New creates a new ClientTLS and starts up the handling of the connection
// is this good ? looks like bad traffic
func (clientTLS *ClientTLS) New(name string, conn *tls.Conn) (chan ClientTLSEvent, error) {
	clientTLS.name = name
	clientTLS.conn = conn
	clientTLS.IpAddr = (*clientTLS.conn).RemoteAddr()
	clientTLS.eventChan = make(chan ClientTLSEvent, 1000)
	clientTLS.IsActive = true

	go clientTLS.handleRequest()

	return clientTLS.eventChan, nil
}

func (clientTLS *ClientTLS) Answer(msgType string, msg map[string]string, msgType2 uint32) error {

	if !clientTLS.IsActive {
		log.Notef("%s: Trying write inactive ClientTLS.\n%v", clientTLS.name, msg)
		return errors.New("ClientTLS Inactive")
	}
	var lena int32
	var buf bytes.Buffer

	payloadEncoded := SerializeFESL(msg)
	baselen := len(payloadEncoded)
	lena = int32(baselen + 12)

	buf.Write([]byte(msgType))

	err := binary.Write(&buf, binary.BigEndian, &msgType2)
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}

	err = binary.Write(&buf, binary.BigEndian, &lena)
	if err != nil {
		fmt.Println("binary.Write failed:", err)
	}

	buf.Write([]byte(payloadEncoded))

	log.Println("Write: ", msg, msgType, msgType2)

	n, err := (*clientTLS.conn).Write(buf.Bytes())
	if err != nil {
		fmt.Println("Writing failed:", n, err)
	}
	return nil
}

func (clientTLS *ClientTLS) readFESL(data []byte) []byte {
	p := bytes.NewBuffer(data)
	i := 0
	log.Println(hex.EncodeToString(data))
	var payloadRaw []byte
	for {
		// Create a copy at this point in case we have to abort later
		// And send back the packet to get the rest
		curData := p
		outCommand := new(CommandFESL)

		var payloadID uint32
		var payloadLen uint32

		payloadTypeRaw := make([]byte, 4)
		_, err := p.Read(payloadTypeRaw)
		if err != nil {
			return nil
		}

		payloadType := string(payloadTypeRaw)

		binary.Read(p, binary.BigEndian, &payloadID)

		if p.Len() < 4 {
			log.Noteln("Strange anomaly")
			return nil
		}

		binary.Read(p, binary.BigEndian, &payloadLen)

		//log.Noteln("Message: " + payloadType + " - " + fmt.Sprint(payloadID) + " - " + fmt.Sprint(payloadLen))

		if (payloadLen - 12) > uint32(len(p.Bytes())) {
			log.Noteln("Packet not fully read")
			return curData.Bytes()
		}

		payloadRaw = make([]byte, (payloadLen - 12))
		p.Read(payloadRaw)

		payload := ProcessFESL(string(payloadRaw))

		outCommand.Query = payloadType
		outCommand.PayloadID = payloadID
		outCommand.Msg = payload

		clientTLS.eventChan <- ClientTLSEvent{
			Name: "command." + payload["TXN"],
			Data: outCommand,
		}
		clientTLS.eventChan <- ClientTLSEvent{
			Name: "command",
			Data: outCommand,
		}

		i++
	}

	return nil
}

func (clientTLS *ClientTLS) Close() {
	log.Notef("%s: ClientTLS closing connection.", clientTLS.name)
	clientTLS.eventChan <- ClientTLSEvent{
		Name: "close",
		Data: clientTLS,
	}
	clientTLS.IsActive = false
}

func (clientTLS *ClientTLS) handleRequest() {
	clientTLS.IsActive = true
	buf := make([]byte, 8096) // buffer
	tempBuf := []byte{}

	for clientTLS.IsActive {
		n, err := (*clientTLS.conn).Read(buf)
		if err != nil {
			if err != io.EOF {
				log.Debugf("%s: Reading from ClientTLS threw error %v", clientTLS.name, err)
				clientTLS.eventChan <- ClientTLSEvent{
					Name: "error",
					Data: err,
				}
				clientTLS.eventChan <- ClientTLSEvent{
					Name: "close",
					Data: clientTLS,
				}
				return
			}
			// If we receive an EndOfFile, close this function/goroutine
			log.Notef("%s: ClientTLS closing connection", clientTLS.name)
			clientTLS.eventChan <- ClientTLSEvent{
				Name: "close",
				Data: clientTLS,
			}
			return

		}
		if tempBuf != nil {
			tempBuf = append(tempBuf, buf[:n]...)
			tempBuf = clientTLS.readFESL(buf[:n])
		} else {
			tempBuf = clientTLS.readFESL(buf[:n])
		}
		buf = make([]byte, 8096) // new fresh buffer
	}

}
