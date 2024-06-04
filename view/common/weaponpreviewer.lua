local var0 = class("WeaponPreviewer")
local var1 = Vector3(0, 1, 40)
local var2 = Vector3(40, 1, 40)
local var3 = Vector3(30, 0, 0)
local var4 = Vector3(0.1, 0.1, 0.1)
local var5 = Vector3(330, 0, 0)

function var0.Ctor(arg0, arg1)
	arg0.rawImage = arg1

	setActive(arg0.rawImage, false)

	arg0.seaCameraGO = GameObject.Find("BarrageCamera")
	arg0.seaCameraGO.tag = "MainCamera"
	arg0.seaCamera = arg0.seaCameraGO:GetComponent(typeof(Camera))
	arg0.seaCamera.targetTexture = arg0.rawImage.texture
	arg0.seaCamera.enabled = true
	arg0.mainCameraGO = pg.UIMgr.GetInstance():GetMainCamera()
	arg0.displayFireFX = true
	arg0.displayHitFX = false
end

function var0.configUI(arg0, arg1)
	arg0.healTF = arg1

	setActive(arg0.healTF, false)
	arg0.healTF:GetComponent("DftAniEvent"):SetEndEvent(function()
		setActive(arg0.healTF, false)
		setText(arg0.healTF:Find("text"), "")
	end)
end

function var0.setDisplayWeapon(arg0, arg1, arg2, arg3)
	arg0.weaponIds = arg1
	arg0.equipSkinId = arg2 or 0

	arg0:onWeaponUpdate()
end

function var0.SetFXMode(arg0, arg1, arg2)
	arg0.displayFireFX = arg1
	arg0.displayHitFX = arg2
end

function var0.load(arg0, arg1, arg2, arg3, arg4)
	assert(not arg0.loading and not arg0.loaded, "load function can be called only once.")

	arg0.loading = true
	arg0.shipVO = arg2

	ys.Battle.BattleVariable.Init()
	ys.Battle.BattleFXPool.GetInstance():Init()

	local var0 = ys.Battle.BattleResourceManager.GetInstance()

	var0:Init()
	var0:AddPreloadResource(var0.GetMapResource(arg1))
	var0:AddPreloadResource(var0.GetDisplayCommonResource())

	if arg0.equipSkinId > 0 then
		var0:AddPreloadResource(var0.GetEquipSkinPreviewRes(arg0.equipSkinId))
	end

	var0:AddPreloadResource(var0.GetShipResource(arg2.configId, arg2.skinId), false)

	if arg2:getShipType() ~= ShipType.WeiXiu then
		for iter0, iter1 in ipairs(arg3) do
			if iter1 ~= 0 then
				local var1 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter1).weapon_id

				for iter2, iter3 in ipairs(var1) do
					var0:AddPreloadResource(var0.GetWeaponResource(iter3))
				end
			end
		end
	end

	local function var2()
		arg0.seaView = ys.Battle.BattleMap.New(arg1)

		local function var0(arg0)
			arg0.loading = false
			arg0.loaded = true

			pg.UIMgr.GetInstance():LoadingOff()

			arg0.seaCharacter = arg0

			local var0 = arg2:getConfig("scale") / 50
			local var1 = arg0.transform

			var1.localScale = Vector3(var0, var0, var0)
			var1.localPosition = var1
			var1.localEulerAngles = var3
			arg0.seaAnimator = var1:GetComponent("SpineAnim")
			arg0.characterAction = ys.Battle.BattleConst.ActionName.MOVE

			arg0.seaAnimator:SetAction(arg0.characterAction, 0, true)

			arg0.seaFXList = {}
			arg0._FXAttachPoint = GameObject()

			local var2 = arg0._FXAttachPoint.transform

			var2:SetParent(var1, false)

			var2.localPosition = Vector3.zero
			var2.localEulerAngles = var5

			local var3 = pg.ship_skin_template[arg2.skinId].fx_container
			local var4 = {}

			for iter0, iter1 in ipairs(ys.Battle.BattleConst.FXContainerIndex) do
				local var5 = var3[iter0]

				var4[iter0] = Vector3(var5[1], var5[2], var5[3])
			end

			arg0._FXOffset = var4

			if arg0.equipSkinId > 0 then
				arg0:attachOrbit()
			end

			local var6 = ys.Battle.BattleFXPool.GetInstance()
			local var7 = var6:GetCharacterFX("movewave", arg0)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var7, Vector3.zero, true)

			arg0.seaFXPool = var6

			if arg2:getShipType() ~= ShipType.WeiXiu then
				arg0.boneList = {}

				local var8 = var1.localToWorldMatrix
				local var9 = pg.ship_skin_template[arg2.skinId]

				for iter2, iter3 in pairs(var9.bound_bone) do
					local var10 = {}

					for iter4, iter5 in ipairs(iter3) do
						if type(iter5) == "table" then
							var10[#var10 + 1] = Vector3(iter5[1], iter5[2], iter5[3])
						else
							var10[#var10 + 1] = Vector3.zero
						end
					end

					arg0.boneList[iter2] = var8:MultiplyPoint3x4(var10[1])
				end

				arg0:SeaUpdate()
			end

			setActive(arg0.rawImage, true)
			arg0.mainCameraGO:SetActive(false)
			pg.TimeMgr.GetInstance():ResumeBattleTimer()
			arg0:onWeaponUpdate()
			arg4()
		end

		var0:InstCharacter(arg2:getPrefab(), function(arg0)
			var0(arg0)
		end)
	end

	var0:StartPreload(var2, nil)
	pg.UIMgr.GetInstance():LoadingOn()
end

function var0.attachOrbit(arg0)
	local var0 = pg.equip_skin_template[arg0.equipSkinId]

	if var0.orbit_combat ~= "" then
		arg0.orbitList = {}

		local var1 = ys.Battle.BattleResourceManager.GetOrbitPath(var0.orbit_combat)

		ResourceMgr.Inst:getAssetAsync(var1, var0.orbit_combat, UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0)
			if arg0.seaCharacter then
				local var0 = Object.Instantiate(arg0)

				table.insert(arg0.orbitList, var0)

				local var1 = var0.orbit_combat_bound[1]
				local var2 = var0.orbit_combat_bound[2]

				var0.transform.localPosition = Vector3(var2[1], var2[2], var2[3])
				SpineAnim.AddFollower(var1, arg0.seaCharacter.transform, var0.transform):GetComponent("Spine.Unity.BoneFollower").followBoneRotation = false
			end
		end), true, true)
	end
