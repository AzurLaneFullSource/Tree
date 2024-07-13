local var0_0 = class("GuildMissionBattleView")
local var1_0 = Vector3(40, -3, 40)
local var2_0 = 10
local var3_0 = 1028
local var4_0 = Vector3(80, -3, 40)

local function var5_0(arg0_1)
	local var0_1 = {}
	local var1_1 = {}

	for iter0_1, iter1_1 in ipairs(ys.Battle.BattleConst.FXContainerIndex) do
		local var2_1 = arg0_1[iter0_1]

		var1_1[iter0_1] = Vector3(var2_1[1], var2_1[2], var2_1[3])
	end

	var0_1._FXOffset = var1_1
	var0_1._FXAttachPoint = GameObject()

	function var0_1.GetFXOffsets(arg0_2, arg1_2)
		arg1_2 = arg1_2 or 1

		return arg0_2._FXOffset[arg1_2]
	end

	function var0_1.GetAttachPoint(arg0_3)
		return arg0_3._FXAttachPoint
	end

	function var0_1.GetGO(arg0_4)
		return arg0_4._go
	end

	function var0_1.SetGo(arg0_5, arg1_5)
		assert(arg1_5)

		arg0_5._go = arg1_5

		local var0_5 = arg0_5._FXAttachPoint.transform

		var0_5:SetParent(arg1_5.transform, false)

		var0_5.localPosition = Vector3.zero
		var0_5.localEulerAngles = Vector3(330, 0, 0)
	end

	function var0_1.GetSpecificFXScale(arg0_6)
		return {}
	end

	return var0_1
end

function var0_0.Ctor(arg0_7, arg1_7)
	arg0_7.rawImage = arg1_7

	setActive(arg0_7.rawImage, false)

	arg0_7.seaCameraGO = GameObject.Find("BarrageCamera")
	arg0_7.seaCameraGO.tag = "MainCamera"
	arg0_7.seaCamera = arg0_7.seaCameraGO:GetComponent(typeof(Camera))
	arg0_7.seaCamera.targetTexture = arg0_7.rawImage.texture
	arg0_7.seaCamera.enabled = true
	arg0_7.mainCameraGO = pg.UIMgr.GetInstance():GetMainCamera()
end

function var0_0.configUI(arg0_8, arg1_8, arg2_8)
	arg0_8.nameTF = arg2_8
	arg0_8.healTF = arg1_8

	setActive(arg0_8.healTF, false)
	arg0_8.healTF:GetComponent("DftAniEvent"):SetEndEvent(function()
		setActive(arg0_8.healTF, false)
		setText(arg0_8.healTF:Find("text"), "")
	end)
end

function var0_0.load(arg0_10, arg1_10, arg2_10)
	ys.Battle.BattleVariable.Init()

	local var0_10 = ys.Battle.BattleResourceManager.GetInstance()

	var0_10:Init()
	var0_10:AddPreloadResource(var0_10.GetMapResource(arg1_10))

	local function var1_10()
		pg.UIMgr.GetInstance():LoadingOff()

		arg0_10.seaView = ys.Battle.BattleMap.New(arg1_10)

		setActive(arg0_10.rawImage, true)

		GameObject.Find("scenes").transform.position = Vector3(0, -26, 0)

		var0_10:Clear()

		if arg2_10 then
			onNextTick(arg2_10)
		end
	end

	var0_10:StartPreload(var1_10, nil)
	pg.UIMgr.GetInstance():LoadingOn()
end

