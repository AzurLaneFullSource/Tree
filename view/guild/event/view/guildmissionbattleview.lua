local var0 = class("GuildMissionBattleView")
local var1 = Vector3(40, -3, 40)
local var2 = 10
local var3 = 1028
local var4 = Vector3(80, -3, 40)

local function var5(arg0)
	local var0 = {}
	local var1 = {}

	for iter0, iter1 in ipairs(ys.Battle.BattleConst.FXContainerIndex) do
		local var2 = arg0[iter0]

		var1[iter0] = Vector3(var2[1], var2[2], var2[3])
	end

	var0._FXOffset = var1
	var0._FXAttachPoint = GameObject()

	function var0.GetFXOffsets(arg0, arg1)
		arg1 = arg1 or 1

		return arg0._FXOffset[arg1]
	end

	function var0.GetAttachPoint(arg0)
		return arg0._FXAttachPoint
	end

	function var0.GetGO(arg0)
		return arg0._go
	end

	function var0.SetGo(arg0, arg1)
		assert(arg1)

		arg0._go = arg1

		local var0 = arg0._FXAttachPoint.transform

		var0:SetParent(arg1.transform, false)

		var0.localPosition = Vector3.zero
		var0.localEulerAngles = Vector3(330, 0, 0)
	end

	function var0.GetSpecificFXScale(arg0)
		return {}
	end

	return var0
end

function var0.Ctor(arg0, arg1)
	arg0.rawImage = arg1

	setActive(arg0.rawImage, false)

	arg0.seaCameraGO = GameObject.Find("BarrageCamera")
	arg0.seaCameraGO.tag = "MainCamera"
	arg0.seaCamera = arg0.seaCameraGO:GetComponent(typeof(Camera))
	arg0.seaCamera.targetTexture = arg0.rawImage.texture
	arg0.seaCamera.enabled = true
	arg0.mainCameraGO = pg.UIMgr.GetInstance():GetMainCamera()
end

function var0.configUI(arg0, arg1, arg2)
	arg0.nameTF = arg2
	arg0.healTF = arg1

	setActive(arg0.healTF, false)
	arg0.healTF:GetComponent("DftAniEvent"):SetEndEvent(function()
		setActive(arg0.healTF, false)
		setText(arg0.healTF:Find("text"), "")
	end)
end

function var0.load(arg0, arg1, arg2)
	ys.Battle.BattleVariable.Init()

	local var0 = ys.Battle.BattleResourceManager.GetInstance()

	var0:Init()
	var0:AddPreloadResource(var0.GetMapResource(arg1))

	local function var1()
		pg.UIMgr.GetInstance():LoadingOff()

		arg0.seaView = ys.Battle.BattleMap.New(arg1)

		setActive(arg0.rawImage, true)

		GameObject.Find("scenes").transform.position = Vector3(0, -26, 0)

		var0:Clear()

		if arg2 then
			onNextTick(arg2)
		end
	end

	var0:StartPreload(var1, nil)
	pg.UIMgr.GetInstance():LoadingOn()
end

