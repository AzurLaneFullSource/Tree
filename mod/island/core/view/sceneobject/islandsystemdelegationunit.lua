local var0_0 = class("IslandSystemDelegationUnit", import(".IslandNpcUnit"))

function var0_0.OnLaterAttach(arg0_1, arg1_1)
	arg0_1.agent = GetOrAddComponent(arg1_1, typeof(UnityEngine.AI.NavMeshAgent))
	arg0_1.agent.updatePosition = true
	arg0_1.agent.updateRotation = true
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
	arg0_1.elapsedTime = 0
	arg0_1.isNavigating = false

	local var0_1 = pg.island_unit_character[arg0_1.modelId]

	arg0_1._characterController = arg0_1._go:GetComponent(typeof(UnityEngine.CharacterController))

	if var0_1.CollisionParam ~= "" then
		arg0_1._characterController.enabled = false

		local var1_1 = GetOrAddComponent(arg0_1._go, typeof("UnityEngine.CapsuleCollider"))

		ReflectionHelp.RefSetProperty(typeof("UnityEngine.CapsuleCollider"), "center", var1_1, Vector3(0, var0_1.CollisionParam[1], 0))
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.CapsuleCollider"), "radius", var1_1, var0_1.CollisionParam[2])
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.CapsuleCollider"), "height", var1_1, var0_1.CollisionParam[3])

		arg0_1.agent.radius = var0_1.CollisionParam[2]
	else
		arg0_1._characterController.enabled = false

		local var2_1 = GetOrAddComponent(arg0_1._go, typeof("UnityEngine.CapsuleCollider"))

		ReflectionHelp.RefSetProperty(typeof("UnityEngine.CapsuleCollider"), "center", var2_1, Vector3(0, 0.96, 0))
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.CapsuleCollider"), "radius", var2_1, 0.5)
		ReflectionHelp.RefSetProperty(typeof("UnityEngine.CapsuleCollider"), "height", var2_1, 1.76)

		arg0_1.agent.radius = 0.5
	end

	arg0_1:SetNavAgentStopDistance(2.1)

	arg0_1.isNavigating = false
end

function var0_0.SetDestination(arg0_2, arg1_2, arg2_2)
	arg0_2.isNavigating = true

	arg0_2:SetNavAgentDestination(arg1_2)

	arg0_2._targetSpeed = Mathf.Clamp(arg2_2 or 0, arg0_2._walkingMaxSpeed, arg0_2._runMaxSpeed)
	arg0_2._targetPosition = arg1_2
end

function var0_0.StopMove(arg0_3)
	arg0_3.isNavigating = false

	arg0_3:StopNavAgent()

	arg0_3._targetSpeed = 0
	arg0_3._targetPosition = Vector3.zero

	if not arg0_3.isLoading then
		arg0_3._animator:SetFloat(IslandConst.SPEED_FLAG_HASH, 0)
	end
end

function var0_0.Update(arg0_4)
	if not arg0_4:IsLoaded() then
		return
	end

	if not arg0_4.active then
		return
	end

	if arg0_4.isNavigating then
		arg0_4:NavUpdate()
	else
		var0_0.super.Update(arg0_4)
	end
end

function var0_0.NavUpdate(arg0_5)
	arg0_5._speed = Mathf.Lerp(arg0_5._speed, arg0_5._targetSpeed, arg0_5._speedDamping)

	arg0_5:SetNavAgentSpeed(arg0_5._speed * 0.5)

	if not arg0_5.isLoading then
		arg0_5._animator:SetFloat(IslandConst.SPEED_FLAG_HASH, arg0_5._speed)
	end
end

function var0_0.SetNavAgentStopDistance(arg0_6, arg1_6)
	arg0_6.agent.stoppingDistance = arg1_6
end

function var0_0.SetNavAgentDestination(arg0_7, arg1_7)
	arg0_7.agent.isStopped = false
	arg0_7.agent.destination = arg1_7
end

function var0_0.SetNavPosition(arg0_8, arg1_8)
	arg0_8.agent.nextPosition = arg1_8
end

function var0_0.CalculateNavPath(arg0_9, arg1_9)
	local var0_9 = UnityEngine.AI.NavMeshPath.New()

	arg0_9.agent:CalculatePath(arg1_9, var0_9)

	return (var0_9.corners:ToTable())
end

function var0_0.SetNavAgentSpeed(arg0_10, arg1_10)
	arg0_10.agent.speed = arg1_10
end

function var0_0.GetNavAgentSpeed(arg0_11, arg1_11)
	return arg0_11.agent.speed
end

function var0_0.SetNavAgentVelocity(arg0_12, arg1_12)
	arg0_12.agent.velocity = arg1_12
end

function var0_0.GetNavAgentVelocity(arg0_13)
	return arg0_13.agent.desiredVelocity * arg0_13.agent.speed
end

function var0_0.GetDesiredVelocity(arg0_14)
	return arg0_14.agent.desiredVelocity
end

function var0_0.StopNavAgent(arg0_15)
	arg0_15.agent.isStopped = true
end

function var0_0.GetAnimator(arg0_16)
	return arg0_16._animator
end

function var0_0.SetShipDressHelper(arg0_17, arg1_17)
	arg0_17.shipDressHelper = arg1_17
end

function var0_0.OnDetach(arg0_18)
	if arg0_18.shipDressHelper then
		arg0_18.shipDressHelper:Destroy()
	end
end

function var0_0.OnCharacterChangeDress(arg0_19, arg1_19, arg2_19, arg3_19)
	if arg1_19 then
		local var0_19 = {}

		local function var1_19()
			arg0_19._animator = arg0_19._tf:GetChild(0):GetComponent(typeof(Animator))

			for iter0_20, iter1_20 in ipairs(var0_19) do
				arg0_19._animator:Play(iter1_20.shortNameHash, iter0_20 - 1, iter1_20.normalizedTime)
			end

			arg0_19.isLoading = false

			arg0_19._tf:GetComponent(typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)):StartBehaviour()
		end

		arg0_19.isLoading = true

		arg0_19._tf:GetComponent(typeof(NodeCanvas.BehaviourTrees.BehaviourTreeOwner)):PauseBehaviour()

		local var2_19 = 0

		normalizedTime = arg0_19._animator:GetCurrentAnimatorStateInfo(var2_19).normalizedTime % 1

		for iter0_19 = 1, arg0_19._animator.layerCount do
			local var3_19 = iter0_19 - 1
			local var4_19 = arg0_19._animator:GetCurrentAnimatorStateInfo(var3_19)

			table.insert(var0_19, {
				shortNameHash = var4_19.shortNameHash,
				normalizedTime = var4_19.normalizedTime
			})
		end

		arg0_19:DestroyInteractiveTools()

		if #arg2_19 == 0 and #arg3_19 == 0 then
			arg0_19.shipDressHelper:ChangeModelTransfromByUnitId(arg1_19, var1_19)
		else
			arg0_19.shipDressHelper:ChangeModelTransfromByUnitIdAndChangeDress(arg1_19, arg2_19, arg3_19, var1_19)
		end
	else
		for iter1_19, iter2_19 in ipairs(arg2_19) do
			local var5_19 = pg.island_dress_template[iter2_19].type

			arg0_19.shipDressHelper:ChangeDressByType(var5_19, {
				id = 0,
				colorId = 0
			})
		end

		for iter3_19, iter4_19 in ipairs(arg3_19) do
			local var6_19 = pg.island_dress_template[iter4_19].type

			arg0_19.shipDressHelper:ChangeDressByType(var6_19, {
				colorId = 0,
				id = iter4_19
			})
		end
	end
end

return var0_0
