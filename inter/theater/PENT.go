package theater

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// PENT - Tell if player is Valid/ with valid stats
func (tM *TheaterManager) PENT(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		return
	}

	pid := event.Process.Msg["PID"]

	// Get 4 stats for PID
	rows, err := tM.getStatsStatement(4).Query(pid, "c_kit", "c_team", "elo", "level")
	if err != nil {
		log.Errorln("Failed gettings stats for hero "+pid, err.Error())
	}

	stats := make(map[string]string)

	for rows.Next() {
		var userID, heroID, heroName, statsKey, statsValue string
		err := rows.Scan(&userID, &heroID, &heroName, &statsKey, &statsValue)
		if err != nil {
			log.Errorln("Issue with database:", err.Error())
		}
		stats[statsKey] = statsValue
	}

	switch stats["c_team"] {
	case "1":
		_, err = tM.stmtGameIncreaseTeam1.Exec(event.Process.Msg["GID"], Shard)
		if err != nil {
			log.Panicln(err)
		}
	case "2":
		_, err = tM.stmtGameIncreaseTeam2.Exec(event.Process.Msg["GID"], Shard)
		if err != nil {
			log.Panicln(err)
		}
	default:
		log.Errorln("Invalid team " + stats["c_team"] + " for " + pid)
	}

	answer := make(map[string]string)
	answer["TID"] = event.Process.Msg["TID"]
	answer["PID"] = event.Process.Msg["PID"]
	event.Client.Answer("PENT", answer, 0x0)
}
