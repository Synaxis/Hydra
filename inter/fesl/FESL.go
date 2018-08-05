package fesl

import (
	"database/sql"
	"strings"
	"time"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/lib"
	"github.com/Synaxis/Hydra/inter/log"

	"github.com/go-redis/redis"
)

const (
	TXN = "TXN"
)


// FeslManager - handles incoming and outgoing FESL data
type FeslManager struct {
	name          string
	db            *sql.DB
	redis         *redis.Client
	socket        *gs.SocketTLS
	eventsChannel chan gs.SocketEvent
	batchTimer    *time.Timer
	stopTimer     chan bool
	server        bool

	// Database Statements
	stmtGetBookmarks					*sql.Stmt
	stmtGetUserByGameToken              *sql.Stmt
	stmtGetServerBySecret               *sql.Stmt
	stmtGetServerByID                   *sql.Stmt
	stmtGetServerByName                 *sql.Stmt
	stmtGetCountOfPermissionByIDAndSlug *sql.Stmt
	stmtGetHeroesByUserID               *sql.Stmt
	stmtGetHeroeByName                  *sql.Stmt
	stmtGetHeroeByID                    *sql.Stmt
	stmtClearGameServerStats            *sql.Stmt
	mapGetStatsVariableAmount           map[int]*sql.Stmt
	mapGetServerStatsVariableAmount     map[int]*sql.Stmt
	mapSetStatsVariableAmount           map[int]*sql.Stmt
	mapSetServerStatsVariableAmount     map[int]*sql.Stmt
}


// New creates and starts a new ClientManager
func (fM *FeslManager) New(name string, port string, certFile string, keyFile string, server bool, db *sql.DB, redis *redis.Client) {
	var err error

	fM.socket = new(gs.SocketTLS)
	fM.db = db
	fM.redis = redis
	fM.name = name
	fM.eventsChannel, err = fM.socket.New(fM.name, port, certFile, keyFile)
	fM.stopTimer = make(chan bool, 1)
	fM.server = server
	fM.mapGetStatsVariableAmount = make(map[int]*sql.Stmt)
	fM.mapGetServerStatsVariableAmount = make(map[int]*sql.Stmt)
	fM.mapSetStatsVariableAmount = make(map[int]*sql.Stmt)

	// Prepare database statements
	fM.prepareStatements()
	if err != nil {
		log.Errorln(err)
	}

	_, err = fM.stmtClearGameServerStats.Exec()
	if err != nil {
		log.Panicln("Error Clearing GameServer", err)
	}

	go fM.run()
}

func (fM *FeslManager) getServerStatsVariableAmount(statsAmount int) *sql.Stmt {
	var err error

	// Check if we already have a statement prepared for that amount of stats
	if statement, ok := fM.mapGetServerStatsVariableAmount[statsAmount]; ok {
		return statement
	}

	var query string
	for i := 1; i < statsAmount; i++ {
		query += "?, "
	}

	sql := "SELECT gid, statsKey, statsValue" +
		"	FROM game_server_stats" +
		"	WHERE gid=?" +
		"		AND statsKey IN (" + query + "?)"

	fM.mapGetServerStatsVariableAmount[statsAmount], err = fM.db.Prepare(sql)
	if err != nil {
		log.Fatalln("Error preparing mapGetServerStatsVariableAmount with "+sql+" query.", err.Error())
	}

	return fM.mapGetServerStatsVariableAmount[statsAmount]
}

func (fM *FeslManager) getStatsStatement(statsAmount int) *sql.Stmt {
	var err error

	// Check if we already have a statement prepared for that amount of stats
	if statement, ok := fM.mapGetStatsVariableAmount[statsAmount]; ok {
		return statement
	}

	var query string
	for i := 1; i < statsAmount; i++ {
		query += "?, "
	}

	sql := "SELECT user_id, heroID, statsKey, statsValue" +
		"	FROM game_stats" +
		"	WHERE heroID=?" +
		"		AND user_id=?" +
		"		AND statsKey IN (" + query + "?)"

	fM.mapGetStatsVariableAmount[statsAmount], err = fM.db.Prepare(sql)
	if err != nil {
		log.Fatalln("stmtGetStatsVariableAmount Error with "+sql+" query.", err.Error())
	}

	return fM.mapGetStatsVariableAmount[statsAmount]
}

