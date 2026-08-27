local var0_0 = class("AddChapterAutoTimeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type1Num
	local var2_1 = var0_1.type3Num
	local var3_1 = var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(13016, {
		ticket_num_1 = var1_1,
		ticket_num_3 = var2_1
	}, 13017, function(arg0_2)
		if arg0_2.result == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("auto_battle_time_add_success"))

			local var0_2 = getProxy(ChapterAutoProxy)

			var0_2:ReduceTicketByType(ChapterAutoTicket.TYPE.MAIN, var1_1)
			var0_2:ReduceTicketByType(ChapterAutoTicket.TYPE.TIME, var2_1)

			local var1_2 = var1_1 * pg.gameset.auto_battle_tickect_to_second_type1.key_value + var2_1 * pg.gameset.auto_battle_tickect_to_second_type3.key_value

			var0_2:AddDailyExtraTime(var1_2)
			existCall(var3_1)
			arg0_1:sendNotification(GAME.ADD_CHAPTER_AUTO_TIME_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("chapter_auto_add_time_fail", arg0_2.result))
		end
	end)
end

return var0_0