function var0_0.LoadShip(arg0_12, arg1_12, arg2_12, arg3_12, arg4_12)
	if not arg1_12 then
		arg4_12()

		return
	end

	if arg0_12.shipVO then
		arg4_12()

		return
	end

	arg0_12.unitList = {}
	arg0_12.bulletUnitList = {}
	arg0_12.shipVO = arg1_12
	arg0_12.equipSkinId = 0
	arg0_12.weaponIds = arg2_12

	ys.Battle.BattleFXPool.GetInstance():Init()

	arg0_12._cldSystem = ys.Battle.BattleCldSystem.New(arg0_12)

	local var0_12 = ys.Battle.BattleResourceManager.GetInstance()

	var0_12:Init()
	var0_12:AddPreloadResource(var0_12.GetDisplayCommonResource())

	if arg0_12.equipSkinId > 0 then
		var0_12:AddPreloadResource(var0_12.GetEquipSkinPreviewRes(arg0_12.equipSkinId))
	end

	local var1_12 = pg.enemy_data_statistics[var2_0]

	var0_12:AddPreloadResource(var0_12.GetCharacterPath(var1_12.prefab), false)

	local var2_12 = pg.enemy_data_statistics[var3_0]

	var0_12:AddPreloadResource(var0_12.GetCharacterPath(var2_12.prefab), false)
	var0_12:AddPreloadResource(var0_12.GetShipResource(arg1_12.configId, arg1_12.skinId), false)

	if arg1_12:getShipType() ~= ShipType.WeiXiu then
		for iter0_12, iter1_12 in ipairs(arg2_12) do
			if iter1_12 ~= 0 then
				local var3_12 = ys.Battle.BattleDataFunction.GetWeaponDataFromID(iter1_12).weapon_id

				for iter2_12, iter3_12 in ipairs(var3_12) do
					var0_12:AddPreloadResource(var0_12.GetWeaponResource(iter3_12))
				end
			end
		end
	end

	local function var4_12()
		local function var0_13(arg0_14)
			arg0_12.seaCharacter = arg0_14

			local var0_14 = arg1_12:getConfig("scale") / 50

			arg0_14.transform.localScale = Vector3(var0_14 - 0.4, var0_14, var0_14)
			arg0_14.transform.localPosition = arg0_12:GetCharacterOffset()
			arg0_14.transform.localEulerAngles = Vector3(30, 0, 0)
			arg0_12.seaAnimator = arg0_14.transform:GetComponent("SpineAnim")
			arg0_12.characterAction = ys.Battle.BattleConst.ActionName.MOVE

			arg0_12.seaAnimator:SetAction(arg0_12.characterAction, 0, true)

			local var1_14 = cloneTplTo(arg0_12.nameTF, arg0_14)

			var1_14.localPosition = Vector3(0, -0.35, -1)

			setText(var1_14:Find("Text"), arg3_12)

			local var2_14 = pg.ship_skin_template[arg1_12.skinId]
			local var3_14 = var5_0(var2_14.fx_container)

			var3_14:SetGo(arg0_14)

			local var4_14 = ys.Battle.BattleFXPool.GetInstance()
			local var5_14 = var4_14:GetCharacterFX("movewave", var3_14)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var5_14, Vector3(0, 0, 0), true)

			arg0_12.seaFXPool = var4_14

			if arg1_12:getShipType() ~= ShipType.WeiXiu then
				arg0_12.boneList = {}

				local var6_14 = pg.ship_skin_template[arg1_12.skinId]

				for iter0_14, iter1_14 in pairs(var6_14.bound_bone) do
					local var7_14 = {}

					for iter2_14, iter3_14 in ipairs(iter1_14) do
						if type(iter3_14) == "table" then
							var7_14[#var7_14 + 1] = Vector3(iter3_14[1], iter3_14[2], iter3_14[3])
						else
							var7_14[#var7_14 + 1] = Vector3.zero
						end
					end

					arg0_12.boneList[iter0_14] = var7_14[1]
				end
			end

			LeanTween.value(arg0_14, -20, 0, 2):setOnUpdate(System.Action_float(function(arg0_15)
				arg0_14.transform.position = Vector3(arg0_15, arg0_14.transform.position.y, arg0_14.transform.position.z)
			end))
		end

		seriesAsync({
			function(arg0_16)
				var0_12:InstCharacter(arg1_12:getPrefab(), function(arg0_17)
					var0_13(arg0_17)
					arg0_16()
				end)
			end,
			function(arg0_18)
				arg0_12:CreateMonster(arg0_18)
			end,
			function(arg0_19)
				arg0_12:CreateItemBox(arg0_19)
			end
		}, function()
			arg0_12.loaded = true

			pg.TimeMgr.GetInstance():ResumeBattleTimer()

			if arg1_12:getShipType() ~= ShipType.WeiXiu then
				arg0_12:onWeaponUpdate()
				arg0_12:SeaUpdate()
			end

			if arg4_12 then
				arg4_12()
			end
		end)
	end

	var0_12:StartPreload(var4_12, nil)
end

function var0_0.StartMoveOtherShips(arg0_21, arg1_21)
	local function var0_21(arg0_22, arg1_22)
		local var0_22 = arg0_22.transform.localPosition
		local var1_22 = math.random(5, 8)
		local var2_22 = math.random(0, 5)

		LeanTween.value(arg0_22, var0_22.x, 80, var1_22):setOnUpdate(System.Action_float(function(arg0_23)
			arg0_22.transform.localPosition = Vector3(arg0_23, var0_22.y, var0_22.z)
		end)):setOnComplete(System.Action(arg1_22)):setDelay(var2_22)
	end

	local var1_21 = {}

	for iter0_21, iter1_21 in ipairs(arg0_21.otherShipGos) do
		table.insert(var1_21, function(arg0_24)
			var0_21(iter1_21, arg0_24)
		end)
	end

	parallelAsync(var1_21, arg1_21)
end

function var0_0.PlayOtherShipAnim(arg0_25, arg1_25, arg2_25)
	if not arg0_25.loaded then
		return
	end

	arg0_25.otherShipGos = {}

	local var0_25 = ys.Battle.BattleResourceManager.GetInstance()

	var0_25:Init()
	var0_25:AddPreloadResource(var0_25.GetDisplayCommonResource())

	local function var1_25(arg0_26, arg1_26, arg2_26)
		local var0_26 = pg.ship_data_statistics[arg0_26.id].scale / 50

		arg2_26.transform.localScale = Vector3(var0_26 - 0.4, var0_26, var0_26)
		arg2_26.transform.localPosition = Vector3(-20, 0, arg1_26)
		arg2_26.transform.localEulerAngles = Vector3(30, 0, 0)

		arg2_26.transform:GetComponent("SpineAnim"):SetAction(ys.Battle.BattleConst.ActionName.MOVE, 0, true)

		local var1_26 = cloneTplTo(arg0_25.nameTF, arg2_26)

		var1_26.localPosition = Vector3(0, -0.35, -1)

		setText(var1_26:Find("Text"), arg0_26.name)

		local var2_26 = pg.ship_skin_template[arg0_26.skin]
		local var3_26 = var5_0(var2_26.fx_container)

		var3_26:SetGo(arg2_26)

		local var4_26 = ys.Battle.BattleFXPool.GetInstance():GetCharacterFX("movewave", var3_26)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var4_26, Vector3(0, 0, 0), true)
		table.insert(arg0_25.otherShipGos, arg2_26)
	end

	local var2_25 = {}
	local var3_25 = {
		math.random(43, 48),
		math.random(49, 53)
	}

	for iter0_25, iter1_25 in ipairs(arg1_25) do
		var0_25:AddPreloadResource(var0_25.GetShipResource(iter1_25.id, iter1_25.skin), false)
		table.insert(var2_25, function(arg0_27)
			local var0_27 = pg.ship_skin_template[iter1_25.skin]

			assert(var0_27, iter1_25.skin)
			var0_25:InstCharacter(var0_27.prefab, function(arg0_28)
				var1_25(iter1_25, var3_25[iter0_25], arg0_28)
				arg0_27()
			end)
		end)
	end

	local function var4_25()
		for iter0_29, iter1_29 in ipairs(arg0_25.otherShipGos) do
			Destroy(iter1_29)
		end

		arg0_25.otherShipGos = nil

		arg2_25()
	end

	local function var5_25()
		seriesAsync(var2_25, function()
			arg0_25:StartMoveOtherShips(var4_25)
		end)
	end

	var0_25:StartPreload(var5_25, nil)
end

function var0_0.PlayAttackAnim(arg0_32)
	arg0_32.isFinish = nil

	local function var0_32()
		if not arg0_32.animTimer then
			return
		end

		arg0_32.animTimer:Stop()

		arg0_32.animTimer = nil
	end

	local function var1_32(arg0_34)
		var0_32()
		arg0_32.seaEmenyAnimator:SetAction("move", 0, true)

		local var0_34

		var0_34.localPosition, var0_34 = var1_0 + Vector3(40, 0, 0), arg0_32.seaEmeny.transform

		setActive(arg0_32.seaEmeny, true)

		arg0_32.animTimer = Timer.New(function()
			var0_34.localPosition = Vector3.Lerp(var0_34.localPosition, var1_0, Time.deltaTime * 3)

			if Vector3.Distance(var1_0, var0_34.localPosition) <= 1 then
				arg0_34()
			end
		end, 0.033, -1)

		arg0_32.animTimer:Start()
	end

	local function var2_32(arg0_36)
		var0_32()

		if arg0_32.shipVO:getShipType() ~= ShipType.WeiXiu then
			arg0_32:SeaFire()
		end

		arg0_32.animTimer = Timer.New(arg0_36, 3, 1)

		arg0_32.animTimer:Start()
	end

	local function var3_32(arg0_37)
		var0_32()

		if not arg0_32.isFinish then
			arg0_32:HandleBulletHit(nil, arg0_32.unitList[1])
		end

		arg0_32.seaAnimator:SetActionCallBack(function(arg0_38)
			if arg0_38 == "finish" then
				arg0_32.seaAnimator:SetAction("move", 0, true)
				arg0_32.seaAnimator:SetActionCallBack(nil)
				arg0_37()
			end
		end)
		arg0_32.seaAnimator:SetAction("victory", 0, true)
	end

	seriesAsync({
		var1_32,
		var2_32,
		var3_32
	})
end

function var0_0.PlayItemAnim(arg0_39)
	local function var0_39()
		if not arg0_39.animTimer then
			return
		end

		arg0_39.animTimer:Stop()

		arg0_39.animTimer = nil
	end

	var0_39()

	local function var1_39(arg0_41)
		arg0_39.seaItemBoxAnimator:SetAction("move", 0, true)
		setActive(arg0_39.seaItemBox, true)

		local var0_41 = arg0_39.seaItemBox.transform

		var0_41.localPosition = var4_0
		arg0_39.animTimer = Timer.New(function()
			var0_41.localPosition = Vector3.Lerp(var0_41.localPosition, var1_0, Time.deltaTime * 3)

			if Vector3.Distance(var1_0, var0_41.localPosition) <= 1 then
				arg0_41()
			end
		end, 0.033, -1)

		arg0_39.animTimer:Start()
	end

	local function var2_39(arg0_43)
		var0_39()
		arg0_39.seaAnimator:SetActionCallBack(function(arg0_44)
			if arg0_44 == "finish" then
				arg0_39.seaAnimator:SetAction("move", 0, true)
				arg0_39.seaAnimator:SetActionCallBack(nil)
				arg0_43()
			end
		end)
		arg0_39.seaAnimator:SetAction("victory", 0, true)
	end

	seriesAsync({
		var1_39,
		var2_39
	})
end

function var0_0.CreateMonster(arg0_45, arg1_45)
	local var0_45 = 1
	local var1_45 = ys.Battle.BattleDataFunction.CreateBattleUnitData(var0_45, ys.Battle.BattleConst.UnitType.ENEMY_UNIT, -1, var2_0, nil, {}, nil, nil, false, 1, 1, nil, nil, 1)

	var1_45:SetPosition(var1_0)
	var1_45:ActiveCldBox()
	arg0_45._cldSystem:InitShipCld(var1_45)

	local var2_45 = var5_0(var1_45:GetTemplate().fx_container)

	ys.Battle.BattleResourceManager.GetInstance():InstCharacter(var1_45:GetTemplate().prefab, function(arg0_46)
		var2_45:SetGo(arg0_46)

		local var0_46 = var1_45:GetTemplate().scale / 50

		arg0_46.transform.localScale = Vector3(var0_46, var0_46, var0_46)
		arg0_46.transform.localPosition = var1_0
		arg0_46.transform.localEulerAngles = Vector3(30, 0, 0)

		local var1_46 = var1_45:GetTemplate().wave_fx
		local var2_46 = ys.Battle.BattleFXPool.GetInstance():GetCharacterFX(var1_46, var2_45)

		pg.EffectMgr.GetInstance():PlayBattleEffect(var2_46, Vector3(0, 0, 0), true)

		arg0_45.seaEmeny = arg0_46
		arg0_45.seaEmenyAnimator = arg0_46.transform:GetComponent("SpineAnim")

		setActive(arg0_46, false)
		arg1_45()
	end)

	arg0_45.unitList[var0_45] = var1_45
end

function var0_0.CreateItemBox(arg0_47, arg1_47)
	local var0_47 = pg.enemy_data_statistics[var3_0]

	ys.Battle.BattleResourceManager.GetInstance():InstCharacter(var0_47.prefab, function(arg0_48)
		local var0_48 = var0_47.scale / 50

		arg0_48.transform.localScale = Vector3(var0_48, var0_48, var0_48)
		arg0_48.transform.localPosition = var4_0
		arg0_48.transform.localEulerAngles = Vector3(30, 0, 0)
		arg0_47.seaItemBox = arg0_48
		arg0_47.seaItemBoxAnimator = arg0_48.transform:GetComponent("SpineAnim")

		setActive(arg0_48, false)
		arg1_47()
	end)
end

function var0_0.playShipAnims(arg0_49)
	if arg0_49.loaded and arg0_49.seaAnimator then
		local var0_49 = {
			"attack",
			"victory",
			"dead"
		}

		local function var1_49(arg0_50)
			if arg0_49.seaAnimator then
				arg0_49.seaAnimator:SetActionCallBack(nil)
			end

			arg0_49.seaAnimator:SetAction(var0_49[arg0_50], 0, false)
			arg0_49.seaAnimator:SetActionCallBack(function(arg0_51)
				if arg0_51 == "finish" then
					arg0_49.seaAnimator:SetActionCallBack(nil)
					arg0_49.seaAnimator:SetAction("stand", 0, false)
				end
			end)
		end

		if arg0_49.palyAnimTimer then
			arg0_49.palyAnimTimer:Stop()

			arg0_49.palyAnimTimer = nil
		end

		arg0_49.palyAnimTimer = Timer.New(function()
			var1_49(math.random(1, #var0_49))
		end, 5, -1)

		arg0_49.palyAnimTimer:Start()
		arg0_49.palyAnimTimer.func()
	end
end

function var0_0.onWeaponUpdate(arg0_53)
	if arg0_53.loaded and arg0_53.weaponIds then
		if arg0_53.seaAnimator then
			arg0_53.seaAnimator:SetActionCallBack(nil)
		end

		local function var0_53()
			for iter0_54, iter1_54 in pairs(arg0_53.weaponList or {}) do
				for iter2_54, iter3_54 in pairs(iter1_54.emitterList or {}) do
					iter3_54:Destroy()
				end
			end

			for iter4_54, iter5_54 in ipairs(arg0_53.bulletList or {}) do
				Object.Destroy(iter5_54._go)
			end

			for iter6_54, iter7_54 in pairs(arg0_53.aircraftList or {}) do
				Object.Destroy(iter7_54.obj)
			end

			arg0_53.bulletList = {}
			arg0_53.aircraftList = {}
		end

		if #arg0_53.weaponIds == 0 and arg0_53.playRandomAnims then
			if arg0_53._fireTimer then
				arg0_53._fireTimer:Stop()
			end

			if arg0_53._delayTimer then
				arg0_53._delayTimer:Stop()
			end

			if arg0_53.shipVO:getShipType() ~= ShipType.WeiXiu then
				var0_53()
			elseif arg0_53.buffTimer then
				pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_53.buffTimer)

				arg0_53.buffTimer = nil
			end

			arg0_53:playShipAnims()
		elseif arg0_53.shipVO:getShipType() ~= ShipType.WeiXiu then
			var0_53()
			arg0_53:MakeWeapon(arg0_53.weaponIds)
		else
			local var1_53 = arg0_53.weaponIds[1]

			if var1_53 then
				local var2_53 = Equipment.getConfigData(var1_53).skill_id[1]

				arg0_53:MakeBuff(var2_53)
			end
		end
	end
end

function var0_0.SeaFire(arg0_55)
	local var0_55 = 1
	local var1_55

	local function var2_55()
		local var0_56 = arg0_55.weaponList[var0_55]

		if var0_56 then
			local function var1_56()
				local var0_57 = 1
				local var1_57 = 0

				for iter0_57, iter1_57 in ipairs(var0_56.emitterList) do
					iter1_57:Ready()
				end

				for iter2_57, iter3_57 in ipairs(var0_56.emitterList) do
					iter3_57:Fire(nil, var0_57, var1_57)
				end

				var0_55 = var0_55 + 1
			end

			if var0_56.tmpData.action_index ~= "" then
				arg0_55.characterAction = var0_56.tmpData.action_index

				arg0_55.seaAnimator:SetAction(arg0_55.characterAction, 0, false)
				arg0_55.seaAnimator:SetActionCallBack(function(arg0_58)
					if arg0_58 == "action" then
						var1_56()
					end
				end)
			else
				var1_56()
			end

			if var0_56.tmpData.type == ys.Battle.BattleConst.EquipmentType.PREVIEW_ARICRAFT then
				arg0_55.timer = Timer.New(var2_55, 1.5, 1)

				arg0_55.timer:Start()
			end
		elseif arg0_55.characterAction ~= ys.Battle.BattleConst.ActionName.MOVE then
			arg0_55.characterAction = ys.Battle.BattleConst.ActionName.MOVE

			arg0_55.seaAnimator:SetAction(arg0_55.characterAction, 0, true)

			var0_55 = 1
		end
	end

	var2_55()
end

function var0_0.MakeBuff(arg0_59, arg1_59)
	local var0_59 = getSkillConfig(arg1_59)
	local var1_59 = var0_59.effect_list[1].arg_list.skill_id
	local var2_59 = var0_59.effect_list[1].arg_list.time
	local var3_59 = require("GameCfg.skill.skill_" .. var1_59)

	if arg0_59.buffTimer then
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_59.buffTimer)

		arg0_59.buffTimer = nil
	end

	arg0_59.buffTimer = pg.TimeMgr.GetInstance():AddBattleTimer("buffTimer", -1, var2_59, function()
		setActive(arg0_59.healTF, true)
		setText(arg0_59.healTF:Find("text"), var3_59.effect_list[1].arg_list.number)
	end)
end

function var0_0.MakeWeapon(arg0_61, arg1_61)
	arg0_61.weaponList = {}
	arg0_61.bulletList = {}
	arg0_61.aircraftList = {}

	local var0_61 = 0
	local var1_61 = ys.Battle.BattleConst

	for iter0_61, iter1_61 in ipairs(arg1_61) do
		local var2_61 = Equipment.getConfigData(iter1_61).weapon_id

		for iter2_61, iter3_61 in ipairs(var2_61) do
			if iter3_61 <= 0 then
				break
			end

			var0_61 = var0_61 + 1

			local var3_61 = ys.Battle.BattleDataFunction.GetWeaponPropertyDataFromID(iter3_61)

			if var3_61.type == var1_61.EquipmentType.MAIN_CANNON or var3_61.type == var1_61.EquipmentType.SUB_CANNON or var3_61.type == var1_61.EquipmentType.TORPEDO or var3_61.type == var1_61.EquipmentType.MANUAL_TORPEDO or var3_61.type == var1_61.EquipmentType.POINT_HIT_AND_LOCK then
				if type(var3_61.barrage_ID) == "table" then
					arg0_61.weaponList[var0_61] = {
						tmpData = var3_61,
						emitterList = {}
					}

					for iter4_61, iter5_61 in ipairs(var3_61.barrage_ID) do
						local var4_61 = arg0_61:createEmitterCannon(iter5_61, var3_61.bullet_ID[iter4_61], var3_61.spawn_bound)

						arg0_61.weaponList[var0_61].emitterList[iter4_61] = var4_61
					end
				end
			elseif var3_61.type == var1_61.EquipmentType.PREVIEW_ARICRAFT and type(var3_61.barrage_ID) == "table" then
				arg0_61.weaponList[var0_61] = {
					tmpData = var3_61,
					emitterList = {}
				}

				for iter6_61, iter7_61 in ipairs(var3_61.barrage_ID) do
					local var5_61 = arg0_61:createEmitterAir(iter7_61, var3_61.bullet_ID[iter6_61], var3_61.spawn_bound)

					arg0_61.weaponList[var0_61].emitterList[iter6_61] = var5_61
				end
			end
		end
	end
end

function var0_0.createEmitterCannon(arg0_62, arg1_62, arg2_62, arg3_62)
	local function var0_62(arg0_63, arg1_63, arg2_63, arg3_63, arg4_63)
		local var0_63 = ys.Battle.BattlePlayerUnit.New(1, ys.Battle.BattleConfig.FRIENDLY_CODE)
		local var1_63 = {
			speed = 0
		}

		var0_63:SetSkinId(arg0_62.shipVO.skinId)
		var0_63:SetTemplate(arg0_62.shipVO.configId, var1_63)

		local var2_63
		local var3_63 = arg0_62:GetCharacterOffset()
		local var4_63, var5_63 = ys.Battle.BattleDataFunction.CreateBattleBulletData(arg2_62, arg2_62, var0_63, var2_63, var3_63 + Vector3(40, 0, 0))

		if var5_63 then
			arg0_62._cldSystem:InitBulletCld(var4_63)
		end

		var4_63:SetOffsetPriority(arg3_63)
		var4_63:SetShiftInfo(arg0_63, arg1_63)
		var4_63:SetRotateInfo(nil, 0, arg2_63)

		if arg0_62.equipSkinId > 0 then
			local var6_63 = pg.equip_skin_template[arg0_62.equipSkinId]
			local var7_63, var8_63, var9_63, var10_63 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0_62.equipSkinId)
			local var11_63 = var4_63:GetType()
			local var12_63 = ys.Battle.BattleConst.BulletType
			local var13_63

			if var11_63 == var12_63.CANNON or var11_63 == var12_63.BOMB then
				local var14_63 = {
					EquipType.CannonQuZhu,
					EquipType.CannonQingXun,
					EquipType.CannonZhongXun,
					EquipType.CannonZhanlie,
					EquipType.CannonZhongXun2
				}

				if _.any(var14_63, function(arg0_64)
					return table.contains(var6_63.equip_type, arg0_64)
				end) then
					var4_63:SetModleID(var7_63)
				elseif var8_63 and #var8_63 > 0 then
					var4_63:SetModleID(var8_63)
				elseif var10_63 and #var10_63 > 0 then
					var4_63:SetModleID(var10_63)
				end
			elseif var11_63 == var12_63.TORPEDO then
				if table.contains(var6_63.equip_type, EquipType.Torpedo) then
					var4_63:SetModleID(var7_63)
				elseif var9_63 and #var9_63 > 0 then
					var4_63:SetModleID(var9_63)
				end
			end
		end

		local var15_63 = var4_63:GetType()
		local var16_63 = ys.Battle.BattleConst.BulletType
		local var17_63

		if var15_63 == var16_63.CANNON then
			var17_63 = ys.Battle.BattleCannonBullet.New()
		elseif var15_63 == var16_63.BOMB then
			var17_63 = ys.Battle.BattleBombBullet.New()
		elseif var15_63 == var16_63.TORPEDO then
			var17_63 = ys.Battle.BattleTorpedoBullet.New()
		else
			var17_63 = ys.Battle.BattleBullet.New()
		end

		var17_63:SetBulletData(var4_63)
		table.insert(arg0_62.bulletUnitList, var4_63)

		local function var18_63(arg0_65)
			var17_63:SetGO(arg0_65)
			var17_63:AddRotateScript()

			if tf(arg0_65).parent then
				tf(arg0_65).parent = nil
			end

			local var0_65 = arg0_62.boneList[arg3_62] or Vector3.zero
			local var1_65 = arg0_62:GetCharacterOffset()

			var17_63:SetSpawn(var1_65 + var0_65)

			if arg0_62.bulletList then
				table.insert(arg0_62.bulletList, var17_63)
			end
		end

		ys.Battle.BattleResourceManager.GetInstance():InstBullet(var17_63:GetModleID(), function(arg0_66)
			var18_63(arg0_66)
		end)
	end

	local function var1_62()
		return
	end

	local var2_62 = "BattleBulletEmitter"

	return (ys.Battle[var2_62].New(var0_62, var1_62, arg1_62))
