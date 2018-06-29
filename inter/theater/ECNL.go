package theater

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// ECNL - CLIENT calls when they want to leave(and cancel queue)
func (tM *TheaterManager) ECNL(event gs.EventClientFESLCommand) {
	log.Noteln("Hero RQ")
	answer := make(map[string]string)
	answer["TID"] = event.Process.Msg["TID"]
	answer["GID"] = event.Process.Msg["GID"]
	answer["LID"] = event.Process.Msg["LID"]
	event.Client.Answer("ECNL", answer, 0x0)
}
