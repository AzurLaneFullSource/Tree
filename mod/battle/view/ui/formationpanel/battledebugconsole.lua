ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleConfig

var0_0.Battle.BattleDebugConsole = class("BattleDebugConsole")
var0_0.Battle.BattleDebugConsole.__name = "BattleDebugConsole"

local var3_0 = var0_0.Battle.BattleDebugConsole

var3_0.ProxyUpdateNormal = var0_0.Battle.BattleDataProxy.Update
var3_0.ProxyUpdateAutoComponentNormal = var0_0.Battle.BattleDataProxy.UpdateAutoComponent
var3_0.UPDATE_PLAYER_WEAPON = "updatePlayerWeapon"
var3_0.UPDATE_MONSTER_WEAPON = "updateMonsterWeapon"
var3_0.UPDATE_MONSTER_AI = "updateMonsterAI"

function var3_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1
	arg0_1._state = arg2_1
	arg0_1._dataProxy = arg0_1._state:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)

	arg0_1:initComponent()

	if arg0_1._dataProxy:GetInitData().battleType == SYSTEM_DEBUG or arg0_1._dataProxy:GetInitData().battleType == SYSTEM_CARDPUZZLE then
		arg0_1:initData()
		arg0_1:initDebug()
	else
		SetActive(arg0_1._debug, false)
	end
end

