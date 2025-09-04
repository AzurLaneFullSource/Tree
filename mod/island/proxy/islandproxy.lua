local var0_0 = class("IslandProxy", import("model.proxy.NetProxy"))

var0_0.STORY_START = "IslandProxy:STORY_START"
var0_0.STORY_END = "IslandProxy:STORY_END"
var0_0.PERFORMANCE_START = "IslandProxy:PERFORMANCE_START"
var0_0.PERFORMANCE_END = "IslandProxy:PERFORMANCE_END"
var0_0.START_PATHFINDER = "IslandProxy:START_PATHFINDER"
var0_0.END_PATHFINDER = "IslandProxy:END_PATHFINDER"
var0_0.ACTIVE_OR_DISABLE_UNIT = "IslandProxy:ACTIVE_OR_DISABLE_UNIT"
var0_0.LINK_CORE = "IslandProxy:LINK_CORE"

function var0_0.register(arg0_1)
	arg0_1.cahce = {}
	arg0_1.giftCache = {}
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

function var0_0.SetIsland(arg0_3, arg1_3)
	arg0_3.island = arg1_3
end

function var0_0.GetIsland(arg0_4)
	return arg0_4.island
end

function var0_0.remove(arg0_5)
	arg0_5.island = nil
end

function var0_0.ShouldTip(arg0_6)
	local function var0_6()
		local var0_7 = arg0_6:GetIsland()

		return var0_7 and var0_7:CanLevelUp()
	end

	local function var1_6()
		local var0_8 = arg0_6:GetIsland()

		return var0_8 and var0_8:AnyProsperityAwardCanGet()
	end

	return var0_6() or var1_6()
end

function var0_0.AddPlayerDataCache(arg0_9, arg1_9)
	arg0_9.cahce[arg1_9.id] = arg1_9
end

function var0_0.GetPlayerDataCache(arg0_10, arg1_10)
	return arg0_10.cahce[arg1_10]
end

function var0_0.ClearAllPlayerDataCache(arg0_11)
	arg0_11.cahce = {}
end

function var0_0.AddGiftTagInfoCache(arg0_12, arg1_12)
	arg0_12.giftCache[arg1_12.playerId] = arg1_12
end

function var0_0.GetGiftTagInfoCache(arg0_13, arg1_13)
	return arg0_13.giftCache[arg1_13]
end

function var0_0.UpdateGiftTagCache(arg0_14, arg1_14, arg2_14, arg3_14)
	local var0_14 = arg0_14:GetGiftTagInfoCache(arg1_14)

	if var0_14 then
		var0_14:Flush(arg2_14, arg3_14)
	else
		local var1_14 = IslandGiftTagInfo.New({
			key = arg1_14,
			value1 = arg3_14,
			value2 = arg2_14
		})

		arg0_14:AddGiftTagInfoCache(var1_14)
	end
end

function var0_0.ClearAllGiftTagInfo(arg0_15)
	arg0_15.giftCache = {}
end

function var0_0.SetSharedIsland(arg0_16, arg1_16)
	arg0_16.sharedIsland = arg1_16
end

function var0_0.GetSharedIsland(arg0_17)
	return arg0_17.sharedIsland
end

function var0_0.SetSyncObjInitData(arg0_18, arg1_18)
	arg0_18.syncObjInitData = arg1_18
end

function var0_0.GetSyncObjInitData(arg0_19)
	return arg0_19.syncObjInitData and arg0_19.syncObjInitData or {}
end

function var0_0.timeCall(arg0_20)
	return {
		[ProxyRegister.SecondCall] = function(arg0_21)
			if not arg0_20.island then
				return
			end

			arg0_20.island:UpdatePerSecond()

			if not arg0_20.sharedIsland then
				return
			end

			arg0_20.sharedIsland:UpdatePerSecond()
		end,
		[ProxyRegister.DayCall] = function(arg0_22)
			if not arg0_20.island then
				return
			end

			arg0_20.island:UpdatePerDay()
		end
	}
end

function var0_0.RecordEnterTime(arg0_23)
	arg0_23.enterTimeStamp = pg.TimeMgr.GetInstance():GetServerTime()
end

function var0_0.GetEnterTime(arg0_24)
	return arg0_24.enterTimeStamp
end

function var0_0.EnterIsland(arg0_25, arg1_25)
	arg0_25.islandHeartBeatMgr:EnterIsland(arg1_25)
end

function var0_0.ExitIsland(arg0_26)
	arg0_26.islandHeartBeatMgr:ExitIsland()
end

function var0_0.remove(arg0_27)
	arg0_27.islandHeartBeatMgr:Dispose()

	arg0_27.islandHeartBeatMgr = nil
end

return var0_0
