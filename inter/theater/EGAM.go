package theater

import (
	"net"
	"strconv"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/MM"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
)

// EGAM - CLIENT called when a client wants to join a gameserver
func (tM *TheaterManager) EGAM(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}
	externalIP := event.Client.IpAddr.(*net.TCPAddr).IP.String()
	lobbyID := event.Process.Msg["LID"]
	gameID := event.Process.Msg["GID"]
	pid := event.Client.RedisState.Get("id")

	clientAnswer := make(map[string]string)
	clientAnswer["TID"] = event.Process.Msg["TID"]
	clientAnswer["LID"] = lobbyID
	clientAnswer["GID"] = gameID
	event.Client.Answer("EGAM", clientAnswer, 0x0)

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

		stats["heroName"] = heroName
		stats["userID"] = userID
		stats[statsKey] = statsValue
	}

	if gameServer, ok := MM.Games[gameID]; ok {
		gsData := new(lib.RedisObject)
		gsData.New(tM.redis, "gdata", gameID)

		serverEGRQ := make(map[string]string)
		serverEGRQ["TID"] = "0"
		serverEGRQ["NAME"] = stats["heroName"]
		serverEGRQ["UID"] = stats["userID"]
		serverEGRQ["PID"] = pid
		serverEGRQ["TICKET"] = "2018751182"

		serverEGRQ["IP"] = externalIP
		serverEGRQ["PORT"] = strconv.Itoa(event.Client.IpAddr.(*net.TCPAddr).Port)

		serverEGRQ["INT-IP"] = event.Process.Msg["R-INT-IP"]
		serverEGRQ["INT-PORT"] = event.Process.Msg["R-INT-PORT"]
		serverEGRQ["PTYPE"] = "P"
		serverEGRQ["R-USER"] = stats["heroName"]
		serverEGRQ["R-UID"] = stats["userID"]
		serverEGRQ["R-U-accid"] = stats["userID"]
		serverEGRQ["R-U-elo"] = stats["elo"]
		serverEGRQ["R-U-team"] = stats["c_team"]
		serverEGRQ["R-U-kit"] = stats["c_kit"]
		serverEGRQ["R-U-lvl"] = stats["level"]
		serverEGRQ["R-U-dataCenter"] = "iad"
		serverEGRQ["R-U-externalIp"] = externalIP
		serverEGRQ["R-U-internalIp"] = event.Process.Msg["R-INT-IP"]
		serverEGRQ["R-U-category"] = event.Process.Msg["R-U-category"]
		serverEGRQ["R-INT-IP"] = event.Process.Msg["R-INT-IP"]
		serverEGRQ["R-INT-PORT"] = event.Process.Msg["R-INT-PORT"]
		serverEGRQ["XUID"] = "24"
		serverEGRQ["R-XUID"] = "24"
		serverEGRQ["LID"] = lobbyID
		serverEGRQ["GID"] = gameID

		gameServer.Answer("EGRQ", serverEGRQ, 0x0)

		//C L I E N T
		clientEGEG := make(map[string]string)
		clientEGEG["TID"] = "0"
		clientEGEG["PL"] = "pc"
		clientEGEG["TICKET"] = "2018751182"
		clientEGEG["PID"] = pid
		clientEGEG["I"] = gsData.Get("IP")
		clientEGEG["P"] = gsData.Get("PORT")
		clientEGEG["HUID"] = "1" // find via GID soon
		clientEGEG["EKEY"] = "O65zZ2D2A58mNrZw1hmuJw%3d%3d"
		clientEGEG["INT-IP"] = gsData.Get("INT-IP")
		clientEGEG["INT-PORT"] = gsData.Get("INT-PORT")
		clientEGEG["SECRET"] = "2587913"
		clientEGEG["UGID"] = gsData.Get("UGID")
		clientEGEG["LID"] = lobbyID
		clientEGEG["GID"] = gameID

		event.Client.Answer("EGEG", clientEGEG, 0x0)
	}

}
