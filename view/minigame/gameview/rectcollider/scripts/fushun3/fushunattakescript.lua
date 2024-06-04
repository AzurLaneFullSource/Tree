local var0 = class("FuShunAttakeScript", import("..RectBaseScript"))

function var0.onInit(arg0)
	arg0._loop = false
	arg0._active = false
	arg0._weight = 2
	arg0._scriptTime = 0.4
	arg0._overrideAble = true
	arg0._name = "FuShunAttakeScript"
end

function var0.onStep(arg0)
	if arg0._active and arg0._collisionInfo.below and not arg0._lateActive then
		arg0._event:emit(Fushun3GameEvent.script_attack_event)
	end
end

function var0.onLateStep(arg0)
	return
end

function var0.onTrigger(arg0)
	if Application.isEditor and arg0._triggerKey == KeyCode.J and arg0._triggerStatus and arg0:checkScirptApply() then
		arg0._active = true
	end
end

return var0
