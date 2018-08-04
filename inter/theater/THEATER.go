package theater

import (
	"database/sql"
	"time"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/MM"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"
	"github.com/go-redis/redis"
)

// GameClient Represents a game client connected to theater
type GameClient struct {
	ip   string
	port string
}

// GameServer Represents a game server and it's data
type GameServer struct {
	ip                 string
	port               string
	intIP              string
	intPort            string
	name               string
	level              string
	activePlayers      int
	maxPlayers         int
	queueLength        int
	joiningPlayers     int
	gameMode           string
	elo                float64
	numObservers       int
	maxObservers       int
	sguid              string
	hash               string
	password           string
	ugid               string
	sType              string
	join               string
	version            string
	dataCenter         string
	serverMap          string
	armyBalance        string
	armyDistribution   string
	availSlotsNational bool
	availSlotsRoyal    bool
	avgAllyRank        float64
	avgAxisRank        float64
	serverState        string
	communityName      string
}

// TheaterManager Handles incoming and outgoing theater communication
type TheaterManager struct {
	name             string
	socket           *gs.Socket
	socketUDP        *gs.SocketUDP
	db               *sql.DB
	redis            *redis.Client
	eventsChannel    chan gs.SocketEvent
	eventsChannelUDP chan gs.SocketUDPEvent
	batchTimer      *time.Timer
	stopTimer       chan bool
	cacheCounters    *lib.RedisObject

	// Database Statements
	stmtGetHeroeByID                      *sql.Stmt
	stmtDeleteServerStatsByGID            *sql.Stmt
	stmtDeleteGameByGIDAndShard           *sql.Stmt
	stmtAddGame                           *sql.Stmt
	stmtGameIncreaseJoining               *sql.Stmt
	stmtGameIncreaseTeam1                 *sql.Stmt
	stmtGameIncreaseTeam2                 *sql.Stmt
	stmtGameDecreaseTeam1                 *sql.Stmt
	stmtGameDecreaseTeam2                 *sql.Stmt
	stmtUpdateGame                        *sql.Stmt
	mapGetStatsVariableAmount             map[int]*sql.Stmt
	mapSetServerStatsVariableAmount       map[int]*sql.Stmt
	mapSetServerPlayerStatsVariableAmount map[int]*sql.Stmt
}


const COUNTER_GID_KEY = "counters:GID"

// New creates and starts a new TheaterManager
func (tM *TheaterManager) New(name string, port string, db *sql.DB, redis *redis.Client) {
	var err error
	tM.socket = new(gs.Socket)
	tM.socketUDP = new(gs.SocketUDP)
	tM.db = db
	tM.redis = redis
	tM.name = name
	tM.eventsChannel, err = tM.socket.New(tM.name, port, true)
	if err != nil {
		log.Errorln(err)
	}
	tM.eventsChannelUDP, err = tM.socketUDP.New(tM.name, port, true)
	if err != nil {
		log.Errorln(err)
	}
	tM.stopTimer = make(chan bool, 1)

	// Prepare database statements
	tM.mapGetStatsVariableAmount = make(map[int]*sql.Stmt)
	tM.mapSetServerStatsVariableAmount = make(map[int]*sql.Stmt)
	tM.mapSetServerPlayerStatsVariableAmount = make(map[int]*sql.Stmt)
	tM.prepareStatements()

	go tM.run()
}

