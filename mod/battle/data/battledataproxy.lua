ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleEvent
local var2_0 = var0_0.Battle.BattleFormulas
local var3_0 = var0_0.Battle.BattleConst
local var4_0 = var0_0.Battle.BattleConfig
local var5_0 = var0_0.Battle.BattleDataFunction
local var6_0 = var0_0.Battle.BattleAttr
local var7_0 = var0_0.Battle.BattleVariable
local var8_0 = var0_0.Battle.BattleCardPuzzleEvent
local var9_0 = singletonClass("BattleDataProxy", var0_0.MVC.Proxy)

var0_0.Battle.BattleDataProxy = var9_0
var9_0.__name = "BattleDataProxy"

function var9_0.Ctor(arg0_1)
	var9_0.super.Ctor(arg0_1)
end

function var9_0.InitBattle(arg0_2, arg1_2)
	arg0_2.Update = arg0_2.updateInit

	local var0_2 = arg1_2.battleType
	local var1_2 = var0_2 == SYSTEM_WORLD or var0_2 == SYSTEM_WORLD_BOSS
	local var2_2 = pg.SdkMgr.GetInstance():CheckPretest() and (PlayerPrefs.GetInt("stage_scratch") or 0) == 1

	arg0_2:SetupCalculateDamage(var2_2 and GodenFnger or var2_0.CreateContextCalculateDamage(var1_2))
	arg0_2:SetupDamageKamikazeAir()
	arg0_2:SetupDamageKamikazeShip()
	arg0_2:SetupDamageCrush()
	var7_0.Init()
	arg0_2:InitData(arg1_2)
	arg0_2:DispatchEvent(var0_0.Event.New(var1_0.STAGE_DATA_INIT_FINISH))
	arg0_2._cameraUtil:Initialize()

	arg0_2._cameraTop, arg0_2._cameraBottom, arg0_2._cameraLeft, arg0_2._cameraRight = arg0_2._cameraUtil:SetMapData(arg0_2:GetTotalBounds())

	arg0_2:InitWeatherData()
	arg0_2:InitUserShipsData(arg0_2._battleInitData.MainUnitList, arg0_2._battleInitData.VanguardUnitList, var4_0.FRIENDLY_CODE, arg0_2._battleInitData.SubUnitList)
	arg0_2:InitUserSupportShipsData(var4_0.FRIENDLY_CODE, arg0_2._battleInitData.SupportUnitList)
	arg0_2:InitUserAidData()
	arg0_2:SetSubmarinAidData()
	arg0_2._cameraUtil:SetFocusFleet(arg0_2:GetFleetByIFF(var4_0.FRIENDLY_CODE))
	arg0_2:StatisticsInit(arg0_2._fleetList[var4_0.FRIENDLY_CODE]:GetUnitList())
	arg0_2:SetFlagShipID(arg0_2:GetFleetByIFF(var4_0.FRIENDLY_CODE):GetFlagShip())
	arg0_2:DispatchEvent(var0_0.Event.New(var1_0.COMMON_DATA_INIT_FINISH, {}))
end

function var9_0.OnCameraRatioUpdate(arg0_3)
	arg0_3._cameraTop, arg0_3._cameraBottom, arg0_3._cameraLeft, arg0_3._cameraRight = arg0_3._cameraUtil:SetMapData(arg0_3:GetTotalBounds())

	arg0_3._cameraUtil:setArrowPoint()
end

function var9_0.Start(arg0_4)
	arg0_4._startTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var9_0.TriggerBattleInitBuffs(arg0_5)
	for iter0_5, iter1_5 in pairs(arg0_5._fleetList) do
		local var0_5 = iter1_5:GetUnitList()

		iter1_5:FleetBuffTrigger(var3_0.BuffEffectType.ON_INIT_GAME)
	end
end

function var9_0.TirggerBattleStartBuffs(arg0_6)
	for iter0_6, iter1_6 in pairs(arg0_6._fleetList) do
		local var0_6 = iter1_6:GetUnitList()
		local var1_6 = iter1_6:GetScoutList()
		local var2_6 = var1_6[1]
		local var3_6 = #var1_6 > 1 and var1_6[#var1_6] or nil
		local var4_6 = #var1_6 == 3 and var1_6[2] or nil
		local var5_6 = iter1_6:GetMainList()
		local var6_6 = var5_6[1]
		local var7_6 = var5_6[2]
		local var8_6 = var5_6[3]

		for iter2_6, iter3_6 in ipairs(var0_6) do
			underscore.each(arg0_6._battleInitData.ChapterBuffIDs or {}, function(arg0_7)
				local var0_7 = var0_0.Battle.BattleBuffUnit.New(arg0_7)

				iter3_6:AddBuff(var0_7)
			end)
			underscore.each(arg0_6._battleInitData.GlobalBuffIDs or {}, function(arg0_8)
				arg0_8 = tonumber(arg0_8)

				local var0_8 = var0_0.Battle.BattleBuffUnit.New(arg0_8)

				iter3_6:AddBuff(var0_8)
			end)

			if arg0_6._battleInitData.MapAuraSkills then
				for iter4_6, iter5_6 in ipairs(arg0_6._battleInitData.MapAuraSkills) do
					local var9_6 = var0_0.Battle.BattleBuffUnit.New(iter5_6.id, iter5_6.level)

					iter3_6:AddBuff(var9_6)
				end
			end

			if arg0_6._battleInitData.MapAidSkills then
				for iter6_6, iter7_6 in ipairs(arg0_6._battleInitData.MapAidSkills) do
					local var10_6 = var0_0.Battle.BattleBuffUnit.New(iter7_6.id, iter7_6.level)

					iter3_6:AddBuff(var10_6)
				end
			end

			if arg0_6._currentStageData.stageBuff then
				for iter8_6, iter9_6 in ipairs(arg0_6._currentStageData.stageBuff) do
					local var11_6 = var0_0.Battle.BattleBuffUnit.New(iter9_6.id, iter9_6.level)

					iter3_6:AddBuff(var11_6)
				end
			end

			iter3_6:TriggerBuff(var3_0.BuffEffectType.ON_START_GAME)

			if iter3_6 == var6_6 then
				iter3_6:TriggerBuff(var3_0.BuffEffectType.ON_FLAG_SHIP)
			elseif iter3_6 == var7_6 then
				iter3_6:TriggerBuff(var3_0.BuffEffectType.ON_UPPER_CONSORT)
			elseif iter3_6 == var8_6 then
				iter3_6:TriggerBuff(var3_0.BuffEffectType.ON_LOWER_CONSORT)
			elseif iter3_6 == var2_6 then
				iter3_6:TriggerBuff(var3_0.BuffEffectType.ON_LEADER)
			elseif iter3_6 == var4_6 then
				iter3_6:TriggerBuff(var3_0.BuffEffectType.ON_CENTER)
			elseif iter3_6 == var3_6 then
				iter3_6:TriggerBuff(var3_0.BuffEffectType.ON_REAR)
			end
		end

		local var12_6 = iter1_6:GetSupportUnitList()

		for iter10_6, iter11_6 in ipairs(var12_6) do
			underscore.each(arg0_6._battleInitData.ChapterBuffIDs or {}, function(arg0_9)
				if var5_0.GetSLGStrategyBuffByCombatBuffID(arg0_9).type == ChapterConst.AirDominanceStrategyBuffType then
					local var0_9 = var0_0.Battle.BattleBuffUnit.New(arg0_9)

					iter11_6:AddBuff(var0_9)
				end
			end)
		end
	end
end

function var9_0.InitAllFleetUnitsWeaponCD(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10._fleetList) do
		local var0_10 = iter1_10:GetUnitList()

		for iter2_10, iter3_10 in ipairs(var0_10) do
			var9_0.InitUnitWeaponCD(iter3_10)
		end
	end
end

function var9_0.InitUnitWeaponCD(arg0_11)
	arg0_11:CheckWeaponInitial()
end

function var9_0.StartCardPuzzle(arg0_12)
	for iter0_12, iter1_12 in pairs(arg0_12._fleetList) do
		iter1_12:GetCardPuzzleComponent():Start()
	end
end

function var9_0.PausePuzzleComponent(arg0_13)
	for iter0_13, iter1_13 in pairs(arg0_13._fleetList) do
		local var0_13 = iter1_13:GetCardPuzzleComponent()

		if var0_13 then
			var0_13:BlockComponentByCard(true)
		end
	end
end

function var9_0.ResumePuzzleComponent(arg0_14)
	onDelayTick(function()
		for iter0_15, iter1_15 in pairs(arg0_14._fleetList) do
			local var0_15 = iter1_15:GetCardPuzzleComponent()

			if var0_15 then
				var0_15:BlockComponentByCard(false)
			end
		end
	end, 0.06)
end

function var9_0.GetInitData(arg0_16)
	return arg0_16._battleInitData
end

function var9_0.GetDungeonData(arg0_17)
	return arg0_17._dungeonInfo
end

function var9_0.InitData(arg0_18, arg1_18)
	arg0_18.FrameIndex = 1
	arg0_18._friendlyCode = 1
	arg0_18._foeCode = -1
	var3_0.FRIENDLY_CODE = 1
	var3_0.FOE_CODE = -1
	arg0_18._completelyRepress = false
	arg0_18._repressReduce = 1
	arg0_18._repressLevel = 0
	arg0_18._repressEnemyHpRant = 1
	arg0_18._friendlyShipList = {}
	arg0_18._foeShipList = {}
	arg0_18._friendlyAircraftList = {}
	arg0_18._foeAircraftList = {}
	arg0_18._minionShipList = {}
	arg0_18._spectreShipList = {}
	arg0_18._fleetList = {}
	arg0_18._freeShipList = {}
	arg0_18._teamList = {}
	arg0_18._waveSummonList = {}
	arg0_18._aidUnitList = {}
	arg0_18._unitList = {}
	arg0_18._unitCount = 0
	arg0_18._bulletList = {}
	arg0_18._bulletCount = 0
	arg0_18._aircraftList = {}
	arg0_18._aircraftCount = 0
	arg0_18._AOEList = {}
	arg0_18._AOECount = 0
	arg0_18._wallList = {}
	arg0_18._wallIndex = 0
	arg0_18._shelterList = {}
	arg0_18._shelterIndex = 0
	arg0_18._environmentList = {}
	arg0_18._environmentIndex = 0
	arg0_18._deadUnitList = {}
	arg0_18._enemySubmarineCount = 0
	arg0_18._airFighterList = {}
	arg0_18._currentStageIndex = 1
	arg0_18._battleInitData = arg1_18
	arg0_18._expeditionID = arg1_18.StageTmpId
	arg0_18._expeditionTmp = pg.expedition_data_template[arg0_18._expeditionID]

	arg0_18:SetDungeonLevel(arg1_18.WorldLevel or arg0_18._expeditionTmp.level)

	arg0_18._dungeonID = arg0_18._expeditionTmp.dungeon_id
	arg0_18._dungeonInfo = var5_0.GetDungeonTmpDataByID(arg0_18._dungeonID)

	if arg1_18.WorldMapId then
		arg0_18._mapId = arg1_18.WorldMapId
	elseif arg0_18._expeditionTmp.map_id then
		local var0_18 = arg0_18._expeditionTmp.map_id

		if #var0_18 == 1 then
			arg0_18._mapId = var0_18[1][1]
		else
			local var1_18 = {}

			for iter0_18, iter1_18 in ipairs(var0_18) do
				local var2_18 = iter1_18[2] * 100

				table.insert(var1_18, {
					rst = iter1_18[1],
					weight = var2_18
				})
			end

			arg0_18._mapId = var2_0.WeightRandom(var1_18)
		end
	end

	arg0_18._weahter = arg1_18.ChapterWeatherIDS or {}
	arg0_18._exposeSpeed = arg0_18._expeditionTmp.expose_speed
	arg0_18._airExpose = arg0_18._expeditionTmp.aircraft_expose[1]
	arg0_18._airExposeEX = arg0_18._expeditionTmp.aircraft_expose[2]
	arg0_18._shipExpose = arg0_18._expeditionTmp.ship_expose[1]
	arg0_18._shipExposeEX = arg0_18._expeditionTmp.ship_expose[2]
	arg0_18._commander = arg1_18.CommanderList or {}
	arg0_18._subCommander = arg1_18.SubCommanderList or {}
	arg0_18._commanderBuff = arg0_18.initCommanderBuff(arg0_18._commander)
	arg0_18._subCommanderBuff = arg0_18.initCommanderBuff(arg0_18._subCommander)

	if arg0_18._battleInitData.RepressInfo then
		local var3_18 = arg0_18._battleInitData.RepressInfo

		if arg0_18._battleInitData.battleType == SYSTEM_SCENARIO then
			if var3_18.repressCount >= var3_18.repressMax then
				arg0_18._completelyRepress = true
			end

			arg0_18._repressReduce = var2_0.ChapterRepressReduce(var3_18.repressReduce)
			arg0_18._repressLevel = var3_18.repressLevel
			arg0_18._repressEnemyHpRant = var3_18.repressEnemyHpRant
		elseif arg0_18._battleInitData.battleType == SYSTEM_WORLD or arg0_18._battleInitData.battleType == SYSTEM_WORLD_BOSS then
			arg0_18._repressEnemyHpRant = var3_18.repressEnemyHpRant
		end
	end

	arg0_18._chapterWinningStreak = arg0_18._battleInitData.DefeatCount or 0
	arg0_18._waveFlags = table.shallowCopy(arg1_18.StageWaveFlags) or {}

	arg0_18:InitStageData()

	arg0_18._cldSystem = var0_0.Battle.BattleCldSystem.New(arg0_18)
	arg0_18._cameraUtil = var0_0.Battle.BattleCameraUtil.GetInstance()

	arg0_18:initBGM()
