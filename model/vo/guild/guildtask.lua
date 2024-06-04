local var0 = class("GuildTask", import("..BaseVO"))

var0.STATE_EMPTY = 0
var0.STATE_ONGOING = 2
var0.STATE_FINISHED = 3
var0.PRIVATE_TASK_TYPE_EVENT = {
	400
}
var0.PRIVATE_TASK_TYPE_BATTLE = {
	20,
	11
}

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id or 0
	arg0.configId = arg0.id
	arg0.progress = arg1.progress or 0

	local var0 = arg1.monday_0clock or 0

	arg0.endTime = 0

	if var0 > 0 then
		arg0.endTime = var0 + 604800
	end
end

function var0.bindConfigTable(arg0)
	return pg.guild_mission_template
end

function var0.GetLivenessAddition(arg0)
	return arg0:getConfig("guild_active")
end

function var0.isExpire(arg0)
	return arg0.endTime > 0 and arg0:isEnd()
end

function var0.getProgress(arg0)
	return arg0.progress
end

function var0.updateProgress(arg0, arg1)
	arg0.progress = arg1
end

function var0.isEnd(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0.endTime
end

function var0.getState(arg0)
	if arg0.id == 0 or arg0:isEnd() then
		return var0.STATE_EMPTY
	elseif arg0:isFinished() then
		return var0.STATE_FINISHED
	else
		return var0.STATE_ONGOING
	end
end

function var0.GetPresonTaskId(arg0)
	return arg0:getConfig("task_id")
end

function var0.GetPrivateTaskName(arg0)
	local var0 = arg0:GetPresonTaskId()

	return pg.task_data_template[var0].desc
end

function var0.IsSamePrivateTask(arg0, arg1)
	return arg1 and arg1.id == arg0:GetPresonTaskId()
end

function var0.isFinished(arg0)
	return arg0.progress >= arg0:getMaxProgress()
end

function var0.getMaxProgress(arg0)
	return arg0:getConfig("max_num")
end

function var0.isRemind(arg0, arg1)
	return arg0:getConfig("warning_time")[arg1] >= pg.TimeMgr.GetInstance():GetServerWeek()
end

function var0.GetScale(arg0)
	return arg0:getConfig("task_scale")
end

function var0.GetDesc(arg0)
	return arg0:getConfig("name")
end

function var0.GetPrivateAward(arg0)
	return arg0:getConfig("award_display")
end

function var0.GetCaptailAward(arg0)
	return arg0:getConfig("award_capital_display") * arg0:getMaxProgress()
end

function var0.GetCurrCaptailAward(arg0)
	return arg0.progress * arg0:getConfig("award_capital_display")
end

function var0.PrivateBeFinished(arg0)
	if var0.STATE_ONGOING == arg0:getState() then
		local var0 = arg0:GetPresonTaskId()
		local var1 = getProxy(TaskProxy)
		local var2 = var1:getTaskById(var0) or var1:getFinishTaskById(var0)

		return var2 and var2:isFinish() and not var2:isReceive()
	end

	return false
end

function var0.SamePrivateTaskType(arg0, arg1)
	local var0 = arg0:GetPresonTaskId()
	local var1 = pg.task_data_template[var0].sub_type

	return _.any(arg1, function(arg0)
		return arg0 == var1
	end)
end

return var0
