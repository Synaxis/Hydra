package theater

import (
	"github.com/Synaxis/Hydra/inter/gs"

	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
)

// UGAM - SERVER Called to udpate serverquery ifo
func (tM *TheaterManager) UGAM(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	gameID := event.Process.Msg["GID"]

	gdata := new(lib.RedisObject)
	gdata.New(tM.redis, "gdata", gameID)

	log.Noteln("Updating GameServer " + gameID)

	var args []interface{}

	keys := 0
	for index, value := range event.Process.Msg {
		if index == "TID" {
			continue
		}

		keys++

		// Strip quotes
		if len(value) > 0 && value[0] == '"' {
			value = value[1:]
		}
		if len(value) > 0 && value[len(value)-1] == '"' {
			value = value[:len(value)-1]
		}

		gdata.Set(index, value)
		args = append(args, gameID)
		args = append(args, index)
		args = append(args, value)
	}
	_, err := tM.stmtUpdateGame.Exec(event.Process.Msg["GID"])
	if err != nil {
		log.Panicln(err)
	}

	_, err = tM.setServerStatsStatement(keys).Exec(args...)
	if err != nil {
		log.Errorln("Failed to update stats for game server "+gameID, err.Error())
		if err.Error() == "Error 1213: Deadlock found when trying to get lock; try restarting transaction" {
			_, err = tM.setServerStatsStatement(keys).Exec(args...)
			if err != nil {
				log.Errorln("Failed to update stats for game server "+gameID+" on the second try", err.Error())
			}
		}
	}
}
