package theater

import (
	"strconv"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// ECHO - Broadcast The Server to NAT Interface
func (tM *TheaterManager) ECHO(event gs.SocketUDPEvent) {
	command := event.Data.(*gs.CommandFESL)

	answer := make(map[string]string)
	answer["TID"] = command.Msg["TID"]
	answer[TXN] = command.Msg[TXN]
	answer["IP"] = event.Addr.IP.String()
	answer["PORT"] = strconv.Itoa(event.Addr.Port)
	answer["ERR"] = "0"
	answer["UID"] = command.Msg["UID"]
	answer["TYPE"] = "1"
	err := tM.socketUDP.Answer("ECHO", answer, 0x0, event.Addr)
	if err != nil {
		log.Errorln(err)
	}
}
