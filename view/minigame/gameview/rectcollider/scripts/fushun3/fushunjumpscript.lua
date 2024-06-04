local var0 = class("FuShunJumpScript", import("..RectBaseScript"))

function var0.onInit(arg0)
	arg0._loop = false
	arg0._active = false
	arg0._weight = 2
	arg0._scriptTime = 0.01
	arg0._lastActive = false
	arg0._name = "FuShunJumpScript"
end

function var0.onStep(arg0)
	if arg0._active then
		if arg0._collisionInfo.below and arg0._collisionInfo.useJumpTimes == 0 then
			local var0 = arg0._collisionInfo:getVelocity()

			var0.x = 0

			arg0._collisionInfo:setVelocity(var0)
		end
	elseif arg0._lastActive and arg0:checkScirptApply() and arg0._collisionInfo.below and arg0._collisionInfo.useJumpTimes == 0 then
		local var1 = arg0._collisionInfo:getVelocity()

		var1.y = arg0._collisionInfo.config.maxJumpVelocity
		arg0._collisionInfo.useJumpTimes = 1

		if arg0._event then
			arg0._event:emit(Fushun3GameEvent.script_jump_event)
		end

		var1.x = arg0._collisionInfo.config.moveSpeed

		arg0._collisionInfo:setVelocity(var1)
	end

	arg0._lastActive = arg0._active
end

function var0.onLateStep(arg0)
	if arg0._collisionInfo.below and arg0._collisionInfo.useJumpTimes == 1 then
		arg0._collisionInfo.useJumpTimes = 0
	end
end

function var0.onTrigger(arg0, arg1, arg2)
	if Application.isEditor and arg0._triggerKey == KeyCode.Space then
		if not arg2 then
			print()
		end

		if arg0:checkScirptApply() then
			arg0._active = true
		end
	end
end

return var0
