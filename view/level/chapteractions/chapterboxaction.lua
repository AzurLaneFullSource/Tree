local var0 = class("ChapterBoxAction", import(".ChapterCommonAction"))

function var0.applyTo(arg0, arg1, arg2)
	if arg2 then
		return true
	end

	arg0.command.chapter = arg1

	arg0.command:doOpenBox()

	return var0.super.applyTo(arg0, arg1, arg2)
end

function var0.PlayAIAction(arg0, arg1, arg2, arg3)
	local var0 = arg1.fleet.line
	local var1 = arg1:getChapterCell(var0.row, var0.column)
	local var2 = pg.box_data_template[var1.attachmentId]

	seriesAsync({
		function(arg0)
			if var2.type == ChapterConst.BoxAirStrike then
				arg2.viewComponent:doPlayAirStrike(ChapterConst.SubjectChampion, false, arg0)

				return
			elseif var2.type == ChapterConst.BoxTorpedo then
				if arg1.fleet:canClearTorpedo() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("levelScene_destroy_torpedo"))
				else
					arg2.viewComponent:doPlayTorpedo(arg0)

					return
				end
			elseif var2.type == ChapterConst.BoxBanaiDamage then
				arg2.viewComponent:doPlayAirStrike(ChapterConst.SubjectChampion, false, arg0)

				return
			elseif var2.type == ChapterConst.BoxLavaDamage then
				pg.CriMgr.GetInstance():PlaySE_V3("ui-magma")
				arg2.viewComponent:doPlayAnim("AirStrikeLava", function(arg0)
					setActive(arg0, false)
					arg0()
				end)

				return
			end

			arg0()
		end,
		arg3
	})
end

return var0