end

function var9_0.initBGM(arg0_19)
	arg0_19._initBGMList = {}
	arg0_19._otherBGMList = {}

	local var0_19 = {}
	local var1_19 = {}

	local function var2_19(arg0_20)
		for iter0_20, iter1_20 in ipairs(arg0_20) do
			local var0_20 = {}

			if iter1_20.skills then
				for iter2_20, iter3_20 in ipairs(iter1_20.skills) do
					table.insert(var0_20, iter3_20)
				end
			end

			if iter1_20.equipment then
				local var1_20 = var5_0.GetEquipSkill(iter1_20.equipment, arg0_19._battleInitData.battleType)

				for iter4_20, iter5_20 in ipairs(var1_20) do
					var0_20[iter5_20] = {
						level = 1,
						id = iter5_20
					}
				end
			end

			local var2_20 = var5_0.GetSongList(var0_20)

			for iter6_20, iter7_20 in pairs(var2_20.initList) do
				var0_19[iter6_20] = true
			end

			for iter8_20, iter9_20 in pairs(var2_20.otherList) do
				var1_19[iter8_20] = true
			end
		end
	end

	var2_19(arg0_19._battleInitData.MainUnitList)
	var2_19(arg0_19._battleInitData.VanguardUnitList)
	var2_19(arg0_19._battleInitData.SubUnitList)

	if arg0_19._battleInitData.RivalMainUnitList then
		var2_19(arg0_19._battleInitData.RivalMainUnitList)
	end

	if arg0_19._battleInitData.RivalVanguardUnitList then
		var2_19(arg0_19._battleInitData.RivalVanguardUnitList)
	end

	for iter0_19, iter1_19 in pairs(var0_19) do
		table.insert(arg0_19._initBGMList, iter0_19)
	end

	for iter2_19, iter3_19 in pairs(var1_19) do
		table.insert(arg0_19._otherBGMList, iter2_19)
	end
end

function var9_0.initCommanderBuff(arg0_21)
	local var0_21 = {}

	for iter0_21, iter1_21 in ipairs(arg0_21) do
		local var1_21 = iter1_21[1]
		local var2_21 = var1_21:getSkills()[1]:getLevel()

		for iter2_21, iter3_21 in ipairs(iter1_21[2]) do
			table.insert(var0_21, {
				id = iter3_21,
				level = var2_21,
				commander = var1_21
			})
		end
	end

	return var0_21
end

function var9_0.Clear(arg0_22)
	for iter0_22, iter1_22 in pairs(arg0_22._teamList) do
		arg0_22:KillNPCTeam(iter1_22)
	end

	arg0_22._teamList = nil

	for iter2_22, iter3_22 in pairs(arg0_22._bulletList) do
		arg0_22:RemoveBulletUnit(iter2_22)
	end

	arg0_22._bulletList = nil

	for iter4_22, iter5_22 in pairs(arg0_22._unitList) do
		arg0_22:KillUnit(iter4_22)
	end

	arg0_22._unitList = nil

	for iter6_22, iter7_22 in ipairs(arg0_22._deadUnitList) do
		iter7_22:Dispose()
	end

	arg0_22._deadUnitList = nil

	for iter8_22, iter9_22 in pairs(arg0_22._aircraftList) do
		arg0_22:KillAircraft(iter8_22)
	end

	arg0_22._aircraftList = nil

	for iter10_22, iter11_22 in pairs(arg0_22._fleetList) do
		iter11_22:Dispose()

		arg0_22._fleetList[iter10_22] = nil
	end

	arg0_22._fleetList = nil

	for iter12_22, iter13_22 in pairs(arg0_22._aidUnitList) do
		iter13_22:Dispose()
	end

	arg0_22._aidUnitList = nil

	for iter14_22, iter15_22 in pairs(arg0_22._environmentList) do
		arg0_22:RemoveEnvironment(iter15_22:GetUniqueID())
	end

	arg0_22._environmentList = nil

	for iter16_22, iter17_22 in pairs(arg0_22._AOEList) do
		arg0_22:RemoveAreaOfEffect(iter16_22)
	end

	arg0_22._AOEList = nil

	arg0_22._cldSystem:Dispose()

	arg0_22._cldSystem = nil
	arg0_22._dungeonInfo = nil
	arg0_22._flagShipUnit = nil
	arg0_22._friendlyShipList = nil
	arg0_22._foeShipList = nil
	arg0_22._spectreShipList = nil
	arg0_22._friendlyAircraftList = nil
	arg0_22._foeAircraftList = nil
	arg0_22._fleetList = nil
	arg0_22._freeShipList = nil
	arg0_22._countDown = nil
	arg0_22._lastUpdateTime = nil
	arg0_22._statistics = nil
	arg0_22._battleInitData = nil
	arg0_22._currentStageData = nil

	arg0_22:ClearFormulas()
	var5_0.ClearDungeonCfg(arg0_22._dungeonID)
end

function var9_0.DeactiveProxy(arg0_23)
	arg0_23._state = nil

	arg0_23:Clear()
	var0_0.Battle.BattleDataProxy.super.DeactiveProxy(arg0_23)
end

function var9_0.InitUserShipsData(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24)
	for iter0_24, iter1_24 in ipairs(arg2_24) do
		local var0_24 = arg0_24:SpawnVanguard(iter1_24, arg3_24)
	end

	for iter2_24, iter3_24 in ipairs(arg1_24) do
		local var1_24 = arg0_24:SpawnMain(iter3_24, arg3_24)
	end

	local var2_24 = arg0_24:GetFleetByIFF(arg3_24)

	var2_24:FleetUnitSpwanFinish()

	local var3_24 = arg0_24._battleInitData.battleType

	if var3_24 == SYSTEM_SUBMARINE_RUN or var3_24 == SYSTEM_SUB_ROUTINE then
		for iter4_24, iter5_24 in ipairs(arg4_24) do
			arg0_24:SpawnManualSub(iter5_24, arg3_24)
		end

		var2_24:ShiftManualSub()
	else
		var2_24:SetSubUnitData(arg4_24)
	end

	if arg0_24._battleInitData.battleType == SYSTEM_DUEL then
		for iter6_24, iter7_24 in ipairs(var2_24:GetCloakList()) do
			iter7_24:GetCloak():SetRecoverySpeed(0)
		end
	end

	arg0_24:DispatchEvent(var0_0.Event.New(var1_0.ADD_FLEET, {
		fleetVO = var2_24
	}))
end

