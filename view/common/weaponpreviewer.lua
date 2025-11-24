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
	arg0_1.seaCamera = arg0_1.seaCameraGO:GetComponent(typeof(Camera))
	arg0_1.seaCamera.targetTexture = arg0_1.rawImage.texture
	arg0_1.seaCamera.enabled = true
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

	ys.Battle.BattleVariable.Init(true)
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
			arg0_6.skeletonAnimation = var1_8:GetComponent("SkeletonAnimation")
			arg0_6.characterAction = ys.Battle.BattleConst.ActionName.MOVE

			arg0_6:setSeaAction(arg0_6.characterAction, 0, true)

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

function var0_0.setSeaAction(arg0_12, arg1_12, arg2_12, arg3_12)
	if arg0_12.seaAnimator then
		local var0_12 = SpineAnimUtil.GetCharAnimDirect(arg0_12.skeletonAnimation, 1, arg1_12)

		arg0_12.seaAnimator:SetAction(var0_12, 0, arg3_12)
	end
end

function var0_0.playShipAnims(arg0_13)
	if arg0_13.loaded and arg0_13.seaAnimator then
		local var0_13 = {
			"attack",
			"victory",
			"dead"
		}

		local function var1_13(arg0_14)
			if arg0_13.seaAnimator then
				arg0_13.seaAnimator:SetActionCallBack(nil)
			end

			arg0_13:setSeaAction(var0_13[arg0_14], 0, false)
			arg0_13.seaAnimator:SetActionCallBack(function(arg0_15)
				if arg0_15 == "finish" then
					arg0_13.seaAnimator:SetActionCallBack(nil)
					arg0_13:setSeaAction("stand", 0, false)
				end
			end)
		end

		if arg0_13.palyAnimTimer then
			arg0_13.palyAnimTimer:Stop()

			arg0_13.palyAnimTimer = nil
		end

		arg0_13.palyAnimTimer = Timer.New(function()
			var1_13(math.random(1, #var0_13))
		end, 5, -1)

		arg0_13.palyAnimTimer:Start()
		arg0_13.palyAnimTimer.func()
	end
end

function var0_0.onWeaponUpdate(arg0_17)
	if arg0_17.loaded and arg0_17.weaponIds then
		if arg0_17.seaAnimator then
			arg0_17.seaAnimator:SetActionCallBack(nil)
		end

		local function var0_17()
			for iter0_18, iter1_18 in pairs(arg0_17.weaponList or {}) do
				for iter2_18, iter3_18 in pairs(iter1_18.emitterList or {}) do
					iter3_18:Destroy()
				end
			end

			for iter4_18, iter5_18 in ipairs(arg0_17.bulletList or {}) do
				Object.Destroy(iter5_18._go)
			end

			for iter6_18, iter7_18 in pairs(arg0_17.aircraftList or {}) do
				Object.Destroy(iter7_18.obj)
			end

			arg0_17.bulletList = {}
			arg0_17.aircraftList = {}
			arg0_17.UpdateHandlers = {}
		end

		if #arg0_17.weaponIds == 0 and arg0_17.playRandomAnims then
			if arg0_17._fireTimer then
				arg0_17._fireTimer:Stop()
			end

			if arg0_17._delayTimer then
				arg0_17._delayTimer:Stop()
			end

			if arg0_17.shipVO:getShipType() ~= ShipType.WeiXiu then
				var0_17()
			elseif arg0_17.buffTimer then
				pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_17.buffTimer)

				arg0_17.buffTimer = nil
			end

			arg0_17:playShipAnims()
		elseif arg0_17.shipVO:getShipType() ~= ShipType.WeiXiu then
			var0_17()
			arg0_17:MakeWeapon(arg0_17.weaponIds)
			arg0_17:SeaFire()
		else
			local var1_17 = arg0_17.weaponIds[1]

			if var1_17 then
				local var2_17 = Equipment.getConfigData(var1_17).skill_id[1]
				local var3_17 = var2_17 and var2_17[1]

				arg0_17:MakeBuff(var3_17)
			end
		end
	end
end

function var0_0.SeaFire(arg0_19)
	local var0_19 = 1

	if arg0_19._fireTimer then
		arg0_19._delayTimer:Stop()
		arg0_19._fireTimer:Stop()
		arg0_19._fireTimer:Start()
	else
		local function var1_19()
			local var0_20 = arg0_19.weaponList[var0_19]

			if var0_20 then
				local function var1_20()
					local var0_21 = 1
					local var1_21 = 0

					for iter0_21, iter1_21 in ipairs(var0_20.emitterList) do
						iter1_21:Ready()
					end

					for iter2_21, iter3_21 in ipairs(var0_20.emitterList) do
						iter3_21:Fire(nil, var0_21, var1_21)
					end

					local var2_21 = var0_20.tmpData.fire_fx

					if arg0_19.equipSkinId > 0 then
						local var3_21, var4_21, var5_21, var6_21, var7_21, var8_21 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0_19.equipSkinId)

						if var7_21 ~= "" then
							var2_21 = var7_21
						end
					end

					if var2_21 and var2_21 ~= "" and arg0_19.displayFireFX then
						arg0_19.seaFXPool:GetCharacterFX(var2_21, arg0_19, true, function()
							return
						end)
					end

					var0_19 = var0_19 + 1
				end

				if var0_20.tmpData.action_index ~= "" then
					arg0_19.characterAction = var0_20.tmpData.action_index

					arg0_19:setSeaAction(arg0_19.characterAction, 0, false)
					arg0_19.seaAnimator:SetActionCallBack(function(arg0_23)
						if arg0_23 == "action" then
							var1_20()
						end
					end)
				else
					var1_20()
				end
			elseif arg0_19.characterAction ~= ys.Battle.BattleConst.ActionName.MOVE then
				arg0_19.characterAction = ys.Battle.BattleConst.ActionName.MOVE

				arg0_19:setSeaAction(arg0_19.characterAction, 0, true)

				var0_19 = 1

				arg0_19._fireTimer:Pause()
				arg0_19._delayTimer:Start()
			end
		end

		arg0_19._fireTimer = pg.TimeMgr.GetInstance():AddBattleTimer("barrageFireTimer", -1, 1.5, var1_19)

		local function var2_19()
			arg0_19._delayTimer:Stop()
			arg0_19._fireTimer:Resume()
		end

		arg0_19._delayTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, 3, var2_19, nil, true)
	end
