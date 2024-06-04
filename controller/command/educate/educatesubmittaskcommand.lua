local var0 = class("EducateSubmitTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	pg.ConnectionMgr.GetInstance():Send(27023, {
		id = var0.id,
		system = var0.system
	}, 27024, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(EducateProxy)

			if var0.id == var0:GetUnlockSecretaryTaskId() then
				var0:SetSecretaryUnlock()
			end

			EducateHelper.UpdateDropsData(arg0.awards)
			var0:GetTaskProxy():RemoveTaskById(var0.id)
			arg0:sendNotification(GAME.EDUCATE_SUBMIT_TASK_DONE, {
				awards = arg0.awards
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate submit task error: ", arg0.result))
		end
	end)
end

return var0
