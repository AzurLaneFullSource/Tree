local var0_0 = class("WorldMapOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	assert(var0_1.class == WorldMapOp, "command parameter should be type of WorldMapOp")
	pg.ConnectionMgr.GetInstance():Send(33103, {
		act = var0_1.op,
		group_id = var0_1.id or 0,
		act_arg_1 = var0_1.arg1,
		act_arg_2 = var0_1.arg2,
		pos_list = var0_1.locations or {}
	}, 33104, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(WorldProxy)
			local var1_2 = nowWorld():GetActiveMap()

			assert(var1_2, "active map not exist.")

			var0_1.drops = PlayerConst.addTranDrop(arg0_2.drop_list)
			var0_1.updateAttachmentCells = var0_2:NetBuildMapAttachmentCells(arg0_2.pos_list)
			var0_1.fleetAttachUpdates = var0_2:NetBuildFleetAttachUpdate(arg0_2.pos_list)
			var0_1.terrainUpdates = var0_2:NetBulidTerrainUpdate(arg0_2.land_list)
			var0_1.fleetUpdates = var0_2:NetBuildFleetUpdate(arg0_2.group_update)
			var0_1.shipUpdates = var0_2:NetBuildShipUpdate(arg0_2.ship_update)
			var0_1.salvageUpdates = var0_2:NetBuildSalvageUpdate(arg0_2.cmd_collection_list)

			WorldConst.DebugPrintAttachmentCell("Op is " .. var0_1.op, var0_1.updateAttachmentCells)
			var0_2:NetUpdateAchievements(arg0_2.target_list)

			if var0_1.op == WorldConst.OpReqMoveFleet then
				arg0_1:BuildFleetMove(arg0_2.move_path, var0_1)
			elseif var0_1.op == WorldConst.OpReqRetreat then
				var0_1.childOps = arg0_1:BuildAIAction(arg0_2)
			elseif var0_1.op == WorldConst.OpReqEvent then
				local var2_2 = var0_1.effect
				local var3_2 = var2_2.effect_type
				local var4_2 = var2_2.effect_paramater

				if var3_2 == WorldMapAttachment.EffectEventTeleport or var3_2 == WorldMapAttachment.EffectEventTeleportBack then
					arg0_1:BuildTransfer(arg0_2, var0_1)
				elseif var3_2 == WorldMapAttachment.EffectEventProgress then
					var0_1.childOps = arg0_1:BuildProgressAction(var4_2[1])
				elseif var3_2 == WorldMapAttachment.EffectEventBlink1 or var3_2 == WorldMapAttachment.EffectEventBlink2 then
					var0_1.childOps = arg0_1:BuildBlinkAction(var0_1.attachment, var0_1.updateAttachmentCells)
				end
			elseif var0_1.op == WorldConst.OpReqTransport then
				arg0_1:BuildTransfer(arg0_2, var0_1)
			elseif var0_1.op == WorldConst.OpReqJumpOut then
				arg0_1:BuildTransfer(arg0_2, var0_1)
			elseif var0_1.op == WorldConst.OpReqRound then
				var0_1.childOps = arg0_1:BuildAIAction(arg0_2)
			elseif var0_1.op == WorldConst.OpReqBox then
				-- block empty
			end
		else
			if arg0_2.result == 130 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("world_stamina_not_enough"))
			elseif var0_1.op == WorldConst.OpReqRetreat then
				pg.TipsMgr.GetInstance():ShowTips(i18n("no_way_to_escape"))
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("world_map_op_error_", arg0_2.result))
			end

			if var0_1.op == WorldConst.OpReqEvent then
				WorldConst.Print(var0_1.attachment:DebugPrint())
			end
		end

		arg0_1:sendNotification(GAME.WORLD_MAP_OP_DONE, {
			result = arg0_2.result,
			mapOp = var0_1
		})
	end)
end