function var0.LoadShip(arg0, arg1, arg2, arg3, arg4)
	if not arg1 then
		arg4()

		return
	end

	if arg0.shipVO then
		arg4()

		return
	end

	arg0.unitList = {}
	arg0.bulletUnitList = {}
	arg0.shipVO = arg1
	arg0.equipSkinId = 0
	arg0.weaponIds = arg2

	ys.Battle.BattleFXPool.GetInstance():Init()

	arg0._cldSystem = ys.Battle.BattleCldSystem.New(arg0)

	local var0 = ys.Battle.BattleResourceManager.GetInstance()

	var0:Init()
	var0:AddPreloadResource(var0.GetDisplayCommonResource())

	if arg0.equipSkinId > 0 then
		var0:AddPreloadResource(var0.GetEquipSkinPreviewRes(arg0.equipSkinId))
	end

	local var1 = pg.enemy_data_statistics[var2]

	var0:AddPreloadResource(var0.GetCharacterPath(var1.prefab), false)

	local var2 = pg.enemy_data_statistics[var3]

	var0:AddPreloadResource(var0.GetCharacterPath(var2.prefab), false)
	var0:AddPreloadResource(var0.GetShipResource(arg1.configId, arg1.skinId), false)

	if arg1:getShipType() ~= ShipType.WeiXiu then
		for iter0, iter1 in ipairs(arg2) do
			if iter1 ~= 0 then
				local var3 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter1).weapon_id

				for iter2, iter3 in ipairs(var3) do
					var0:AddPreloadResource(var0.GetWeaponResource(iter3))
				end
			end
		end
	end

	local function var4()
		local function var0(arg0)
			arg0.seaCharacter = arg0

			local var0 = arg1:getConfig("scale") / 50

			arg0.transform.localScale = Vector3(var0 - 0.4, var0, var0)
			arg0.transform.localPosition = arg0:GetCharacterOffset()
			arg0.transform.localEulerAngles = Vector3(30, 0, 0)
			arg0.seaAnimator = arg0.transform:GetComponent("SpineAnim")
			arg0.characterAction = ys.Battle.BattleConst.ActionName.MOVE

			arg0.seaAnimator:SetAction(arg0.characterAction, 0, true)

			local var1 = cloneTplTo(arg0.nameTF, arg0)

			var1.localPosition = Vector3(0, -0.35, -1)

			setText(var1:Find("Text"), arg3)

			local var2 = pg.ship_skin_template[arg1.skinId]
			local var3 = var5(var2.fx_container)

			var3:SetGo(arg0)

			local var4 = ys.Battle.BattleFXPool.GetInstance()
			local var5 = var4:GetCharacterFX("movewave", var3)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var5, Vector3(0, 0, 0), true)

			arg0.seaFXPool = var4

			if arg1:getShipType() ~= ShipType.WeiXiu then
				arg0.boneList = {}

				local var6 = pg.ship_skin_template[arg1.skinId]

				for iter0, iter1 in pairs(var6.bound_bone) do
					local var7 = {}

					for iter2, iter3 in ipairs(iter1) do
						if type(iter3) == "table" then
							var7[#var7 + 1] = Vector3(iter3[1], iter3[2], iter3[3])
						else
							var7[#var7 + 1] = Vector3.zero
						end
					end

					arg0.boneList[iter0] = var7[1]
				end
			end

			LeanTween.value(arg0, -20, 0, 2):setOnUpdate(System.Action_float(function(arg0)
				arg0.transform.position = Vector3(arg0, arg0.transform.position.y, arg0.transform.position.z)
			end))
		end

		seriesAsync({
			function(arg0)
				var0:InstCharacter(arg1:getPrefab(), function(arg0)
					var0(arg0)
					arg0()
				end)
			end,
			function(arg0)
				arg0:CreateMonster(arg0)
			end,
			function(arg0)
				arg0:CreateItemBox(arg0)
			end
		}, function()
			arg0.loaded = true

			pg.TimeMgr.GetInstance():ResumeBattleTimer()

			if arg1:getShipType() ~= ShipType.WeiXiu then
				arg0:onWeaponUpdate()
				arg0:SeaUpdate()
			end

			if arg4 then
				arg4()
			end
		end)
	end

	var0:StartPreload(var4, nil)
end

function var0.StartMoveOtherShips(arg0, arg1)
	local function var0(arg0, arg1)
		local var0 = arg0.transform.localPosition
		local var1 = math.random(5, 8)
		local var2 = math.random(0, 5)

		LeanTween.value(arg0, var0.x, 80, var1):setOnUpdate(System.Action_float(function(arg0)
			arg0.transform.localPosition = Vector3(arg0, var0.y, var0.z)
		end)):setOnComplete(System.Action(arg1)):setDelay(var2)
	end

	local var1 = {}

	for iter0, iter1 in ipairs(arg0.otherShipGos) do
		table.insert(var1, function(arg0)
			var0(iter1, arg0)
		end)
	end

	parallelAsync(var1, arg1)
end

function var0.PlayOtherShipAnim(arg0, arg1, arg2)
	if not arg0.loaded then
		return
	end

	arg0.otherShipGos = {}

	local var0 = ys.Battle.BattleResourceManager.GetInstance()

	var0:Init()
	var0:AddPreloadResource(var0.GetDisplayCommonResource())

	local function var1(arg0, arg1, arg2)
		local var0 = pg.ship_data_statistics[arg0.id].scale / 50

		arg2.transform.localScale = Vector3(var0 - 0.4, var0, var0)
		arg2.transform.localPosition = Vector3(-20, 0, arg1)
		arg2.transform.localEulerAngles = Vector3(30, 0, 0)

		arg2.transform:GetComponent("SpineAnim"):SetAction(ys.Battle.BattleConst.ActionName.MOVE, 0, true)

		local var1 = cloneTplTo(arg0.nameTF, arg2)

		var1.localPosition = Vector3(0, -0.35, -1)

		setText(var1:Find("Text"), arg0.name)

		local var2 = pg.ship_skin_template[arg0.skin]
		local var3 = var5(var2.fx_container)

		var3:SetGo(arg2)

		local var4 = ys.Battle.BattleFXPool.GetInstance():GetCharacterFX("movewave", var3)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var4, Vector3(0, 0, 0), true)
		table.insert(arg0.otherShipGos, arg2)
	end

	local var2 = {}
	local var3 = {
		math.random(43, 48),
		math.random(49, 53)
	}

	for iter0, iter1 in ipairs(arg1) do
		var0:AddPreloadResource(var0.GetShipResource(iter1.id, iter1.skin), false)
		table.insert(var2, function(arg0)
			local var0 = pg.ship_skin_template[iter1.skin]

			assert(var0, iter1.skin)
			var0:InstCharacter(var0.prefab, function(arg0)
				var1(iter1, var3[iter0], arg0)
				arg0()
			end)
		end)
	end

	local function var4()
		for iter0, iter1 in ipairs(arg0.otherShipGos) do
			Destroy(iter1)
		end

		arg0.otherShipGos = nil

		arg2()
	end

	local function var5()
		seriesAsync(var2, function()
			arg0:StartMoveOtherShips(var4)
		end)
	end

	var0:StartPreload(var5, nil)
end

function var0.PlayAttackAnim(arg0)
	arg0.isFinish = nil

	local function var0()
		if not arg0.animTimer then
			return
		end

		arg0.animTimer:Stop()

		arg0.animTimer = nil
	end

	local var1 = function(arg0)
		var0()
		arg0.seaEmenyAnimator:SetAction("move", 0, true)

		local var0

		var0.localPosition, var0 = var1 + Vector3(40, 0, 0), arg0.seaEmeny.transform

		setActive(arg0.seaEmeny, true)

		arg0.animTimer = Timer.New(function()
			var0.localPosition = Vector3.Lerp(var0.localPosition, var1, Time.deltaTime * 3)

			if Vector3.Distance(var1, var0.localPosition) <= 1 then
				arg0()
			end
		end, 0.033, -1)

		arg0.animTimer:Start()
	end

	local function var2(arg0)
		var0()

		if arg0.shipVO:getShipType() ~= ShipType.WeiXiu then
			arg0:SeaFire()
		end

		arg0.animTimer = Timer.New(arg0, 3, 1)

		arg0.animTimer:Start()
	end

	local function var3(arg0)
		var0()

		if not arg0.isFinish then
			arg0:HandleBulletHit(nil, arg0.unitList[1])
		end

		arg0.seaAnimator:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				arg0.seaAnimator:SetAction("move", 0, true)
				arg0.seaAnimator:SetActionCallBack(nil)
				arg0()
			end
		end)
		arg0.seaAnimator:SetAction("victory", 0, true)
	end

	seriesAsync({
		var1,
		var2,
		var3
	})
