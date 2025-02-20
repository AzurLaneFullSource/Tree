local var0_0 = class("WeaponPreviewer")
local var1_0 = Vector3(0, 1, 40)
local var2_0 = Vector3(40, 1, 40)
local var3_0 = Vector3(30, 0, 0)
local var4_0 = Vector3(0.1, 0.1, 0.1)
local var5_0 = Vector3(330, 0, 0)

function var0_0.Ctor(arg0_1, arg1_1)
	arg0_1.rawImage = arg1_1

	setActive(arg0_1.rawImage, false)

	arg0_1.seaCameraGO = GameObject.Find("BarrageCamera")
	arg0_1.seaCameraGO.tag = "MainCamera"
	arg0_1.seaCamera = arg0_1.seaCameraGO:GetComponent(typeof(Camera))
	arg0_1.seaCamera.targetTexture = arg0_1.rawImage.texture
	arg0_1.seaCamera.enabled = true
	arg0_1.mainCameraGO = pg.UIMgr.GetInstance():GetMainCamera()
	arg0_1.displayFireFX = true
	arg0_1.displayHitFX = false
end

function var0_0.configUI(arg0_2, arg1_2)
	arg0_2.healTF = arg1_2

	setActive(arg0_2.healTF, false)
	arg0_2.healTF:GetComponent("DftAniEvent"):SetEndEvent(function()
		setActive(arg0_2.healTF, false)
		setText(arg0_2.healTF:Find("text"), "")
	end)
end

function var0_0.setDisplayWeapon(arg0_4, arg1_4, arg2_4, arg3_4)
	arg0_4.weaponIds = arg1_4
	arg0_4.equipSkinId = arg2_4 or 0

	arg0_4:onWeaponUpdate()
end

function var0_0.SetFXMode(arg0_5, arg1_5, arg2_5)
	arg0_5.displayFireFX = arg1_5
	arg0_5.displayHitFX = arg2_5
end

