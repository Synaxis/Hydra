package theater

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// EGRS - SERVER sent up, tell us if client is 'allowed' to join
func (tM *TheaterManager) EGRS(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		return
	}

	if event.Process.Msg["ALLOWED"] == "1" {
		_, err := tM.stmtGameIncreaseJoining.Exec(event.Process.Msg["GID"], )
		if err != nil {
			log.Panicln(err)
		}
	}

	answer := make(map[string]string)
	answer["TID"] = event.Process.Msg["TID"]
	answer["LID"] = event.Process.Msg["PID"]
	answer["PID"] = event.Process.Msg["LID"]
	event.Client.Answer("EGRS", answer, 0x0)
}