end

function var0_0.createEmitterAir(arg0_68, arg1_68, arg2_68, arg3_68)
	local function var0_68(arg0_69, arg1_69, arg2_69, arg3_69, arg4_69)
		local var0_69 = {
			id = arg2_68
		}
		local var1_69 = pg.aircraft_template[arg2_68]

		var0_69.tmpData = var1_69

		local var2_69 = math.deg2Rad * arg2_69
		local var3_69 = Vector3(math.cos(var2_69), 0, math.sin(var2_69))

		local function var4_69(arg0_70)
			local var0_70 = arg0_68:GetCharacterOffset()
			local var1_70 = var0_70 + Vector3(var1_69.position_offset[1] + arg0_69, var1_69.position_offset[2], var1_69.position_offset[3] + arg1_69)

			arg0_70.transform.localPosition = var1_70
			arg0_70.transform.localScale = Vector3(0.1, 0.1, 0.1)
			var0_69.obj = arg0_70
			var0_69.tf = arg0_70.transform
			var0_69.pos = var1_70
			var0_69.baseVelocity = ys.Battle.BattleFormulas.ConvertAircraftSpeed(var0_69.tmpData.speed)
			var0_69.speed = var3_69 * var0_69.baseVelocity
			var0_69.speedZ = (math.random() - 0.5) * 0.5
			var0_69.targetZ = var0_70.z

			if arg0_68.aircraftList then
				table.insert(arg0_68.aircraftList, var0_69)
			end
		end

		local var5_69 = var1_69.model_ID

		if arg0_68.equipSkinId > 0 then
			local var6_69 = pg.equip_skin_template[arg0_68.equipSkinId]
			local var7_69 = {
				EquipType.FighterAircraft,
				EquipType.TorpedoAircraft,
				EquipType.BomberAircraft
			}

			if table.contains(var6_69.equip_type, var7_69[var1_69.type]) then
				var5_69 = ys.Battle.BattleDataFunction.GetEquipSkin(arg0_68.equipSkinId)
			end
		end

		ys.Battle.BattleResourceManager.GetInstance():InstAirCharacter(var5_69, function(arg0_71)
			var4_69(arg0_71)
		end)
	end

	local function var1_68()
		return
	end

	local var2_68 = "BattleBulletEmitter"

	return (ys.Battle[var2_68].New(var0_68, var1_68, arg1_68))
