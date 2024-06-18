local var0_0 = class("SubmitWeekTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(TaskProxy):GetWeekTaskProgressInfo()
	local var2_1 = var1_1:GetSubTask(var0_1)

	if not var2_1 or not var2_1:IsFinished() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(20106, {
		id = var0_1
	}, 20107, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}
			local var1_2 = var2_1:GetAward()

			table.insert(var0_2, Drop.Create(var1_2))
			var1_1:AddProgress(var1_2[3])
			var1_1:RemoveSubTask(var0_1)

			if arg0_2.next and arg0_2.next.id ~= 0 then
				local var2_2 = WeekPtTask.New(arg0_2.next)

				var1_1:AddSubTask(var2_2)
			end

			arg0_1:sendNotification(GAME.SUBMIT_WEEK_TASK_DONE, {
				awards = var0_2,
				id = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