function var9_0.InitUserSupportShipsData(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25:GetFleetByIFF(arg1_25)

	for iter0_25, iter1_25 in ipairs(arg2_25) do
		local var1_25 = arg0_25:SpawnSupportUnit(iter1_25, arg1_25)
	end
end

function var9_0.InitUserAidData(arg0_26)
	for iter0_26, iter1_26 in ipairs(arg0_26._battleInitData.AidUnitList) do
		local var0_26 = arg0_26:GenerateUnitID()
		local var1_26 = iter1_26.properties

		var1_26.level = iter1_26.level
		var1_26.formationID = var4_0.FORMATION_ID
		var1_26.id = iter1_26.id

		var2_0.AttrFixer(arg0_26._battleInitData.battleType, var1_26)

		local var2_26 = iter1_26.proficiency or {
			1,
			1,
			1
		}
		local var3_26 = var5_0.CreateBattleUnitData(var0_26, var3_0.UnitType.PLAYER_UNIT, var4_0.FRIENDLY_CODE, iter1_26.tmpID, iter1_26.skinId, iter1_26.equipment, var1_26, iter1_26.baseProperties, var2_26, iter1_26.baseList, iter1_26.preloasList)

		arg0_26._aidUnitList[var3_26:GetUniqueID()] = var3_26
	end
end

function var9_0.SetSubmarinAidData(arg0_27)
	arg0_27:GetFleetByIFF(var4_0.FRIENDLY_CODE):SetSubAidData(arg0_27._battleInitData.TotalSubAmmo, arg0_27._battleInitData.SubFlag)
end

function var9_0.AddWeather(arg0_28, arg1_28)
	table.insert(arg0_28._weahter, arg1_28)
	arg0_28:InitWeatherData()
end

function var9_0.InitWeatherData(arg0_29)
	for iter0_29, iter1_29 in ipairs(arg0_29._weahter) do
		if iter1_29 == var3_0.WEATHER.NIGHT then
			for iter2_29, iter3_29 in pairs(arg0_29._fleetList) do
				iter3_29:AttachNightCloak()
			end

			for iter4_29, iter5_29 in pairs(arg0_29._unitList) do
				var5_0.AttachWeather(iter5_29, arg0_29._weahter)
			end
		end
	end
end

function var9_0.CelebrateVictory(arg0_30, arg1_30)
	local var0_30

	if arg1_30 == arg0_30:GetFoeCode() then
		var0_30 = arg0_30._foeShipList
	else
		var0_30 = arg0_30._friendlyShipList
	end

	for iter0_30, iter1_30 in pairs(var0_30) do
		iter1_30:StateChange(var0_0.Battle.UnitState.STATE_VICTORY)
	end
end

function var9_0.InitStageData(arg0_31)
	arg0_31._currentStageData = arg0_31._dungeonInfo.stages[arg0_31._currentStageIndex]
	arg0_31._countDown = arg0_31._currentStageData.timeCount

	local var0_31 = arg0_31._currentStageData.totalArea

	arg0_31._totalLeftBound = var0_31[1]
	arg0_31._totalRightBound = var0_31[1] + var0_31[3]
	arg0_31._totalUpperBound = var0_31[2] + var0_31[4]
	arg0_31._totalLowerBound = var0_31[2]

	local var1_31 = arg0_31._currentStageData.playerArea

	arg0_31._leftZoneLeftBound = var1_31[1]
	arg0_31._leftZoneRightBound = var1_31[1] + var1_31[3]
	arg0_31._leftZoneUpperBound = var1_31[2] + var1_31[4]
	arg0_31._leftZoneLowerBound = var1_31[2]
	arg0_31._rightZoneLeftBound = arg0_31._leftZoneRightBound
	arg0_31._rightZoneRightBound = arg0_31._totalRightBound
	arg0_31._rightZoneUpperBound = arg0_31._leftZoneUpperBound
	arg0_31._rightZoneLowerBound = arg0_31._leftZoneLowerBound
	arg0_31._bulletUpperBound = arg0_31._totalUpperBound + 3
	arg0_31._bulletLowerBound = arg0_31._totalLowerBound - 10
	arg0_31._bulletLeftBound = arg0_31._totalLeftBound - 10
	arg0_31._bulletRightBound = arg0_31._totalRightBound + 10
	arg0_31._bulletUpperBoundVision = arg0_31._totalUpperBound + var4_0.BULLET_UPPER_BOUND_VISION_OFFSET
	arg0_31._bulletLowerBoundSplit = arg0_31._bulletLowerBound + var4_0.BULLET_LOWER_BOUND_SPLIT_OFFSET
	arg0_31._bulletLeftBoundSplit = arg0_31._bulletLeftBound + var4_0.BULLET_LEFT_BOUND_SPLIT_OFFSET

	if arg0_31._battleInitData.battleType == SYSTEM_DUEL then
		arg0_31._leftFieldBound = arg0_31._totalLeftBound
		arg0_31._rightFieldBound = arg0_31._totalRightBound
	else
		local var2_31

		if arg0_31._currentStageData.mainUnitPosition and arg0_31._currentStageData.mainUnitPosition[var4_0.FRIENDLY_CODE] then
			var2_31 = arg0_31._currentStageData.mainUnitPosition[var4_0.FRIENDLY_CODE][1].x
		else
			var2_31 = var4_0.MAIN_UNIT_POS[var4_0.FRIENDLY_CODE][1].x
		end

		arg0_31._leftFieldBound = var2_31 - 1
		arg0_31._rightFieldBound = arg0_31._totalRightBound + var4_0.FIELD_RIGHT_BOUND_BIAS
	end
end

function var9_0.GetVanguardBornCoordinate(arg0_32, arg1_32)
	if arg1_32 == var4_0.FRIENDLY_CODE then
		return arg0_32._currentStageData.fleetCorrdinate
	elseif arg1_32 == var4_0.FOE_CODE then
		return arg0_32._currentStageData.rivalCorrdinate
	end
end

function var9_0.GetTotalBounds(arg0_33)
	return arg0_33._totalUpperBound, arg0_33._totalLowerBound, arg0_33._totalLeftBound, arg0_33._totalRightBound
end

function var9_0.GetTotalRightBound(arg0_34)
	return arg0_34._totalRightBound
end

function var9_0.GetTotalLowerBound(arg0_35)
	return arg0_35._totalLowerBound
end

function var9_0.GetUnitBoundByIFF(arg0_36, arg1_36)
	if arg1_36 == var4_0.FRIENDLY_CODE then
		return arg0_36._leftZoneUpperBound, arg0_36._leftZoneLowerBound, arg0_36._leftZoneLeftBound, var4_0.MaxRight, var4_0.MaxLeft, arg0_36._leftZoneRightBound
	elseif arg1_36 == var4_0.FOE_CODE then
		return arg0_36._rightZoneUpperBound, arg0_36._rightZoneLowerBound, arg0_36._rightZoneLeftBound, arg0_36._rightZoneRightBound, arg0_36._rightZoneLeftBound, var4_0.MaxRight
	end
end

function var9_0.GetFleetBoundByIFF(arg0_37, arg1_37)
	if arg1_37 == var4_0.FRIENDLY_CODE then
		return arg0_37._leftZoneUpperBound, arg0_37._leftZoneLowerBound, arg0_37._leftZoneLeftBound, arg0_37._leftZoneRightBound
	elseif arg1_37 == var4_0.FOE_CODE then
		return arg0_37._rightZoneUpperBound, arg0_37._rightZoneLowerBound, arg0_37._rightZoneLeftBound, arg0_37._rightZoneRightBound
	end
end

function var9_0.ShiftFleetBound(arg0_38, arg1_38, arg2_38)
	arg1_38:GetUnitBound():SwtichDuelAggressive()
	arg1_38:SetAutobotBound(arg0_38:GetFleetBoundByIFF(arg2_38))
	arg1_38:UpdateScoutUnitBound()
end

function var9_0.GetFieldBound(arg0_39)
	if arg0_39._battleInitData and arg0_39._battleInitData.battleType == SYSTEM_DUEL then
		return arg0_39:GetTotalBounds()
	else
		return arg0_39._totalUpperBound, arg0_39._totalLowerBound, arg0_39._leftFieldBound, arg0_39._rightFieldBound
	end
end

function var9_0.GetFleetByIFF(arg0_40, arg1_40)
	if arg0_40._fleetList[arg1_40] == nil then
		local var0_40 = var0_0.Battle.BattleFleetVO.New(arg1_40)

		arg0_40._fleetList[arg1_40] = var0_40

		var0_40:SetAutobotBound(arg0_40:GetFleetBoundByIFF(arg1_40))
		var0_40:SetTotalBound(arg0_40:GetTotalBounds())
		var0_40:SetUnitBound(arg0_40._currentStageData.totalArea, arg0_40._currentStageData.playerArea)
		var0_40:SetExposeLine(arg0_40._expeditionTmp.horizon_line[arg1_40], arg0_40._expeditionTmp.expose_line[arg1_40])
		var0_40:CalcSubmarineBaseLine(arg0_40._battleInitData.battleType)

		if arg0_40._battleInitData.battleType == SYSTEM_CARDPUZZLE then
			local var1_40 = var0_40:AttachCardPuzzleComponent()
			local var2_40 = {
				cardList = arg0_40._battleInitData.CardPuzzleCardIDList,
				commonHP = arg0_40._battleInitData.CardPuzzleCommonHPValue,
				relicList = arg0_40._battleInitData.CardPuzzleRelicList
			}

			var1_40:InitCardPuzzleData(var2_40)
			var1_40:CustomConfigID(arg0_40._battleInitData.CardPuzzleCombatID)
			arg0_40:DispatchEvent(var0_0.Event.New(var8_0.CARD_PUZZLE_INIT))
		end
	end

	return arg0_40._fleetList[arg1_40]
end

function var9_0.GetAidUnit(arg0_41)
	return arg0_41._aidUnitList
end

function var9_0.GetFleetList(arg0_42)
	return arg0_42._fleetList
end

function var9_0.GetEnemySubmarineCount(arg0_43)
	return arg0_43._enemySubmarineCount
end

function var9_0.GetCommander(arg0_44)
	return arg0_44._commander
end

function var9_0.GetCommanderBuff(arg0_45)
	return arg0_45._commanderBuff, arg0_45._subCommanderBuff
end

function var9_0.GetStageInfo(arg0_46)
	return arg0_46._currentStageData
end

function var9_0.GetWinningStreak(arg0_47)
	return arg0_47._chapterWinningStreak
end

function var9_0.GetBGMList(arg0_48, arg1_48)
	if not arg1_48 then
		return arg0_48._initBGMList
	else
		return arg0_48._otherBGMList
	end
end

function var9_0.GetDungeonLevel(arg0_49)
	return arg0_49._dungeonLevel
end

function var9_0.SetDungeonLevel(arg0_50, arg1_50)
	arg0_50._dungeonLevel = arg1_50
end

function var9_0.IsCompletelyRepress(arg0_51)
	return arg0_51._completelyRepress
end

function var9_0.GetRepressReduce(arg0_52)
	return arg0_52._repressReduce
end

function var9_0.GetRepressLevel(arg0_53)
	return arg0_53._repressLevel
end

function var9_0.updateInit(arg0_54, arg1_54)
	arg0_54:TriggerBattleInitBuffs()

	arg0_54.checkCld = true

	arg0_54:updateLoop(arg1_54)

	arg0_54.Update = arg0_54.updateLoop
end

function var9_0.updateLoop(arg0_55, arg1_55)
	arg0_55.FrameIndex = arg0_55.FrameIndex + 1

	arg0_55:updateDeadList()
	arg0_55:UpdateCountDown(arg1_55)
	arg0_55:UpdateWeather(arg1_55)

	for iter0_55, iter1_55 in pairs(arg0_55._fleetList) do
		iter1_55:UpdateMotion()
	end

	arg0_55.checkCld = not arg0_55.checkCld

	local var0_55 = {
		[var4_0.FRIENDLY_CODE] = arg0_55._totalLeftBound,
		[var4_0.FOE_CODE] = arg0_55._totalRightBound
	}

	for iter2_55, iter3_55 in pairs(arg0_55._unitList) do
		if iter3_55:IsSpectre() then
			if iter3_55:GetAttrByName(var0_0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY) <= var4_0.FUSION_ELEMENT_UNIT_TYPE then
				-- block empty
			else
				iter3_55:Update(arg1_55)
			end
		else
			if arg0_55.checkCld then
				arg0_55._cldSystem:UpdateShipCldTree(iter3_55)
			end

			if iter3_55:IsAlive() then
				iter3_55:Update(arg1_55)
			end

			local var1_55 = iter3_55:GetPosition().x
			local var2_55 = iter3_55:GetIFF()

			if var2_55 == var4_0.FRIENDLY_CODE then
				var0_55[var2_55] = math.max(var0_55[var2_55], var1_55)
			elseif var2_55 == var4_0.FOE_CODE then
				var0_55[var2_55] = math.min(var0_55[var2_55], var1_55)
			end
		end
	end

	local var3_55 = arg0_55._fleetList[var4_0.FRIENDLY_CODE]
	local var4_55 = var3_55:GetFleetExposeLine()
	local var5_55 = var3_55:GetFleetVisionLine()
	local var6_55 = var0_55[var4_0.FOE_CODE]

	if var4_55 and var6_55 < var4_55 then
		var3_55:CloakFatalExpose()
	elseif var6_55 < var5_55 then
		var3_55:CloakInVision(arg0_55._exposeSpeed)
	else
		var3_55:CloakOutVision()
	end

	if arg0_55._fleetList[var4_0.FOE_CODE] then
		local var7_55 = arg0_55._fleetList[var4_0.FOE_CODE]
		local var8_55 = var7_55:GetFleetExposeLine()
		local var9_55 = var7_55:GetFleetVisionLine()
		local var10_55 = var0_55[var4_0.FRIENDLY_CODE]

		if var8_55 and var8_55 < var10_55 then
			var7_55:CloakFatalExpose()
		elseif var9_55 < var10_55 then
			var7_55:CloakInVision(arg0_55._exposeSpeed)
		else
			var7_55:CloakOutVision()
		end
	end

	for iter4_55, iter5_55 in pairs(arg0_55._bulletList) do
		local var11_55 = iter5_55:GetSpeed()
		local var12_55 = iter5_55:GetPosition()
		local var13_55 = iter5_55:GetType()
		local var14_55 = iter5_55:GetOutBound()

		if var14_55 == var3_0.BulletOutBound.SPLIT and var13_55 == var3_0.BulletType.SHRAPNEL and (var12_55.x > arg0_55._bulletRightBound and var11_55.x > 0 or var12_55.x < arg0_55._bulletLeftBoundSplit and var11_55.x < 0 or var12_55.z > arg0_55._bulletUpperBound and var11_55.z > 0 or var12_55.z < arg0_55._bulletLowerBoundSplit and var11_55.z < 0) then
			if iter5_55:GetExist() then
				iter5_55:OutRange()
			else
				arg0_55:RemoveBulletUnit(iter5_55:GetUniqueID())
			end
		elseif var14_55 == var3_0.BulletOutBound.COMMON and (var12_55.x > arg0_55._bulletRightBound and var11_55.x > 0 or var12_55.z < arg0_55._bulletLowerBound and var11_55.z < 0) then
			arg0_55:RemoveBulletUnit(iter5_55:GetUniqueID())
		elseif var12_55.x < arg0_55._bulletLeftBound and var11_55.x < 0 and var13_55 ~= var3_0.BulletType.BOMB then
			if var14_55 == var3_0.BulletOutBound.RANDOM then
				local var15_55 = arg0_55._fleetList[var4_0.FRIENDLY_CODE]:RandomMainVictim()

				if var15_55 then
					arg0_55:HandleDamage(iter5_55, var15_55)
				end
			end

			arg0_55:RemoveBulletUnit(iter5_55:GetUniqueID())
		else
			iter5_55:Update(arg1_55)

			local var16_55 = iter5_55.GetCurrentState and iter5_55:GetCurrentState() or nil

			if var16_55 == var0_0.Battle.BattleShrapnelBulletUnit.STATE_FINAL_SPLIT then
				-- block empty
			elseif var16_55 == var0_0.Battle.BattleShrapnelBulletUnit.STATE_SPLIT and not iter5_55:IsFragile() then
				-- block empty
			elseif var14_55 == var3_0.BulletOutBound.COMMON and var12_55.z > arg0_55._bulletUpperBound and var11_55.z > 0 or var14_55 == var3_0.BulletOutBound.VISION and var12_55.z > arg0_55._bulletUpperBoundVision and var11_55.z > 0 or iter5_55:IsOutRange(arg1_55) then
				if iter5_55:GetExist() then
					iter5_55:OutRange()
				else
					arg0_55:RemoveBulletUnit(iter5_55:GetUniqueID())
				end
			elseif arg0_55.checkCld then
				arg0_55._cldSystem:UpdateBulletCld(iter5_55)
			end
		end
	end

	for iter6_55, iter7_55 in pairs(arg0_55._aircraftList) do
		iter7_55:Update(arg1_55)

		local var17_55, var18_55 = iter7_55:GetIFF()

		if var17_55 == var4_0.FRIENDLY_CODE then
			var18_55 = arg0_55._totalRightBound
		elseif var17_55 == var4_0.FOE_CODE then
			var18_55 = arg0_55._totalLeftBound
		end

		if iter7_55:GetPosition().x * var17_55 > math.abs(var18_55) and iter7_55:GetSpeed().x * var17_55 > 0 then
			iter7_55:OutBound()
		else
			arg0_55._cldSystem:UpdateAircraftCld(iter7_55)
		end

		if not iter7_55:IsAlive() then
			arg0_55:KillAircraft(iter7_55:GetUniqueID())
		end
	end

	for iter8_55, iter9_55 in pairs(arg0_55._AOEList) do
		arg0_55._cldSystem:UpdateAOECld(iter9_55)
		iter9_55:Settle()

		if iter9_55:GetActiveFlag() == false then
			iter9_55:SettleFinale()
			arg0_55:RemoveAreaOfEffect(iter9_55:GetUniqueID())
		end
	end

	for iter10_55, iter11_55 in pairs(arg0_55._environmentList) do
		iter11_55:Update()

		if iter11_55:IsExpire(arg1_55) then
			arg0_55:RemoveEnvironment(iter11_55:GetUniqueID())
		end
	end

	if arg0_55.checkCld then
		for iter12_55, iter13_55 in pairs(arg0_55._shelterList) do
			if not iter13_55:IsWallActive() then
				arg0_55:RemoveShelter(iter13_55:GetUniqueID())
			else
				iter13_55:Update(arg1_55)
			end
		end

		for iter14_55, iter15_55 in pairs(arg0_55._wallList) do
			if iter15_55:IsActive() then
				arg0_55._cldSystem:UpdateWallCld(iter15_55)
			end
		end
	end

	if arg0_55._battleInitData.battleType ~= SYSTEM_DUEL then
		for iter16_55, iter17_55 in pairs(arg0_55._foeShipList) do
			if iter17_55:GetPosition().x + iter17_55:GetBoxSize().x < arg0_55._leftZoneLeftBound then
				iter17_55:SetDeathReason(var3_0.UnitDeathReason.TOUCHDOWN)
				iter17_55:DeadAction()
				arg0_55:KillUnit(iter17_55:GetUniqueID())
				arg0_55:HandleShipMissDamage(iter17_55, arg0_55._fleetList[var4_0.FRIENDLY_CODE])
			end
		end
	end
end

function var9_0.UpdateAutoComponent(arg0_56, arg1_56)
	for iter0_56, iter1_56 in pairs(arg0_56._fleetList) do
		iter1_56:UpdateAutoComponent(arg1_56)
	end

	for iter2_56, iter3_56 in pairs(arg0_56._teamList) do
		if iter3_56:IsFatalDamage() then
			arg0_56:KillNPCTeam(iter2_56)
		else
			iter3_56:UpdateMotion()
		end
	end

	for iter4_56, iter5_56 in pairs(arg0_56._freeShipList) do
		iter5_56:UpdateOxygen(arg1_56)
		iter5_56:UpdateWeapon(arg1_56)
		iter5_56:UpdatePhaseSwitcher()
	end
end

function var9_0.UpdateWeather(arg0_57, arg1_57)
	for iter0_57, iter1_57 in ipairs(arg0_57._weahter) do
		if iter1_57 == var3_0.WEATHER.NIGHT then
			local var0_57 = {
				[var4_0.FRIENDLY_CODE] = 0,
				[var4_0.FOE_CODE] = 0
			}
			local var1_57 = {
				[var4_0.FRIENDLY_CODE] = 0,
				[var4_0.FOE_CODE] = 0
			}
			local var2_57 = {
				[var4_0.FRIENDLY_CODE] = 0,
				[var4_0.FOE_CODE] = 0
			}

			for iter2_57, iter3_57 in pairs(arg0_57._unitList) do
				local var3_57 = iter3_57:GetAimBias()

				if not var3_57 or var3_57:GetCurrentState() ~= var3_57.STATE_SUMMON_SICKNESS then
					local var4_57 = iter3_57:GetIFF()
					local var5_57 = var1_57[var4_57]
					local var6_57 = var6_0.GetCurrent(iter3_57, "attackRating")
					local var7_57 = var6_0.GetCurrent(iter3_57, "aimBiasExtraACC")

					var1_57[var4_57] = math.max(var5_57, var6_57)
					var2_57[var4_57] = var2_57[var4_57] + var7_57

					if ShipType.ContainInLimitBundle(ShipType.BundleAntiSubmarine, iter3_57:GetTemplate().type) then
						var0_57[var4_57] = math.max(var0_57[var4_57], var6_57)
					end
				end
			end

			for iter4_57, iter5_57 in pairs(arg0_57._fleetList) do
				local var8_57 = iter5_57:GetFleetBias()
				local var9_57 = iter4_57 * -1

				var8_57:SetDecayFactor(var1_57[var9_57], var2_57[var9_57])
				var8_57:Update(arg1_57)

				for iter6_57, iter7_57 in ipairs(iter5_57:GetSubList()) do
					local var10_57 = iter7_57:GetAimBias()

					if var10_57:GetDecayFactorType() == var10_57.DIVING then
						var10_57:SetDecayFactor(var0_57[var9_57], var2_57[var9_57])
					else
						var10_57:SetDecayFactor(var1_57[var9_57], var2_57[var9_57])
					end

					var10_57:Update(arg1_57)
				end
			end

			for iter8_57, iter9_57 in pairs(arg0_57._freeShipList) do
				local var11_57 = iter9_57:GetIFF() * -1
				local var12_57 = iter9_57:GetAimBias()

				if var12_57:GetDecayFactorType() == var12_57.DIVING then
					var12_57:SetDecayFactor(var0_57[var11_57], var2_57[var11_57])
				else
					var12_57:SetDecayFactor(var1_57[var11_57], var2_57[var11_57])
				end

				var12_57:Update(arg1_57)
			end
		end
	end
end

function var9_0.UpdateEscapeOnly(arg0_58, arg1_58)
	for iter0_58, iter1_58 in pairs(arg0_58._foeShipList) do
		iter1_58:Update(arg1_58)
	end
end

function var9_0.UpdateCountDown(arg0_59, arg1_59)
	arg0_59._lastUpdateTime = arg0_59._lastUpdateTime or arg1_59

	local var0_59 = arg0_59._countDown - (arg1_59 - arg0_59._lastUpdateTime)

	if var0_59 <= 0 then
		var0_59 = 0
	end

	if math.floor(arg0_59._countDown - var0_59) == 0 or var0_59 == 0 then
		arg0_59:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_COUNT_DOWN, {}))
	end

	arg0_59._countDown = var0_59
	arg0_59._totalTime = arg1_59 - arg0_59._startTimeStamp
	arg0_59._lastUpdateTime = arg1_59