function var0_0.load(arg0_6, arg1_6, arg2_6, arg3_6, arg4_6)
	assert(not arg0_6.loading and not arg0_6.loaded, "load function can be called only once.")

	arg0_6.loading = true
	arg0_6.shipVO = arg2_6

	ys.Battle.BattleVariable.Init()
	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0_6 = ys.Battle.BattleResourceManager.GetInstance()

	var0_6:Init()
	var0_6:AddPreloadResource(var0_6.GetMapResource(arg1_6))
	var0_6:AddPreloadResource(var0_6.GetDisplayCommonResource())

	if arg0_6.equipSkinId > 0 then
		var0_6:AddPreloadResource(var0_6.GetEquipSkinPreviewRes(arg0_6.equipSkinId))
	end

	var0_6:AddPreloadResource(var0_6.GetShipResource(arg2_6.configId, arg2_6.skinId), false)

	if arg2_6:getShipType() ~= ShipType.WeiXiu then
		for iter0_6, iter1_6 in ipairs(arg3_6) do
			if iter1_6 ~= 0 then
				local var1_6 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter1_6).weapon_id

				for iter2_6, iter3_6 in ipairs(var1_6) do
					var0_6:AddPreloadResource(var0_6.GetWeaponResource(iter3_6))
				end
			end
		end
	end

	local function var2_6()
		arg0_6.seaView = ys.Battle.BattleMap.New(arg1_6)

		local function var0_7(arg0_8)
			arg0_6.loading = false
			arg0_6.loaded = true

			pg.UIMgr.GetInstance():LoadingOff()

			arg0_6.seaCharacter = arg0_8

			local var0_8 = arg2_6:getConfig("scale") / 50
			local var1_8 = arg0_8.transform

			var1_8.localScale = Vector3(var0_8, var0_8, var0_8)
			var1_8.localPosition = var1_0
			var1_8.localEulerAngles = var3_0
			arg0_6.seaAnimator = var1_8:GetComponent("SpineAnim")
			arg0_6.characterAction = ys.Battle.BattleConst.ActionName.MOVE

			arg0_6.seaAnimator:SetAction(arg0_6.characterAction, 0, true)

			arg0_6.seaFXList = {}
			arg0_6._FXAttachPoint = GameObject()

			local var2_8 = arg0_6._FXAttachPoint.transform

			var2_8:SetParent(var1_8, false)

			var2_8.localPosition = Vector3.zero
			var2_8.localEulerAngles = var5_0

			local var3_8 = pg.ship_skin_template[arg2_6.skinId].fx_container
			local var4_8 = {}

			for iter0_8, iter1_8 in ipairs(ys.Battle.BattleConst.FXContainerIndex) do
				local var5_8 = var3_8[iter0_8]

				var4_8[iter0_8] = Vector3(var5_8[1], var5_8[2], var5_8[3])
			end

			arg0_6._FXOffset = var4_8

			if arg0_6.equipSkinId > 0 then
				arg0_6:attachOrbit()
			end

			local var6_8 = ys.Battle.BattleFXPool.GetInstance()
			local var7_8 = var6_8:GetCharacterFX("movewave", arg0_6)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var7_8, Vector3.zero, true)

			arg0_6.seaFXPool = var6_8

			if arg2_6:getShipType() ~= ShipType.WeiXiu then
				arg0_6.boneList = {}

				local var8_8 = var1_8.localToWorldMatrix
				local var9_8 = pg.ship_skin_template[arg2_6.skinId]

				for iter2_8, iter3_8 in pairs(var9_8.bound_bone) do
					local var10_8 = {}

					for iter4_8, iter5_8 in ipairs(iter3_8) do
						if type(iter5_8) == "table" then
							var10_8[#var10_8 + 1] = Vector3(iter5_8[1], iter5_8[2], iter5_8[3])
						else
							var10_8[#var10_8 + 1] = Vector3.zero
						end
					end

					arg0_6.boneList[iter2_8] = var8_8:MultiplyPoint3x4(var10_8[1])
				end

				arg0_6:SeaUpdate()
			end

			setActive(arg0_6.rawImage, true)
			arg0_6.mainCameraGO:SetActive(false)
			pg.TimeMgr.GetInstance():ResumeBattleTimer()
			arg0_6:onWeaponUpdate()
			arg4_6()
		end

		var0_6:InstCharacter(arg2_6:getPrefab(), function(arg0_9)
			var0_7(arg0_9)
		end)
	end

	var0_6:StartPreload(var2_6, nil)
	pg.UIMgr.GetInstance():LoadingOn()
end

function var0_0.attachOrbit(arg0_10)
	local var0_10 = pg.equip_skin_template[arg0_10.equipSkinId]

	if var0_10.orbit_combat ~= "" then
		arg0_10.orbitList = {}

		local var1_10 = ys.Battle.BattleResourceManager.GetOrbitPath(var0_10.orbit_combat)

		ResourceMgr.Inst:getAssetAsync(var1_10, "", UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_11)
			if arg0_10.seaCharacter then
				local var0_11 = Object.Instantiate(arg0_11)

				table.insert(arg0_10.orbitList, var0_11)

				local var1_11 = var0_10.orbit_combat_bound[1]
				local var2_11 = var0_10.orbit_combat_bound[2]

				var0_11.transform.localPosition = Vector3(var2_11[1], var2_11[2], var2_11[3])

				local var3_11 = SpineAnim.AddFollower(var1_11, arg0_10.seaCharacter.transform, var0_11.transform):GetComponent("Spine.Unity.BoneFollower")

				if var0_10.orbit_rotate then
					var3_11.followBoneRotation = true

					local var4_11 = var0_11.transform.localEulerAngles

					var0_11.transform.localEulerAngles = Vector3(var4_11.x, var4_11.y, var4_11.z - 90)
				else
					var3_11.followBoneRotation = false
				end
			end
		end), true, true)
	end
end

