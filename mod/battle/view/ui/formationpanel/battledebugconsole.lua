ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleConfig

var0.Battle.BattleDebugConsole = class("BattleDebugConsole")
var0.Battle.BattleDebugConsole.__name = "BattleDebugConsole"

local var3 = var0.Battle.BattleDebugConsole

var3.ProxyUpdateNormal = var0.Battle.BattleDataProxy.Update
var3.ProxyUpdateAutoComponentNormal = var0.Battle.BattleDataProxy.UpdateAutoComponent
var3.UPDATE_PLAYER_WEAPON = "updatePlayerWeapon"
var3.UPDATE_MONSTER_WEAPON = "updateMonsterWeapon"
var3.UPDATE_MONSTER_AI = "updateMonsterAI"

function var3.Ctor(arg0, arg1, arg2)
	arg0._go = arg1
	arg0._state = arg2
	arg0._dataProxy = arg0._state:GetProxyByName(var0.Battle.BattleDataProxy.__name)

	arg0:initComponent()

	if arg0._dataProxy:GetInitData().battleType == SYSTEM_DEBUG or arg0._dataProxy:GetInitData().battleType == SYSTEM_CARDPUZZLE then
		arg0:initData()
		arg0:initDebug()
	else
		SetActive(arg0._debug, false)
	end
end

