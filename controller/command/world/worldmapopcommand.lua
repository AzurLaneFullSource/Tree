local var0 = class("WorldMapOpCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	assert(var0.class == WorldMapOp, "command parameter should be type of WorldMapOp")
	pg.ConnectionMgr.GetInstance():Send(33103, {
		act = var0.op,
		group_id = var0.id or 0,
		act_arg_1 = var0.arg1,
		act_arg_2 = var0.arg2,
		pos_list = var0.locations or {}
	}, 33104, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(WorldProxy)
			local var1 = nowWorld():GetActiveMap()

			assert(var1, "active map not exist.")

			var0.drops = PlayerConst.addTranDrop(arg0.drop_list)
			var0.updateAttachmentCells = var0:NetBuildMapAttachmentCells(arg0.pos_list)
			var0.fleetAttachUpdates = var0:NetBuildFleetAttachUpdate(arg0.pos_list)
			var0.terrainUpdates = var0:NetBulidTerrainUpdate(arg0.land_list)
			var0.fleetUpdates = var0:NetBuildFleetUpdate(arg0.group_update)
			var0.shipUpdates = var0:NetBuildShipUpdate(arg0.ship_update)
			var0.salvageUpdates = var0:NetBuildSalvageUpdate(arg0.cmd_collection_list)

			WorldConst.DebugPrintAttachmentCell("Op is " .. var0.op, var0.updateAttachmentCells)
			var0:NetUpdateAchievements(arg0.target_list)

			if var0.op == WorldConst.OpReqMoveFleet then
				arg0:BuildFleetMove(arg0.move_path, var0)
			elseif var0.op == WorldConst.OpReqRetreat then
				var0.childOps = arg0:BuildAIAction(arg0)
			elseif var0.op == WorldConst.OpReqEvent then
				local var2 = var0.effect
				local var3 = var2.effect_type
				local var4 = var2.effect_paramater

				if var3 == WorldMapAttachment.EffectEventTeleport or var3 == WorldMapAttachment.EffectEventTeleportBack then
					arg0:BuildTransfer(arg0, var0)
				elseif var3 == WorldMapAttachment.EffectEventProgress then
					var0.childOps = arg0:BuildProgressAction(var4[1])
				elseif var3 == WorldMapAttachment.EffectEventBlink1 or var3 == WorldMapAttachment.EffectEventBlink2 then
					var0.childOps = arg0:BuildBlinkAction(var0.attachment, var0.updateAttachmentCells)
				end
			elseif var0.op == WorldConst.OpReqTransport then
				arg0:BuildTransfer(arg0, var0)
			elseif var0.op == WorldConst.OpReqJumpOut then
				arg0:BuildTransfer(arg0, var0)
			elseif var0.op == WorldConst.OpReqRound then
				var0.childOps = arg0:BuildAIAction(arg0)
			elseif var0.op == WorldConst.OpReqBox then
				-- block empty
			end
		else
			if arg0.result == 130 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_stamina_not_enough"))
			elseif var0.op == WorldConst.OpReqRetreat then
				pg.TipsMgr.GetInstance():ShowTips(i18n("no_way_to_escape"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("world_map_op_error_", arg0.result))
			end

			if var0.op == WorldConst.OpReqEvent then
				WorldConst.Print(var0.attachment:DebugPrint())
			end
		end

		arg0:sendNotification(GAME.WORLD_MAP_OP_DONE, {
			result = arg0.result,
			mapOp = var0
		})
	end)
end

function var0.BuildAIAction(arg0, arg1)
	local var0 = {}
	local var1 = getProxy(WorldProxy)

	for iter0, iter1 in ipairs(arg1.ai_act_list) do
		local var2 = {}

		if iter1.type == WorldMapAttachment.TypeFleet then
			var2 = arg0:BuildFleetAction(iter1)
		elseif iter1.type == WorldMapAttachment.TypeTrap then
			var2 = arg0:BuildTrapAction(iter1)
		else
			var2 = arg0:BuildAttachmentAction(iter1)
		end

		var2[#var2].shipUpdates = var1:NetBuildShipUpdate(iter1.ship_update)
		var2[#var2].fleetAttachUpdates = var1:NetBuildFleetAttachUpdate(iter1.pos_list)
		var0 = table.mergeArray(var0, var2)
	end

	return var0
end

function var0.BuildTransfer(arg0, arg1, arg2)
	arg2.entranceId = arg1.enter_map_id
	arg2.destMapId = arg1.id.random_id
	arg2.destGridId = arg1.id.template_id
	arg2.staminaUpdate = {
		arg1.action_power,
		arg1.action_power_extra
	}
end

function var0.BuildFleetMove(arg0, arg1, arg2)
	local var0 = {}

	if #arg1 > 0 then
		local var1 = nowWorld():GetActiveMap()
		local var2 = var1:GetFleet()
		local var3 = arg2.updateAttachmentCells

		arg2.updateAttachmentCells = {}
		var0 = table.mergeArray(var0, arg0:BuildFleetMoveAction(arg1, var1, var2.id, var2.row, var2.column, var3, true))
	elseif arg2.trap == WorldBuff.TrapVortex then
		local var4 = WBank:Fetch(WorldMapOp)

		var4.op = WorldConst.OpActionFleetAnim
		var4.id = arg2.id
		var4.anim = WorldConst.ActionYun
		var4.duration = 2

		table.insert(var0, var4)
	end

	arg2.path = _.rest(arg1, 1)
	arg2.childOps = var0
end

function var0.BuildFleetPath(arg0, arg1, arg2, arg3, arg4)
	local var0 = nowWorld():GetActiveMap()
	local var1 = var0:GetFleet(arg3.id)

	_.each(arg1, function(arg0)
		arg0.duration = arg0.duration * var1:GetStepDurationRate()
	end)

	local var2 = {}
	local var3 = {}
	local var4 = {}
	local var5 = var1:GetCarries()
	local var6 = _.map(var5, function(arg0)
		return var1:BuildCarryPath(arg0, arg2, arg1)
	end)

	_.each(arg1, function(arg0)
		local var0 = WBank:Fetch(WorldMapOp)

		var0.op = WorldConst.OpActionMoveStep
		var0.id = arg3.id
		var0.pos = {
			row = arg0.row,
			column = arg0.column
		}
		var0.updateAttachmentCells = {}
		var0.hiddenCells = {}
		var0.hiddenAttachments = {}

		if #var5 > 0 then
			var0.updateCarryItems = {}

			for iter0, iter1 in ipairs(var5) do
				local var1 = var6[#var0.updateCarryItems + 1]
				local var2 = WPool:Get(WorldCarryItem)

				var2:Setup(iter1.id)
				var2:UpdateOffset(var1[#var2 + 1].row - arg0.row, var1[#var2 + 1].column - arg0.column)
				table.insert(var0.updateCarryItems, var2)
			end
		end

		local var3 = var0.theme
		local var4 = var0:GetFOVRange(var1, arg0.row, arg0.column)

		for iter2 = arg0.row - var4, arg0.row + var4 do
			for iter3 = arg0.column - var4, arg0.column + var4 do
				local var5 = var0:GetCell(iter2, iter3)
				local var6 = iter2 .. "_" .. iter3

				if var5 and not var5.discovered and WorldConst.InFOVRange(arg0.row, arg0.column, iter2, iter3, var4) and not var3[var6] then
					var3[var6] = true

					table.insert(var0.hiddenCells, var5)
					table.insert(var4, {
						row = var5.row,
						column = var5.column
					})
					_.each(var5.attachments, function(arg0)
						if arg0:ShouldMarkAsLurk() then
							table.insert(var0.hiddenAttachments, arg0)
						end
					end)

					local var7 = WorldMapCell.GetName(var5.row, var5.column)

					if arg4[var7] then
						_.each(arg4[var7].attachmentList, function(arg0)
							if arg0:ShouldMarkAsLurk() then
								table.insert(var0.hiddenAttachments, arg0)
							end
						end)

						var0.updateAttachmentCells[var7] = arg4[var7]
						arg4[var7] = nil
					end
				end
			end
		end

		table.insert(var2, var0)
	end)

	arg3.stepOps = var2
	arg3.path = arg1
	arg3.pos = {
		row = arg2.row,
		column = arg2.column
	}
	arg3.locations = var4
end

function var0.BuildFleetAction(arg0, arg1)
	local var0 = nowWorld():GetActiveMap()
	local var1 = var0:FindFleet(arg1.ai_pos.row, arg1.ai_pos.column)

	assert(var1, "fleet not exist at: " .. arg1.ai_pos.column .. ", " .. arg1.ai_pos.column)

	local var2 = getProxy(WorldProxy):NetBuildMapAttachmentCells(arg1.pos_list)
	local var3

	if #arg1.move_path > 0 then
		var3 = arg0:BuildFleetMoveAction(arg1.move_path, var0, var1.id, var1.row, var1.column, var2)
	else
		local var4 = WBank:Fetch(WorldMapOp)

		var4.op = WorldConst.OpActionUpdate
		var4.updateAttachmentCells = var2
		var3 = {
			var4
		}
	end

	return var3
end

function var0.BuildFleetMoveAction(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7)
	local var0 = {}
	local var1 = arg7 and WorldMapCell.TerrainNone or arg2:GetCell(arg4, arg5):GetTerrain()
	local var2 = arg2:GetCell(arg4, arg5).terrainStrong
	local var3 = {
		row = arg4,
		column = arg5
	}
	local var4 = 0
	local var5 = {}

	for iter0, iter1 in ipairs(arg1) do
		local var6 = arg2:GetCell(iter1.row, iter1.column)
		local var7 = var6:GetTerrain()

		table.insert(var5, {
			row = iter1.row,
			column = iter1.column,
			terrain = var1,
			duration = WorldConst.GetTerrainMoveStepDuration(var1)
		})

		local var8
		local var9
		local var10

		if var1 == WorldMapCell.TerrainWind and var4 + var2 > #var5 then
			var8 = true
		elseif var1 ~= var7 then
			var9 = true
		elseif var7 == WorldMapCell.TerrainWind then
			var10 = true
		end

		if iter0 == #arg1 or var9 then
			var4 = 0

			local var11 = WBank:Fetch(WorldMapOp)

			var11.op = WorldConst.OpActionFleetMove
			var11.id = arg3
			var11.arg1 = iter1.row
			var11.arg2 = iter1.column

			arg0:BuildFleetPath(var5, var3, var11, arg6)

			if iter0 == #arg1 then
				var11.updateAttachmentCells = arg6
			end

			table.insert(var0, var11)

			var5, var3 = {}, {
				row = iter1.row,
				column = iter1.column
			}
		elseif var10 then
			var4 = var4 + var2
		end

		if var8 then
			-- block empty
		else
			var1 = var7
			var2 = var6.terrainStrong
		end
	end

	return var0
end

function var0.BuildAttachmentAction(arg0, arg1)
	local var0 = nowWorld():GetActiveMap()
	local var1 = arg1.ai_pos.row
	local var2 = arg1.ai_pos.column
	local var3 = var0:GetCell(var1, var2):FindAliveAttachment(WorldMapAttachment.TypeEnemyAI)

	assert(var3, "attachment not exist at: " .. var1 .. ", " .. var2)

	local var4 = {}
	local var5 = WBank:Fetch(WorldMapOp)

	var5.op = WorldConst.OpActionCameraMove
	var5.attachment = var3

	table.insert(var4, var5)

	local var6 = WBank:Fetch(WorldMapOp)

	var6.updateAttachmentCells = getProxy(WorldProxy):NetBuildMapAttachmentCells(arg1.pos_list)

	if #arg1.move_path > 0 then
		var6.op = WorldConst.OpActionAttachmentMove
		var6.attachment = var3

		arg0:BuildAttachmentActionPath(arg1.move_path, var6)
	else
		var6.op = WorldConst.OpActionUpdate
	end

	table.insert(var4, var6)

	return var4
end

function var0.BuildAttachmentActionPath(arg0, arg1, arg2)
	local var0 = nowWorld():GetActiveMap()

	assert(var0, "active map not exist.")

	arg2.path = underscore.map(arg1, function(arg0)
		return {
			row = arg0.row,
			column = arg0.column,
			duration = WorldConst.GetTerrainMoveStepDuration(WorldMapCell.TerrainNone)
		}
	end)
	arg2.pos = {
		row = arg2.attachment.row,
		column = arg2.attachment.column
	}
end

function var0.BuildTrapAction(arg0, arg1)
	local var0 = nowWorld():GetActiveMap()
	local var1 = arg1.ai_pos.row
	local var2 = arg1.ai_pos.column
	local var3 = var0:GetCell(var1, var2):FindAliveAttachment(WorldMapAttachment.TypeTrap)

	assert(var3, "attachment not exist at: " .. var1 .. ", " .. var2)

	local var4 = {}
	local var5 = WBank:Fetch(WorldMapOp)

	var5.op = WorldConst.OpActionCameraMove
	var5.attachment = var3

	table.insert(var4, var5)

	local var6 = WBank:Fetch(WorldMapOp)

	var6.op = WorldConst.OpActionTrapGravityAnim
	var6.attachment = var3

	table.insert(var4, var6)

	return var4
end

function var0.BuildBlinkAction(arg0, arg1, arg2)
	local var0 = {}
	local var1 = arg1:GetSpEventType()
	local var2 = arg2[WorldMapCell.GetName(arg1.row, arg1.column)]
	local var3

	for iter0, iter1 in pairs(arg2) do
		if _.any(iter1.attachmentList, function(arg0)
			return arg0.type == arg1.type and arg0.id == arg1.id
		end) then
			var3 = iter1

			break
		end
	end

	if var1 == WorldMapAttachment.SpEventHaibao then
		local var4 = WBank:Fetch(WorldMapOp)

		var4.op = WorldConst.OpActionAttachmentAnim
		var4.attachment = arg1
		var4.anim = WorldConst.ActionVanish
		var4.updateAttachmentCells = {
			[WorldMapCell.GetName(var2.pos.row, var2.pos.column)] = var2,
			[WorldMapCell.GetName(var3.pos.row, var3.pos.column)] = var3
		}
		arg2[WorldMapCell.GetName(var2.pos.row, var2.pos.column)] = nil
		arg2[WorldMapCell.GetName(var3.pos.row, var3.pos.column)] = nil

		table.insert(var0, var4)

		local var5 = WBank:Fetch(WorldMapOp)

		var5.op = WorldConst.OpActionAttachmentAnim
		var5.attachment = _.detect(var3.attachmentList, function(arg0)
			return arg0.type == arg1.type and arg0.id == arg1.id
		end)
		var5.anim = WorldConst.ActionAppear

		table.insert(var0, var5)
	elseif var1 == WorldMapAttachment.SpEventFufen then
		local var6, var7 = nowWorld():GetActiveMap():FindAIPath({
			row = arg1.row,
			column = arg1.column
		}, {
			row = var3.pos.row,
			column = var3.pos.column
		})

		if var6 < PathFinding.PrioObstacle then
			local var8 = WBank:Fetch(WorldMapOp)

			var8.op = WorldConst.OpActionAttachmentMove
			var8.attachment = arg1

			arg0:BuildAttachmentActionPath(var7, var8)
			table.insert(var0, var8)
		end
	end

	return var0
end

function var0.BuildProgressAction(arg0, arg1)
	local var0 = {}
	local var1 = nowWorld()
	local var2 = var1:GetRealm()

	if arg1 > var1:GetProgress() then
		local var3 = WorldConst.FindStageTemplates(arg1)

		_.each(var3, function(arg0)
			if arg0 and #arg0.stage_effect[var2] > 0 then
				_.each(arg0.stage_effect[var2], function(arg0)
					local var0 = pg.world_effect_data[arg0]

					assert(var0, "world_effect_data not exist: " .. arg0)

					local var1 = WBank:Fetch(WorldMapOp)

					var1.op = WorldConst.OpActionEventEffect
					var1.effect = var0

					table.insert(var0, var1)
				end)
			end
		end)
	end

	return var0
end

return var0
