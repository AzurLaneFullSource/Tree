local var0_0 = class("IslandProxy", import("model.proxy.NetProxy"))

var0_0.STORY_START = "IslandProxy:STORY_START"
var0_0.STORY_END = "IslandProxy:STORY_END"
var0_0.PERFORMANCE_START = "IslandProxy:PERFORMANCE_START"
var0_0.PERFORMANCE_END = "IslandProxy:PERFORMANCE_END"
var0_0.START_PATHFINDER = "IslandProxy:START_PATHFINDER"
var0_0.END_PATHFINDER = "IslandProxy:END_PATHFINDER"
var0_0.ACTIVE_OR_DISABLE_UNIT = "IslandProxy:ACTIVE_OR_DISABLE_UNIT"
var0_0.LINK_CORE = "IslandProxy:LINK_CORE"
var0_0.GEN_RECYCLEITEM = "IslandProxy:GEN_RECYCLEITEM"
var0_0.LOCK_NPC_REFRESH = "IslandProxy:LOCK_NPC_REFRESH"
var0_0.RELEASE_NPC_REFRESH = "IslandProxy:RELEASE_NPC_REFRESH"
var0_0.RESET_SP = "IslandProxy:RESET_SP"
var0_0.CHAT_MSG_UPDATE = "IslandProxy:CHAT_MSG_UPDATE"

function var0_0.register(arg0_1)
	arg0_1.cahce = {}
	arg0_1.giftCache = {}
	arg0_1.chatMsgs = {}
	arg0_1.reconnectProcessing = false
	arg0_1.islandHeartBeatMgr = IslandHearBeatMgr.New()

	arg0_1:on(21216, function(arg0_2)
		local var0_2 = arg0_1:GetIsland()

		if not var0_2 then
			return
		end

		for iter0_2, iter1_2 in ipairs(arg0_2.visitor_list) do
			local var1_2 = IslandVisitorLog.New(iter1_2)

			if not var1_2:IsSelf() then
				var0_2:GetAccessAgency():AddVisitorLog(var1_2)
				pg.IslandVisitorNotificationMgr.GetInstance():Enqueue(var1_2)
			end
		end
	end)
end

function var0_0.SetReconnectProcessing(arg0_3, arg1_3)
	arg0_3.reconnectProcessing = arg1_3 and true or false

	warning("IslandProxy:SetReconnectProcessing", arg0_3.reconnectProcessing)
end

function var0_0.IsReconnectProcessing(arg0_4)
	return arg0_4.reconnectProcessing == true
end

function var0_0.AddChatMsg(arg0_5, arg1_5, arg2_5)
	if not arg0_5.chatMsgs[arg1_5] then
		arg0_5.chatMsgs[arg1_5] = {}
	end

	table.insert(arg0_5.chatMsgs[arg1_5], arg2_5)
	arg0_5:sendNotification(IslandProxy.CHAT_MSG_UPDATE, {
		islandId = arg1_5,
		msg = arg2_5
	})
end

function var0_0.GetChatMsgList(arg0_6, arg1_6)
	return arg0_6.chatMsgs[arg1_6] or {}
end

function var0_0.SetIsland(arg0_7, arg1_7)
	arg0_7.island = arg1_7
end

function var0_0.GetIsland(arg0_8)
	return arg0_8.island
end

function var0_0.remove(arg0_9)
	arg0_9.island = nil
end

function var0_0.ShouldTip(arg0_10)
	local function var0_10()
		local var0_11 = arg0_10:GetIsland()

		return var0_11 and var0_11:CanLevelUp()
	end

	local function var1_10()
		local var0_12 = arg0_10:GetIsland()

		return var0_12 and var0_12:AnyProsperityAwardCanGet()
	end

	return var0_10() or var1_10()
end

function var0_0.AddPlayerDataCache(arg0_13, arg1_13)
	arg0_13.cahce[arg1_13.id] = arg1_13
end

function var0_0.GetPlayerDataCache(arg0_14, arg1_14)
	return arg0_14.cahce[arg1_14]
end

function var0_0.ClearAllPlayerDataCache(arg0_15)
	arg0_15.cahce = {}
end

function var0_0.AddGiftTagInfoCache(arg0_16, arg1_16)
	arg0_16.giftCache[arg1_16.playerId] = arg1_16
end

function var0_0.GetGiftTagInfoCache(arg0_17, arg1_17)
	return arg0_17.giftCache[arg1_17]
end

function var0_0.UpdateGiftTagCache(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = arg0_18:GetGiftTagInfoCache(arg1_18)

	if var0_18 then
		var0_18:Flush(arg2_18, arg3_18)
	else
		local var1_18 = IslandGiftTagInfo.New({
			key = arg1_18,
			value1 = arg3_18,
			value2 = arg2_18
		})

		arg0_18:AddGiftTagInfoCache(var1_18)
	end
end

function var0_0.ClearAllGiftTagInfo(arg0_19)
	arg0_19.giftCache = {}
end

function var0_0.SetSharedIsland(arg0_20, arg1_20)
	arg0_20.sharedIsland = arg1_20
end

function var0_0.GetSharedIsland(arg0_21)
	return arg0_21.sharedIsland
end

function var0_0.SetSyncObjInitData(arg0_22, arg1_22)
	arg0_22.syncObjInitData = arg1_22
end

function var0_0.GetSyncObjInitData(arg0_23)
	return arg0_23.syncObjInitData and arg0_23.syncObjInitData or {}
end

function var0_0.timeCall(arg0_24)
	return {
		[ProxyRegister.SecondCall] = function(arg0_25)
			if not arg0_24.island then
				return
			end

			arg0_24.island:UpdatePerSecond()

			if not arg0_24.sharedIsland then
				return
			end

			arg0_24.sharedIsland:UpdatePerSecond()
		end,
		[ProxyRegister.HourCall] = function(arg0_26)
			if not arg0_24.island then
				return
			end

			arg0_24.island:UpdatePerHour(arg0_26)

			if not arg0_24.sharedIsland then
				return
			end

			arg0_24.sharedIsland:UpdatePerHour(arg0_26)
		end,
		[ProxyRegister.DayCall] = function(arg0_27)
			if not arg0_24.island then
				return
			end

			arg0_24.island:UpdatePerDay()
		end
	}
end

function var0_0.RecordEnterTime(arg0_28)
	arg0_28.enterTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetEnterTime(arg0_29)
	return arg0_29.enterTimeStamp
end

function var0_0.RecordTempPlayerPosition(arg0_30, arg1_30, arg2_30, arg3_30)
	arg0_30.tempPlayerPosition = {
		arg1_30,
		arg2_30,
		arg3_30
	}
end

function var0_0.GetTempPlayerPosition(arg0_31)
	return arg0_31.tempPlayerPosition
end

function var0_0.EnterIsland(arg0_32, arg1_32)
	arg0_32.islandHeartBeatMgr:EnterIsland(arg1_32)
end

function var0_0.ExitIsland(arg0_33)
	arg0_33.islandHeartBeatMgr:ExitIsland()
end

function var0_0.remove(arg0_34)
	arg0_34.islandHeartBeatMgr:Dispose()

	arg0_34.islandHeartBeatMgr = nil
end

return var0_0