end

function var0_0.RemoveBullet(arg0_73, arg1_73, arg2_73)
	table.remove(arg0_73.bulletUnitList, arg1_73)

	local var0_73 = arg0_73.bulletList[arg1_73]

	Object.Destroy(var0_73._go)
	table.remove(arg0_73.bulletList, arg1_73)

	if arg2_73 then
		local var1_73 = var0_73:GetMissFXID()

		if var1_73 and var1_73 ~= "" then
			local var2_73, var3_73 = arg0_73.seaFXPool:GetFX(var1_73)

			pg.EffectMgr.GetInstance():PlayBattleEffect(var2_73, var0_73:GetPosition() + var3_73, true)
		end
	end
end

function var0_0.SeaUpdate(arg0_74)
	if not arg0_74.bulletList then
		return
	end

	local var0_74 = 0
	local var1_74 = -20
	local var2_74 = 60
	local var3_74 = 0
	local var4_74 = 60
	local var5_74 = ys.Battle.BattleConfig
	local var6_74 = ys.Battle.BattleConst

	local function var7_74()
		for iter0_75 = #arg0_74.bulletUnitList, 1, -1 do
			local var0_75 = arg0_74.bulletUnitList[iter0_75]

			arg0_74._cldSystem:UpdateBulletCld(var0_75)
		end

		for iter1_75 = #arg0_74.bulletList, 1, -1 do
			local var1_75 = arg0_74.bulletList[iter1_75]
			local var2_75 = var1_75._bulletData:GetSpeed()()
			local var3_75 = var1_75:GetPosition()

			if var3_75.x > var2_74 and var2_75.x > 0 or var3_75.z < var3_74 and var2_75.z < 0 then
				arg0_74:RemoveBullet(iter1_75, false)
			elseif var3_75.x < var1_74 and var2_75.x < 0 and var1_75:GetType() ~= var6_74.BulletType.BOMB then
				arg0_74:RemoveBullet(iter1_75, false)
			else
				local var4_75 = pg.TimeMgr.GetInstance():GetCombatTime()

				var1_75._bulletData:Update(var4_75)
				var1_75:Update(var0_74)

				if var3_75.z > var4_74 and var2_75.z > 0 or var1_75._bulletData:IsOutRange(var0_74) then
					arg0_74:RemoveBullet(iter1_75, true)
				end
			end
		end

		for iter2_75, iter3_75 in ipairs(arg0_74.aircraftList) do
			local var5_75 = iter3_75.pos + iter3_75.speed

			if var5_75.y < var5_74.AircraftHeight + 5 then
				iter3_75.speed.y = math.max(0.4, 1 - var5_75.y / var5_74.AircraftHeight)

				local var6_75 = math.min(1, var5_75.y / var5_74.AircraftHeight)

				iter3_75.tf.localScale = Vector3(var6_75, var6_75, var6_75)
			end

			iter3_75.speed.z = iter3_75.baseVelocity * iter3_75.speedZ

			local var7_75 = iter3_75.targetZ - var5_75.z

			if var7_75 > iter3_75.baseVelocity then
				iter3_75.speed.z = iter3_75.baseVelocity * 0.5
			elseif var7_75 < -iter3_75.baseVelocity then
				iter3_75.speed.z = -iter3_75.baseVelocity * 0.5
			else
				local var8_75 = arg0_74:GetCharacterOffset()

				iter3_75.targetZ = var8_75.z + var8_75.z * (math.random() - 0.5) * 0.6
			end

			if var5_75.x > var2_74 or var5_75.x < var1_74 then
				Object.Destroy(iter3_75.obj)
				table.remove(arg0_74.aircraftList, iter2_75)
			else
				iter3_75.tf.localPosition = var5_75
				iter3_75.pos = var5_75
			end
		end

		var0_74 = var0_74 + 1
	end

	pg.TimeMgr.GetInstance():AddBattleTimer("barrageUpdateTimer", -1, 0.033, var7_74)
