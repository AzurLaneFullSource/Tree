local var0_0 = class("IslandSyncMgr")

var0_0.ISLAND_SYNC_DATA_UPDATE = "IslandSyncMgr.ISLAND_SYNC_DATA_UPDATE"
var0_0.ISLAND_SYNC_OBJ_UPDATE = "IslandSyncMgr.ISLAND_SYNC_OBJ_UPDATE"

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.controlResultDic = {}
	arg0_1.visitorDic = {}
	arg0_1.unitDic = {}
	arg0_1.controller = arg1_1
	arg0_1.island = arg1_1.island
	arg0_1.view = arg1_1:GetCore().view
	arg0_1.playerId = getProxy(PlayerProxy):getPlayerId()
	arg0_1.syncDataDelayedProcessor = DelayedDataProcessor.New(IslandConst.SYNC_TIME_DELAY, IslandConst.SYNC_TIME_INTERVAL * 1000, function(arg0_2)
		arg0_1:UpdateVisitorSyncData(arg0_2)
	end)
	arg0_1.syncObjDelayedProcessor = DelayedDataProcessor.New(IslandConst.SYNC_TIME_DELAY, IslandConst.SYNC_TIME_INTERVAL * 1000, function(arg0_3)
		arg0_1:UpdateSyncObj(arg0_3)
	end)
	arg0_1.collectClientStateTimer = Timer.New(function()
		arg0_1:UpdateLocalPlayer()
	end, IslandConst.SYNC_TIME_INTERVAL, -1)
end

function var0_0.Init(arg0_5, arg1_5, arg2_5)
	arg0_5:InitPlayer()
	arg0_5:InitVisitor()
	arg0_5:InitAgora(arg2_5 or {})
	arg0_5:InitWorldObject(arg1_5)
	arg0_5:InitSyncObj()
	arg0_5.collectClientStateTimer:Start()
end

function var0_0.Update(arg0_6)
	xpcall(function()
		arg0_6.syncDataDelayedProcessor:Update()
		arg0_6.syncObjDelayedProcessor:Update()
		arg0_6:UpdateVisitorUnit()
	end, function(...)
		errorMsg(debug.traceback(...))
	end)
end

function var0_0.InitPlayer(arg0_9)
	arg0_9.player = SyncLocalPlayer.New(arg0_9.playerId, arg0_9.view.player)
end

function var0_0.InitVisitor(arg0_10)
	local var0_10 = arg0_10.island:GetVisitorAgency():GetMapVisitorList()

	for iter0_10, iter1_10 in pairs(var0_10) do
		local var1_10 = arg0_10.view:GetUnitModule(iter1_10.id)

		arg0_10.visitorDic[iter1_10.id] = SyncUnitVisitor.New(var1_10)
	end
end

function var0_0.OnVisitorEnter(arg0_11, arg1_11, arg2_11)
	arg0_11.visitorDic[arg1_11] = SyncUnitVisitor.New(arg2_11)
end

function var0_0.OnVisitorExit(arg0_12, arg1_12)
	local var0_12 = arg0_12.visitorDic[arg1_12]

	if var0_12 then
		local var1_12 = var0_12:GetLastInteract()

		if var1_12 then
			arg0_12:GetUnit(var1_12.type, var1_12.id):RemoveOwner(arg1_12)

			if var1_12.type == IslandConst.SYNC_TYPE_AGORA then
				arg0_12.controller:InterActionEnd(var1_12.id, arg1_12, true)
			elseif var1_12.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
				arg0_12.controller:WorldObjectInterActionEnd(var1_12.id, arg1_12, true)
			end
		end

		arg0_12.syncDataDelayedProcessor:RemoveDataById(arg1_12)
		var0_12:Dispose()

		arg0_12.visitorDic[arg1_12] = nil
	end
end

function var0_0.UpdateLocalPlayer(arg0_13)
	local var0_13 = {}

	if arg0_13.player:IsLoaded() and not arg0_13.player:InTimeline() then
		local var1_13 = arg0_13.player:CreateSyncData()

		table.insert(var0_13, var1_13)
	end

	if #var0_13 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_SYNC_DATA, {
			data = var0_13,
			islandId = arg0_13.island.id
		})
	end
end

function var0_0.UpdateVisitorUnit(arg0_14)
	for iter0_14, iter1_14 in pairs(arg0_14.visitorDic) do
		iter1_14:Update()
	end
end

function var0_0.HandleSyncData(arg0_15, arg1_15)
	_.each(arg1_15, function(arg0_16)
		local var0_16 = arg0_16.id

		arg0_15.syncDataDelayedProcessor:Add(var0_16, arg0_16)
	end)
end

function var0_0.UpdateVisitorSyncData(arg0_17, arg1_17)
	local var0_17 = arg1_17.id
	local var1_17 = arg0_17.visitorDic[var0_17]

	if not var1_17 then
		return
	end

	var1_17:UpdateSyncData(arg1_17)
end

function var0_0.SyncVisitorExist(arg0_18, arg1_18)
	return arg0_18.visitorDic[arg1_18] ~= nil
end

function var0_0.InitAgora(arg0_19, arg1_19)
	local var0_19 = {}

	for iter0_19, iter1_19 in pairs(arg1_19) do
		var0_19[iter0_19] = SyncUnitInteract.New(iter0_19, IslandConst.SYNC_TYPE_AGORA)
	end

	arg0_19.unitDic[IslandConst.SYNC_TYPE_AGORA] = var0_19
end

function var0_0.OnClearAgora(arg0_20)
	return
end