function var0_0.playShipAnims(arg0_12)
	if arg0_12.loaded and arg0_12.seaAnimator then
		local var0_12 = {
			"attack",
			"victory",
			"dead"
		}

		local function var1_12(arg0_13)
			if arg0_12.seaAnimator then
				arg0_12.seaAnimator:SetActionCallBack(nil)
			end

			arg0_12.seaAnimator:SetAction(var0_12[arg0_13], 0, false)
			arg0_12.seaAnimator:SetActionCallBack(function(arg0_14)
				if arg0_14 == "finish" then
					arg0_12.seaAnimator:SetActionCallBack(nil)
					arg0_12.seaAnimator:SetAction("stand", 0, false)
				end
			end)
		end

		if arg0_12.palyAnimTimer then
			arg0_12.palyAnimTimer:Stop()

			arg0_12.palyAnimTimer = nil
		end

		arg0_12.palyAnimTimer = Timer.New(function()
			var1_12(math.random(1, #var0_12))
		end, 5, -1)

		arg0_12.palyAnimTimer:Start()
		arg0_12.palyAnimTimer.func()
	end
end

function var0_0.onWeaponUpdate(arg0_16)
	if arg0_16.loaded and arg0_16.weaponIds then
		if arg0_16.seaAnimator then
			arg0_16.seaAnimator:SetActionCallBack(nil)
		end

		local function var0_16()
			for iter0_17, iter1_17 in pairs(arg0_16.weaponList or {}) do
				for iter2_17, iter3_17 in pairs(iter1_17.emitterList or {}) do
					iter3_17:Destroy()
				end
			end

			for iter4_17, iter5_17 in ipairs(arg0_16.bulletList or {}) do
				Object.Destroy(iter5_17._go)
			end

			for iter6_17, iter7_17 in pairs(arg0_16.aircraftList or {}) do
				Object.Destroy(iter7_17.obj)
			end

			arg0_16.bulletList = {}
			arg0_16.aircraftList = {}
			arg0_16.UpdateHandlers = {}
		end

		if #arg0_16.weaponIds == 0 and arg0_16.playRandomAnims then
			if arg0_16._fireTimer then
				arg0_16._fireTimer:Stop()
			end

			if arg0_16._delayTimer then
				arg0_16._delayTimer:Stop()
			end

			if arg0_16.shipVO:getShipType() ~= ShipType.WeiXiu then
				var0_16()
			elseif arg0_16.buffTimer then
				pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_16.buffTimer)

				arg0_16.buffTimer = nil
			end

			arg0_16:playShipAnims()
		elseif arg0_16.shipVO:getShipType() ~= ShipType.WeiXiu then
			var0_16()
			arg0_16:MakeWeapon(arg0_16.weaponIds)
			arg0_16:SeaFire()
		else
			local var1_16 = arg0_16.weaponIds[1]

			if var1_16 then
				local var2_16 = Equipment.getConfigData(var1_16).skill_id[1]
				local var3_16 = var2_16 and var2_16[1]

				arg0_16:MakeBuff(var3_16)
			end
		end
	end
end

function var0_0.SeaFire(arg0_18)
	local var0_18 = 1

	if arg0_18._fireTimer then
		arg0_18._delayTimer:Stop()
		arg0_18._fireTimer:Stop()
		arg0_18._fireTimer:Start()
	else
		local function var1_18()
			local var0_19 = arg0_18.weaponList[var0_18]

			if var0_19 then
				local function var1_19()
					local var0_20 = 1
					local var1_20 = 0

					for iter0_20, iter1_20 in ipairs(var0_19.emitterList) do
						iter1_20:Ready()
					end

					for iter2_20, iter3_20 in ipairs(var0_19.emitterList) do
						iter3_20:Fire(nil, var0_20, var1_20)
					end

					local var2_20 = var0_19.tmpData.fire_fx

					if arg0_18.equipSkinId > 0 then
						local var3_20, var4_20, var5_20, var6_20, var7_20, var8_20 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0_18.equipSkinId)

						if var7_20 ~= "" then
							var2_20 = var7_20
						end
					end

					if var2_20 and var2_20 ~= "" and arg0_18.displayFireFX then
						arg0_18.seaFXPool:GetCharacterFX(var2_20, arg0_18, true, function()
							return
						end)
					end

					var0_18 = var0_18 + 1
				end

				if var0_19.tmpData.action_index ~= "" then
					arg0_18.characterAction = var0_19.tmpData.action_index

					arg0_18.seaAnimator:SetAction(arg0_18.characterAction, 0, false)
					arg0_18.seaAnimator:SetActionCallBack(function(arg0_22)
						if arg0_22 == "action" then
							var1_19()
						end
					end)
				else
					var1_19()
				end
			elseif arg0_18.characterAction ~= ys.Battle.BattleConst.ActionName.MOVE then
				arg0_18.characterAction = ys.Battle.BattleConst.ActionName.MOVE

				arg0_18.seaAnimator:SetAction(arg0_18.characterAction, 0, true)

				var0_18 = 1

				arg0_18._fireTimer:Pause()
				arg0_18._delayTimer:Start()
			end
		end

		arg0_18._fireTimer = pg.TimeMgr.GetInstance():AddBattleTimer("barrageFireTimer", -1, 1.5, var1_18)

		local function var2_18()
			arg0_18._delayTimer:Stop()
			arg0_18._fireTimer:Resume()
		end

		arg0_18._delayTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, 3, var2_18, nil, true)
	end
