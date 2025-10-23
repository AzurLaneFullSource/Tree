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

function var0_0.IsPlayerInTimeline(arg0_10)
	return arg0_10.player and arg0_10.player:InTimeline()
end

function var0_0.InitPlayer(arg0_11)
	arg0_11.player = SyncLocalPlayer.New(arg0_11.playerId, arg0_11.view.player)
end

function var0_0.InitVisitor(arg0_12)
	local var0_12 = arg0_12.island:GetVisitorAgency():GetMapVisitorList()

	for iter0_12, iter1_12 in pairs(var0_12) do
		local var1_12 = arg0_12.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_PLAYER, iter1_12.id)

		arg0_12.visitorDic[iter1_12.id] = SyncUnitVisitor.New(var1_12)
	end
end

function var0_0.OnVisitorEnter(arg0_13, arg1_13, arg2_13)
	arg0_13.visitorDic[arg1_13] = SyncUnitVisitor.New(arg2_13)
end

function var0_0.OnVisitorExit(arg0_14, arg1_14)
	local var0_14 = arg0_14.visitorDic[arg1_14]

	if var0_14 then
		local var1_14 = var0_14:GetLastInteract()

		if var1_14 then
			arg0_14:GetUnit(var1_14.type, var1_14.id):RemoveOwner(arg1_14)

			if var1_14.type == IslandConst.SYNC_TYPE_AGORA then
				arg0_14:Op("InterActionEndSync", var1_14.id, arg1_14)
			elseif var1_14.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
				arg0_14:Op("WorldObjectInterActionEndSync", var1_14.id, arg1_14)
			end
		end

		arg0_14.syncDataDelayedProcessor:RemoveDataById(arg1_14)
		var0_14:Dispose()

		arg0_14.visitorDic[arg1_14] = nil
	end
end

function var0_0.UpdateLocalPlayer(arg0_15)
	if table.getCount(arg0_15.visitorDic) <= 1 then
		return
	end

	local var0_15 = {}

	if arg0_15.player:IsLoaded() and not arg0_15.player:InTimeline() then
		local var1_15 = arg0_15.player:CreateSyncData()

		table.insert(var0_15, var1_15)
	end

	if #var0_15 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_SYNC_DATA, {
			data = var0_15,
			islandId = arg0_15.island.id
		})
	end
end

function var0_0.HandleSyncData(arg0_16, arg1_16)
	_.each(arg1_16, function(arg0_17)
		local var0_17 = arg0_17.id

		arg0_16.syncDataDelayedProcessor:Add(var0_17, arg0_17)
	end)
end

function var0_0.UpdateVisitorSyncData(arg0_18, arg1_18)
	local var0_18 = arg1_18.id

	if not arg0_18.visitorDic[var0_18] then
		Debugger.LogWarning(string.format("访客不存在 id=%d", var0_18))

		return
	end

	arg0_18:Op("SetVisitorSyncData", var0_18, arg1_18)
end

function var0_0.SyncVisitorExist(arg0_19, arg1_19)
	return arg0_19.visitorDic[arg1_19] ~= nil
end

function var0_0.InitAgora(arg0_20, arg1_20)
	local var0_20 = {}

	for iter0_20, iter1_20 in pairs(arg1_20) do
		var0_20[iter0_20] = SyncUnitInteract.New(iter0_20, IslandConst.SYNC_TYPE_AGORA)
	end

	arg0_20.unitDic[IslandConst.SYNC_TYPE_AGORA] = var0_20
end

function var0_0.CancelAgoraInteract(arg0_21)
	local var0_21 = arg0_21.unitDic[IslandConst.SYNC_TYPE_AGORA]

	if not var0_21 then
		return
	end

	for iter0_21, iter1_21 in pairs(var0_21) do
		if iter1_21:OwnerCount() > 0 then
			for iter2_21, iter3_21 in pairs(iter1_21.owners) do
				arg0_21:Op("InterActionEndSync", iter0_21, iter3_21)

				if iter3_21 == arg0_21.playerId then
					arg0_21.player:SetInTimeline(false)
				end
			end
		end
	end
end

function var0_0.ResumeAgoraInteract(arg0_22)
	local var0_22 = arg0_22.unitDic[IslandConst.SYNC_TYPE_AGORA]

	if not var0_22 then
		return
	end

	for iter0_22, iter1_22 in pairs(var0_22) do
		if iter1_22:OwnerCount() > 0 then
			for iter2_22, iter3_22 in pairs(iter1_22.owners) do
				arg0_22:Op("InterActionSync", iter0_22, iter3_22, iter2_22)
			end
		end
	end
end

function var0_0.ClearAgoraInteractData(arg0_23)
	arg0_23.unitDic[IslandConst.SYNC_TYPE_AGORA] = {}
end

function var0_0.InitWorldObject(arg0_24, arg1_24)
	local var0_24 = {}

	for iter0_24, iter1_24 in ipairs(arg1_24) do
		if iter1_24.type == IslandConst.UNIT_TYPE_ITEM_INTERACT then
			var0_24[iter1_24.id] = SyncUnitInteract.New(iter1_24.id, IslandConst.SYNC_TYPE_UNIT_STATIC)
		end
	end

	arg0_24.unitDic[IslandConst.SYNC_TYPE_UNIT_STATIC] = var0_24
end

