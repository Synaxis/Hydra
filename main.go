package main

import (
	"flag"
	"fmt"
	"io/ioutil"
	"os"
	"os/signal"
	"runtime"

	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/core"
	"github.com/Synaxis/Hydra/inter/fesl"
	"github.com/Synaxis/Hydra/inter/log"
	"github.com/Synaxis/Hydra/inter/MM"
	"github.com/Synaxis/Hydra/inter/theater"
	"github.com/go-redis/redis"
	"github.com/gorilla/mux"

	"net/http"
	"net/http/pprof"
)

// Initialize flag-parameters and config
func init() {
	flag.StringVar(&configPath, "config", "config.yml", "Path to yml configuration file")
	flag.StringVar(&loglevel, "loglevel", "error", "LogLevel [error|warning|note|debug]")
	flag.StringVar(&certFileFlag, "cert", "./cert.pem", "[HTTPS] Location of your certification file. Env: LOUIS_HTTPS_CERT")
	flag.StringVar(&keyFileFlag, "key", "./key.pem", "[HTTPS] Location of your private key file. Env: LOUIS_HTTPS_KEY")

	flag.Parse()

	log.SetLevel(loglevel)
	MyConfig.Load(configPath)

	if CompileVersion != "0" {
		Version = Version + "." + CompileVersion
	}
}

var (
	configPath   string
	loglevel     string
	certFileFlag string
	keyFileFlag  string

	// CompileVersion we are receiving by the build command
	CompileVersion = "0"
	// Version of the Application
	Version = "1"

	// MyConfig Default configuration
	MyConfig = Config{
		MysqlServer: "localhost:3306",
		MysqlUser:   "loginserver",
		MysqlDb:     "loginserver",
		MysqlPw:     "",
	}

	mem runtime.MemStats

	AppName = "HeroesServer"

	Shard string
)

func emtpyHandler(w http.ResponseWriter, r *http.Request) {
	log.Noteln("EMTPTY", r.URL.Path)
	fmt.Fprintf(w, "<update><status>Online</status></update>")
}

func relationship(w http.ResponseWriter, r *http.Request) {
	log.Noteln("RELATIONSHIP", r.URL.Path)
	vars := mux.Vars(r)
	fmt.Fprintf(w, "<update><id>1</id><name>MargeSimpson</name><state>ACTIVE</state><type>server</type><status>Online</status><realid>"+vars["id"]+"</realid></update>")
}

func sessionHandler(w http.ResponseWriter, r *http.Request) {
	serverKey := r.Header.Get("X-SERVER-KEY")
	if serverKey != "" {
		log.Noteln("Server " + serverKey + " authenticating.")
		fmt.Fprintf(w, "<success><token>"+serverKey+"</token></success>")
	} else {
		userKey, err := r.Cookie("magma")
		if err != nil {
		}
		log.Noteln("<success><token code=\"NEW_TOKEN\">" + userKey.Value + "</token></success>")
		fmt.Fprintf(w, "<success><token code=\"NEW_TOKEN\">"+userKey.Value+"</token></success>")
	}
}

func entitlementsHandler(w http.ResponseWriter, r *http.Request) {
	log.Noteln("ENTITLEMENTS", r.URL.Path)

	vars := mux.Vars(r)
	fmt.Fprintf(w,
		"<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?>"+
			"<entitlements>"+
			"	<entitlement>"+
			"		<entitlementId>1</entitlementId>"+
			"		<entitlementTag>WEST_Custom_Item_142</entitlementTag>"+
			"		<status>ACTIVE</status>"+
			"		<userId>"+vars["heroID"]+"</userId>"+
			"	</entitlement>"+
			"	<entitlement>"+
			"		<entitlementId>1253</entitlementId>"+
			"		<entitlementTag>WEST_Custom_Item_142</entitlementTag>"+
			"		<status>ACTIVE</status>"+
			"		<userId>"+vars["heroID"]+"</userId>"+
			"	</entitlement>"+
			"</entitlements>")
}

func offersHandler(w http.ResponseWriter, r *http.Request) {

	contents, _ := ioutil.ReadFile("api/products.xml")
	str := string(contents)
	fmt.Fprintf(w, str)
}

func walletsHandler(w http.ResponseWriter, r *http.Request) {
	log.Noteln("WALLETS", r.URL.Path)
	fmt.Fprintf(w, "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\" ?><billingAccounts><walletAccount><currency>hp</currency><balance>1</balance></billingAccounts>")
}

func main() {
	log.Notef("Start v%s", Version)

	r := mux.NewRouter()

	// Register pprof handlers
	r.HandleFunc("/debug/pprof/", pprof.Index)
	r.HandleFunc("/debug/pprof/cmdline", pprof.Cmdline)
	r.HandleFunc("/debug/pprof/profile", pprof.Profile)
	r.HandleFunc("/debug/pprof/symbol", pprof.Symbol)
	r.HandleFunc("/debug/pprof/trace", pprof.Trace)

	r.HandleFunc("/nucleus/authToken", sessionHandler)
	r.HandleFunc("/relationships/roster/{type}:{id}", relationship)

	r.HandleFunc("/nucleus/entitlements/{heroID}", entitlementsHandler)
	r.HandleFunc("/nucleus/wallets/{heroID}", walletsHandler)
	r.HandleFunc("/ofb/products", offersHandler)

	r.HandleFunc("/", emtpyHandler)

	go func() {
		log.Noteln(http.ListenAndServe("0.0.0.0:8080", r))
	}()
	go func() {
		log.Noteln(http.ListenAndServeTLS("0.0.0.0:443", certFileFlag, keyFileFlag, r))
	}()

	// Startup done

	// DB Connection
	dbConnection := new(core.DB)
	dbSQL, err := dbConnection.New(MyConfig.MysqlServer, MyConfig.MysqlDb, MyConfig.MysqlUser, MyConfig.MysqlPw)
	if err != nil {
		log.Fatalln("Error connecting to DB:", err)
	}

	// Redis Connection
	redisClient := redis.NewClient(&redis.Options{
		Addr:     MyConfig.RedisServer,
		Password: MyConfig.RedisPassword,
		DB:       MyConfig.RedisDB,
	})

	_, err = redisClient.Ping().Result()
	if err != nil {
		log.Fatalln("Error connecting to Redis:", err)
	}

	Shard := gs.BF2RandomUnsafe(6)
	log.Noteln("Starting as: " + Shard)
	MM.Shard = Shard
	theater.Shard = Shard
	fesl.Shard = Shard

	feslManager := new(fesl.FeslManager)
	feslManager.New("Fesl", "18270", certFileFlag, keyFileFlag, false, dbSQL, redisClient)
	serverManager := new(fesl.FeslManager)
	serverManager.New("SvFesl", "18051", certFileFlag, keyFileFlag, true, dbSQL, redisClient)

	theaterManager := new(theater.TheaterManager)
	theaterManager.New("Theater", "18275", dbSQL, redisClient)
	servertheaterManager := new(theater.TheaterManager)
	servertheaterManager.New("SvTheater", "18056", dbSQL, redisClient)

	c := make(chan os.Signal, 1)
	signal.Notify(c, os.Interrupt)
	for sig := range c {
		log.Noteln("Captured" + sig.String() + ". Shutting down.")
		os.Exit(0)
	}
}
