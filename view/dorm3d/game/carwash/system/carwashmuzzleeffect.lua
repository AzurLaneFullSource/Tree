local var0_0 = class("CarWashMuzzleEffect", import("view.dorm3d.Game.CarWash.CarWashBaseSystem"))

var0_0.GUN_LOOK_LERP_TIME = 0.2
var0_0.GUN_ROTATION_EPSILON = 0.1
var0_0.AIM_TARGET_ENABLE_LERP_TIME = 0.25
var0_0.GUN_ROTATION_STATE_LOOK = 1
var0_0.GUN_ROTATION_STATE_RETURN = 2

function var0_0.OnInit(arg0_1)
	arg0_1:InitSceneRefs()

	arg0_1.isShooting = false
	arg0_1.gunLookLerpTime = 0
	arg0_1.gunLookLerpDuration = var0_0.GUN_LOOK_LERP_TIME
	arg0_1.aimTargetLerpTime = 0
	arg0_1.muzzleRaycastResult = nil
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_IS_SHOOTING, function(arg0_3, arg1_3)
		arg0_2:OnShootingChanged(arg1_3.newValue)
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_CURRENT_GUN_TYPE, function(arg0_4, arg1_4)
		arg0_2:OnSwitchGun(arg1_4.newValue)
	end)
	arg0_2:Bind(CarWashRaycastSystem.UPDATE_COMMON_RAYCAST, function(arg0_5, arg1_5)
		arg0_2.muzzleRaycastResult = arg1_5
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_GAME_STATE, function(arg0_6, arg1_6)
		if arg1_6.newValue == CarWashConst.GAME_STATE.PHASE_1 then
			setActive(arg0_2.gunTF, true)
		elseif arg1_6.newValue == CarWashConst.GAME_STATE.PHASE_2 then
			setActive(arg0_2.gunTF, false)
		end
	end)
end

function var0_0.OnDispose(arg0_7)
	arg0_7:ResetGunRotation()

	arg0_7.gunTF = nil
	arg0_7.originalRotation = nil
	arg0_7.vfxRoot = nil
	arg0_7.hitVFX = nil
	arg0_7.gunLookFromRotation = nil
	arg0_7.gunLookToRotation = nil
	arg0_7.gunLookLerpTime = nil
	arg0_7.gunLookLerpDuration = nil
	arg0_7.gunLookUseLocalRotation = nil
	arg0_7.gunRotationState = nil
	arg0_7.muzzle = nil
	arg0_7.aimTarget = nil
	arg0_7.aimTargetLerpFromPosition = nil
	arg0_7.aimTargetLerpTime = nil
	arg0_7.isAimTargetEntering = nil
	arg0_7.muzzleRaycastResult = nil
end

function var0_0.OnUpdate(arg0_8, arg1_8)
	arg0_8:UpdateMuzzleEffect(arg1_8)
	arg0_8:UpdateGunRotation(arg1_8)
end

function var0_0.InitSceneRefs(arg0_9)
	local var0_9 = arg0_9:GetMainCameraTF()

	arg0_9.gunTF = var0_9:Find("[GUNROOT]/gun")

	assert(arg0_9.gunTF, "CarWash gun node not found: gun")

	arg0_9.originalRotation = arg0_9.gunTF.localRotation
	arg0_9.aimTarget = var0_9:Find("[GUNROOT]/AimTarget")

	assert(arg0_9.aimTarget, "CarWash AimTarget node not found: AimTarget")
end

function var0_0.OnShootingChanged(arg0_10, arg1_10)
	arg0_10.isShooting = arg1_10
	arg0_10.muzzleRaycastResult = nil

	if arg0_10.isShooting then
		arg0_10:StartAimTargetEnterTransition()
		setActive(arg0_10.vfxRoot, true)
	else
		arg0_10:KeepAimTargetAtMuzzle()
		setActive(arg0_10.vfxRoot, false)
		setActive(arg0_10.hitVFX, false)
		arg0_10:ReturnGunRotation()
	end
end