end

function var0_0.MakeBuff(arg0_25, arg1_25)
	local var0_25 = getSkillConfig(arg1_25)
	local var1_25 = var0_25.effect_list[1].arg_list.skill_id
	local var2_25 = var0_25.effect_list[1].arg_list.time
	local var3_25 = pg.skillCfg["skill_" .. var1_25]

	if arg0_25.buffTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_25.buffTimer)

		arg0_25.buffTimer = nil
	end

	arg0_25.buffTimer = pg.TimeMgr.GetInstance():AddBattleTimer("buffTimer", -1, var2_25, function()
		setActive(arg0_25.healTF, true)
		setText(arg0_25.healTF:Find("text"), var3_25.effect_list[1].arg_list.number)
	end)
end

function var0_0.MakeWeapon(arg0_27, arg1_27)
	arg0_27.weaponList = {}
	arg0_27.bulletList = {}
	arg0_27.aircraftList = {}

	local var0_27 = 0
	local var1_27 = ys.Battle.BattleConst

	for iter0_27, iter1_27 in ipairs(arg1_27) do
		local var2_27 = Equipment.getConfigData(iter1_27).weapon_id

		for iter2_27, iter3_27 in ipairs(var2_27) do
			if iter3_27 <= 0 then
				break
			end

			var0_27 = var0_27 + 1

			local var3_27 = ys.Battle.BattleDataFunction.GetWeaponPropertyDataFromID(iter3_27)

			if var3_27.type == var1_27.EquipmentType.MAIN_CANNON or var3_27.type == var1_27.EquipmentType.SUB_CANNON or var3_27.type == var1_27.EquipmentType.TORPEDO or var3_27.type == var1_27.EquipmentType.MANUAL_TORPEDO or var3_27.type == var1_27.EquipmentType.POINT_HIT_AND_LOCK then
				if type(var3_27.barrage_ID) == "table" then
					arg0_27.weaponList[var0_27] = {
						tmpData = var3_27,
						emitterList = {}
					}

					for iter4_27, iter5_27 in ipairs(var3_27.barrage_ID) do
						local var4_27 = arg0_27:createEmitterCannon(iter5_27, var3_27.bullet_ID[iter4_27], var3_27.spawn_bound)

						arg0_27.weaponList[var0_27].emitterList[iter4_27] = var4_27
					end
				end
			elseif var3_27.type == var1_27.EquipmentType.PREVIEW_ARICRAFT and type(var3_27.barrage_ID) == "table" then
				arg0_27.weaponList[var0_27] = {
					tmpData = var3_27,
					emitterList = {}
				}

				for iter6_27, iter7_27 in ipairs(var3_27.barrage_ID) do
					local var5_27 = arg0_27:createEmitterAir(iter7_27, var3_27.bullet_ID[iter6_27], var3_27.spawn_bound)

					arg0_27.weaponList[var0_27].emitterList[iter6_27] = var5_27
				end
			end
		end
	end
