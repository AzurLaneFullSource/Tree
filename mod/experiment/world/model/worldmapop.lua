local var0_0 = class("WorldMapOp", import("...BaseEntity"))

var0_0.Fields = {
	updateAttachmentCells = "table",
	fleetUpdates = "table",
	anim = "string",
	callbacksWhenApplied = "table",
	op = "number",
	salvageUpdates = "table",
	hiddenAttachments = "table",
	path = "table",
	hiddenCells = "table",
	depth = "number",
	stepOps = "table",
	staminaUpdate = "table",
	arg1 = "number",
	duration = "number",
	arg2 = "number",
	effect = "table",
	applied = "boolean",
	skipDisplay = "boolean",
	destMapId = "number",
	id = "number",
	trap = "number",
	routine = "function",
	updateCarryItems = "table",
	entranceId = "number",
	pos = "table",
	childOps = "table",
	drops = "table",
	locations = "table",
	terrainUpdates = "table",
	attachment = "table",
	shipUpdates = "table",
	fleetAttachUpdates = "table",
	sign = "table",
	destGridId = "number"
}

function var0_0.Apply(arg0_1)
	assert(not arg0_1.applied, "current op has been applied.")

	arg0_1.applied = true

	local var0_1 = getProxy(WorldProxy)
	local var1_1 = nowWorld()
	local var2_1 = var1_1:GetActiveMap()

	if arg0_1.op == WorldConst.OpReqMoveFleet then
		var1_1:IncRound()
	elseif arg0_1.op == WorldConst.OpReqRound then
		var1_1:IncRound()
	elseif arg0_1.op == WorldConst.OpReqEvent then
		local var3_1 = var2_1:GetFleet(arg0_1.id)
		local var4_1 = arg0_1.effect
		local var5_1 = var4_1.effect_type
		local var6_1 = var4_1.effect_paramater

		if var5_1 == WorldMapAttachment.EffectEventTeleport or var5_1 == WorldMapAttachment.EffectEventTeleportBack then
			assert(arg0_1.destMapId and arg0_1.destMapId > 0)
			var0_1:NetUpdateActiveMap(arg0_1.entranceId, arg0_1.destMapId, arg0_1.destGridId)
		elseif var5_1 == WorldMapAttachment.EffectEventShipBuff then
			local var7_1 = var6_1[1]

			_.each(var3_1:GetShips(true), function(arg0_2)
				arg0_2:AddBuff(var7_1, 1)
			end)
		elseif var5_1 == WorldMapAttachment.EffectEventAchieveCarry then
			_.each(var6_1, function(arg0_3)
				local var0_3 = WorldCarryItem.New()

				var0_3:Setup(arg0_3)
				var3_1:AddCarry(var0_3)
			end)
		elseif var5_1 == WorldMapAttachment.EffectEventConsumeCarry then
			local var8_1 = var6_1[1] or {}

			_.each(var8_1, function(arg0_4)
				var3_1:RemoveCarry(arg0_4)
			end)
		elseif var5_1 == WorldMapAttachment.EffectEventConsumeItem then
			var1_1:GetInventoryProxy():RemoveItem(var6_1[1], var6_1[2])
		elseif var5_1 == WorldMapAttachment.EffectEventDropTreasure then
			var1_1.treasureCount = var1_1.treasureCount + 1
		elseif var5_1 == WorldMapAttachment.EffectEventFOV then
			var2_1:EventEffectOpenFOV(var4_1)
		elseif var5_1 == WorldMapAttachment.EffectEventProgress then
			local var9_1 = math.max(var1_1:GetProgress(), var6_1[1])

			var1_1:UpdateProgress(var9_1)
		elseif var5_1 == WorldMapAttachment.EffectEventDeleteTask then
			local var10_1 = var1_1:GetTaskProxy()

			for iter0_1, iter1_1 in ipairs(var6_1) do
				var10_1:deleteTask(iter1_1)
			end
		elseif var5_1 == WorldMapAttachment.EffectEventGlobalBuff then
			var1_1:AddGlobalBuff(var6_1[1], var6_1[2])
		elseif var5_1 == WorldMapAttachment.EffectEventMapClearFlag then
			var2_1:UpdateClearFlag(var6_1[1] == 1)
		elseif var5_1 == WorldMapAttachment.EffectEventBrokenClean then
			for iter2_1, iter3_1 in ipairs(var1_1:GetShips()) do
				if iter3_1:IsBroken() then
					iter3_1:RemoveBuff(WorldConst.BrokenBuffId)
				end
			end
		elseif var5_1 == WorldMapAttachment.EffectEventCatSalvage then
			-- block empty
		elseif var5_1 == WorldMapAttachment.EffectEventAddWorldBossFreeCount then
			nowWorld():GetBossProxy():AddSummonFree(1)
		end

		if #var4_1.sound_effects > 0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:" .. var4_1.sound_effects)
		end
	elseif arg0_1.op == WorldConst.OpReqDiscover then
		_.each(arg0_1.locations, function(arg0_5)
			var2_1:GetCell(arg0_5.row, arg0_5.column):UpdateDiscovered(true)
		end)
		_.each(arg0_1.hiddenAttachments, function(arg0_6)
			arg0_6:UpdateLurk(false)
		end)
	elseif arg0_1.op == WorldConst.OpReqTransport then
		assert(arg0_1.destMapId and arg0_1.destMapId > 0)
		var0_1:NetUpdateActiveMap(arg0_1.entranceId, arg0_1.destMapId, arg0_1.destGridId)

		local var11_1 = var1_1:TreasureMap2ItemId(arg0_1.destMapId, arg0_1.entranceId)

		if var11_1 then
			var1_1:GetInventoryProxy():RemoveItem(var11_1, 1)
		end
	elseif arg0_1.op == WorldConst.OpReqSub then
		var1_1:ResetSubmarine()
		var1_1:UpdateSubmarineSupport(true)

		local var12_1 = var1_1:GetActiveMap()
	elseif arg0_1.op == WorldConst.OpReqPressingMap then
		local var13_1 = arg0_1.arg1

		var1_1:FlagMapPressingAward(var13_1)
		var1_1:GetAtlas():AddPressingMap(var13_1)

		local var14_1 = var1_1:GetMap(var13_1)

		if not var14_1.visionFlag and nowWorld():IsMapVisioned(var13_1) then
			var14_1:UpdateVisionFlag(true)
		end
	elseif arg0_1.op == WorldConst.OpReqJumpOut then
		assert(arg0_1.destMapId and arg0_1.destMapId > 0)

		local var15_1 = pg.world_chapter_template_reset[var2_1.gid].reset_item
		local var16_1 = var1_1:GetInventoryProxy()

		_.each(var15_1, function(arg0_7)
			var16_1:RemoveItem(arg0_7)
		end)
		var0_1:NetUpdateActiveMap(arg0_1.entranceId, arg0_1.destMapId, arg0_1.destGridId)

		var2_1 = var1_1:GetActiveMap()
	elseif arg0_1.op == WorldConst.OpReqEnterPort then
		-- block empty
	elseif arg0_1.op == WorldConst.OpReqCatSalvage then
		var2_1:GetFleet(arg0_1.id):UpdateCatSalvage(0, nil, 0)
	elseif arg0_1.op == WorldConst.OpReqSkipBattle then
		var2_1:WriteBack(true, {
			statistics = {},
			hpDropInfo = {}
		})
	elseif arg0_1.op == WorldConst.OpActionFleetMove then
		local var17_1 = arg0_1.path[#arg0_1.path]

		var2_1:UpdateFleetLocation(arg0_1.id, var17_1.row, var17_1.column)

		var1_1.stepCount = var1_1.stepCount + #arg0_1.path
	elseif arg0_1.op == WorldConst.OpActionMoveStep then
		arg0_1:ApplyAttachmentUpdate()
		_.each(arg0_1.hiddenCells, function(arg0_8)
			arg0_8:UpdateDiscovered(true)
		end)

		local var18_1 = var2_1:GetFleet(arg0_1.id)
		local var19_1 = var2_1:GetCell(var18_1.row, var18_1.column):GetEventAttachment()

		if var19_1 and var19_1:IsTriggered() then
			var19_1.triggered = false
		end

		if arg0_1.updateCarryItems and #arg0_1.updateCarryItems > 0 then
			local var20_1 = var18_1:GetCarries()

			assert(#var20_1 == #arg0_1.updateCarryItems)

			for iter4_1, iter5_1 in ipairs(var20_1) do
				iter5_1:UpdateOffset(arg0_1.updateCarryItems[iter4_1].offsetRow, arg0_1.updateCarryItems[iter4_1].offsetColumn)
			end

			WPool:ReturnArray(arg0_1.updateCarryItems)

			arg0_1.updateCarryItems = nil
		end

		var2_1:UpdateFleetLocation(arg0_1.id, arg0_1.pos.row, arg0_1.pos.column)
		_.each(arg0_1.hiddenAttachments, function(arg0_9)
			arg0_9:UpdateLurk(false)
		end)
	elseif arg0_1.op == WorldConst.OpActionAttachmentMove then
		assert(#arg0_1.path > 0)

		local var21_1 = arg0_1.attachment:Clone()
		local var22_1 = arg0_1.path[#arg0_1.path]

		var2_1:GetCell(arg0_1.attachment.row, arg0_1.attachment.column):RemoveAttachment(arg0_1.attachment)

		local var23_1 = var2_1:GetCell(var22_1.row, var22_1.column)

		assert(var23_1, "dest cell not exist: " .. var22_1.row .. ", " .. var22_1.column)

		var21_1.row = var22_1.row
		var21_1.column = var22_1.column

		var23_1:AddAttachment(var21_1)
	elseif arg0_1.op == WorldConst.OpActionEventOp then
		local var24_1 = arg0_1.effect

		if var24_1.effect_type == WorldMapAttachment.EffectEventFOV then
			var2_1:EventEffectOpenFOV(var24_1)
		end

		arg0_1.attachment:UpdateDataOp(arg0_1.attachment.dataop - 1)
	elseif arg0_1.op == WorldConst.OpActionTaskGoto then
		local var25_1 = arg0_1.effect

		if var25_1.effect_type == WorldMapAttachment.EffectEventFOV then
			var2_1:EventEffectOpenFOV(var25_1)
		end
	end

	if arg0_1.childOps then
		_.each(arg0_1.childOps, function(arg0_10)
			if not arg0_10.applied then
				arg0_10:Apply()
			end
		end)
	end

	if arg0_1.stepOps then
		_.each(arg0_1.stepOps, function(arg0_11)
			if not arg0_11.applied then
				arg0_11:Apply()
			end
		end)
	end

	arg0_1:ApplyAttachmentUpdate()
	arg0_1:ApplyNetUpdate()

	if arg0_1.callbacksWhenApplied then
		_.each(arg0_1.callbacksWhenApplied, function(arg0_12)
			arg0_12()
		end)
	end
end

function var0_0.ApplyAttachmentUpdate(arg0_13)
	local var0_13 = getProxy(WorldProxy)
	local var1_13 = nowWorld():GetActiveMap()

	if arg0_13.updateAttachmentCells then
		var0_13:UpdateMapAttachmentCells(var1_13.id, arg0_13.updateAttachmentCells)

		for iter0_13, iter1_13 in pairs(arg0_13.updateAttachmentCells) do
			local var2_13 = var1_13:GetCell(iter1_13.pos.row, iter1_13.pos.column)

			_.each(iter1_13.attachmentList, function(arg0_14)
				if not var2_13:ContainsAttachment(arg0_14) then
					WPool:Return(arg0_14)
				end
			end)
		end

		arg0_13.updateAttachmentCells = nil
	end
end

function var0_0.ApplyNetUpdate(arg0_15)
	local var0_15 = getProxy(WorldProxy)
	local var1_15 = nowWorld()
	local var2_15 = var1_15:GetActiveMap()

	if arg0_15.staminaUpdate then
		var1_15.staminaMgr:ChangeStamina(arg0_15.staminaUpdate[1], arg0_15.staminaUpdate[2])

		arg0_15.staminaUpdate = nil
	end

	if arg0_15.shipUpdates and #arg0_15.shipUpdates > 0 then
		var0_15:ApplyShipUpdate(arg0_15.shipUpdates)
		WPool:ReturnArray(arg0_15.shipUpdates)

		arg0_15.shipUpdates = nil
	end

	if arg0_15.fleetAttachUpdates and #arg0_15.fleetAttachUpdates > 0 then
		var0_15:ApplyFleetAttachUpdate(var2_15.id, arg0_15.fleetAttachUpdates)
		WPool:ReturnArray(arg0_15.fleetAttachUpdates)

		arg0_15.fleetAttachUpdates = nil
	end

	if arg0_15.fleetUpdates and #arg0_15.fleetUpdates > 0 then
		var0_15:ApplyFleetUpdate(var2_15.id, arg0_15.fleetUpdates)
		WPool:ReturnArray(arg0_15.fleetUpdates)

		arg0_15.fleetUpdates = nil
	end

	if arg0_15.terrainUpdates and #arg0_15.terrainUpdates > 0 then
		var0_15:ApplyTerrainUpdate(var2_15.id, arg0_15.terrainUpdates)
		WPool:ReturnArray(arg0_15.terrainUpdates)

		arg0_15.terrainUpdates = nil
	end

	if arg0_15.salvageUpdates and #arg0_15.salvageUpdates > 0 then
		var0_15:ApplySalvageUpdate(arg0_15.salvageUpdates)
		WPool:ReturnArray(arg0_15.salvageUpdates)

		arg0_15.salvageUpdates = nil
	end
end

function var0_0.AddCallbackWhenApplied(arg0_16, arg1_16)
	if not arg0_16.callbacksWhenApplied then
		arg0_16.callbacksWhenApplied = {}
	end

	table.insert(arg0_16.callbacksWhenApplied, arg1_16)
end

return var0_0
