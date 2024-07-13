local var0_0 = class("RectCollisionData")

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.maxSlopeAngle = 45
	arg0_1.downMaxSlopeSpeed = 8
	arg0_1.gravity = -50
	arg0_1.maxJumpHeight = 4
	arg0_1.minJumpHeight = 2
	arg0_1.accelerationTimeAirborne = 0.05
	arg0_1.accelerationTimeGrounded = 0.05
	arg0_1.moveSpeed = 8
	arg0_1.wallJumpClimb = 10
	arg0_1.wallJumpOff = 10
	arg0_1.wallLeap = 10
	arg0_1.wallSlideSpeedMax = 3
	arg0_1.wallStickTime = 0.25
	arg0_1.jumpStickTime = 0.01
	arg0_1.jumpTimes = 0
	arg0_1.jumpHeights = {
		50,
		30
	}
	arg0_1.useSprint = false
	arg0_1.sprintDistance = 5
	arg0_1.sprintSpeed = 0
	arg0_1.sprintDirect = true
	arg0_1.sprintStopWithCollision = false
	arg0_1.sprintStickTime = 0
	arg0_1.holdInSlider = false

	if arg0_1.gravity ~= 0 then
		arg0_1.timeToJumpApex = math.sqrt(-(2 * arg0_1.maxJumpHeight) / arg0_1.gravity)
		arg0_1.maxJumpVelocity = math.abs(arg0_1.gravity) * arg0_1.timeToJumpApex
		arg0_1.minJumpVelocity = math.sqrt(2 * Mathf.Abs(arg0_1.gravity) * arg0_1.minJumpHeight)
		arg0_1.jumpVelocitys = {}
		arg0_1.jumpTimes = arg0_1.jumpTimes <= 0 and 1 or arg0_1.jumpTimes

		if arg0_1.jumpHeights ~= nil then
			for iter0_1 = 1, #arg0_1.jumpHeights do
				arg0_1.timeToJumpApex = math.sqrt(-(2 * arg0_1.jumpHeights[iter0_1]) / arg0_1.gravity)

				table.insert(arg0_1.jumpVelocitys, math.abs(arg0_1.gravity) * arg0_1.timeToJumpApex)
			end
		end
	end
end

return var0_0
