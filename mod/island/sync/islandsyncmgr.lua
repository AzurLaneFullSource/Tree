local var0_0 = class("IslandSyncMgr")

local function var1_0(...)
	if false then
		warning(...)
	end
end

var0_0.INTERACRION_ITEMS = {
	IslandConst.SYNC_TYPE_INTERACTION_TEST
}
var0_0.ISLAND_SYNC_DATA_UPDATE = "IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE"
var0_0.ISLAND_SYNC_OBJ_UPDATE = "IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE"

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.syncUnitDic = {}
	arg0_2.controlResultDic = {}
	arg0_2.tid2SyncIdDic = {}
	arg0_2.controller = arg1_2
	arg0_2.island = arg1_2.island
	arg0_2.lazyCount = 0
	arg0_2.playerId = getProxy(PlayerProxy):getPlayerId()
	arg0_2.syncDataDelayedProcessor = DelayedDataProcessor.New(IslandConst.SYNC_TIME_DELAY, IslandConst.SYNC_TIME_INTERVAL * 1000, function(arg0_3)
		arg0_2:UpdateSyncData(arg0_3)
	end)
	arg0_2.syncObjDelayedProcessor = DelayedDataProcessor.New(IslandConst.SYNC_TIME_DELAY, IslandConst.SYNC_TIME_INTERVAL * 1000, function(arg0_4)
		arg0_2:UpdateSyncObj(arg0_4)
	end)
	arg0_2.syncUnitBuilder = SyncUnitBuilder.New(arg0_2.controller)
end

function var0_0.Init(arg0_5)
	local var0_5 = getProxy(IslandProxy):GetSyncObjInitData()

	for iter0_5, iter1_5 in ipairs(var0_5) do
		if iter1_5.type ~= IslandConst.SYNC_TYPE_UNIT_MOVE or table.contains(var0_0.INTERACRION_ITEMS, iter1_5.tid) then
			arg0_5:AddSyncUnit(iter1_5)
		end
	end

	arg0_5.collectClientStateTimer = Timer.New(function()
		arg0_5:UpdateMovableClientUnit()
	end, IslandConst.SYNC_TIME_INTERVAL, -1)

	arg0_5.collectClientStateTimer:Start()

	arg0_5.heartBeatTimer = Timer.New(function()
		pg.m02:sendNotification(GAME.ISLAND_HEART_BEAT, arg0_5.island.id)
	end, IslandConst.HEART_BEAT_INTERVAL, -1)

	arg0_5.heartBeatTimer:Start()
end

function var0_0.AddSyncUnit(arg0_8, arg1_8)
	local var0_8 = arg0_8.syncUnitBuilder:Build(arg1_8)

	arg0_8.syncUnitDic[arg1_8.id] = var0_8

	if arg0_8.tid2SyncIdDic[arg1_8.type] == nil then
		arg0_8.tid2SyncIdDic[arg1_8.type] = {}
	end

	arg0_8.tid2SyncIdDic[arg1_8.type][arg1_8.tid] = arg1_8.id
end

function var0_0.RemoveSyncUnit(arg0_9, arg1_9)
	local var0_9 = arg0_9.syncUnitDic[arg1_9.id]

	arg0_9.tid2SyncIdDic[arg1_9.type][arg1_9.tid] = nil

	var0_9:Dispose()

	arg0_9.syncUnitDic[arg1_9.id] = nil
end

function var0_0.GetUnitByTid(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.tid2SyncIdDic[arg2_10][arg1_10]
	local var1_10 = arg0_10.syncUnitDic[var0_10]

	assert(var1_10, "unit不存在 id=" .. var0_10)

	return var1_10, var0_10
end

function var0_0.HandleSyncObj(arg0_11, arg1_11)
	for iter0_11, iter1_11 in ipairs(arg1_11) do
		local var0_11 = iter1_11.id

		arg0_11.syncObjDelayedProcessor:Add(var0_11, iter1_11)
	end
end

function var0_0.UpdateSyncObj(arg0_12, arg1_12)
	if arg1_12.state == 0 then
		local var0_12 = arg0_12.syncUnitDic[arg1_12.id]

		if arg1_12.type == IslandConst.SYNC_TYPE_AGORA then
			local var1_12, var2_12 = var0_12:UpdateOwner(arg1_12.slots)

			if var1_12 then
				arg0_12.controller:InterAction(var0_12.tid, var2_12, true)
			else
				arg0_12.controller:InterActionEnd(var0_12.tid, var2_12, true)
			end
		elseif arg1_12.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
			-- block empty
		else
			var0_12:UpdateOwner(arg1_12.slots)
		end
	elseif arg1_12.state == 1 then
		arg0_12:AddSyncUnit(arg1_12)
	elseif arg1_12.state == 2 then
		arg0_12:RemoveSyncUnit(arg1_12)
	end
end

function var0_0.HandleSyncData(arg0_13, arg1_13)
	_.each(arg1_13, function(arg0_14)
		local var0_14 = arg0_14.id

		arg0_13.syncDataDelayedProcessor:Add(var0_14, arg0_14)
	end)
end

function var0_0.UpdateSyncData(arg0_15, arg1_15)
	local var0_15 = arg1_15.id
	local var1_15 = arg0_15.syncUnitDic[var0_15]

	if not var1_15 then
		Debugger.LogWarning(string.format("unit 不存在 id=%d", var0_15))

		return
	end

	var1_15:UpdateSyncData(arg1_15)
end

function var0_0.Update(arg0_16)
	arg0_16.syncObjDelayedProcessor:Update()
	arg0_16.syncDataDelayedProcessor:Update()
	arg0_16:UpdateMovableServerUnit()
end

function var0_0.UpdateMovableClientUnit(arg0_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in pairs(arg0_17.syncUnitDic) do
		if isa(iter1_17, SyncUnitMovable) and iter1_17:IsLoaded() and iter1_17:IsClient() and (iter1_17:GetType() ~= IslandConst.SYNC_TYPE_PLAYER or not iter1_17:InTimeline()) then
			local var1_17 = iter1_17:CreateSyncData()

			table.insert(var0_17, var1_17)
		end
	end

	if #var0_17 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_SYNC_DATA, {
			data = var0_17,
			islandId = arg0_17.island.id
		})
	end
