local var0_0 = class("AcceptLoveLetterMailCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().activity_id
	local var1_1 = getProxy(ActivityProxy):getActivityById(var0_1)

	if not var1_1 or var1_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("challenge_end_tip"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var0_1
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ActivityProxy):getActivityById(var0_1)

			var0_2.data1 = 1

			getProxy(ActivityProxy):updateActivity(var0_2)
			pg.TipsMgr.GetInstance():ShowTips(i18n("spring_present_tips3"))
			pg.m02:sendNotification(GAME.ACCEPT_LOVE_LETTER_MAIL_DONE)
		elseif arg0_2.result == 22 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spring_present_tips2"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
