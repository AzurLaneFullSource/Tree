local var0 = class("Student", import(".BaseVO"))

var0.WAIT = 1
var0.ATTEND = 2
var0.CANCEL_TYPE_AUTO = 0
var0.CANCEL_TYPE_MANUAL = 1
var0.CANCEL_TYPE_QUICKLY = 2

function var0.Ctor(arg0, arg1)
	arg0.id = arg1.id or arg1.room_id
	arg0.skillId = arg1.skill_pos
	arg0.skillIdIndex = nil
	arg0.lessonId = arg1.lessonId
	arg0.shipId = arg1.ship_id
	arg0.finishTime = arg1.finish_time
	arg0.startTime = arg1.start_time
	arg0.time = arg1.time
	arg0.exp = arg1.exp
	arg0.state = arg1.state or var0.ATTEND
end

function var0.IsFinish(arg0)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0:getFinishTime()
end

function var0.updateSkillId(arg0, arg1)
	arg0.skillId = arg1
end

function var0.setSkillIndex(arg0, arg1)
	arg0.skillIdIndex = arg1
end

function var0.getSkillId(arg0, arg1)
	if arg0.skillId then
		return arg0.skillId
	else
		return arg1:getSkillList()[arg0.skillIdIndex]
	end
end

function var0.setLesson(arg0, arg1)
	arg0.lessonId = arg1
end

function var0.setFinishTime(arg0, arg1)
	arg0.finishTime = arg1
end

function var0.setTime(arg0, arg1)
	arg0.time = arg1
end

function var0.getTime(arg0)
	return arg0.time or arg0.finishTime - arg0.startTime
end

function var0.getFinishTime(arg0)
	return arg0.finishTime
end

function var0.getState(arg0)
	return arg0.state
end

function var0.getSkillDesc(arg0, arg1, arg2)
	return (getSkillDescLearn(arg0, arg1, arg2))
end

function var0.getSkillName(arg0)
	local var0 = getProxy(BayProxy):getShipById(arg0.shipId)

	return getSkillName(arg0:getSkillId(var0))
end

function var0.getShipVO(arg0)
	return (getProxy(BayProxy):getShipById(arg0.shipId))
end

return var0