function var3_0.initDebug(arg0_2)
	arg0_2._randomEngage = arg0_2._debug:Find("spawn_enemy")

	onButton(nil, arg0_2._randomEngage, function()
		local var0_3 = math.random(#arg0_2._monsterArray)

		arg0_2:spawnEnemy(arg0_2._monsterArray[var0_3], 15, 25, 25, 65)
	end, SFX_PANEL)

	arg0_2._summon = arg0_2._debug:Find("summon_enemy")
	arg0_2._summonID = arg0_2._debug:Find("model_id"):GetComponent("InputField")
	arg0_2._minX = arg0_2._debug:Find("x_min"):GetComponent("InputField")
	arg0_2._manX = arg0_2._debug:Find("x_max"):GetComponent("InputField")
	arg0_2._minZ = arg0_2._debug:Find("z_min"):GetComponent("InputField")
	arg0_2._manZ = arg0_2._debug:Find("z_max"):GetComponent("InputField")

	onButton(nil, arg0_2._summon, function()
		local var0_4 = tonumber(arg0_2._summonID.text)
		local var1_4 = tonumber(arg0_2._minX.text)
		local var2_4 = tonumber(arg0_2._manX.text)
		local var3_4 = tonumber(arg0_2._minZ.text)
		local var4_4 = tonumber(arg0_2._manZ.text)

		arg0_2:spawnEnemy(var0_4, var1_4, var2_4, var3_4, var4_4)
	end, SFX_PANEL)

	arg0_2._killAllEnemy = arg0_2._debug:Find("clear_enemy")

	onButton(nil, arg0_2._killAllEnemy, function()
		arg0_2._dataProxy:KillAllEnemy()
	end, SFX_PANEL)

	arg0_2._summonStrike = arg0_2._debug:Find("spawn_strike")
	arg0_2._summonStrikeID = arg0_2._debug:Find("air_model_id"):GetComponent("InputField")
	arg0_2._summonStrikeTotal = arg0_2._debug:Find("total"):GetComponent("InputField")
	arg0_2._summonStrikeSingular = arg0_2._debug:Find("once"):GetComponent("InputField")
	arg0_2._summonStrikeInterval = arg0_2._debug:Find("interval"):GetComponent("InputField")

	onButton(nil, arg0_2._summonStrike, function()
		local var0_6 = tonumber(arg0_2._summonStrikeID.text)
		local var1_6 = tonumber(arg0_2._summonStrikeTotal.text)
		local var2_6 = tonumber(arg0_2._summonStrikeSingular.text)
		local var3_6 = tonumber(arg0_2._summonStrikeInterval.text)

		arg0_2:spawnStrike(var0_6, var1_6, var2_6, var3_6)
	end, SFX_PANEL)

	arg0_2._killAllStrike = arg0_2._debug:Find("clear_strike")

	onButton(nil, arg0_2._killAllStrike, function()
		arg0_2._dataProxy:KillAllAirStrike()
	end, SFX_PANEL)

	arg0_2._blockCld = arg0_2._debug:Find("all_cld")
	arg0_2._blockPlayerWeapon = arg0_2._debug:Find("player_weapon")
	arg0_2._blockMonsterWeapon = arg0_2._debug:Find("monster_weapon")
	arg0_2._blockMonsterAI = arg0_2._debug:Find("monster_motion")

	onToggle(nil, arg0_2._blockCld, function(arg0_8)
		if arg0_8 then
			arg0_2._dataProxy.Update = var3_0.ProxyUpdateNormal
		else
			arg0_2._dataProxy.Update = arg0_2._dataProxy.__debug__BlockCldUpdate__
		end
	end, SFX_PANEL)
	onToggle(nil, arg0_2._blockPlayerWeapon, function(arg0_9)
		if arg0_9 then
			arg0_2._autoComponentFuncList.updatePlayerWeapon = arg0_2._updatePlayerWeapon
		else
			arg0_2._autoComponentFuncList.updatePlayerWeapon = nil
		end
	end, SFX_PANEL)
	onToggle(nil, arg0_2._blockMonsterWeapon, function(arg0_10)
		if arg0_10 then
			arg0_2._autoComponentFuncList.updateMonsterWeapon = arg0_2._updateMonsterWeapon
		else
			arg0_2._autoComponentFuncList.updateMonsterWeapon = nil
		end
	end, SFX_PANEL)
	onToggle(nil, arg0_2._blockMonsterAI, function(arg0_11)
		if arg0_11 then
			arg0_2._autoComponentFuncList.updateMonsterAI = arg0_2._updateMonsterAI
		else
			arg0_2._autoComponentFuncList.updateMonsterAI = nil
		end
	end, SFX_PANEL)

	arg0_2._setDungeonLevel = arg0_2._debug:Find("dungeon_level")
	arg0_2._dungeonLevel = arg0_2._debug:Find("level_input"):GetComponent("InputField")

	onButton(nil, arg0_2._setDungeonLevel, function()
		arg0_2._dataProxy:SetDungeonLevel(tonumber(arg0_2._dungeonLevel.text))
	end, SFX_PANEL)

	arg0_2._clsBullet = arg0_2._debug:Find("cls_bullet")

	onButton(nil, arg0_2._clsBullet, function()
		arg0_2._dataProxy:CLSBullet(var2_0.FRIENDLY_CODE)
		arg0_2._dataProxy:CLSBullet(var2_0.FOE_CODE)
	end, SFX_PANEL)
end

function var3_0.initData(arg0_14)
	arg0_14._fleetList = arg0_14._dataProxy:GetFleetList()
	arg0_14._freeShipList = arg0_14._dataProxy:GetFreeShipList()
	arg0_14._monsterArray = {}

	for iter0_14, iter1_14 in ipairs(pg.enemy_data_statistics.all) do
		if type(iter1_14) == "number" and iter1_14 <= 10000000 then
			table.insert(arg0_14._monsterArray, iter1_14)
		end
	end

	function arg0_14._updatePlayerWeapon(arg0_15)
		for iter0_15, iter1_15 in pairs(arg0_14._fleetList) do
			iter1_15:UpdateAutoComponent(arg0_15)
		end
	end

	function arg0_14._updateMonsterWeapon(arg0_16)
		for iter0_16, iter1_16 in pairs(arg0_14._freeShipList) do
			iter1_16:UpdateWeapon(arg0_16)
		end
	end

	function arg0_14._updateMonsterAI(arg0_17)
		for iter0_17, iter1_17 in pairs(arg0_14._dataProxy._teamList) do
			if iter1_17:IsFatalDamage() then
				arg0_14._dataProxy:KillNPCTeam(iter0_17)
			else
				iter1_17:UpdateMotion()
			end
		end
	end

	arg0_14._autoComponentFuncList = {}
	arg0_14._autoComponentFuncList.updatePlayerWeapon = arg0_14._updatePlayerWeapon
	arg0_14._autoComponentFuncList.updateMonsterWeapon = arg0_14._updateMonsterWeapon
	arg0_14._autoComponentFuncList.updateMonsterAI = arg0_14._updateMonsterAI

	local function var0_14(arg0_18, arg1_18)
		for iter0_18, iter1_18 in pairs(arg0_14._autoComponentFuncList) do
			iter1_18(arg1_18)
		end
	end

	arg0_14._dataProxy.UpdateAutoComponent = var0_14
end

function var3_0.initComponent(arg0_19)
	arg0_19._base = arg0_19._go:Find("bg")
	arg0_19._common = arg0_19._base:Find("common")
	arg0_19._debug = arg0_19._base:Find("debug")
	arg0_19._exitBtn = arg0_19._common:Find("close")

	onButton(nil, arg0_19._exitBtn, function()
		arg0_19:SetActive(false)
	end, SFX_PANEL)

	arg0_19._activeReference = arg0_19._common:Find("reference_switch")

	onButton(nil, arg0_19._activeReference, function()
		arg0_19:activeReference()
	end, SFX_PANEL)

	arg0_19._lockCommonDMG = arg0_19._common:Find("common_damage")
	arg0_19._lockS2MDMG = arg0_19._common:Find("ship2main_damage")
	arg0_19._lockA2MDMG = arg0_19._common:Find("aircraft2main_damage")
	arg0_19._lockCrushDMG = arg0_19._common:Find("crush_damage")

	onToggle(nil, arg0_19._lockCommonDMG, function(arg0_22)
		arg0_19._dataProxy:SetupCalculateDamage(arg0_22 and var0_0.Battle.BattleFormulas.CalcDamageLock or nil)
	end, SFX_PANEL)
	onToggle(nil, arg0_19._lockS2MDMG, function(arg0_23)
		arg0_19._dataProxy:SetupDamageKamikazeAir(arg0_23 and var0_0.Battle.BattleFormulas.CalcDamageLockA2M or nil)
	end, SFX_PANEL)
	onToggle(nil, arg0_19._lockA2MDMG, function(arg0_24)
		arg0_19._dataProxy:SetupDamageKamikazeShip(arg0_24 and var0_0.Battle.BattleFormulas.CalcDamageLockS2M or nil)
	end, SFX_PANEL)
	onToggle(nil, arg0_19._lockCrushDMG, function(arg0_25)
		arg0_19._dataProxy:SetupDamageCrush(arg0_25 and var0_0.Battle.BattleFormulas.CalcDamageLockCrush or nil)
	end, SFX_PANEL)

	arg0_19._triggerWave = arg0_19._common:Find("wave_trigger")
	arg0_19._waveIndex = arg0_19._common:Find("wave_input"):GetComponent("InputField")

	if arg0_19._dataProxy:GetInitData().battleType ~= SYSTEM_SCENARIO and arg0_19._dataProxy:GetInitData().battleType ~= SYSTEM_ROUTINE and arg0_19._dataProxy:GetInitData().battleType ~= SYSTEM_ACT_BOSS then
		SetActive(arg0_19._triggerWave, false)
		SetActive(arg0_19._waveIndex, false)
	else
		onButton(nil, arg0_19._triggerWave, function()
			arg0_19:forceTrigger(tonumber(arg0_19._waveIndex.text))
		end)
	end

	arg0_19._triggerWeather = arg0_19._common:Find("weather_trigger")
	arg0_19._weatherInput = arg0_19._common:Find("weather_input"):GetComponent("InputField")

	onButton(nil, arg0_19._triggerWeather, function()
		arg0_19._dataProxy:AddWeather(tonumber(arg0_19._weatherInput.text))
	end)

	arg0_19._antiSubDetailRange = arg0_19._common:Find("anti_sub_detail")

	onButton(nil, arg0_19._antiSubDetailRange, function()
		arg0_19._state:GetMediatorByName("BattleSceneMediator"):InitDetailAntiSubArea()
	end)

	arg0_19._instantReload = arg0_19._common:Find("instant_reload")

	onButton(nil, arg0_19._instantReload, function()
		local var0_29 = arg0_19._dataProxy._fleetList[1]

		local function var1_29(arg0_30)
			local var0_30 = arg0_30:GetWeaponList()

			for iter0_30, iter1_30 in ipairs(var0_30) do
				iter1_30:QuickCoolDown()
			end
		end

		var1_29(var0_29:GetChargeWeaponVO())
		var1_29(var0_29:GetTorpedoWeaponVO())
		var1_29(var0_29:GetAirAssistVO())
	end)

	arg0_19._white = arg0_19._base:Find("white_button")

	onButton(nil, arg0_19._white, function()
		arg0_19._dataProxy._fleetList[1]._scoutList[1]:UpdateHP(-20, {})
	end, SFX_PANEL)
	SetActive(arg0_19._white, true)
end

function var3_0.SetActive(arg0_32, arg1_32)
	SetActive(arg0_32._go, arg1_32)
end

function var3_0.spawnEnemy(arg0_33, arg1_33, arg2_33, arg3_33, arg4_33, arg5_33)
	local var0_33 = {
		monsterTemplateID = arg1_33,
		corrdinate = {
			math.random(arg2_33, arg3_33),
			0,
			math.random(arg4_33, arg5_33)
		}
	}

	var0_33.delay = 0
	var0_33.moveCast = true
	var0_33.score = 0
	var0_33.buffList = {
		8001
	}

	arg0_33._dataProxy:SpawnMonster(var0_33, 1, var1_0.UnitType.ENEMY_UNIT, var2_0.FOE_CODE)
end

function var3_0.spawnStrike(arg0_34, arg1_34, arg2_34, arg3_34, arg4_34)
	local var0_34 = {
		templateID = arg1_34,
		weaponID = {},
		attr = {},
		totalNumber = arg2_34,
		onceNumber = arg3_34
	}

	var0_34.formation = 10006
	var0_34.delay = 0
	var0_34.interval = 0.1
	var0_34.score = 0

	arg0_34._dataProxy:SpawnAirFighter(var0_34)
end

function var3_0.activeReference(arg0_35)
	arg0_35._state:ActiveReference()

	local var0_35 = arg0_35._state:GetMediatorByName(var0_0.Battle.BattleReferenceBoxMediator.__name) or arg0_35._state:AddMediator(var0_0.Battle.BattleReferenceBoxMediator.New())

	pg.TipsMgr.GetInstance():ShowTips("┏━━━━━━━━━━━━━━━━━━━┓")
	pg.TipsMgr.GetInstance():ShowTips("┃ヽ(•̀ω•́ )ゝ战斗调试模块初始化成功！(ง •̀_•́)ง┃")
	pg.TipsMgr.GetInstance():ShowTips("┗━━━━━━━━━━━━━━━━━━━┛")

	arg0_35._activeReference.transform:GetComponent("Button").enabled = false
	arg0_35._activeReference:Find("text"):GetComponent(typeof(Text)).text = "(ﾉ･ω･)ﾉﾞ"
	arg0_35._referenceConsole = arg0_35._common:Find("reference_btns")

	SetActive(arg0_35._referenceConsole, true)

	arg0_35._speedUp = arg0_35._referenceConsole:Find("speed_up")
	arg0_35._speedDown = arg0_35._referenceConsole:Find("speed_down")
	arg0_35._speedLevel = arg0_35._referenceConsole:Find("speed")

	onButton(nil, arg0_35._speedUp, function()
		local var0_36 = var0_0.Battle.BattleConfig.BASIC_TIME_SCALE

		if var0_36 < 1 then
			var0_0.Battle.BattleControllerCommand.removeSpeed(2)
		elseif var0_36 >= 1 then
			var0_0.Battle.BattleControllerCommand.addSpeed(2)
		end

		arg0_35._speedLevel:GetComponent(typeof(Text)).text = var0_0.Battle.BattleConfig.BASIC_TIME_SCALE

		arg0_35._state:ScaleTimer()
	end, SFX_PANEL)
	onButton(nil, arg0_35._speedDown, function()
		local var0_37 = var0_0.Battle.BattleConfig.BASIC_TIME_SCALE

		if var0_37 > 1 then
			var0_0.Battle.BattleControllerCommand.removeSpeed(0.5)
		elseif var0_37 <= 1 then
			var0_0.Battle.BattleControllerCommand.addSpeed(0.5)
		end

		arg0_35._speedLevel:GetComponent(typeof(Text)).text = var0_0.Battle.BattleConfig.BASIC_TIME_SCALE

		arg0_35._state:ScaleTimer()
	end, SFX_PANEL)

	arg0_35._shipBox = arg0_35._referenceConsole:Find("ship_box")
	arg0_35._bulletBox = arg0_35._referenceConsole:Find("bullet_box")
	arg0_35._pp = arg0_35._referenceConsole:Find("property_panel")

	onToggle(nil, arg0_35._shipBox, function(arg0_38)
		var0_35:ActiveUnitBoxes(arg0_38)
	end, SFX_PANEL)
	onToggle(nil, arg0_35._bulletBox, function(arg0_39)
		var0_35:ActiveBulletBoxes(arg0_39)
	end, SFX_PANEL)
	onToggle(nil, arg0_35._pp, function(arg0_40)
		var0_35:ActiveUnitDetail(arg0_40)
	end, SFX_PANEL)
end

function var3_0.forceTrigger(arg0_41, arg1_41)
	local var0_41 = arg0_41._state:GetCommandByName("BattleSingleDungeonCommand")._waveUpdater._waveInfoList[arg1_41]

	if var0_41 == nil then
		pg.TipsMgr.GetInstance():ShowTips("查无次波")
	elseif var0_41:GetState() ~= var0_41.STATE_DEACTIVE then
		pg.TipsMgr.GetInstance():ShowTips("该触发器已经触发")
	else
		var0_41:DoWave()
	end
end