end

function var9_0.SpawnMonster(arg0_60, arg1_60, arg2_60, arg3_60, arg4_60, arg5_60)
	local var0_60 = arg0_60:GenerateUnitID()
	local var1_60 = var5_0.GetMonsterTmpDataFromID(arg1_60.monsterTemplateID)
	local var2_60 = {}

	for iter0_60, iter1_60 in ipairs(var1_60.equipment_list) do
		table.insert(var2_60, {
			id = iter1_60
		})
	end

	local var3_60 = var1_60.random_equipment_list
	local var4_60 = var1_60.random_nub

	for iter2_60, iter3_60 in ipairs(var3_60) do
		local var5_60 = var4_60[iter2_60]
		local var6_60 = Clone(iter3_60)

		for iter4_60 = 1, var5_60 do
			local var7_60 = math.random(#var6_60)

			table.insert(var2_60, {
				id = var6_60[var7_60]
			})
			table.remove(var6_60, var7_60)
		end
	end

	local var8_60 = var5_0.CreateBattleUnitData(var0_60, arg3_60, arg4_60, arg1_60.monsterTemplateID, nil, var2_60, arg1_60.extraInfo, nil, nil, nil, nil, arg1_60.level)

	var6_0.MonsterAttrFixer(arg0_60._battleInitData.battleType, var8_60)

	local var9_60

	if arg1_60.immuneHPInherit then
		var9_60 = var8_60:GetMaxHP()
	else
		var9_60 = math.ceil(var8_60:GetMaxHP() * arg0_60._repressEnemyHpRant)
	end

	if var9_60 <= 0 then
		var9_60 = 1
	end

	var8_60:SetCurrentHP(var9_60)

	local var10_60 = var2_0.RandomPos(arg1_60.corrdinate)

	var8_60:SetPosition(var10_60)
	var8_60:SetAI(arg1_60.pilotAITemplateID or var1_60.pilot_ai_template_id)
	arg0_60:setShipUnitBound(var8_60)

	if table.contains(TeamType.SubShipType, var1_60.type) then
		var8_60:InitOxygen()
		arg0_60:UpdateHostileSubmarine(true)
	end

	var5_0.AttachWeather(var8_60, arg0_60._weahter)

	arg0_60._freeShipList[var0_60] = var8_60
	arg0_60._unitList[var0_60] = var8_60

	if var8_60:IsSpectre() then
		var8_60:UpdateBlindInvisibleBySpectre()
	else
		arg0_60._cldSystem:InitShipCld(var8_60)
	end

	local var11_60 = arg1_60.sickness or var3_0.SUMMONING_SICKNESS_DURATION

	var8_60:SummonSickness(var11_60)
	var8_60:SetMoveCast(arg1_60.moveCast == true)

	if var8_60:GetIFF() == var4_0.FRIENDLY_CODE then
		arg0_60._friendlyShipList[var0_60] = var8_60
	else
		if var8_60:IsSpectre() then
			arg0_60._spectreShipList[var0_60] = var8_60
		else
			arg0_60._foeShipList[var0_60] = var8_60
		end

		var8_60:SetWaveIndex(arg2_60)
	end

	if arg1_60.reinforce then
		var8_60:Reinforce()
	end

	if arg1_60.reinforceDelay then
		var8_60:SetReinforceCastTime(arg1_60.reinforceDelay)
	end

	if arg1_60.team then
		arg0_60:GetNPCTeam(arg1_60.team):AppendUnit(var8_60)
	end

	if arg1_60.phase then
		var0_0.Battle.BattleUnitPhaseSwitcher.New(var8_60):SetTemplateData(arg1_60.phase)
	end

	if arg5_60 then
		arg5_60(var8_60)
	end

	local var12_60 = {
		type = arg3_60,
		unit = var8_60,
		bossData = arg1_60.bossData,
		extraInfo = arg1_60.extraInfo
	}

	arg0_60:DispatchEvent(var0_0.Event.New(var1_0.ADD_UNIT, var12_60))

	local function var13_60(arg0_61)
		for iter0_61, iter1_61 in ipairs(arg0_61) do
			local var0_61
			local var1_61
			local var2_61

			if type(iter1_61) == "number" then
				var1_61 = iter1_61
				var2_61 = 1
			else
				var1_61 = iter1_61.ID
				var2_61 = iter1_61.LV or 1
			end

			local var3_61 = var0_0.Battle.BattleBuffUnit.New(var1_61, var2_61, var8_60)

			var8_60:AddBuff(var3_61)
		end
	end

	local var14_60 = var8_60:GetTemplate().buff_list
	local var15_60 = arg1_60.buffList or {}
	local var16_60 = arg0_60._battleInitData.ExtraBuffList or {}
	local var17_60 = arg0_60._battleInitData.AffixBuffList or {}

	var13_60(var14_60)
	var13_60(var16_60)
	var13_60(var15_60)

	if arg1_60.affix then
		var13_60(var17_60)
	end

	local var18_60 = arg1_60.summonWaveIndex

	if var18_60 then
		arg0_60._waveSummonList[var18_60] = arg0_60._waveSummonList[var18_60] or {}
		arg0_60._waveSummonList[var18_60][var8_60] = true
	end

	var8_60:CheckWeaponInitial()

	if arg0_60._battleInitData.CMDArgs and var8_60:GetTemplateID() == arg0_60._battleInitData.CMDArgs then
		arg0_60:InitSpecificEnemyStatistics(var8_60)
	end

	var8_60:OverrideDeadFX(arg1_60.deadFX)

	if BATTLE_ENEMY_AIMBIAS_RANGE and var8_60:GetAimBias() then
		arg0_60:DispatchEvent(var0_0.Event.New(var1_0.ADD_AIM_BIAS, {
			aimBias = var8_60:GetAimBias()
		}))
	end

	return var8_60
end

function var9_0.UpdateHostileSubmarine(arg0_62, arg1_62)
	if arg1_62 then
		arg0_62._enemySubmarineCount = arg0_62._enemySubmarineCount + 1
	else
		arg0_62._enemySubmarineCount = arg0_62._enemySubmarineCount - 1
	end

	arg0_62:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_HOSTILE_SUBMARINE))
