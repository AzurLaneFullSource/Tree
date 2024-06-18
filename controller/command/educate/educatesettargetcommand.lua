local var0_0 = class("EducateSetTargetCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1 and var0_1.callback
	local var2_1 = var0_1.open

	pg.ConnectionMgr.GetInstance():Send(27019, {
		id = var0_1.id
	}, 27020, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(EducateProxy)

			var0_2:GetTaskProxy():UpdateTargetAwardStatus(false)
			var0_2:GetTaskProxy():SetTarget(var0_1.id)
			var0_2:UpdateGameStatus()
			arg0_1:sendNotification(GAME.EDUCATE_SET_TARGET_DONE, {
				autoOpen = var2_1
			})

			if var1_1 then
				var1_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate set target error: ", arg0_2.result))
		end
	end)
end

return var0_0