function var0_0.BuildAIAction(arg0_3, arg1_3)
	local var0_3 = {}
	local var1_3 = getProxy(WorldProxy)

	for iter0_3, iter1_3 in ipairs(arg1_3.ai_act_list) do
		local var2_3 = {}

		if iter1_3.type == WorldMapAttachment.TypeFleet then
			var2_3 = arg0_3:BuildFleetAction(iter1_3)
		elseif iter1_3.type == WorldMapAttachment.TypeTrap then
			var2_3 = arg0_3:BuildTrapAction(iter1_3)
		else
			var2_3 = arg0_3:BuildAttachmentAction(iter1_3)
		end

		var2_3[#var2_3].shipUpdates = var1_3:NetBuildShipUpdate(iter1_3.ship_update)
		var2_3[#var2_3].fleetAttachUpdates = var1_3:NetBuildFleetAttachUpdate(iter1_3.pos_list)
		var0_3 = table.mergeArray(var0_3, var2_3)
	end

	return var0_3
end

function var0_0.BuildTransfer(arg0_4, arg1_4, arg2_4)
	arg2_4.entranceId = arg1_4.enter_map_id
	arg2_4.destMapId = arg1_4.id.random_id
	arg2_4.destGridId = arg1_4.id.template_id
	arg2_4.staminaUpdate = {
		arg1_4.action_power,
		arg1_4.action_power_extra
	}
end

function var0_0.BuildFleetMove(arg0_5, arg1_5, arg2_5)
	local var0_5 = {}

	if #arg1_5 > 0 then
		local var1_5 = nowWorld():GetActiveMap()
		local var2_5 = var1_5:GetFleet()
		local var3_5 = arg2_5.updateAttachmentCells

		arg2_5.updateAttachmentCells = {}
		var0_5 = table.mergeArray(var0_5, arg0_5:BuildFleetMoveAction(arg1_5, var1_5, var2_5.id, var2_5.row, var2_5.column, var3_5, true))
	elseif arg2_5.trap == WorldBuff.TrapVortex then
		local var4_5 = WBank:Fetch(WorldMapOp)

		var4_5.op = WorldConst.OpActionFleetAnim
		var4_5.id = arg2_5.id
		var4_5.anim = WorldConst.ActionYun
		var4_5.duration = 2

		table.insert(var0_5, var4_5)
	end

	arg2_5.path = _.rest(arg1_5, 1)
	arg2_5.childOps = var0_5
end

function var0_0.BuildFleetPath(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	local var0_6 = nowWorld():GetActiveMap()
	local var1_6 = var0_6:GetFleet(arg3_6.id)

	_.each(arg1_6, function(arg0_7)
		arg0_7.duration = arg0_7.duration * var1_6:GetStepDurationRate()
	end)

	local var2_6 = {}
	local var3_6 = {}
	local var4_6 = {}
	local var5_6 = var1_6:GetCarries()
	local var6_6 = _.map(var5_6, function(arg0_8)
		return var1_6:BuildCarryPath(arg0_8, arg2_6, arg1_6)
	end)

	_.each(arg1_6, function(arg0_9)
		local var0_9 = WBank:Fetch(WorldMapOp)

		var0_9.op = WorldConst.OpActionMoveStep
		var0_9.id = arg3_6.id
		var0_9.pos = {
			row = arg0_9.row,
			column = arg0_9.column
		}
		var0_9.updateAttachmentCells = {}
		var0_9.hiddenCells = {}
		var0_9.hiddenAttachments = {}

		if #var5_6 > 0 then
			var0_9.updateCarryItems = {}

			for iter0_9, iter1_9 in ipairs(var5_6) do
				local var1_9 = var6_6[#var0_9.updateCarryItems + 1]
				local var2_9 = WPool:Get(WorldCarryItem)

				var2_9:Setup(iter1_9.id)
				var2_9:UpdateOffset(var1_9[#var2_6 + 1].row - arg0_9.row, var1_9[#var2_6 + 1].column - arg0_9.column)
				table.insert(var0_9.updateCarryItems, var2_9)
			end
		end

		local var3_9 = var0_6.theme
		local var4_9 = var0_6:GetFOVRange(var1_6, arg0_9.row, arg0_9.column)

		for iter2_9 = arg0_9.row - var4_9, arg0_9.row + var4_9 do
			for iter3_9 = arg0_9.column - var4_9, arg0_9.column + var4_9 do
				local var5_9 = var0_6:GetCell(iter2_9, iter3_9)
				local var6_9 = iter2_9 .. "_" .. iter3_9

				if var5_9 and not var5_9.discovered and WorldConst.InFOVRange(arg0_9.row, arg0_9.column, iter2_9, iter3_9, var4_9) and not var3_6[var6_9] then
					var3_6[var6_9] = true

					table.insert(var0_9.hiddenCells, var5_9)
					table.insert(var4_6, {
						row = var5_9.row,
						column = var5_9.column
					})
					_.each(var5_9.attachments, function(arg0_10)
						if arg0_10:ShouldMarkAsLurk() then
							table.insert(var0_9.hiddenAttachments, arg0_10)
						end
					end)

					local var7_9 = WorldMapCell.GetName(var5_9.row, var5_9.column)

					if arg4_6[var7_9] then
						_.each(arg4_6[var7_9].attachmentList, function(arg0_11)
							if arg0_11:ShouldMarkAsLurk() then
								table.insert(var0_9.hiddenAttachments, arg0_11)
							end
						end)

						var0_9.updateAttachmentCells[var7_9] = arg4_6[var7_9]
						arg4_6[var7_9] = nil
					end
				end
			end
		end

		table.insert(var2_6, var0_9)
	end)

	arg3_6.stepOps = var2_6
	arg3_6.path = arg1_6
	arg3_6.pos = {
		row = arg2_6.row,
		column = arg2_6.column
	}
	arg3_6.locations = var4_6
end

function var0_0.BuildFleetAction(arg0_12, arg1_12)
	local var0_12 = nowWorld():GetActiveMap()
	local var1_12 = var0_12:FindFleet(arg1_12.ai_pos.row, arg1_12.ai_pos.column)

	assert(var1_12, "fleet not exist at: " .. arg1_12.ai_pos.column .. ", " .. arg1_12.ai_pos.column)

	local var2_12 = getProxy(WorldProxy):NetBuildMapAttachmentCells(arg1_12.pos_list)
	local var3_12

	if #arg1_12.move_path > 0 then
		var3_12 = arg0_12:BuildFleetMoveAction(arg1_12.move_path, var0_12, var1_12.id, var1_12.row, var1_12.column, var2_12)
	else
		local var4_12 = WBank:Fetch(WorldMapOp)

		var4_12.op = WorldConst.OpActionUpdate
		var4_12.updateAttachmentCells = var2_12
		var3_12 = {
			var4_12
		}
	end

	return var3_12
end

function var0_0.BuildFleetMoveAction(arg0_13, arg1_13, arg2_13, arg3_13, arg4_13, arg5_13, arg6_13, arg7_13)
	local var0_13 = {}
	local var1_13 = arg7_13 and WorldMapCell.TerrainNone or arg2_13:GetCell(arg4_13, arg5_13):GetTerrain()
	local var2_13 = arg2_13:GetCell(arg4_13, arg5_13).terrainStrong
	local var3_13 = {
		row = arg4_13,
		column = arg5_13
	}
	local var4_13 = 0
	local var5_13 = {}

	for iter0_13, iter1_13 in ipairs(arg1_13) do
		local var6_13 = arg2_13:GetCell(iter1_13.row, iter1_13.column)
		local var7_13 = var6_13:GetTerrain()

		table.insert(var5_13, {
			row = iter1_13.row,
			column = iter1_13.column,
			terrain = var1_13,
			duration = WorldConst.GetTerrainMoveStepDuration(var1_13)
		})

		local var8_13
		local var9_13
		local var10_13

		if var1_13 == WorldMapCell.TerrainWind and var4_13 + var2_13 > #var5_13 then
			var8_13 = true
		elseif var1_13 ~= var7_13 then
			var9_13 = true
		elseif var7_13 == WorldMapCell.TerrainWind then
			var10_13 = true
		end

		if iter0_13 == #arg1_13 or var9_13 then
			var4_13 = 0

			local var11_13 = WBank:Fetch(WorldMapOp)

			var11_13.op = WorldConst.OpActionFleetMove
			var11_13.id = arg3_13
			var11_13.arg1 = iter1_13.row
			var11_13.arg2 = iter1_13.column

			arg0_13:BuildFleetPath(var5_13, var3_13, var11_13, arg6_13)

			if iter0_13 == #arg1_13 then
				var11_13.updateAttachmentCells = arg6_13
			end

			table.insert(var0_13, var11_13)

			var5_13, var3_13 = {}, {
				row = iter1_13.row,
				column = iter1_13.column
			}
		elseif var10_13 then
			var4_13 = var4_13 + var2_13
		end

		if var8_13 then
			-- block empty
		else
			var1_13 = var7_13
			var2_13 = var6_13.terrainStrong
		end
	end

	return var0_13
end

function var0_0.BuildAttachmentAction(arg0_14, arg1_14)
	local var0_14 = nowWorld():GetActiveMap()
	local var1_14 = arg1_14.ai_pos.row
	local var2_14 = arg1_14.ai_pos.column
	local var3_14 = var0_14:GetCell(var1_14, var2_14):FindAliveAttachment(WorldMapAttachment.TypeEnemyAI)

	assert(var3_14, "attachment not exist at: " .. var1_14 .. ", " .. var2_14)

	local var4_14 = {}
	local var5_14 = WBank:Fetch(WorldMapOp)

	var5_14.op = WorldConst.OpActionCameraMove
	var5_14.attachment = var3_14

	table.insert(var4_14, var5_14)

	local var6_14 = WBank:Fetch(WorldMapOp)

	var6_14.updateAttachmentCells = getProxy(WorldProxy):NetBuildMapAttachmentCells(arg1_14.pos_list)

	if #arg1_14.move_path > 0 then
		var6_14.op = WorldConst.OpActionAttachmentMove
		var6_14.attachment = var3_14

		arg0_14:BuildAttachmentActionPath(arg1_14.move_path, var6_14)
	else
		var6_14.op = WorldConst.OpActionUpdate
	end

	table.insert(var4_14, var6_14)

	return var4_14
end

function var0_0.BuildAttachmentActionPath(arg0_15, arg1_15, arg2_15)
	local var0_15 = nowWorld():GetActiveMap()

	assert(var0_15, "active map not exist.")

	arg2_15.path = underscore.map(arg1_15, function(arg0_16)
		return {
			row = arg0_16.row,
			column = arg0_16.column,
			duration = WorldConst.GetTerrainMoveStepDuration(WorldMapCell.TerrainNone)
		}
	end)
	arg2_15.pos = {
		row = arg2_15.attachment.row,
		column = arg2_15.attachment.column
	}
end

function var0_0.BuildTrapAction(arg0_17, arg1_17)
	local var0_17 = nowWorld():GetActiveMap()
	local var1_17 = arg1_17.ai_pos.row
	local var2_17 = arg1_17.ai_pos.column
	local var3_17 = var0_17:GetCell(var1_17, var2_17):FindAliveAttachment(WorldMapAttachment.TypeTrap)

	assert(var3_17, "attachment not exist at: " .. var1_17 .. ", " .. var2_17)

	local var4_17 = {}
	local var5_17 = WBank:Fetch(WorldMapOp)

	var5_17.op = WorldConst.OpActionCameraMove
	var5_17.attachment = var3_17

	table.insert(var4_17, var5_17)

	local var6_17 = WBank:Fetch(WorldMapOp)

	var6_17.op = WorldConst.OpActionTrapGravityAnim
	var6_17.attachment = var3_17

	table.insert(var4_17, var6_17)

	return var4_17
end

function var0_0.BuildBlinkAction(arg0_18, arg1_18, arg2_18)
	local var0_18 = {}
	local var1_18 = arg1_18:GetSpEventType()
	local var2_18 = arg2_18[WorldMapCell.GetName(arg1_18.row, arg1_18.column)]
	local var3_18

	for iter0_18, iter1_18 in pairs(arg2_18) do
		if _.any(iter1_18.attachmentList, function(arg0_19)
			return arg0_19.type == arg1_18.type and arg0_19.id == arg1_18.id
		end) then
			var3_18 = iter1_18

			break
		end
	end

	if var1_18 == WorldMapAttachment.SpEventHaibao then
		local var4_18 = WBank:Fetch(WorldMapOp)

		var4_18.op = WorldConst.OpActionAttachmentAnim
		var4_18.attachment = arg1_18
		var4_18.anim = WorldConst.ActionVanish
		var4_18.updateAttachmentCells = {
			[WorldMapCell.GetName(var2_18.pos.row, var2_18.pos.column)] = var2_18,
			[WorldMapCell.GetName(var3_18.pos.row, var3_18.pos.column)] = var3_18
		}
		arg2_18[WorldMapCell.GetName(var2_18.pos.row, var2_18.pos.column)] = nil
		arg2_18[WorldMapCell.GetName(var3_18.pos.row, var3_18.pos.column)] = nil

		table.insert(var0_18, var4_18)

		local var5_18 = WBank:Fetch(WorldMapOp)

		var5_18.op = WorldConst.OpActionAttachmentAnim
		var5_18.attachment = _.detect(var3_18.attachmentList, function(arg0_20)
			return arg0_20.type == arg1_18.type and arg0_20.id == arg1_18.id
		end)
		var5_18.anim = WorldConst.ActionAppear

		table.insert(var0_18, var5_18)
	elseif var1_18 == WorldMapAttachment.SpEventFufen then
		local var6_18, var7_18 = nowWorld():GetActiveMap():FindAIPath({
			row = arg1_18.row,
			column = arg1_18.column
		}, {
			row = var3_18.pos.row,
			column = var3_18.pos.column
		})

		if var6_18 < PathFinding.PrioObstacle then
			local var8_18 = WBank:Fetch(WorldMapOp)

			var8_18.op = WorldConst.OpActionAttachmentMove
			var8_18.attachment = arg1_18

			arg0_18:BuildAttachmentActionPath(var7_18, var8_18)
			table.insert(var0_18, var8_18)
		end
	end

	return var0_18
end

function var0_0.BuildProgressAction(arg0_21, arg1_21)
	local var0_21 = {}
	local var1_21 = nowWorld()
	local var2_21 = var1_21:GetRealm()

	if arg1_21 > var1_21:GetProgress() then
		local var3_21 = WorldConst.FindStageTemplates(arg1_21)

		_.each(var3_21, function(arg0_22)
			if arg0_22 and #arg0_22.stage_effect[var2_21] > 0 then
				_.each(arg0_22.stage_effect[var2_21], function(arg0_23)
					local var0_23 = pg.world_effect_data[arg0_23]

					assert(var0_23, "world_effect_data not exist: " .. arg0_23)

					local var1_23 = WBank:Fetch(WorldMapOp)

					var1_23.op = WorldConst.OpActionEventEffect
					var1_23.effect = var0_23

					table.insert(var0_21, var1_23)
				end)
			end
		end)
	end

	return var0_21
end

return var0_0