function var0_0.InitWorldObject(arg0_21, arg1_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(arg1_21) do
		if iter1_21.type == IslandConst.UNIT_TYPE_ITEM_INTERACT then
			var0_21[iter1_21.id] = SyncUnitInteract.New(iter1_21.id, IslandConst.SYNC_TYPE_UNIT_STATIC)
		end
	end

	arg0_21.unitDic[IslandConst.SYNC_TYPE_UNIT_STATIC] = var0_21
end

function var0_0.InitSyncObj(arg0_22)
	local var0_22 = getProxy(IslandProxy):GetSyncObjInitData()

	for iter0_22, iter1_22 in ipairs(var0_22) do
		local var1_22 = arg0_22:GetUnit(iter1_22.type, iter1_22.id)

		if var1_22 then
			var1_22:InitOwner(iter1_22.slots)

			if iter1_22.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
				if var1_22:OwnerCount() > 0 then
					for iter2_22, iter3_22 in pairs(var1_22.owners) do
						if iter3_22 ~= arg0_22.playerId then
							arg0_22.controller:WorldObjectInterAction(iter1_22.tid, iter3_22, iter1_22.status, true)
						end
					end
				elseif iter1_22.status > 0 then
					arg0_22.controller:WorldObjectInitStatus(iter1_22.tid, iter1_22.status)
				end
			elseif iter1_22.type == IslandConst.SYNC_TYPE_AGORA and var1_22:OwnerCount() > 0 then
				for iter4_22, iter5_22 in pairs(var1_22.owners) do
					if iter5_22 ~= arg0_22.playerId then
						arg0_22.controller:InterAction(iter1_22.tid, iter5_22, true)
					end
				end
			end
		end
	end
end

function var0_0.GetUnit(arg0_23, arg1_23, arg2_23)
	if not arg0_23.unitDic[arg1_23] then
		return nil
	end

	return arg0_23.unitDic[arg1_23][arg2_23]
end

function var0_0.HandleSyncObj(arg0_24, arg1_24)
	for iter0_24, iter1_24 in ipairs(arg1_24) do
		arg0_24.syncObjDelayedProcessor:Add(iter1_24.id, iter1_24)
	end
end

function var0_0.UpdateSyncObj(arg0_25, arg1_25)
	if arg1_25.type == IslandConst.SYNC_TYPE_AGORA then
		arg0_25:OnVisitorInteract(arg1_25, function(arg0_26)
			if not arg0_25:SyncVisitorExist(arg0_26) then
				return
			end

			arg0_25.controller:InterAction(arg1_25.id, arg0_26, true)
		end, function(arg0_27)
			arg0_25.controller:InterActionEnd(arg1_25.id, arg0_27, true)
		end)
	elseif arg1_25.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
		arg0_25:OnVisitorInteract(arg1_25, function(arg0_28)
			arg0_25:GetUnit(arg1_25.type, arg1_25.id):SetStatus(arg1_25.status)

			if not arg0_25:SyncVisitorExist(arg0_28) then
				return
			end

			arg0_25.controller:WorldObjectInterAction(arg1_25.id, arg0_28, arg1_25.status, true)
		end, function(arg0_29)
			arg0_25.controller:WorldObjectInterActionEnd(arg1_25.id, arg0_29, true)
		end)
	end
end

function var0_0.OnVisitorInteract(arg0_30, arg1_30, arg2_30, arg3_30)
	local var0_30, var1_30 = arg0_30:GetUnit(arg1_30.type, arg1_30.id):UpdateOwner(arg1_30.slots)

	if var1_30 == arg0_30.playerId then
		return
	end

	local var2_30 = arg0_30.visitorDic[var1_30]

	if var0_30 then
		var2_30:RecordLastInteract(arg1_30.id, arg1_30.type)
		arg2_30(var1_30)
	else
		var2_30:ClearLastInteract()
		arg3_30(var1_30)
	end
end

function var0_0.TryControlUnit(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31, arg5_31)
	local var0_31 = arg0_31:GetUnit(arg1_31, arg2_31)

	arg0_31:ControlUnit(arg2_31, arg3_31, 1, arg4_31, arg1_31, function(arg0_32)
		if arg0_32 then
			arg0_31.player:SetInTimeline(true)
			var0_31:SetStatus(arg4_31)
		end

		arg5_31(arg0_32)
	end)
end

function var0_0.EndControlUnit(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33)
	local var0_33 = arg0_33:GetUnit(arg1_33, arg2_33)

	arg0_33:ControlUnit(arg2_33, arg3_33, 0, var0_33:GetStatus(), arg1_33, function(arg0_34)
		if arg0_34 then
			arg0_33.player:SetInTimeline(false)
		end

		arg4_33(arg0_34)
	end)
end

function var0_0.ControlUnit(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35, arg5_35, arg6_35)
	if arg0_35.controlResultDic[arg1_35] then
		arg6_35(false)

		return
	end

	arg0_35.controlResultDic[arg1_35] = arg6_35

	pg.m02:sendNotification(GAME.ISLAND_SYNC_CONTROL, {
		islandId = arg0_35.island.id,
		objId = arg1_35,
		slotId = arg2_35,
		op = arg3_35,
		status = arg4_35,
		type = arg5_35,
		onResult = function(arg0_36)
			local var0_36 = arg0_36 == 0

			existCall(arg0_35.controlResultDic[arg1_35], var0_36)

			arg0_35.controlResultDic[arg1_35] = nil
		end
	})
end

function var0_0.Dispose(arg0_37)
	arg0_37.collectClientStateTimer:Stop()
end

return var0_0