end

function var0.playShipAnims(arg0)
	if arg0.loaded and arg0.seaAnimator then
		local var0 = {
			"attack",
			"victory",
			"dead"
		}

		local function var1(arg0)
			if arg0.seaAnimator then
				arg0.seaAnimator:SetActionCallBack(nil)
			end

			arg0.seaAnimator:SetAction(var0[arg0], 0, false)
			arg0.seaAnimator:SetActionCallBack(function(arg0)
				if arg0 == "finish" then
					arg0.seaAnimator:SetActionCallBack(nil)
					arg0.seaAnimator:SetAction("stand", 0, false)
				end
			end)
		end

		if arg0.palyAnimTimer then
			arg0.palyAnimTimer:Stop()

			arg0.palyAnimTimer = nil
		end

		arg0.palyAnimTimer = Timer.New(function()
			var1(math.random(1, #var0))
		end, 5, -1)

		arg0.palyAnimTimer:Start()
		arg0.palyAnimTimer.func()
	end
end

function var0.onWeaponUpdate(arg0)
	if arg0.loaded and arg0.weaponIds then
		if arg0.seaAnimator then
			arg0.seaAnimator:SetActionCallBack(nil)
		end

		local function var0()
			for iter0, iter1 in pairs(arg0.weaponList or {}) do
				for iter2, iter3 in pairs(iter1.emitterList or {}) do
					iter3:Destroy()
				end
			end

			for iter4, iter5 in ipairs(arg0.bulletList or {}) do
				Object.Destroy(iter5._go)
			end

			for iter6, iter7 in pairs(arg0.aircraftList or {}) do
				Object.Destroy(iter7.obj)
			end

			arg0.bulletList = {}
			arg0.aircraftList = {}
			arg0.UpdateHandlers = {}
		end

		if #arg0.weaponIds == 0 and arg0.playRandomAnims then
			if arg0._fireTimer then
				arg0._fireTimer:Stop()
			end

			if arg0._delayTimer then
				arg0._delayTimer:Stop()
			end

			if arg0.shipVO:getShipType() ~= ShipType.WeiXiu then
				var0()
			elseif arg0.buffTimer then
				pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0.buffTimer)

				arg0.buffTimer = nil
			end

			arg0:playShipAnims()
		elseif arg0.shipVO:getShipType() ~= ShipType.WeiXiu then
			var0()
			arg0:MakeWeapon(arg0.weaponIds)
			arg0:SeaFire()
		else
			local var1 = arg0.weaponIds[1]

			if var1 then
				local var2 = Equipment.getConfigData(var1).skill_id[1]

				arg0:MakeBuff(var2)
			end
		end
	end
end

function var0.SeaFire(arg0)
	local var0 = 1

	if arg0._fireTimer then
		arg0._delayTimer:Stop()
		arg0._fireTimer:Stop()
		arg0._fireTimer:Start()
	else
		local function var1()
			local var0 = arg0.weaponList[var0]

			if var0 then
				local function var1()
					local var0 = 1
					local var1 = 0

					for iter0, iter1 in ipairs(var0.emitterList) do
						iter1:Ready()
					end

					for iter2, iter3 in ipairs(var0.emitterList) do
						iter3:Fire(nil, var0, var1)
					end

					local var2 = var0.tmpData.fire_fx

					if arg0.equipSkinId > 0 then
						local var3, var4, var5, var6, var7, var8 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0.equipSkinId)

						if var7 ~= "" then
							var2 = var7
						end
					end

					if var2 and var2 ~= "" and arg0.displayFireFX then
						arg0.seaFXPool:GetCharacterFX(var2, arg0, true, function()
							return
						end)
					end

					var0 = var0 + 1
				end

				if var0.tmpData.action_index ~= "" then
					arg0.characterAction = var0.tmpData.action_index

					arg0.seaAnimator:SetAction(arg0.characterAction, 0, false)
					arg0.seaAnimator:SetActionCallBack(function(arg0)
						if arg0 == "action" then
							var1()
						end
					end)
				else
					var1()
				end
			elseif arg0.characterAction ~= ys.Battle.BattleConst.ActionName.MOVE then
				arg0.characterAction = ys.Battle.BattleConst.ActionName.MOVE

				arg0.seaAnimator:SetAction(arg0.characterAction, 0, true)

				var0 = 1

				arg0._fireTimer:Pause()
				arg0._delayTimer:Start()
			end
		end

		arg0._fireTimer = pg.TimeMgr.GetInstance():AddBattleTimer("barrageFireTimer", -1, 1.5, var1)

		local function var2()
			arg0._delayTimer:Stop()
			arg0._fireTimer:Resume()
		end

		arg0._delayTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", -1, 3, var2, nil, true)
	end