function var0_0.OnSwitchGun(arg0_11, arg1_11)
	local var0_11 = CarWashConst.GetGunConfig(arg1_11)

	assert(var0_11, "CarWash gun config not found: " .. tostring(arg1_11))
	assert(var0_11.name, "CarWash gun name not found: " .. tostring(arg1_11))

	if arg0_11.hitVFX then
		setActive(arg0_11.hitVFX, false)
	end

	if arg0_11.vfxRoot then
		setActive(arg0_11.vfxRoot, false)
	end

	if arg0_11.gunModel then
		setActive(arg0_11.gunModel, false)
	end

	local var1_11 = arg0_11.gunTF:Find(var0_11.name)

	assert(var1_11, "CarWash gun model not found: " .. var0_11.name)

	local var2_11 = var1_11:Find("vfx")

	assert(var2_11, "CarWash gun VFX root not found: " .. var0_11.name .. "/vfx")

	local var3_11 = var2_11:Find("hit")

	assert(var3_11, "CarWash gun hit VFX not found: " .. var0_11.name .. "/vfx/hit")

	local var4_11 = var1_11:Find("muzzle")

	assert(var4_11, "CarWash gun muzzle not found: " .. var0_11.name .. "/muzzle")

	arg0_11.currentGunType = arg1_11
	arg0_11.gunModel = var1_11
	arg0_11.vfxRoot = var2_11
	arg0_11.hitVFX = var3_11
	arg0_11.muzzle = var4_11

	setActive(arg0_11.gunModel, true)
	setActive(arg0_11.vfxRoot, arg0_11.isShooting)
	setActive(arg0_11.hitVFX, false)

	if arg0_11.isShooting then
		arg0_11:StartAimTargetEnterTransition()
	else
		arg0_11:KeepAimTargetAtMuzzle()
	end
end

function var0_0.UpdateMuzzleEffect(arg0_12, arg1_12)
	if not arg0_12.isShooting then
		return
	end

	if not arg0_12.muzzleRaycastResult then
		return
	end

	local var0_12 = arg0_12.muzzleRaycastResult.hit
	local var1_12 = arg0_12.muzzleRaycastResult.hitInfo

	if var0_12 then
		local var2_12 = arg0_12:UpdateAimTarget(var1_12.point, arg1_12)

		setActive(arg0_12.hitVFX, not arg0_12.isAimTargetEntering)

		arg0_12.hitVFX.position = var2_12

		arg0_12:LookAtTarget(var1_12.point)
	else
		setActive(arg0_12.hitVFX, false)
		arg0_12:UpdateAimTarget(arg0_12:GetMuzzleForwardPosition(), arg1_12)
		arg0_12:ReturnGunRotation()
	end
end

function var0_0.LookAtTarget(arg0_13, arg1_13)
	local var0_13 = arg1_13 - arg0_13.gunTF.position

	if var0_13:SqrMagnitude() <= 1e-06 then
		return
	end

	arg0_13:StartGunRotation(Quaternion.LookRotation(var0_13.normalized, Vector3.up), var0_0.GUN_LOOK_LERP_TIME, false, var0_0.GUN_ROTATION_STATE_LOOK)
end

function var0_0.UpdateGunRotation(arg0_14, arg1_14)
	if not arg0_14.gunLookToRotation then
		return
	end

	arg0_14.gunLookLerpTime = arg0_14.gunLookLerpTime + arg1_14

	local var0_14 = math.min(arg0_14.gunLookLerpTime / arg0_14.gunLookLerpDuration, 1)
	local var1_14 = Quaternion.Slerp(arg0_14.gunLookFromRotation, arg0_14.gunLookToRotation, var0_14)

	if arg0_14.gunLookUseLocalRotation then
		arg0_14.gunTF.localRotation = var1_14
	else
		arg0_14.gunTF.rotation = var1_14
	end

	if var0_14 >= 1 then
		if arg0_14.gunRotationState == var0_0.GUN_ROTATION_STATE_RETURN then
			arg0_14.gunTF.localRotation = arg0_14.originalRotation
		end

		arg0_14.gunLookFromRotation = nil
		arg0_14.gunLookToRotation = nil
		arg0_14.gunLookLerpTime = 0
		arg0_14.gunLookLerpDuration = var0_0.GUN_LOOK_LERP_TIME
		arg0_14.gunLookUseLocalRotation = nil
		arg0_14.gunRotationState = nil
	end