end

function var0.PlayItemAnim(arg0)
	local function var0()
		if not arg0.animTimer then
			return
		end

		arg0.animTimer:Stop()

		arg0.animTimer = nil
	end

	var0()

	local var1 = function(arg0)
		arg0.seaItemBoxAnimator:SetAction("move", 0, true)
		setActive(arg0.seaItemBox, true)

		local var0 = arg0.seaItemBox.transform

		var0.localPosition = var4
		arg0.animTimer = Timer.New(function()
			var0.localPosition = Vector3.Lerp(var0.localPosition, var1, Time.deltaTime * 3)

			if Vector3.Distance(var1, var0.localPosition) <= 1 then
				arg0()
			end
		end, 0.033, -1)

		arg0.animTimer:Start()
	end

	local function var2(arg0)
		var0()
		arg0.seaAnimator:SetActionCallBack(function(arg0)
			if arg0 == "finish" then
				arg0.seaAnimator:SetAction("move", 0, true)
				arg0.seaAnimator:SetActionCallBack(nil)
				arg0()
			end
		end)
		arg0.seaAnimator:SetAction("victory", 0, true)
	end

	seriesAsync({
		var1,
		var2
	})
end

function var0.CreateMonster(arg0, arg1)
	local var0 = 1
	local var1 = ys.Battle.BattleDataFunction.CreateBattleUnitData(var0, ys.Battle.BattleConst.UnitType.ENEMY_UNIT, -1, var2, nil, {}, nil, nil, false, 1, 1, nil, nil, 1)

	var1:SetPosition(var1)
	var1:ActiveCldBox()
	arg0._cldSystem:InitShipCld(var1)

	local var2 = var5(var1:GetTemplate().fx_container)

	ys.Battle.BattleResourceManager.GetInstance():InstCharacter(var1:GetTemplate().prefab, function(arg0)
		var2:SetGo(arg0)

		local var0 = var1:GetTemplate().scale / 50

		arg0.transform.localScale = Vector3(var0, var0, var0)
		arg0.transform.localPosition = var1
		arg0.transform.localEulerAngles = Vector3(30, 0, 0)

		local var1 = var1:GetTemplate().wave_fx
		local var2 = ys.Battle.BattleFXPool.GetInstance():GetCharacterFX(var1, var2)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var2, Vector3(0, 0, 0), true)

		arg0.seaEmeny = arg0
		arg0.seaEmenyAnimator = arg0.transform:GetComponent("SpineAnim")

		setActive(arg0, false)
		arg1()
	end)

	arg0.unitList[var0] = var1