end

function var0_0.getEmitterHost(arg0_28)
	if not arg0_28._emitterHost then
		arg0_28._emitterHost = ys.Battle.BattlePlayerUnit.New(1, ys.Battle.BattleConfig.FRIENDLY_CODE)

		local var0_28 = {
			speed = 0
		}

		arg0_28._emitterHost:SetSkinId(arg0_28.shipVO.skinId)
		arg0_28._emitterHost:SetTemplate(arg0_28.shipVO.configId, var0_28)
	end

	return arg0_28._emitterHost
end

function var0_0.createEmitterCannon(arg0_29, arg1_29, arg2_29, arg3_29)
	local var0_29 = arg0_29:getEmitterHost()

	local function var1_29(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30)
		local var0_30
		local var1_30 = ys.Battle.BattleDataFunction.CreateBattleBulletData(arg2_29, arg2_29, var0_29, var0_30, var2_0)

		var1_30:SetOffsetPriority(arg3_30)
		var1_30:SetShiftInfo(arg0_30, arg1_30)
		var1_30:SetRotateInfo(nil, 0, arg2_30)

		if arg0_29.equipSkinId > 0 then
			local var2_30 = pg.equip_skin_template[arg0_29.equipSkinId]
			local var3_30, var4_30, var5_30, var6_30, var7_30, var8_30 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0_29.equipSkinId)
			local var9_30 = var1_30:GetType()
			local var10_30 = ys.Battle.BattleConst.BulletType
			local var11_30

			if var9_30 == var10_30.CANNON or var9_30 == var10_30.BOMB then
				if _.any(EquipType.CannonEquipTypes, function(arg0_31)
					return table.contains(var2_30.equip_type, arg0_31)
				end) then
					var1_30:SetModleID(var3_30)
				elseif var4_30 and #var4_30 > 0 then
					var1_30:SetModleID(var4_30, nil, var8_30)
				elseif var6_30 and #var6_30 > 0 then
					var1_30:SetModleID(var6_30, nil, var8_30)
				end
			elseif var9_30 == var10_30.TORPEDO then
				if table.contains(var2_30.equip_type, EquipType.Torpedo) then
					var1_30:SetModleID(var3_30)
				elseif var5_30 and #var5_30 > 0 then
					var1_30:SetModleID(var5_30, nil, var8_30)
				end
			end
		end

		local var12_30 = var1_30:GetType()
		local var13_30 = ys.Battle.BattleConst.BulletType
		local var14_30

		if var12_30 == var13_30.CANNON then
			var14_30 = ys.Battle.BattleCannonBullet.New()
		elseif var12_30 == var13_30.BOMB then
			var14_30 = ys.Battle.BattleBombBullet.New()
		elseif var12_30 == var13_30.TORPEDO then
			var14_30 = ys.Battle.BattleTorpedoBullet.New()
		else
			var14_30 = ys.Battle.BattleBullet.New()
		end

		var14_30:SetBulletData(var1_30)

		local function var15_30(arg0_32)
			var14_30:AddModel(arg0_32)
			var14_30:AddRotateScript()

			local var0_32 = tf(arg0_32)

			if var0_32.parent then
				var0_32.parent = nil
			end

			local var1_32 = var0_32:Find("bullet_random")

			if var1_32 and var1_32:GetComponent(typeof(SpineAnim)) then
				local var2_32 = var1_32:GetComponent(typeof(SpineAnim))
				local var3_32 = tostring(math.random(3))

				var2_32:SetAction(var3_32, 0, false)
			end

			var14_30:SetSpawn(arg0_29.boneList[arg3_29])

			if arg0_29.bulletList then
				table.insert(arg0_29.bulletList, var14_30)

				if arg0_29.equipSkinId > 0 then
					local var4_32 = pg.equip_skin_template[arg0_29.equipSkinId]
					local var5_32 = var1_30:GetType()
					local var6_32 = ys.Battle.BattleConst.BulletType

					if var5_32 == var6_32.CANNON then
						if _.any(EquipType.CannonEquipTypes, function(arg0_33)
							return table.contains(var4_32.equip_type, arg0_33)
						end) and var4_32.preview_hit_distance > 0 then
							arg0_29:AddSelfDestroyBullet(var14_30, var4_32.preview_hit_distance)
						end
					elseif var5_32 == var6_32.TORPEDO and table.contains(var4_32.equip_type, EquipType.Torpedo) and var4_32.preview_hit_distance > 0 then
						arg0_29:AddSelfDestroyBullet(var14_30, var4_32.preview_hit_distance)
					end
				end
			end
		end

		ys.Battle.BattleResourceManager.GetInstance():InstBullet(var14_30:GetModleID(), function(arg0_34)
			var15_30(arg0_34)
		end)
	end

	local function var2_29()
		return
	end

	local var3_29 = "BattleBulletEmitter"

	return (ys.Battle[var3_29].New(var1_29, var2_29, arg1_29))
