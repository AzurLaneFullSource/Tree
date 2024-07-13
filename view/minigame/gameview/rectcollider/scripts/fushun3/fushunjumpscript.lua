local var0_0 = class("FuShunJumpScript", import("..RectBaseScript"))

function var0_0.onInit(arg0_1)
	arg0_1._loop = false
	arg0_1._active = false
	arg0_1._weight = 2
	arg0_1._scriptTime = 0.01
	arg0_1._lastActive = false
	arg0_1._name = "FuShunJumpScript"
end

function var0_0.onStep(arg0_2)
	if arg0_2._active then
		if arg0_2._collisionInfo.below and arg0_2._collisionInfo.useJumpTimes == 0 then
			local var0_2 = arg0_2._collisionInfo:getVelocity()

			var0_2.x = 0

			arg0_2._collisionInfo:setVelocity(var0_2)
		end
	elseif arg0_2._lastActive and arg0_2:checkScirptApply() and arg0_2._collisionInfo.below and arg0_2._collisionInfo.useJumpTimes == 0 then
		local var1_2 = arg0_2._collisionInfo:getVelocity()

		var1_2.y = arg0_2._collisionInfo.config.maxJumpVelocity
		arg0_2._collisionInfo.useJumpTimes = 1

		if arg0_2._event then
			arg0_2._event:emit(Fushun3GameEvent.script_jump_event)
		end

		var1_2.x = arg0_2._collisionInfo.config.moveSpeed

		arg0_2._collisionInfo:setVelocity(var1_2)
	end

	arg0_2._lastActive = arg0_2._active
end

function var0_0.onLateStep(arg0_3)
	if arg0_3._collisionInfo.below and arg0_3._collisionInfo.useJumpTimes == 1 then
		arg0_3._collisionInfo.useJumpTimes = 0
	end
end

function var0_0.onTrigger(arg0_4, arg1_4, arg2_4)
	if Application.isEditor and arg0_4._triggerKey == KeyCode.Space then
		if not arg2_4 then
			print()
		end

		if arg0_4:checkScirptApply() then
			arg0_4._active = true
		end
	end
end

return var0_0
