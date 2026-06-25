local var0_0 = class("CarWashRaycastSystem", import("view.dorm3d.Game.CarWash.CarWashBaseSystem"))

var0_0.UPDATE_COMMON_RAYCAST = "CarWashRaycastSystem.UPDATE_COMMON_RAYCAST"
var0_0.UPDATE_DECAL_RAYCAST = "CarWashRaycastSystem.UPDATE_DECAL_RAYCAST"

function var0_0.OnInit(arg0_1)
	arg0_1:InitSceneRefs()

	arg0_1.isShooting = false
	arg0_1.onShootTime = 0
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_IS_SHOOTING, function(arg0_3, arg1_3)
		arg0_2.isShooting = arg1_3.newValue
		arg0_2.onShootTime = 0
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_CURRENT_GUN_TYPE, function(arg0_4, arg1_4)
		arg0_2:OnSwitchGun(arg1_4.newValue)
	end)
end

function var0_0.OnDispose(arg0_5)
	arg0_5.mainCamera = nil
	arg0_5.sceneRaycaster = nil
	arg0_5.gunTF = nil
	arg0_5.muzzle = nil
	arg0_5.isShooting = nil
	arg0_5.onShootTime = nil
end

function var0_0.OnUpdate(arg0_6, arg1_6)
	if not arg0_6.isShooting then
		return
	end

	arg0_6:UpdateCommonRaycast(arg1_6)
	arg0_6:UpdateDecalRaycast(arg1_6)
end

function var0_0.InitSceneRefs(arg0_7)
	arg0_7.mainCamera = arg0_7:GetMainCamera()
	arg0_7.sceneRaycaster = arg0_7:GetRaycaster()
	arg0_7.gunTF = arg0_7:GetMainCameraTF():Find("[GUNROOT]/gun")

	assert(arg0_7.gunTF, "CarWash gun node not found: gun")
end

function var0_0.OnSwitchGun(arg0_8, arg1_8)
	local var0_8 = CarWashConst.GetGunConfig(arg1_8)

	assert(var0_8, "CarWash gun config not found: " .. tostring(arg1_8))
	assert(var0_8.name, "CarWash gun name not found: " .. tostring(arg1_8))

	local var1_8 = arg0_8.gunTF:Find(var0_8.name)

	assert(var1_8, "CarWash gun model not found: " .. var0_8.name)

	arg0_8.muzzle = var1_8:Find("muzzle")

	assert(arg0_8.muzzle, "CarWash gun muzzle not found: " .. var0_8.name .. "/muzzle")
end

function var0_0.UpdateCommonRaycast(arg0_9, arg1_9)
	local var0_9, var1_9 = arg0_9:RaycastScreenCenter(CarWashConst.EFFECT_LAYER_MASK, CarWashConst.DEFAULT_RAY_DISTANCE)

	arg0_9:EmitRaycastResult(var0_0.UPDATE_COMMON_RAYCAST, var0_9, var1_9, {}, arg1_9)
end

function var0_0.UpdateDecalRaycast(arg0_10, arg1_10)
	arg0_10.onShootTime = arg0_10.onShootTime + arg1_10

	if arg0_10.onShootTime < CarWashDecalSystem.ON_SHOOT_INTERVAL then
		return
	end

	arg0_10.onShootTime = arg0_10.onShootTime - CarWashDecalSystem.ON_SHOOT_INTERVAL

	local var0_10 = arg0_10:RaycastSceneRaycasterScreenCenter()
	local var1_10, var2_10 = arg0_10:RaycastScreenCenter(CarWashConst.LAYER_MASK, CarWashConst.DEFAULT_RAY_DISTANCE)

	arg0_10:EmitRaycastResult(var0_0.UPDATE_DECAL_RAYCAST, var1_10, var2_10, var0_10, CarWashDecalSystem.ON_SHOOT_INTERVAL)
end

function var0_0.EmitRaycastResult(arg0_11, arg1_11, arg2_11, arg3_11, arg4_11, arg5_11)
	arg0_11:Emit(arg1_11, {
		hit = arg2_11,
		hitInfo = arg3_11,
		targets = arg4_11,
		ray = arg0_11:GetScreenCenterRay(),
		muzzleRay = arg0_11:GetMuzzleRay(arg2_11, arg3_11),
		deltaTime = arg5_11
	})
end

function var0_0.GetScreenCenterPoint(arg0_12)
	return Vector3.New(Screen.width * 0.5, Screen.height * 0.5, 0)
end

function var0_0.GetScreenCenterRay(arg0_13)
	local var0_13 = arg0_13:GetScreenCenterPoint()

	return arg0_13.mainCamera:ScreenPointToRay(var0_13)
end

function var0_0.GetMuzzleRay(arg0_14, arg1_14, arg2_14)
	if not arg0_14.muzzle then
		return nil
	end

	local var0_14 = arg0_14.muzzle.position
	local var1_14 = (arg1_14 and arg2_14 and arg2_14.point or var0_14 + arg0_14.muzzle.forward * CarWashConst.DEFAULT_RAY_DISTANCE) - var0_14

	if var1_14:SqrMagnitude() <= 1e-06 then
		var1_14 = arg0_14.muzzle.forward
	else
		var1_14 = var1_14:Normalize()
	end

	return Ray.New(var1_14, var0_14)
end

function var0_0.RaycastScreenCenter(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15:GetScreenCenterRay()

	arg2_15 = arg2_15 or CarWashConst.DEFAULT_RAY_DISTANCE

	return Physics.Raycast(var0_15.origin, var0_15.direction, nil, arg2_15, arg1_15)
end

function var0_0.RaycastSceneRaycasterScreenCenter(arg0_16)
	return CameraMgr.instance:Raycast(arg0_16.sceneRaycaster, arg0_16:GetScreenCenterPoint()):ToTable()
end

return var0_0
