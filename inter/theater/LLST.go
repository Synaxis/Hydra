package theater

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// LLST - CLIENT (???) unknown, potentially bookmarks
func (tM *TheaterManager) LLST(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	answer := make(map[string]string)
	answer["TID"] = event.Process.Msg["TID"]
	answer["NUM-LOBBIES"] = "1"
	event.Client.Answer(event.Process.Query, answer, 0x0)

	// Todo: create dataset for lobbies, iterate through and send one for each lobby (LDAT>)()
	ldatPacket := make(map[string]string)
	ldatPacket["TID"] = event.Process.Msg["TID"]
	ldatPacket["FAVORITE-GAMES"] = "0"
	ldatPacket["FAVORITE-PLAYERS"] = "0"
	ldatPacket["LID"] = "1"
	ldatPacket["LOCALE"] = "en_US"
	ldatPacket["MAX-GAMES"] = "10000"
	ldatPacket["NAME"] = "bfwestPC02"
	ldatPacket["NUM-GAMES"] = "1"
	ldatPacket["PASSING"] = "0"
	event.Client.Answer("LDAT", ldatPacket, 0x0)
}
