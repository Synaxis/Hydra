package theater

import (
	"strconv"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
)

// UPLA - SERVER presumably "update player"? valid response reqiured
func (tM *TheaterManager) UPLA(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		return
	}

	var args []interface{}

	keys := 0

	pid := event.Process.Msg["PID"]
	gid := event.Process.Msg["GID"]

	for index, value := range event.Process.Msg {
		if index == "TID" || index == "PID" || index == "GID" {
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

		args = append(args, gid)
		args = append(args, pid)
		args = append(args, index)
		args = append(args, value)
	}

	var err error
	_, err = tM.setServerPlayerStatsStatement(keys).Exec(args...)
	if err != nil {
		log.Errorln("Failed Update stats player "+pid, err.Error())
	}

	gdata := new(lib.RedisObject)
	gdata.New(tM.redis, "gdata", event.Process.Msg["GID"])

	num, _ := strconv.Atoi(gdata.Get("AP"))

	num++

	gdata.Set("AP", strconv.Itoa(num))
}
