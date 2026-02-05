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
	arg0_6:InitAgora(arg2_6 or {})
	arg0_6:InitWorldObject(arg1_6)
	arg0_6:InitSyncObj()
	arg0_6.collectClientStateTimer:Start()
end

function var0_0.Update(arg0_7)
	arg0_7.syncDataDelayedProcessor:Update()
	arg0_7.syncObjDelayedProcessor:Update()
end

function var0_0.IsPlayerInTimeline(arg0_8)
	return arg0_8.player and arg0_8.player:InTimeline()
end

function var0_0.InitPlayer(arg0_9)
	arg0_9.player = SyncLocalPlayer.New(arg0_9.playerId, arg0_9.view.player)
end

function var0_0.OnVisitorEnter(arg0_10, arg1_10, arg2_10)
	arg0_10.visitorDic[arg1_10] = SyncUnitVisitor.New()
end

function var0_0.OnVisitorExit(arg0_11, arg1_11)
	local var0_11 = arg0_11.visitorDic[arg1_11]

	if var0_11 then
		local var1_11 = var0_11:GetLastInteract()

		if var1_11 then
			arg0_11:GetUnit(var1_11.type, var1_11.id):RemoveOwner(arg1_11)

			if var1_11.type == IslandConst.SYNC_TYPE_AGORA then
				arg0_11:Op("AgoraVirtualInterActionEndSync", var1_11.id, arg1_11)
			elseif var1_11.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
				arg0_11:Op("WorldObjectInterActionEndSync", var1_11.id, arg1_11)
			end
		end

		arg0_11.syncDataDelayedProcessor:RemoveDataById(arg1_11)
		var0_11:Dispose()

		arg0_11.visitorDic[arg1_11] = nil
	end
end

function var0_0.UpdateLocalPlayer(arg0_12)
	if table.getCount(arg0_12.visitorDic) <= 1 then
		return
	end

	local var0_12 = {}

	if arg0_12.player:IsLoaded() and not arg0_12.player:InTimeline() then
		local var1_12 = arg0_12.player:CreateSyncData()

		table.insert(var0_12, var1_12)
	end

	if #var0_12 > 0 then
		pg.m02:sendNotification(GAME.ISLAND_SYNC_DATA, {
			data = var0_12,
			islandId = arg0_12.island.id
		})
	end
end

function var0_0.HandleSyncData(arg0_13, arg1_13)
	_.each(arg1_13, function(arg0_14)
		local var0_14 = arg0_14.id

		arg0_13.syncDataDelayedProcessor:Add(var0_14, arg0_14)
	end)
end

function var0_0.UpdateVisitorSyncData(arg0_15, arg1_15)
	local var0_15 = arg1_15.id

	if not arg0_15.visitorDic[var0_15] then
		Debugger.LogWarning(string.format("访客不存在 id=%d", var0_15))

		return
	end

	arg0_15:Op("SetVisitorSyncData", var0_15, arg1_15)
end

function var0_0.SyncVisitorExist(arg0_16, arg1_16)
	return arg0_16.visitorDic[arg1_16] ~= nil
end

function var0_0.InitAgora(arg0_17, arg1_17)
	local var0_17 = {}

	for iter0_17, iter1_17 in pairs(arg1_17) do
		var0_17[iter0_17] = SyncUnitInteract.New(iter0_17, IslandConst.SYNC_TYPE_AGORA)
	end

	arg0_17.unitDic[IslandConst.SYNC_TYPE_AGORA] = var0_17
end

function var0_0.CancelAgoraInteract(arg0_18)
	local var0_18 = arg0_18.unitDic[IslandConst.SYNC_TYPE_AGORA]

	if not var0_18 then
		return
	end

	for iter0_18, iter1_18 in pairs(var0_18) do
		if iter1_18:OwnerCount() > 0 then
			for iter2_18, iter3_18 in pairs(iter1_18.owners) do
				arg0_18:Op("AgoraVirtualInterActionEndSync", iter0_18, iter3_18)

				if iter3_18 == arg0_18.playerId then
					arg0_18.player:SetInTimeline(false)
				end
			end
		end
	end
end

function var0_0.ResumeAgoraInteract(arg0_19)
	local var0_19 = arg0_19.unitDic[IslandConst.SYNC_TYPE_AGORA]

	if not var0_19 then
		return
	end

	for iter0_19, iter1_19 in pairs(var0_19) do
		if iter1_19:OwnerCount() > 0 then
			for iter2_19, iter3_19 in pairs(iter1_19.owners) do
				arg0_19:Op("AgoraVirtualInterActionSync", iter0_19, iter3_19, iter1_19.status, iter2_19)
			end
		end
	end
end

