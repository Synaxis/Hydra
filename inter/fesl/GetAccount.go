package fesl

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// NuGetAccount - General account information retrieved, based on parameters sent
func (fM *FeslManager) NuGetAccount(event gs.EventClientTLSCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	login := make(map[string]string)
	redis := event.Client.RedisState

	login[TXN] = "NuGetAccount"
	login["language"] = "en_US"
	login["country"] = 	"US"
	login["DOBDay"] = 	"1"
	login["DOBMonth"] = "1"
	login["DOBYear"] = "1992"
	login["heroName"] = redis.Get("username")
	login["nuid"] = redis.Get("email")
	login["userId"] = redis.Get("uID")
	login["globalOptin"] = "1"
	login["thirdPartyOptin"] = "0"

	event.Client.Answer(event.Process.Query, login, event.Process.PayloadID)
}
