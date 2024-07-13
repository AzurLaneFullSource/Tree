local var0_0 = class("ChapterAIAction")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.line = {
		row = arg1_1.ai_pos.row,
		column = arg1_1.ai_pos.column
	}
	arg0_1.stgId = arg1_1.strategy_id

	if arg1_1.target_pos then
		arg0_1.stgTarget = {
			row = arg1_1.target_pos.row,
			column = arg1_1.target_pos.column
		}
	end

	arg0_1.movePath = _.map(arg1_1.move_path, function(arg0_2)
		return {
			row = arg0_2.row,
			column = arg0_2.column
		}
	end)
	arg0_1.shipUpdate = _.map(arg1_1.ship_update, function(arg0_3)
		return {
			id = arg0_3.id,
			hpRant = arg0_3.hp_rant
		}
	end)
	arg0_1.cellUpdates = {}

	_.each(arg1_1.map_update, function(arg0_4)
		if arg0_4.item_type ~= ChapterConst.AttachNone and arg0_4.item_type ~= ChapterConst.AttachBorn and arg0_4.item_type ~= ChapterConst.AttachBorn_Sub and (arg0_4.item_type ~= ChapterConst.AttachStory or arg0_4.item_data ~= ChapterConst.StoryTrigger) then
			local var0_4 = arg0_4.item_type == ChapterConst.AttachChampion and ChapterChampionPackage.New(arg0_4) or ChapterCell.New(arg0_4)

			table.insert(arg0_1.cellUpdates, var0_4)
		end
	end)

	arg0_1.actType = arg1_1.act_type
	arg0_1.hp_del = arg1_1.hp_del
end

