package theater

import (
	"net"
	"strconv"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/MM"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
)

// CGAM  SERVER Create Game
func (tM *TheaterManager) CGAM(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	addr, ok := event.Client.IpAddr.(*net.TCPAddr)

	if !ok {
		log.Errorln("Failed with IpAddr to net.TCPAddr")
		return
	}

	gameIDInt, _ := tM.redis.Incr(COUNTER_GID_KEY).Result()
	gameID := strconv.Itoa(int(gameIDInt))

	// Store server access later
	MM.Games[gameID] = event.Client

	var args []interface{}

	// Setup key for game
	gameServer := new(lib.RedisObject)
	gameServer.New(tM.redis, "gdata", gameID)

	keys := 0

	// Stores what we know about this game in the redis db
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
		gameServer.Set(index, value)

		args = append(args, gameID)
		args = append(args, index)
		args = append(args, value)
	}

	gameServer.Set("LID", "1")
	gameServer.Set("GID", gameID)
	gameServer.Set("IP", addr.IP.String())
	gameServer.Set("AP", "0")
	gameServer.Set("QUEUE-LENGTH", "0")

	event.Client.RedisState.Set("gdata:GID", gameID)

	var err error
	_, err = tM.setServerStatsStatement(keys).Exec(args...)
	if err != nil {
		log.Errorln("Error stats game server "+gameID, err.Error())
	}

	answer := make(map[string]string)
	answer["TID"] = event.Process.Msg["TID"]
	answer["LID"] = "1"
	answer["UGID"] = event.Process.Msg["UGID"]
	answer["MAX-PLAYERS"] = event.Process.Msg["MAX-PLAYERS"]
	answer["EKEY"] = "O65zZ2D2A58mNrZw1hmuJw%3d%3d"
	answer["UGID"] = event.Process.Msg["UGID"]
	answer["SECRET"] = "2587913"
	answer["JOIN"] = event.Process.Msg["JOIN"]
	answer["J"] = event.Process.Msg["JOIN"]
	answer["GID"] = gameID
	event.Client.Answer("CGAM", answer, 0x0)

	// Create game in database
	_, err = tM.stmtAddGame.Exec(gameID, Shard, addr.IP.String(), event.Process.Msg["PORT"], event.Process.Msg["B-version"], event.Process.Msg["JOIN"], event.Process.Msg["B-U-map"], 0, 0, event.Process.Msg["MAX-PLAYERS"], 0, 0, "")
	if err != nil {
		log.Panicln(err)
	}
}
