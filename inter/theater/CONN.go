package theater

import (
	"strconv"
	"time"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// CONN - SHARED (???) called on connection
func (tM *TheaterManager) CONN(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	answer := make(map[string]string)
	answer["TID"] = event.Process.Msg["TID"]
	answer["TIME"] = strconv.FormatInt(time.Now().UTC().Unix(), 10)
	answer["activityTimeoutSecs"] = "3600"
	answer["PROT"] = event.Process.Msg["PROT"]
	event.Client.Answer(event.Process.Query, answer, 0x0)
}
