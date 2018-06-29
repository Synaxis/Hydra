package gs

import (
	"bufio"
	"bytes"
	"encoding/binary"
	"encoding/hex"
	"errors"
	"fmt"
	"net"
	"strings"
	"time"

	"github.com/Synaxis/Hydra/inter/core"
	"github.com/Synaxis/Hydra/inter/log"
	"github.com/sirupsen/logrus"
)

type Client struct {
	name       string
	conn       *net.Conn
	recvBuffer []byte
	eventChan  chan ClientEvent
	IsActive   bool
	reader     *bufio.Reader
	RedisState *core.RedisState
	IpAddr     net.Addr
	State      ClientState
	FESL       bool
}

type ClientState struct {
	GameName        string
	ServerChallenge string
	ClientChallenge string
	ClientResponse  string
	Username        string
	PlyName         string
	PlyEmail        string
	PlyCountry      string
	PlyPid          int
	Sessionkey      int
	Confirmed       bool
	IpAddress       net.Addr
	HasLogin        bool
	ProfileSent     bool
	LoggedOut       bool
	HeartTimer     *time.Timer
}

// ClientEvent is the generic struct for events
type ClientEvent struct {
	Name string
	Data interface{}
}

// New creates a new Client and starts up the handling of the connection
func (client *Client) New(name string, conn *net.Conn) (chan ClientEvent, error) {
	client.name = name
	client.conn = conn
	client.IpAddr = (*client.conn).RemoteAddr()
	client.eventChan = make(chan ClientEvent, 1000)
	client.reader = bufio.NewReader(*client.conn)
	client.IsActive = true

	go client.handleRequest()

	return client.eventChan, nil
}

func (client *Client) Write(command string) error {
	if !client.IsActive {
		log.Notef("%s: Trying to write to inactive client.\n%v", client.name, command)
		return errors.New("Client Inactive")
	}

	log.Println("Write:", command)

	(*client.conn).Write([]byte(command))
	return nil
}

func (client *Client) WriteError(code string, message string) error {
	err := client.Write("\\error\\\\err\\" + code + "\\fatal\\\\errmsg\\" + message + "\\id\\1\\final\\")
	return err
}

func (client *Client) processCommand(command string) {
	gsPacket, err := ProcessCommand(command)
	if err != nil {
		log.Errorf("%s: Error processing command %s.\n%v", client.name, command, err)
		client.eventChan <- ClientEvent{
			Name: "error",
			Data: err,
		}
		return
	}

	client.eventChan <- ClientEvent{
		Name: "command." + gsPacket.Query,
		Data: gsPacket,
	}
	client.eventChan <- ClientEvent{
		Name: "command",
		Data: gsPacket,
	}
}

func (client *Client) Close() {
	log.Notef("%s: Client closing connection.", client.name)
	client.eventChan <- ClientEvent{
		Name: "close",
		Data: client,
	}
	client.IsActive = false
}

//Answer is the answerPacket structure function
func (client *Client) Answer(msgType string, msg map[string]string, msgType2 uint32) error {

	if !client.IsActive {
		log.Notef("%s: AFK BUFFER.\n%v", client.name, msg)
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

	log.Println("Answer:", msg, msgType, msgType2)

	n, err := (*client.conn).Write(buf.Bytes())
	if err != nil {
		fmt.Println("Answer Err:", n, err)
	}
	return nil
}

func (client *Client) readFESL(data []byte) []byte {
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
			return nil
		}

		binary.Read(p, binary.BigEndian, &payloadLen)

		log.Noteln("Message: " + payloadType + " - " + fmt.Sprint(payloadID) + " - " + fmt.Sprint(payloadLen))

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

		client.eventChan <- ClientEvent{
			Name: "command." + payloadType,
			Data: outCommand,
		}
		client.eventChan <- ClientEvent{
			Name: "command",
			Data: outCommand,
		}

		i++
	}

	return nil
}

func (client *Client) handleRequest() {
	client.IsActive = true
	buf := make([]byte, 8096) // buffer
	tempBuf := []byte{}

	for client.IsActive {
		n, err := (*client.conn).Read(buf)
		if err != nil {
			return
		}

		if client.FESL {
			if tempBuf != nil {
				tempBuf = append(tempBuf, buf[:n]...)
				tempBuf = client.readFESL(buf[:n])
			} else {
				tempBuf = client.readFESL(buf[:n])
			}
			buf = make([]byte, 8096) // new fresh buffer
			continue
		}

		client.recvBuffer = append(client.recvBuffer, buf[:n]...)

		message := strings.TrimSpace(string(client.recvBuffer))

		logrus.Println("Got message:", hex.EncodeToString(client.recvBuffer))

		if strings.Index(message, `\final\`) == -1 {
			if len(client.recvBuffer) > 1024 {
				// We don't support more than 2048 long messages
				client.recvBuffer = make([]byte, 0)
			}
			continue
		}

		client.eventChan <- ClientEvent{Name: "data", Data: message}

		commands := strings.Split(message, `\final\`)
		for _, command := range commands {
			if len(command) == 0 {
				continue
			}

			client.processCommand(command)
		}

		// Add unprocessed commands back into recvBuffer
		client.recvBuffer = []byte(commands[(len(commands) - 1)])
	}
}
