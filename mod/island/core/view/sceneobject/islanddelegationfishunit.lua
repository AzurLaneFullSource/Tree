local var0_0 = require("Framework.toLua.UnityEngine.Vector3")
local var1_0 = require("Framework.toLua.UnityEngine.Quaternion")
local var2_0 = class("IslandDelegationFishUnit", import(".IslandSceneUnit"))
local var3_0 = LayerMask.NameToLayer("IgnoreIslandCharacter")
local var4_0 = bit.bnot(bit.lshift(1, var3_0))
local var5_0 = {
	baseSpeed = 2,
	turnDetectionThreshold = 0.4,
	noiseScale = 0.5,
	avoidBoost = 1.5,
	avoidTurnAngle = 45,
	noiseAmplitude = 0.8,
	speedChangeRate = 0.5,
	minSpeedFactor = 0.5,
	turnSpeed = 2,
	maxSpeedFactor = 2,
	turnSlowdownFactor = 0.6,
	avoidBoostDuration = 1,
	changeTargetInterval = 4,
	avoidDistance = 2
}

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.speed = arg2_1.speed or var5_0.baseSpeed
end

function var2_0.OnAttach(arg0_2, arg1_2)
	arg0_2._go = arg1_2
	arg0_2._tf = arg1_2.transform
	arg0_2.baseSpeed = arg0_2.speed or var5_0.baseSpeed
	arg0_2.turnSpeed = arg0_2.turnSpeed or var5_0.turnSpeed
	arg0_2.avoidDistance = arg0_2.avoidDistance or var5_0.avoidDistance
	arg0_2.avoidTurnAngle = arg0_2.avoidTurnAngle or var5_0.avoidTurnAngle
	arg0_2.obstacleMask = arg0_2.obstacleMask or var5_0.obstacleMask
	arg0_2.avoidBoost = arg0_2.avoidBoost or var5_0.avoidBoost
	arg0_2.avoidBoostDuration = arg0_2.avoidBoostDuration or var5_0.avoidBoostDuration
	arg0_2.minSpeed = arg0_2.baseSpeed * var5_0.minSpeedFactor
	arg0_2.maxSpeed = arg0_2.baseSpeed or var5_0.maxSpeedFactor
	arg0_2.speedChangeRate = arg0_2.speedChangeRate or var5_0.speedChangeRate
	arg0_2.noiseScale = arg0_2.noiseScale or var5_0.noiseScale
	arg0_2.noiseAmplitude = arg0_2.noiseAmplitude or var5_0.noiseAmplitude
	arg0_2.turnSlowdownFactor = arg0_2.turnSlowdownFactor or var5_0.turnSlowdownFactor
	arg0_2.turnDetectionThreshold = arg0_2.turnDetectionThreshold or var5_0.turnDetectionThreshold
	arg0_2.changeTargetInterval = var5_0.changeTargetInterval
	arg0_2.targetPos = var0_0.zero
	arg0_2.timer = 0
	arg0_2.currentSpeed = arg0_2.baseSpeed
	arg0_2.noiseSeed = math.random() * 100
	arg0_2.avoidBoostTimer = 0
	arg0_2.lastRotation = arg0_2._tf.rotation or var1_0.identity
	arg0_2.animator = arg0_2._tf:GetChild(0):GetComponent(typeof(Animator))
end

function var2_0.SetFishPonds(arg0_3, arg1_3)
	arg0_3.pond = arg0_3.view:GetUnitModuleWithType(IslandConst.UNIT_LIST_OBJ, arg1_3)._go.transform:GetComponent(typeof(FishPond)):GetBounds()
end

function var2_0.GetRandomPoint(arg0_4)
	local var0_4 = arg0_4.pond:GetMin()
	local var1_4 = arg0_4.pond:GetMax()

	return var0_0.New(math.random() * (var1_4.x - var0_4.x) + var0_4.x, math.random() * (var1_4.y - var0_4.y) + var0_4.y, math.random() * (var1_4.z - var0_4.z) + var0_4.z)
end

function var2_0.StartFishing(arg0_5)
	arg0_5.startFishing = true
	arg0_5._tf.position = arg0_5:GetRandomPoint()

	arg0_5.animator:Play("walk")
end

function var2_0.OnUpdate(arg0_6)
	if not arg0_6.startFishing then
		return
	end

	local var0_6 = Time.deltaTime

	arg0_6.timer = arg0_6.timer + var0_6

	if arg0_6.timer > arg0_6.changeTargetInterval then
		arg0_6:SetNewTarget()
	end

	arg0_6:UpdateSpeed()
	arg0_6:Move()
	arg0_6:KeepInsideBounds()
end

