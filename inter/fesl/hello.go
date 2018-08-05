package fesl

import (
	"github.com/Synaxis/Hydra/inter/gs"
	"github.com/Synaxis/Hydra/inter/log"

	"github.com/Synaxis/Hydra/inter/core"
)

func (fM *FeslManager) hello(event gs.EventClientTLSCommand) {
	if !event.Client.IsActive {
		log.Noteln("Client left")
		return
	}

	redisState := new(core.RedisState)
	redisState.New(fM.redis, event.Process.Msg["clientType"]+"-"+event.Client.IpAddr.String())

	event.Client.RedisState = redisState

	if !fM.server {
		getSession := make(map[string]string)
		getSession[TXN] = "GetSessionId"
		event.Client.Answer("gsum", getSession, 0)
	}

	saveRedis := make(map[string]interface{})
	saveRedis["SDKVersion"] = event.Process.Msg["SDKVersion"]
	saveRedis["clientPlatform"] = event.Process.Msg["clientPlatform"]
	saveRedis["clientString"] = event.Process.Msg["clientString"]
	saveRedis["clientType"] = event.Process.Msg["clientType"]
	saveRedis["clientVersion"] = event.Process.Msg["clientVersion"]
	saveRedis["locale"] = event.Process.Msg["locale"]
	saveRedis["sku"] = event.Process.Msg["sku"]
	event.Client.RedisState.SetM(saveRedis)

	helloPacket := make(map[string]string)
	helloPacket[TXN] = "Hello"
	helloPacket["domainPartition.domain"] = "eagames"
	if fM.server {
		helloPacket["domainPartition.subDomain"] = "bfwest-server"
	} else {
		helloPacket["domainPartition.subDomain"] = "bfwest-dedicated"
	}
	helloPacket["curTime"] = "Jan-12-2018 07:26:12 UTC"
	helloPacket["activityTimeoutSecs"] = "3600"
	helloPacket["messengerIp"] = "127.0.0.1"
	helloPacket["messengerPort"] = "13505"
	helloPacket["theaterIp"] = "127.0.0.1"
	if fM.server {
		helloPacket["theaterPort"] = "18056"
	} else {
		helloPacket["theaterPort"] = "18275"
	}
	event.Client.Answer("fsys", helloPacket, 0xC0000001)
}
