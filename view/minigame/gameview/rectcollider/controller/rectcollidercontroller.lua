local var0_0 = class("RectColliderController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.collisionInfo = arg1_1
	arg0_1.origins = arg2_1
	arg0_1.zeroVec = Vector2.zero
end

function var0_0.platformMove(arg0_2, arg1_2)
	arg0_2.collisionInfo.standingOnPlatform = true

	arg0_2:move(arg1_2)
end

function var0_0.move(arg0_3, arg1_3)
	arg0_3:updateCollisionInfo(arg1_3)

	if arg1_3.y <= 0 then
		RectCollisionVertical.DescendSlope(arg1_3, arg0_3.collisionInfo, arg0_3.origins)
	end

	RectCollisionHorizontal.HorizontalCollisions(arg1_3, arg0_3.collisionInfo, arg0_3.origins)

	if arg1_3.y ~= 0 then
		RectCollisionVertical.VerticalCollisions(arg1_3, arg0_3.collisionInfo, arg0_3.origins)
	end

	arg0_3.collisionInfo.moveAmount = arg1_3

	arg0_3:afterUpdateCollisionInfo()
end

function var0_0.updateCollisionInfo(arg0_4, arg1_4)
	arg0_4.origins:updateRaycastOrigins()
	arg0_4.collisionInfo:reset()

	arg0_4.collisionInfo.moveAmountOld = arg1_4
	arg0_4.collisionInfo.MoveDir = arg1_4.x > 0 and 1 or arg0_4.collisionInfo.MoveDir
	arg0_4.collisionInfo.MoveDir = arg1_4.x < 0 and -1 or arg0_4.collisionInfo.MoveDir
end

function var0_0.afterUpdateCollisionInfo(arg0_5)
	arg0_5.collisionInfo.below = arg0_5.collisionInfo.standingOnPlatform or arg0_5.collisionInfo.below
end

return var0_0
