package theater

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/core"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
)

// USER - SHARED Called to get user data about client? No idea
func (tM *TheaterManager) USER(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	lkeyRedis := new(lib.RedisObject)
	lkeyRedis.New(tM.redis, "lkeys", event.Process.Msg["LKEY"])

	redisState := new(core.RedisState)
	redisState.New(tM.redis, "MM:"+event.Process.Msg["LKEY"])
	event.Client.RedisState = redisState

	redisState.Set("id", lkeyRedis.Get("id"))
	redisState.Set("userID", lkeyRedis.Get("userID"))
	redisState.Set("name", lkeyRedis.Get("name"))

	answer := make(map[string]string)
	answer["TID"] = event.Process.Msg["TID"]
	answer["NAME"] = lkeyRedis.Get("name")
	answer["CID"] = lkeyRedis.Get("id")
	event.Client.Answer(event.Process.Query, answer, 0x0)
}
