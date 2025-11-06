local var0_0 = class("IslandNavigableUnit", import(".IslandSceneUnit"))

function var0_0.WarpAgent(arg0_1)
	arg0_1.agent:Warp(arg0_1._tf.position)

	local var0_1 = arg0_1.agent.steeringTarget - arg0_1._tf.position

	var0_1.y = 0

	if var0_1.sqrMagnitude > 0.001 then
		arg0_1._tf.rotation = Quaternion.LookRotation(var0_1)
	end
end

function var0_0.OnLaterAttach(arg0_2, arg1_2)
	arg0_2.agent = GetOrAddComponent(arg1_2, typeof(UnityEngine.AI.NavMeshAgent))
	arg0_2.agent.updatePosition = false
	arg0_2.agent.updateRotation = false
	arg0_2._tf = arg0_2._go.transform
	arg0_2._degreeSpeedDamping = 10
	arg0_2._targetSpeed = 0
	arg0_2._speed = 0
	arg0_2._speedDamping = 1
	arg0_2._walkingMaxSpeed = 1.5
	arg0_2._runMaxSpeed = 5
	arg0_2._targetPosition = Vector3.zero
	arg0_2.verticalVelocity = 0
	arg0_2.smoothVelocity = Vector3.zero
	arg0_2.elapsedTime = 0
	arg0_2._animator = arg0_2._tf:GetChild(0):GetComponent(typeof(Animator))
	arg0_2._characterController = arg0_2._go:GetComponent(typeof(UnityEngine.CharacterController))

	arg0_2:SetNavAgentStopDistance(2)

	arg0_2.isNavigating = false
end

