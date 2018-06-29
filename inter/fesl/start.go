package fesl

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

const (
	partition = "partition.partition"
)

// Start - Handle PlayNow! - Start the Search
func (fM *FeslManager) Start(event gs.EventClientTLSCommand) {
	log.Noteln("==Start==")
	answer := make(map[string]string)
	answer["TXN"] = "Start"
	answer["id.id"] = "1"
	answer["id.partition"] = event.Process.Msg[partition]
	answer["poolTimeout"] = "60"
	answer["firewallType"] = "0"
	event.Client.Answer(event.Process.Query, answer, event.Process.PayloadID)

	fM.Status(event)
}
