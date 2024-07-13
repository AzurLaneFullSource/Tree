local var0_0 = class("EducateGetTargetAwardCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27035, {
		type = 0
	}, 27036, function(arg0_2)
		if arg0_2.result == 0 then
			EducateHelper.UpdateDropsData(arg0_2.drops)
			getProxy(EducateProxy):GetTaskProxy():UpdateTargetAwardStatus(true)
			arg0_1:sendNotification(GAME.EDUCATE_GET_TARGET_AWARD_DONE, {
				awards = arg0_2.drops
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("get target award error: ", arg0_2.result))
		end
	end)
end

return var0_0
