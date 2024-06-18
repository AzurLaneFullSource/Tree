local var0_0 = class("SkirmishVO", import(".BaseVO"))

var0_0.TypeStoryOrExpedition = 1
var0_0.TypeChapter = 2
var0_0.StateInactive = 0
var0_0.StateActive = 1
var0_0.StateWorking = 2
var0_0.StateClear = 3

function var0_0.bindConfigTable(arg0_1)
	return pg.activity_skirmish_event
end

function var0_0.Ctor(arg0_2, arg1_2)
	arg0_2.id = arg1_2
	arg0_2.configId = arg1_2
	arg0_2.state = var0_0.StateInactive
	arg0_2.flagNew = nil
end

function var0_0.SetState(arg0_3, arg1_3)
	arg1_3 = arg1_3 or 0

	if arg1_3 == arg0_3.state then
		return
	end

	if arg0_3.state ~= nil and arg1_3 == SkirmishVO.StateWorking then
		arg0_3.flagNew = true
	end

	arg0_3.state = arg1_3
end

function var0_0.GetState(arg0_4)
	return arg0_4.state
end

function var0_0.GetType(arg0_5)
	return arg0_5:getConfig("type")
end

function var0_0.GetEvent(arg0_6)
	return arg0_6:getConfig("event")
end

return var0_0
