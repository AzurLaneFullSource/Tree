local var0_0 = class("RectCollisionInfo")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.above = false
	arg0_1.below = false
	arg0_1.left = false
	arg0_1.right = false
	arg0_1.fullSliding = false
	arg0_1.climbingSlope = false
	arg0_1.descendingSlope = false
	arg0_1.slidingDownMaxSlope = false
	arg0_1.slopeAngle = 0
	arg0_1.slopeAngleOld = 0
	arg0_1.slopeNormal = Vector3.zero
	arg0_1.horizontalLeftTfs = {}
	arg0_1.horizontalRightTfs = {}
	arg0_1.verticalTopTfs = {}
	arg0_1.verticalBottomTfs = {}
	arg0_1.script = nil
	arg0_1.scriptWeight = nil
	arg0_1.scriptTime = nil
	arg0_1.scriptOverrideAble = nil
	arg0_1.frameRate = 0.0166666666666667
	arg0_1.config = RectCollisionData.New(arg1_1)
	arg0_1.layerMask = LayerMask.GetMask("Collider", "Character")
	arg0_1.ignoreLayerMask = {
		LayerMask.NameToLayer("Character")
	}
	arg0_1.playerInput = Vector2(0, 0)
	arg0_1.directionalInput = Vector2.zero
	arg0_1._velocity = Vector3.zero
	arg0_1.standingOnPlatform = false
	arg0_1.velocityXSmoothing = 0
	arg0_1.moveAmountOld = 0
	arg0_1.moveAmount = 0
	arg0_1.fallingThroughPlatform = false
	arg0_1.MoveDir = 1
	arg0_1.FaceDir = 1
	arg0_1.LockFaceDir = false
	arg0_1.useJumpTimes = 0
	arg0_1.holdInSlider = false
	arg0_1.lockHorizontalMove = false
	arg0_1.lockVerticalMove = false
	arg0_1.sprint = false
	arg0_1.damaged = false

	function arg0_1.wallSliding()
		return (arg0_1.left and arg0_1.FaceDir == -1 or arg0_1.right and arg0_1.FaceDir == 1) and not arg0_1.below and arg0_1.fullSliding
	end

	function arg0_1.wallSlidingDown()
		return arg0_1.wallSliding and arg0_1.moveAmount < 0
	end

	function arg0_1.wallDirX()
		return arg0_1:getWallDirX()
	end
end

function var0_0.getVelocity(arg0_5)
	return arg0_5._velocity
end

function var0_0.setVelocity(arg0_6, arg1_6)
	arg0_6._velocity.x = arg1_6.x
	arg0_6._velocity.y = arg1_6.y
	arg0_6._velocity.z = arg1_6.z
end

function var0_0.changeVelocity(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7._velocity.x = arg1_7 or arg0_7._velocity.x
	arg0_7._velocity.y = arg2_7 or arg0_7._velocity.y
	arg0_7._velocity.z = arg3_7 or arg0_7._velocity.z
end

function var0_0.setPos(arg0_8, arg1_8)
	arg0_8._anchoredPosition = arg1_8
end

function var0_0.getPos(arg0_9)
	return arg0_9._anchoredPosition or Vector2.zero
end

function var0_0.setScript(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10)
	arg0_10.script = arg1_10
	arg0_10.scriptWeight = arg2_10
	arg0_10.scriptTime = arg3_10
	arg0_10.scriptOverrideAble = arg4_10
end

function var0_0.removeScript(arg0_11)
	if arg0_11.script then
		arg0_11.script:active(false)
	end

	arg0_11.script = nil
	arg0_11.scriptWeight = nil
	arg0_11.scriptTime = nil
	arg0_11.scriptOverrideAble = nil
end

function var0_0.getWallDirX(arg0_12)
	if arg0_12.fullSliding then
		if arg0_12.left then
			return -1
		elseif arg0_12.right then
			return 1
		end
	end

	return 0
end

function var0_0.reset(arg0_13)
	arg0_13.above = false
	arg0_13.below = false
	arg0_13.left = false
	arg0_13.right = false
	arg0_13.climbingSlope = false
	arg0_13.descendingSlope = false
	arg0_13.slidingDownMaxSlope = false
	arg0_13.lockHorizontalMove = false
	arg0_13.lockVerticalMove = false
	arg0_13.fullSliding = false
	arg0_13.slopeNormal = Vector3.zero
	arg0_13.slopeAngleOld = arg0_13.slopeAngle
	arg0_13.slopeAngle = 0
	arg0_13.standingOnPlatform = false
	arg0_13.horizontalLeftTfs = {}
	arg0_13.horizontalRightTfs = {}
	arg0_13.verticalTopTfs = {}
	arg0_13.verticalBottomTfs = {}
end

return var0_0