func (tM *TheaterManager) prepareStatements() {
	var err error

	tM.stmtGetHeroeByID, err = tM.db.Prepare(
		"SELECT id, user_id, heroName, online" +
			"	FROM game_heroes" +
			"	WHERE id = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGetHeroeByID.", err.Error())
	}

	tM.stmtDeleteServerStatsByGID, err = tM.db.Prepare(
		"DELETE FROM game_server_stats WHERE gid = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtClearGameServerStats.", err.Error())
	}

	tM.stmtDeleteGameByGIDAndShard, err = tM.db.Prepare(
		"DELETE FROM games WHERE gid = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtClearGameServerStats.", err.Error())
	}

	tM.stmtAddGame, err = tM.db.Prepare(
		"INSERT INTO games (" +
			"	gid," +
			"	game_ip," +
			"	game_port," +
			"	game_version," +
			"	status_join," +
			"	status_mapname," +
			"	players_connected," +
			"	players_joining," +
			"	players_max," +
			"	team_1," +
			"	team_2," +
			"	team_distribution," +
			"	created_at," +
			"	updated_at)" +
			"VALUES" +
			"	(?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, NOW(), NOW())")
	if err != nil {
		log.Fatalln("Error preparing stmtAddGame.", err.Error())
	}

	tM.stmtGameIncreaseJoining, err = tM.db.Prepare(
		"UPDATE games SET " +
			"	players_joining = players_joining + 1," +
			"	updated_at = NOW()" +
			"WHERE gid = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGameIncreaseJoining.", err.Error())
	}

	tM.stmtGameIncreaseTeam1, err = tM.db.Prepare(
		"UPDATE games SET " +
			"	players_connected = players_connected + 1," +
			"	players_joining = players_joining - 1," +
			"	team_1 = team_1 + 1," +
			"	updated_at = NOW()" +
			"WHERE gid = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGameIncreaseTeam1.", err.Error())
	}

	tM.stmtGameIncreaseTeam2, err = tM.db.Prepare(
		"UPDATE games SET " +
			"	players_connected = players_connected + 1," +
			"	players_joining = players_joining - 1," +
			"	team_2 = team_2 + 1," +
			"	updated_at = NOW()" +
			"WHERE gid = ? ")
	if err != nil {
		log.Fatalln("Error preparing stmtGameIncreaseTeam2.", err.Error())
	}

	tM.stmtGameDecreaseTeam1, err = tM.db.Prepare(
		"UPDATE games SET " +
			"	players_connected = players_connected - 1," +
			"	team_1 = team_1 - 1," +
			"	updated_at = NOW()" +
			"WHERE gid = ? ")
	if err != nil {
		log.Fatalln("Error preparing stmtGameDecreaseTeam1.", err.Error())
	}

	tM.stmtGameDecreaseTeam2, err = tM.db.Prepare(
		"UPDATE games SET " +
			"	players_connected = players_connected - 1," +
			"	team_2 = team_2 - 1," +
			"	updated_at = NOW()" +
			"WHERE gid = ? ")
	if err != nil {
		log.Fatalln("Error preparing stmtGameDecreaseTeam2.", err.Error())
	}

	tM.stmtUpdateGame, err = tM.db.Prepare(
		"UPDATE games SET" +
			"	updated_at = NOW()" +
			"WHERE gid = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtUpdateGame.", err.Error())
	}
}

func (tM *TheaterManager) getStatsStatement(statsAmount int) *sql.Stmt {
	var err error

	// Check if we already have a statement prepared for that amount of stats
	if statement, ok := tM.mapGetStatsVariableAmount[statsAmount]; ok {
		return statement
	}

	var query string
	for i := 1; i < statsAmount; i++ {
		query += "?, "
	}

	sql := "SELECT game_heroes.user_id, game_heroes.id, game_heroes.heroName, game_stats.statsKey, game_stats.statsValue" +
		"	FROM game_heroes" +
		"	LEFT JOIN game_stats" +
		"		ON game_stats.user_id = game_heroes.user_id" +
		"		AND game_stats.heroID = game_heroes.id" +
		"	WHERE game_heroes.id=?" +
		"		AND game_stats.statsKey IN (" + query + "?)"

	tM.mapGetStatsVariableAmount[statsAmount], err = tM.db.Prepare(sql)
	if err != nil {
		log.Fatalln("Error preparing stmtGetStatsVariableAmount with "+sql+" query.", err.Error())
	}

	return tM.mapGetStatsVariableAmount[statsAmount]
}

func (tM *TheaterManager) setServerStatsStatement(statsAmount int) *sql.Stmt {
	var err error

	// Check if we already have a statement prepared for that amount of stats
	if statement, ok := tM.mapSetServerStatsVariableAmount[statsAmount]; ok {
		return statement
	}

	var query string
	for i := 1; i < statsAmount; i++ {
		query += "(?, ?, ?, NOW()), "
	}

	sql := "INSERT INTO game_server_stats" +
		"	(gid, statsKey, statsValue, created_at)" +
		"	VALUES " + query + "(?, ?, ?, NOW())" +
		"	ON DUPLICATE KEY UPDATE" +
		"	statsValue=VALUES(statsValue)," +
		"   updated_at=NOW()"

	tM.mapSetServerStatsVariableAmount[statsAmount], err = tM.db.Prepare(sql)
	if err != nil {
		log.Fatalln("Error preparing setServerStatsStatement with "+sql+" query.", err.Error())
	}

	return tM.mapSetServerStatsVariableAmount[statsAmount]
}

