local var0_0 = class("FuShunMovementScript", import("..RectBaseScript"))

function var0_0.onInit(arg0_1)
	arg0_1._loop = true
	arg0_1._active = true
	arg0_1._weight = 1
	arg0_1._scriptTime = nil
	arg0_1._name = "FuShunMovementScript"
end

function var0_0.onStep(arg0_2)
	arg0_2._collisionInfo.playerInput.x = 1

	local var0_2 = arg0_2._collisionInfo.playerInput.x * arg0_2._collisionInfo.config.moveSpeed
	local var1_2 = arg0_2._collisionInfo:getVelocity()
	local var2_2 = arg0_2._collisionInfo.velocityXSmoothing

	if var1_2.x == var0_2 then
		var2_2 = 0
	end

	local var3_2 = arg0_2._collisionInfo.below and arg0_2._collisionInfo.config.accelerationTimeGrounded or arg0_2._collisionInfo.config.accelerationTimeAirborne
	local var4_2

	var1_2.x, var4_2 = Mathf.SmoothDamp(var1_2.x, var0_2, var2_2, var3_2)

	if not arg0_2._collisionInfo.below then
		var1_2.y = var1_2.y + arg0_2._collisionInfo.config.gravity * arg0_2._collisionInfo.frameRate
	end

	arg0_2._collisionInfo:setVelocity(var1_2)

	arg0_2._collisionInfo.velocityXSmoothing = var4_2
end

function var0_0.onLateStep(arg0_3)
	return
end

function var0_0.onTrigger(arg0_4)
	if Application.isEditor and arg0_4._triggerKey == KeyCode.A or arg0_4._triggerKey == KeyCode.D then
		local var0_4 = arg0_4._keyInfo:getKeyCode(KeyCode.A)
		local var1_4 = arg0_4._keyInfo:getKeyCode(KeyCode.D)

		if arg0_4._triggerKey == KeyCode.A then
			arg0_4._collisionInfo.playerInput.x = arg0_4._triggerStatus and -1 or var1_4 and 1 or 0
		elseif arg0_4._triggerKey == KeyCode.D then
			arg0_4._collisionInfo.playerInput.x = arg0_4._triggerStatus and 1 or var0_4 and -1 or 0
		end

		arg0_4._collisionInfo.directionalInput = arg0_4._collisionInfo.playerInput
	end
end

return var0_0
