local var0 = class("RectColliderController")

function var0.Ctor(arg0, arg1, arg2)
	arg0.collisionInfo = arg1
	arg0.origins = arg2
	arg0.zeroVec = Vector2.zero
end

function var0.platformMove(arg0, arg1)
	arg0.collisionInfo.standingOnPlatform = true

	arg0:move(arg1)
end

function var0.move(arg0, arg1)
	arg0:updateCollisionInfo(arg1)

	if arg1.y <= 0 then
		RectCollisionVertical.DescendSlope(arg1, arg0.collisionInfo, arg0.origins)
	end

	RectCollisionHorizontal.HorizontalCollisions(arg1, arg0.collisionInfo, arg0.origins)

	if arg1.y ~= 0 then
		RectCollisionVertical.VerticalCollisions(arg1, arg0.collisionInfo, arg0.origins)
	end

	arg0.collisionInfo.moveAmount = arg1

	arg0:afterUpdateCollisionInfo()
end

function var0.updateCollisionInfo(arg0, arg1)
	arg0.origins:updateRaycastOrigins()
	arg0.collisionInfo:reset()

	arg0.collisionInfo.moveAmountOld = arg1
	arg0.collisionInfo.MoveDir = arg1.x > 0 and 1 or arg0.collisionInfo.MoveDir
	arg0.collisionInfo.MoveDir = arg1.x < 0 and -1 or arg0.collisionInfo.MoveDir
end

function var0.afterUpdateCollisionInfo(arg0)
	arg0.collisionInfo.below = arg0.collisionInfo.standingOnPlatform or arg0.collisionInfo.below
end

return var0
