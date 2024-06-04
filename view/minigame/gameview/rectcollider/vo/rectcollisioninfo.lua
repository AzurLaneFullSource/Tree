local var0 = class("RectCollisionInfo")

function var0.Ctor(arg0, arg1)
	arg0.above = false
	arg0.below = false
	arg0.left = false
	arg0.right = false
	arg0.fullSliding = false
	arg0.climbingSlope = false
	arg0.descendingSlope = false
	arg0.slidingDownMaxSlope = false
	arg0.slopeAngle = 0
	arg0.slopeAngleOld = 0
	arg0.slopeNormal = Vector3.zero
	arg0.horizontalLeftTfs = {}
	arg0.horizontalRightTfs = {}
	arg0.verticalTopTfs = {}
	arg0.verticalBottomTfs = {}
	arg0.script = nil
	arg0.scriptWeight = nil
	arg0.scriptTime = nil
	arg0.scriptOverrideAble = nil
	arg0.frameRate = 0.0166666666666667
	arg0.config = RectCollisionData.New(arg1)
	arg0.layerMask = LayerMask.GetMask("Collider", "Character")
	arg0.ignoreLayerMask = {
		LayerMask.NameToLayer("Character")
	}
	arg0.playerInput = Vector2(0, 0)
	arg0.directionalInput = Vector2.zero
	arg0._velocity = Vector3.zero
	arg0.standingOnPlatform = false
	arg0.velocityXSmoothing = 0
	arg0.moveAmountOld = 0
	arg0.moveAmount = 0
	arg0.fallingThroughPlatform = false
	arg0.MoveDir = 1
	arg0.FaceDir = 1
	arg0.LockFaceDir = false
	arg0.useJumpTimes = 0
	arg0.holdInSlider = false
	arg0.lockHorizontalMove = false
	arg0.lockVerticalMove = false
	arg0.sprint = false
	arg0.damaged = false

	function arg0.wallSliding()
		return (arg0.left and arg0.FaceDir == -1 or arg0.right and arg0.FaceDir == 1) and not arg0.below and arg0.fullSliding
	end

	function arg0.wallSlidingDown()
		return arg0.wallSliding and arg0.moveAmount < 0
	end

	function arg0.wallDirX()
		return arg0:getWallDirX()
	end
end

function var0.getVelocity(arg0)
	return arg0._velocity
end

function var0.setVelocity(arg0, arg1)
	arg0._velocity.x = arg1.x
	arg0._velocity.y = arg1.y
	arg0._velocity.z = arg1.z
end

function var0.changeVelocity(arg0, arg1, arg2, arg3)
	arg0._velocity.x = arg1 or arg0._velocity.x
	arg0._velocity.y = arg2 or arg0._velocity.y
	arg0._velocity.z = arg3 or arg0._velocity.z
end

function var0.setPos(arg0, arg1)
	arg0._anchoredPosition = arg1
end

function var0.getPos(arg0)
	return arg0._anchoredPosition or Vector2.zero
end

function var0.setScript(arg0, arg1, arg2, arg3, arg4)
	arg0.script = arg1
	arg0.scriptWeight = arg2
	arg0.scriptTime = arg3
	arg0.scriptOverrideAble = arg4
end

function var0.removeScript(arg0)
	if arg0.script then
		arg0.script:active(false)
	end

	arg0.script = nil
	arg0.scriptWeight = nil
	arg0.scriptTime = nil
	arg0.scriptOverrideAble = nil
end

function var0.getWallDirX(arg0)
	if arg0.fullSliding then
		if arg0.left then
			return -1
		elseif arg0.right then
			return 1
		end
	end

	return 0
end

function var0.reset(arg0)
	arg0.above = false
	arg0.below = false
	arg0.left = false
	arg0.right = false
	arg0.climbingSlope = false
	arg0.descendingSlope = false
	arg0.slidingDownMaxSlope = false
	arg0.lockHorizontalMove = false
	arg0.lockVerticalMove = false
	arg0.fullSliding = false
	arg0.slopeNormal = Vector3.zero
	arg0.slopeAngleOld = arg0.slopeAngle
	arg0.slopeAngle = 0
	arg0.standingOnPlatform = false
	arg0.horizontalLeftTfs = {}
	arg0.horizontalRightTfs = {}
	arg0.verticalTopTfs = {}
	arg0.verticalBottomTfs = {}
end

return var0
