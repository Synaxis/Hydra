package fesl

import (
	"strconv"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// NuLookupUserInfo - Gets basic information about a game user
func (fM *FeslManager) NuLookupUserInfo(event gs.EventClientTLSCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client Left")
		return
	}

	Process := event.Process.Msg
	Int := strconv.Itoa

	if event.Client.RedisState.Get("clientType") == "server" && Process["userInfo.0.userName"] == "Test-Server" {
		log.Noteln("===SERVER CONNECTED=== " + Process["userInfo.0.userName"])
		fM.NuLookupUserInfoServer(event)
		return
	}

	log.Noteln("===ClientConnected=== " + Process["userInfo.0.userName"])

	answer := make(map[string]string)

	keys, _ := strconv.Atoi(Process["userInfo.[]"])
	for i := 0; i < keys; i++ {
		heroNamePacket := Process["userInfo."+Int(i)+".userName"]

		var id, userID, heroName, online string
		err := fM.stmtGetHeroeByName.QueryRow(heroNamePacket).Scan(&id, &userID, &heroName, &online)
		if err != nil {
			return
		}
		answer[TXN] = "NuLookupUserInfo"
		answer["userInfo."+Int(i)+".userName"] = heroName
		answer["userInfo."+Int(i)+".userId"] = id
		answer["userInfo."+Int(i)+".masterUserId"] = id
		answer["userInfo."+Int(i)+".namespace"] = "MAIN"
		answer["userInfo."+Int(i)+".xuid"] = "24"
	}

	answer["userInfo.[]"] = Int(keys)

	event.Client.Answer(event.Process.Query, answer, event.Process.PayloadID)
}

// NuLookupUserInfoServer - Gets basic information about a game user
func (fM *FeslManager) NuLookupUserInfoServer(event gs.EventClientTLSCommand) {
	var err error

	var id, userID, servername, secretKey, username string
	err = fM.stmtGetServerByID.QueryRow(event.Client.RedisState.Get("sID")).Scan(&id, &userID, &servername, &secretKey, &username)
	if err != nil {
		log.Errorln(err)
		return
	}

	Int := strconv.Itoa
	personaPacket := make(map[string]string)
	personaPacket[TXN] = "NuLookupUserInfo"
	personaPacket["userInfo.0.userName"] = servername
	personaPacket["userInfo.0.userId"] = "1"
	personaPacket["userInfo.0.masterUserId"] = "1"
	personaPacket["userInfo.0.namespace"] = "MAIN"
	personaPacket["userInfo.0.xuid"] = "24"
	personaPacket["userInfo.0.cid"] = "1"
	personaPacket["userInfo.[]"] = Int(1)

	event.Client.Answer(event.Process.Query, personaPacket, event.Process.PayloadID)
}