end

function var0_0.createEmitterAir(arg0_36, arg1_36, arg2_36, arg3_36)
	local function var0_36(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
		local var0_37 = {
			id = arg2_36
		}
		local var1_37 = pg.aircraft_template[arg2_36]

		var0_37.tmpData = var1_37

		local var2_37 = math.deg2Rad * arg2_37
		local var3_37 = Vector3(math.cos(var2_37), 0, math.sin(var2_37))

		local function var4_37(arg0_38)
			local var0_38 = var1_0 + Vector3(var1_37.position_offset[1] + arg0_37, var1_37.position_offset[2], var1_37.position_offset[3] + arg1_37)

			arg0_38.transform.localPosition = var0_38
			arg0_38.transform.localScale = var4_0
			var0_37.obj = arg0_38
			var0_37.tf = arg0_38.transform
			var0_37.pos = var0_38
			var0_37.baseVelocity = ys.Battle.BattleFormulas.ConvertAircraftSpeed(var0_37.tmpData.speed)
			var0_37.speed = var3_37 * var0_37.baseVelocity
			var0_37.speedZ = (math.random() - 0.5) * 0.5
			var0_37.targetZ = var1_0.z

			if arg0_36.aircraftList then
				table.insert(arg0_36.aircraftList, var0_37)
			end
		end

		local var5_37 = var1_37.model_ID

		if arg0_36.equipSkinId > 0 then
			local var6_37 = pg.equip_skin_template[arg0_36.equipSkinId]

			if table.contains(var6_37.equip_type, EquipType.AirProtoEquipTypes[var1_37.type]) then
				var5_37 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0_36.equipSkinId)
			end
		end

		ys.Battle.BattleResourceManager.GetInstance():InstAirCharacter(var5_37, function(arg0_39)
			var4_37(arg0_39)
		end)
	end

	local function var1_36()
		return
	end

	local var2_36 = "BattleBulletEmitter"

	return (ys.Battle[var2_36].New(var0_36, var1_36, arg1_36))