func (fM *FeslManager) setStatsStatement(statsAmount int) *sql.Stmt {
	var err error

	// Check if we already have a statement prepared for that amount of stats
	if statement, ok := fM.mapSetStatsVariableAmount[statsAmount]; ok {
		return statement
	}

	var query string
	for i := 1; i < statsAmount; i++ {
		query += "(?, ?, ?, ?), "
	}

	sql := "INSERT INTO game_stats" +
		"	(user_id, heroID, statsKey, statsValue)" +
		"	VALUES " + query + "(?, ?, ?, ?)" +
		"	ON DUPLICATE KEY UPDATE" +
		"	statsValue=VALUES(statsValue)"

	fM.mapSetStatsVariableAmount[statsAmount], err = fM.db.Prepare(sql)
	if err != nil {
		log.Fatalln("Error stmtSetStatsVariableAmount with "+sql+" query.", err.Error())
	}

	return fM.mapSetStatsVariableAmount[statsAmount]
}

func (fM *FeslManager) prepareStatements() {
	var err error

	fM.stmtGetUserByGameToken, err = fM.db.Prepare(
		"SELECT id, username, email, birthday, language, country, game_token" +
			"	FROM users" +
			"	WHERE game_token = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGetUserByGameToken.", err.Error())
	}

	fM.stmtGetServerBySecret, err = fM.db.Prepare(
		"SELECT game_servers.id, users.id, game_servers.servername, game_servers.secretKey, users.username" +
			"	FROM game_servers" +
			"	LEFT JOIN users" +
			"		ON users.id=game_servers.user_id" +
			"	WHERE secretKey = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGetServerBySecret.", err.Error())
	}
	

	fM.stmtGetBookmarks, err = fM.db.Prepare(
	 "SELECT gid" +
		"	FROM game_player_server_preferences" +
		"	WHERE userid=?")

		if err != nil {
			log.Fatalln("Error preparing stmtGetServerBySecret.", err.Error())
		}

	fM.stmtGetServerByID, err = fM.db.Prepare(
		"SELECT game_servers.id, users.id, game_servers.servername, game_servers.secretKey, users.username" +
			"	FROM game_servers" +
			"	LEFT JOIN users" +
			"		ON users.id=game_servers.user_id" +
			"	WHERE game_servers.id = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGetServerByID.", err.Error())
	}

	fM.stmtGetServerByName, err = fM.db.Prepare(
		"SELECT game_servers.id, users.id, game_servers.servername, game_servers.secretKey, users.username" +
			"	FROM game_servers" +
			"	LEFT JOIN users" +
			"		ON users.id=game_servers.user_id" +
			"	WHERE game_servers.servername = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGetServerByName.", err.Error())
	}

	fM.stmtGetCountOfPermissionByIDAndSlug, err = fM.db.Prepare(
		"SELECT count(permissions.slug)" +
			"	FROM users" +
			"	LEFT JOIN role_user" +
			"		ON users.id=role_user.user_id" +
			"	LEFT JOIN permission_role" +
			"		ON permission_role.role_id=role_user.role_id" +
			"	LEFT JOIN permissions" +
			"		ON permissions.id=permission_role.permission_id" +
			"	WHERE users.id = ?" +
			"		AND permissions.slug = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGetCountOfPermissionByIdAndSlug.", err.Error())
	}

	fM.stmtGetHeroesByUserID, err = fM.db.Prepare(
		"SELECT id, user_id, heroName, online" +
			"	FROM game_heroes" +
			"	WHERE user_id = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGetHeroesByUserID.", err.Error())
	}

	fM.stmtGetHeroeByName, err = fM.db.Prepare(
		"SELECT id, user_id, heroName, online" +
			"	FROM game_heroes" +
			"	WHERE heroName = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGetHeroesByUserID.", err.Error())
	}

	fM.stmtGetHeroeByID, err = fM.db.Prepare(
		"SELECT id, user_id, heroName, online" +
			"	FROM game_heroes" +
			"	WHERE id = ?")
	if err != nil {
		log.Fatalln("Error preparing stmtGetHeroeByID.", err.Error())
	}

	fM.stmtClearGameServerStats, err = fM.db.Prepare(
		"DELETE FROM game_server_stats")
	if err != nil {
		log.Fatalln("Error preparing stmtClearGameServerStats.", err.Error())
	}
}

