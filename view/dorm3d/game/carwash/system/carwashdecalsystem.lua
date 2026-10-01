local var0_0 = class("CarWashDecalSystem", import("view.dorm3d.Game.CarWash.CarWashBaseSystem"))

var0_0.GENERATE_DECALS = "CarWashDecalSystem.GENERATE_DECALS"
var0_0.GENERATOR_NAME = "[DECALROOT]/[DECAL GENERATOR]"
var0_0.ON_SHOOT_INTERVAL = 0.1

function var0_0.OnInit(arg0_1)
	arg0_1:InitSceneRefs()

	arg0_1.selectedCarDecalType = nil
	arg0_1.selectedLadyDecalType = nil
	arg0_1.isShooting = false
end

function var0_0.RegisterEvents(arg0_2)
	arg0_2:Bind(var0_0.GENERATE_DECALS, function(arg0_3)
		arg0_2:RegenerateAll(System.Action_int(function(arg0_4)
			arg0_2:Emit(CarWashGameFlowSystem.SET_STAINS_COUNT_MAX, arg0_4)
			arg0_2:Emit(CarWashGameFlowSystem.SET_STAINS_COUNT, arg0_4)
		end))
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_IS_SHOOTING, function(arg0_5, arg1_5)
		arg0_2.isShooting = arg1_5.newValue
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_CURRENT_GUN_TYPE, function(arg0_6, arg1_6)
		arg0_2:OnSwitchGun(arg1_6.newValue)
	end)
	arg0_2:Bind(CarWashRaycastSystem.UPDATE_DECAL_RAYCAST, function(arg0_7, arg1_7)
		arg0_2:OnShootLogic(arg1_7)
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_BEGIN, function(arg0_8)
		arg0_2:EnableDecalRoot(false)
	end)
	arg0_2:Bind(CarWashTimelineSystem.TIMELINE_SEQUENCE_END, function(arg0_9)
		arg0_2:EnableDecalRoot(true)
	end)
	arg0_2:Bind(CarWashGameFlowSystem.UPDATE_GAME_STATE, function(arg0_10, arg1_10)
		if arg1_10.newValue == CarWashConst.GAME_STATE.PHASE_2 then
			arg0_2:EnableDecalRoot(false)
		elseif arg1_10.newValue == CarWashConst.GAME_STATE.PHASE_1 then
			arg0_2:EnableDecalRoot(true)
		end
	end)
end

function var0_0.OnDispose(arg0_11)
	arg0_11.randomDecalGenerator = nil
	arg0_11.generatorTF = nil
	arg0_11.decalParent = nil
end

function var0_0.InitSceneRefs(arg0_12)
	local var0_12 = GameObject.Find(var0_0.GENERATOR_NAME)

	assert(var0_12, "CarWash RandomDecalGenerator object not found: " .. var0_0.GENERATOR_NAME)

	arg0_12.generatorTF = var0_12.transform
	arg0_12.decalParent = arg0_12.generatorTF
	arg0_12.randomDecalGenerator = var0_12:GetComponent(typeof(RandomDecalGenerator))

	assert(arg0_12.randomDecalGenerator, "RandomDecalGenerator component not found on " .. var0_0.GENERATOR_NAME)
end

function var0_0.EnableDecalRoot(arg0_13, arg1_13)
	if arg0_13.randomDecalGenerator then
		arg0_13.randomDecalGenerator:SetGeneratedActive(arg1_13)
	end

	if arg0_13.decalParent then
		setActive(arg0_13.decalParent, arg1_13)
	end
end

function var0_0.GenerateDecals(arg0_14)
	return arg0_14:GenerateAll()
end

function var0_0.OnSwitchGun(arg0_15, arg1_15)
	local var0_15 = CarWashConst.GetGunConfig(arg1_15)

	assert(var0_15, "CarWash gun config not found: " .. tostring(arg1_15))

	local var1_15 = var0_15.decalType

	assert(var1_15, "CarWash decal types not found for gun type: " .. tostring(arg1_15))
	assert(var1_15.onCar, "CarWash car decal type not found for gun type: " .. tostring(arg1_15))
	assert(var1_15.onLady, "CarWash lady decal type not found for gun type: " .. tostring(arg1_15))

	arg0_15.currentGunType = arg1_15
	arg0_15.selectedCarDecalType = var1_15.onCar
	arg0_15.selectedLadyDecalType = var1_15.onLady
