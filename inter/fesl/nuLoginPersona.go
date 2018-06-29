package fesl

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
)

// NuLoginPersona - soldier login command
func (fM *FeslManager) NuLoginPersona(event gs.EventClientTLSCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	if event.Client.RedisState.Get("clientType") == "server" {
		// Server login
		fM.NuLoginPersonaServer(event)
		return
	}

	var id, userID, heroName, online string
	err := fM.stmtGetHeroeByName.QueryRow(event.Process.Msg["name"]).Scan(&id, &userID, &heroName, &online)
	if err != nil {
		log.Noteln("Wrong Credentials")
		return
	}

	// Setup a new key for our persona
	lkey := gs.BF2RandomUnsafe(24)
	lkeyRedis := new(lib.RedisObject)
	lkeyRedis.New(fM.redis, "lkeys", lkey)
	lkeyRedis.Set("id", id)
	lkeyRedis.Set("userID", userID)
	lkeyRedis.Set("name", heroName)

	saveRedis := make(map[string]interface{})
	saveRedis["heroID"] = id
	event.Client.RedisState.SetM(saveRedis)

	loginPacket := make(map[string]string)
	loginPacket["TXN"] = "NuLoginPersona"
	loginPacket["lkey"] = lkey
	loginPacket["profileId"] = userID
	loginPacket["userId"] = userID
	event.Client.RedisState.Set("lkeys", event.Client.RedisState.Get("lkeys")+";"+lkey)
	event.Client.Answer(event.Process.Query, loginPacket, event.Process.PayloadID)
}

// NuLoginPersonaServer - soldier login command
func (fM *FeslManager) NuLoginPersonaServer(event gs.EventClientTLSCommand) {
	var id, userID, servername, secretKey, username string
	err := fM.stmtGetServerByName.QueryRow(event.Process.Msg["name"]).Scan(&id, &userID, &servername, &secretKey, &username)
	if err != nil {
		log.Noteln("Wrong Server Credentials")
		return
	}

	// Setup a new key for our persona
	lkey := gs.BF2RandomUnsafe(24)
	lkeyRedis := new(lib.RedisObject)
	lkeyRedis.New(fM.redis, "lkeys", lkey)
	lkeyRedis.Set("id", userID)
	lkeyRedis.Set("userID", userID)
	lkeyRedis.Set("name", servername)

	loginPacket := make(map[string]string)
	loginPacket["TXN"] = "NuLoginPersona"
	loginPacket["lkey"] = lkey
	loginPacket["profileId"] = id
	loginPacket["userId"] = id
	event.Client.RedisState.Set("lkeys", event.Client.RedisState.Get("lkeys")+";"+lkey)
	event.Client.Answer(event.Process.Query, loginPacket, event.Process.PayloadID)
}