end

function var0_0.UpdateMovableServerUnit(arg0_18)
	for iter0_18, iter1_18 in pairs(arg0_18.syncUnitDic) do
		if isa(iter1_18, SyncUnitMovable) and iter1_18:IsLoaded() and iter1_18:IsServer() then
			iter1_18:Update()
		end
	end
end

function var0_0.TryControlUnitAgora(arg0_19, arg1_19, arg2_19, arg3_19)
	local var0_19, var1_19 = arg0_19:GetUnitByTid(arg1_19, IslandConst.SYNC_TYPE_AGORA)

	arg0_19:ControlUnit(var1_19, 4294967295, function(arg0_20)
		if arg0_20 == 0 then
			arg0_19:GetUnitByTid(arg0_19.playerId, IslandConst.SYNC_TYPE_PLAYER):SetInTimeline(true)
		end

		arg3_19(arg0_20)
	end)
end

function var0_0.EndControlUnitAgora(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21, var1_21 = arg0_21:GetUnitByTid(arg1_21, IslandConst.SYNC_TYPE_AGORA)

	arg0_21:ControlUnit(var1_21, 0, function(arg0_22)
		if arg0_22 == 0 then
			arg0_21:GetUnitByTid(arg0_21.playerId, IslandConst.SYNC_TYPE_PLAYER):SetInTimeline(false)
		end

		arg3_21(arg0_22)
	end)
end

function var0_0.TryControlUnitInteraction(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = arg0_23.syncUnitDic[arg1_23]

	assert(var0_23:GetType() == IslandConst.SYNC_TYPE_UNIT_MOVE, "interact with wrong unit" .. arg1_23)
	var0_23:SetOwnerType(SyncUnitMovable.OWNER_TYPE_CLIENT)
	arg0_23:ControlUnit(arg1_23, arg2_23, arg3_23)
end

function var0_0.ControlUnit(arg0_24, arg1_24, arg2_24, arg3_24)
	if arg0_24.controlResultDic[arg1_24] then
		arg3_24(false)

		return
	end

	arg0_24.controlResultDic[arg1_24] = arg3_24

	pg.m02:sendNotification(GAME.ISLAND_SYNC_CONTROL, {
		islandId = arg0_24.island.id,
		objId = arg1_24,
		mseconds = arg2_24,
		onResult = function(arg0_25)
			local var0_25 = arg0_25 == 0

			existCall(arg0_24.controlResultDic[arg1_24], var0_25)

			arg0_24.controlResultDic[arg1_24] = nil
		end
	})
end

function var0_0.Dispose(arg0_26)
	arg0_26.collectClientStateTimer:Stop()
	arg0_26.heartBeatTimer:Stop()
end

function var0_0.TestData(arg0_27)
	local var0_27 = getProxy(IslandProxy):GetIsland()

	local function var1_27(arg0_28)
		local var0_28 = tonumber(string.match(arg0_28, "id=(%d+)"))
		local var1_28 = string.match(arg0_28, "pos=%[([%d%.,-]+)%]")
		local var2_28 = string.match(arg0_28, "dir=%[([%d%.,-]+)%]")
		local var3_28 = tonumber(string.match(arg0_28, "status=(%d+)"))

		local function var4_28(arg0_29)
			local var0_29, var1_29, var2_29 = arg0_29:match("([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)")

			return Vector3(tonumber(var0_29), tonumber(var1_29), tonumber(var2_29))
		end

		local function var5_28(arg0_30)
			local var0_30, var1_30, var2_30, var3_30 = arg0_30:match("([%d%.%-]+),([%d%.%-]+),([%d%.%-]+),([%d%.%-]+)")

			return Quaternion(tonumber(var0_30), tonumber(var1_30), tonumber(var2_30), tonumber(var3_30))
		end

		local var6_28 = var4_28(var1_28)
		local var7_28 = var5_28(var2_28)

		return SyncUnitData.New({
			id = var0_28,
			pos = var6_28,
			dir = var7_28,
			status = var3_28
		})
	end

	local var2_27 = {}

	for iter0_27 in io.lines("D:\\Project\\SyncTest.txt") do
		table.insert(var2_27, iter0_27)
	end

	local var3_27 = 1

	Timer.New(function()
		if var3_27 > #var2_27 then
			return
		end

		local var0_31 = var2_27[var3_27]

		var3_27 = var3_27 + 1

		local var1_31 = var1_27(var0_31)

		var1_31.id = 100
		var1_31.type = 1

		local var2_31 = {}

		table.insert(var2_31, var1_31)

		local var3_31 = math.random(IslandConst.SYNC_TEST_DELAY_L, IslandConst.SYNC_TEST_DELAY_R)

		LeanTween.delayedCall(var3_31 / 1000, System.Action(function()
			var0_27:DispatchEvent(IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE, var2_31)
		end))
	end, IslandConst.SYNC_TIME_INTERVAL, -1):Start()
end

return var0_0