function var0_0.PlayAIAction(arg0_5, arg1_5, arg2_5, arg3_5)
	local var0_5 = arg1_5:getChapterCell(arg0_5.line.row, arg0_5.line.column)

	if var0_5 and var0_5.attachment == ChapterConst.AttachLandbase and not table.equal(arg0_5.stgTarget, {
		row = 9999,
		columns = 9999
	}) then
		local var1_5 = pg.land_based_template[var0_5.attachmentId]

		if var1_5.type == ChapterConst.LBCoastalGun then
			arg2_5.viewComponent:doPlayAnim("coastalgun", function(arg0_6)
				setActive(arg0_6, false)
				arg3_5()
			end)
		elseif var1_5.type == ChapterConst.LBHarbor then
			if not arg0_5.hp_del or arg0_5.hp_del <= 0 then
				arg3_5()
			end

			arg2_5.viewComponent.grid:PlayAttachmentEffect(var0_5.row, var0_5.column, "huoqiubaozha", Vector2.zero)
			arg3_5()
		elseif var1_5.type == ChapterConst.LBDock then
			arg3_5()
		elseif var1_5.type == ChapterConst.LBAntiAir then
			arg2_5.viewComponent:doPlayAnim("AntiAirFire", function(arg0_7)
				setActive(arg0_7, false)
				arg2_5.viewComponent.grid:PlayAttachmentEffect(arg0_5.stgTarget.row, arg0_5.stgTarget.column, "huoqiubaozha", Vector2.zero, arg3_5)
			end)
		else
			assert(false)
		end

		return
	end

	if arg0_5.stgId > 0 then
		if arg0_5.stgId == ChapterConst.StrategySonarDetect then
			local var2_5 = {}

			_.each(arg0_5.cellUpdates, function(arg0_8)
				if isa(arg0_8, ChapterChampionPackage) then
					table.insert(var2_5, arg0_8)
				end
			end)
			arg2_5.viewComponent.grid:PlaySonarDetectAnim(var2_5, arg3_5)
		else
			assert(false)
		end

		return
	end

	local var3_5 = arg1_5:getChampion(arg0_5.line.row, arg0_5.line.column)
	local var4_5 = arg1_5:getChampionIndex(arg0_5.line.row, arg0_5.line.column)
	local var5_5 = arg0_5.movePath[#arg0_5.movePath] or arg0_5.line

	if var4_5 then
		seriesAsync({
			function(arg0_9)
				if #arg0_5.movePath > 0 then
					arg2_5.viewComponent.grid:moveChampion(var4_5, arg0_5.movePath, Clone(arg0_5.movePath), arg0_9)
				else
					arg0_9()
				end
			end,
			function(arg0_10)
				if #arg0_5.shipUpdate > 0 then
					arg2_5.viewComponent:doPlayEnemyAnim(var3_5, "SubSairenTorpedoUI", arg0_10)
				else
					arg0_10()
				end
			end,
			function(arg0_11)
				local var0_11 = false

				if arg0_5.actType == ChapterConst.ActType_SubmarineHunting and #arg0_5.cellUpdates > 0 then
					_.each(arg0_5.cellUpdates, function(arg0_12)
						if var5_5.row == arg0_12.row and var5_5.column == arg0_12.column and isa(arg0_12, ChapterChampionPackage) then
							arg0_5:TryPlayChampionSubAnim(arg2_5, arg0_12, var3_5, arg0_11)

							var0_11 = true
						end
					end)
				end

				if not var0_11 then
					arg0_11()
				end
			end,
			function(arg0_13)
				arg3_5()
			end
		})

		return
	end

	assert(false)
end

function var0_0.TryPlayChampionSubAnim(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	if (arg2_14.flag == ChapterConst.CellFlagDiving or arg3_14.flag == ChapterConst.CellFlagDiving) and (arg2_14.flag == ChapterConst.CellFlagActive or arg3_14.flag == ChapterConst.CellFlagActive) then
		local var0_14 = arg2_14.flag == ChapterConst.CellFlagDiving

		arg1_14.viewComponent.grid:PlayChampionSubmarineAnimation(arg3_14, var0_14, arg4_14)

		return
	end

	arg4_14()
end

function var0_0.applyTo(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg1_15:getChapterCell(arg0_15.line.row, arg0_15.line.column)

	if var0_15 and var0_15.attachment == ChapterConst.AttachLandbase and not table.equal(arg0_15.stgTarget, {
		row = 9999,
		column = 9999
	}) then
		local var1_15 = pg.land_based_template[var0_15.attachmentId]

		if var1_15.type == ChapterConst.LBCoastalGun then
			return arg0_15:applyToCoastalGun(arg1_15, var0_15, arg2_15)
		elseif var1_15.type == ChapterConst.LBHarbor then
			return arg0_15:applyToHarbor(arg1_15, var0_15, arg2_15)
		elseif var1_15.type == ChapterConst.LBDock then
			return arg0_15:applyToDock(arg1_15, var0_15, arg2_15)
		elseif var1_15.type == ChapterConst.LBAntiAir then
			return arg0_15:applyToAntiAir(arg1_15, var0_15, arg2_15)
		else
			return false, "Trouble with Attach LandBased"
		end
	end

	if arg0_15.stgId > 0 then
		return arg0_15:applyToStrategy(arg1_15, arg0_15.stgId, arg2_15)
	end

	local var2_15 = arg1_15:getChampion(arg0_15.line.row, arg0_15.line.column)

	if var2_15 then
		return arg0_15:applyToChampion(arg1_15, var2_15, arg2_15)
	end

	return false, "can not find any object at: [" .. arg0_15.line.row .. ", " .. arg0_15.line.column .. "]"
end

function var0_0.applyToChampion(arg0_16, arg1_16, arg2_16, arg3_16)
	if arg2_16.flag == ChapterConst.CellFlagDisabled then
		return false, "can not apply ai to dead champion at: [" .. arg0_16.line.row .. ", " .. arg0_16.line.column .. "]"
	end

	local var0_16 = 0
	local var1_16 = 0
	local var2_16 = arg0_16.line

	if arg0_16.stgId > 0 and not pg.strategy_data_template[arg0_16.stgId] then
		return false, "can not find strategy: " .. arg0_16.stgId
	end

	if #arg0_16.movePath > 0 then
		var2_16 = arg0_16.movePath[#arg0_16.movePath]

		if _.any(arg0_16.movePath, function(arg0_17)
			local var0_17 = arg1_16:getChapterCell(arg0_17.row, arg0_17.column)

			return not var0_17 or not var0_17:IsWalkable()
		end) then
			return false, "invalide move path"
		end
	end

	if #arg0_16.shipUpdate > 0 and not arg1_16:getFleet(FleetType.Normal, var2_16.row, var2_16.column) then
		return false, "can not find fleet at: [" .. arg0_16.line.row .. ", " .. arg0_16.line.column .. "]"
	end

	if not arg3_16 then
		if #arg0_16.movePath > 0 then
			arg2_16.row = var2_16.row
			arg2_16.column = var2_16.column
			var0_16 = bit.bor(var0_16, ChapterConst.DirtyChampionPosition)
		end

		if arg1_16:existFleet(FleetType.Submarine, arg2_16.row, arg2_16.column) then
			var0_16 = bit.bor(var0_16, ChapterConst.DirtyFleet)
		end

		if arg0_16.actType == ChapterConst.ActType_SubmarineHunting then
			local var3_16 = arg1_16:getChapterCell(var2_16.row, var2_16.column)

			if var3_16 and var3_16.attachment == ChapterConst.AttachBarrier then
				var3_16.flag = ChapterConst.CellFlagDisabled

				arg1_16:mergeChapterCell(var3_16)

				var0_16 = bit.bor(var0_16, ChapterConst.DirtyAttachment)
			end
		end

		if #arg0_16.shipUpdate > 0 then
			_.each(arg0_16.shipUpdate, function(arg0_18)
				arg1_16:updateFleetShipHp(arg0_18.id, arg0_18.hpRant)
			end)

			var0_16 = bit.bor(var0_16, ChapterConst.DirtyFleet)
		end

		if #arg0_16.cellUpdates > 0 then
			_.each(arg0_16.cellUpdates, function(arg0_19)
				if isa(arg0_19, ChapterChampionPackage) then
					local var0_19 = arg1_16:mergeChampion(arg0_19) and ChapterConst.DirtyChampionPosition or ChapterConst.DirtyChampion

					var0_16 = bit.bor(var0_16, var0_19)
				else
					arg1_16:mergeChapterCell(arg0_19)

					var0_16 = bit.bor(var0_16, ChapterConst.DirtyAttachment)
				end
			end)

			var1_16 = bit.bor(var1_16, ChapterConst.DirtyAutoAction)
		end
	end

	return true, var0_16, var1_16
end

function var0_0.applyToStrategy(arg0_20, arg1_20, arg2_20, arg3_20)
	if not pg.strategy_data_template[arg2_20] then
		return false, "can not find strategy: " .. arg2_20
	end

	local var0_20 = 0

	if not arg3_20 and arg0_20.stgId == ChapterConst.StrategySonarDetect then
		_.each(arg0_20.cellUpdates, function(arg0_21)
			if isa(arg0_21, ChapterChampionPackage) then
				arg1_20:mergeChampion(arg0_21)

				var0_20 = bit.bor(var0_20, ChapterConst.DirtyChampion)
			else
				arg1_20:mergeChapterCell(arg0_21)

				var0_20 = bit.bor(var0_20, ChapterConst.DirtyAttachment)
			end
		end)
	end

	return true, var0_20
end

function var0_0.applyToCoastalGun(arg0_22, arg1_22, arg2_22, arg3_22)
	if arg2_22.flag == ChapterConst.CellFlagDisabled then
		return false, "can not apply ai to dead coastalgun at: [" .. arg0_22.line.row .. ", " .. arg0_22.line.column .. "]"
	end

	local var0_22 = 0
	local var1_22 = 0
	local var2_22 = arg1_22:getFleet(FleetType.Normal, arg0_22.stgTarget.row, arg0_22.stgTarget.column)

	if not var2_22 then
		return false, "can not find fleet at: [" .. arg0_22.stgTarget.row .. ", " .. arg0_22.stgTarget.column .. "]"
	end

	if not arg3_22 then
		var2_22:increaseSlowSpeedFactor()

		var0_22 = bit.bor(var0_22, ChapterConst.DirtyFleet)

		_.each(arg0_22.cellUpdates, function(arg0_23)
			if isa(arg0_23, ChapterChampionPackage) then
				arg1_22:mergeChampion(arg0_23)

				var0_22 = bit.bor(var0_22, ChapterConst.DirtyChampion)
			else
				arg1_22:mergeChapterCell(arg0_23)

				var0_22 = bit.bor(var0_22, ChapterConst.DirtyAttachment)
			end
		end)

		if #arg0_22.cellUpdates > 0 then
			var1_22 = bit.bor(var1_22, ChapterConst.DirtyAutoAction)
		end
	end

	return true, var0_22, var1_22
end

function var0_0.applyToHarbor(arg0_24, arg1_24, arg2_24, arg3_24)
	if arg2_24.flag == ChapterConst.CellFlagDisabled then
		return false, "can not apply ai to dead Harbor at: [" .. arg0_24.line.row .. ", " .. arg0_24.line.column .. "]"
	end

	local var0_24 = 0
	local var1_24 = 0
	local var2_24 = arg1_24:getChampion(arg0_24.stgTarget.row, arg0_24.stgTarget.column)

	if not var2_24 then
		return false, "can not find champion at: [" .. arg0_24.stgTarget.row .. ", " .. arg0_24.stgTarget.column .. "]"
	end

	if not arg3_24 then
		arg1_24.BaseHP = math.max(arg1_24.BaseHP - arg0_24.hp_del, 0)

		arg1_24:RemoveChampion(var2_24)

		var0_24 = bit.bor(var0_24, ChapterConst.DirtyBase, ChapterConst.DirtyChampion)
		var1_24 = bit.bor(var1_24, ChapterConst.DirtyAutoAction)

		if #arg0_24.cellUpdates > 0 then
			_.each(arg0_24.cellUpdates, function(arg0_25)
				if isa(arg0_25, ChapterChampionPackage) then
					local var0_25 = arg1_24:mergeChampion(arg0_25)

					var0_24 = bit.bor(var0_24, ChapterConst.DirtyChampion)
				else
					arg1_24:mergeChapterCell(arg0_25)

					var0_24 = bit.bor(var0_24, ChapterConst.DirtyAttachment)
				end
			end)
		end
	end

	return true, var0_24, var1_24
end

function var0_0.applyToDock(arg0_26, arg1_26, arg2_26, arg3_26)
	if arg2_26.flag == ChapterConst.CellFlagDisabled then
		return false, "can not apply ai to dead Dock at: [" .. arg0_26.line.row .. ", " .. arg0_26.line.column .. "]"
	end

	local var0_26 = 0
	local var1_26 = 0

	if not arg1_26:getFleet(FleetType.Normal, arg0_26.stgTarget.row, arg0_26.stgTarget.column) then
		return false, "can not find fleet at: [" .. arg0_26.stgTarget.row .. ", " .. arg0_26.stgTarget.column .. "]"
	end

	if not arg3_26 then
		_.each(arg0_26.cellUpdates, function(arg0_27)
			if isa(arg0_27, ChapterCell) then
				arg1_26:mergeChapterCell(arg0_27)

				var0_26 = bit.bor(var0_26, ChapterConst.DirtyAttachment)
			end
		end)
		_.each(arg0_26.shipUpdate, function(arg0_28)
			arg1_26:updateFleetShipHp(arg0_28.id, arg0_28.hpRant)
		end)

		var0_26 = bit.bor(var0_26, ChapterConst.DirtyFleet)
	end

	return true, var0_26
end

function var0_0.applyToAntiAir(arg0_29, arg1_29, arg2_29, arg3_29)
	if arg2_29.flag == ChapterConst.CellFlagDisabled then
		return false, "can not apply ai to dead antiairGun at: [" .. arg0_29.line.row .. ", " .. arg0_29.line.column .. "]"
	end

	local var0_29 = 0
	local var1_29 = 0
	local var2_29 = arg1_29:getChampion(arg0_29.stgTarget.row, arg0_29.stgTarget.column)

	if not var2_29 then
		return false, "can not find champion at: [" .. arg0_29.stgTarget.row .. ", " .. arg0_29.stgTarget.column .. "]"
	end

	if not arg3_29 then
		arg1_29:RemoveChampion(var2_29)

		var0_29 = bit.bor(var0_29, ChapterConst.DirtyChampion, ChapterConst.DirtyAttachment)

		_.each(arg0_29.cellUpdates, function(arg0_30)
			if isa(arg0_30, ChapterChampionPackage) then
				local var0_30 = arg1_29:mergeChampion(arg0_30)
			else
				arg1_29:mergeChapterCell(arg0_30)

				var0_29 = bit.bor(var0_29, ChapterConst.DirtyAttachment)
			end
		end)
	end

	return true, var0_29, var1_29
end

return var0_0
