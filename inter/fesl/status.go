package fesl

import (
	"strconv"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/MM"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
)

// Status - Status of the Search
func (fM *FeslManager) Status(event gs.EventClientTLSCommand) {
	log.Noteln("==STATUS==")

	answer := make(map[string]string)
	answer["TXN"] = "Status"
	answer["id.id"] = "1"
	answer["id.partition"] = event.Process.Msg[partition]
	answer["sessionState"] = "COMPLETE"
	answer["sessionType"] = "findServer"
	answer["props.{}.[]"] = "1"
	answer["props.{resultType}"] = "JOIN"

	i := 0
	for k := range MM.Games {
		gameID := k

		// Get % from databse
		var args []interface{}
		statsKeys := make(map[string]string)
		args = append(args, gameID)
		args = append(args, "B-U-percent_full")

		rows, err := fM.getServerStatsVariableAmount(1).Query(args...)
		if err != nil {
			log.Errorln("Fail with stats "+gameID, err.Error())
		}

		for rows.Next() {
			var gid, statsKey, statsValue string
			err := rows.Scan(&gid, &statsKey, &statsValue)
			if err != nil {
				log.Errorln("Fail with mm stats "+gameID, err.Error())
			}
			statsKeys[statsKey] = statsValue
		}

		if statsKeys["B-U-percent_full"] == "100" {
			// Don't join if full
			continue
		}

		gameServer := new(lib.RedisObject)
		gameServer.New(fM.redis, "gdata", gameID)

		answer["props.{games}."+strconv.Itoa(i)+".lid"] = "1"
		answer["props.{games}."+strconv.Itoa(i)+".fit"] = "1000"
		answer["props.{games}."+strconv.Itoa(i)+".gid"] = gameID

		log.Noteln(gameServer.Get("NAME") + " GID: " + gameID + " with fitness of: " + strconv.Itoa(len(MM.Games)-i))
		i++
	}

	answer["props.{games}.[]"] = strconv.Itoa(i)

	event.Client.Answer("pnow", answer, 0x80000000)
}
