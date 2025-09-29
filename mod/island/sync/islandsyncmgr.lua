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

function var0_0.Op(arg0_5, arg1_5, ...)
	arg0_5.controller:Receive(arg1_5, ...)
end

function var0_0.Init(arg0_6, arg1_6, arg2_6)
	arg0_6:InitPlayer()
	arg0_6:InitVisitor()
	arg0_6:InitAgora(arg2_6 or {})
	arg0_6:InitWorldObject(arg1_6)
	arg0_6:InitSyncObj()
	arg0_6.collectClientStateTimer:Start()
end

function var0_0.Update(arg0_7)
	xpcall(function()
		arg0_7.syncDataDelayedProcessor:Update()
		arg0_7.syncObjDelayedProcessor:Update()
	end, function(...)
		errorMsg(debug.traceback(...))
	end)
end

function var0_0.InitPlayer(arg0_10)
	arg0_10.player = SyncLocalPlayer.New(arg0_10.playerId, arg0_10.view.player)
end

function var0_0.InitVisitor(arg0_11)
	local var0_11 = arg0_11.island:GetVisitorAgency():GetMapVisitorList()

	for iter0_11, iter1_11 in pairs(var0_11) do
		local var1_11 = arg0_11.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, iter1_11.id)

		arg0_11.visitorDic[iter1_11.id] = SyncUnitVisitor.New(var1_11)
	end
end

function var0_0.OnVisitorEnter(arg0_12, arg1_12, arg2_12)
	arg0_12.visitorDic[arg1_12] = SyncUnitVisitor.New(arg2_12)
end

function var0_0.OnVisitorExit(arg0_13, arg1_13)
	local var0_13 = arg0_13.visitorDic[arg1_13]

	if var0_13 then
		local var1_13 = var0_13:GetLastInteract()

		if var1_13 then
			arg0_13:GetUnit(var1_13.type, var1_13.id):RemoveOwner(arg1_13)

			if var1_13.type == IslandConst.SYNC_TYPE_AGORA then
				arg0_13:Op("InterActionEndSync", var1_13.id, arg1_13)
			elseif var1_13.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
				arg0_13:Op("WorldObjectInterActionEndSync", var1_13.id, arg1_13)
			end
		end

		arg0_13.syncDataDelayedProcessor:RemoveDataById(arg1_13)
		var0_13:Dispose()

		arg0_13.visitorDic[arg1_13] = nil
	end
end

function var0_0.UpdateLocalPlayer(arg0_14)
	if table.getCount(arg0_14.visitorDic) <= 1 then
		return
	end

	local var0_14 = {}

	if arg0_14.player:IsLoaded() and not arg0_14.player:InTimeline() then
		local var1_14 = arg0_14.player:CreateSyncData()

		table.insert(var0_14, var1_14)
	end

	if #var0_14 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_SYNC_DATA, {
			data = var0_14,
			islandId = arg0_14.island.id
		})
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

	if not arg0_17.visitorDic[var0_17] then
		Debugger.LogWarning(string.format("访客不存在 id=%d", var0_17))

		return
	end

	arg0_17:Op("SetVisitorSyncData", var0_17, arg1_17)
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

function var0_0.CancelAgoraInteract(arg0_20)
	local var0_20 = arg0_20.unitDic[IslandConst.SYNC_TYPE_AGORA]

	if not var0_20 then
		return
	end

	for iter0_20, iter1_20 in pairs(var0_20) do
		if iter1_20:OwnerCount() > 0 then
			for iter2_20, iter3_20 in pairs(iter1_20.owners) do
				arg0_20:Op("InterActionEndSync", iter0_20, iter3_20)

				if iter3_20 == arg0_20.playerId then
					arg0_20.player:SetInTimeline(false)
				end
			end
		end
	end
end

function var0_0.ResumeAgoraInteract(arg0_21)
	local var0_21 = arg0_21.unitDic[IslandConst.SYNC_TYPE_AGORA]

	if not var0_21 then
		return
	end

	for iter0_21, iter1_21 in pairs(var0_21) do
		if iter1_21:OwnerCount() > 0 then
			for iter2_21, iter3_21 in pairs(iter1_21.owners) do
				arg0_21:Op("InterActionSync", iter0_21, iter3_21, iter2_21)
			end
		end
	end
end

function var0_0.ClearAgoraInteractData(arg0_22)
	arg0_22.unitDic[IslandConst.SYNC_TYPE_AGORA] = {}
end

function var0_0.InitWorldObject(arg0_23, arg1_23)
	local var0_23 = {}

	for iter0_23, iter1_23 in ipairs(arg1_23) do
		if iter1_23.type == IslandConst.UNIT_TYPE_ITEM_INTERACT then
			var0_23[iter1_23.id] = SyncUnitInteract.New(iter1_23.id, IslandConst.SYNC_TYPE_UNIT_STATIC)
		end
	end

	arg0_23.unitDic[IslandConst.SYNC_TYPE_UNIT_STATIC] = var0_23
end