end

function var0.CreateItemBox(arg0, arg1)
	local var0 = pg.enemy_data_statistics[var3]

	ys.Battle.BattleResourceManager.GetInstance():InstCharacter(var0.prefab, function(arg0)
		local var0 = var0.scale / 50

		arg0.transform.localScale = Vector3(var0, var0, var0)
		arg0.transform.localPosition = var4
		arg0.transform.localEulerAngles = Vector3(30, 0, 0)
		arg0.seaItemBox = arg0
		arg0.seaItemBoxAnimator = arg0.transform:GetComponent("SpineAnim")

		setActive(arg0, false)
		arg1()
	end)
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
	local var1

	local function var2()
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

			if var0.tmpData.type == ys.Battle.BattleConst.EquipmentType.PREVIEW_ARICRAFT then
				arg0.timer = Timer.New(var2, 1.5, 1)

				arg0.timer:Start()
			end
		elseif arg0.characterAction ~= ys.Battle.BattleConst.ActionName.MOVE then
			arg0.characterAction = ys.Battle.BattleConst.ActionName.MOVE

			arg0.seaAnimator:SetAction(arg0.characterAction, 0, true)

			var0 = 1
		end
	end

	var2()
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

function var0.createEmitterCannon(arg0, arg1, arg2, arg3)
	local function var0(arg0, arg1, arg2, arg3, arg4)
		local var0 = ys.Battle.BattlePlayerUnit.New(1, ys.Battle.BattleConfig.FRIENDLY_CODE)
		local var1 = {
			speed = 0
		}

		var0:SetSkinId(arg0.shipVO.skinId)
		var0:SetTemplate(arg0.shipVO.configId, var1)

		local var2
		local var3 = arg0:GetCharacterOffset()
		local var4, var5 = ys.Battle.BattleDataFunction.CreateBattleBulletData(arg2, arg2, var0, var2, var3 + Vector3(40, 0, 0))

		if var5 then
			arg0._cldSystem:InitBulletCld(var4)
		end

		var4:SetOffsetPriority(arg3)
		var4:SetShiftInfo(arg0, arg1)
		var4:SetRotateInfo(nil, 0, arg2)

		if arg0.equipSkinId > 0 then
			local var6 = pg.equip_skin_template[arg0.equipSkinId]
			local var7, var8, var9, var10 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0.equipSkinId)
			local var11 = var4:GetType()
			local var12 = ys.Battle.BattleConst.BulletType
			local var13

			if var11 == var12.CANNON or var11 == var12.BOMB then
				local var14 = {
					EquipType.CannonQuZhu,
					EquipType.CannonQingXun,
					EquipType.CannonZhongXun,
					EquipType.CannonZhanlie,
					EquipType.CannonZhongXun2
				}

				if _.any(var14, function(arg0)
					return table.contains(var6.equip_type, arg0)
				end) then
					var4:SetModleID(var7)
				elseif var8 and #var8 > 0 then
					var4:SetModleID(var8)
				elseif var10 and #var10 > 0 then
					var4:SetModleID(var10)
				end
			elseif var11 == var12.TORPEDO then
				if table.contains(var6.equip_type, EquipType.Torpedo) then
					var4:SetModleID(var7)
				elseif var9 and #var9 > 0 then
					var4:SetModleID(var9)
				end
			end
		end

		local var15 = var4:GetType()
		local var16 = ys.Battle.BattleConst.BulletType
		local var17

		if var15 == var16.CANNON then
			var17 = ys.Battle.BattleCannonBullet.New()
		elseif var15 == var16.BOMB then
			var17 = ys.Battle.BattleBombBullet.New()
		elseif var15 == var16.TORPEDO then
			var17 = ys.Battle.BattleTorpedoBullet.New()
		else
			var17 = ys.Battle.BattleBullet.New()
		end

		var17:SetBulletData(var4)
		table.insert(arg0.bulletUnitList, var4)

		local function var18(arg0)
			var17:SetGO(arg0)
			var17:AddRotateScript()

			if tf(arg0).parent then
				tf(arg0).parent = nil
			end

			local var0 = arg0.boneList[arg3] or Vector3.zero
			local var1 = arg0:GetCharacterOffset()

			var17:SetSpawn(var1 + var0)

			if arg0.bulletList then
				table.insert(arg0.bulletList, var17)
			end
		end

		ys.Battle.BattleResourceManager.GetInstance():InstBullet(var17:GetModleID(), function(arg0)
			var18(arg0)
		end)
	end

	local function var1()
		return
	end

	local var2 = "BattleBulletEmitter"

	return (ys.Battle[var2].New(var0, var1, arg1))
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

		local function var4(arg0)
			local var0 = arg0:GetCharacterOffset()
			local var1 = var0 + Vector3(var1.position_offset[1] + arg0, var1.position_offset[2], var1.position_offset[3] + arg1)

			arg0.transform.localPosition = var1
			arg0.transform.localScale = Vector3(0.1, 0.1, 0.1)
			var0.obj = arg0
			var0.tf = arg0.transform
			var0.pos = var1
			var0.baseVelocity = ys.Battle.BattleFormulas.ConvertAircraftSpeed(var0.tmpData.speed)
			var0.speed = var3 * var0.baseVelocity
			var0.speedZ = (math.random() - 0.5) * 0.5
			var0.targetZ = var0.z

			if arg0.aircraftList then
				table.insert(arg0.aircraftList, var0)
			end
		end

		local var5 = var1.model_ID

		if arg0.equipSkinId > 0 then
			local var6 = pg.equip_skin_template[arg0.equipSkinId]
			local var7 = {
				EquipType.FighterAircraft,
				EquipType.TorpedoAircraft,
				EquipType.BomberAircraft
			}

			if table.contains(var6.equip_type, var7[var1.type]) then
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

