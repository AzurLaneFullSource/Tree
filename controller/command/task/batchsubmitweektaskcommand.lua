local var0_0 = class("BatchSubmitWeekTaskCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.ids
	local var2_1 = var0_1.callback
	local var3_1 = var0_1.dontSendMsg
	local var4_1 = getProxy(TaskProxy):GetWeekTaskProgressInfo()

	if #var1_1 <= 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(20108, {
		id = var1_1
	}, 20109, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = {}
			local var1_2 = var4_1:GetSubTask(var1_1[1]):GetAward()

			table.insert(var0_2, Drop.New({
				type = var1_2[1],
				id = var1_2[2],
				count = arg0_2.pt
			}))
			var4_1:RemoveSubTasks(var1_1)
			var4_1:AddProgress(arg0_2.pt)

			for iter0_2, iter1_2 in ipairs(arg0_2.next) do
				local var2_2 = WeekPtTask.New(iter1_2)

				var4_1:AddSubTask(var2_2)
			end

			if not var3_1 then
				arg0_1:sendNotification(GAME.BATCH_SUBMIT_WEEK_TASK_DONE, {
					awards = var0_2,
					ids = var1_1
				})
			end

			if var2_1 then
				var2_1(var0_2)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