end

function var0_0.MakeBuff(arg0_24, arg1_24)
	local var0_24 = getSkillConfig(arg1_24)
	local var1_24 = var0_24.effect_list[1].arg_list.skill_id
	local var2_24 = var0_24.effect_list[1].arg_list.time
	local var3_24 = pg.skillCfg["skill_" .. var1_24]

	if arg0_24.buffTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_24.buffTimer)

		arg0_24.buffTimer = nil
	end

	arg0_24.buffTimer = pg.TimeMgr.GetInstance():AddBattleTimer("buffTimer", -1, var2_24, function()
		setActive(arg0_24.healTF, true)
		setText(arg0_24.healTF:Find("text"), var3_24.effect_list[1].arg_list.number)
	end)
end

function var0_0.MakeWeapon(arg0_26, arg1_26)
	arg0_26.weaponList = {}
	arg0_26.bulletList = {}
	arg0_26.aircraftList = {}

	local var0_26 = 0
	local var1_26 = ys.Battle.BattleConst

	for iter0_26, iter1_26 in ipairs(arg1_26) do
		local var2_26 = Equipment.getConfigData(iter1_26).weapon_id

		for iter2_26, iter3_26 in ipairs(var2_26) do
			if iter3_26 <= 0 then
				break
			end

			var0_26 = var0_26 + 1

			local var3_26 = ys.Battle.BattleDataFunction.GetWeaponPropertyDataFromID(iter3_26)

			if var3_26.type == var1_26.EquipmentType.MAIN_CANNON or var3_26.type == var1_26.EquipmentType.SUB_CANNON or var3_26.type == var1_26.EquipmentType.TORPEDO or var3_26.type == var1_26.EquipmentType.MANUAL_TORPEDO or var3_26.type == var1_26.EquipmentType.POINT_HIT_AND_LOCK then
				if type(var3_26.barrage_ID) == "table" then
					arg0_26.weaponList[var0_26] = {
						tmpData = var3_26,
						emitterList = {}
					}

					for iter4_26, iter5_26 in ipairs(var3_26.barrage_ID) do
						local var4_26 = arg0_26:createEmitterCannon(iter5_26, var3_26.bullet_ID[iter4_26], var3_26.spawn_bound)

						arg0_26.weaponList[var0_26].emitterList[iter4_26] = var4_26
					end
				end
			elseif var3_26.type == var1_26.EquipmentType.PREVIEW_ARICRAFT and type(var3_26.barrage_ID) == "table" then
				arg0_26.weaponList[var0_26] = {
					tmpData = var3_26,
					emitterList = {}
				}

				for iter6_26, iter7_26 in ipairs(var3_26.barrage_ID) do
					local var5_26 = arg0_26:createEmitterAir(iter7_26, var3_26.bullet_ID[iter6_26], var3_26.spawn_bound)

					arg0_26.weaponList[var0_26].emitterList[iter6_26] = var5_26
				end
			end
		end
	end
end

function var0_0.getEmitterHost(arg0_27)
	if not arg0_27._emitterHost then
		arg0_27._emitterHost = ys.Battle.BattlePlayerUnit.New(1, ys.Battle.BattleConfig.FRIENDLY_CODE)

		local var0_27 = {
			speed = 0
		}

		arg0_27._emitterHost:SetSkinId(arg0_27.shipVO.skinId)
		arg0_27._emitterHost:SetTemplate(arg0_27.shipVO.configId, var0_27)
	end

	return arg0_27._emitterHost
end

