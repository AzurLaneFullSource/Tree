local var0_0 = class("ChapterAirSupportAIAction", import(".ChapterMissileExplodeAction"))

function var0_0.PlayAIAction(arg0_1, arg1_1, arg2_1, arg3_1)
	seriesAsync({
		function(arg0_2)
			arg2_1.viewComponent:doPlayAnim("AirStrikeBar", function(arg0_3)
				setActive(arg0_3, false)
				arg0_2()
			end)
		end,
		function(arg0_4)
			table.ParallelIpairsAsync(arg0_1.cellUpdates, function(arg0_5, arg1_5, arg2_5)
				local var0_5 = arg1_1:GetRawChapterCell(arg1_5.row, arg1_5.column)
				local var1_5 = var0_5 and var0_5.data or 0
				local var2_5 = "-" .. (arg1_5.data - var1_5) / 100 .. "%"

				arg2_1.viewComponent:strikeEnemy(arg1_5, var2_5, arg2_5)
			end, arg0_4)
		end,
		function(arg0_6)
			arg2_1.viewComponent.levelStageView:SwitchBottomStagePanel(false)
			arg2_1.viewComponent.grid:HideAirSupportAimingMark()
			arg0_6()
		end,
		arg3_1
	})
end

return var0_0
