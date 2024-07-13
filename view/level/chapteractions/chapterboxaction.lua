local var0_0 = class("ChapterBoxAction", import(".ChapterCommonAction"))

function var0_0.applyTo(arg0_1, arg1_1, arg2_1)
	if arg2_1 then
		return true
	end

	arg0_1.command.chapter = arg1_1

	arg0_1.command:doOpenBox()

	return var0_0.super.applyTo(arg0_1, arg1_1, arg2_1)
end

function var0_0.PlayAIAction(arg0_2, arg1_2, arg2_2, arg3_2)
	local var0_2 = arg1_2.fleet.line
	local var1_2 = arg1_2:getChapterCell(var0_2.row, var0_2.column)
	local var2_2 = pg.box_data_template[var1_2.attachmentId]

	seriesAsync({
		function(arg0_3)
			if var2_2.type == ChapterConst.BoxAirStrike then
				arg2_2.viewComponent:doPlayAirStrike(ChapterConst.SubjectChampion, false, arg0_3)

				return
			elseif var2_2.type == ChapterConst.BoxTorpedo then
				if arg1_2.fleet:canClearTorpedo() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_destroy_torpedo"))
				else
					arg2_2.viewComponent:doPlayTorpedo(arg0_3)

					return
				end
			elseif var2_2.type == ChapterConst.BoxBanaiDamage then
				arg2_2.viewComponent:doPlayAirStrike(ChapterConst.SubjectChampion, false, arg0_3)

				return
			elseif var2_2.type == ChapterConst.BoxLavaDamage then
				pg.CriMgr.GetInstance():PlaySE_V3("ui-magma")
				arg2_2.viewComponent:doPlayAnim("AirStrikeLava", function(arg0_4)
					setActive(arg0_4, false)
					arg0_3()
				end)

				return
			end

			arg0_3()
		end,
		arg3_2
	})
end

return var0_0
