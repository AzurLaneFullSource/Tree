local var0 = class("FuShunMonsterScript", import("..RectBaseScript"))

function var0.onInit(arg0)
	arg0._loop = true
	arg0._active = true
	arg0._weight = 1
	arg0._scriptTime = nil
	arg0._collisionInfo.playerInput.x = math.random() > 0.5 and 1 or -1
	arg0._collisionInfo.directionalInput = arg0._collisionInfo.playerInput
	arg0._name = "FuShunMonsterScript"
end

function var0.onStep(arg0)
	arg0._collisionInfo.config.moveSpeed = 1

	if arg0._collisionInfo.left and arg0._collisionInfo.playerInput.x == -1 then
		arg0._collisionInfo.playerInput.x = 1
		arg0._collisionInfo.directionalInput = arg0._collisionInfo.playerInput
	elseif arg0._collisionInfo.right and arg0._collisionInfo.playerInput.x == 1 then
		arg0._collisionInfo.playerInput.x = -1
		arg0._collisionInfo.directionalInput = arg0._collisionInfo.playerInput
	end

	local var0 = arg0._collisionInfo.playerInput.x * arg0._collisionInfo.config.moveSpeed
	local var1 = arg0._collisionInfo:getVelocity()
	local var2 = arg0._collisionInfo.velocityXSmoothing

	if var1.x == var0 then
		var2 = 0
	end

	local var3 = arg0._collisionInfo.below and arg0._collisionInfo.config.accelerationTimeGrounded or arg0._collisionInfo.config.accelerationTimeAirborne
	local var4

	var1.x, var4 = Mathf.SmoothDamp(var1.x, var0, var2, var3)

	if not arg0._collisionInfo.below then
		var1.y = var1.y + arg0._collisionInfo.config.gravity * arg0._collisionInfo.frameRate
	end

	arg0._collisionInfo:setVelocity(var1)

	arg0._collisionInfo.velocityXSmoothing = var4
end

function var0.onLateStep(arg0)
	return
end

function var0.onTrigger(arg0)
	return
end

return var0
