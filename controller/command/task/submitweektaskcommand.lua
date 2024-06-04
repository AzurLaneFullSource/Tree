local var0 = class("SubmitWeekTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().id
	local var1 = getProxy(TaskProxy):GetWeekTaskProgressInfo()
	local var2 = var1:GetSubTask(var0)

	if not var2 or not var2:IsFinished() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(20106, {
		id = var0
	}, 20107, function(arg0)
		if arg0.result == 0 then
			local var0 = {}
			local var1 = var2:GetAward()

			table.insert(var0, Drop.Create(var1))
			var1:AddProgress(var1[3])
			var1:RemoveSubTask(var0)

			if arg0.next and arg0.next.id ~= 0 then
				local var2 = WeekPtTask.New(arg0.next)

				var1:AddSubTask(var2)
			end

			arg0:sendNotification(GAME.SUBMIT_WEEK_TASK_DONE, {
				awards = var0,
				id = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
