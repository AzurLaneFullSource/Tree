local var0 = class("EducateSetTargetCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0 and var0.callback
	local var2 = var0.open

	pg.ConnectionMgr.GetInstance():Send(27019, {
		id = var0.id
	}, 27020, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(EducateProxy)

			var0:GetTaskProxy():UpdateTargetAwardStatus(false)
			var0:GetTaskProxy():SetTarget(var0.id)
			var0:UpdateGameStatus()
			arg0:sendNotification(GAME.EDUCATE_SET_TARGET_DONE, {
				autoOpen = var2
			})

			if var1 then
				var1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate set target error: ", arg0.result))
		end
	end)
end

return var0