function var0_0.SetDestination(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	arg0_3.agent.radius = defaultValue(arg3_3, 0.6)
	arg0_3._characterController.radius = defaultValue(arg4_3, 0.25)
	arg0_3.isNavigating = true

	arg0_3:SetNavAgentDestination(arg1_3)

	arg2_3 = Mathf.Clamp(arg2_3 or 0, arg0_3._walkingMaxSpeed, arg0_3._runMaxSpeed)

	arg0_3:SetNavAgentSpeed(arg2_3)

	arg0_3._targetPosition = arg1_3
	arg0_3.lastAvoidancePriority = arg0_3.agent.avoidancePriority
	arg0_3.agent.avoidancePriority = 0

	IslandHelper.SetLowQualityObstacle(arg0_3.agent)
end

function var0_0.StopMove(arg0_4)
	arg0_4.agent.avoidancePriority = defaultValue(arg0_4.lastAvoidancePriority, 10)
	arg0_4.isNavigating = false

	arg0_4:StopNavAgent()

	arg0_4._targetSpeed = 0
	arg0_4._characterController.radius = 0.5

	arg0_4:WarpAgent()

	arg0_4._targetPosition = Vector3.zero

	if arg0_4._animator then
		arg0_4._animator:SetFloat(IslandConst.SPEED_FLAG_HASH, 0)
	end

	arg0_4.agent.radius = 0.5

	IslandHelper.SetHighQualityObstacle(arg0_4.agent)
end

function var0_0.Update(arg0_5)
	if not arg0_5:IsLoaded() then
		return
	end

	arg0_5.elapsedTime = arg0_5.elapsedTime + Time.deltaTime

	if arg0_5.stateCallback then
		arg0_5:CheckAnimationState()
	end

	if not arg0_5.active then
		return
	end

	if arg0_5.isNavigating then
		arg0_5:NavUpdate()
	else
		var0_0.super.Update(arg0_5)
	end
end

function var0_0.GetElapsedTime(arg0_6)
	return arg0_6.elapsedTime
end

function var0_0.NavUpdate(arg0_7)
	if not arg0_7.agent then
		return
	end

	if not arg0_7.agent.pathPending and arg0_7.agent.remainingDistance <= arg0_7.agent.stoppingDistance then
		if not arg0_7.agent.hasPath or arg0_7.agent.velocity.sqrMagnitude < 0.01 then
			arg0_7.reached = true
		end
	else
		arg0_7.reached = false
	end

	local var0_7 = Vector3.zero

	if not arg0_7.reached then
		local var1_7 = arg0_7.agent.velocity
		local var2_7 = Vector3(var1_7.x, 0, var1_7.z)
		local var3_7 = 1
		local var4_7 = arg0_7.agent.stoppingDistance * 2

		if var4_7 > arg0_7.agent.remainingDistance then
			var3_7 = arg0_7.agent.remainingDistance / var4_7
		end

		arg0_7.smoothVelocity = Vector3.Lerp(arg0_7.smoothVelocity or Vector3.zero, var2_7 * var3_7, Time.deltaTime * 10)
		var0_7 = arg0_7.smoothVelocity
	end

	local var5_7 = Vector3(var0_7.x, 0, var0_7.z)

	if not arg0_7.reached and var5_7.sqrMagnitude > 0.05 then
		local var6_7 = Quaternion.LookRotation(var5_7)

		arg0_7._tf.rotation = Quaternion.Slerp(arg0_7._tf.rotation, var6_7, Time.deltaTime * 10)
	end

	if arg0_7._characterController.isGrounded then
		arg0_7.verticalVelocity = -0.1
	else
		arg0_7.verticalVelocity = arg0_7.verticalVelocity + -9.81 * Time.deltaTime
	end

	var0_7.y = arg0_7.verticalVelocity

	arg0_7._characterController:Move(var0_7 * Time.deltaTime)

	local var7_7 = arg0_7._tf.position

	arg0_7.agent.nextPosition = Vector3.Lerp(arg0_7.agent.nextPosition, var7_7, Time.deltaTime * 20)

	local var8_7 = var5_7.magnitude * 1.5

	if arg0_7._animator then
		arg0_7._animator:SetFloat(IslandConst.SPEED_FLAG_HASH, var8_7)
	end
end

function var0_0.SetNavAgentStopDistance(arg0_8, arg1_8)
	arg0_8.agent.stoppingDistance = arg1_8
end

function var0_0.SetNavAgentDestination(arg0_9, arg1_9)
	arg0_9.agent.isStopped = false
	arg0_9.agent.destination = arg1_9
end

function var0_0.SetNavPosition(arg0_10, arg1_10)
	arg0_10.agent.nextPosition = arg1_10
end

function var0_0.CalculateNavPath(arg0_11, arg1_11)
	local var0_11 = UnityEngine.AI.NavMeshPath.New()

	arg0_11.agent:CalculatePath(arg1_11, var0_11)

	return (var0_11.corners:ToTable())
end

function var0_0.SetNavAgentSpeed(arg0_12, arg1_12)
	arg0_12.agent.speed = arg1_12
end

function var0_0.GetNavAgentSpeed(arg0_13, arg1_13)
	return arg0_13.agent.speed
end

function var0_0.SetNavAgentVelocity(arg0_14, arg1_14)
	arg0_14.agent.velocity = arg1_14
end

function var0_0.GetNavAgentVelocity(arg0_15)
	return arg0_15.agent.desiredVelocity * arg0_15.agent.speed
end

function var0_0.GetDesiredVelocity(arg0_16)
	return arg0_16.agent.desiredVelocity
end

function var0_0.StopNavAgent(arg0_17)
	arg0_17.agent.isStopped = true
end

function var0_0.GetAnimator(arg0_18)
	return arg0_18._animator
end

function var0_0.CheckMovement(arg0_19)
	local var0_19 = arg0_19:GetAnimator():GetCurrentAnimatorStateInfo(0)

	if arg0_19.cantMove then
		return false
	end

	if _.any(IslandConst.CANT_SWITCH_TO_MOVEMENT_STATES, function(arg0_20)
		return var0_19:IsName(arg0_20)
	end) then
		return false
	end

	local var1_19 = IslandConst.ANIMATION_MOVEMENT

	if not var0_19:IsName(var1_19) then
		arg0_19:PlayAnimation(var1_19, 0)

		return true
	end

	arg0_19:ClearSatetCallback()

	return false
end

function var0_0.PlayAnimation(arg0_21, arg1_21, arg2_21, arg3_21)
	local var0_21 = defaultValue(arg2_21, 0.25)

	if arg1_21 == IslandConst.ANIMATION_HEROCOMING then
		var0_21 = 0
	end

	local var1_21 = arg0_21:GetAnimator()
	local var2_21 = Animator.StringToHash(arg1_21)

	for iter0_21 = 1, var1_21.layerCount do
		var1_21:CrossFadeInFixedTime(var2_21, var0_21, iter0_21 - 1)
	end

	if arg3_21 then
		arg0_21.stateCallback = {
			state = arg1_21,
			callback = arg3_21
		}
	end
end

function var0_0.CheckAnimationState(arg0_22)
	local var0_22 = arg0_22.stateCallback.state
	local var1_22 = arg0_22.stateCallback.callback
	local var2_22 = arg0_22:GetAnimator()
	local var3_22 = var2_22:GetCurrentAnimatorStateInfo(0)

	if var3_22:IsName(var0_22) and not arg0_22.endTime then
		local var4_22 = var3_22.length / var2_22.speed

		arg0_22.endTime = arg0_22:GetElapsedTime() + var4_22
	end

	if arg0_22.endTime and arg0_22:GetElapsedTime() >= arg0_22.endTime then
		var1_22()
		arg0_22:ClearSatetCallback()
	end
end

function var0_0.ClearSatetCallback(arg0_23)
	if arg0_23.stateCallback then
		arg0_23.stateCallback = nil
	end

	arg0_23.endTime = nil
end

function var0_0.Enable(arg0_24)
	var0_0.super.Enable(arg0_24)

	if not arg0_24:IsLoaded() then
		return
	end

	arg0_24.agent.enabled = true
end

function var0_0.Disable(arg0_25)
	var0_0.super.Disable(arg0_25)

	if not arg0_25:IsLoaded() then
		return
	end

	arg0_25.agent.enabled = false
end

function var0_0.Dispose(arg0_26)
	var0_0.super.Dispose(arg0_26)
	arg0_26:ClearSatetCallback()
end

return var0_0