function var0.RemoveBullet(arg0, arg1, arg2)
	table.remove(arg0.bulletUnitList, arg1)

	local var0 = arg0.bulletList[arg1]

	Object.Destroy(var0._go)
	table.remove(arg0.bulletList, arg1)

	if arg2 then
		local var1 = var0:GetMissFXID()

		if var1 and var1 ~= "" then
			local var2, var3 = arg0.seaFXPool:GetFX(var1)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var2, var0:GetPosition() + var3, true)
		end
	end
end

function var0.SeaUpdate(arg0)
	if not arg0.bulletList then
		return
	end

	local var0 = 0
	local var1 = -20
	local var2 = 60
	local var3 = 0
	local var4 = 60
	local var5 = ys.Battle.BattleConfig
	local var6 = ys.Battle.BattleConst

	local function var7()
		for iter0 = #arg0.bulletUnitList, 1, -1 do
			local var0 = arg0.bulletUnitList[iter0]

			arg0._cldSystem:UpdateBulletCld(var0)
		end

		for iter1 = #arg0.bulletList, 1, -1 do
			local var1 = arg0.bulletList[iter1]
			local var2 = var1._bulletData:GetSpeed()()
			local var3 = var1:GetPosition()

			if var3.x > var2 and var2.x > 0 or var3.z < var3 and var2.z < 0 then
				arg0:RemoveBullet(iter1, false)
			elseif var3.x < var1 and var2.x < 0 and var1:GetType() ~= var6.BulletType.BOMB then
				arg0:RemoveBullet(iter1, false)
			else
				local var4 = pg.TimeMgr.GetInstance():GetCombatTime()

				var1._bulletData:Update(var4)
				var1:Update(var0)

				if var3.z > var4 and var2.z > 0 or var1._bulletData:IsOutRange(var0) then
					arg0:RemoveBullet(iter1, true)
				end
			end
		end

		for iter2, iter3 in ipairs(arg0.aircraftList) do
			local var5 = iter3.pos + iter3.speed

			if var5.y < var5.AircraftHeight + 5 then
				iter3.speed.y = math.max(0.4, 1 - var5.y / var5.AircraftHeight)

				local var6 = math.min(1, var5.y / var5.AircraftHeight)

				iter3.tf.localScale = Vector3(var6, var6, var6)
			end

			iter3.speed.z = iter3.baseVelocity * iter3.speedZ

			local var7 = iter3.targetZ - var5.z

			if var7 > iter3.baseVelocity then
				iter3.speed.z = iter3.baseVelocity * 0.5
			elseif var7 < -iter3.baseVelocity then
				iter3.speed.z = -iter3.baseVelocity * 0.5
			else
				local var8 = arg0:GetCharacterOffset()

				iter3.targetZ = var8.z + var8.z * (math.random() - 0.5) * 0.6
			end

			if var5.x > var2 or var5.x < var1 then
				Object.Destroy(iter3.obj)
				table.remove(arg0.aircraftList, iter2)
			else
				iter3.tf.localPosition = var5
				iter3.pos = var5
			end
		end

		var0 = var0 + 1
	end

	pg.TimeMgr.GetInstance():AddBattleTimer("barrageUpdateTimer", -1, 0.033, var7)