end

function var0.MakeBuff(arg0, arg1)
	local var0 = getSkillConfig(arg1)
	local var1 = var0.effect_list[1].arg_list.skill_id
	local var2 = var0.effect_list[1].arg_list.time
	local var3 = require("GameCfg.skill.skill_" .. var1)

	if arg0.buffTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0.buffTimer)

		arg0.buffTimer = nil
	end

	arg0.buffTimer = pg.TimeMgr.GetInstance():AddBattleTimer("buffTimer", -1, var2, function()
		setActive(arg0.healTF, true)
		setText(arg0.healTF:Find("text"), var3.effect_list[1].arg_list.number)
	end)
end

function var0.MakeWeapon(arg0, arg1)
	arg0.weaponList = {}
	arg0.bulletList = {}
	arg0.aircraftList = {}

	local var0 = 0
	local var1 = ys.Battle.BattleConst

	for iter0, iter1 in ipairs(arg1) do
		local var2 = Equipment.getConfigData(iter1).weapon_id

		for iter2, iter3 in ipairs(var2) do
			if iter3 <= 0 then
				break
			end

			var0 = var0 + 1

			local var3 = ys.Battle.BattleDataFunction.GetWeaponPropertyDataFromID(iter3)

			if var3.type == var1.EquipmentType.MAIN_CANNON or var3.type == var1.EquipmentType.SUB_CANNON or var3.type == var1.EquipmentType.TORPEDO or var3.type == var1.EquipmentType.MANUAL_TORPEDO or var3.type == var1.EquipmentType.POINT_HIT_AND_LOCK then
				if type(var3.barrage_ID) == "table" then
					arg0.weaponList[var0] = {
						tmpData = var3,
						emitterList = {}
					}

					for iter4, iter5 in ipairs(var3.barrage_ID) do
						local var4 = arg0:createEmitterCannon(iter5, var3.bullet_ID[iter4], var3.spawn_bound)

						arg0.weaponList[var0].emitterList[iter4] = var4
					end
				end
			elseif var3.type == var1.EquipmentType.PREVIEW_ARICRAFT and type(var3.barrage_ID) == "table" then
				arg0.weaponList[var0] = {
					tmpData = var3,
					emitterList = {}
				}

				for iter6, iter7 in ipairs(var3.barrage_ID) do
					local var5 = arg0:createEmitterAir(iter7, var3.bullet_ID[iter6], var3.spawn_bound)

					arg0.weaponList[var0].emitterList[iter6] = var5
				end
			end
		end
	end
