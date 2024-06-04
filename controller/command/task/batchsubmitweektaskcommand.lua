local var0 = class("BatchSubmitWeekTaskCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.ids
	local var2 = var0.callback
	local var3 = var0.dontSendMsg
	local var4 = getProxy(TaskProxy):GetWeekTaskProgressInfo()

	if #var1 <= 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(20108, {
		id = var1
	}, 20109, function(arg0)
		if arg0.result == 0 then
			local var0 = {}
			local var1 = var4:GetSubTask(var1[1]):GetAward()

			table.insert(var0, Drop.New({
				type = var1[1],
				id = var1[2],
				count = arg0.pt
			}))
			var4:RemoveSubTasks(var1)
			var4:AddProgress(arg0.pt)

			for iter0, iter1 in ipairs(arg0.next) do
				local var2 = WeekPtTask.New(iter1)

				var4:AddSubTask(var2)
			end

			if not var3 then
				arg0:sendNotification(GAME.BATCH_SUBMIT_WEEK_TASK_DONE, {
					awards = var0,
					ids = var1
				})
			end

			if var2 then
				var2(var0)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