end

function var0_0.AddSelfDestroyBullet(arg0_41, arg1_41, arg2_41)
	if not arg0_41.displayHitFX then
		return
	end

	table.insert(arg0_41.UpdateHandlers, function(arg0_42)
		local var0_42 = table.indexof(arg0_41.bulletList, arg1_41)

		if not var0_42 then
			arg0_42()

			return
		end

		if arg1_41:GetBulletData():GetCurrentDistance() < arg2_41 then
			return
		end

		arg0_41:RemoveBullet(var0_42, true)
		arg0_42()
	end)
end

function var0_0.RemoveBullet(arg0_43, arg1_43, arg2_43)
	local var0_43 = arg0_43.bulletList[arg1_43]

	Object.Destroy(var0_43._go)
	table.remove(arg0_43.bulletList, arg1_43)

	if arg2_43 then
		local var1_43 = var0_43:GetMissFXID()

		if arg0_43.equipSkinId > 0 then
			local var2_43 = pg.equip_skin_template[arg0_43.equipSkinId]

			if var2_43.hit_fx_name ~= "" then
				var1_43 = var2_43.hit_fx_name
			end
		end

		if var1_43 and var1_43 ~= "" then
			local var3_43, var4_43 = arg0_43.seaFXPool:GetFX(var1_43)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var3_43, var0_43:GetPosition() + var4_43, true)
		end
	end
end

function var0_0.SeaUpdate(arg0_44)
	local var0_44 = 0
	local var1_44 = -20
	local var2_44 = 60
	local var3_44 = 0
	local var4_44 = 60
	local var5_44 = ys.Battle.BattleConfig
	local var6_44 = ys.Battle.BattleConst

	local function var7_44()
		for iter0_45 = #arg0_44.bulletList, 1, -1 do
			local var0_45 = arg0_44.bulletList[iter0_45]
			local var1_45 = var0_45._bulletData:GetSpeed()()
			local var2_45 = var0_45:GetPosition()

			if var2_45.x > var2_44 and var1_45.x > 0 or var2_45.z < var3_44 and var1_45.z < 0 then
				arg0_44:RemoveBullet(iter0_45, false)
			elseif var2_45.x < var1_44 and var1_45.x < 0 and var0_45:GetType() ~= var6_44.BulletType.BOMB then
				arg0_44:RemoveBullet(iter0_45, false)
			else
				local var3_45 = pg.TimeMgr.GetInstance():GetCombatTime()

				var0_45._bulletData:Update(var3_45)
				var0_45:Update(var0_44)

				if var2_45.z > var4_44 and var1_45.z > 0 or var0_45._bulletData:IsOutRange(var0_44) then
					arg0_44:RemoveBullet(iter0_45, true)
				end
			end
		end

		for iter1_45, iter2_45 in ipairs(arg0_44.aircraftList) do
			local var4_45 = iter2_45.pos + iter2_45.speed

			if var4_45.y < var5_44.AircraftHeight + 5 then
				iter2_45.speed.y = math.max(0.4, 1 - var4_45.y / var5_44.AircraftHeight)

				local var5_45 = math.min(1, var4_45.y / var5_44.AircraftHeight)

				iter2_45.tf.localScale = Vector3(var5_45, var5_45, var5_45)
			end

			iter2_45.speed.z = iter2_45.baseVelocity * iter2_45.speedZ

			local var6_45 = iter2_45.targetZ - var4_45.z

			if var6_45 > iter2_45.baseVelocity then
				iter2_45.speed.z = iter2_45.baseVelocity * 0.5
			elseif var6_45 < -iter2_45.baseVelocity then
				iter2_45.speed.z = -iter2_45.baseVelocity * 0.5
			else
				iter2_45.targetZ = var1_0.z + var1_0.z * (math.random() - 0.5) * 0.6
			end

			if var4_45.x > var2_44 or var4_45.x < var1_44 then
				Object.Destroy(iter2_45.obj)
				table.remove(arg0_44.aircraftList, iter1_45)
			else
				iter2_45.tf.localPosition = var4_45
				iter2_45.pos = var4_45
			end
		end

		for iter3_45 = #arg0_44.UpdateHandlers, 1, -1 do
			local var7_45 = arg0_44.UpdateHandlers[iter3_45]

			local function var8_45()
				table.remove(arg0_44.UpdateHandlers, iter3_45)
			end

			var7_45(var8_45)
		end

		var0_44 = var0_44 + 1
	end

	pg.TimeMgr.GetInstance():AddBattleTimer("barrageUpdateTimer", -1, 0.033, var7_44)
