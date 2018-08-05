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

	answer[TXN] = "Start"
	answer["id.id"] = "1"
	answer["id.partition"] = event.Process.Msg[partition]
	answer["poolTimeout"] = "NO_POOL_TIMEOUT"
	answer["firewallType"] = "0"
	answer["PlaynowOptionsVersion"] = "1"
	answer["GameProtocolVersion"] = ""	
	answer["DebugThreshold"] = "low"
	answer["players.0.props.{debugHostAssignment}"] = "1"
	event.Client.Answer(event.Process.Query, answer, event.Process.PayloadID)

	fM.Status(event)
}
