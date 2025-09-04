local var0_0 = class("IslandNavigableUnit", import(".IslandSceneUnit"))

function var0_0.OnLaterAttach(arg0_1, arg1_1)
	arg0_1.agent = GetOrAddComponent(arg1_1, typeof(UnityEngine.AI.NavMeshAgent))
	arg0_1.agent.updatePosition = false
	arg0_1.agent.updateRotation = false
	arg0_1._tf = arg0_1._go.transform
	arg0_1._degreeSpeedDamping = 10
	arg0_1._targetSpeed = 0
	arg0_1._speed = 0
	arg0_1._speedDamping = 1
	arg0_1._walkingMaxSpeed = 1.5
	arg0_1._runMaxSpeed = 5
	arg0_1._targetPosition = Vector3.zero
	arg0_1._velocity = Vector3.zero
	arg0_1._extraVelocity = Vector3.zero
	arg0_1._animator = arg0_1._tf:GetChild(0):GetComponent(typeof(Animator))
	arg0_1._characterController = arg0_1._go:GetComponent(typeof(UnityEngine.CharacterController))

	arg0_1:SetNavAgentStopDistance(2)

	arg0_1.lookingFor = false
end

function var0_0.SetDestination(arg0_2, arg1_2, arg2_2)
	arg0_2.agent:Warp(arg0_2._tf.position)

	arg0_2.lookingFor = true

	arg0_2:SetNavAgentDestination(arg1_2)

	arg0_2._targetSpeed = Mathf.Clamp(arg2_2 or 0, arg0_2._walkingMaxSpeed, arg0_2._runMaxSpeed)
	arg0_2._targetPosition = arg1_2
end

function var0_0.StopMove(arg0_3)
	arg0_3.lookingFor = false

	arg0_3:StopNavAgent()

	arg0_3._targetSpeed = 0
	arg0_3._targetPosition = Vector3.zero

	arg0_3._animator:SetFloat(IslandConst.SPEED_FLAG_HASH, 0)
end

function var0_0.OnUpdate(arg0_4)
	if arg0_4.lookingFor then
		arg0_4:NavUpdate()
	else
		arg0_4:OnNormalUpdate()
	end
end

function var0_0.NavUpdate(arg0_5)
	arg0_5._speed = Mathf.Lerp(arg0_5._speed, arg0_5._targetSpeed, arg0_5._speedDamping)

	arg0_5:SetNavAgentSpeed(arg0_5._speed * 0.5)
	arg0_5:_Move()
	arg0_5._animator:SetFloat(IslandConst.SPEED_FLAG_HASH, arg0_5._speed)

	arg0_5._velocity = arg0_5:GetNavAgentVelocity()
end

function var0_0._Move(arg0_6)
	local var0_6 = arg0_6:GetDesiredVelocity() + arg0_6._extraVelocity

	if var0_6.magnitude <= 0 or var0_6.normalized == Vector3.zero then
		return
	end

	local var1_6 = Quaternion.LookRotation(var0_6.normalized)

	arg0_6._tf.rotation = Quaternion.Slerp(arg0_6._tf.rotation, var1_6, Time.deltaTime * arg0_6._degreeSpeedDamping)

	local var2_6 = Vector3.up * IslandConst.GRAVITY

	if Physics.CheckSphere(arg0_6._tf.position + Vector3.up * (arg0_6._characterController.radius - arg0_6._characterController.skinWidth), arg0_6._characterController.radius, LayerMask.GetMask("Ground")) then
		var2_6 = Vector3.zero
	end

	arg0_6._characterController:Move(var0_6.normalized * arg0_6:GetNavAgentSpeed() * Time.deltaTime + var2_6 * Time.deltaTime)
	arg0_6:SetNavAgentVelocity(arg0_6._characterController.velocity)
end

function var0_0.SetNavAgentStopDistance(arg0_7, arg1_7)
	arg0_7.agent.stoppingDistance = arg1_7
end

function var0_0.SetNavAgentDestination(arg0_8, arg1_8)
	arg0_8.agent.isStopped = false
	arg0_8.agent.destination = arg1_8
end

function var0_0.SetNavPosition(arg0_9, arg1_9)
	arg0_9.agent.nextPosition = arg1_9
end

function var0_0.CalculateNavPath(arg0_10, arg1_10)
	local var0_10 = UnityEngine.AI.NavMeshPath.New()

	arg0_10.agent:CalculatePath(arg1_10, var0_10)

	return (var0_10.corners:ToTable())
end

function var0_0.SetNavAgentSpeed(arg0_11, arg1_11)
	arg0_11.agent.speed = arg1_11
end

function var0_0.GetNavAgentSpeed(arg0_12, arg1_12)
	return arg0_12.agent.speed
end

function var0_0.SetNavAgentVelocity(arg0_13, arg1_13)
	arg0_13.agent.velocity = arg1_13
end

function var0_0.GetNavAgentVelocity(arg0_14)
	return arg0_14.agent.desiredVelocity * arg0_14.agent.speed
end

function var0_0.GetDesiredVelocity(arg0_15)
	return arg0_15.agent.desiredVelocity
end

function var0_0.StopNavAgent(arg0_16)
	arg0_16.agent.isStopped = true
end

function var0_0.OnNormalUpdate(arg0_17, ...)
	return
end

function var0_0.GetAnimator(arg0_18)
	return arg0_18._animator
end

function var0_0.Enable(arg0_19)
	var0_0.super.Enable(arg0_19)

	if not arg0_19:IsLoaded() then
		return
	end

	arg0_19.agent.enabled = true
end

function var0_0.Disable(arg0_20)
	var0_0.super.Disable(arg0_20)

	if not arg0_20:IsLoaded() then
		return
	end

	arg0_20.agent.enabled = false
end

return var0_0