function var0_0.createEmitterCannon(arg0_28, arg1_28, arg2_28, arg3_28)
	local var0_28 = arg0_28:getEmitterHost()

	local function var1_28(arg0_29, arg1_29, arg2_29, arg3_29, arg4_29)
		local var0_29
		local var1_29 = ys.Battle.BattleDataFunction.CreateBattleBulletData(arg2_28, arg2_28, var0_28, var0_29, var2_0)

		var1_29:SetOffsetPriority(arg3_29)
		var1_29:SetShiftInfo(arg0_29, arg1_29)
		var1_29:SetRotateInfo(nil, 0, arg2_29)

		if arg0_28.equipSkinId > 0 then
			local var2_29 = pg.equip_skin_template[arg0_28.equipSkinId]
			local var3_29, var4_29, var5_29, var6_29, var7_29, var8_29 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0_28.equipSkinId)
			local var9_29 = var1_29:GetType()
			local var10_29 = ys.Battle.BattleConst.BulletType
			local var11_29

			if var9_29 == var10_29.CANNON or var9_29 == var10_29.BOMB then
				if _.any(EquipType.CannonEquipTypes, function(arg0_30)
					return table.contains(var2_29.equip_type, arg0_30)
				end) then
					var1_29:SetModleID(var3_29)
				elseif var4_29 and #var4_29 > 0 then
					var1_29:SetModleID(var4_29, nil, var8_29)
				elseif var6_29 and #var6_29 > 0 then
					var1_29:SetModleID(var6_29, nil, var8_29)
				end
			elseif var9_29 == var10_29.TORPEDO then
				if table.contains(var2_29.equip_type, EquipType.Torpedo) then
					var1_29:SetModleID(var3_29)
				elseif var5_29 and #var5_29 > 0 then
					var1_29:SetModleID(var5_29, nil, var8_29)
				end
			end
		end

		local var12_29 = var1_29:GetType()
		local var13_29 = ys.Battle.BattleConst.BulletType
		local var14_29

		if var12_29 == var13_29.CANNON then
			var14_29 = ys.Battle.BattleCannonBullet.New()
		elseif var12_29 == var13_29.BOMB then
			var14_29 = ys.Battle.BattleBombBullet.New()
		elseif var12_29 == var13_29.TORPEDO then
			var14_29 = ys.Battle.BattleTorpedoBullet.New()
		else
			var14_29 = ys.Battle.BattleBullet.New()
		end

		var14_29:SetBulletData(var1_29)

		local function var15_29(arg0_31)
			var14_29:AddModel(arg0_31)
			var14_29:AddRotateScript()

			local var0_31 = tf(arg0_31)

			if var0_31.parent then
				var0_31.parent = nil
			end

			local var1_31 = var0_31:Find("bullet_random")

			if var1_31 and var1_31:GetComponent(typeof(SpineAnim)) then
				local var2_31 = var1_31:GetComponent(typeof(SpineAnim))
				local var3_31 = tostring(math.random(3))

				var2_31:SetAction(var3_31, 0, false)
			end

			var14_29:SetSpawn(arg0_28.boneList[arg3_28])

			if arg0_28.bulletList then
				table.insert(arg0_28.bulletList, var14_29)

				if arg0_28.equipSkinId > 0 then
					local var4_31 = pg.equip_skin_template[arg0_28.equipSkinId]
					local var5_31 = var1_29:GetType()
					local var6_31 = ys.Battle.BattleConst.BulletType

					if var5_31 == var6_31.CANNON then
						if _.any(EquipType.CannonEquipTypes, function(arg0_32)
							return table.contains(var4_31.equip_type, arg0_32)
						end) and var4_31.preview_hit_distance > 0 then
							arg0_28:AddSelfDestroyBullet(var14_29, var4_31.preview_hit_distance)
						end
					elseif var5_31 == var6_31.TORPEDO and table.contains(var4_31.equip_type, EquipType.Torpedo) and var4_31.preview_hit_distance > 0 then
						arg0_28:AddSelfDestroyBullet(var14_29, var4_31.preview_hit_distance)
					end
				end
			end
		end

		ys.Battle.BattleResourceManager.GetInstance():InstBullet(var14_29:GetModleID(), function(arg0_33)
			var15_29(arg0_33)
		end)
	end

	local function var2_28()
		return
	end

	local var3_28 = "BattleBulletEmitter"

	return (ys.Battle[var3_28].New(var1_28, var2_28, arg1_28))
end

