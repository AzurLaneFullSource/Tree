local var0 = class("TaskProgressUpdateCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	arg0:CheckAndSubmitVoteTask()
end

function var0.CheckAndSubmitVoteTask(arg0, arg1)
	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_VOTE)

	for iter0, iter1 in pairs(var0) do
		if not iter1:isEnd() then
			local var1 = arg0:GetCanSubmitVoteTaskList(iter1)

			arg0:SubmitTaskList(var1)
		end
	end
end

function var0.GetCanSubmitVoteTaskList(arg0, arg1)
	local var0 = arg1:getConfig("config_id")
	local var1 = pg.activity_vote[var0]

	assert(var1, arg1.id .. "-" .. var0)

	local var2 = _.flatten(var1.task_period)
	local var3 = {}

	for iter0, iter1 in ipairs(var2) do
		local var4 = getProxy(TaskProxy):getTaskById(iter1)

		if var4 and var4:isFinish() and not var4:isReceive() then
			table.insert(var3, var4)
		end
	end

	return var3
end

function var0.SubmitTaskList(arg0, arg1)
	if #arg1 <= 0 then
		return
	end

	for iter0, iter1 in pairs(arg1) do
		arg0:sendNotification(GAME.SUBMIT_TASK, iter1.id)
	end
end

return var0
