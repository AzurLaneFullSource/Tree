local var0_0 = class("TaskProgressUpdateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	arg0_1:CheckAndSubmitVoteTask()
end

function var0_0.CheckAndSubmitVoteTask(arg0_2, arg1_2)
	local var0_2 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	for iter0_2, iter1_2 in pairs(var0_2) do
		if not iter1_2:isEnd() then
			local var1_2 = arg0_2:GetCanSubmitVoteTaskList(iter1_2)

			arg0_2:SubmitTaskList(var1_2)
		end
	end
end

function var0_0.GetCanSubmitVoteTaskList(arg0_3, arg1_3)
	local var0_3 = arg1_3:getConfig("config_id")
	local var1_3 = pg.activity_vote[var0_3]

	assert(var1_3, arg1_3.id .. "-" .. var0_3)

	local var2_3 = _.flatten(var1_3.task_period)
	local var3_3 = {}

	for iter0_3, iter1_3 in ipairs(var2_3) do
		local var4_3 = getProxy(TaskProxy):getTaskById(iter1_3)

		if var4_3 and var4_3:isFinish() and not var4_3:isReceive() then
			table.insert(var3_3, var4_3)
		end
	end

	return var3_3
end

function var0_0.SubmitTaskList(arg0_4, arg1_4)
	if #arg1_4 <= 0 then
		return
	end

	for iter0_4, iter1_4 in pairs(arg1_4) do
		arg0_4:sendNotification(GAME.SUBMIT_TASK, iter1_4.id)
	end
end

return var0_0