function var2_0.Move(arg0_7)
	local var0_7 = arg0_7._tf.position
	local var1_7 = arg0_7.targetPos - var0_7

	if var1_7.sqrMagnitude < 0.01 then
		return
	end

	local var2_7 = var1_7.normalized

	if var2_7 ~= var0_0.zero then
		local var3_7 = var1_0.LookRotation(var2_7)

		arg0_7._tf.rotation = var1_0.Slerp(arg0_7._tf.rotation, var3_7, arg0_7.turnSpeed * Time.deltaTime)
	end

	local var4_7 = var1_0.Angle(arg0_7._tf.rotation, arg0_7.lastRotation) * Mathf.Deg2Rad

	arg0_7.lastRotation = arg0_7._tf.rotation

	local var5_7 = 1

	if var4_7 > arg0_7.turnDetectionThreshold then
		var5_7 = var5_7 * arg0_7.turnSlowdownFactor
	end

	if arg0_7.avoidBoostTimer > 0 then
		arg0_7.avoidBoostTimer = arg0_7.avoidBoostTimer - Time.deltaTime
		var5_7 = var5_7 * arg0_7.avoidBoost
	end

	local var6_7 = arg0_7._tf.forward * (arg0_7.currentSpeed * var5_7) * Time.deltaTime

	arg0_7._tf.position = arg0_7._tf.position + var6_7
end

function var2_0.UpdateSpeed(arg0_8)
	local var0_8 = Mathf.PerlinNoise(arg0_8.noiseSeed, Time.time * arg0_8.noiseScale)
	local var1_8 = Mathf.Lerp(arg0_8.minSpeed, arg0_8.maxSpeed, var0_8 * arg0_8.noiseAmplitude)

	arg0_8.currentSpeed = Mathf.Lerp(arg0_8.currentSpeed, var1_8, Time.deltaTime * arg0_8.speedChangeRate)
end

function var2_0.SetNewTarget(arg0_9)
	arg0_9.timer = 0

	local var0_9 = arg0_9.pond
	local var1_9 = Mathf.Lerp(var0_9.min.x, var0_9.max.x, math.random())
	local var2_9 = Mathf.Lerp(var0_9.min.y, var0_9.max.y, math.random())
	local var3_9 = Mathf.Lerp(var0_9.min.z, var0_9.max.z, math.random())

	arg0_9.targetPos = var0_0.New(var1_9, var2_9, var3_9)
	arg0_9.changeTargetInterval = (arg0_9.targetPos - arg0_9._tf.position).magnitude / arg0_9.speed
end

function var2_0.AvoidCollision(arg0_10)
	local var0_10 = arg0_10._tf.position
	local var1_10 = arg0_10._tf.forward
	local var2_10 = 0.5
	local var3_10 = arg0_10.avoidDistance or var5_0.avoidDistance
	local var4_10, var5_10 = Physics.SphereCast(var0_10, var2_10, var1_10, nil, var3_10, var4_0)

	if var4_10 and var5_10 and var5_10.collider then
		local var6_10 = (math.random() - 0.5) * 2 * arg0_10.avoidTurnAngle
		local var7_10 = var1_0.Euler(0, var6_10, 0) * arg0_10._tf.forward
		local var8_10 = var1_0.LookRotation(var7_10)

		arg0_10._tf.rotation = var1_0.Slerp(arg0_10._tf.rotation, var8_10, arg0_10.turnSpeed * Time.deltaTime)

		arg0_10:SetNewTarget()

		arg0_10.avoidBoostTimer = arg0_10.avoidBoostDuration
	end
end

function var2_0.KeepInsideBounds(arg0_11)
	local var0_11 = arg0_11.pond
	local var1_11 = arg0_11._tf.position
	local var2_11 = false

	if var0_11.Contains then
		var2_11 = var0_11:Contains(var1_11)
	else
		var2_11 = var1_11.x >= var0_11.min.x and var1_11.x <= var0_11.max.x and var1_11.y >= var0_11.min.y and var1_11.y <= var0_11.max.y and var1_11.z >= var0_11.min.z and var1_11.z <= var0_11.max.z
	end

	if not var2_11 then
		local var3_11 = (arg0_11.pond.center - var1_11).normalized

		if var3_11 ~= var0_0.zero then
			local var4_11 = var1_0.LookRotation(var3_11)

			arg0_11._tf.rotation = var1_0.Slerp(arg0_11._tf.rotation, var4_11, arg0_11.turnSpeed * Time.deltaTime)
		end

		if var0_11.ClosestPoint then
			local var5_11 = var0_11:ClosestPoint(var1_11)

			arg0_11._tf.position = var0_0.Lerp(var1_11, var5_11, 0.5)
		else
			arg0_11._tf.position = var0_0.Lerp(var1_11, arg0_11.pond.center, 0.5)
		end

		arg0_11:SetNewTarget()
	end
end

return var2_0
