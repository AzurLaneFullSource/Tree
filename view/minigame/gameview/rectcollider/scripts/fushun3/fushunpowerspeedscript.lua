local var0_0 = class("FuShunPowerSpeedScript", import("..RectBaseScript"))
local var1_0 = {
	400,
	450
}
local var2_0 = 20

function var0_0.onInit(arg0_1)
	arg0_1._loop = false
	arg0_1._active = false
	arg0_1._weight = 4
	arg0_1._overrideAble = false
	arg0_1._lastActive = false
	arg0_1._scriptTime = 10
	arg0_1._name = "FuShunPowerSpeedScript"
end

function var0_0.onStep(arg0_2)
	if arg0_2._active then
		local var0_2 = arg0_2._collisionInfo:getVelocity()
		local var1_2 = arg0_2._collisionInfo:getPos()

		if var1_2.y >= var1_0[2] then
			var0_2.y = -10
		elseif var1_2.y <= var1_0[1] then
			var0_2.y = 10
		else
			var0_2.y = 0
			var0_2.x = var2_0

			if not arg0_2.powerFlag then
				arg0_2._event:emit(Fushun3GameEvent.script_power_event)

				arg0_2.powerFlag = true
			end
		end

		arg0_2._collisionInfo:setVelocity(var0_2)
	else
		arg0_2.powerFlag = false

		if arg0_2._collisionInfo.script == arg0_2 then
			arg0_2._collisionInfo:removeScript()
		end
	end

	arg0_2._lastActive = arg0_2._active
end

function var0_0.onLateStep(arg0_3)
	return
end

function var0_0.onTrigger(arg0_4)
	return
end

return var0_0
