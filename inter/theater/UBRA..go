package theater

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
)

// UBRA - SERVER Called to  update server data
func (tM *TheaterManager) UBRA(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	//  need to udpate redis
	answer := make(map[string]string)
	answer["TID"] = event.Process.Msg["TID"]
	event.Client.Answer(event.Process.Query, answer, 0x0)

	gdata := new(lib.RedisObject)
	gdata.New(tM.redis, "gdata", event.Process.Msg["GID"])

	if event.Process.Msg["START"] == "1" {
		gdata.Set("AP", "0")
	}

}