end

function var0_0.GetCharacterOffset(arg0_76)
	return Vector3(0, -3, 40)
end

function var0_0.GetTotalBounds(arg0_77)
	local var0_77 = {
		-70,
		20,
		90,
		70
	}
	local var1_77 = var0_77[1]
	local var2_77 = var0_77[1] + var0_77[3]
	local var3_77 = var0_77[2] + var0_77[4]
	local var4_77 = var0_77[2]

	return var3_77, var4_77, var1_77, var2_77
end

function var0_0.HandleShipCrashDecelerate(arg0_78)
	return
end

function var0_0.HandleShipCrashDecelerate(arg0_79)
	return
end

function var0_0.HandleShipCrashDamageList(arg0_80)
	return
end

function var0_0.HandleBulletHit(arg0_81, arg1_81, arg2_81)
	for iter0_81 = #arg0_81.bulletUnitList, 1, -1 do
		if arg0_81.bulletUnitList[iter0_81] == arg1_81 then
			arg0_81:RemoveBullet(iter0_81, true)
		end
	end

	if not arg0_81.isFinish then
		arg0_81.isFinish = true

		setActive(arg0_81.seaEmeny, false)

		local var0_81, var1_81 = ys.Battle.BattleFXPool.GetInstance():GetFX("Bomb")

		pg.EffectMgr.GetInstance():PlayBattleEffect(var0_81, var1_81:Add(arg2_81:GetPosition()), true)
	end