end

function var0.getEmitterHost(arg0)
	if not arg0._emitterHost then
		arg0._emitterHost = ys.Battle.BattlePlayerUnit.New(1, ys.Battle.BattleConfig.FRIENDLY_CODE)

		local var0 = {
			speed = 0
		}

		arg0._emitterHost:SetSkinId(arg0.shipVO.skinId)
		arg0._emitterHost:SetTemplate(arg0.shipVO.configId, var0)
	end

	return arg0._emitterHost
end

function var0.createEmitterCannon(arg0, arg1, arg2, arg3)
	local var0 = arg0:getEmitterHost()

	local function var1(arg0, arg1, arg2, arg3, arg4)
		local var0
		local var1 = ys.Battle.BattleDataFunction.CreateBattleBulletData(arg2, arg2, var0, var0, var2)

		var1:SetOffsetPriority(arg3)
		var1:SetShiftInfo(arg0, arg1)
		var1:SetRotateInfo(nil, 0, arg2)

		if arg0.equipSkinId > 0 then
			local var2 = pg.equip_skin_template[arg0.equipSkinId]
			local var3, var4, var5, var6, var7, var8 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0.equipSkinId)
			local var9 = var1:GetType()
			local var10 = ys.Battle.BattleConst.BulletType
			local var11

			if var9 == var10.CANNON or var9 == var10.BOMB then
				if _.any(EquipType.CannonEquipTypes, function(arg0)
					return table.contains(var2.equip_type, arg0)
				end) then
					var1:SetModleID(var3)
				elseif var4 and #var4 > 0 then
					var1:SetModleID(var4, nil, var8)
				elseif var6 and #var6 > 0 then
					var1:SetModleID(var6, nil, var8)
				end
			elseif var9 == var10.TORPEDO then
				if table.contains(var2.equip_type, EquipType.Torpedo) then
					var1:SetModleID(var3)
				elseif var5 and #var5 > 0 then
					var1:SetModleID(var5, nil, var8)
				end
			end
		end

		local var12 = var1:GetType()
		local var13 = ys.Battle.BattleConst.BulletType
		local var14

		if var12 == var13.CANNON then
			var14 = ys.Battle.BattleCannonBullet.New()
		elseif var12 == var13.BOMB then
			var14 = ys.Battle.BattleBombBullet.New()
		elseif var12 == var13.TORPEDO then
			var14 = ys.Battle.BattleTorpedoBullet.New()
		else
			var14 = ys.Battle.BattleBullet.New()
		end

		var14:SetBulletData(var1)

		local function var15(arg0)
			var14:SetGO(arg0)
			var14:AddRotateScript()

			local var0 = tf(arg0)

			if var0.parent then
				var0.parent = nil
			end

			local var1 = var0:Find("bullet_random")

			if var1 and var1:GetComponent(typeof(SpineAnim)) then
				local var2 = var1:GetComponent(typeof(SpineAnim))
				local var3 = tostring(math.random(3))

				var2:SetAction(var3, 0, false)
			end

			var14:SetSpawn(arg0.boneList[arg3])

			if arg0.bulletList then
				table.insert(arg0.bulletList, var14)

				if arg0.equipSkinId > 0 then
					local var4 = pg.equip_skin_template[arg0.equipSkinId]
					local var5 = var1:GetType()
					local var6 = ys.Battle.BattleConst.BulletType

					if var5 == var6.CANNON then
						if _.any(EquipType.CannonEquipTypes, function(arg0)
							return table.contains(var4.equip_type, arg0)
						end) and var4.preview_hit_distance > 0 then
							arg0:AddSelfDestroyBullet(var14, var4.preview_hit_distance)
						end
					elseif var5 == var6.TORPEDO and table.contains(var4.equip_type, EquipType.Torpedo) and var4.preview_hit_distance > 0 then
						arg0:AddSelfDestroyBullet(var14, var4.preview_hit_distance)
					end
				end
			end
		end

		ys.Battle.BattleResourceManager.GetInstance():InstBullet(var14:GetModleID(), function(arg0)
			var15(arg0)
		end)
	end

	local function var2()
		return
	end

	local var3 = "BattleBulletEmitter"

	return (ys.Battle[var3].New(var1, var2, arg1))