end

function var0_0.StartGunRotation(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15)
	if arg0_15.gunLookToRotation and arg0_15.gunRotationState == arg4_15 and Quaternion.Angle(arg0_15.gunLookToRotation, arg1_15) <= var0_0.GUN_ROTATION_EPSILON then
		return
	end

	local var0_15 = arg3_15 and arg0_15.gunTF.localRotation or arg0_15.gunTF.rotation

	if Quaternion.Angle(var0_15, arg1_15) <= var0_0.GUN_ROTATION_EPSILON then
		if arg3_15 then
			arg0_15.gunTF.localRotation = arg1_15
		else
			arg0_15.gunTF.rotation = arg1_15
		end

		arg0_15.gunLookFromRotation = nil
		arg0_15.gunLookToRotation = nil
		arg0_15.gunLookLerpTime = 0
		arg0_15.gunLookLerpDuration = var0_0.GUN_LOOK_LERP_TIME
		arg0_15.gunLookUseLocalRotation = nil
		arg0_15.gunRotationState = nil

		return
	end

	arg0_15.gunLookLerpTime = 0
	arg0_15.gunLookLerpDuration = arg2_15 or var0_0.GUN_LOOK_LERP_TIME
	arg0_15.gunLookUseLocalRotation = arg3_15
	arg0_15.gunLookFromRotation = var0_15
	arg0_15.gunLookToRotation = arg1_15
	arg0_15.gunRotationState = arg4_15
end

function var0_0.ReturnGunRotation(arg0_16)
	if not arg0_16.gunTF then
		return
	end

	arg0_16:StartGunRotation(arg0_16.originalRotation, var0_0.GUN_LOOK_LERP_TIME, true, var0_0.GUN_ROTATION_STATE_RETURN)
end

function var0_0.StartAimTargetEnterTransition(arg0_17)
	if not arg0_17.aimTarget or not arg0_17.muzzle then
		return
	end

	arg0_17.aimTarget.position = arg0_17.muzzle.position
	arg0_17.aimTargetLerpFromPosition = arg0_17.muzzle.position
	arg0_17.aimTargetLerpTime = 0
	arg0_17.isAimTargetEntering = true
end

function var0_0.KeepAimTargetAtMuzzle(arg0_18)
	arg0_18.aimTarget.position = arg0_18.muzzle.position
	arg0_18.aimTargetLerpFromPosition = arg0_18.muzzle.position
	arg0_18.aimTargetLerpTime = 0
	arg0_18.isAimTargetEntering = true
end

function var0_0.GetMuzzleForwardPosition(arg0_19)
	return arg0_19.muzzle.position + arg0_19.muzzle.forward * CarWashConst.DEFAULT_RAY_DISTANCE
end

function var0_0.UpdateAimTarget(arg0_20, arg1_20, arg2_20)
	if not arg0_20.isAimTargetEntering then
		arg0_20.aimTarget.position = arg1_20

		return arg1_20
	end

	arg0_20.aimTargetLerpTime = arg0_20.aimTargetLerpTime + arg2_20

	local var0_20 = math.min(arg0_20.aimTargetLerpTime / var0_0.AIM_TARGET_ENABLE_LERP_TIME, 1)
	local var1_20 = Vector3.Lerp(arg0_20.aimTargetLerpFromPosition, arg1_20, var0_20)

	arg0_20.aimTarget.position = var1_20

	if var0_20 >= 1 then
		arg0_20.isAimTargetEntering = false
		arg0_20.aimTarget.position = arg1_20

		return arg1_20
	end

	return var1_20
end

function var0_0.ResetGunRotation(arg0_21)
	if not arg0_21.gunTF then
		return
	end

	arg0_21.gunTF.localRotation = arg0_21.originalRotation
	arg0_21.gunLookFromRotation = nil
	arg0_21.gunLookToRotation = nil
	arg0_21.gunLookLerpTime = 0
	arg0_21.gunLookLerpDuration = var0_0.GUN_LOOK_LERP_TIME
	arg0_21.gunLookUseLocalRotation = nil
	arg0_21.gunRotationState = nil
end

return var0_0