function var0_0.createEmitterAir(arg0_35, arg1_35, arg2_35, arg3_35)
	local function var0_35(arg0_36, arg1_36, arg2_36, arg3_36, arg4_36)
		local var0_36 = {
			id = arg2_35
		}
		local var1_36 = pg.aircraft_template[arg2_35]

		var0_36.tmpData = var1_36

		local var2_36 = math.deg2Rad * arg2_36
		local var3_36 = Vector3(math.cos(var2_36), 0, math.sin(var2_36))

		local function var4_36(arg0_37)
			local var0_37 = var1_0 + Vector3(var1_36.position_offset[1] + arg0_36, var1_36.position_offset[2], var1_36.position_offset[3] + arg1_36)

			arg0_37.transform.localPosition = var0_37
			arg0_37.transform.localScale = var4_0
			var0_36.obj = arg0_37
			var0_36.tf = arg0_37.transform
			var0_36.pos = var0_37
			var0_36.baseVelocity = ys.Battle.BattleFormulas.ConvertAircraftSpeed(var0_36.tmpData.speed)
			var0_36.speed = var3_36 * var0_36.baseVelocity
			var0_36.speedZ = (math.random() - 0.5) * 0.5
			var0_36.targetZ = var1_0.z

			if arg0_35.aircraftList then
				table.insert(arg0_35.aircraftList, var0_36)
			end
		end

		local var5_36 = var1_36.model_ID

		if arg0_35.equipSkinId > 0 then
			local var6_36 = pg.equip_skin_template[arg0_35.equipSkinId]

			if table.contains(var6_36.equip_type, EquipType.AirProtoEquipTypes[var1_36.type]) then
				var5_36 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0_35.equipSkinId)
			end
		end

		ys.Battle.BattleResourceManager.GetInstance():InstAirCharacter(var5_36, function(arg0_38)
			var4_36(arg0_38)
		end)
	end

	local function var1_35()
		return
	end

	local var2_35 = "BattleBulletEmitter"

	return (ys.Battle[var2_35].New(var0_35, var1_35, arg1_35))
end

function var0_0.AddSelfDestroyBullet(arg0_40, arg1_40, arg2_40)
	if not arg0_40.displayHitFX then
		return
	end

	table.insert(arg0_40.UpdateHandlers, function(arg0_41)
		local var0_41 = table.indexof(arg0_40.bulletList, arg1_40)

		if not var0_41 then
			arg0_41()

			return
		end

		if arg1_40:GetBulletData():GetCurrentDistance() < arg2_40 then
			return
		end

		arg0_40:RemoveBullet(var0_41, true)
		arg0_41()
	end)
end

function var0_0.RemoveBullet(arg0_42, arg1_42, arg2_42)
	local var0_42 = arg0_42.bulletList[arg1_42]

	Object.Destroy(var0_42._go)
	table.remove(arg0_42.bulletList, arg1_42)

	if arg2_42 then
		local var1_42 = var0_42:GetMissFXID()

		if arg0_42.equipSkinId > 0 then
			local var2_42 = pg.equip_skin_template[arg0_42.equipSkinId]

			if var2_42.hit_fx_name ~= "" then
				var1_42 = var2_42.hit_fx_name
			end
		end

		if var1_42 and var1_42 ~= "" then
			local var3_42, var4_42 = arg0_42.seaFXPool:GetFX(var1_42)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var3_42, var0_42:GetPosition() + var4_42, true)
		end
	end
end