end

function var0.createEmitterAir(arg0, arg1, arg2, arg3)
	local function var0(arg0, arg1, arg2, arg3, arg4)
		local var0 = {
			id = arg2
		}
		local var1 = pg.aircraft_template[arg2]

		var0.tmpData = var1

		local var2 = math.deg2Rad * arg2
		local var3 = Vector3(math.cos(var2), 0, math.sin(var2))
		local var4 = function(arg0)
			local var0 = var1 + Vector3(var1.position_offset[1] + arg0, var1.position_offset[2], var1.position_offset[3] + arg1)

			arg0.transform.localPosition = var0
			arg0.transform.localScale = var4
			var0.obj = arg0
			var0.tf = arg0.transform
			var0.pos = var0
			var0.baseVelocity = ys.Battle.BattleFormulas.ConvertAircraftSpeed(var0.tmpData.speed)
			var0.speed = var3 * var0.baseVelocity
			var0.speedZ = (math.random() - 0.5) * 0.5
			var0.targetZ = var1.z

			if arg0.aircraftList then
				table.insert(arg0.aircraftList, var0)
			end
		end
		local var5 = var1.model_ID

		if arg0.equipSkinId > 0 then
			local var6 = pg.equip_skin_template[arg0.equipSkinId]

			if table.contains(var6.equip_type, EquipType.AirProtoEquipTypes[var1.type]) then
				var5 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0.equipSkinId)
			end
		end

		ys.Battle.BattleResourceManager.GetInstance():InstAirCharacter(var5, function(arg0)
			var4(arg0)
		end)
	end

	local function var1()
		return
	end

	local var2 = "BattleBulletEmitter"

	return (ys.Battle[var2].New(var0, var1, arg1))
end

function var0.AddSelfDestroyBullet(arg0, arg1, arg2)
	if not arg0.displayHitFX then
		return
	end

	table.insert(arg0.UpdateHandlers, function(arg0)
		local var0 = table.indexof(arg0.bulletList, arg1)

		if not var0 then
			arg0()

			return
		end

		if arg1:GetBulletData():GetCurrentDistance() < arg2 then
			return
		end

		arg0:RemoveBullet(var0, true)
		arg0()
	end)
end

function var0.RemoveBullet(arg0, arg1, arg2)
	local var0 = arg0.bulletList[arg1]

	Object.Destroy(var0._go)
	table.remove(arg0.bulletList, arg1)

	if arg2 then
		local var1 = var0:GetMissFXID()

		if arg0.equipSkinId > 0 then
			local var2 = pg.equip_skin_template[arg0.equipSkinId]

			if var2.hit_fx_name ~= "" then
				var1 = var2.hit_fx_name
			end
		end

		if var1 and var1 ~= "" then
			local var3, var4 = arg0.seaFXPool:GetFX(var1)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var3, var0:GetPosition() + var4, true)
		end
	end
end