end

function var0.GetCharacterOffset(arg0)
	return Vector3(0, -3, 40)
end

function var0.GetTotalBounds(arg0)
	local var0 = {
		-70,
		20,
		90,
		70
	}
	local var1 = var0[1]
	local var2 = var0[1] + var0[3]
	local var3 = var0[2] + var0[4]
	local var4 = var0[2]

	return var3, var4, var1, var2
end

function var0.HandleShipCrashDecelerate(arg0)
	return
end

function var0.HandleShipCrashDecelerate(arg0)
	return
end

function var0.HandleShipCrashDamageList(arg0)
	return
end

function var0.HandleBulletHit(arg0, arg1, arg2)
	for iter0 = #arg0.bulletUnitList, 1, -1 do
		if arg0.bulletUnitList[iter0] == arg1 then
			arg0:RemoveBullet(iter0, true)
		end
	end

	if not arg0.isFinish then
		arg0.isFinish = true

		setActive(arg0.seaEmeny, false)

		local var0, var1 = ys.Battle.BattleFXPool.GetInstance():GetFX("Bomb")

		pg.EffectMgr.GetInstance():PlayBattleEffect(var0, var1:Add(arg2:GetPosition()), true)
	end
end

function var0.HandleWallHitByBullet(arg0)
	return