end

function var0_0.HandleWallHitByBullet(arg0_82)
	return
end

function var0_0.GetUnitList(arg0_83)
	return arg0_83.unitList
end

function var0_0.GetAircraftList(arg0_84)
	return {}
end

function var0_0.GetBulletList(arg0_85)
	return arg0_85.bulletUnitList
end

function var0_0.GetAOEList(arg0_86)
	return {}
end

function var0_0.GetFriendlyCode(arg0_87)
	return 1
end

function var0_0.GetFoeCode(arg0_88)
	return -1
end

function var0_0.clear(arg0_89)
	if arg0_89.animTimer then
		arg0_89.animTimer:Stop()

		arg0_89.animTimer = nil
	end

	if arg0_89._cldSystem then
		arg0_89._cldSystem:Dispose()
	end

	if arg0_89.timer then
		arg0_89.timer:Stop()

		arg0_89.timer = nil
	end

	pg.TimeMgr.GetInstance():RemoveAllBattleTimer()

	if arg0_89.seaCharacter then
		Destroy(arg0_89.seaCharacter)

		arg0_89.seaCharacter = nil
	end

	if arg0_89.otherShipGos then
		for iter0_89, iter1_89 in ipairs(arg0_89.otherShipGos) do
			Destroy(iter1_89)
		end

		arg0_89.otherShipGos = nil
	end

	if arg0_89.aircraftList then
		for iter2_89, iter3_89 in ipairs(arg0_89.aircraftList) do
			Destroy(iter3_89.obj)
		end

		arg0_89.aircraftList = nil
	end

	if arg0_89.seaView then
		arg0_89.seaView:Dispose()

		arg0_89.seaView = nil
	end

	if arg0_89.weaponList then
		for iter4_89, iter5_89 in ipairs(arg0_89.weaponList) do
			for iter6_89, iter7_89 in ipairs(iter5_89.emitterList) do
				iter7_89:Destroy()
			end
		end

		arg0_89.weaponList = nil
	end

	if arg0_89.bulletList then
		for iter8_89, iter9_89 in ipairs(arg0_89.bulletList) do
			Destroy(iter9_89._go)
		end

		arg0_89.bulletList = nil
	end

	if arg0_89.seaFXPool then
		arg0_89.seaFXPool:Clear()

		arg0_89.seaFXPool = nil
	end

	if arg0_89.seaEmeny then
		Destroy(arg0_89.seaEmeny)

		arg0_89.seaEmeny = nil
	end

	if arg0_89.seaItemBox then
		Destroy(arg0_89.seaItemBox)

		arg0_89.seaItemBox = nil
	end

	if arg0_89.seaFXContainersPool then
		arg0_89.seaFXContainersPool:Clear()

		arg0_89.seaFXContainersPool = nil
	end

	ys.Battle.BattleResourceManager.GetInstance():Clear()

	arg0_89.seaCameraGO.tag = "Untagged"
	arg0_89.seaCameraGO = nil
	arg0_89.seaCamera = nil

	arg0_89.mainCameraGO:SetActive(true)

	arg0_89.mainCameraGO = nil
	arg0_89.loaded = false

	if arg0_89.palyAnimTimer then
		arg0_89.palyAnimTimer:Stop()

		arg0_89.palyAnimTimer = nil
	end
end

return var0_0
