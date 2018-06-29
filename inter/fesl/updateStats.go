package fesl

import (
	"strconv"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

type stat struct {
	text  string
	value float64
}

// UpdateStats - updates stats about a soldier
func (fM *FeslManager) UpdateStats(event gs.EventClientTLSCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client Left")
		return
	}

	convert := strconv.Itoa
	Process := event.Process.Msg

	userId := event.Client.RedisState.Get("uID")

	users, _ := strconv.Atoi(Process["u.[]"])

	for i := 0; i < users; i++ {
		owner, ok := Process["u."+convert(i)+".o"]
		if event.Client.RedisState.Get("clientType") == "server" {
			if !ok {
				return
			}
			var id, userIDhero, heroName, online string
			err := fM.stmtGetHeroeByID.QueryRow(owner).Scan(&id, &userIDhero, &heroName, &online)
			if err != nil {
				log.Noteln("Credentials Error")
				return
			}
			if !ok {
				return
			}
			userId = userIDhero
			log.Noteln("==Server UpdatingStats==")
		}
		if !ok {
			return
		}

		stats := make(map[string]*stat)

		//Make args for statement -> heroID, userID, key1, key2, key3,
		var argsGet []interface{}
		statsKeys := make(map[string]string)
		argsGet = append(argsGet, owner)
		argsGet = append(argsGet, userId)
		keys, _ := strconv.Atoi(Process["u."+convert(i)+".s.[]"])
		for j := 0; j < keys; j++ {
			argsGet = append(argsGet, Process["u."+convert(i)+".s."+convert(j)+".k"])
			statsKeys[Process["u."+convert(i)+".s."+convert(j)+".k"]] = convert(j)
		}

		rows, err := fM.getStatsStatement(keys).Query(argsGet...)
		if err != nil {
			log.Errorln("Failed Stats Search "+owner, err.Error())
		}

		count := 0
		for rows.Next() {
			var userID, heroID, statsKey, statsValue string
			err := rows.Scan(&userID, &heroID, &statsKey, &statsValue)
			if err != nil {
				log.Errorln("Issue with database:", err.Error())
			}

			intValue, err := strconv.ParseFloat(statsValue, 64)
			if err != nil {
				intValue = 0
			}
			stats[statsKey] = &stat{
				text:  statsValue,
				value: intValue,
			}

			delete(statsKeys, statsKey)
			count++
		}

		// Send stats not found with default value of ""
		for key := range statsKeys {
			stats[key] = &stat{
				text:  "",
				value: 0,
			}

			count++
		}
		// end Get current stats from DB

		//Make  args list for Statement -> userId, owner, key1, value1, userId, owner, key2, value2, userId, owner
		var args []interface{}
		keys, _ = strconv.Atoi(Process["u."+convert(i)+".s.[]"])
		for j := 0; j < keys; j++ {
			if !event.Client.IsActive {
				log.Noteln("Client Left")
				return
			}

			if Process["u."+convert(i)+".s."+convert(j)+".ut"] != "3" {
				log.Noteln("Updating new Stats:",
					Process["u."+convert(i)+".s."+convert(j)+".k"],
					Process["u."+convert(i)+".s."+convert(j)+".t"],
					Process["u."+convert(i)+".s."+convert(j)+".ut"],
					Process["u."+convert(i)+".s."+convert(j)+".v"],
					Process["u."+convert(i)+".s."+convert(j)+".pt"])
			}

			key := Process["u."+convert(i)+".s."+convert(j)+".k"]
			value := Process["u."+convert(i)+".s."+convert(j)+".t"]

			if value == "" {
				log.Noteln("UpdateStats", key+":", Process["u."+convert(i)+".s."+convert(j)+".v"], "+", stats[key].value)
				// We are dealing with a number (convert)
				value = Process["u."+convert(i)+".s."+convert(j)+".v"]

				// ut = 3 when XP up . When level up = 0
				if Process["u."+convert(i)+".s."+convert(j)+".ut"] == "3" {
					intValue, err := strconv.ParseFloat(value, 64)

					if err != nil {
						// Skip if error
						log.Errorln("Skipping stat "+key, err)

						ans := make(map[string]string)
						ans["TXN"] = "UpdateStats"

						event.Client.Answer(event.Process.Query, ans, event.Process.PayloadID)
						return
					}

					if intValue <= 0 || event.Client.RedisState.Get("clientType") == "server" || key == "c_ltp" || key == "c_sln" || key == "c_ltm" || key == "c_slm" || key == "c_wmid0" || key == "c_wmid1" || key == "c_tut" || key == "c_wmid2" {
						// Only allow increasing numbers (like HeroPoints) by the server for now
						newValue := stats[key].value + intValue

						if key == "c_wallet_hero" && newValue < 0 {
							log.Errorln("Negative Value c_wallet_hero < 0", key)
							ans := make(map[string]string)
							ans["TXN"] = "UpdateStats"
							event.Client.Answer(event.Process.Query, ans, event.Process.PayloadID)
							return
						}

						value = strconv.FormatFloat(newValue, 'f', 4, 64)
					} else {
						value = Process["u."+convert(i)+".s."+convert(j)+".v"]
						log.Errorln("Not allowed to process Stat", key)
						ans := make(map[string]string)
						ans["TXN"] = "UpdateStats"
						event.Client.Answer(event.Process.Query, ans, event.Process.PayloadID)
						return
					}
				}
			}

			// We need to append 3 values for each insert/update,
			// owner, key and value
			log.Noteln("Updating stats:", userId, owner, key, value)
			args = append(args, userId)
			args = append(args, owner)
			args = append(args, key)
			args = append(args, value)
		}

		_, err = fM.setStatsStatement(keys).Exec(args...)
		if err != nil {
			log.Errorln("Failed setting Stats "+owner, err.Error())
		}
	}

	event.Client.Answer(event.Process.Query, Process, event.Process.PayloadID)
}
