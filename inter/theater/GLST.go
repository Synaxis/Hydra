package theater

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// GLST - CLIENT called to get a list of game servers? Irrelevant for heroes.
func (tM *TheaterManager) GLST(event gs.EventClientFESLCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}
	log.Noteln("GLST was called")
}
