local var0 = class("ChapterAirSupportAIAction", import(".ChapterMissileExplodeAction"))

function var0.PlayAIAction(arg0, arg1, arg2, arg3)
	seriesAsync({
		function(arg0)
			arg2.viewComponent:doPlayAnim("AirStrikeBar", function(arg0)
				setActive(arg0, false)
				arg0()
			end)
		end,
		function(arg0)
			table.ParallelIpairsAsync(arg0.cellUpdates, function(arg0, arg1, arg2)
				local var0 = arg1:GetRawChapterCell(arg1.row, arg1.column)
				local var1 = var0 and var0.data or 0
				local var2 = "-" .. (arg1.data - var1) / 100 .. "%"

				arg2.viewComponent:strikeEnemy(arg1, var2, arg2)
			end, arg0)
		end,
		function(arg0)
			arg2.viewComponent.levelStageView:SwitchBottomStagePanel(false)
			arg2.viewComponent.grid:HideAirSupportAimingMark()
			arg0()
		end,
		arg3
	})
end

return var0
