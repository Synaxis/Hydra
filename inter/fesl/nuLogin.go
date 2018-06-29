package fesl

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
)

// NuLogin - master login command
func (fM *FeslManager) NuLogin(event gs.EventClientTLSCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	/*  Pointers    */
	Process := event.Process.Msg

	/*   Pointers   */

	if event.Client.RedisState.Get("clientType") == "server" {
		// Server login
		fM.NuLoginServer(event)
		return
	}

	var id, username, email, birthday, language, country, gameToken string

	err := fM.stmtGetUserByGameToken.QueryRow(Process["encryptedInfo"]).Scan(&id, &username, &email, &birthday, &language, &country, &gameToken)
	if err != nil {
		log.Noteln("User not worthy!", err)
		loginPacket := make(map[string]string)
		loginPacket["TXN"] = "NuLogin"
		loginPacket["localizedMessage"] = "\"User not entitled!\""
		loginPacket["errorContainer.[]"] = "0"
		loginPacket["errorCode"] = "120"
		event.Client.Answer(event.Process.Query, loginPacket, event.Process.PayloadID)
		return
	}

	saveRedis := make(map[string]interface{})
	saveRedis["uID"] = id
	saveRedis["username"] = username
	saveRedis["sessionID"] = gameToken
	saveRedis["email"] = email
	saveRedis["keyHash"] = Process["encryptedInfo"]
	event.Client.RedisState.SetM(saveRedis)

	// Setup a new key for our persona
	lkey := gs.BF2RandomUnsafe(24)
	lkeyRedis := new(lib.RedisObject)
	lkeyRedis.New(fM.redis, "lkeys", lkey)
	lkeyRedis.Set("id", id)
	lkeyRedis.Set("userID", id)
	lkeyRedis.Set("name", username)

	loginPacket := make(map[string]string)
	loginPacket["TXN"] = "NuLogin"
	loginPacket["profileId"] = id
	loginPacket["userId"] = id
	loginPacket["nuid"] = username
	loginPacket["lkey"] = lkey
	event.Client.RedisState.Set("lkeys", event.Client.RedisState.Get("lkeys")+";"+lkey)
	event.Client.Answer(event.Process.Query, loginPacket, event.Process.PayloadID)
}

// NuLoginServer - login command for servers
func (fM *FeslManager) NuLoginServer(event gs.EventClientTLSCommand) {
	var id, userID, servername, secretKey, username string
	Process := event.Process.Msg

	err := fM.stmtGetServerBySecret.QueryRow(Process["password"]).Scan(&id, &userID, &servername, &secretKey, &username)
	if err != nil {
		loginPacket := make(map[string]string)
		loginPacket["TXN"] = "NuLogin"
		loginPacket["localizedMessage"] = "\"Wrong Password\""
		loginPacket["errorContainer.[]"] = "0"
		loginPacket["errorCode"] = "122"
		event.Client.Answer(event.Process.Query, loginPacket, event.Process.PayloadID)
		return
	}

	saveRedis := make(map[string]interface{})
	saveRedis["uID"] = userID
	saveRedis["sID"] = id
	saveRedis["username"] = username
	saveRedis["apikey"] = Process["encryptedInfo"]
	saveRedis["keyHash"] = Process["password"]
	event.Client.RedisState.SetM(saveRedis)

	// Setup a new key for our persona
	lkey := gs.BF2RandomUnsafe(24)
	lkeyRedis := new(lib.RedisObject)
	lkeyRedis.New(fM.redis, "lkeys", lkey)
	lkeyRedis.Set("id", id)
	lkeyRedis.Set("userID", userID)
	lkeyRedis.Set("name", username)

	loginPacket := make(map[string]string)
	loginPacket["TXN"] = "NuLogin"
	loginPacket["profileId"] = userID
	loginPacket["userId"] = userID
	loginPacket["nuid"] = username
	loginPacket["lkey"] = lkey

	event.Client.RedisState.Set("lkeys", event.Client.RedisState.Get("lkeys")+";"+lkey)
	event.Client.Answer(event.Process.Query, loginPacket, event.Process.PayloadID)
}
