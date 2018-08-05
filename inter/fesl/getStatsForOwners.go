package fesl

import (
	"strconv"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// GetStatsForOwners - Get Stats for Each HERO
func (fM *FeslManager) GetStatsForOwners(event gs.EventClientTLSCommand) {
	if !event.Client.IsActive {
		return
	}
	///////////////////////////////
	convInt := strconv.Itoa
	Process := event.Process.Msg

	Packet := make(map[string]string)
	Packet[TXN] = "GetStats"
	//////////////////////////////

	// Get the owner pids from redis
	numOfHeroes := event.Client.RedisState.Get("numOfHeroes")
	userID := event.Client.RedisState.Get("uID")
	numOfHeroesInt, err := strconv.Atoi(numOfHeroes)
	if err != nil {
		return
	}

	i := 1
	for i = 1; i <= numOfHeroesInt; i++ {
		ownerID := event.Client.RedisState.Get("ownerId." + convInt(i))
		if event.Client.RedisState.Get("clientType") == "server" {

			var id, userIDhero, heroName, online string
			err := fM.stmtGetHeroeByID.QueryRow(ownerID).Scan(&id, &userIDhero, &heroName, &online)
			if err != nil {
				log.Noteln("Persona not worthy!")
				return
			}

			userID = userIDhero
			log.Noteln("Server Requesting Stats")
		}

		Packet["stats."+convInt(i-1)+".ownerId"] = ownerID
		Packet["stats."+convInt(i-1)+".ownerType"] = "1"

		// Generate our argument list for the statement -> heroID, key1, key2, key3, ...
		var args []interface{}
		statsKeys := make(map[string]string)
		args = append(args, ownerID)
		args = append(args, userID)
		keys, _ := strconv.Atoi(event.Process.Msg["keys.[]"])
		for i := 0; i < keys; i++ {
			args = append(args, Process["keys."+convInt(i)+""])
			statsKeys[Process["keys."+convInt(i)+""]] = convInt(i)
		}

		rows, err := fM.getStatsStatement(keys).Query(args...)
		if err != nil {
			log.Errorln("Failed gettings stats for hero "+ownerID, err.Error())
		}

		count := 0
		for rows.Next() {
			var userID, heroID, statsKey, statsValue string
			err := rows.Scan(&userID, &heroID, &statsKey, &statsValue)
			if err != nil {
				log.Errorln("Issue with database GetStatsForOwners:", err.Error())
			}

			Packet["stats."+convInt(i-1)+".stats."+convInt(count)+".key"] = statsKey
			Packet["stats."+convInt(i-1)+".stats."+convInt(count)+".value"] = statsValue
			Packet["stats."+convInt(i-1)+".stats."+convInt(count)+".text"] = statsValue

			delete(statsKeys, statsKey)
			count++
		}

		// Send stats not found with default value of ""
		for key := range statsKeys {
			Packet["stats."+convInt(i-1)+".stats."+convInt(count)+".key"] = key
			Packet["stats."+convInt(i-1)+".stats."+convInt(count)+".value"] = ""
			Packet["stats."+convInt(i-1)+".stats."+convInt(count)+".text"] = ""

			count++
		}
		Packet["stats."+convInt(i-1)+".stats.[]"] = convInt(count)
	}

	Packet["stats.[]"] = convInt(i - 1)

	event.Client.Answer(event.Process.Query, Packet, 0xC0000007)
}