function var0_0.ClearAgoraInteractData(arg0_20)
	arg0_20.unitDic[IslandConst.SYNC_TYPE_AGORA] = {}
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

			if var1_22:OwnerCount() > 0 then
				for iter2_22, iter3_22 in pairs(var1_22.owners) do
					if iter3_22 ~= arg0_22.playerId and arg0_22.visitorDic[iter3_22] then
						arg0_22.visitorDic[iter3_22]:RecordLastInteract(iter1_22.id, iter1_22.type)

						if iter1_22.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
							arg0_22:Op("WorldObjectInterActionSync", iter1_22.id, iter3_22, iter1_22.status, iter2_22)
						elseif iter1_22.type == IslandConst.SYNC_TYPE_AGORA then
							arg0_22:Op("AgoraVirtualInterActionSync", iter1_22.id, iter3_22, iter1_22.status, iter2_22)
						end
					end
				end
			elseif iter1_22.status > 0 then
				if iter1_22.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
					arg0_22:Op("WorldObjectInitStatus", iter1_22.id, iter1_22.status)
				elseif iter1_22.type == IslandConst.SYNC_TYPE_AGORA then
					arg0_22:Op("AgoraVirtualInitStatus", iter1_22.id, iter1_22.status)
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
	arg0_25:OnVisitorInteract(arg1_25, function(arg0_26, arg1_26)
		local var0_26 = arg0_25:GetUnit(arg1_25.type, arg1_25.id)

		if not var0_26 then
			return
		end

		var0_26:SetStatus(arg1_25.status)

		if not arg0_25:SyncVisitorExist(arg0_26) then
			return
		end

		if arg1_25.type == IslandConst.SYNC_TYPE_AGORA then
			arg0_25:Op("AgoraVirtualInterActionSync", arg1_25.id, arg0_26, arg1_25.status, arg1_26)
		elseif arg1_25.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
			arg0_25:Op("WorldObjectInterActionSync", arg1_25.id, arg0_26, arg1_25.status, arg1_26)
		end
	end, function(arg0_27)
		if arg1_25.type == IslandConst.SYNC_TYPE_AGORA then
			arg0_25:Op("AgoraVirtualInterActionEndSync", arg1_25.id, arg0_27)
		elseif arg1_25.type == IslandConst.SYNC_TYPE_UNIT_STATIC then
			arg0_25:Op("WorldObjectInterActionEndSync", arg1_25.id, arg0_27)
		end
	end)
end

function var0_0.OnVisitorInteract(arg0_28, arg1_28, arg2_28, arg3_28)
	local var0_28 = arg0_28:GetUnit(arg1_28.type, arg1_28.id)

	if not var0_28 then
		return
	end

	local var1_28, var2_28, var3_28 = var0_28:UpdateOwner(arg1_28.slots)

	if var2_28 == arg0_28.playerId then
		return
	end

	local var4_28 = arg0_28.visitorDic[var2_28]

	if not var4_28 then
		warning("访客不存在 id=", var2_28)

		return
	end

	if var1_28 then
		var4_28:RecordLastInteract(arg1_28.id, arg1_28.type)
		arg2_28(var2_28, var3_28)
	else
		var4_28:ClearLastInteract()
		arg3_28(var2_28)
	end
end

function var0_0.TryControlUnit(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29, arg5_29)
	if arg0_29:IsPlayerInTimeline() then
		arg5_29(false)

		return
	end

	local var0_29 = arg0_29:GetUnit(arg1_29, arg2_29)

	arg0_29:ControlUnit(arg2_29, arg3_29, 1, arg4_29, arg1_29, function(arg0_30)
		if arg0_30 then
			arg0_29.player:SetInTimeline(true)
			var0_29:SetStatus(arg4_29)
		end

		arg5_29(arg0_30)
	end)
end

function var0_0.EndControlUnit(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31)
	local var0_31 = arg0_31:GetUnit(arg1_31, arg2_31)

	arg0_31:ControlUnit(arg2_31, arg3_31, 0, var0_31:GetStatus(), arg1_31, function(arg0_32)
		if arg0_32 then
			arg0_31.player:SetInTimeline(false)
		end

		arg4_31(arg0_32)
	end)
end

function var0_0.ControlUnit(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33, arg5_33, arg6_33)
	if arg0_33.controlResultDic[arg1_33] then
		arg6_33(false)

		return
	end

	arg0_33.controlResultDic[arg1_33] = arg6_33

	pg.m02:sendNotification(GAME.ISLAND_SYNC_CONTROL, {
		islandId = arg0_33.island.id,
		objId = arg1_33,
		slotId = arg2_33,
		op = arg3_33,
		status = arg4_33,
		type = arg5_33,
		onResult = function(arg0_34)
			local var0_34 = arg0_34 == 0

			existCall(arg0_33.controlResultDic[arg1_33], var0_34)

			arg0_33.controlResultDic[arg1_33] = nil
		end
	})
end

function var0_0.Dispose(arg0_35)
	arg0_35.collectClientStateTimer:Stop()
end

return var0_0
