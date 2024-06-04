local var0 = class("RectBaseScript")

function var0.Ctor(arg0)
	arg0._weight = 1
	arg0._loop = false
	arg0._active = false
	arg0._scriptTime = 0
	arg0._overrideAble = false
	arg0._lateActive = false
	arg0._name = ""
end

function var0.init(arg0)
	return
end

function var0.setData(arg0, arg1, arg2, arg3)
	arg0._collisionInfo = arg1
	arg0._keyInfo = arg2
	arg0._event = arg3

	arg0:onInit()
end

function var0.step(arg0)
	arg0:onStep()

	arg0._triggerKey = nil
	arg0._triggerStatus = nil
end

function var0.addScriptApply(arg0)
	arg0._collisionInfo:removeScript()
	arg0._collisionInfo:setScript(arg0, arg0._weight, arg0._scriptTime, arg0._overrideAble)
end

function var0.checkScirptApply(arg0)
	if not arg0._collisionInfo.script then
		arg0:addScriptApply()

		return true
	elseif arg0._collisionInfo.script ~= arg0 and arg0._collisionInfo.scriptOverrideAble and arg0._collisionInfo.scriptWeight <= arg0._weight then
		arg0:addScriptApply()

		return true
	end

	print("当前脚本 " .. arg0._collisionInfo.script._name .. " 中，无法执行" .. arg0._name)

	return false
end

function var0.onStep(arg0)
	return
end

function var0.lateStep(arg0)
	arg0._lateActive = arg0._active

	arg0:onLateStep()
end

function var0.onLateStep(arg0)
	return
end

function var0.active(arg0, arg1)
	arg0._active = arg1
end

function var0.onActive(arg0)
	return
end

function var0.keyTrigger(arg0, arg1, arg2)
	arg0._triggerKey = arg1
	arg0._triggerStatus = arg2

	arg0:onTrigger(arg1, arg2)
end

function var0.getWeight(arg0)
	return arg0._weight
end

return var0
