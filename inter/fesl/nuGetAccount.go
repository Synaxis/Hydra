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

	loginPacket := make(map[string]string)
	loginPacket["TXN"] = "NuGetAccount"
	loginPacket["heroName"] = event.Client.RedisState.Get("username")
	loginPacket["nuid"] = event.Client.RedisState.Get("email")
	loginPacket["DOBDay"] = "1"
	loginPacket["DOBMonth"] = "1"
	loginPacket["DOBYear"] = "1992"
	loginPacket["userId"] = event.Client.RedisState.Get("uID")
	loginPacket["globalOptin"] = "1"
	loginPacket["thidPartyOptin"] = "0"
	loginPacket["language"] = "enUS"
	loginPacket["country"] = "US"
	event.Client.Answer(event.Process.Query, loginPacket, event.Process.PayloadID)
}
