local var0_0 = require("Framework.toLua.UnityEngine.Vector3")
local var1_0 = require("Framework.toLua.UnityEngine.Vector2")
local var2_0 = var0_0.zero
local var3_0 = class("IslandThirdTakePhotoUnit", import(".IslandSceneUnit"))
local var4_0 = LayerMask.NameToLayer("IgnoreIslandCharacter")
local var5_0 = bit.bnot(bit.lshift(1, var4_0))

function var3_0.OnAttach(arg0_1, arg1_1)
	var3_0.super.OnAttach(arg0_1, arg1_1)

	arg0_1._tf = arg0_1._go.transform
	arg0_1.characterController = arg0_1._go:GetComponent(typeof(CharacterController))
	arg0_1.targetSpeed = 0
	arg0_1.speed = 0

	local var0_1 = pg.island_set.player_movement_parameters.key_value_varchar

	arg0_1.degreeSpeed = 720
	arg0_1.maxSpeed = var0_1[1]
	arg0_1.sprintSpeed = var0_1[2]
	arg0_1.upSpeedDamping = 3
	arg0_1.downSpeedDamping = 6
	arg0_1.jumpHeight = var0_1[3]
	arg0_1.targetDir = Vector3.zero
	arg0_1.velocity = Vector3.zero
	arg0_1.extraVelocity = Vector3.zero
	arg0_1.gravitySpeed = 0
	arg0_1.orginTargetDir = var2_0

	setActive(arg0_1._go, false)
	arg0_1:ActiveOrDisactive(false)
end

function var3_0.OnLateUpdate(arg0_2)
	return
end

function var3_0.OnUpdate(arg0_3)
	arg0_3:RefreshTemp()

	local var0_3 = Time.deltaTime

	arg0_3:Rotation(var0_3)
	arg0_3:Move(var0_3)
end

function var3_0.RefreshTemp(arg0_4)
	arg0_4.ignoreStepdown = false
	arg0_4.gravityAcc = IslandConst.GRAVITYACC

	if arg0_4.orginTargetDir.x ~= 0 or arg0_4.orginTargetDir.z ~= 0 then
		local var0_4 = IslandCameraMgr.instance._mainCamera.transform:TransformVector(arg0_4.orginTargetDir)

		arg0_4.targetDir = var0_0(var0_4.x, 0, var0_4.z).normalized
		arg0_4.targetRotation = Quaternion.LookRotation(arg0_4.targetDir)
	end
end

function var3_0.Rotation(arg0_5, arg1_5)
	if arg0_5.targetRotation then
		local var0_5 = Quaternion.RotateTowards(arg0_5._tf.rotation, arg0_5.targetRotation, arg0_5.degreeSpeed * arg1_5)

		arg0_5._tf.rotation = var0_5
	end
end

function var3_0.SetTargetRotation(arg0_6, arg1_6)
	arg0_6.targetRotation = arg1_6
end

function var3_0.Move(arg0_7, arg1_7)
	if Mathf.Approximately(arg0_7.speed, arg0_7.targetSpeed) then
		arg0_7.speed = arg0_7.targetSpeed
	elseif arg0_7.targetSpeed > arg0_7.speed then
		arg0_7.speed = Mathf.Lerp(arg0_7.speed, arg0_7.targetSpeed, arg0_7.upSpeedDamping * arg1_7)
	else
		arg0_7.speed = Mathf.Lerp(arg0_7.speed, arg0_7.targetSpeed, arg0_7.downSpeedDamping * arg1_7)
	end

	arg0_7.velocity = arg0_7.targetDir * arg0_7.speed
	arg0_7.onGroud = true

	local var0_7 = 0

	if arg0_7.gravitySpeed >= 0 then
		local var1_7, var2_7 = arg0_7:CalcGrounded()

		if var1_7 then
			arg0_7.gravitySpeed = 0
			var0_7 = var2_7
		else
			local var3_7, var4_7 = arg0_7:CalcNotFalling()

			if var3_7 then
				arg0_7.gravitySpeed = 0
				var0_7 = var4_7
			else
				arg0_7.onGroud = false
			end
		end
	else
		arg0_7.onGroud = false
	end

	local var5_7 = Vector3(0, IslandConst.GRAVITYDIR.y * var0_7, 0)

	if arg0_7.ignoreStepdown then
		var5_7 = var2_0
	end

	local var6_7 = var5_7

	arg0_7.characterController:Move(arg0_7.velocity * Time.deltaTime + var6_7)
end

function var3_0.CalcGrounded(arg0_8)
	local var0_8, var1_8 = Physics.SphereCast(arg0_8._tf.position + arg0_8.characterController.center, arg0_8.characterController.radius, Vector3.down, nil, 2 * arg0_8.characterController.skinWidth + (0.5 * arg0_8.characterController.height - arg0_8.characterController.radius), var5_0)

	if var0_8 then
		local var2_8 = arg0_8._tf.position.y + arg0_8.characterController.skinWidth - var1_8.point.y

		return true, var2_8
	end

	return false
end

function var3_0.CalcNotFalling(arg0_9)
	local var0_9, var1_9 = Physics.SphereCast(arg0_9._tf.position + arg0_9.characterController.center, arg0_9.characterController.radius, Vector3.down, nil, 0.3 + 2 * arg0_9.characterController.skinWidth + (0.5 * arg0_9.characterController.height - arg0_9.characterController.radius), var5_0)

	if var0_9 then
		local var2_9 = arg0_9._tf.position.y + arg0_9.characterController.skinWidth - var1_9.point.y

		return true, var2_9
	end

	return false
end

function var3_0.OnPlayerPlayerSprint(arg0_10)
	if arg0_10.targetSpeed ~= 0 then
		arg0_10.isSprint = true
		arg0_10.lastTargetSpeed = arg0_10.targetSpeed
		arg0_10.targetSpeed = arg0_10.sprintSpeed
		arg0_10.speed = arg0_10.targetSpeed
	end
end

function var3_0.ChangeHeight(arg0_11, arg1_11)
	arg0_11.characterController.center = Vector3(0, arg1_11, 0)
end

function var3_0.OnStopPlayerSprint(arg0_12)
	if arg0_12.isSprint and arg0_12.targetSpeed ~= 0 then
		arg0_12.targetSpeed = arg0_12.lastTargetSpeed
		arg0_12.speed = arg0_12.lastTargetSpeed
		arg0_12.isSprint = false
	end
end

function var3_0.MoveHandle(arg0_13, arg1_13, arg2_13)
	arg0_13.orginTargetDir = arg1_13
	arg0_13.lastTargetSpeed = arg2_13 * arg0_13.maxSpeed
	arg0_13.targetSpeed = arg0_13.isSprint and arg0_13.sprintSpeed or arg0_13.lastTargetSpeed
end

function var3_0.StopMoveHandle(arg0_14)
	arg0_14.targetSpeed = 0
	arg0_14.speed = 0
	arg0_14.orginTargetDir = var2_0
	arg0_14.isSprint = false
end

return var3_0
