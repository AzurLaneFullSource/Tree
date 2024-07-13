local var0_0 = class("FuShunAttakeScript", import("..RectBaseScript"))

function var0_0.onInit(arg0_1)
	arg0_1._loop = false
	arg0_1._active = false
	arg0_1._weight = 2
	arg0_1._scriptTime = 0.4
	arg0_1._overrideAble = true
	arg0_1._name = "FuShunAttakeScript"
end

function var0_0.onStep(arg0_2)
	if arg0_2._active and arg0_2._collisionInfo.below and not arg0_2._lateActive then
		arg0_2._event:emit(Fushun3GameEvent.script_attack_event)
	end
end

function var0_0.onLateStep(arg0_3)
	return
end

function var0_0.onTrigger(arg0_4)
	if Application.isEditor and arg0_4._triggerKey == KeyCode.J and arg0_4._triggerStatus and arg0_4:checkScirptApply() then
		arg0_4._active = true
	end
end

return var0_0
