local var0 = class("ChapterExpelAIAction")

function var0.Ctor(arg0, arg1)
	arg0.actType = arg1.act_type
	arg0.line = {
		row = arg1.ai_pos.row,
		column = arg1.ai_pos.column
	}
	arg0.shipUpdate = _.map(arg1.ship_update, function(arg0)
		return {
			id = arg0.id,
			hpRant = arg0.hp_rant
		}
	end)
	arg0.cellFlagUpdates = _.map(arg1.cell_flag_list, function(arg0)
		return {
			row = arg0.pos.row,
			column = arg0.pos.column,
			flag_list = _.map(arg0.flag_list, function(arg0)
				return arg0
			end)
		}
	end)
	arg0.cellUpdates = _.map(arg1.map_update, function(arg0)
		if arg0.item_type ~= ChapterConst.AttachNone and arg0.item_type ~= ChapterConst.AttachBorn and arg0.item_type ~= ChapterConst.AttachBorn_Sub and (arg0.item_type ~= ChapterConst.AttachStory or arg0.item_data ~= ChapterConst.StoryTrigger) then
			return arg0.item_type == ChapterConst.AttachChampion and ChapterChampionPackage.New(arg0) or ChapterCell.New(arg0)
		end
	end)
end

function var0.SetTargetLine(arg0, arg1, arg2)
	arg0.sourceLine = arg1
	arg0.targetLine = arg2
end

function var0.applyTo(arg0, arg1, arg2)
	if not arg2 then
		local var0 = 0
		local var1 = 0

		if #arg0.cellFlagUpdates > 0 then
			_.each(arg0.cellFlagUpdates, function(arg0)
				local var0 = arg1:getChapterCell(arg0.row, arg0.column)

				if var0 then
					var0:updateFlagList(arg0)
				else
					var0 = ChapterCell.New(arg0)
				end

				arg1:updateChapterCell(var0)
			end)

			var0 = bit.bor(var0, ChapterConst.DirtyCellFlag)
		end

		if #arg0.cellUpdates > 0 then
			_.each(arg0.cellUpdates, function(arg0)
				if isa(arg0, ChapterChampionPackage) then
					local var0 = arg1:mergeChampion(arg0, true) and ChapterConst.DirtyChampionPosition or ChapterConst.DirtyChampion

					var0 = bit.bor(var0, var0)
				else
					arg1:mergeChapterCell(arg0, true)

					var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
				end
			end)
			arg1:clearChapterCell(arg0.sourceLine.row, arg0.sourceLine.column)

			local var2 = arg1:getChampion(arg0.sourceLine.row, arg0.sourceLine.column)

			if var2 then
				arg1:RemoveChampion(var2)
			end

			var0 = bit.bor(var0, ChapterConst.DirtyAttachment)
			var1 = bit.bor(var1, ChapterConst.DirtyAutoAction)
		end

		if #arg0.shipUpdate > 0 then
			_.each(arg0.shipUpdate, function(arg0)
				arg1:updateFleetShipHp(arg0.id, arg0.hpRant)
			end)

			var0 = bit.bor(var0, ChapterConst.DirtyFleet)
		end

		return true, var0, var1
	end

	return true
end

function var0.PlayAIAction(arg0, arg1, arg2, arg3)
	seriesAsync({
		function(arg0)
			arg2.viewComponent.levelStageView:SwitchBottomStagePanel(false)
			arg2.viewComponent.grid:HideAirExpelAimingMark()
			arg0()
		end,
		arg3
	})
end

return var0
