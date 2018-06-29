package fesl

import (
	"strconv"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// GetStats - Get basic stats about a soldier/owner (account holder)
func (fM *FeslManager) GetStats(event gs.EventClientTLSCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}
	//////////////////////////////////
	convInt := strconv.Itoa
	Process := event.Process.Msg
	owner := Process["owner"]
	userId := event.Client.RedisState.Get("uID")
	/////////////////////////////////////////

	if event.Client.RedisState.Get("clientType") == "server" {

		var id, userID, heroName, online string
		err := fM.stmtGetHeroeByID.QueryRow(owner).Scan(&id, &userID, &heroName, &online)
		if err != nil {
			log.Noteln("Persona not worthy!")
			return
		}

		userId = userID
		log.Noteln("Server requesting stats")
	}

	log.Noteln("GetStats", owner, userId)

	log.Noteln(Process["owner"])

	loginPacket := make(map[string]string)
	loginPacket["TXN"] = "GetStats"
	loginPacket["ownerId"] = owner
	loginPacket["ownerType"] = "1"

	// Generate our argument list for the statement -> heroID, userID, key1, key2, key3, ...
	var args []interface{}
	statsKeys := make(map[string]string)
	args = append(args, owner)
	args = append(args, userId)
	keys, _ := strconv.Atoi(Process["keys.[]"])
	for i := 0; i < keys; i++ {
		args = append(args, Process["keys."+convInt(i)+""])
		statsKeys[Process["keys."+convInt(i)+""]] = convInt(i)
	}

	rows, err := fM.getStatsStatement(keys).Query(args...)
	if err != nil {
		log.Errorln("Failed gettings stats for hero "+owner, err.Error())
	}

	count := 0
	for rows.Next() {
		var userID, heroID, statsKey, statsValue string
		err := rows.Scan(&userID, &heroID, &statsKey, &statsValue)
		if err != nil {
			log.Errorln("Issue with database:", err.Error())
		}

		loginPacket["stats."+convInt(count)+".key"] = statsKey
		loginPacket["stats."+convInt(count)+".value"] = statsValue
		loginPacket["stats."+convInt(count)+".text"] = statsValue

		delete(statsKeys, statsKey)
		count++
	}

	// Send stats not found with default value of ""
	for key := range statsKeys {
		loginPacket["stats."+convInt(count)+".key"] = key
		loginPacket["stats."+convInt(count)+".value"] = ""
		loginPacket["stats."+convInt(count)+".text"] = ""

		count++
	}
	loginPacket["stats.[]"] = convInt(count)

	event.Client.Answer(event.Process.Query, loginPacket, event.Process.PayloadID)
}