func (tM *TheaterManager) setServerPlayerStatsStatement(statsAmount int) *sql.Stmt {
	var err error

	// Check if we already have a statement prepared for that amount of stats
	if statement, ok := tM.mapSetServerPlayerStatsVariableAmount[statsAmount]; ok {
		return statement
	}

	var query string
	for i := 1; i < statsAmount; i++ {
		query += "(?, ?, ?, ?, NOW()), "
	}

	sql := "INSERT INTO game_server_player_stats" +
		"	(gid, pid, statsKey, statsValue, created_at)" +
		"	VALUES " + query + "(?, ?, ?, ?, NOW())" +
		"	ON DUPLICATE KEY UPDATE" +
		"	statsValue=VALUES(statsValue)," +
		"   updated_at=NOW()"

	tM.mapSetServerPlayerStatsVariableAmount[statsAmount], err = tM.db.Prepare(sql)
	if err != nil {
		log.Fatalln("Error preparing mapSetServerPlayerStatsVariableAmount with "+sql+" query.", err.Error())
	}

	return tM.mapSetServerPlayerStatsVariableAmount[statsAmount]
}

func (tM *TheaterManager) closeStatements() {
	// Close the dynamic lenght getStats statements
	for index := range tM.mapGetStatsVariableAmount {
		tM.mapGetStatsVariableAmount[index].Close()
	}
}

func (tM *TheaterManager) run() {
	for {
		select {
		case event := <-tM.eventsChannelUDP:
			switch {
			case event.Name == "command.ECHO":
				go tM.ECHO(event)
			case event.Name == "command":
				log.Debugf("UDP Got event %s: %v", event.Name, event.Data.(*gs.CommandFESL))
			default:
				log.Debugf("UDP Got event %s: %v", event.Name, event.Data)
			}
		case event := <-tM.eventsChannel:
			switch {
			case event.Name == "newClient":
				go tM.newClient(event.Data.(gs.EventNewClient))
			case event.Name == "client.command.CONN":
				go tM.CONN(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.USER":
				go tM.USER(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.LLST":
				go tM.LLST(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.GDAT":
				go tM.GDAT(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.EGAM":
				go tM.EGAM(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.ECNL":
				go tM.ECNL(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.CGAM":
				go tM.CGAM(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.UBRA":
				go tM.UBRA(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.UGAM":
				go tM.UGAM(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.EGRS":
				go tM.EGRS(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.GLST":
				go tM.GLST(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.PENT":
				go tM.PENT(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.PLVT":
				go tM.PLVT(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.command.UPLA":
				go tM.UPLA(event.Data.(gs.EventClientFESLCommand))
			case event.Name == "client.close":
				tM.close(event.Data.(gs.EventClientClose))
			case event.Name == "client.command":
				log.Debugf(" %s: %v", event.Name, event.Data.(gs.EventClientFESLCommand).Process)
			default:
				log.Debugf("Event %s: %v", event.Name, event.Data)
			}
		}
	}

	// Close all database statements
	tM.closeStatements()
}

func (tM *TheaterManager) newClient(event gs.EventNewClient) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}
	log.Noteln("Client connecting")

	// Start Heartbeat
	event.Client.State.HeartTimer = time.NewTimer(time.Second * 10)
	go func() {
		for {
			if !event.Client.IsActive {
				return
			}
			select {
			case <-event.Client.State.HeartTimer.C:
				if !event.Client.IsActive {
					return
				}
				pingPacket := make(map[string]string)
				pingPacket["TID"] = "0"
				event.Client.Answer("PING", pingPacket, 0x0)
			}
		}
	}()
}

func (tM *TheaterManager) close(event gs.EventClientClose) {
	log.Noteln("Client closed.")

	if event.Client.RedisState != nil {

		if event.Client.RedisState.Get("gdata:GID") != "" {

			// Delete game from db
			_, err := tM.stmtDeleteServerStatsByGID.Exec(event.Client.RedisState.Get("gdata:GID"))
			if err != nil {
				log.Errorln("Failed deleting settings for  "+event.Client.RedisState.Get("gdata:GID"), err.Error())
			}

			_, err = tM.stmtDeleteGameByGIDAndShard.Exec(event.Client.RedisState.Get("gdata:GID"))
			if err != nil {
				log.Errorln("Failed deleting game for "+event.Client.RedisState.Get("gdata:GID"), err.Error())
			}

			// Delete game out of MM array
			delete(MM.Games, event.Client.RedisState.Get("gdata:GID"))

			gameServer := new(lib.RedisObject)
			gameServer.New(tM.redis, "gdata", event.Client.RedisState.Get("gdata:GID"))
			gameServer.Delete()
		}

		event.Client.RedisState.Delete()
	}

	if !event.Client.State.HasLogin {
		return
	}

}

func (tM *TheaterManager) error(event gs.EventClientTLSError) {
	log.Noteln("Client threw an error: ", event.Error)
}