func (fM *FeslManager) closeStatements() {
	fM.stmtGetUserByGameToken.Close()
	fM.stmtGetServerBySecret.Close()
	fM.stmtGetServerByID.Close()
	fM.stmtGetServerByName.Close()
	fM.stmtGetCountOfPermissionByIDAndSlug.Close()
	fM.stmtGetHeroesByUserID.Close()
	fM.stmtGetHeroeByName.Close()
	fM.stmtClearGameServerStats.Close()

	// Close the dynamic lenght getStats statements
	for index := range fM.mapGetStatsVariableAmount {
		fM.mapGetStatsVariableAmount[index].Close()
	}

	// Close the dynamic lenght setStats statements
	for index := range fM.mapSetStatsVariableAmount {
		fM.mapSetStatsVariableAmount[index].Close()
	}
}

func (fM *FeslManager) run() {
	for {
		select {
		case event := <-fM.eventsChannel:
			switch {
			case event.Name == "newClient":
				fM.newClient(event.Data.(gs.EventNewClientTLS))
			case event.Name == "client.command.Hello":
				fM.hello(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.command.NuLogin":
				fM.NuLogin(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.command.NuGetPersonas":
				fM.NuGetPersonas(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.command.NuGetAccount":
				fM.NuGetAccount(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.command.NuLoginPersona":
				fM.NuLoginPersona(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.command.GetStatsForOwners":
				fM.GetStatsForOwners(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.command.GetStats":
				fM.GetStats(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.command.NuLookupUserInfo":
				fM.NuLookupUserInfo(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.command.GetPingSites":
				fM.GetPingSites(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.command.UpdateStats":
				fM.UpdateStats(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.command.Start":
				fM.Start(event.Data.(gs.EventClientTLSCommand))
			case event.Name == "client.close":
				fM.close(event.Data.(gs.EventClientTLSClose))
			case event.Name == "client.command":
				log.Debugf("Event %s.%s: %v", event.Name, event.Data.(gs.EventClientTLSCommand).Process.Msg[TXN], event.Data.(gs.EventClientTLSCommand).Process)
			default:
				log.Debugf("Event %s: %v", event.Name, event.Data)
			}
		}
	}

	// Close all database statements
	fM.closeStatements()
}

// MysqlRealEscapeString - you know
func MysqlRealEscapeString(value string) string {
	replace := map[string]string{"\\": "\\\\", "'": `\'`, "\\0": "\\\\0", "\n": "\\n", "\r": "\\r", `"`: `\"`, "\x1a": "\\Z"}

	for b, a := range replace {
		value = strings.Replace(value, b, a, -1)
	}

	return value
}

func (fM *FeslManager) newClient(event gs.EventNewClientTLS) {
	if !event.Client.IsActive {
		log.Noteln("Client Left")
		return
	}

	memCheck := make(map[string]string)
	memCheck[TXN] = "MemCheck"
	memCheck["memcheck.[]"] = "0"
	memCheck["salt"] = "4"
	event.Client.Answer("fsys", memCheck, 0xC0000000)

	// Start Heartbeat
	event.Client.State.HeartTimer = time.NewTimer(time.Second * 4)
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
				memCheck := make(map[string]string)
				memCheck[TXN] = "MemCheck"
				memCheck["memcheck.[]"] = "0"
				memCheck["salt"] = "4"
				event.Client.Answer("fsys", memCheck, 0xC0000000)
			}
		}
	}()

	log.Noteln("Client Connect!")

}

func (fM *FeslManager) close(event gs.EventClientTLSClose) {
	log.Noteln("Client Closed.")

	if event.Client.RedisState != nil {
		if event.Client.RedisState.Get("lkeys") != "" {
			lkeys := strings.Split(event.Client.RedisState.Get("lkeys"), ";")
			for _, lkey := range lkeys {
				lkeyRedis := new(lib.RedisObject)
				lkeyRedis.New(fM.redis, "lkeys", lkey)
				lkeyRedis.Delete()
			}
		}

		event.Client.RedisState.Delete()
	}

	if !event.Client.State.HasLogin {
		return
	}

}

func (fM *FeslManager) error(event gs.EventClientTLSError) {
	log.Noteln("Client ERROR: ", event.Error)
}
