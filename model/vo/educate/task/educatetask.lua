local var0_0 = class("EducateTask", import("model.vo.BaseVO"))

var0_0.SYSTEM_TYPE_MIND = 1
var0_0.SYSTEM_TYPE_TARGET = 2
var0_0.STSTEM_TYPE_MAIN = 3
var0_0.TYPE_PLAN = 1
var0_0.TYPE_ATTR = 2
var0_0.TYPE_SITE_COST = 3
var0_0.TYPE_PURCHASE = 4
var0_0.TYPE_SITE_ENTER = 5
var0_0.TYPE_TARGET = 6
var0_0.TYPE_PERFORM = 7
var0_0.TYPE_ITEM = 8
var0_0.TYPE_TASK = 9
var0_0.TYPE_SCHEDULE = 10
var0_0.STATUS_UNFINISH = 0
var0_0.STATUS_FINISH = 1
var0_0.STATUS_RECEIVE = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id
	arg0_1.configId = arg0_1.id
	arg0_1.progress = arg1_1.progress or 0
	arg0_1.status = arg0_1.progress < 1 and var0_0.STATUS_UNFINISH or var0_0.STATUS_FINISH

	arg0_1:initCfgTime()
end

function var0_0.bindConfigTable(arg0_2)
	return pg.child_task
end

function var0_0.initCfgTime(arg0_3)
	local var0_3 = arg0_3:getConfig("time_limit")

	arg0_3.startTime, arg0_3.endTime = EducateHelper.CfgTime2Time(var0_3)
end

function var0_0.GetSystemType(arg0_4)
	return arg0_4:getConfig("type_1")
end

function var0_0.GetType(arg0_5)
	return arg0_5:getConfig("type_2")
end

function var0_0.IsMind(arg0_6)
	return arg0_6:GetSystemType() == var0_0.SYSTEM_TYPE_MIND
end

function var0_0.IsTarget(arg0_7)
	return arg0_7:GetSystemType() == var0_0.SYSTEM_TYPE_TARGET
end

function var0_0.IsMain(arg0_8)
	return arg0_8:GetSystemType() == var0_0.STSTEM_TYPE_MAIN
end

function var0_0.NeedAddProgressFromSiteEnter(arg0_9)
	return arg0_9:GetType() == var0_0.TYPE_SITE_ENTER and not arg0_9:IsFinish()
end

function var0_0.NeedAddProgressFromPerform(arg0_10)
	return arg0_10:GetType() == var0_0.TYPE_PERFORM and not arg0_10:IsFinish()
end

function var0_0.InTime(arg0_11, arg1_11)
	local var0_11 = arg1_11 or getProxy(EducateProxy):GetCurTime()

	return EducateHelper.InTime(var0_11, arg0_11.startTime, arg0_11.endTime)
end

function var0_0.GetRemainTime(arg0_12, arg1_12)
	local var0_12 = arg1_12 or getProxy(EducateProxy):GetCurTime()

	return EducateHelper.GetDaysBetweenTimes(var0_12, arg0_12.endTime)
end

function var0_0.IsFinish(arg0_13)
	return arg0_13:GetProgress() >= arg0_13:GetFinishNum()
end

function var0_0.GetProgress(arg0_14)
	return math.min(arg0_14.progress, arg0_14:GetFinishNum())
end

function var0_0.GetFinishNum(arg0_15)
	return arg0_15:getConfig("arg")
end

function var0_0.GetTargetProgress(arg0_16)
	return arg0_16:getConfig("task_target_progress")
end

function var0_0.SetRecieve(arg0_17)
	arg0_17.isReceive = true
	arg0_17.progress = arg0_17:GetFinishNum()
end

function var0_0.IsReceive(arg0_18)
	return arg0_18.isReceive
end

function var0_0.GetTaskStatus(arg0_19)
	if arg0_19:IsReceive() then
		return var0_0.STATUS_RECEIVE
	end

	if arg0_19:IsFinish() then
		return var0_0.STATUS_FINISH
	end

	return var0_0.STATUS_UNFINISH
end

function var0_0.updateProgress(arg0_20, arg1_20)
	arg0_20.progress = arg1_20
end

function var0_0.GetAwardShow(arg0_21)
	local var0_21 = arg0_21:getConfig("drop_display")

	return {
		type = var0_21[1],
		id = var0_21[2],
		number = var0_21[3]
	}
end

return var0_0
