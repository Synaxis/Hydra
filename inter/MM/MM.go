package MM

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"
)

// Games - a list of gameServers
var Games = make(map[string]*gs.Client)

var Shard string

// FindAvailableGID - returns a GID suitable for the player to join (ADD A PID HERE)
func findGids() string {
	var gameID string

	for k := range Games {
		gameID = k
		log.Println("==Joined Server==:" + k)
	}

	return gameID
}