end

function var0_0.GetFXOffsets(arg0_47, arg1_47)
	arg1_47 = arg1_47 or 1

	return arg0_47._FXOffset[arg1_47]
end

function var0_0.GetAttachPoint(arg0_48)
	return arg0_48._FXAttachPoint
end

function var0_0.GetGO(arg0_49)
	return arg0_49.seaCharacter
end

function var0_0.GetSpecificFXScale(arg0_50)
	return {}
end

function var0_0.clear(arg0_51)
	pg.TimeMgr.GetInstance():RemoveAllBattleTimer()

	arg0_51._emitterHost = nil

	if arg0_51.seaCharacter then
		Destroy(arg0_51.seaCharacter)

		arg0_51.seaCharacter = nil
	end

	if arg0_51.aircraftList then
		for iter0_51, iter1_51 in ipairs(arg0_51.aircraftList) do
			Destroy(iter1_51.obj)
		end

		arg0_51.aircraftList = nil
	end

	if arg0_51.seaView then
		arg0_51.seaView:Dispose()

		arg0_51.seaView = nil
	end

	if arg0_51.weaponList then
		for iter2_51, iter3_51 in ipairs(arg0_51.weaponList) do
			for iter4_51, iter5_51 in ipairs(iter3_51.emitterList) do
				iter5_51:Destroy()
			end
		end

		arg0_51.weaponList = nil
	end

	if arg0_51.bulletList then
		for iter6_51, iter7_51 in ipairs(arg0_51.bulletList) do
			Destroy(iter7_51._go)
		end

		arg0_51.bulletList = nil
	end

	if arg0_51.orbitList then
		for iter8_51, iter9_51 in ipairs(arg0_51.orbitList) do
			Destroy(iter9_51)
		end

		arg0_51.orbitList = nil
	end

	if arg0_51.seaFXPool then
		arg0_51.seaFXPool:Clear()

		arg0_51.seaFXPool = nil
	end

	if arg0_51.seaFXContainersPool then
		arg0_51.seaFXContainersPool:Clear()

		arg0_51.seaFXContainersPool = nil
	end

	ys.Battle.BattleResourceManager.GetInstance():Clear()

	arg0_51.seaCamera.enabled = false
	arg0_51.seaCameraGO = nil
	arg0_51.seaCamera = nil
	arg0_51.loading = false
	arg0_51.loaded = false

	if arg0_51.palyAnimTimer then
		arg0_51.palyAnimTimer:Stop()

		arg0_51.palyAnimTimer = nil
	end
end

return var0_0