end

function var0_0.OnShootLogic(arg0_16, arg1_16)
	if not arg0_16.isShooting then
		return
	end

	local var0_16 = arg1_16.targets
	local var1_16 = arg1_16.hit
	local var2_16 = arg1_16.hitInfo
	local var3_16 = false
	local var4_16
	local var5_16 = false
	local var6_16 = {}
	local var7_16 = 16191
	local var8_16 = 16191

	for iter0_16, iter1_16 in ipairs(var0_16) do
		local var9_16 = iter1_16.gameObject
		local var10_16 = var9_16.transform

		if var9_16.layer == CarWashConst.CAR_LAYER then
			var5_16 = true
			var7_16 = math.min(var7_16, iter0_16)
		end

		if var9_16.layer == CarWashConst.LADY_LAYER then
			var3_16 = true
			var4_16 = var10_16
			var8_16 = math.min(var8_16, iter0_16)
		end

		local var11_16 = var9_16:GetComponent(typeof(DecalController))

		if var11_16 then
			table.insert(var6_16, var11_16)
		end
	end

	if var1_16 and var3_16 and var8_16 < var7_16 and not table.contains(arg0_16:GetGameConfig().non_decal_colliders, var2_16.collider.name) then
		assert(var2_16, "CarWash decal hitInfo is nil")

		if not _.any(var6_16, function(arg0_17)
			return arg0_17.decalType == arg0_16.selectedLadyDecalType
		end) then
			arg0_16:GenerateDecalAtScreenCenter(arg0_16.selectedLadyDecalType, var2_16, arg0_16:GetColliderBone(var4_16), arg0_16:GetCapsuleColliderRadius(var4_16))
		end
	end

	if var1_16 and var5_16 and var7_16 < var8_16 then
		assert(var2_16, "CarWash decal hitInfo is nil")

		local var12_16 = arg0_16:FindDecalFaceFilter(var2_16.collider)

		if var12_16 and not var12_16:IsAllowed(var2_16.normal) then
			return
		end

		if not _.any(var6_16, function(arg0_18)
			return arg0_18.decalType == arg0_16.selectedCarDecalType
		end) then
			arg0_16:GenerateDecalAtScreenCenter(arg0_16.selectedCarDecalType, var2_16)
		end

		for iter2_16, iter3_16 in ipairs(var6_16) do
			local var13_16 = CarWashConst.GetStainsConfig(iter3_16.decalType)

			if var13_16 then
				local var14_16 = 0
				local var15_16 = arg0_16.currentGunType == var13_16.targetGunType
				local var16_16 = var13_16.coverDecal and _.any(var6_16, function(arg0_19)
					return arg0_19.decalType == var13_16.coverDecal
				end)
				local var17_16 = var14_16 + (var15_16 and var13_16.fadePerSec or 0) + (var15_16 and var16_16 and var13_16.coverBuff or 0)

				if var17_16 > 0 then
					iter3_16:SetAlpha(iter3_16.Alpha - var17_16 * var0_0.ON_SHOOT_INTERVAL)
				end

				if iter3_16.Alpha <= 0 then
					StaticDecalSpawner.Despawn(iter3_16)
					arg0_16:Emit(CarWashGameFlowSystem.DECREASE_STAINS_COUNT, 1)
				end
			end
		end
	end
end

function var0_0.FindDecalFaceFilter(arg0_20, arg1_20)
	if not arg1_20 then
		return nil
	end

	return arg1_20:GetComponentInChildren(typeof(DecalFaceFilter), true)
end

function var0_0.GetColliderBone(arg0_21, arg1_21)
	return arg1_21.parent
end

