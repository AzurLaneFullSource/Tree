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
var0_0.CHAT_MSG_UPDATE = "IslandProxy:CHAT_MSG_UPDATE"

function var0_0.register(arg0_1)
	arg0_1.cahce = {}
	arg0_1.giftCache = {}
	arg0_1.chatMsgs = {}
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

function var0_0.AddChatMsg(arg0_3, arg1_3, arg2_3)
	if not arg0_3.chatMsgs[arg1_3] then
		arg0_3.chatMsgs[arg1_3] = {}
	end

	table.insert(arg0_3.chatMsgs[arg1_3], arg2_3)
	arg0_3:sendNotification(IslandProxy.CHAT_MSG_UPDATE, {
		islandId = arg1_3,
		msg = arg2_3
	})
end

function var0_0.GetChatMsgList(arg0_4, arg1_4)
	return arg0_4.chatMsgs[arg1_4] or {}
end

function var0_0.SetIsland(arg0_5, arg1_5)
	arg0_5.island = arg1_5
end

function var0_0.GetIsland(arg0_6)
	return arg0_6.island
end

function var0_0.remove(arg0_7)
	arg0_7.island = nil
end

function var0_0.ShouldTip(arg0_8)
	local function var0_8()
		local var0_9 = arg0_8:GetIsland()

		return var0_9 and var0_9:CanLevelUp()
	end

	local function var1_8()
		local var0_10 = arg0_8:GetIsland()

		return var0_10 and var0_10:AnyProsperityAwardCanGet()
	end

	return var0_8() or var1_8()
end

function var0_0.AddPlayerDataCache(arg0_11, arg1_11)
	arg0_11.cahce[arg1_11.id] = arg1_11
end

function var0_0.GetPlayerDataCache(arg0_12, arg1_12)
	return arg0_12.cahce[arg1_12]
end

function var0_0.ClearAllPlayerDataCache(arg0_13)
	arg0_13.cahce = {}
end

function var0_0.AddGiftTagInfoCache(arg0_14, arg1_14)
	arg0_14.giftCache[arg1_14.playerId] = arg1_14
end

function var0_0.GetGiftTagInfoCache(arg0_15, arg1_15)
	return arg0_15.giftCache[arg1_15]
end

function var0_0.UpdateGiftTagCache(arg0_16, arg1_16, arg2_16, arg3_16)
	local var0_16 = arg0_16:GetGiftTagInfoCache(arg1_16)

	if var0_16 then
		var0_16:Flush(arg2_16, arg3_16)
	else
		local var1_16 = IslandGiftTagInfo.New({
			key = arg1_16,
			value1 = arg3_16,
			value2 = arg2_16
		})

		arg0_16:AddGiftTagInfoCache(var1_16)
	end
end

function var0_0.ClearAllGiftTagInfo(arg0_17)
	arg0_17.giftCache = {}
end

function var0_0.SetSharedIsland(arg0_18, arg1_18)
	arg0_18.sharedIsland = arg1_18
end

function var0_0.GetSharedIsland(arg0_19)
	return arg0_19.sharedIsland
end

function var0_0.SetSyncObjInitData(arg0_20, arg1_20)
	arg0_20.syncObjInitData = arg1_20
end

function var0_0.GetSyncObjInitData(arg0_21)
	return arg0_21.syncObjInitData and arg0_21.syncObjInitData or {}
end

function var0_0.timeCall(arg0_22)
	return {
		[ProxyRegister.SecondCall] = function(arg0_23)
			if not arg0_22.island then
				return
			end

			arg0_22.island:UpdatePerSecond()

			if not arg0_22.sharedIsland then
				return
			end

			arg0_22.sharedIsland:UpdatePerSecond()
		end,
		[ProxyRegister.DayCall] = function(arg0_24)
			if not arg0_22.island then
				return
			end

			arg0_22.island:UpdatePerDay()
		end
	}
end

function var0_0.RecordEnterTime(arg0_25)
	arg0_25.enterTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetEnterTime(arg0_26)
	return arg0_26.enterTimeStamp
end

function var0_0.RecordTempPlayerPosition(arg0_27, arg1_27, arg2_27, arg3_27)
	arg0_27.tempPlayerPosition = {
		arg1_27,
		arg2_27,
		arg3_27
	}
end

function var0_0.GetTempPlayerPosition(arg0_28)
	return arg0_28.tempPlayerPosition
end

function var0_0.EnterIsland(arg0_29, arg1_29)
	arg0_29.islandHeartBeatMgr:EnterIsland(arg1_29)
end

function var0_0.ExitIsland(arg0_30)
	arg0_30.islandHeartBeatMgr:ExitIsland()
end

function var0_0.remove(arg0_31)
	arg0_31.islandHeartBeatMgr:Dispose()

	arg0_31.islandHeartBeatMgr = nil
end

return var0_0
