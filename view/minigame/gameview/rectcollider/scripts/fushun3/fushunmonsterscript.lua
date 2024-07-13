local var0_0 = class("FuShunMonsterScript", import("..RectBaseScript"))

function var0_0.onInit(arg0_1)
	arg0_1._loop = true
	arg0_1._active = true
	arg0_1._weight = 1
	arg0_1._scriptTime = nil
	arg0_1._collisionInfo.playerInput.x = math.random() > 0.5 and 1 or -1
	arg0_1._collisionInfo.directionalInput = arg0_1._collisionInfo.playerInput
	arg0_1._name = "FuShunMonsterScript"
end

function var0_0.onStep(arg0_2)
	arg0_2._collisionInfo.config.moveSpeed = 1

	if arg0_2._collisionInfo.left and arg0_2._collisionInfo.playerInput.x == -1 then
		arg0_2._collisionInfo.playerInput.x = 1
		arg0_2._collisionInfo.directionalInput = arg0_2._collisionInfo.playerInput
	elseif arg0_2._collisionInfo.right and arg0_2._collisionInfo.playerInput.x == 1 then
		arg0_2._collisionInfo.playerInput.x = -1
		arg0_2._collisionInfo.directionalInput = arg0_2._collisionInfo.playerInput
	end

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
	return
end

return var0_0
