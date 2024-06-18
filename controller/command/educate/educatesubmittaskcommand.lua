local var0_0 = class("EducateSubmitTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	pg.ConnectionMgr.GetInstance():Send(27023, {
		id = var0_1.id,
		system = var0_1.system
	}, 27024, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(EducateProxy)

			if var0_1.id == var0_2:GetUnlockSecretaryTaskId() then
				var0_2:SetSecretaryUnlock()
			end

			EducateHelper.UpdateDropsData(arg0_2.awards)
			var0_2:GetTaskProxy():RemoveTaskById(var0_1.id)
			arg0_1:sendNotification(GAME.EDUCATE_SUBMIT_TASK_DONE, {
				awards = arg0_2.awards
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate submit task error: ", arg0_2.result))
		end
	end)
end

return var0_0
