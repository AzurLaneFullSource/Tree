local var0 = class("WorldMapOp", import("...BaseEntity"))

var0.Fields = {
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

function var0.Apply(arg0)
	assert(not arg0.applied, "current op has been applied.")

	arg0.applied = true

	local var0 = getProxy(WorldProxy)
	local var1 = nowWorld()
	local var2 = var1:GetActiveMap()

	if arg0.op == WorldConst.OpReqMoveFleet then
		var1:IncRound()
	elseif arg0.op == WorldConst.OpReqRound then
		var1:IncRound()
	elseif arg0.op == WorldConst.OpReqEvent then
		local var3 = var2:GetFleet(arg0.id)
		local var4 = arg0.effect
		local var5 = var4.effect_type
		local var6 = var4.effect_paramater

		if var5 == WorldMapAttachment.EffectEventTeleport or var5 == WorldMapAttachment.EffectEventTeleportBack then
			assert(arg0.destMapId and arg0.destMapId > 0)
			var0:NetUpdateActiveMap(arg0.entranceId, arg0.destMapId, arg0.destGridId)
		elseif var5 == WorldMapAttachment.EffectEventShipBuff then
			local var7 = var6[1]

			_.each(var3:GetShips(true), function(arg0)
				arg0:AddBuff(var7, 1)
			end)
		elseif var5 == WorldMapAttachment.EffectEventAchieveCarry then
			_.each(var6, function(arg0)
				local var0 = WorldCarryItem.New()

				var0:Setup(arg0)
				var3:AddCarry(var0)
			end)
		elseif var5 == WorldMapAttachment.EffectEventConsumeCarry then
			local var8 = var6[1] or {}

			_.each(var8, function(arg0)
				var3:RemoveCarry(arg0)
			end)
		elseif var5 == WorldMapAttachment.EffectEventConsumeItem then
			var1:GetInventoryProxy():RemoveItem(var6[1], var6[2])
		elseif var5 == WorldMapAttachment.EffectEventDropTreasure then
			var1.treasureCount = var1.treasureCount + 1
		elseif var5 == WorldMapAttachment.EffectEventFOV then
			var2:EventEffectOpenFOV(var4)
		elseif var5 == WorldMapAttachment.EffectEventProgress then
			local var9 = math.max(var1:GetProgress(), var6[1])

			var1:UpdateProgress(var9)
		elseif var5 == WorldMapAttachment.EffectEventDeleteTask then
			local var10 = var1:GetTaskProxy()

			for iter0, iter1 in ipairs(var6) do
				var10:deleteTask(iter1)
			end
		elseif var5 == WorldMapAttachment.EffectEventGlobalBuff then
			var1:AddGlobalBuff(var6[1], var6[2])
		elseif var5 == WorldMapAttachment.EffectEventMapClearFlag then
			var2:UpdateClearFlag(var6[1] == 1)
		elseif var5 == WorldMapAttachment.EffectEventBrokenClean then
			for iter2, iter3 in ipairs(var1:GetShips()) do
				if iter3:IsBroken() then
					iter3:RemoveBuff(WorldConst.BrokenBuffId)
				end
			end
		elseif var5 == WorldMapAttachment.EffectEventCatSalvage then
			-- block empty
		elseif var5 == WorldMapAttachment.EffectEventAddWorldBossFreeCount then
			nowWorld():GetBossProxy():AddSummonFree(1)
		end

		if #var4.sound_effects > 0 then
			pg.CriMgr.GetInstance():PlaySoundEffect_V3("event:" .. var4.sound_effects)
		end
	elseif arg0.op == WorldConst.OpReqDiscover then
		_.each(arg0.locations, function(arg0)
			var2:GetCell(arg0.row, arg0.column):UpdateDiscovered(true)
		end)
		_.each(arg0.hiddenAttachments, function(arg0)
			arg0:UpdateLurk(false)
		end)
	elseif arg0.op == WorldConst.OpReqTransport then
		assert(arg0.destMapId and arg0.destMapId > 0)
		var0:NetUpdateActiveMap(arg0.entranceId, arg0.destMapId, arg0.destGridId)

		local var11 = var1:TreasureMap2ItemId(arg0.destMapId, arg0.entranceId)

		if var11 then
			var1:GetInventoryProxy():RemoveItem(var11, 1)
		end
	elseif arg0.op == WorldConst.OpReqSub then
		var1:ResetSubmarine()
		var1:UpdateSubmarineSupport(true)

		local var12 = var1:GetActiveMap()
	elseif arg0.op == WorldConst.OpReqPressingMap then
		local var13 = arg0.arg1

		var1:FlagMapPressingAward(var13)
		var1:GetAtlas():AddPressingMap(var13)

		local var14 = var1:GetMap(var13)

		if not var14.visionFlag and nowWorld():IsMapVisioned(var13) then
			var14:UpdateVisionFlag(true)
		end
	elseif arg0.op == WorldConst.OpReqJumpOut then
		assert(arg0.destMapId and arg0.destMapId > 0)

		local var15 = pg.world_chapter_template_reset[var2.gid].reset_item
		local var16 = var1:GetInventoryProxy()

		_.each(var15, function(arg0)
			var16:RemoveItem(arg0)
		end)
		var0:NetUpdateActiveMap(arg0.entranceId, arg0.destMapId, arg0.destGridId)

		var2 = var1:GetActiveMap()
	elseif arg0.op == WorldConst.OpReqEnterPort then
		-- block empty
	elseif arg0.op == WorldConst.OpReqCatSalvage then
		var2:GetFleet(arg0.id):UpdateCatSalvage(0, nil, 0)
	elseif arg0.op == WorldConst.OpReqSkipBattle then
		var2:WriteBack(true, {
			statistics = {},
			hpDropInfo = {}
		})
	elseif arg0.op == WorldConst.OpActionFleetMove then
		local var17 = arg0.path[#arg0.path]

		var2:UpdateFleetLocation(arg0.id, var17.row, var17.column)

		var1.stepCount = var1.stepCount + #arg0.path
	elseif arg0.op == WorldConst.OpActionMoveStep then
		arg0:ApplyAttachmentUpdate()
		_.each(arg0.hiddenCells, function(arg0)
			arg0:UpdateDiscovered(true)
		end)

		local var18 = var2:GetFleet(arg0.id)
		local var19 = var2:GetCell(var18.row, var18.column):GetEventAttachment()

		if var19 and var19:IsTriggered() then
			var19.triggered = false
		end

		if arg0.updateCarryItems and #arg0.updateCarryItems > 0 then
			local var20 = var18:GetCarries()

			assert(#var20 == #arg0.updateCarryItems)

			for iter4, iter5 in ipairs(var20) do
				iter5:UpdateOffset(arg0.updateCarryItems[iter4].offsetRow, arg0.updateCarryItems[iter4].offsetColumn)
			end

			WPool:ReturnArray(arg0.updateCarryItems)

			arg0.updateCarryItems = nil
		end

		var2:UpdateFleetLocation(arg0.id, arg0.pos.row, arg0.pos.column)
		_.each(arg0.hiddenAttachments, function(arg0)
			arg0:UpdateLurk(false)
		end)
	elseif arg0.op == WorldConst.OpActionAttachmentMove then
		assert(#arg0.path > 0)

		local var21 = arg0.attachment:Clone()
		local var22 = arg0.path[#arg0.path]

		var2:GetCell(arg0.attachment.row, arg0.attachment.column):RemoveAttachment(arg0.attachment)

		local var23 = var2:GetCell(var22.row, var22.column)

		assert(var23, "dest cell not exist: " .. var22.row .. ", " .. var22.column)

		var21.row = var22.row
		var21.column = var22.column

		var23:AddAttachment(var21)
	elseif arg0.op == WorldConst.OpActionEventOp then
		local var24 = arg0.effect

		if var24.effect_type == WorldMapAttachment.EffectEventFOV then
			var2:EventEffectOpenFOV(var24)
		end

		arg0.attachment:UpdateDataOp(arg0.attachment.dataop - 1)
	elseif arg0.op == WorldConst.OpActionTaskGoto then
		local var25 = arg0.effect

		if var25.effect_type == WorldMapAttachment.EffectEventFOV then
			var2:EventEffectOpenFOV(var25)
		end
	end

	if arg0.childOps then
		_.each(arg0.childOps, function(arg0)
			if not arg0.applied then
				arg0:Apply()
			end
		end)
	end

	if arg0.stepOps then
		_.each(arg0.stepOps, function(arg0)
			if not arg0.applied then
				arg0:Apply()
			end
		end)
	end

	arg0:ApplyAttachmentUpdate()
	arg0:ApplyNetUpdate()

	if arg0.callbacksWhenApplied then
		_.each(arg0.callbacksWhenApplied, function(arg0)
			arg0()
		end)
	end
end

function var0.ApplyAttachmentUpdate(arg0)
	local var0 = getProxy(WorldProxy)
	local var1 = nowWorld():GetActiveMap()

	if arg0.updateAttachmentCells then
		var0:UpdateMapAttachmentCells(var1.id, arg0.updateAttachmentCells)

		for iter0, iter1 in pairs(arg0.updateAttachmentCells) do
			local var2 = var1:GetCell(iter1.pos.row, iter1.pos.column)

			_.each(iter1.attachmentList, function(arg0)
				if not var2:ContainsAttachment(arg0) then
					WPool:Return(arg0)
				end
			end)
		end

		arg0.updateAttachmentCells = nil
	end
end

function var0.ApplyNetUpdate(arg0)
	local var0 = getProxy(WorldProxy)
	local var1 = nowWorld()
	local var2 = var1:GetActiveMap()

	if arg0.staminaUpdate then
		var1.staminaMgr:ChangeStamina(arg0.staminaUpdate[1], arg0.staminaUpdate[2])

		arg0.staminaUpdate = nil
	end

	if arg0.shipUpdates and #arg0.shipUpdates > 0 then
		var0:ApplyShipUpdate(arg0.shipUpdates)
		WPool:ReturnArray(arg0.shipUpdates)

		arg0.shipUpdates = nil
	end

	if arg0.fleetAttachUpdates and #arg0.fleetAttachUpdates > 0 then
		var0:ApplyFleetAttachUpdate(var2.id, arg0.fleetAttachUpdates)
		WPool:ReturnArray(arg0.fleetAttachUpdates)

		arg0.fleetAttachUpdates = nil
	end

	if arg0.fleetUpdates and #arg0.fleetUpdates > 0 then
		var0:ApplyFleetUpdate(var2.id, arg0.fleetUpdates)
		WPool:ReturnArray(arg0.fleetUpdates)

		arg0.fleetUpdates = nil
	end

	if arg0.terrainUpdates and #arg0.terrainUpdates > 0 then
		var0:ApplyTerrainUpdate(var2.id, arg0.terrainUpdates)
		WPool:ReturnArray(arg0.terrainUpdates)

		arg0.terrainUpdates = nil
	end

	if arg0.salvageUpdates and #arg0.salvageUpdates > 0 then
		var0:ApplySalvageUpdate(arg0.salvageUpdates)
		WPool:ReturnArray(arg0.salvageUpdates)

		arg0.salvageUpdates = nil
	end
end

function var0.AddCallbackWhenApplied(arg0, arg1)
	if not arg0.callbacksWhenApplied then
		arg0.callbacksWhenApplied = {}
	end

	table.insert(arg0.callbacksWhenApplied, arg1)
end

return var0
