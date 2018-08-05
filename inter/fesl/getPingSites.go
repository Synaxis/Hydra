package fesl

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// GetPingSites - returns a list of endpoints to test for the lowest latency on a client
func (fM *FeslManager) GetPingSites(event gs.EventClientTLSCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}
	answer := make(map[string]string)
	answer[TXN] = "GetPingSites"
	answer["minPingSitesToPing"] = "0"
	answer["pingSites.[]"] = "0"
	event.Client.Answer(event.Process.Query, answer, event.Process.PayloadID)
}
