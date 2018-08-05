package fesl

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)


// Status - Status of the Search
func (fM *FeslManager) Status(event gs.EventClientTLSCommand) {
	log.Noteln("==STATUS==")
	Process := event.Process.Msg
	answer := make(map[string]string)

	var gid string
	var err error

	userID := event.Client.RedisState.Get("uID")

	err = fM.stmtGetBookmarks.QueryRow(userID).Scan(&gid)
	if err != nil {
		log.Noteln("error with bookmark!", err)		
		return
	}

	
	answer[TXN] = "Status"
	answer["id.id"] = "1"
	answer["id.partition"] = Process[partition]
	answer["sessionState"] = "COMPLETE"
	answer["sessionType"] = "FindServer"
	answer["firewallType"] = "0"
	answer["props.{resultType}"] = "JOIN"
	
	//games
	gameID := gid
	answer["props.{games}.[]"] = "1"
	answer["props.{games}.0.lid"] = "1"
	answer["props.{games}.0.fit"] = "1001"
	answer["props.{games}.0.gid"] = gameID

	
	event.Client.Answer("pnow", answer, 0x80000000)

}