end

function var0.GetUnitList(arg0)
	return arg0.unitList
end

function var0.GetAircraftList(arg0)
	return {}
end

function var0.GetBulletList(arg0)
	return arg0.bulletUnitList
end

function var0.GetAOEList(arg0)
	return {}
end

function var0.GetFriendlyCode(arg0)
	return 1
end

function var0.GetFoeCode(arg0)
	return -1
end

function var0.clear(arg0)
	if arg0.animTimer then
		arg0.animTimer:Stop()

		arg0.animTimer = nil
	end

	if arg0._cldSystem then
		arg0._cldSystem:Dispose()
	end

	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end

	pg.TimeMgr.GetInstance():RemoveAllBattleTimer()

	if arg0.seaCharacter then
		Destroy(arg0.seaCharacter)

		arg0.seaCharacter = nil
	end

	if arg0.otherShipGos then
		for iter0, iter1 in ipairs(arg0.otherShipGos) do
			Destroy(iter1)
		end

		arg0.otherShipGos = nil
	end

	if arg0.aircraftList then
		for iter2, iter3 in ipairs(arg0.aircraftList) do
			Destroy(iter3.obj)
		end

		arg0.aircraftList = nil
	end

	if arg0.seaView then
		arg0.seaView:Dispose()

		arg0.seaView = nil
	end

	if arg0.weaponList then
		for iter4, iter5 in ipairs(arg0.weaponList) do
			for iter6, iter7 in ipairs(iter5.emitterList) do
				iter7:Destroy()
			end
		end

		arg0.weaponList = nil
	end

	if arg0.bulletList then
		for iter8, iter9 in ipairs(arg0.bulletList) do
			Destroy(iter9._go)
		end

		arg0.bulletList = nil
	end

	if arg0.seaFXPool then
		arg0.seaFXPool:Clear()

		arg0.seaFXPool = nil
	end

	if arg0.seaEmeny then
		Destroy(arg0.seaEmeny)

		arg0.seaEmeny = nil
	end

	if arg0.seaItemBox then
		Destroy(arg0.seaItemBox)

		arg0.seaItemBox = nil
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
	arg0.loaded = false

	if arg0.palyAnimTimer then
		arg0.palyAnimTimer:Stop()

		arg0.palyAnimTimer = nil
	end
end

return var0
