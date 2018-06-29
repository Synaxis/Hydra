package theater

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
)

// GDAT - CLIENT called to get data about the server
func (tM *TheaterManager) GDAT(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	gameID := event.Process.Msg["GID"]

	gameServer := new(lib.RedisObject)
	gameServer.New(tM.redis, "gdata", gameID)

	answer := make(map[string]string)

	answer["TID"] = event.Process.Msg["TID"]

	for _, dataKey := range gameServer.HKeys() {
		if len(dataKey) > 0 && dataKey[0] == '"' {
			dataKey = dataKey[1:]
		}
		if len(dataKey) > 0 && dataKey[len(dataKey)-1] == '"' {
			dataKey = dataKey[:len(dataKey)-1]
		}

		answer[dataKey] = gameServer.Get(dataKey)
	}

	event.Client.Answer("GDAT", answer, 0x0)

}
