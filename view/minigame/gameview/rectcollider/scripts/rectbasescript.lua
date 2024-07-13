local var0_0 = class("RectBaseScript")

function var0_0.Ctor(arg0_1)
	arg0_1._weight = 1
	arg0_1._loop = false
	arg0_1._active = false
	arg0_1._scriptTime = 0
	arg0_1._overrideAble = false
	arg0_1._lateActive = false
	arg0_1._name = ""
end

function var0_0.init(arg0_2)
	return
end

function var0_0.setData(arg0_3, arg1_3, arg2_3, arg3_3)
	arg0_3._collisionInfo = arg1_3
	arg0_3._keyInfo = arg2_3
	arg0_3._event = arg3_3

	arg0_3:onInit()
end

function var0_0.step(arg0_4)
	arg0_4:onStep()

	arg0_4._triggerKey = nil
	arg0_4._triggerStatus = nil
end

function var0_0.addScriptApply(arg0_5)
	arg0_5._collisionInfo:removeScript()
	arg0_5._collisionInfo:setScript(arg0_5, arg0_5._weight, arg0_5._scriptTime, arg0_5._overrideAble)
end

function var0_0.checkScirptApply(arg0_6)
	if not arg0_6._collisionInfo.script then
		arg0_6:addScriptApply()

		return true
	elseif arg0_6._collisionInfo.script ~= arg0_6 and arg0_6._collisionInfo.scriptOverrideAble and arg0_6._collisionInfo.scriptWeight <= arg0_6._weight then
		arg0_6:addScriptApply()

		return true
	end

	print("当前脚本 " .. arg0_6._collisionInfo.script._name .. " 中，无法执行" .. arg0_6._name)

	return false
end

function var0_0.onStep(arg0_7)
	return
end

function var0_0.lateStep(arg0_8)
	arg0_8._lateActive = arg0_8._active

	arg0_8:onLateStep()
end

function var0_0.onLateStep(arg0_9)
	return
end

function var0_0.active(arg0_10, arg1_10)
	arg0_10._active = arg1_10
end

function var0_0.onActive(arg0_11)
	return
end

function var0_0.keyTrigger(arg0_12, arg1_12, arg2_12)
	arg0_12._triggerKey = arg1_12
	arg0_12._triggerStatus = arg2_12

	arg0_12:onTrigger(arg1_12, arg2_12)
end

function var0_0.getWeight(arg0_13)
	return arg0_13._weight
end

return var0_0