function var0_0.InitSyncObj(arg0_25)
	local var0_25 = getProxy(IslandProxy):GetSyncObjInitData()

	for iter0_25, iter1_25 in ipairs(var0_25) do
		local var1_25 = arg0_25:GetUnit(iter1_25.type, iter1_25.id)

		if var1_25 then
			var1_25:InitOwner(iter1_25.slots)

			if iter1_25.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
				if var1_25:OwnerCount() > 0 then
					for iter2_25, iter3_25 in pairs(var1_25.owners) do
						if iter3_25 ~= arg0_25.playerId and arg0_25.visitorDic[iter3_25] then
							arg0_25.visitorDic[iter3_25]:RecordLastInteract(iter1_25.id, iter1_25.type)
							arg0_25:Op("WorldObjectInterActionSync", iter1_25.id, iter3_25, iter1_25.status, iter2_25)
						end
					end
				elseif iter1_25.status > 0 then
					arg0_25:Op("WorldObjectInitStatus", iter1_25.id, iter1_25.status)
				end
			elseif iter1_25.type == IslandConst.SYNC_TYPE_AGORA and var1_25:OwnerCount() > 0 then
				for iter4_25, iter5_25 in pairs(var1_25.owners) do
					if iter5_25 ~= arg0_25.playerId and arg0_25.visitorDic[iter5_25] then
						arg0_25.visitorDic[iter5_25]:RecordLastInteract(iter1_25.id, iter1_25.type)
						arg0_25:Op("InterActionSync", iter1_25.id, iter5_25, iter4_25)
					end
				end
			end
		end
	end
end

function var0_0.GetUnit(arg0_26, arg1_26, arg2_26)
	if not arg0_26.unitDic[arg1_26] then
		return nil
	end

	return arg0_26.unitDic[arg1_26][arg2_26]
end

function var0_0.HandleSyncObj(arg0_27, arg1_27)
	for iter0_27, iter1_27 in ipairs(arg1_27) do
		arg0_27.syncObjDelayedProcessor:Add(iter1_27.id, iter1_27)
	end
end

function var0_0.UpdateSyncObj(arg0_28, arg1_28)
	if arg1_28.type == IslandConst.SYNC_TYPE_AGORA then
		arg0_28:OnVisitorInteract(arg1_28, function(arg0_29, arg1_29)
			if not arg0_28:SyncVisitorExist(arg0_29) then
				return
			end

			arg0_28:Op("InterActionSync", arg1_28.id, arg0_29, arg1_29)
		end, function(arg0_30)
			arg0_28:Op("InterActionEndSync", arg1_28.id, arg0_30)
		end)
	elseif arg1_28.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
		arg0_28:OnVisitorInteract(arg1_28, function(arg0_31, arg1_31)
			local var0_31 = arg0_28:GetUnit(arg1_28.type, arg1_28.id)

			if not var0_31 then
				return
			end

			var0_31:SetStatus(arg1_28.status)

			if not arg0_28:SyncVisitorExist(arg0_31) then
				return
			end

			arg0_28:Op("WorldObjectInterActionSync", arg1_28.id, arg0_31, arg1_28.status, arg1_31)
		end, function(arg0_32)
			arg0_28:Op("WorldObjectInterActionEndSync", arg1_28.id, arg0_32)
		end)
	end
end

function var0_0.OnVisitorInteract(arg0_33, arg1_33, arg2_33, arg3_33)
	local var0_33 = arg0_33:GetUnit(arg1_33.type, arg1_33.id)

	if not var0_33 then
		return
	end

	local var1_33, var2_33, var3_33 = var0_33:UpdateOwner(arg1_33.slots)

	if var2_33 == arg0_33.playerId then
		return
	end

	local var4_33 = arg0_33.visitorDic[var2_33]

	if not var4_33 then
		Debugger.LogWarning(string.format("访客不存在 id=%d", var2_33))

		return
	end

	if var1_33 then
		var4_33:RecordLastInteract(arg1_33.id, arg1_33.type)
		arg2_33(var2_33, var3_33)
	else
		var4_33:ClearLastInteract()
		arg3_33(var2_33)
	end
end

function var0_0.TryControlUnit(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34, arg5_34)
	if arg0_34:IsPlayerInTimeline() then
		arg5_34(false)

		return
	end

	local var0_34 = arg0_34:GetUnit(arg1_34, arg2_34)

	arg0_34:ControlUnit(arg2_34, arg3_34, 1, arg4_34, arg1_34, function(arg0_35)
		if arg0_35 then
			arg0_34.player:SetInTimeline(true)
			var0_34:SetStatus(arg4_34)
		end

		arg5_34(arg0_35)
	end)
end

function var0_0.EndControlUnit(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
	local var0_36 = arg0_36:GetUnit(arg1_36, arg2_36)

	arg0_36:ControlUnit(arg2_36, arg3_36, 0, var0_36:GetStatus(), arg1_36, function(arg0_37)
		if arg0_37 then
			arg0_36.player:SetInTimeline(false)
		end

		arg4_36(arg0_37)
	end)
end

function var0_0.ControlUnit(arg0_38, arg1_38, arg2_38, arg3_38, arg4_38, arg5_38, arg6_38)
	if arg0_38.controlResultDic[arg1_38] then
		arg6_38(false)

		return
	end

	arg0_38.controlResultDic[arg1_38] = arg6_38

	pg.m02:sendNotification(GAME.ISLAND_SYNC_CONTROL, {
		islandId = arg0_38.island.id,
		objId = arg1_38,
		slotId = arg2_38,
		op = arg3_38,
		status = arg4_38,
		type = arg5_38,
		onResult = function(arg0_39)
			local var0_39 = arg0_39 == 0

			existCall(arg0_38.controlResultDic[arg1_38], var0_39)

			arg0_38.controlResultDic[arg1_38] = nil
		end
	})
end

function var0_0.Dispose(arg0_40)
	arg0_40.collectClientStateTimer:Stop()
end

return var0_0