end

function var9_0.SpawnNPC(arg0_63, arg1_63, arg2_63)
	local var0_63 = arg0_63:GenerateUnitID()
	local var1_63 = var3_0.UnitType.MINION_UNIT
	local var2_63 = var5_0.GetMonsterTmpDataFromID(arg1_63.monsterTemplateID)
	local var3_63 = {}

	for iter0_63, iter1_63 in ipairs(var2_63.equipment_list) do
		table.insert(var3_63, {
			id = iter1_63
		})
	end

	local var4_63 = var5_0.CreateBattleUnitData(var0_63, var1_63, arg2_63:GetIFF(), arg1_63.monsterTemplateID, nil, var3_63, arg1_63.extraInfo, nil, nil, nil, nil, arg1_63.level)

	var4_63:SetMaster(arg2_63)
	var4_63:InheritMasterAttr()

	local var5_63 = var4_63:GetMaxHP()

	var4_63:SetCurrentHP(var5_63)

	local var6_63

	if arg1_63.corrdinate then
		var6_63 = var2_0.RandomPos(arg1_63.corrdinate)
	else
		var6_63 = Clone(arg2_63:GetPosition())
	end

	var4_63:SetPosition(var6_63)
	var4_63:SetAI(arg1_63.pilotAITemplateID or var2_63.pilot_ai_template_id)
	arg0_63:setShipUnitBound(var4_63)

	if table.contains(TeamType.SubShipType, var2_63.type) then
		var4_63:InitOxygen()

		if var4_63:GetIFF() ~= var4_0.FRIENDLY_CODE then
			arg0_63:UpdateHostileSubmarine(true)
		end
	end

	var5_0.AttachWeather(var4_63, arg0_63._weahter)

	arg0_63._freeShipList[var0_63] = var4_63
	arg0_63._unitList[var0_63] = var4_63

	arg0_63._cldSystem:InitShipCld(var4_63)

	local var7_63 = arg1_63.sickness or var3_0.SUMMONING_SICKNESS_DURATION

	var4_63:SummonSickness(var7_63)
	var4_63:SetMoveCast(arg1_63.moveCast == true)

	arg0_63._minionShipList[var0_63] = var4_63

	if arg1_63.phase then
		var0_0.Battle.BattleUnitPhaseSwitcher.New(var4_63):SetTemplateData(arg1_63.phase)
	end

	local var8_63 = {
		type = var1_63,
		unit = var4_63,
		bossData = arg1_63.bossData,
		extraInfo = arg1_63.extraInfo
	}

	arg0_63:DispatchEvent(var0_0.Event.New(var1_0.ADD_UNIT, var8_63))

	local function var9_63(arg0_64)
		for iter0_64, iter1_64 in ipairs(arg0_64) do
			local var0_64
			local var1_64
			local var2_64

			if type(iter1_64) == "number" then
				var1_64 = iter1_64
				var2_64 = 1
			else
				var1_64 = iter1_64.ID
				var2_64 = iter1_64.LV or 1
			end

			local var3_64 = var0_0.Battle.BattleBuffUnit.New(var1_64, var2_64, var4_63)

			var4_63:AddBuff(var3_64)
		end
	end

	local var10_63 = var4_63:GetTemplate().buff_list
	local var11_63 = arg1_63.buffList or {}

	var9_63(var10_63)
	var9_63(var11_63)
	var4_63:CheckWeaponInitial()

	return var4_63
end

function var9_0.EnemyEscape(arg0_65)
	for iter0_65, iter1_65 in pairs(arg0_65._foeShipList) do
		if iter1_65:ContainsLabelTag(var4_0.ESCAPE_EXPLO_TAG) then
			iter1_65:SetDeathReason(var3_0.UnitDeathReason.CLS)
			iter1_65:DeadAction()
		else
			iter1_65:RemoveAllAutoWeapon()
			iter1_65:SetAI(var4_0.COUNT_DOWN_ESCAPE_AI_ID)
		end
	end
end

function var9_0.GetNPCTeam(arg0_66, arg1_66)
	if not arg0_66._teamList[arg1_66] then
		arg0_66._teamList[arg1_66] = var0_0.Battle.BattleTeamVO.New(arg1_66)
	end

	return arg0_66._teamList[arg1_66]
end

function var9_0.KillNPCTeam(arg0_67, arg1_67)
	local var0_67 = arg0_67._teamList[arg1_67]

	if var0_67 then
		var0_67:Dispose()

		arg0_67._teamList[arg1_67] = nil
	end
end

function var9_0.SpawnVanguard(arg0_68, arg1_68, arg2_68)
	local var0_68 = arg0_68:GetVanguardBornCoordinate(arg2_68)
	local var1_68 = arg0_68:generatePlayerUnit(arg1_68, arg2_68, BuildVector3(var0_68), arg0_68._commanderBuff)

	arg0_68:GetFleetByIFF(arg2_68):AppendPlayerUnit(var1_68)
	arg0_68:setShipUnitBound(var1_68)
	var5_0.AttachWeather(var1_68, arg0_68._weahter)
	arg0_68._cldSystem:InitShipCld(var1_68)

	local var2_68 = {
		type = var3_0.UnitType.PLAYER_UNIT,
		unit = var1_68
	}

	arg0_68:DispatchEvent(var0_0.Event.New(var1_0.ADD_UNIT, var2_68))

	return var1_68
end

function var9_0.SpawnMain(arg0_69, arg1_69, arg2_69)
	local var0_69
	local var1_69 = arg0_69:GetFleetByIFF(arg2_69)
	local var2_69 = #var1_69:GetMainList() + 1

	if arg0_69._currentStageData.mainUnitPosition and arg0_69._currentStageData.mainUnitPosition[arg2_69] then
		var0_69 = Clone(arg0_69._currentStageData.mainUnitPosition[arg2_69][var2_69])
	else
		var0_69 = Clone(var4_0.MAIN_UNIT_POS[arg2_69][var2_69])
	end

	local var3_69 = arg0_69:generatePlayerUnit(arg1_69, arg2_69, var0_69, arg0_69._commanderBuff)

	var3_69:SetBornPosition(var0_69)
	var3_69:SetMainFleetUnit()

	local var4_69 = var0_69.x

	if var4_69 < arg0_69._totalLeftBound or var4_69 > arg0_69._totalRightBound then
		var3_69:SetImmuneCommonBulletCLD()
	end

	var1_69:AppendPlayerUnit(var3_69)
	arg0_69:setShipUnitBound(var3_69)
	var5_0.AttachWeather(var3_69, arg0_69._weahter)
	arg0_69._cldSystem:InitShipCld(var3_69)

	local var5_69 = {
		type = var3_0.UnitType.PLAYER_UNIT,
		unit = var3_69
	}

	arg0_69:DispatchEvent(var0_0.Event.New(var1_0.ADD_UNIT, var5_69))

	return var3_69
end

function var9_0.SpawnSub(arg0_70, arg1_70, arg2_70)
	local var0_70
	local var1_70 = arg0_70:GetFleetByIFF(arg2_70)
	local var2_70 = #var1_70:GetSubList() + 1
	local var3_70 = var4_0.SUB_UNIT_OFFSET_X + (var5_0.GetPlayerShipTmpDataFromID(arg1_70.tmpID).summon_offset or 0)

	if arg2_70 == var4_0.FRIENDLY_CODE then
		var0_70 = Vector3(var3_70 + arg0_70._totalLeftBound, 0, var4_0.SUB_UNIT_POS_Z[var2_70])
	else
		var0_70 = Vector3(arg0_70._totalRightBound - var3_70, 0, var4_0.SUB_UNIT_POS_Z[var2_70])
	end

	local var4_70 = arg0_70:generatePlayerUnit(arg1_70, arg2_70, var0_70, arg0_70._subCommanderBuff)

	var1_70:AddSubMarine(var4_70)
	arg0_70:setShipUnitBound(var4_70)
	var5_0.AttachWeather(var4_70, arg0_70._weahter)
	arg0_70._cldSystem:InitShipCld(var4_70)

	local var5_70 = {
		type = var3_0.UnitType.PLAYER_UNIT,
		unit = var4_70
	}

	arg0_70:DispatchEvent(var0_0.Event.New(var1_0.ADD_UNIT, var5_70))

	return var4_70
end

function var9_0.SpawnManualSub(arg0_71, arg1_71, arg2_71)
	local var0_71 = arg0_71:GetVanguardBornCoordinate(arg2_71)
	local var1_71 = arg0_71:generatePlayerUnit(arg1_71, arg2_71, BuildVector3(var0_71), arg0_71._commanderBuff)

	arg0_71:GetFleetByIFF(arg2_71):AddManualSubmarine(var1_71)
	arg0_71:setShipUnitBound(var1_71)
	arg0_71._cldSystem:InitShipCld(var1_71)

	local var2_71 = {
		type = var3_0.UnitType.SUB_UNIT,
		unit = var1_71
	}

	arg0_71:DispatchEvent(var0_0.Event.New(var1_0.ADD_UNIT, var2_71))

	return var1_71
end

function var9_0.SpawnSupportUnit(arg0_72, arg1_72, arg2_72)
	local var0_72 = arg0_72:generateSupportPlayerUnit(arg1_72, arg2_72)

	arg0_72:GetFleetByIFF(arg2_72):AppendSupportUnit(var0_72)

	return var0_72
end

function var9_0.ShutdownPlayerUnit(arg0_73, arg1_73)
	local var0_73 = arg0_73._unitList[arg1_73]
	local var1_73 = var0_73:GetIFF()
	local var2_73 = arg0_73:GetFleetByIFF(var1_73)

	var2_73:RemovePlayerUnit(var0_73)

	local var3_73 = {}

	if var2_73:GetFleetAntiAirWeapon():GetRange() == 0 then
		var3_73.isShow = false
	end

	arg0_73:DispatchEvent(var0_0.Event.New(var1_0.ANTI_AIR_AREA, var3_73))

	local var4_73 = {
		unit = var0_73
	}

	arg0_73:DispatchEvent(var0_0.Event.New(var1_0.SHUT_DOWN_PLAYER, var4_73))
end

function var9_0.updateDeadList(arg0_74)
	local var0_74 = #arg0_74._deadUnitList

	while var0_74 > 0 do
		arg0_74._deadUnitList[var0_74]:Dispose()

		arg0_74._deadUnitList[var0_74] = nil
		var0_74 = var0_74 - 1
	end
end

function var9_0.KillUnit(arg0_75, arg1_75)
	local var0_75 = arg0_75._unitList[arg1_75]

	if var0_75 == nil then
		return
	end

	local var1_75 = var0_75:GetUnitType()

	arg0_75._cldSystem:DeleteShipCld(var0_75)
	var0_75:Clear()

	arg0_75._unitList[arg1_75] = nil

	if arg0_75._freeShipList[arg1_75] then
		arg0_75._freeShipList[arg1_75] = nil
	end

	local var2_75 = var0_75:GetIFF()
	local var3_75 = var0_75:GetDeathReason()

	if var0_75:GetAimBias() then
		local var4_75 = var0_75:GetAimBias()

		var4_75:RemoveCrew(var0_75)

		if var4_75:GetCurrentState() == var4_75.STATE_EXPIRE then
			arg0_75:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_AIM_BIAS, {
				aimBias = var0_75:GetAimBias()
			}))
		end
	end

	if var0_75:IsSpectre() then
		arg0_75._spectreShipList[arg1_75] = nil
	elseif var2_75 == var4_0.FOE_CODE then
		arg0_75._foeShipList[arg1_75] = nil

		if var1_75 == var3_0.UnitType.ENEMY_UNIT or var1_75 == var3_0.UnitType.BOSS_UNIT then
			if var0_75:GetTeam() then
				var0_75:GetTeam():RemoveUnit(var0_75)
			end

			local var5_75 = var0_75:GetTemplate().type

			if table.contains(TeamType.SubShipType, var5_75) then
				arg0_75:UpdateHostileSubmarine(false)
			end

			local var6_75 = var0_75:GetWaveIndex()

			if var6_75 and arg0_75._waveSummonList[var6_75] then
				arg0_75._waveSummonList[var6_75][var0_75] = nil
			end
		end
	elseif var2_75 == var4_0.FRIENDLY_CODE then
		arg0_75._friendlyShipList[arg1_75] = nil
	end

	local var7_75 = {
		UID = arg1_75,
		type = var1_75,
		deadReason = var3_75,
		unit = var0_75
	}

	arg0_75:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_UNIT, var7_75))
	table.insert(arg0_75._deadUnitList, var0_75)