function var0.SeaUpdate(arg0)
	local var0 = 0
	local var1 = -20
	local var2 = 60
	local var3 = 0
	local var4 = 60
	local var5 = ys.Battle.BattleConfig
	local var6 = ys.Battle.BattleConst

	local function var7()
		for iter0 = #arg0.bulletList, 1, -1 do
			local var0 = arg0.bulletList[iter0]
			local var1 = var0._bulletData:GetSpeed()()
			local var2 = var0:GetPosition()

			if var2.x > var2 and var1.x > 0 or var2.z < var3 and var1.z < 0 then
				arg0:RemoveBullet(iter0, false)
			elseif var2.x < var1 and var1.x < 0 and var0:GetType() ~= var6.BulletType.BOMB then
				arg0:RemoveBullet(iter0, false)
			else
				local var3 = pg.TimeMgr.GetInstance():GetCombatTime()

				var0._bulletData:Update(var3)
				var0:Update(var0)

				if var2.z > var4 and var1.z > 0 or var0._bulletData:IsOutRange(var0) then
					arg0:RemoveBullet(iter0, true)
				end
			end
		end

		for iter1, iter2 in ipairs(arg0.aircraftList) do
			local var4 = iter2.pos + iter2.speed

			if var4.y < var5.AircraftHeight + 5 then
				iter2.speed.y = math.max(0.4, 1 - var4.y / var5.AircraftHeight)

				local var5 = math.min(1, var4.y / var5.AircraftHeight)

				iter2.tf.localScale = Vector3(var5, var5, var5)
			end

			iter2.speed.z = iter2.baseVelocity * iter2.speedZ

			local var6 = iter2.targetZ - var4.z

			if var6 > iter2.baseVelocity then
				iter2.speed.z = iter2.baseVelocity * 0.5
			elseif var6 < -iter2.baseVelocity then
				iter2.speed.z = -iter2.baseVelocity * 0.5
			else
				iter2.targetZ = var1.z + var1.z * (math.random() - 0.5) * 0.6
			end

			if var4.x > var2 or var4.x < var1 then
				Object.Destroy(iter2.obj)
				table.remove(arg0.aircraftList, iter1)
			else
				iter2.tf.localPosition = var4
				iter2.pos = var4
			end
		end

		for iter3 = #arg0.UpdateHandlers, 1, -1 do
			local var7 = arg0.UpdateHandlers[iter3]

			local function var8()
				table.remove(arg0.UpdateHandlers, iter3)
			end

			var7(var8)
		end

		var0 = var0 + 1
	end

	pg.TimeMgr.GetInstance():AddBattleTimer("barrageUpdateTimer", -1, 0.033, var7)
end

function var0.GetFXOffsets(arg0, arg1)
	arg1 = arg1 or 1

	return arg0._FXOffset[arg1]
end

function var0.GetAttachPoint(arg0)
	return arg0._FXAttachPoint
end

function var0.GetGO(arg0)
	return arg0.seaCharacter
end

function var0.GetSpecificFXScale(arg0)
	return {}
end

function var0.clear(arg0)
	pg.TimeMgr.GetInstance():RemoveAllBattleTimer()

	arg0._emitterHost = nil

	if arg0.seaCharacter then
		Destroy(arg0.seaCharacter)

		arg0.seaCharacter = nil
	end

	if arg0.aircraftList then
		for iter0, iter1 in ipairs(arg0.aircraftList) do
			Destroy(iter1.obj)
		end

		arg0.aircraftList = nil
	end

	if arg0.seaView then
		arg0.seaView:Dispose()

		arg0.seaView = nil
	end

	if arg0.weaponList then
		for iter2, iter3 in ipairs(arg0.weaponList) do
			for iter4, iter5 in ipairs(iter3.emitterList) do
				iter5:Destroy()
			end
		end

		arg0.weaponList = nil
	end

	if arg0.bulletList then
		for iter6, iter7 in ipairs(arg0.bulletList) do
			Destroy(iter7._go)
		end

		arg0.bulletList = nil
	end

	if arg0.orbitList then
		for iter8, iter9 in ipairs(arg0.orbitList) do
			Destroy(iter9)
		end

		arg0.orbitList = nil
	end

	if arg0.seaFXPool then
		arg0.seaFXPool:Clear()

		arg0.seaFXPool = nil
	end

	if arg0.seaFXContainersPool then
		arg0.seaFXContainersPool:Clear()

		arg0.seaFXContainersPool = nil
	end

	ys.Battle.BattleResourceManager.GetInstance():Clear()

	arg0.seaCameraGO.tag = "Untagged"
	arg0.seaCameraGO = nil
	arg0.seaCamera = nil

	arg0.mainCameraGO:SetActive(true)

	arg0.mainCameraGO = nil
	arg0.loading = false
	arg0.loaded = false

	if arg0.palyAnimTimer then
		arg0.palyAnimTimer:Stop()

		arg0.palyAnimTimer = nil
	end
end

return var0