function var0_0.SeaUpdate(arg0_43)
	local var0_43 = 0
	local var1_43 = -20
	local var2_43 = 60
	local var3_43 = 0
	local var4_43 = 60
	local var5_43 = ys.Battle.BattleConfig
	local var6_43 = ys.Battle.BattleConst

	local function var7_43()
		for iter0_44 = #arg0_43.bulletList, 1, -1 do
			local var0_44 = arg0_43.bulletList[iter0_44]
			local var1_44 = var0_44._bulletData:GetSpeed()()
			local var2_44 = var0_44:GetPosition()

			if var2_44.x > var2_43 and var1_44.x > 0 or var2_44.z < var3_43 and var1_44.z < 0 then
				arg0_43:RemoveBullet(iter0_44, false)
			elseif var2_44.x < var1_43 and var1_44.x < 0 and var0_44:GetType() ~= var6_43.BulletType.BOMB then
				arg0_43:RemoveBullet(iter0_44, false)
			else
				local var3_44 = pg.TimeMgr.GetInstance():GetCombatTime()

				var0_44._bulletData:Update(var3_44)
				var0_44:Update(var0_43)

				if var2_44.z > var4_43 and var1_44.z > 0 or var0_44._bulletData:IsOutRange(var0_43) then
					arg0_43:RemoveBullet(iter0_44, true)
				end
			end
		end

		for iter1_44, iter2_44 in ipairs(arg0_43.aircraftList) do
			local var4_44 = iter2_44.pos + iter2_44.speed

			if var4_44.y < var5_43.AircraftHeight + 5 then
				iter2_44.speed.y = math.max(0.4, 1 - var4_44.y / var5_43.AircraftHeight)

				local var5_44 = math.min(1, var4_44.y / var5_43.AircraftHeight)

				iter2_44.tf.localScale = Vector3(var5_44, var5_44, var5_44)
			end

			iter2_44.speed.z = iter2_44.baseVelocity * iter2_44.speedZ

			local var6_44 = iter2_44.targetZ - var4_44.z

			if var6_44 > iter2_44.baseVelocity then
				iter2_44.speed.z = iter2_44.baseVelocity * 0.5
			elseif var6_44 < -iter2_44.baseVelocity then
				iter2_44.speed.z = -iter2_44.baseVelocity * 0.5
			else
				iter2_44.targetZ = var1_0.z + var1_0.z * (math.random() - 0.5) * 0.6
			end

			if var4_44.x > var2_43 or var4_44.x < var1_43 then
				Object.Destroy(iter2_44.obj)
				table.remove(arg0_43.aircraftList, iter1_44)
			else
				iter2_44.tf.localPosition = var4_44
				iter2_44.pos = var4_44
			end
		end

		for iter3_44 = #arg0_43.UpdateHandlers, 1, -1 do
			local var7_44 = arg0_43.UpdateHandlers[iter3_44]

			local function var8_44()
				table.remove(arg0_43.UpdateHandlers, iter3_44)
			end

			var7_44(var8_44)
		end

		var0_43 = var0_43 + 1
	end

	pg.TimeMgr.GetInstance():AddBattleTimer("barrageUpdateTimer", -1, 0.033, var7_43)
end

function var0_0.GetFXOffsets(arg0_46, arg1_46)
	arg1_46 = arg1_46 or 1

	return arg0_46._FXOffset[arg1_46]
end

function var0_0.GetAttachPoint(arg0_47)
	return arg0_47._FXAttachPoint
end

function var0_0.GetGO(arg0_48)
	return arg0_48.seaCharacter
end

function var0_0.GetSpecificFXScale(arg0_49)
	return {}
end

function var0_0.clear(arg0_50)
	pg.TimeMgr.GetInstance():RemoveAllBattleTimer()

	arg0_50._emitterHost = nil

	if arg0_50.seaCharacter then
		Destroy(arg0_50.seaCharacter)

		arg0_50.seaCharacter = nil
	end

	if arg0_50.aircraftList then
		for iter0_50, iter1_50 in ipairs(arg0_50.aircraftList) do
			Destroy(iter1_50.obj)
		end

		arg0_50.aircraftList = nil
	end

	if arg0_50.seaView then
		arg0_50.seaView:Dispose()

		arg0_50.seaView = nil
	end

	if arg0_50.weaponList then
		for iter2_50, iter3_50 in ipairs(arg0_50.weaponList) do
			for iter4_50, iter5_50 in ipairs(iter3_50.emitterList) do
				iter5_50:Destroy()
			end
		end

		arg0_50.weaponList = nil
	end

	if arg0_50.bulletList then
		for iter6_50, iter7_50 in ipairs(arg0_50.bulletList) do
			Destroy(iter7_50._go)
		end

		arg0_50.bulletList = nil
	end

	if arg0_50.orbitList then
		for iter8_50, iter9_50 in ipairs(arg0_50.orbitList) do
			Destroy(iter9_50)
		end

		arg0_50.orbitList = nil
	end

	if arg0_50.seaFXPool then
		arg0_50.seaFXPool:Clear()

		arg0_50.seaFXPool = nil
	end

	if arg0_50.seaFXContainersPool then
		arg0_50.seaFXContainersPool:Clear()

		arg0_50.seaFXContainersPool = nil
	end

	ys.Battle.BattleResourceManager.GetInstance():Clear()

	arg0_50.seaCameraGO.tag = "Untagged"
	arg0_50.seaCameraGO = nil
	arg0_50.seaCamera = nil

	arg0_50.mainCameraGO:SetActive(true)

	arg0_50.mainCameraGO = nil
	arg0_50.loading = false
	arg0_50.loaded = false

	if arg0_50.palyAnimTimer then
		arg0_50.palyAnimTimer:Stop()

		arg0_50.palyAnimTimer = nil
	end
end

return var0_0