end

function var9_0.KillAllEnemy(arg0_76)
	for iter0_76, iter1_76 in pairs(arg0_76._unitList) do
		if iter1_76:GetIFF() == var4_0.FOE_CODE and iter1_76:IsAlive() and not iter1_76:IsBoss() then
			iter1_76:DeadAction()
		end
	end
end

function var9_0.KillSubmarineByIFF(arg0_77, arg1_77)
	for iter0_77, iter1_77 in pairs(arg0_77._unitList) do
		if iter1_77:GetIFF() == arg1_77 and iter1_77:IsAlive() and table.contains(TeamType.SubShipType, iter1_77:GetTemplate().type) and not iter1_77:IsBoss() then
			iter1_77:DeadAction()
		end
	end
end

function var9_0.KillAllAircraft(arg0_78)
	for iter0_78, iter1_78 in pairs(arg0_78._aircraftList) do
		iter1_78:Clear()

		local var0_78 = {
			UID = iter0_78
		}

		arg0_78:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_AIR_CRAFT, var0_78))

		arg0_78._aircraftList[iter0_78] = nil
	end
end

function var9_0.KillWaveSummonMonster(arg0_79, arg1_79)
	local var0_79 = arg0_79._waveSummonList[arg1_79]

	if var0_79 then
		for iter0_79, iter1_79 in pairs(var0_79) do
			local var1_79 = iter0_79:GetUniqueID()

			arg0_79:KillUnit(var1_79)
		end
	end

	arg0_79._waveSummonList[arg1_79] = nil
end

function var9_0.IsThereBoss(arg0_80)
	return arg0_80:GetActiveBossCount() > 0
end

function var9_0.GetActiveBossCount(arg0_81)
	local var0_81 = 0

	for iter0_81, iter1_81 in pairs(arg0_81:GetUnitList()) do
		if iter1_81:IsBoss() and iter1_81:IsAlive() then
			var0_81 = var0_81 + 1
		end
	end

	return var0_81
end

function var9_0.setShipUnitBound(arg0_82, arg1_82)
	local var0_82 = arg1_82:GetIFF()

	if arg1_82:GetFleetVO() then
		arg1_82:SetBound(arg1_82:GetFleetVO():GetUnitBound():GetBound())
	else
		arg1_82:SetBound(arg0_82:GetUnitBoundByIFF(var0_82))
	end
end

function var9_0.generatePlayerUnit(arg0_83, arg1_83, arg2_83, arg3_83, arg4_83)
	local var0_83 = arg0_83:GenerateUnitID()
	local var1_83 = arg1_83.properties

	var1_83.level = arg1_83.level
	var1_83.formationID = var4_0.FORMATION_ID
	var1_83.id = arg1_83.id

	var6_0.AttrFixer(arg0_83._battleInitData.battleType, var1_83)

	local var2_83 = arg1_83.proficiency or {
		1,
		1,
		1
	}
	local var3_83 = var3_0.UnitType.PLAYER_UNIT
	local var4_83 = arg0_83._battleInitData.battleType

	if var4_83 == SYSTEM_SUBMARINE_RUN or var4_83 == SYSTEM_SUB_ROUTINE then
		var3_83 = var3_0.UnitType.SUB_UNIT
	elseif var4_83 == SYSTEM_AIRFIGHT then
		var3_83 = var3_0.UnitType.CONST_UNIT
	elseif var4_83 == SYSTEM_CARDPUZZLE then
		var3_83 = var3_0.UnitType.CARDPUZZLE_PLAYER_UNIT
	end

	local var5_83 = var5_0.CreateBattleUnitData(var0_83, var3_83, arg2_83, arg1_83.tmpID, arg1_83.skinId, arg1_83.equipment, var1_83, arg1_83.baseProperties, var2_83, arg1_83.baseList, arg1_83.preloasList)

	var5_0.AttachUltimateBonus(var5_83)
	var5_83:InitCurrentHP(arg1_83.initHPRate or 1)
	var5_83:SetRarity(arg1_83.rarity)
	var5_83:SetIntimacy(arg1_83.intimacy)
	var5_83:SetShipName(arg1_83.name)

	if arg1_83.spWeapon then
		var5_83:SetSpWeapon(arg1_83.spWeapon)
		_.each(arg1_83.spWeapon:GetLabel(), function(arg0_84)
			var5_83:AddLabelTag(arg0_84)
		end)
	end

	arg0_83._unitList[var0_83] = var5_83

	if var5_83:GetIFF() == var4_0.FRIENDLY_CODE then
		arg0_83._friendlyShipList[var0_83] = var5_83
	elseif var5_83:GetIFF() == var4_0.FOE_CODE then
		arg0_83._foeShipList[var0_83] = var5_83
	end

	if var4_83 == SYSTEM_WORLD then
		local var6_83 = var2_0.WorldMapRewardHealingRate(arg0_83._battleInitData.EnemyMapRewards, arg0_83._battleInitData.FleetMapRewards)

		var6_0.SetCurrent(var5_83, "healingRate", var6_83)
	end

	var5_83:SetPosition(arg3_83)
	var5_0.InitUnitSkill(arg1_83, var5_83, var4_83)
	var5_0.InitEquipSkill(arg1_83.equipment, var5_83, var4_83)
	var5_0.InitCommanderSkill(arg4_83, var5_83, var4_83)
	var5_83:SetGearScore(arg1_83.shipGS)

	if arg1_83.deathMark then
		var5_83:SetWorldDeathMark()
	end

	return var5_83
end

function var9_0.generateSupportPlayerUnit(arg0_85, arg1_85, arg2_85)
	local var0_85 = arg0_85:GenerateUnitID()
	local var1_85 = arg1_85.properties

	var1_85.level = arg1_85.level
	var1_85.formationID = var4_0.FORMATION_ID
	var1_85.id = arg1_85.id

	var6_0.AttrFixer(arg0_85._battleInitData.battleType, var1_85)

	local var2_85 = arg1_85.proficiency or {
		1,
		1,
		1
	}
	local var3_85 = var5_0.CreateBattleUnitData(var0_85, var3_0.UnitType.SUPPORT_UNIT, arg2_85, arg1_85.tmpID, arg1_85.skinId, arg1_85.equipment, var1_85, arg1_85.baseProperties, var2_85, arg1_85.baseList, arg1_85.preloasList)

	var3_85:InitCurrentHP(1)
	var3_85:SetShipName(arg1_85.name)

	arg0_85._spectreShipList[var0_85] = var3_85

	var3_85:SetPosition(Clone(var4_0.AirSupportUnitPos))

	return var3_85
end

function var9_0.SwitchSpectreUnit(arg0_86, arg1_86)
	local var0_86 = arg1_86:GetUniqueID()
	local var1_86 = arg1_86:GetIFF() == var4_0.FRIENDLY_CODE and arg0_86._friendlyShipList or arg0_86._foeShipList

	if arg1_86:IsSpectre() then
		var1_86[var0_86] = nil
		arg0_86._spectreShipList[var0_86] = arg1_86

		for iter0_86, iter1_86 in pairs(arg0_86._AOEList) do
			iter1_86:ForceExit(arg1_86:GetUniqueID())
		end

		arg0_86._cldSystem:DeleteShipCld(arg1_86)
	else
		arg0_86._spectreShipList[var0_86] = nil
		var1_86[var0_86] = arg1_86

		arg1_86:ActiveCldBox()
		arg0_86._cldSystem:InitShipCld(arg1_86)
	end
end

function var9_0.GetUnitList(arg0_87)
	return arg0_87._unitList
end

function var9_0.GetFriendlyShipList(arg0_88)
	return arg0_88._friendlyShipList
end

function var9_0.GetFoeShipList(arg0_89)
	return arg0_89._foeShipList
end

function var9_0.GetFoeAircraftList(arg0_90)
	return arg0_90._foeAircraftList
end

function var9_0.GetFreeShipList(arg0_91)
	return arg0_91._freeShipList
end

function var9_0.GetSpectreShipList(arg0_92)
	return arg0_92._spectreShipList
end

function var9_0.GenerateUnitID(arg0_93)
	arg0_93._unitCount = arg0_93._unitCount + 1

	return arg0_93._unitCount
end

function var9_0.GetCountDown(arg0_94)
	return arg0_94._countDown
end

function var9_0.SpawnAirFighter(arg0_95, arg1_95)
	local var0_95 = #arg0_95._airFighterList + 1
	local var1_95 = var5_0.GetFormationTmpDataFromID(arg1_95.formation).pos_offset
	local var2_95 = {
		currentNumber = 0,
		templateID = arg1_95.templateID,
		totalNumber = arg1_95.totalNumber or 0,
		onceNumber = arg1_95.onceNumber,
		timeDelay = arg1_95.interval or 3,
		maxTotalNumber = arg1_95.maxTotalNumber or 15
	}

	local function var3_95(arg0_96)
		local var0_96 = var2_95.currentNumber

		if var0_96 < var2_95.totalNumber then
			var2_95.currentNumber = var0_96 + 1

			local var1_96 = arg0_95:CreateAirFighter(arg1_95)

			var1_96:SetFormationOffset(var1_95[arg0_96])
			var1_96:SetFormationIndex(arg0_96)
			var1_96:SetDeadCallBack(function()
				var2_95.totalNumber = var2_95.totalNumber - 1
				var2_95.currentNumber = var2_95.currentNumber - 1

				arg0_95:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_AIR_FIGHTER_ICON, {
					index = var0_95
				}))
				arg0_95:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_AIR_SUPPORT_LABEL, {}))
			end)
			var1_96:SetLiveCallBack(function()
				var2_95.currentNumber = var2_95.currentNumber - 1
			end)
		end
	end

	local function var4_95()
		local var0_99 = var2_95.onceNumber

		if var2_95.totalNumber > 0 then
			for iter0_99 = 1, var0_99 do
				var3_95(iter0_99)
			end
		else
			pg.TimeMgr.GetInstance():RemoveBattleTimer(var2_95.timer)

			var2_95.timer = nil
		end
	end

	arg0_95._airFighterList[var0_95] = var2_95

	arg0_95:DispatchEvent(var0_0.Event.New(var1_0.ADD_AIR_FIGHTER_ICON, {
		index = var0_95
	}))
	arg0_95:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_AIR_SUPPORT_LABEL, {}))

	var2_95.timer = pg.TimeMgr.GetInstance():AddBattleTimer("striker", -1, arg1_95.interval, var4_95)
end

function var9_0.ClearAirFighterTimer(arg0_100)
	for iter0_100, iter1_100 in ipairs(arg0_100._airFighterList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter1_100.timer)

		iter1_100.timer = nil
	end

	arg0_100._airFighterList = {}
end

function var9_0.KillAllAirStrike(arg0_101)
	for iter0_101, iter1_101 in pairs(arg0_101._aircraftList) do
		if iter1_101.__name == var0_0.Battle.BattleAirFighterUnit.__name then
			arg0_101._cldSystem:DeleteAircraftCld(iter1_101)

			iter1_101._aliveState = false
			arg0_101._aircraftList[iter0_101] = nil
			arg0_101._foeAircraftList[iter0_101] = nil

			local var0_101 = {
				UID = iter0_101
			}

			arg0_101:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_AIR_CRAFT, var0_101))
		end
	end

	local var1_101 = true

	for iter2_101, iter3_101 in pairs(arg0_101._foeAircraftList) do
		var1_101 = false

		break
	end

	if var1_101 then
		arg0_101:DispatchEvent(var0_0.Event.New(var1_0.ANTI_AIR_AREA, {
			isShow = false
		}))
	end

	for iter4_101, iter5_101 in ipairs(arg0_101._airFighterList) do
		iter5_101.totalNumber = 0

		arg0_101:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_AIR_FIGHTER_ICON, {
			index = iter4_101
		}))
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter5_101.timer)

		iter5_101.timer = nil
	end

	arg0_101._airFighterList = {}
end

function var9_0.GetAirFighterInfo(arg0_102, arg1_102)
	return arg0_102._airFighterList[arg1_102]
end

function var9_0.GetAirFighterList(arg0_103)
	return arg0_103._airFighterList
end

