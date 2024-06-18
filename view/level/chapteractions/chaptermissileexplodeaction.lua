local var0_0 = class("ChapterMissileExplodeAction")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.actType = arg1_1.act_type
	arg0_1.line = {
		row = arg1_1.ai_pos.row,
		column = arg1_1.ai_pos.column
	}
	arg0_1.shipUpdate = _.map(arg1_1.ship_update, function(arg0_2)
		return {
			id = arg0_2.id,
			hpRant = arg0_2.hp_rant
		}
	end)
	arg0_1.cellFlagUpdates = _.map(arg1_1.cell_flag_list, function(arg0_3)
		return {
			row = arg0_3.pos.row,
			column = arg0_3.pos.column,
			flag_list = _.map(arg0_3.flag_list, function(arg0_4)
				return arg0_4
			end)
		}
	end)
	arg0_1.cellUpdates = _.map(arg1_1.map_update, function(arg0_5)
		if arg0_5.item_type ~= ChapterConst.AttachNone and arg0_5.item_type ~= ChapterConst.AttachBorn and arg0_5.item_type ~= ChapterConst.AttachBorn_Sub and (arg0_5.item_type ~= ChapterConst.AttachStory or arg0_5.item_data ~= ChapterConst.StoryTrigger) then
			return arg0_5.item_type == ChapterConst.AttachChampion and ChapterChampionPackage.New(arg0_5) or ChapterCell.New(arg0_5)
		end
	end)
end

function var0_0.SetTargetLine(arg0_6, arg1_6)
	arg0_6.targetLine = arg1_6
	arg0_6.flagStrategy = true
end

function var0_0.applyTo(arg0_7, arg1_7, arg2_7)
	if not arg2_7 then
		local var0_7 = 0
		local var1_7 = 0

		if #arg0_7.cellFlagUpdates > 0 then
			_.each(arg0_7.cellFlagUpdates, function(arg0_8)
				local var0_8 = arg1_7:getChapterCell(arg0_8.row, arg0_8.column)

				if var0_8 then
					var0_8:updateFlagList(arg0_8)
				else
					var0_8 = ChapterCell.New(arg0_8)
				end

				arg1_7:updateChapterCell(var0_8)
			end)

			var0_7 = bit.bor(var0_7, ChapterConst.DirtyCellFlag)
		end

		if #arg0_7.cellUpdates > 0 then
			_.each(arg0_7.cellUpdates, function(arg0_9)
				if isa(arg0_9, ChapterChampionPackage) then
					local var0_9 = arg1_7:mergeChampion(arg0_9) and ChapterConst.DirtyChampionPosition or ChapterConst.DirtyChampion

					var0_7 = bit.bor(var0_7, var0_9)
				else
					arg1_7:mergeChapterCell(arg0_9)

					var0_7 = bit.bor(var0_7, ChapterConst.DirtyAttachment)
				end
			end)

			var1_7 = bit.bor(var1_7, ChapterConst.DirtyAutoAction)
		end

		if #arg0_7.shipUpdate > 0 then
			_.each(arg0_7.shipUpdate, function(arg0_10)
				arg1_7:updateFleetShipHp(arg0_10.id, arg0_10.hpRant)
			end)

			var0_7 = bit.bor(var0_7, ChapterConst.DirtyFleet)
		end

		return true, var0_7, var1_7
	end

	return true
end

function var0_0.PlayAIAction(arg0_11, arg1_11, arg2_11, arg3_11)
	local var0_11

	if arg0_11.targetLine then
		var0_11 = {
			arg0_11.targetLine
		}
	else
		local function var1_11(arg0_12)
			local var0_12 = arg1_11:GetRawChapterCell(arg0_12.row, arg0_12.column)

			return var0_12 and table.contains(var0_12:GetFlagList(), ChapterConst.FlagMissleAiming) and not table.contains(arg0_12.flag_list, ChapterConst.FlagMissleAiming)
		end

		var0_11 = _.filter(arg0_11.cellFlagUpdates, function(arg0_13)
			return var1_11(arg0_13)
		end)
	end

	seriesAsync({
		function(arg0_14)
			if not arg0_11.flagStrategy then
				return arg0_14()
			end

			arg2_11.viewComponent:doPlayAnim("MissileStrikeBar", function(arg0_15)
				setActive(arg0_15, false)
				arg0_14()
			end)
		end,
		function(arg0_16)
			table.ParallelIpairsAsync(var0_11, function(arg0_17, arg1_17, arg2_17)
				arg2_11.viewComponent.grid:PlayMissileExplodAnim(arg1_17, arg2_17)
			end, arg0_16)
		end,
		function(arg0_18)
			table.ParallelIpairsAsync(arg0_11.cellUpdates, function(arg0_19, arg1_19, arg2_19)
				if ChapterConst.IsBossCell(arg1_19) then
					arg2_11.viewComponent.grid:PlayShellFx(arg1_19)
					arg2_19()
				else
					local var0_19 = arg1_11:GetRawChapterCell(arg1_19.row, arg1_19.column)
					local var1_19 = var0_19 and var0_19.data or 0
					local var2_19 = "-" .. (arg1_19.data - var1_19) / 100 .. "%"

					arg2_11.viewComponent:strikeEnemy(arg1_19, var2_19, arg2_19)
				end
			end, arg0_18)
		end,
		function(arg0_20)
			arg2_11.viewComponent.levelStageView:SwitchBottomStagePanel(false)
			arg2_11.viewComponent.grid:HideMissileAimingMark()
			arg0_20()
		end,
		arg3_11
	})
end

return var0_0
