local var0 = class("RectCollisionData")

function var0.Ctor(arg0, arg1)
	arg0.maxSlopeAngle = 45
	arg0.downMaxSlopeSpeed = 8
	arg0.gravity = -50
	arg0.maxJumpHeight = 4
	arg0.minJumpHeight = 2
	arg0.accelerationTimeAirborne = 0.05
	arg0.accelerationTimeGrounded = 0.05
	arg0.moveSpeed = 8
	arg0.wallJumpClimb = 10
	arg0.wallJumpOff = 10
	arg0.wallLeap = 10
	arg0.wallSlideSpeedMax = 3
	arg0.wallStickTime = 0.25
	arg0.jumpStickTime = 0.01
	arg0.jumpTimes = 0
	arg0.jumpHeights = {
		50,
		30
	}
	arg0.useSprint = false
	arg0.sprintDistance = 5
	arg0.sprintSpeed = 0
	arg0.sprintDirect = true
	arg0.sprintStopWithCollision = false
	arg0.sprintStickTime = 0
	arg0.holdInSlider = false

	if arg0.gravity ~= 0 then
		arg0.timeToJumpApex = math.sqrt(-(2 * arg0.maxJumpHeight) / arg0.gravity)
		arg0.maxJumpVelocity = math.abs(arg0.gravity) * arg0.timeToJumpApex
		arg0.minJumpVelocity = math.sqrt(2 * Mathf.Abs(arg0.gravity) * arg0.minJumpHeight)
		arg0.jumpVelocitys = {}
		arg0.jumpTimes = arg0.jumpTimes <= 0 and 1 or arg0.jumpTimes

		if arg0.jumpHeights ~= nil then
			for iter0 = 1, #arg0.jumpHeights do
				arg0.timeToJumpApex = math.sqrt(-(2 * arg0.jumpHeights[iter0]) / arg0.gravity)

				table.insert(arg0.jumpVelocitys, math.abs(arg0.gravity) * arg0.timeToJumpApex)
			end
		end
	end
end

return var0