function var9_0.CreateAircraft(arg0_104, arg1_104, arg2_104, arg3_104, arg4_104)
	local var0_104 = arg0_104:GenerateAircraftID()
	local var1_104 = var5_0.CreateAircraftUnit(var0_104, arg2_104, arg1_104, arg3_104)

	if arg4_104 then
		var1_104:SetSkinID(arg4_104)
	end

	local var2_104

	if arg1_104:GetIFF() == var4_0.FRIENDLY_CODE then
		-- block empty
	else
		var2_104 = true
	end

	arg0_104:doCreateAirUnit(var0_104, var1_104, var3_0.UnitType.AIRCRAFT_UNIT, var2_104)

	return var1_104
end

function var9_0.CreateAirFighter(arg0_105, arg1_105)
	local var0_105 = arg0_105:GenerateAircraftID()
	local var1_105 = var5_0.CreateAirFighterUnit(var0_105, arg1_105)

	arg0_105:doCreateAirUnit(var0_105, var1_105, var3_0.UnitType.AIRFIGHTER_UNIT, true)

	return var1_105
end

function var9_0.doCreateAirUnit(arg0_106, arg1_106, arg2_106, arg3_106, arg4_106)
	arg0_106._aircraftList[arg1_106] = arg2_106

	arg0_106._cldSystem:InitAircraftCld(arg2_106)
	arg2_106:SetBound(arg0_106._leftZoneUpperBound, arg0_106._leftZoneLowerBound)
	arg2_106:SetViewBoundData(arg0_106._cameraTop, arg0_106._cameraBottom, arg0_106._cameraLeft, arg0_106._cameraRight)
	arg0_106:DispatchEvent(var0_0.Event.New(var1_0.ADD_UNIT, {
		unit = arg2_106,
		type = arg3_106
	}))

	arg4_106 = arg4_106 or false

	if arg4_106 then
		arg0_106._foeAircraftList[arg1_106] = arg2_106

		arg0_106:DispatchEvent(var0_0.Event.New(var1_0.ANTI_AIR_AREA, {
			isShow = true
		}))
	end
end

function var9_0.KillAircraft(arg0_107, arg1_107)
	local var0_107 = arg0_107._aircraftList[arg1_107]

	if var0_107 == nil then
		return
	end

	var0_107:Clear()
	arg0_107._cldSystem:DeleteAircraftCld(var0_107)

	if var0_107:IsUndefeated() and var0_107:GetCurrentState() ~= var0_107.STRIKE_STATE_RECYCLE then
		local var1_107 = var0_107:GetIFF() * -1

		arg0_107:HandleAircraftMissDamage(var0_107, arg0_107._fleetList[var1_107])
	end

	var0_107._aliveState = false
	arg0_107._aircraftList[arg1_107] = nil
	arg0_107._foeAircraftList[arg1_107] = nil

	local var2_107 = true

	for iter0_107, iter1_107 in pairs(arg0_107._foeAircraftList) do
		var2_107 = false

		break
	end

	if var2_107 then
		arg0_107:DispatchEvent(var0_0.Event.New(var1_0.ANTI_AIR_AREA, {
			isShow = false
		}))
	end

	local var3_107 = {
		UID = arg1_107
	}

	arg0_107:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_AIR_CRAFT, var3_107))
end

function var9_0.GetAircraftList(arg0_108)
	return arg0_108._aircraftList
end

function var9_0.GenerateAircraftID(arg0_109)
	arg0_109._aircraftCount = arg0_109._aircraftCount + 1

	return arg0_109._aircraftCount
end

function var9_0.CreateBulletUnit(arg0_110, arg1_110, arg2_110, arg3_110, arg4_110)
	local var0_110 = arg0_110:GenerateBulletID()
	local var1_110, var2_110 = var5_0.CreateBattleBulletData(var0_110, arg1_110, arg2_110, arg3_110, arg4_110)

	if var2_110 then
		arg0_110._cldSystem:InitBulletCld(var1_110)
	end

	local var3_110, var4_110 = arg3_110:GetFixBulletRange()

	if var3_110 or var4_110 then
		var1_110:FixRange(var3_110, var4_110)
	end

	arg0_110._bulletList[var0_110] = var1_110

	return var1_110
end

function var9_0.RemoveBulletUnit(arg0_111, arg1_111)
	local var0_111 = arg0_111._bulletList[arg1_111]

	if var0_111 == nil then
		return
	end

	var0_111:DamageUnitListWriteback()

	if var0_111:GetIsCld() then
		arg0_111._cldSystem:DeleteBulletCld(var0_111)
	end

	arg0_111._bulletList[arg1_111] = nil

	local var1_111 = {
		UID = arg1_111
	}

	arg0_111:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_BULLET, var1_111))
	var0_111:Dispose()
end

function var9_0.GetBulletList(arg0_112)
	return arg0_112._bulletList
end

function var9_0.GenerateBulletID(arg0_113)
	local var0_113 = arg0_113._bulletCount + 1

	arg0_113._bulletCount = var0_113

	return var0_113
end

function var9_0.CLSBullet(arg0_114, arg1_114, arg2_114)
	local var0_114 = true

	if arg0_114._battleInitData.battleType == SYSTEM_DUEL then
		var0_114 = false
	end

	if var0_114 then
		for iter0_114, iter1_114 in pairs(arg0_114._bulletList) do
			if iter1_114:GetIFF() ~= arg1_114 or not iter1_114:GetExist() or iter1_114:ImmuneCLS() or iter1_114:ImmuneBombCLS() and arg2_114 then
				-- block empty
			else
				arg0_114:RemoveBulletUnit(iter0_114)
			end
		end
	end
end

function var9_0.CLSAircraft(arg0_115, arg1_115)
	for iter0_115, iter1_115 in pairs(arg0_115._aircraftList) do
		if iter1_115:GetIFF() == arg1_115 then
			iter1_115:Clear()

			local var0_115 = {
				UID = iter0_115
			}

			arg0_115:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_AIR_CRAFT, var0_115))

			arg0_115._aircraftList[iter0_115] = nil
		end
	end
end

function var9_0.CLSMinion(arg0_116)
	for iter0_116, iter1_116 in pairs(arg0_116._unitList) do
		if iter1_116:GetIFF() == var4_0.FOE_CODE and iter1_116:IsAlive() and not iter1_116:IsBoss() then
			iter1_116:SetDeathReason(var3_0.UnitDeathReason.CLS)
			iter1_116:DeadAction()
		end
	end
end

function var9_0.SpawnColumnArea(arg0_117, arg1_117, arg2_117, arg3_117, arg4_117, arg5_117, arg6_117, arg7_117, arg8_117)
	arg7_117 = arg7_117 or false

	local var0_117 = arg0_117:GenerateAreaID()
	local var1_117 = var0_0.Battle.BattleAOEData.New(var0_117, arg2_117, arg6_117, arg8_117)
	local var2_117 = Clone(arg3_117)

	var1_117:SetPosition(var2_117)
	var1_117:SetRange(arg4_117)
	var1_117:SetAreaType(var3_0.AreaType.COLUMN)
	var1_117:SetLifeTime(arg5_117)
	var1_117:SetFieldType(arg1_117)
	var1_117:SetOpponentAffected(not arg7_117)
	arg0_117:CreateAreaOfEffect(var1_117)

	return var1_117
end

function var9_0.SpawnCubeArea(arg0_118, arg1_118, arg2_118, arg3_118, arg4_118, arg5_118, arg6_118, arg7_118, arg8_118, arg9_118)
	arg8_118 = arg8_118 or false

	local var0_118 = arg0_118:GenerateAreaID()
	local var1_118 = var0_0.Battle.BattleAOEData.New(var0_118, arg2_118, arg7_118, arg9_118)
	local var2_118 = Clone(arg3_118)

	var1_118:SetPosition(var2_118)
	var1_118:SetWidth(arg4_118)
	var1_118:SetHeight(arg5_118)
	var1_118:SetAreaType(var3_0.AreaType.CUBE)
	var1_118:SetLifeTime(arg6_118)
	var1_118:SetFieldType(arg1_118)
	var1_118:SetOpponentAffected(not arg8_118)
	arg0_118:CreateAreaOfEffect(var1_118)

	return var1_118
end

function var9_0.SpawnLastingColumnArea(arg0_119, arg1_119, arg2_119, arg3_119, arg4_119, arg5_119, arg6_119, arg7_119, arg8_119, arg9_119, arg10_119, arg11_119)
	arg8_119 = arg8_119 or false

	local var0_119 = arg0_119:GenerateAreaID()
	local var1_119 = var0_0.Battle.BattleLastingAOEData.New(var0_119, arg2_119, arg6_119, arg7_119, arg10_119, arg11_119)
	local var2_119 = Clone(arg3_119)

	var1_119:SetPosition(var2_119)
	var1_119:SetRange(arg4_119)
	var1_119:SetAreaType(var3_0.AreaType.COLUMN)
	var1_119:SetLifeTime(arg5_119)
	var1_119:SetFieldType(arg1_119)
	var1_119:SetOpponentAffected(not arg8_119)
	arg0_119:CreateAreaOfEffect(var1_119)

	if arg9_119 and arg9_119 ~= "" then
		local var3_119 = {
			area = var1_119,
			FXID = arg9_119
		}

		arg0_119:DispatchEvent(var0_0.Event.New(var1_0.ADD_AREA, var3_119))
	end

	return var1_119
end

function var9_0.SpawnLastingCubeArea(arg0_120, arg1_120, arg2_120, arg3_120, arg4_120, arg5_120, arg6_120, arg7_120, arg8_120, arg9_120, arg10_120, arg11_120, arg12_120)
	arg9_120 = arg9_120 or false

	local var0_120 = arg0_120:GenerateAreaID()
	local var1_120 = var0_0.Battle.BattleLastingAOEData.New(var0_120, arg2_120, arg7_120, arg8_120, arg11_120, arg12_120)
	local var2_120 = Clone(arg3_120)

	var1_120:SetPosition(var2_120)
	var1_120:SetWidth(arg4_120)
	var1_120:SetHeight(arg5_120)
	var1_120:SetAreaType(var3_0.AreaType.CUBE)
	var1_120:SetLifeTime(arg6_120)
	var1_120:SetFieldType(arg1_120)
	var1_120:SetOpponentAffected(not arg9_120)
	arg0_120:CreateAreaOfEffect(var1_120)

	if arg10_120 and arg10_120 ~= "" then
		local var3_120 = {
			area = var1_120,
			FXID = arg10_120
		}

		arg0_120:DispatchEvent(var0_0.Event.New(var1_0.ADD_AREA, var3_120))
	end

	return var1_120
end

function var9_0.SpawnTriggerColumnArea(arg0_121, arg1_121, arg2_121, arg3_121, arg4_121, arg5_121, arg6_121, arg7_121, arg8_121)
	arg6_121 = arg6_121 or false

	local var0_121 = arg0_121:GenerateAreaID()
	local var1_121 = var0_0.Battle.BattleTriggerAOEData.New(var0_121, arg2_121, arg8_121)
	local var2_121 = Clone(arg3_121)

	var1_121:SetPosition(var2_121)
	var1_121:SetRange(arg4_121)
	var1_121:SetAreaType(var3_0.AreaType.COLUMN)
	var1_121:SetLifeTime(arg5_121)
	var1_121:SetFieldType(arg1_121)
	var1_121:SetOpponentAffected(not arg6_121)
	arg0_121:CreateAreaOfEffect(var1_121)

	if arg7_121 and arg7_121 ~= "" then
		local var3_121 = {
			area = var1_121,
			FXID = arg7_121
		}

		arg0_121:DispatchEvent(var0_0.Event.New(var1_0.ADD_AREA, var3_121))
	end

	return var1_121
end

function var9_0.CreateAreaOfEffect(arg0_122, arg1_122)
	arg0_122._AOEList[arg1_122:GetUniqueID()] = arg1_122

	arg0_122._cldSystem:InitAOECld(arg1_122)
	arg1_122:StartTimer()
end

function var9_0.RemoveAreaOfEffect(arg0_123, arg1_123)
	local var0_123 = arg0_123._AOEList[arg1_123]

	if not var0_123 then
		return
	end

	var0_123:Dispose()

	arg0_123._AOEList[arg1_123] = nil

	arg0_123._cldSystem:DeleteAOECld(var0_123)
	arg0_123:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_AREA, {
		id = arg1_123
	}))
end

function var9_0.GetAOEList(arg0_124)
	return arg0_124._AOEList
end

function var9_0.GenerateAreaID(arg0_125)
	arg0_125._AOECount = arg0_125._AOECount + 1

	return arg0_125._AOECount
end

