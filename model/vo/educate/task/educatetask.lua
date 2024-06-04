local var0 = class("EducateTask", import("model.vo.BaseVO"))

var0.SYSTEM_TYPE_MIND = 1
var0.SYSTEM_TYPE_TARGET = 2
var0.STSTEM_TYPE_MAIN = 3
var0.TYPE_PLAN = 1
var0.TYPE_ATTR = 2
var0.TYPE_SITE_COST = 3
var0.TYPE_PURCHASE = 4
var0.TYPE_SITE_ENTER = 5
var0.TYPE_TARGET = 6
var0.TYPE_PERFORM = 7
var0.TYPE_ITEM = 8
var0.TYPE_TASK = 9
var0.TYPE_SCHEDULE = 10
var0.STATUS_UNFINISH = 0
var0.STATUS_FINISH = 1
var0.STATUS_RECEIVE = 2

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id
	arg0.configId = arg0.id
	arg0.progress = arg1.progress or 0
	arg0.status = arg0.progress < 1 and var0.STATUS_UNFINISH or var0.STATUS_FINISH

	arg0:initCfgTime()
end

function var0.bindConfigTable(arg0)
	return pg.child_task
end

function var0.initCfgTime(arg0)
	local var0 = arg0:getConfig("time_limit")

	arg0.startTime, arg0.endTime = EducateHelper.CfgTime2Time(var0)
end

function var0.GetSystemType(arg0)
	return arg0:getConfig("type_1")
end

function var0.GetType(arg0)
	return arg0:getConfig("type_2")
end

function var0.IsMind(arg0)
	return arg0:GetSystemType() == var0.SYSTEM_TYPE_MIND
end

function var0.IsTarget(arg0)
	return arg0:GetSystemType() == var0.SYSTEM_TYPE_TARGET
end

function var0.IsMain(arg0)
	return arg0:GetSystemType() == var0.STSTEM_TYPE_MAIN
end

function var0.NeedAddProgressFromSiteEnter(arg0)
	return arg0:GetType() == var0.TYPE_SITE_ENTER and not arg0:IsFinish()
end

function var0.NeedAddProgressFromPerform(arg0)
	return arg0:GetType() == var0.TYPE_PERFORM and not arg0:IsFinish()
end

function var0.InTime(arg0, arg1)
	local var0 = arg1 or getProxy(EducateProxy):GetCurTime()

	return EducateHelper.InTime(var0, arg0.startTime, arg0.endTime)
end

function var0.GetRemainTime(arg0, arg1)
	local var0 = arg1 or getProxy(EducateProxy):GetCurTime()

	return EducateHelper.GetDaysBetweenTimes(var0, arg0.endTime)
end

function var0.IsFinish(arg0)
	return arg0:GetProgress() >= arg0:GetFinishNum()
end

function var0.GetProgress(arg0)
	return math.min(arg0.progress, arg0:GetFinishNum())
end

function var0.GetFinishNum(arg0)
	return arg0:getConfig("arg")
end

function var0.GetTargetProgress(arg0)
	return arg0:getConfig("task_target_progress")
end

function var0.SetRecieve(arg0)
	arg0.isReceive = true
	arg0.progress = arg0:GetFinishNum()
end

function var0.IsReceive(arg0)
	return arg0.isReceive
end

function var0.GetTaskStatus(arg0)
	if arg0:IsReceive() then
		return var0.STATUS_RECEIVE
	end

	if arg0:IsFinish() then
		return var0.STATUS_FINISH
	end

	return var0.STATUS_UNFINISH
end

function var0.updateProgress(arg0, arg1)
	arg0.progress = arg1
end

function var0.GetAwardShow(arg0)
	local var0 = arg0:getConfig("drop_display")

	return {
		type = var0[1],
		id = var0[2],
		number = var0[3]
	}
end

return var0