function var0_0.InitSyncObj(arg0_24)
	local var0_24 = getProxy(IslandProxy):GetSyncObjInitData()

	for iter0_24, iter1_24 in ipairs(var0_24) do
		local var1_24 = arg0_24:GetUnit(iter1_24.type, iter1_24.id)

		if var1_24 then
			var1_24:InitOwner(iter1_24.slots)

			if iter1_24.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
				if var1_24:OwnerCount() > 0 then
					for iter2_24, iter3_24 in pairs(var1_24.owners) do
						if iter3_24 ~= arg0_24.playerId and arg0_24.visitorDic[iter3_24] then
							arg0_24.visitorDic[iter3_24]:RecordLastInteract(iter1_24.id, iter1_24.type)
							arg0_24:Op("WorldObjectInterActionSync", iter1_24.id, iter3_24, iter1_24.status, iter2_24)
						end
					end
				elseif iter1_24.status > 0 then
					arg0_24:Op("WorldObjectInitStatus", iter1_24.id, iter1_24.status)
				end
			elseif iter1_24.type == IslandConst.SYNC_TYPE_AGORA and var1_24:OwnerCount() > 0 then
				for iter4_24, iter5_24 in pairs(var1_24.owners) do
					if iter5_24 ~= arg0_24.playerId and arg0_24.visitorDic[iter5_24] then
						arg0_24.visitorDic[iter5_24]:RecordLastInteract(iter1_24.id, iter1_24.type)
						arg0_24:Op("InterActionSync", iter1_24.id, iter5_24, iter4_24)
					end
				end
			end
		end
	end
end

function var0_0.GetUnit(arg0_25, arg1_25, arg2_25)
	if not arg0_25.unitDic[arg1_25] then
		return nil
	end

	return arg0_25.unitDic[arg1_25][arg2_25]
end

function var0_0.HandleSyncObj(arg0_26, arg1_26)
	for iter0_26, iter1_26 in ipairs(arg1_26) do
		arg0_26.syncObjDelayedProcessor:Add(iter1_26.id, iter1_26)
	end
end

function var0_0.UpdateSyncObj(arg0_27, arg1_27)
	if arg1_27.type == IslandConst.SYNC_TYPE_AGORA then
		arg0_27:OnVisitorInteract(arg1_27, function(arg0_28, arg1_28)
			if not arg0_27:SyncVisitorExist(arg0_28) then
				return
			end

			arg0_27:Op("InterActionSync", arg1_27.id, arg0_28, arg1_28)
		end, function(arg0_29)
			arg0_27:Op("InterActionEndSync", arg1_27.id, arg0_29)
		end)
	elseif arg1_27.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
		arg0_27:OnVisitorInteract(arg1_27, function(arg0_30, arg1_30)
			local var0_30 = arg0_27:GetUnit(arg1_27.type, arg1_27.id)

			if not var0_30 then
				return
			end

			var0_30:SetStatus(arg1_27.status)

			if not arg0_27:SyncVisitorExist(arg0_30) then
				return
			end

			arg0_27:Op("WorldObjectInterActionSync", arg1_27.id, arg0_30, arg1_27.status, arg1_30)
		end, function(arg0_31)
			arg0_27:Op("WorldObjectInterActionEndSync", arg1_27.id, arg0_31)
		end)
	end
end

function var0_0.OnVisitorInteract(arg0_32, arg1_32, arg2_32, arg3_32)
	local var0_32 = arg0_32:GetUnit(arg1_32.type, arg1_32.id)

	if not var0_32 then
		return
	end

	local var1_32, var2_32, var3_32 = var0_32:UpdateOwner(arg1_32.slots)

	if var2_32 == arg0_32.playerId then
		return
	end

	local var4_32 = arg0_32.visitorDic[var2_32]

	if not var4_32 then
		Debugger.LogWarning(string.format("访客不存在 id=%d", var2_32))

		return
	end

	if var1_32 then
		var4_32:RecordLastInteract(arg1_32.id, arg1_32.type)
		arg2_32(var2_32, var3_32)
	else
		var4_32:ClearLastInteract()
		arg3_32(var2_32)
	end
end

function var0_0.TryControlUnit(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33, arg5_33)
	local var0_33 = arg0_33:GetUnit(arg1_33, arg2_33)

	arg0_33:ControlUnit(arg2_33, arg3_33, 1, arg4_33, arg1_33, function(arg0_34)
		if arg0_34 then
			arg0_33.player:SetInTimeline(true)
			var0_33:SetStatus(arg4_33)
		end

		arg5_33(arg0_34)
	end)
end

function var0_0.EndControlUnit(arg0_35, arg1_35, arg2_35, arg3_35, arg4_35)
	local var0_35 = arg0_35:GetUnit(arg1_35, arg2_35)

	arg0_35:ControlUnit(arg2_35, arg3_35, 0, var0_35:GetStatus(), arg1_35, function(arg0_36)
		if arg0_36 then
			arg0_35.player:SetInTimeline(false)
		end

		arg4_35(arg0_36)
	end)
end

function var0_0.ControlUnit(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37, arg5_37, arg6_37)
	if arg0_37.controlResultDic[arg1_37] then
		arg6_37(false)

		return
	end

	arg0_37.controlResultDic[arg1_37] = arg6_37

	pg.m02:sendNotification(GAME.ISLAND_SYNC_CONTROL, {
		islandId = arg0_37.island.id,
		objId = arg1_37,
		slotId = arg2_37,
		op = arg3_37,
		status = arg4_37,
		type = arg5_37,
		onResult = function(arg0_38)
			local var0_38 = arg0_38 == 0

			existCall(arg0_37.controlResultDic[arg1_37], var0_38)

			arg0_37.controlResultDic[arg1_37] = nil
		end
	})
end

function var0_0.Dispose(arg0_39)
	arg0_39.collectClientStateTimer:Stop()
end

return var0_0
