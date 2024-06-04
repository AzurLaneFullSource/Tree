local var0 = class("FuShunPowerSpeedScript", import("..RectBaseScript"))
local var1 = {
	400,
	450
}
local var2 = 20

function var0.onInit(arg0)
	arg0._loop = false
	arg0._active = false
	arg0._weight = 4
	arg0._overrideAble = false
	arg0._lastActive = false
	arg0._scriptTime = 10
	arg0._name = "FuShunPowerSpeedScript"
end

function var0.onStep(arg0)
	if arg0._active then
		local var0 = arg0._collisionInfo:getVelocity()
		local var1 = arg0._collisionInfo:getPos()

		if var1.y >= var1[2] then
			var0.y = -10
		elseif var1.y <= var1[1] then
			var0.y = 10
		else
			var0.y = 0
			var0.x = var2

			if not arg0.powerFlag then
				arg0._event:emit(Fushun3GameEvent.script_power_event)

				arg0.powerFlag = true
			end
		end

		arg0._collisionInfo:setVelocity(var0)
	else
		arg0.powerFlag = false

		if arg0._collisionInfo.script == arg0 then
			arg0._collisionInfo:removeScript()
		end
	end

	arg0._lastActive = arg0._active
end

function var0.onLateStep(arg0)
	return
end

function var0.onTrigger(arg0)
	return
end

return var0
