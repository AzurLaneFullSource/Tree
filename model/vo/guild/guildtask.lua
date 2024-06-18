local var0_0 = class("GuildTask", import("..BaseVO"))

var0_0.STATE_EMPTY = 0
var0_0.STATE_ONGOING = 2
var0_0.STATE_FINISHED = 3
var0_0.PRIVATE_TASK_TYPE_EVENT = {
	400
}
var0_0.PRIVATE_TASK_TYPE_BATTLE = {
	20,
	11
}

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id or 0
	arg0_1.configId = arg0_1.id
	arg0_1.progress = arg1_1.progress or 0

	local var0_1 = arg1_1.monday_0clock or 0

	arg0_1.endTime = 0

	if var0_1 > 0 then
		arg0_1.endTime = var0_1 + 604800
	end
end

function var0_0.bindConfigTable(arg0_2)
	return pg.guild_mission_template
end

function var0_0.GetLivenessAddition(arg0_3)
	return arg0_3:getConfig("guild_active")
end

function var0_0.isExpire(arg0_4)
	return arg0_4.endTime > 0 and arg0_4:isEnd()
end

function var0_0.getProgress(arg0_5)
	return arg0_5.progress
end

function var0_0.updateProgress(arg0_6, arg1_6)
	arg0_6.progress = arg1_6
end

function var0_0.isEnd(arg0_7)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_7.endTime
end

function var0_0.getState(arg0_8)
	if arg0_8.id == 0 or arg0_8:isEnd() then
		return var0_0.STATE_EMPTY
	elseif arg0_8:isFinished() then
		return var0_0.STATE_FINISHED
	else
		return var0_0.STATE_ONGOING
	end
end

function var0_0.GetPresonTaskId(arg0_9)
	return arg0_9:getConfig("task_id")
end

function var0_0.GetPrivateTaskName(arg0_10)
	local var0_10 = arg0_10:GetPresonTaskId()

	return pg.task_data_template[var0_10].desc
end

function var0_0.IsSamePrivateTask(arg0_11, arg1_11)
	return arg1_11 and arg1_11.id == arg0_11:GetPresonTaskId()
end

function var0_0.isFinished(arg0_12)
	return arg0_12.progress >= arg0_12:getMaxProgress()
end

function var0_0.getMaxProgress(arg0_13)
	return arg0_13:getConfig("max_num")
end

function var0_0.isRemind(arg0_14, arg1_14)
	return arg0_14:getConfig("warning_time")[arg1_14] >= pg.TimeMgr.GetInstance():GetServerWeek()
end

function var0_0.GetScale(arg0_15)
	return arg0_15:getConfig("task_scale")
end

function var0_0.GetDesc(arg0_16)
	return arg0_16:getConfig("name")
end

function var0_0.GetPrivateAward(arg0_17)
	return arg0_17:getConfig("award_display")
end

function var0_0.GetCaptailAward(arg0_18)
	return arg0_18:getConfig("award_capital_display") * arg0_18:getMaxProgress()
end

function var0_0.GetCurrCaptailAward(arg0_19)
	return arg0_19.progress * arg0_19:getConfig("award_capital_display")
end

function var0_0.PrivateBeFinished(arg0_20)
	if var0_0.STATE_ONGOING == arg0_20:getState() then
		local var0_20 = arg0_20:GetPresonTaskId()
		local var1_20 = getProxy(TaskProxy)
		local var2_20 = var1_20:getTaskById(var0_20) or var1_20:getFinishTaskById(var0_20)

		return var2_20 and var2_20:isFinish() and not var2_20:isReceive()
	end

	return false
end

function var0_0.SamePrivateTaskType(arg0_21, arg1_21)
	local var0_21 = arg0_21:GetPresonTaskId()
	local var1_21 = pg.task_data_template[var0_21].sub_type

	return _.any(arg1_21, function(arg0_22)
		return arg0_22 == var1_21
	end)
end

return var0_0