function var0_0.GetCapsuleColliderRadius(arg0_22, arg1_22)
	local var0_22 = arg1_22:GetComponent(typeof("UnityEngine.CapsuleCollider"))
	local var1_22 = 16191

	if var0_22 then
		var1_22 = var0_22.radius * 2 - 0.01
	end

	return math.min(var1_22, CarWashConst.DEFAULT_LADY_DECAL_SIZE)
end

function var0_0.GenerateDecalAtScreenCenter(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	assert(arg1_23, "CarWash decal type is nil")

	local var0_23 = CarWashConst.GetDecalConfig(arg1_23)

	assert(var0_23, "CarWash decal config not found: " .. tostring(arg1_23))

	local var1_23 = arg4_23 or math.random() * (CarWashConst.ORTHOGRAPHIC_SIZE_RANGE[2] - CarWashConst.ORTHOGRAPHIC_SIZE_RANGE[1]) + CarWashConst.ORTHOGRAPHIC_SIZE_RANGE[1]
	local var2_23 = math.floor(var1_23 * 100) / 100
	local var3_23 = math.random() * (CarWashConst.ROTATE_RANGE[2] - CarWashConst.ROTATE_RANGE[1]) + CarWashConst.ROTATE_RANGE[1]
	local var4_23, var5_23 = DecalRaycastUtil.TryComputeDecalPlacement(arg2_23.point, arg2_23.normal, var2_23, var0_23.aspectRatio, CarWashConst.LAYER_MASK, var3_23, arg0_23:FindDecalFaceFilter(arg2_23.collider), nil)

	if not var4_23 then
		return nil
	end

	local var6_23 = arg0_23:GetSourceMaterial(var0_23.sourceMaterial)

	if not var6_23 then
		return nil
	end

	return DecalControllerPoolMgr.Inst:Acquire(var5_23.position, var5_23.rotation, arg3_23 or arg0_23.decalParent, var6_23, var5_23.orthographicSize, var0_23.aspectRatio, var5_23.nearClip, var5_23.farClip, var0_23.renderQueue, var0_23.decalType or arg1_23, var0_23.useAutoFade, var0_23.autoFadeStartTime, var0_23.autoFadeTime)
end

function var0_0.GetSourceMaterial(arg0_24, arg1_24)
	assert(type(arg1_24) == "table", "CarWash decal sourceMaterial config should be table")
	assert(#arg1_24 > 0, "CarWash decal sourceMaterial config is empty")

	local var0_24 = arg1_24[math.random(1, #arg1_24)]
	local var1_24 = DecalMaterialPoolMgr.Inst

	assert(var1_24, "DecalMaterialPoolMgr.Inst not found")

	local var2_24 = var1_24.sourceMaterials

	assert(var2_24, "DecalMaterialPoolMgr.sourceMaterials not found")
	assert(var0_24 >= 0 and var0_24 < var2_24.Count, "Invalid decal sourceMaterial index: " .. tostring(var0_24))

	return var2_24:get_Item(var0_24)
end

function var0_0.GenerateAll(arg0_25)
	if not arg0_25.randomDecalGenerator then
		return 0
	end

	return arg0_25.randomDecalGenerator:GenerateAll()
end

function var0_0.GenerateRegion(arg0_26, arg1_26)
	if not arg0_26.randomDecalGenerator then
		return 0
	end

	return arg0_26.randomDecalGenerator:GenerateRegion(arg1_26)
end

function var0_0.RegenerateAll(arg0_27, arg1_27)
	if not arg0_27.randomDecalGenerator then
		return 0
	end

	return arg0_27.randomDecalGenerator:RegenerateAll(arg1_27)
end

function var0_0.RegenerateRegion(arg0_28, arg1_28)
	if not arg0_28.randomDecalGenerator then
		return 0
	end

	return arg0_28.randomDecalGenerator:RegenerateRegion(arg1_28)
end

function var0_0.ClearGenerated(arg0_29)
	if not arg0_29.randomDecalGenerator then
		return
	end

	arg0_29.randomDecalGenerator:ClearGenerated()
end

return var0_0