function var3.initDebug(arg0)
	arg0._randomEngage = arg0._debug:Find("spawn_enemy")

	onButton(nil, arg0._randomEngage, function()
		local var0 = math.random(#arg0._monsterArray)

		arg0:spawnEnemy(arg0._monsterArray[var0], 15, 25, 25, 65)
	end, SFX_PANEL)

	arg0._summon = arg0._debug:Find("summon_enemy")
	arg0._summonID = arg0._debug:Find("model_id"):GetComponent("InputField")
	arg0._minX = arg0._debug:Find("x_min"):GetComponent("InputField")
	arg0._manX = arg0._debug:Find("x_max"):GetComponent("InputField")
	arg0._minZ = arg0._debug:Find("z_min"):GetComponent("InputField")
	arg0._manZ = arg0._debug:Find("z_max"):GetComponent("InputField")

	onButton(nil, arg0._summon, function()
		local var0 = tonumber(arg0._summonID.text)
		local var1 = tonumber(arg0._minX.text)
		local var2 = tonumber(arg0._manX.text)
		local var3 = tonumber(arg0._minZ.text)
		local var4 = tonumber(arg0._manZ.text)

		arg0:spawnEnemy(var0, var1, var2, var3, var4)
	end, SFX_PANEL)

	arg0._killAllEnemy = arg0._debug:Find("clear_enemy")

	onButton(nil, arg0._killAllEnemy, function()
		arg0._dataProxy:KillAllEnemy()
	end, SFX_PANEL)

	arg0._summonStrike = arg0._debug:Find("spawn_strike")
	arg0._summonStrikeID = arg0._debug:Find("air_model_id"):GetComponent("InputField")
	arg0._summonStrikeTotal = arg0._debug:Find("total"):GetComponent("InputField")
	arg0._summonStrikeSingular = arg0._debug:Find("once"):GetComponent("InputField")
	arg0._summonStrikeInterval = arg0._debug:Find("interval"):GetComponent("InputField")

	onButton(nil, arg0._summonStrike, function()
		local var0 = tonumber(arg0._summonStrikeID.text)
		local var1 = tonumber(arg0._summonStrikeTotal.text)
		local var2 = tonumber(arg0._summonStrikeSingular.text)
		local var3 = tonumber(arg0._summonStrikeInterval.text)

		arg0:spawnStrike(var0, var1, var2, var3)
	end, SFX_PANEL)

	arg0._killAllStrike = arg0._debug:Find("clear_strike")

	onButton(nil, arg0._killAllStrike, function()
		arg0._dataProxy:KillAllAirStrike()
	end, SFX_PANEL)

	arg0._blockCld = arg0._debug:Find("all_cld")
	arg0._blockPlayerWeapon = arg0._debug:Find("player_weapon")
	arg0._blockMonsterWeapon = arg0._debug:Find("monster_weapon")
	arg0._blockMonsterAI = arg0._debug:Find("monster_motion")

	onToggle(nil, arg0._blockCld, function(arg0)
		if arg0 then
			arg0._dataProxy.Update = var3.ProxyUpdateNormal
		else
			arg0._dataProxy.Update = arg0._dataProxy.__debug__BlockCldUpdate__
		end
	end, SFX_PANEL)
	onToggle(nil, arg0._blockPlayerWeapon, function(arg0)
		if arg0 then
			arg0._autoComponentFuncList.updatePlayerWeapon = arg0._updatePlayerWeapon
		else
			arg0._autoComponentFuncList.updatePlayerWeapon = nil
		end
	end, SFX_PANEL)
	onToggle(nil, arg0._blockMonsterWeapon, function(arg0)
		if arg0 then
			arg0._autoComponentFuncList.updateMonsterWeapon = arg0._updateMonsterWeapon
		else
			arg0._autoComponentFuncList.updateMonsterWeapon = nil
		end
	end, SFX_PANEL)
	onToggle(nil, arg0._blockMonsterAI, function(arg0)
		if arg0 then
			arg0._autoComponentFuncList.updateMonsterAI = arg0._updateMonsterAI
		else
			arg0._autoComponentFuncList.updateMonsterAI = nil
		end
	end, SFX_PANEL)

	arg0._setDungeonLevel = arg0._debug:Find("dungeon_level")
	arg0._dungeonLevel = arg0._debug:Find("level_input"):GetComponent("InputField")

	onButton(nil, arg0._setDungeonLevel, function()
		arg0._dataProxy:SetDungeonLevel(tonumber(arg0._dungeonLevel.text))
	end, SFX_PANEL)

	arg0._clsBullet = arg0._debug:Find("cls_bullet")

	onButton(nil, arg0._clsBullet, function()
		arg0._dataProxy:CLSBullet(var2.FRIENDLY_CODE)
		arg0._dataProxy:CLSBullet(var2.FOE_CODE)
	end, SFX_PANEL)
end

function var3.initData(arg0)
	arg0._fleetList = arg0._dataProxy:GetFleetList()
	arg0._freeShipList = arg0._dataProxy:GetFreeShipList()
	arg0._monsterArray = {}

	for iter0, iter1 in ipairs(pg.enemy_data_statistics.all) do
		if type(iter1) == "number" and iter1 <= 10000000 then
			table.insert(arg0._monsterArray, iter1)
		end
	end

	function arg0._updatePlayerWeapon(arg0)
		for iter0, iter1 in pairs(arg0._fleetList) do
			iter1:UpdateAutoComponent(arg0)
		end
	end

	function arg0._updateMonsterWeapon(arg0)
		for iter0, iter1 in pairs(arg0._freeShipList) do
			iter1:UpdateWeapon(arg0)
		end
	end

	function arg0._updateMonsterAI(arg0)
		for iter0, iter1 in pairs(arg0._dataProxy._teamList) do
			if iter1:IsFatalDamage() then
				arg0._dataProxy:KillNPCTeam(iter0)
			else
				iter1:UpdateMotion()
			end
		end
	end

	arg0._autoComponentFuncList = {}
	arg0._autoComponentFuncList.updatePlayerWeapon = arg0._updatePlayerWeapon
	arg0._autoComponentFuncList.updateMonsterWeapon = arg0._updateMonsterWeapon
	arg0._autoComponentFuncList.updateMonsterAI = arg0._updateMonsterAI

	local function var0(arg0, arg1)
		for iter0, iter1 in pairs(arg0._autoComponentFuncList) do
			iter1(arg1)
		end
	end

	arg0._dataProxy.UpdateAutoComponent = var0
end

function var3.initComponent(arg0)
	arg0._base = arg0._go:Find("bg")
	arg0._common = arg0._base:Find("common")
	arg0._debug = arg0._base:Find("debug")
	arg0._exitBtn = arg0._common:Find("close")

	onButton(nil, arg0._exitBtn, function()
		arg0:SetActive(false)
	end, SFX_PANEL)

	arg0._activeReference = arg0._common:Find("reference_switch")

	onButton(nil, arg0._activeReference, function()
		arg0:activeReference()
	end, SFX_PANEL)

	arg0._lockCommonDMG = arg0._common:Find("common_damage")
	arg0._lockS2MDMG = arg0._common:Find("ship2main_damage")
	arg0._lockA2MDMG = arg0._common:Find("aircraft2main_damage")
	arg0._lockCrushDMG = arg0._common:Find("crush_damage")

	onToggle(nil, arg0._lockCommonDMG, function(arg0)
		arg0._dataProxy:SetupCalculateDamage(arg0 and var0.Battle.BattleFormulas.CalcDamageLock or nil)
	end, SFX_PANEL)
	onToggle(nil, arg0._lockS2MDMG, function(arg0)
		arg0._dataProxy:SetupDamageKamikazeAir(arg0 and var0.Battle.BattleFormulas.CalcDamageLockA2M or nil)
	end, SFX_PANEL)
	onToggle(nil, arg0._lockA2MDMG, function(arg0)
		arg0._dataProxy:SetupDamageKamikazeShip(arg0 and var0.Battle.BattleFormulas.CalcDamageLockS2M or nil)
	end, SFX_PANEL)
	onToggle(nil, arg0._lockCrushDMG, function(arg0)
		arg0._dataProxy:SetupDamageCrush(arg0 and var0.Battle.BattleFormulas.CalcDamageLockCrush or nil)
	end, SFX_PANEL)

	arg0._triggerWave = arg0._common:Find("wave_trigger")
	arg0._waveIndex = arg0._common:Find("wave_input"):GetComponent("InputField")

	if arg0._dataProxy:GetInitData().battleType ~= SYSTEM_SCENARIO and arg0._dataProxy:GetInitData().battleType ~= SYSTEM_ROUTINE and arg0._dataProxy:GetInitData().battleType ~= SYSTEM_ACT_BOSS then
		SetActive(arg0._triggerWave, false)
		SetActive(arg0._waveIndex, false)
	else
		onButton(nil, arg0._triggerWave, function()
			arg0:forceTrigger(tonumber(arg0._waveIndex.text))
		end)
	end

	arg0._triggerWeather = arg0._common:Find("weather_trigger")
	arg0._weatherInput = arg0._common:Find("weather_input"):GetComponent("InputField")

	onButton(nil, arg0._triggerWeather, function()
		arg0._dataProxy:AddWeather(tonumber(arg0._weatherInput.text))
	end)

	arg0._antiSubDetailRange = arg0._common:Find("anti_sub_detail")

	onButton(nil, arg0._antiSubDetailRange, function()
		arg0._state:GetMediatorByName("BattleSceneMediator"):InitDetailAntiSubArea()
	end)

	arg0._instantReload = arg0._common:Find("instant_reload")

	onButton(nil, arg0._instantReload, function()
		local var0 = arg0._dataProxy._fleetList[1]

		local function var1(arg0)
			local var0 = arg0:GetWeaponList()

			for iter0, iter1 in ipairs(var0) do
				iter1:QuickCoolDown()
			end
		end

		var1(var0:GetChargeWeaponVO())
		var1(var0:GetTorpedoWeaponVO())
		var1(var0:GetAirAssistVO())
	end)

	arg0._white = arg0._base:Find("white_button")

	onButton(nil, arg0._white, function()
		arg0._dataProxy._fleetList[1]._scoutList[1]:UpdateHP(-20, {})
	end, SFX_PANEL)
	SetActive(arg0._white, true)
end

function var3.SetActive(arg0, arg1)
	SetActive(arg0._go, arg1)
end

function var3.spawnEnemy(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = {
		monsterTemplateID = arg1,
		corrdinate = {
			math.random(arg2, arg3),
			0,
			math.random(arg4, arg5)
		}
	}

	var0.delay = 0
	var0.moveCast = true
	var0.score = 0
	var0.buffList = {
		8001
	}

	arg0._dataProxy:SpawnMonster(var0, 1, var1.UnitType.ENEMY_UNIT, var2.FOE_CODE)
end

function var3.spawnStrike(arg0, arg1, arg2, arg3, arg4)
	local var0 = {
		templateID = arg1,
		weaponID = {},
		attr = {},
		totalNumber = arg2,
		onceNumber = arg3
	}

	var0.formation = 10006
	var0.delay = 0
	var0.interval = 0.1
	var0.score = 0

	arg0._dataProxy:SpawnAirFighter(var0)
end

function var3.activeReference(arg0)
	arg0._state:ActiveReference()

	local var0 = arg0._state:GetMediatorByName(var0.Battle.BattleReferenceBoxMediator.__name) or arg0._state:AddMediator(var0.Battle.BattleReferenceBoxMediator.New())

	pg.TipsMgr.GetInstance():ShowTips("┏━━━━━━━━━━━━━━━━━━━┓")
	pg.TipsMgr.GetInstance():ShowTips("┃ヽ(•̀ω•́ )ゝ战斗调试模块初始化成功！(ง •̀_•́)ง┃")
	pg.TipsMgr.GetInstance():ShowTips("┗━━━━━━━━━━━━━━━━━━━┛")

	arg0._activeReference.transform:GetComponent("Button").enabled = false
	arg0._activeReference:Find("text"):GetComponent(typeof(Text)).text = "(ﾉ･ω･)ﾉﾞ"
	arg0._referenceConsole = arg0._common:Find("reference_btns")

	SetActive(arg0._referenceConsole, true)

	arg0._speedUp = arg0._referenceConsole:Find("speed_up")
	arg0._speedDown = arg0._referenceConsole:Find("speed_down")
	arg0._speedLevel = arg0._referenceConsole:Find("speed")

	onButton(nil, arg0._speedUp, function()
		local var0 = var0.Battle.BattleConfig.BASIC_TIME_SCALE

		if var0 < 1 then
			var0.Battle.BattleControllerCommand.removeSpeed(2)
		elseif var0 >= 1 then
			var0.Battle.BattleControllerCommand.addSpeed(2)
		end

		arg0._speedLevel:GetComponent(typeof(Text)).text = var0.Battle.BattleConfig.BASIC_TIME_SCALE

		arg0._state:ScaleTimer()
	end, SFX_PANEL)
	onButton(nil, arg0._speedDown, function()
		local var0 = var0.Battle.BattleConfig.BASIC_TIME_SCALE

		if var0 > 1 then
			var0.Battle.BattleControllerCommand.removeSpeed(0.5)
		elseif var0 <= 1 then
			var0.Battle.BattleControllerCommand.addSpeed(0.5)
		end

		arg0._speedLevel:GetComponent(typeof(Text)).text = var0.Battle.BattleConfig.BASIC_TIME_SCALE

		arg0._state:ScaleTimer()
	end, SFX_PANEL)

	arg0._shipBox = arg0._referenceConsole:Find("ship_box")
	arg0._bulletBox = arg0._referenceConsole:Find("bullet_box")
	arg0._pp = arg0._referenceConsole:Find("property_panel")

	onToggle(nil, arg0._shipBox, function(arg0)
		var0:ActiveUnitBoxes(arg0)
	end, SFX_PANEL)
	onToggle(nil, arg0._bulletBox, function(arg0)
		var0:ActiveBulletBoxes(arg0)
	end, SFX_PANEL)
	onToggle(nil, arg0._pp, function(arg0)
		var0:ActiveUnitDetail(arg0)
	end, SFX_PANEL)
end

function var3.forceTrigger(arg0, arg1)
	local var0 = arg0._state:GetCommandByName("BattleSingleDungeonCommand")._waveUpdater._waveInfoList[arg1]

	if var0 == nil then
		pg.TipsMgr.GetInstance():ShowTips("查无次波")
	elseif var0:GetState() ~= var0.STATE_DEACTIVE then
		pg.TipsMgr.GetInstance():ShowTips("该触发器已经触发")
	else
		var0:DoWave()
	end
end
