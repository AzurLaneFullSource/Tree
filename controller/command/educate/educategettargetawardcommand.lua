local var0 = class("EducateGetTargetAwardCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27035, {
		type = 0
	}, 27036, function(arg0)
		if arg0.result == 0 then
			EducateHelper.UpdateDropsData(arg0.drops)
			getProxy(EducateProxy):GetTaskProxy():UpdateTargetAwardStatus(true)
			arg0:sendNotification(GAME.EDUCATE_GET_TARGET_AWARD_DONE, {
				awards = arg0.drops
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("get target award error: ", arg0.result))
		end
	end)
end

return var0
