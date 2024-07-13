local var0_0 = class("ChapterExpelAIAction")

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

function var0_0.SetTargetLine(arg0_6, arg1_6, arg2_6)
	arg0_6.sourceLine = arg1_6
	arg0_6.targetLine = arg2_6
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
					local var0_9 = arg1_7:mergeChampion(arg0_9, true) and ChapterConst.DirtyChampionPosition or ChapterConst.DirtyChampion

					var0_7 = bit.bor(var0_7, var0_9)
				else
					arg1_7:mergeChapterCell(arg0_9, true)

					var0_7 = bit.bor(var0_7, ChapterConst.DirtyAttachment)
				end
			end)
			arg1_7:clearChapterCell(arg0_7.sourceLine.row, arg0_7.sourceLine.column)

			local var2_7 = arg1_7:getChampion(arg0_7.sourceLine.row, arg0_7.sourceLine.column)

			if var2_7 then
				arg1_7:RemoveChampion(var2_7)
			end

			var0_7 = bit.bor(var0_7, ChapterConst.DirtyAttachment)
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
	seriesAsync({
		function(arg0_12)
			arg2_11.viewComponent.levelStageView:SwitchBottomStagePanel(false)
			arg2_11.viewComponent.grid:HideAirExpelAimingMark()
			arg0_12()
		end,
		arg3_11
	})
end

return var0_0
