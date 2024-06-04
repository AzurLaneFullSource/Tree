local var0 = class("SkirmishVO", import(".BaseVO"))

var0.TypeStoryOrExpedition = 1
var0.TypeChapter = 2
var0.StateInactive = 0
var0.StateActive = 1
var0.StateWorking = 2
var0.StateClear = 3

function var0.bindConfigTable(arg0)
	return pg.activity_skirmish_event
end

function var0.Ctor(arg0, arg1)
	arg0.id = arg1
	arg0.configId = arg1
	arg0.state = var0.StateInactive
	arg0.flagNew = nil
end

function var0.SetState(arg0, arg1)
	arg1 = arg1 or 0

	if arg1 == arg0.state then
		return
	end

	if arg0.state ~= nil and arg1 == SkirmishVO.StateWorking then
		arg0.flagNew = true
	end

	arg0.state = arg1
end

function var0.GetState(arg0)
	return arg0.state
end

function var0.GetType(arg0)
	return arg0:getConfig("type")
end

function var0.GetEvent(arg0)
	return arg0:getConfig("event")
end

return var0
