local var0_0 = class("Student", import(".BaseVO"))

var0_0.WAIT = 1
var0_0.ATTEND = 2
var0_0.CANCEL_TYPE_AUTO = 0
var0_0.CANCEL_TYPE_MANUAL = 1
var0_0.CANCEL_TYPE_QUICKLY = 2

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.id = arg1_1.id or arg1_1.room_id
	arg0_1.skillId = arg1_1.skill_pos
	arg0_1.skillIdIndex = nil
	arg0_1.lessonId = arg1_1.lessonId
	arg0_1.shipId = arg1_1.ship_id
	arg0_1.finishTime = arg1_1.finish_time
	arg0_1.startTime = arg1_1.start_time
	arg0_1.time = arg1_1.time
	arg0_1.exp = arg1_1.exp
	arg0_1.state = arg1_1.state or var0_0.ATTEND
end

function var0_0.IsFinish(arg0_2)
	return pg.TimeMgr.GetInstance():GetServerTime() >= arg0_2:getFinishTime()
end

function var0_0.updateSkillId(arg0_3, arg1_3)
	arg0_3.skillId = arg1_3
end

function var0_0.setSkillIndex(arg0_4, arg1_4)
	arg0_4.skillIdIndex = arg1_4
end

function var0_0.getSkillId(arg0_5, arg1_5)
	if arg0_5.skillId then
		return arg0_5.skillId
	else
		return arg1_5:getSkillList()[arg0_5.skillIdIndex]
	end
end

function var0_0.setLesson(arg0_6, arg1_6)
	arg0_6.lessonId = arg1_6
end

function var0_0.setFinishTime(arg0_7, arg1_7)
	arg0_7.finishTime = arg1_7
end

function var0_0.setTime(arg0_8, arg1_8)
	arg0_8.time = arg1_8
end

function var0_0.getTime(arg0_9)
	return arg0_9.time or arg0_9.finishTime - arg0_9.startTime
end

function var0_0.getFinishTime(arg0_10)
	return arg0_10.finishTime
end

function var0_0.getState(arg0_11)
	return arg0_11.state
end

function var0_0.getSkillDesc(arg0_12, arg1_12, arg2_12)
	return (getSkillDescLearn(arg0_12, arg1_12, arg2_12))
end

function var0_0.getSkillName(arg0_13)
	local var0_13 = getProxy(BayProxy):getShipById(arg0_13.shipId)

	return getSkillName(arg0_13:getSkillId(var0_13))
end

function var0_0.getShipVO(arg0_14)
	return (getProxy(BayProxy):getShipById(arg0_14.shipId))
end

return var0_0