function var9_0.SpawnWall(arg0_126, arg1_126, arg2_126, arg3_126, arg4_126)
	local var0_126 = arg0_126:GenerateWallID()
	local var1_126 = var0_0.Battle.BattleWallData.New(var0_126, arg1_126, arg2_126, arg3_126, arg4_126)

	arg0_126._wallList[var0_126] = var1_126

	arg0_126._cldSystem:InitWallCld(var1_126)

	return var1_126
end

function var9_0.RemoveWall(arg0_127, arg1_127)
	local var0_127 = arg0_127._wallList[arg1_127]

	arg0_127._wallList[arg1_127] = nil

	arg0_127._cldSystem:DeleteWallCld(var0_127)
end

function var9_0.SpawnShelter(arg0_128, arg1_128, arg2_128)
	local var0_128 = arg0_128:GernerateShelterID()
	local var1_128 = var0_0.Battle.BattleShelterData.New(var0_128)

	arg0_128._shelterList[var0_128] = var1_128

	return var1_128
end

function var9_0.RemoveShelter(arg0_129, arg1_129)
	local var0_129 = arg0_129._shelterList[arg1_129]
	local var1_129 = {
		uid = arg1_129
	}

	arg0_129:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_SHELTER, var1_129))
	var0_129:Deactive()

	arg0_129._shelterList[arg1_129] = nil
end

function var9_0.GetWallList(arg0_130)
	return arg0_130._wallList
end

function var9_0.GenerateWallID(arg0_131)
	arg0_131._wallIndex = arg0_131._wallIndex + 1

	return arg0_131._wallIndex
end

function var9_0.GernerateShelterID(arg0_132)
	arg0_132._shelterIndex = arg0_132._shelterIndex + 1

	return arg0_132._shelterIndex
end

function var9_0.SpawnEnvironment(arg0_133, arg1_133)
	local var0_133 = arg0_133:GernerateEnvironmentID()
	local var1_133 = var0_0.Battle.BattleEnvironmentUnit.New(var0_133, var4_0.FOE_CODE)

	var1_133:SetTemplate(arg1_133)

	local var2_133 = var1_133:GetBehaviours()
	local var3_133 = Vector3(arg1_133.coordinate[1], arg1_133.coordinate[2], arg1_133.coordinate[3])

	local function var4_133(arg0_134)
		local var0_134 = {}

		for iter0_134, iter1_134 in ipairs(arg0_134) do
			if iter1_134.Active then
				local var1_134 = arg0_133._unitList[iter1_134.UID]

				if not var1_134:IsSpectre() then
					table.insert(var0_134, var1_134)
				end
			end
		end

		var1_133:UpdateFrequentlyCollide(var0_134)
	end

	local function var5_133()
		return
	end

	local function var6_133()
		return
	end

	local var7_133 = arg1_133.field_type or var3_0.BulletField.SURFACE
	local var8_133 = arg1_133.IFF or var4_0.FOE_CODE
	local var9_133 = 0
	local var10_133

	if #arg1_133.cld_data == 1 then
		local var11_133 = arg1_133.cld_data[1]

		var10_133 = arg0_133:SpawnLastingColumnArea(var7_133, var8_133, var3_133, var11_133, var9_133, var4_133, var5_133, false, arg1_133.prefab, var6_133, true)
	else
		local var12_133 = arg1_133.cld_data[1]
		local var13_133 = arg1_133.cld_data[2]

		var10_133 = arg0_133:SpawnLastingCubeArea(var7_133, var8_133, var3_133, var12_133, var13_133, var9_133, var4_133, var5_133, false, arg1_133.prefab, var6_133, true)
	end

	var1_133:SetAOEData(var10_133)

	arg0_133._environmentList[var0_133] = var1_133

	return var1_133
end

function var9_0.RemoveEnvironment(arg0_137, arg1_137)
	local var0_137 = arg0_137._environmentList[arg1_137]
	local var1_137 = var0_137:GetAOEData()

	arg0_137:RemoveAreaOfEffect(var1_137:GetUniqueID())
	var0_137:Dispose()

	arg0_137._environmentList[arg1_137] = nil
end

function var9_0.DispatchWarning(arg0_138, arg1_138, arg2_138)
	arg0_138:DispatchEvent(var0_0.Event.New(var1_0.UPDATE_ENVIRONMENT_WARNING, {
		isActive = arg1_138
	}))
end

function var9_0.GetEnvironmentList(arg0_139)
	return arg0_139._environmentList
end

function var9_0.GernerateEnvironmentID(arg0_140)
	arg0_140._environmentIndex = arg0_140._environmentIndex + 1

	return arg0_140._environmentIndex
end

function var9_0.SpawnEffect(arg0_141, arg1_141, arg2_141, arg3_141)
	arg0_141:DispatchEvent(var0_0.Event.New(var1_0.ADD_EFFECT, {
		FXID = arg1_141,
		position = arg2_141,
		localScale = arg3_141
	}))
end

function var9_0.SpawnUIFX(arg0_142, arg1_142, arg2_142, arg3_142, arg4_142)
	arg0_142:DispatchEvent(var0_0.Event.New(var1_0.ADD_UI_FX, {
		FXID = arg1_142,
		position = arg2_142,
		localScale = arg3_142,
		orderDiff = arg4_142
	}))
end

function var9_0.SpawnCameraFX(arg0_143, arg1_143, arg2_143, arg3_143, arg4_143)
	arg0_143:DispatchEvent(var0_0.Event.New(var1_0.ADD_CAMERA_FX, {
		FXID = arg1_143,
		position = arg2_143,
		localScale = arg3_143,
		orderDiff = arg4_143
	}))
end

function var9_0.GetFriendlyCode(arg0_144)
	return arg0_144._friendlyCode
end

function var9_0.GetFoeCode(arg0_145)
	return arg0_145._foeCode
end

function var9_0.GetOppoSideCode(arg0_146)
	if arg0_146 == var4_0.FRIENDLY_CODE then
		return var4_0.FOE_CODE
	elseif arg0_146 == var4_0.FOE_CODE then
		return var4_0.FRIENDLY_CODE
	end
end

function var9_0.GetStatistics(arg0_147)
	return arg0_147._statistics
end

function var9_0.BlockManualCast(arg0_148, arg1_148)
	local var0_148 = arg1_148 and 1 or -1

	for iter0_148, iter1_148 in pairs(arg0_148._fleetList) do
		iter1_148:SetWeaponBlock(var0_148)
	end
end

function var9_0.JamManualCast(arg0_149, arg1_149)
	arg0_149:DispatchEvent(var0_0.Event.New(var1_0.JAMMING, {
		jammingFlag = arg1_149
	}))
end

function var9_0.SubmarineStrike(arg0_150, arg1_150)
	local var0_150 = arg0_150:GetFleetByIFF(arg1_150)
	local var1_150 = var0_150:GetSubAidVO()

	if var0_150:GetWeaponBlock() or var1_150:GetCurrent() < 1 then
		return
	end

	local var2_150 = var0_150:GetSubUnitData()

	for iter0_150, iter1_150 in ipairs(var2_150) do
		local var3_150 = arg0_150:SpawnSub(iter1_150, arg1_150)

		arg0_150:InitAidUnitStatistics(var3_150)
	end

	var0_150:SubWarcry()

	local var4_150 = var0_150:GetSubList()

	for iter2_150, iter3_150 in ipairs(var4_150) do
		if iter2_150 == 1 then
			iter3_150:TriggerBuff(var3_0.BuffEffectType.ON_SUB_LEADER)
		elseif iter2_150 == 2 then
			iter3_150:TriggerBuff(var3_0.BuffEffectType.ON_UPPER_SUB_CONSORT)
		elseif iter2_150 == 3 then
			iter3_150:TriggerBuff(var3_0.BuffEffectType.ON_LOWER_SUB_CONSORT)
		end

		if iter3_150:GetAimBias() then
			arg0_150:DispatchEvent(var0_0.Event.New(var1_0.ADD_AIM_BIAS, {
				aimBias = iter3_150:GetAimBias()
			}))
		end
	end

	local var5_150 = var4_150[1]

	var1_150:Cast()
end

function var9_0.GetWaveFlags(arg0_151)
	return arg0_151._waveFlags
end

function var9_0.AddWaveFlag(arg0_152, arg1_152)
	if not arg1_152 then
		return
	end

	local var0_152 = arg0_152:GetWaveFlags()

	if table.contains(var0_152, arg1_152) then
		return
	end

	table.insert(var0_152, arg1_152)
end

function var9_0.RemoveFlag(arg0_153, arg1_153)
	if not arg1_153 then
		return
	end

	local var0_153 = arg0_153:GetWaveFlags()

	if not table.contains(var0_153, arg1_153) then
		return
	end

	table.removebyvalue(var0_153, arg1_153)
end

function var9_0.DispatchCustomWarning(arg0_154, arg1_154)
	arg0_154:DispatchEvent(var0_0.Event.New(var1_0.EDIT_CUSTOM_WARNING_LABEL, {
		labelData = arg1_154
	}))
end

function var9_0.DispatchGridmanSkill(arg0_155, arg1_155, arg2_155)
	arg0_155:DispatchEvent(var0_0.Event.New(var1_0.GRIDMAN_SKILL_FLOAT, {
		type = arg1_155,
		IFF = arg2_155
	}))
end

function var9_0.SpawnFusionUnit(arg0_156, arg1_156, arg2_156, arg3_156, arg4_156)
	local var0_156 = Clone(arg1_156:GetPosition())
	local var1_156 = arg1_156:GetIFF()
	local var2_156 = arg0_156:generatePlayerUnit(arg2_156, var1_156, var0_156, arg0_156._commanderBuff)

	var6_0.SetFusionAttrFromElement(var2_156, arg1_156, arg3_156, arg4_156)
	var2_156:SetCurrentHP(var2_156:GetMaxHP())
	arg1_156:GetFleetVO():AppendPlayerUnit(var2_156)
	arg0_156:setShipUnitBound(var2_156)
	var5_0.AttachWeather(var2_156, arg0_156._weahter)
	arg0_156._cldSystem:InitShipCld(var2_156)

	local var3_156 = {
		type = var3_0.UnitType.PLAYER_UNIT,
		unit = var2_156
	}

	arg0_156:DispatchEvent(var0_0.Event.New(var1_0.ADD_UNIT, var3_156))

	return var2_156
end

function var9_0.DefusionUnit(arg0_157, arg1_157)
	local var0_157 = arg1_157:GetIFF()
	local var1_157 = arg0_157:GetFleetByIFF(var0_157)

	var1_157:RemovePlayerUnit(arg1_157)

	local var2_157 = {}

	if var1_157:GetFleetAntiAirWeapon():GetRange() == 0 then
		var2_157.isShow = false
	end

	arg0_157:DispatchEvent(var0_0.Event.New(var1_0.ANTI_AIR_AREA, var2_157))
	arg1_157:SetDeathReason(var3_0.UnitDeathReason.DEFUSION)
	arg0_157:KillUnit(arg1_157:GetUniqueID())
end

function var9_0.FreezeUnit(arg0_158, arg1_158)
	var6_0.SetCurrent(arg1_158, var0_0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY, var4_0.FUSION_ELEMENT_UNIT_TYPE)
	arg1_158:UpdateBlindInvisibleBySpectre()
	arg0_158:SwitchSpectreUnit(arg1_158)

	if arg1_158:GetAimBias() then
		local var0_158 = arg1_158:GetAimBias()

		var0_158:RemoveCrew(arg1_158)

		if var0_158:GetCurrentState() == var0_158.STATE_EXPIRE then
			arg0_158:DispatchEvent(var0_0.Event.New(var1_0.REMOVE_AIM_BIAS, {
				aimBias = arg1_158:GetAimBias()
			}))
		end
	end

	arg1_158:Freeze()

	local var1_158 = arg1_158:GetFleetVO()

	if var1_158 then
		var1_158:FreezeUnit(arg1_158)
	end
end

function var9_0.ActiveFreezeUnit(arg0_159, arg1_159)
	var6_0.SetCurrent(arg1_159, var0_0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY, var4_0.PLAYER_DEFAULT)
	arg1_159:UpdateBlindInvisibleBySpectre()
	arg0_159:SwitchSpectreUnit(arg1_159)
	var5_0.AttachWeather(arg1_159, arg0_159._weahter)
	arg1_159:ActiveFreeze()

	local var0_159 = arg1_159:GetFleetVO()

	if var0_159 then
		var0_159:ActiveFreezeUnit(arg1_159)
	end
end
