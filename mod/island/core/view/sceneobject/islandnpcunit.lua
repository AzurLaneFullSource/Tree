local var0_0 = class("IslandNpcUnit", import(".IslandNavigableUnit"))

function var0_0.OnInit(arg0_1)
	arg0_1._tf = arg0_1._go.transform
	arg0_1.degreeSpeedDamping = 10
	arg0_1.targetSpeed = 0
	arg0_1.speed = 0
	arg0_1.speedDamping = 1
	arg0_1.walkingMaxSpeed = 1.5
	arg0_1.runMaxSpeed = 5
	arg0_1.targetPosition = Vector3.zero
	arg0_1.velocity = Vector3.zero
	arg0_1.extraVelocity = Vector3.zero
	arg0_1.animator = arg0_1._go:GetComponent(typeof(Animator))
	arg0_1.characterController = arg0_1._go:GetComponent(typeof(UnityEngine.CharacterController))
end

function var0_0.SetDestination(arg0_2, arg1_2, arg2_2)
	arg0_2:SetNavAgentDestination(arg1_2)

	arg0_2.targetSpeed = Mathf.Clamp(arg2_2 or 0, arg0_2.walkingMaxSpeed, arg0_2.runMaxSpeed)
	arg0_2.targetPosition = arg1_2
end

function var0_0.StopMove(arg0_3)
	arg0_3:StopNavAgent()

	arg0_3.targetSpeed = 0
	arg0_3.targetPosition = Vector3.zero

	arg0_3.animator:SetFloat(IslandConst.SPEED_FLAG_HASH, 0)
end

function var0_0.OnUpdate(arg0_4)
	arg0_4.speed = Mathf.Lerp(arg0_4.speed, arg0_4.targetSpeed, arg0_4.speedDamping)

	arg0_4:SetNavAgentSpeed(arg0_4.speed * 0.5)
	arg0_4:Move()
	arg0_4.animator:SetFloat(IslandConst.SPEED_FLAG_HASH, arg0_4.speed)

	arg0_4.velocity = arg0_4:GetNavAgentVelocity()
end

function var0_0.Move(arg0_5)
	local var0_5 = arg0_5:GetDesiredVelocity() + arg0_5.extraVelocity

	if var0_5.magnitude <= 0 or var0_5.normalized == Vector3.zero then
		return
	end

	local var1_5 = Quaternion.LookRotation(var0_5.normalized)

	arg0_5._tf.rotation = Quaternion.Slerp(arg0_5._tf.rotation, var1_5, Time.deltaTime * arg0_5.degreeSpeedDamping)

	local var2_5 = Vector3.up * IslandConst.GRAVITY

	if Physics.CheckSphere(arg0_5._tf.position + Vector3.up * (arg0_5.characterController.radius - arg0_5.characterController.skinWidth), arg0_5.characterController.radius, LayerMask.GetMask("Ground")) then
		var2_5 = Vector3.zero
	end

	arg0_5.characterController:Move(var0_5.normalized * arg0_5:GetNavAgentSpeed() * Time.deltaTime + var2_5 * Time.deltaTime)
	arg0_5:SetNavAgentVelocity(arg0_5.characterController.velocity)
end

function var0_0.OnDispose(arg0_6)
	return
end

return var0_0
