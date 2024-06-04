ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleEvent
local var2 = var0.Battle.BattleFormulas
local var3 = var0.Battle.BattleConst
local var4 = var0.Battle.BattleConfig
local var5 = var0.Battle.BattleDataFunction
local var6 = var0.Battle.BattleAttr
local var7 = var0.Battle.BattleVariable
local var8 = var0.Battle.BattleCardPuzzleEvent
local var9 = singletonClass("BattleDataProxy", var0.MVC.Proxy)

var0.Battle.BattleDataProxy = var9
var9.__name = "BattleDataProxy"

function var9.Ctor(arg0)
	var9.super.Ctor(arg0)
end

function var9.InitBattle(arg0, arg1)
	arg0.Update = arg0.updateInit

	local var0 = arg1.battleType
	local var1 = var0 == SYSTEM_WORLD or var0 == SYSTEM_WORLD_BOSS
	local var2 = pg.SdkMgr.GetInstance():CheckPretest() and (PlayerPrefs.GetInt("stage_scratch") or 0) == 1

	arg0:SetupCalculateDamage(var2 and GodenFnger or var2.CreateContextCalculateDamage(var1))
	arg0:SetupDamageKamikazeAir()
	arg0:SetupDamageKamikazeShip()
	arg0:SetupDamageCrush()
	var7.Init()
	arg0:InitData(arg1)
	arg0:DispatchEvent(var0.Event.New(var1.STAGE_DATA_INIT_FINISH))
	arg0._cameraUtil:Initialize()

	arg0._cameraTop, arg0._cameraBottom, arg0._cameraLeft, arg0._cameraRight = arg0._cameraUtil:SetMapData(arg0:GetTotalBounds())

	arg0:InitWeatherData()
	arg0:InitUserShipsData(arg0._battleInitData.MainUnitList, arg0._battleInitData.VanguardUnitList, var4.FRIENDLY_CODE, arg0._battleInitData.SubUnitList)
	arg0:InitUserSupportShipsData(var4.FRIENDLY_CODE, arg0._battleInitData.SupportUnitList)
	arg0:InitUserAidData()
	arg0:SetSubmarinAidData()
	arg0._cameraUtil:SetFocusFleet(arg0:GetFleetByIFF(var4.FRIENDLY_CODE))
	arg0:StatisticsInit(arg0._fleetList[var4.FRIENDLY_CODE]:GetUnitList())
	arg0:SetFlagShipID(arg0:GetFleetByIFF(var4.FRIENDLY_CODE):GetFlagShip())
	arg0:DispatchEvent(var0.Event.New(var1.COMMON_DATA_INIT_FINISH, {}))
end

function var9.OnCameraRatioUpdate(arg0)
	arg0._cameraTop, arg0._cameraBottom, arg0._cameraLeft, arg0._cameraRight = arg0._cameraUtil:SetMapData(arg0:GetTotalBounds())

	arg0._cameraUtil:setArrowPoint()
end

function var9.Start(arg0)
	arg0._startTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var9.TriggerBattleInitBuffs(arg0)
	for iter0, iter1 in pairs(arg0._fleetList) do
		local var0 = iter1:GetUnitList()

		iter1:FleetBuffTrigger(var3.BuffEffectType.ON_INIT_GAME)
	end
end

function var9.TirggerBattleStartBuffs(arg0)
	for iter0, iter1 in pairs(arg0._fleetList) do
		local var0 = iter1:GetUnitList()
		local var1 = iter1:GetScoutList()
		local var2 = var1[1]
		local var3 = #var1 > 1 and var1[#var1] or nil
		local var4 = #var1 == 3 and var1[2] or nil
		local var5 = iter1:GetMainList()
		local var6 = var5[1]
		local var7 = var5[2]
		local var8 = var5[3]

		for iter2, iter3 in ipairs(var0) do
			underscore.each(arg0._battleInitData.ChapterBuffIDs or {}, function(arg0)
				local var0 = var0.Battle.BattleBuffUnit.New(arg0)

				iter3:AddBuff(var0)
			end)
			underscore.each(arg0._battleInitData.GlobalBuffIDs or {}, function(arg0)
				arg0 = tonumber(arg0)

				local var0 = var0.Battle.BattleBuffUnit.New(arg0)

				iter3:AddBuff(var0)
			end)

			if arg0._battleInitData.MapAuraSkills then
				for iter4, iter5 in ipairs(arg0._battleInitData.MapAuraSkills) do
					local var9 = var0.Battle.BattleBuffUnit.New(iter5.id, iter5.level)

					iter3:AddBuff(var9)
				end
			end

			if arg0._battleInitData.MapAidSkills then
				for iter6, iter7 in ipairs(arg0._battleInitData.MapAidSkills) do
					local var10 = var0.Battle.BattleBuffUnit.New(iter7.id, iter7.level)

					iter3:AddBuff(var10)
				end
			end

			if arg0._currentStageData.stageBuff then
				for iter8, iter9 in ipairs(arg0._currentStageData.stageBuff) do
					local var11 = var0.Battle.BattleBuffUnit.New(iter9.id, iter9.level)

					iter3:AddBuff(var11)
				end
			end

			iter3:TriggerBuff(var3.BuffEffectType.ON_START_GAME)

			if iter3 == var6 then
				iter3:TriggerBuff(var3.BuffEffectType.ON_FLAG_SHIP)
			elseif iter3 == var7 then
				iter3:TriggerBuff(var3.BuffEffectType.ON_UPPER_CONSORT)
			elseif iter3 == var8 then
				iter3:TriggerBuff(var3.BuffEffectType.ON_LOWER_CONSORT)
			elseif iter3 == var2 then
				iter3:TriggerBuff(var3.BuffEffectType.ON_LEADER)
			elseif iter3 == var4 then
				iter3:TriggerBuff(var3.BuffEffectType.ON_CENTER)
			elseif iter3 == var3 then
				iter3:TriggerBuff(var3.BuffEffectType.ON_REAR)
			end
		end

		local var12 = iter1:GetSupportUnitList()

		for iter10, iter11 in ipairs(var12) do
			underscore.each(arg0._battleInitData.ChapterBuffIDs or {}, function(arg0)
				if var5.GetSLGStrategyBuffByCombatBuffID(arg0).type == ChapterConst.AirDominanceStrategyBuffType then
					local var0 = var0.Battle.BattleBuffUnit.New(arg0)

					iter11:AddBuff(var0)
				end
			end)
		end
	end
end

function var9.InitAllFleetUnitsWeaponCD(arg0)
	for iter0, iter1 in pairs(arg0._fleetList) do
		local var0 = iter1:GetUnitList()

		for iter2, iter3 in ipairs(var0) do
			var9.InitUnitWeaponCD(iter3)
		end
	end
end

function var9.InitUnitWeaponCD(arg0)
	arg0:CheckWeaponInitial()
end

function var9.StartCardPuzzle(arg0)
	for iter0, iter1 in pairs(arg0._fleetList) do
		iter1:GetCardPuzzleComponent():Start()
	end
end

function var9.PausePuzzleComponent(arg0)
	for iter0, iter1 in pairs(arg0._fleetList) do
		local var0 = iter1:GetCardPuzzleComponent()

		if var0 then
			var0:BlockComponentByCard(true)
		end
	end
end

function var9.ResumePuzzleComponent(arg0)
	onDelayTick(function()
		for iter0, iter1 in pairs(arg0._fleetList) do
			local var0 = iter1:GetCardPuzzleComponent()

			if var0 then
				var0:BlockComponentByCard(false)
			end
		end
	end, 0.06)
end

function var9.GetInitData(arg0)
	return arg0._battleInitData
end

function var9.GetDungeonData(arg0)
	return arg0._dungeonInfo
end

function var9.InitData(arg0, arg1)
	arg0.FrameIndex = 1
	arg0._friendlyCode = 1
	arg0._foeCode = -1
	var3.FRIENDLY_CODE = 1
	var3.FOE_CODE = -1
	arg0._completelyRepress = false
	arg0._repressReduce = 1
	arg0._repressLevel = 0
	arg0._repressEnemyHpRant = 1
	arg0._friendlyShipList = {}
	arg0._foeShipList = {}
	arg0._friendlyAircraftList = {}
	arg0._foeAircraftList = {}
	arg0._minionShipList = {}
	arg0._spectreShipList = {}
	arg0._fleetList = {}
	arg0._freeShipList = {}
	arg0._teamList = {}
	arg0._waveSummonList = {}
	arg0._aidUnitList = {}
	arg0._unitList = {}
	arg0._unitCount = 0
	arg0._bulletList = {}
	arg0._bulletCount = 0
	arg0._aircraftList = {}
	arg0._aircraftCount = 0
	arg0._AOEList = {}
	arg0._AOECount = 0
	arg0._wallList = {}
	arg0._wallIndex = 0
	arg0._shelterList = {}
	arg0._shelterIndex = 0
	arg0._environmentList = {}
	arg0._environmentIndex = 0
	arg0._deadUnitList = {}
	arg0._enemySubmarineCount = 0
	arg0._airFighterList = {}
	arg0._currentStageIndex = 1
	arg0._battleInitData = arg1
	arg0._expeditionID = arg1.StageTmpId
	arg0._expeditionTmp = pg.expedition_data_template[arg0._expeditionID]

	arg0:SetDungeonLevel(arg1.WorldLevel or arg0._expeditionTmp.level)

	arg0._dungeonID = arg0._expeditionTmp.dungeon_id
	arg0._dungeonInfo = var5.GetDungeonTmpDataByID(arg0._dungeonID)

	if arg1.WorldMapId then
		arg0._mapId = arg1.WorldMapId
	elseif arg0._expeditionTmp.map_id then
		local var0 = arg0._expeditionTmp.map_id

		if #var0 == 1 then
			arg0._mapId = var0[1][1]
		else
			local var1 = {}

			for iter0, iter1 in ipairs(var0) do
				local var2 = iter1[2] * 100

				table.insert(var1, {
					rst = iter1[1],
					weight = var2
				})
			end

			arg0._mapId = var2.WeightRandom(var1)
		end
	end

	arg0._weahter = arg1.ChapterWeatherIDS or {}
	arg0._exposeSpeed = arg0._expeditionTmp.expose_speed
	arg0._airExpose = arg0._expeditionTmp.aircraft_expose[1]
	arg0._airExposeEX = arg0._expeditionTmp.aircraft_expose[2]
	arg0._shipExpose = arg0._expeditionTmp.ship_expose[1]
	arg0._shipExposeEX = arg0._expeditionTmp.ship_expose[2]
	arg0._commander = arg1.CommanderList or {}
	arg0._subCommander = arg1.SubCommanderList or {}
	arg0._commanderBuff = arg0.initCommanderBuff(arg0._commander)
	arg0._subCommanderBuff = arg0.initCommanderBuff(arg0._subCommander)

	if arg0._battleInitData.RepressInfo then
		local var3 = arg0._battleInitData.RepressInfo

		if arg0._battleInitData.battleType == SYSTEM_SCENARIO then
			if var3.repressCount >= var3.repressMax then
				arg0._completelyRepress = true
			end

			arg0._repressReduce = var2.ChapterRepressReduce(var3.repressReduce)
			arg0._repressLevel = var3.repressLevel
			arg0._repressEnemyHpRant = var3.repressEnemyHpRant
		elseif arg0._battleInitData.battleType == SYSTEM_WORLD or arg0._battleInitData.battleType == SYSTEM_WORLD_BOSS then
			arg0._repressEnemyHpRant = var3.repressEnemyHpRant
		end
	end

	arg0._chapterWinningStreak = arg0._battleInitData.DefeatCount or 0
	arg0._waveFlags = table.shallowCopy(arg1.StageWaveFlags) or {}

	arg0:InitStageData()

	arg0._cldSystem = var0.Battle.BattleCldSystem.New(arg0)
	arg0._cameraUtil = var0.Battle.BattleCameraUtil.GetInstance()

	arg0:initBGM()
end

function var9.initBGM(arg0)
	arg0._initBGMList = {}
	arg0._otherBGMList = {}

	local var0 = {}
	local var1 = {}

	local function var2(arg0)
		for iter0, iter1 in ipairs(arg0) do
			local var0 = {}

			if iter1.skills then
				for iter2, iter3 in ipairs(iter1.skills) do
					table.insert(var0, iter3)
				end
			end

			if iter1.equipment then
				local var1 = var5.GetEquipSkill(iter1.equipment, arg0._battleInitData.battleType)

				for iter4, iter5 in ipairs(var1) do
					var0[iter5] = {
						level = 1,
						id = iter5
					}
				end
			end

			local var2 = var5.GetSongList(var0)

			for iter6, iter7 in pairs(var2.initList) do
				var0[iter6] = true
			end

			for iter8, iter9 in pairs(var2.otherList) do
				var1[iter8] = true
			end
		end
	end

	var2(arg0._battleInitData.MainUnitList)
	var2(arg0._battleInitData.VanguardUnitList)
	var2(arg0._battleInitData.SubUnitList)

	if arg0._battleInitData.RivalMainUnitList then
		var2(arg0._battleInitData.RivalMainUnitList)
	end

	if arg0._battleInitData.RivalVanguardUnitList then
		var2(arg0._battleInitData.RivalVanguardUnitList)
	end

	for iter0, iter1 in pairs(var0) do
		table.insert(arg0._initBGMList, iter0)
	end

	for iter2, iter3 in pairs(var1) do
		table.insert(arg0._otherBGMList, iter2)
	end
end

function var9.initCommanderBuff(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(arg0) do
		local var1 = iter1[1]
		local var2 = var1:getSkills()[1]:getLevel()

		for iter2, iter3 in ipairs(iter1[2]) do
			table.insert(var0, {
				id = iter3,
				level = var2,
				commander = var1
			})
		end
	end

	return var0
end

function var9.Clear(arg0)
	for iter0, iter1 in pairs(arg0._teamList) do
		arg0:KillNPCTeam(iter1)
	end

	arg0._teamList = nil

	for iter2, iter3 in pairs(arg0._bulletList) do
		arg0:RemoveBulletUnit(iter2)
	end

	arg0._bulletList = nil

	for iter4, iter5 in pairs(arg0._unitList) do
		arg0:KillUnit(iter4)
	end

	arg0._unitList = nil

	for iter6, iter7 in ipairs(arg0._deadUnitList) do
		iter7:Dispose()
	end

	arg0._deadUnitList = nil

	for iter8, iter9 in pairs(arg0._aircraftList) do
		arg0:KillAircraft(iter8)
	end

	arg0._aircraftList = nil

	for iter10, iter11 in pairs(arg0._fleetList) do
		iter11:Dispose()

		arg0._fleetList[iter10] = nil
	end

	arg0._fleetList = nil

	for iter12, iter13 in pairs(arg0._aidUnitList) do
		iter13:Dispose()
	end

	arg0._aidUnitList = nil

	for iter14, iter15 in pairs(arg0._environmentList) do
		arg0:RemoveEnvironment(iter15:GetUniqueID())
	end

	arg0._environmentList = nil

	for iter16, iter17 in pairs(arg0._AOEList) do
		arg0:RemoveAreaOfEffect(iter16)
	end

	arg0._AOEList = nil

	arg0._cldSystem:Dispose()

	arg0._cldSystem = nil
	arg0._dungeonInfo = nil
	arg0._flagShipUnit = nil
	arg0._friendlyShipList = nil
	arg0._foeShipList = nil
	arg0._spectreShipList = nil
	arg0._friendlyAircraftList = nil
	arg0._foeAircraftList = nil
	arg0._fleetList = nil
	arg0._freeShipList = nil
	arg0._countDown = nil
	arg0._lastUpdateTime = nil
	arg0._statistics = nil
	arg0._battleInitData = nil
	arg0._currentStageData = nil

	arg0:ClearFormulas()
	var5.ClearDungeonCfg(arg0._dungeonID)
end

function var9.DeactiveProxy(arg0)
	arg0._state = nil

	arg0:Clear()
	var0.Battle.BattleDataProxy.super.DeactiveProxy(arg0)
end

function var9.InitUserShipsData(arg0, arg1, arg2, arg3, arg4)
	for iter0, iter1 in ipairs(arg2) do
		local var0 = arg0:SpawnVanguard(iter1, arg3)
	end

	for iter2, iter3 in ipairs(arg1) do
		local var1 = arg0:SpawnMain(iter3, arg3)
	end

	local var2 = arg0:GetFleetByIFF(arg3)

	var2:FleetUnitSpwanFinish()

	local var3 = arg0._battleInitData.battleType

	if var3 == SYSTEM_SUBMARINE_RUN or var3 == SYSTEM_SUB_ROUTINE then
		for iter4, iter5 in ipairs(arg4) do
			arg0:SpawnManualSub(iter5, arg3)
		end

		var2:ShiftManualSub()
	else
		var2:SetSubUnitData(arg4)
	end

	if arg0._battleInitData.battleType == SYSTEM_DUEL then
		for iter6, iter7 in ipairs(var2:GetCloakList()) do
			iter7:GetCloak():SetRecoverySpeed(0)
		end
	end

	arg0:DispatchEvent(var0.Event.New(var1.ADD_FLEET, {
		fleetVO = var2
	}))
end

function var9.InitUserSupportShipsData(arg0, arg1, arg2)
	local var0 = arg0:GetFleetByIFF(arg1)

	for iter0, iter1 in ipairs(arg2) do
		local var1 = arg0:SpawnSupportUnit(iter1, arg1)
	end
end

function var9.InitUserAidData(arg0)
	for iter0, iter1 in ipairs(arg0._battleInitData.AidUnitList) do
		local var0 = arg0:GenerateUnitID()
		local var1 = iter1.properties

		var1.level = iter1.level
		var1.formationID = var4.FORMATION_ID
		var1.id = iter1.id

		var2.AttrFixer(arg0._battleInitData.battleType, var1)

		local var2 = iter1.proficiency or {
			1,
			1,
			1
		}
		local var3 = var5.CreateBattleUnitData(var0, var3.UnitType.PLAYER_UNIT, var4.FRIENDLY_CODE, iter1.tmpID, iter1.skinId, iter1.equipment, var1, iter1.baseProperties, var2, iter1.baseList, iter1.preloasList)

		arg0._aidUnitList[var3:GetUniqueID()] = var3
	end
end

function var9.SetSubmarinAidData(arg0)
	arg0:GetFleetByIFF(var4.FRIENDLY_CODE):SetSubAidData(arg0._battleInitData.TotalSubAmmo, arg0._battleInitData.SubFlag)
end

function var9.AddWeather(arg0, arg1)
	table.insert(arg0._weahter, arg1)
	arg0:InitWeatherData()
end

function var9.InitWeatherData(arg0)
	for iter0, iter1 in ipairs(arg0._weahter) do
		if iter1 == var3.WEATHER.NIGHT then
			for iter2, iter3 in pairs(arg0._fleetList) do
				iter3:AttachNightCloak()
			end

			for iter4, iter5 in pairs(arg0._unitList) do
				var5.AttachWeather(iter5, arg0._weahter)
			end
		end
	end
end

function var9.CelebrateVictory(arg0, arg1)
	local var0

	if arg1 == arg0:GetFoeCode() then
		var0 = arg0._foeShipList
	else
		var0 = arg0._friendlyShipList
	end

	for iter0, iter1 in pairs(var0) do
		iter1:StateChange(var0.Battle.UnitState.STATE_VICTORY)
	end
end

function var9.InitStageData(arg0)
	arg0._currentStageData = arg0._dungeonInfo.stages[arg0._currentStageIndex]
	arg0._countDown = arg0._currentStageData.timeCount

	local var0 = arg0._currentStageData.totalArea

	arg0._totalLeftBound = var0[1]
	arg0._totalRightBound = var0[1] + var0[3]
	arg0._totalUpperBound = var0[2] + var0[4]
	arg0._totalLowerBound = var0[2]

	local var1 = arg0._currentStageData.playerArea

	arg0._leftZoneLeftBound = var1[1]
	arg0._leftZoneRightBound = var1[1] + var1[3]
	arg0._leftZoneUpperBound = var1[2] + var1[4]
	arg0._leftZoneLowerBound = var1[2]
	arg0._rightZoneLeftBound = arg0._leftZoneRightBound
	arg0._rightZoneRightBound = arg0._totalRightBound
	arg0._rightZoneUpperBound = arg0._leftZoneUpperBound
	arg0._rightZoneLowerBound = arg0._leftZoneLowerBound
	arg0._bulletUpperBound = arg0._totalUpperBound + 3
	arg0._bulletLowerBound = arg0._totalLowerBound - 10
	arg0._bulletLeftBound = arg0._totalLeftBound - 10
	arg0._bulletRightBound = arg0._totalRightBound + 10
	arg0._bulletUpperBoundVision = arg0._totalUpperBound + var4.BULLET_UPPER_BOUND_VISION_OFFSET
	arg0._bulletLowerBoundSplit = arg0._bulletLowerBound + var4.BULLET_LOWER_BOUND_SPLIT_OFFSET
	arg0._bulletLeftBoundSplit = arg0._bulletLeftBound + var4.BULLET_LEFT_BOUND_SPLIT_OFFSET

	if arg0._battleInitData.battleType == SYSTEM_DUEL then
		arg0._leftFieldBound = arg0._totalLeftBound
		arg0._rightFieldBound = arg0._totalRightBound
	else
		local var2

		if arg0._currentStageData.mainUnitPosition and arg0._currentStageData.mainUnitPosition[var4.FRIENDLY_CODE] then
			var2 = arg0._currentStageData.mainUnitPosition[var4.FRIENDLY_CODE][1].x
		else
			var2 = var4.MAIN_UNIT_POS[var4.FRIENDLY_CODE][1].x
		end

		arg0._leftFieldBound = var2 - 1
		arg0._rightFieldBound = arg0._totalRightBound + var4.FIELD_RIGHT_BOUND_BIAS
	end
end

function var9.GetVanguardBornCoordinate(arg0, arg1)
	if arg1 == var4.FRIENDLY_CODE then
		return arg0._currentStageData.fleetCorrdinate
	elseif arg1 == var4.FOE_CODE then
		return arg0._currentStageData.rivalCorrdinate
	end
end

function var9.GetTotalBounds(arg0)
	return arg0._totalUpperBound, arg0._totalLowerBound, arg0._totalLeftBound, arg0._totalRightBound
end

function var9.GetTotalRightBound(arg0)
	return arg0._totalRightBound
end

function var9.GetTotalLowerBound(arg0)
	return arg0._totalLowerBound
end

function var9.GetUnitBoundByIFF(arg0, arg1)
	if arg1 == var4.FRIENDLY_CODE then
		return arg0._leftZoneUpperBound, arg0._leftZoneLowerBound, arg0._leftZoneLeftBound, var4.MaxRight, var4.MaxLeft, arg0._leftZoneRightBound
	elseif arg1 == var4.FOE_CODE then
		return arg0._rightZoneUpperBound, arg0._rightZoneLowerBound, arg0._rightZoneLeftBound, arg0._rightZoneRightBound, arg0._rightZoneLeftBound, var4.MaxRight
	end
end

function var9.GetFleetBoundByIFF(arg0, arg1)
	if arg1 == var4.FRIENDLY_CODE then
		return arg0._leftZoneUpperBound, arg0._leftZoneLowerBound, arg0._leftZoneLeftBound, arg0._leftZoneRightBound
	elseif arg1 == var4.FOE_CODE then
		return arg0._rightZoneUpperBound, arg0._rightZoneLowerBound, arg0._rightZoneLeftBound, arg0._rightZoneRightBound
	end
end

function var9.ShiftFleetBound(arg0, arg1, arg2)
	arg1:GetUnitBound():SwtichDuelAggressive()
	arg1:SetAutobotBound(arg0:GetFleetBoundByIFF(arg2))
	arg1:UpdateScoutUnitBound()
end

function var9.GetFieldBound(arg0)
	if arg0._battleInitData and arg0._battleInitData.battleType == SYSTEM_DUEL then
		return arg0:GetTotalBounds()
	else
		return arg0._totalUpperBound, arg0._totalLowerBound, arg0._leftFieldBound, arg0._rightFieldBound
	end
end

function var9.GetFleetByIFF(arg0, arg1)
	if arg0._fleetList[arg1] == nil then
		local var0 = var0.Battle.BattleFleetVO.New(arg1)

		arg0._fleetList[arg1] = var0

		var0:SetAutobotBound(arg0:GetFleetBoundByIFF(arg1))
		var0:SetTotalBound(arg0:GetTotalBounds())
		var0:SetUnitBound(arg0._currentStageData.totalArea, arg0._currentStageData.playerArea)
		var0:SetExposeLine(arg0._expeditionTmp.horizon_line[arg1], arg0._expeditionTmp.expose_line[arg1])
		var0:CalcSubmarineBaseLine(arg0._battleInitData.battleType)

		if arg0._battleInitData.battleType == SYSTEM_CARDPUZZLE then
			local var1 = var0:AttachCardPuzzleComponent()
			local var2 = {
				cardList = arg0._battleInitData.CardPuzzleCardIDList,
				commonHP = arg0._battleInitData.CardPuzzleCommonHPValue,
				relicList = arg0._battleInitData.CardPuzzleRelicList
			}

			var1:InitCardPuzzleData(var2)
			var1:CustomConfigID(arg0._battleInitData.CardPuzzleCombatID)
			arg0:DispatchEvent(var0.Event.New(var8.CARD_PUZZLE_INIT))
		end
	end

	return arg0._fleetList[arg1]
end

function var9.GetAidUnit(arg0)
	return arg0._aidUnitList
end

function var9.GetFleetList(arg0)
	return arg0._fleetList
end

function var9.GetEnemySubmarineCount(arg0)
	return arg0._enemySubmarineCount
end

function var9.GetCommander(arg0)
	return arg0._commander
end

function var9.GetCommanderBuff(arg0)
	return arg0._commanderBuff, arg0._subCommanderBuff
end

function var9.GetStageInfo(arg0)
	return arg0._currentStageData
end

function var9.GetWinningStreak(arg0)
	return arg0._chapterWinningStreak
end

function var9.GetBGMList(arg0, arg1)
	if not arg1 then
		return arg0._initBGMList
	else
		return arg0._otherBGMList
	end
end

function var9.GetDungeonLevel(arg0)
	return arg0._dungeonLevel
end

function var9.SetDungeonLevel(arg0, arg1)
	arg0._dungeonLevel = arg1
end

function var9.IsCompletelyRepress(arg0)
	return arg0._completelyRepress
end

function var9.GetRepressReduce(arg0)
	return arg0._repressReduce
end

function var9.GetRepressLevel(arg0)
	return arg0._repressLevel
end

function var9.updateInit(arg0, arg1)
	arg0:TriggerBattleInitBuffs()

	arg0.checkCld = true

	arg0:updateLoop(arg1)

	arg0.Update = arg0.updateLoop
end

function var9.updateLoop(arg0, arg1)
	arg0.FrameIndex = arg0.FrameIndex + 1

	arg0:updateDeadList()
	arg0:UpdateCountDown(arg1)
	arg0:UpdateWeather(arg1)

	for iter0, iter1 in pairs(arg0._fleetList) do
		iter1:UpdateMotion()
	end

	arg0.checkCld = not arg0.checkCld

	local var0 = {
		[var4.FRIENDLY_CODE] = arg0._totalLeftBound,
		[var4.FOE_CODE] = arg0._totalRightBound
	}

	for iter2, iter3 in pairs(arg0._unitList) do
		if iter3:IsSpectre() then
			if iter3:GetAttrByName(var0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY) <= var4.FUSION_ELEMENT_UNIT_TYPE then
				-- block empty
			else
				iter3:Update(arg1)
			end
		else
			if arg0.checkCld then
				arg0._cldSystem:UpdateShipCldTree(iter3)
			end

			if iter3:IsAlive() then
				iter3:Update(arg1)
			end

			local var1 = iter3:GetPosition().x
			local var2 = iter3:GetIFF()

			if var2 == var4.FRIENDLY_CODE then
				var0[var2] = math.max(var0[var2], var1)
			elseif var2 == var4.FOE_CODE then
				var0[var2] = math.min(var0[var2], var1)
			end
		end
	end

	local var3 = arg0._fleetList[var4.FRIENDLY_CODE]
	local var4 = var3:GetFleetExposeLine()
	local var5 = var3:GetFleetVisionLine()
	local var6 = var0[var4.FOE_CODE]

	if var4 and var6 < var4 then
		var3:CloakFatalExpose()
	elseif var6 < var5 then
		var3:CloakInVision(arg0._exposeSpeed)
	else
		var3:CloakOutVision()
	end

	if arg0._fleetList[var4.FOE_CODE] then
		local var7 = arg0._fleetList[var4.FOE_CODE]
		local var8 = var7:GetFleetExposeLine()
		local var9 = var7:GetFleetVisionLine()
		local var10 = var0[var4.FRIENDLY_CODE]

		if var8 and var8 < var10 then
			var7:CloakFatalExpose()
		elseif var9 < var10 then
			var7:CloakInVision(arg0._exposeSpeed)
		else
			var7:CloakOutVision()
		end
	end

	for iter4, iter5 in pairs(arg0._bulletList) do
		local var11 = iter5:GetSpeed()
		local var12 = iter5:GetPosition()
		local var13 = iter5:GetType()
		local var14 = iter5:GetOutBound()

		if var14 == var3.BulletOutBound.SPLIT and var13 == var3.BulletType.SHRAPNEL and (var12.x > arg0._bulletRightBound and var11.x > 0 or var12.x < arg0._bulletLeftBoundSplit and var11.x < 0 or var12.z > arg0._bulletUpperBound and var11.z > 0 or var12.z < arg0._bulletLowerBoundSplit and var11.z < 0) then
			if iter5:GetExist() then
				iter5:OutRange()
			else
				arg0:RemoveBulletUnit(iter5:GetUniqueID())
			end
		elseif var14 == var3.BulletOutBound.COMMON and (var12.x > arg0._bulletRightBound and var11.x > 0 or var12.z < arg0._bulletLowerBound and var11.z < 0) then
			arg0:RemoveBulletUnit(iter5:GetUniqueID())
		elseif var12.x < arg0._bulletLeftBound and var11.x < 0 and var13 ~= var3.BulletType.BOMB then
			if var14 == var3.BulletOutBound.RANDOM then
				local var15 = arg0._fleetList[var4.FRIENDLY_CODE]:RandomMainVictim()

				if var15 then
					arg0:HandleDamage(iter5, var15)
				end
			end

			arg0:RemoveBulletUnit(iter5:GetUniqueID())
		else
			iter5:Update(arg1)

			local var16 = iter5.GetCurrentState and iter5:GetCurrentState() or nil

			if var16 == var0.Battle.BattleShrapnelBulletUnit.STATE_FINAL_SPLIT then
				-- block empty
			elseif var16 == var0.Battle.BattleShrapnelBulletUnit.STATE_SPLIT and not iter5:IsFragile() then
				-- block empty
			elseif var14 == var3.BulletOutBound.COMMON and var12.z > arg0._bulletUpperBound and var11.z > 0 or var14 == var3.BulletOutBound.VISION and var12.z > arg0._bulletUpperBoundVision and var11.z > 0 or iter5:IsOutRange(arg1) then
				if iter5:GetExist() then
					iter5:OutRange()
				else
					arg0:RemoveBulletUnit(iter5:GetUniqueID())
				end
			elseif arg0.checkCld then
				arg0._cldSystem:UpdateBulletCld(iter5)
			end
		end
	end

	for iter6, iter7 in pairs(arg0._aircraftList) do
		iter7:Update(arg1)

		local var17, var18 = iter7:GetIFF()

		if var17 == var4.FRIENDLY_CODE then
			var18 = arg0._totalRightBound
		elseif var17 == var4.FOE_CODE then
			var18 = arg0._totalLeftBound
		end

		if iter7:GetPosition().x * var17 > math.abs(var18) and iter7:GetSpeed().x * var17 > 0 then
			iter7:OutBound()
		else
			arg0._cldSystem:UpdateAircraftCld(iter7)
		end

		if not iter7:IsAlive() then
			arg0:KillAircraft(iter7:GetUniqueID())
		end
	end

	for iter8, iter9 in pairs(arg0._AOEList) do
		arg0._cldSystem:UpdateAOECld(iter9)
		iter9:Settle()

		if iter9:GetActiveFlag() == false then
			iter9:SettleFinale()
			arg0:RemoveAreaOfEffect(iter9:GetUniqueID())
		end
	end

	for iter10, iter11 in pairs(arg0._environmentList) do
		iter11:Update()

		if iter11:IsExpire(arg1) then
			arg0:RemoveEnvironment(iter11:GetUniqueID())
		end
	end

	if arg0.checkCld then
		for iter12, iter13 in pairs(arg0._shelterList) do
			if not iter13:IsWallActive() then
				arg0:RemoveShelter(iter13:GetUniqueID())
			else
				iter13:Update(arg1)
			end
		end

		for iter14, iter15 in pairs(arg0._wallList) do
			if iter15:IsActive() then
				arg0._cldSystem:UpdateWallCld(iter15)
			end
		end
	end

	if arg0._battleInitData.battleType ~= SYSTEM_DUEL then
		for iter16, iter17 in pairs(arg0._foeShipList) do
			if iter17:GetPosition().x + iter17:GetBoxSize().x < arg0._leftZoneLeftBound then
				iter17:SetDeathReason(var3.UnitDeathReason.TOUCHDOWN)
				iter17:DeadAction()
				arg0:KillUnit(iter17:GetUniqueID())
				arg0:HandleShipMissDamage(iter17, arg0._fleetList[var4.FRIENDLY_CODE])
			end
		end
	end
end

function var9.UpdateAutoComponent(arg0, arg1)
	for iter0, iter1 in pairs(arg0._fleetList) do
		iter1:UpdateAutoComponent(arg1)
	end

	for iter2, iter3 in pairs(arg0._teamList) do
		if iter3:IsFatalDamage() then
			arg0:KillNPCTeam(iter2)
		else
			iter3:UpdateMotion()
		end
	end

	for iter4, iter5 in pairs(arg0._freeShipList) do
		iter5:UpdateOxygen(arg1)
		iter5:UpdateWeapon(arg1)
		iter5:UpdatePhaseSwitcher()
	end
end

function var9.UpdateWeather(arg0, arg1)
	for iter0, iter1 in ipairs(arg0._weahter) do
		if iter1 == var3.WEATHER.NIGHT then
			local var0 = {
				[var4.FRIENDLY_CODE] = 0,
				[var4.FOE_CODE] = 0
			}
			local var1 = {
				[var4.FRIENDLY_CODE] = 0,
				[var4.FOE_CODE] = 0
			}
			local var2 = {
				[var4.FRIENDLY_CODE] = 0,
				[var4.FOE_CODE] = 0
			}

			for iter2, iter3 in pairs(arg0._unitList) do
				local var3 = iter3:GetAimBias()

				if not var3 or var3:GetCurrentState() ~= var3.STATE_SUMMON_SICKNESS then
					local var4 = iter3:GetIFF()
					local var5 = var1[var4]
					local var6 = var6.GetCurrent(iter3, "attackRating")
					local var7 = var6.GetCurrent(iter3, "aimBiasExtraACC")

					var1[var4] = math.max(var5, var6)
					var2[var4] = var2[var4] + var7

					if ShipType.ContainInLimitBundle(ShipType.BundleAntiSubmarine, iter3:GetTemplate().type) then
						var0[var4] = math.max(var0[var4], var6)
					end
				end
			end

			for iter4, iter5 in pairs(arg0._fleetList) do
				local var8 = iter5:GetFleetBias()
				local var9 = iter4 * -1

				var8:SetDecayFactor(var1[var9], var2[var9])
				var8:Update(arg1)

				for iter6, iter7 in ipairs(iter5:GetSubList()) do
					local var10 = iter7:GetAimBias()

					if var10:GetDecayFactorType() == var10.DIVING then
						var10:SetDecayFactor(var0[var9], var2[var9])
					else
						var10:SetDecayFactor(var1[var9], var2[var9])
					end

					var10:Update(arg1)
				end
			end

			for iter8, iter9 in pairs(arg0._freeShipList) do
				local var11 = iter9:GetIFF() * -1
				local var12 = iter9:GetAimBias()

				if var12:GetDecayFactorType() == var12.DIVING then
					var12:SetDecayFactor(var0[var11], var2[var11])
				else
					var12:SetDecayFactor(var1[var11], var2[var11])
				end

				var12:Update(arg1)
			end
		end
	end
end

function var9.UpdateEscapeOnly(arg0, arg1)
	for iter0, iter1 in pairs(arg0._foeShipList) do
		iter1:Update(arg1)
	end
end

function var9.UpdateCountDown(arg0, arg1)
	arg0._lastUpdateTime = arg0._lastUpdateTime or arg1

	local var0 = arg0._countDown - (arg1 - arg0._lastUpdateTime)

	if var0 <= 0 then
		var0 = 0
	end

	if math.floor(arg0._countDown - var0) == 0 or var0 == 0 then
		arg0:DispatchEvent(var0.Event.New(var1.UPDATE_COUNT_DOWN, {}))
	end

	arg0._countDown = var0
	arg0._totalTime = arg1 - arg0._startTimeStamp
	arg0._lastUpdateTime = arg1
end

function var9.SpawnMonster(arg0, arg1, arg2, arg3, arg4, arg5)
	local var0 = arg0:GenerateUnitID()
	local var1 = var5.GetMonsterTmpDataFromID(arg1.monsterTemplateID)
	local var2 = {}

	for iter0, iter1 in ipairs(var1.equipment_list) do
		table.insert(var2, {
			id = iter1
		})
	end

	local var3 = var1.random_equipment_list
	local var4 = var1.random_nub

	for iter2, iter3 in ipairs(var3) do
		local var5 = var4[iter2]
		local var6 = Clone(iter3)

		for iter4 = 1, var5 do
			local var7 = math.random(#var6)

			table.insert(var2, {
				id = var6[var7]
			})
			table.remove(var6, var7)
		end
	end

	local var8 = var5.CreateBattleUnitData(var0, arg3, arg4, arg1.monsterTemplateID, nil, var2, arg1.extraInfo, nil, nil, nil, nil, arg1.level)

	var6.MonsterAttrFixer(arg0._battleInitData.battleType, var8)

	local var9

	if arg1.immuneHPInherit then
		var9 = var8:GetMaxHP()
	else
		var9 = math.ceil(var8:GetMaxHP() * arg0._repressEnemyHpRant)
	end

	if var9 <= 0 then
		var9 = 1
	end

	var8:SetCurrentHP(var9)

	local var10 = var2.RandomPos(arg1.corrdinate)

	var8:SetPosition(var10)
	var8:SetAI(arg1.pilotAITemplateID or var1.pilot_ai_template_id)
	arg0:setShipUnitBound(var8)

	if table.contains(TeamType.SubShipType, var1.type) then
		var8:InitOxygen()
		arg0:UpdateHostileSubmarine(true)
	end

	var5.AttachWeather(var8, arg0._weahter)

	arg0._freeShipList[var0] = var8
	arg0._unitList[var0] = var8

	if var8:IsSpectre() then
		var8:UpdateBlindInvisibleBySpectre()
	else
		arg0._cldSystem:InitShipCld(var8)
	end

	local var11 = arg1.sickness or var3.SUMMONING_SICKNESS_DURATION

	var8:SummonSickness(var11)
	var8:SetMoveCast(arg1.moveCast == true)

	if var8:GetIFF() == var4.FRIENDLY_CODE then
		arg0._friendlyShipList[var0] = var8
	else
		if var8:IsSpectre() then
			arg0._spectreShipList[var0] = var8
		else
			arg0._foeShipList[var0] = var8
		end

		var8:SetWaveIndex(arg2)
	end

	if arg1.reinforce then
		var8:Reinforce()
	end

	if arg1.reinforceDelay then
		var8:SetReinforceCastTime(arg1.reinforceDelay)
	end

	if arg1.team then
		arg0:GetNPCTeam(arg1.team):AppendUnit(var8)
	end

	if arg1.phase then
		var0.Battle.BattleUnitPhaseSwitcher.New(var8):SetTemplateData(arg1.phase)
	end

	if arg5 then
		arg5(var8)
	end

	local var12 = {
		type = arg3,
		unit = var8,
		bossData = arg1.bossData,
		extraInfo = arg1.extraInfo
	}

	arg0:DispatchEvent(var0.Event.New(var1.ADD_UNIT, var12))

	local function var13(arg0)
		for iter0, iter1 in ipairs(arg0) do
			local var0
			local var1
			local var2

			if type(iter1) == "number" then
				var1 = iter1
				var2 = 1
			else
				var1 = iter1.ID
				var2 = iter1.LV or 1
			end

			local var3 = var0.Battle.BattleBuffUnit.New(var1, var2, var8)

			var8:AddBuff(var3)
		end
	end

	local var14 = var8:GetTemplate().buff_list
	local var15 = arg1.buffList or {}
	local var16 = arg0._battleInitData.ExtraBuffList or {}
	local var17 = arg0._battleInitData.AffixBuffList or {}

	var13(var14)
	var13(var16)
	var13(var15)

	if arg1.affix then
		var13(var17)
	end

	local var18 = arg1.summonWaveIndex

	if var18 then
		arg0._waveSummonList[var18] = arg0._waveSummonList[var18] or {}
		arg0._waveSummonList[var18][var8] = true
	end

	var8:CheckWeaponInitial()

	if arg0._battleInitData.CMDArgs and var8:GetTemplateID() == arg0._battleInitData.CMDArgs then
		arg0:InitSpecificEnemyStatistics(var8)
	end

	var8:OverrideDeadFX(arg1.deadFX)

	if BATTLE_ENEMY_AIMBIAS_RANGE and var8:GetAimBias() then
		arg0:DispatchEvent(var0.Event.New(var1.ADD_AIM_BIAS, {
			aimBias = var8:GetAimBias()
		}))
	end

	return var8
end

function var9.UpdateHostileSubmarine(arg0, arg1)
	if arg1 then
		arg0._enemySubmarineCount = arg0._enemySubmarineCount + 1
	else
		arg0._enemySubmarineCount = arg0._enemySubmarineCount - 1
	end

	arg0:DispatchEvent(var0.Event.New(var1.UPDATE_HOSTILE_SUBMARINE))
end

function var9.SpawnNPC(arg0, arg1, arg2)
	local var0 = arg0:GenerateUnitID()
	local var1 = var3.UnitType.MINION_UNIT
	local var2 = var5.GetMonsterTmpDataFromID(arg1.monsterTemplateID)
	local var3 = {}

	for iter0, iter1 in ipairs(var2.equipment_list) do
		table.insert(var3, {
			id = iter1
		})
	end

	local var4 = var5.CreateBattleUnitData(var0, var1, arg2:GetIFF(), arg1.monsterTemplateID, nil, var3, arg1.extraInfo, nil, nil, nil, nil, arg1.level)

	var4:SetMaster(arg2)
	var4:InheritMasterAttr()

	local var5 = var4:GetMaxHP()

	var4:SetCurrentHP(var5)

	local var6

	if arg1.corrdinate then
		var6 = var2.RandomPos(arg1.corrdinate)
	else
		var6 = Clone(arg2:GetPosition())
	end

	var4:SetPosition(var6)
	var4:SetAI(arg1.pilotAITemplateID or var2.pilot_ai_template_id)
	arg0:setShipUnitBound(var4)

	if table.contains(TeamType.SubShipType, var2.type) then
		var4:InitOxygen()

		if var4:GetIFF() ~= var4.FRIENDLY_CODE then
			arg0:UpdateHostileSubmarine(true)
		end
	end

	var5.AttachWeather(var4, arg0._weahter)

	arg0._freeShipList[var0] = var4
	arg0._unitList[var0] = var4

	arg0._cldSystem:InitShipCld(var4)
	var4:SummonSickness(var3.SUMMONING_SICKNESS_DURATION)
	var4:SetMoveCast(arg1.moveCast == true)

	arg0._minionShipList[var0] = var4

	if arg1.phase then
		var0.Battle.BattleUnitPhaseSwitcher.New(var4):SetTemplateData(arg1.phase)
	end

	local var7 = {
		type = var1,
		unit = var4,
		bossData = arg1.bossData,
		extraInfo = arg1.extraInfo
	}

	arg0:DispatchEvent(var0.Event.New(var1.ADD_UNIT, var7))

	local function var8(arg0)
		for iter0, iter1 in ipairs(arg0) do
			local var0
			local var1
			local var2

			if type(iter1) == "number" then
				var1 = iter1
				var2 = 1
			else
				var1 = iter1.ID
				var2 = iter1.LV or 1
			end

			local var3 = var0.Battle.BattleBuffUnit.New(var1, var2, var4)

			var4:AddBuff(var3)
		end
	end

	local var9 = var4:GetTemplate().buff_list
	local var10 = arg1.buffList or {}

	var8(var9)
	var8(var10)
	var4:CheckWeaponInitial()

	return var4
end

function var9.EnemyEscape(arg0)
	for iter0, iter1 in pairs(arg0._foeShipList) do
		if iter1:ContainsLabelTag(var4.ESCAPE_EXPLO_TAG) then
			iter1:SetDeathReason(var3.UnitDeathReason.CLS)
			iter1:DeadAction()
		else
			iter1:RemoveAllAutoWeapon()
			iter1:SetAI(var4.COUNT_DOWN_ESCAPE_AI_ID)
		end
	end
end

function var9.GetNPCTeam(arg0, arg1)
	if not arg0._teamList[arg1] then
		arg0._teamList[arg1] = var0.Battle.BattleTeamVO.New(arg1)
	end

	return arg0._teamList[arg1]
end

function var9.KillNPCTeam(arg0, arg1)
	local var0 = arg0._teamList[arg1]

	if var0 then
		var0:Dispose()

		arg0._teamList[arg1] = nil
	end
end

function var9.SpawnVanguard(arg0, arg1, arg2)
	local var0 = arg0:GetVanguardBornCoordinate(arg2)
	local var1 = arg0:generatePlayerUnit(arg1, arg2, BuildVector3(var0), arg0._commanderBuff)

	arg0:GetFleetByIFF(arg2):AppendPlayerUnit(var1)
	arg0:setShipUnitBound(var1)
	var5.AttachWeather(var1, arg0._weahter)
	arg0._cldSystem:InitShipCld(var1)

	local var2 = {
		type = var3.UnitType.PLAYER_UNIT,
		unit = var1
	}

	arg0:DispatchEvent(var0.Event.New(var1.ADD_UNIT, var2))

	return var1
end

function var9.SpawnMain(arg0, arg1, arg2)
	local var0
	local var1 = arg0:GetFleetByIFF(arg2)
	local var2 = #var1:GetMainList() + 1

	if arg0._currentStageData.mainUnitPosition and arg0._currentStageData.mainUnitPosition[arg2] then
		var0 = Clone(arg0._currentStageData.mainUnitPosition[arg2][var2])
	else
		var0 = Clone(var4.MAIN_UNIT_POS[arg2][var2])
	end

	local var3 = arg0:generatePlayerUnit(arg1, arg2, var0, arg0._commanderBuff)

	var3:SetBornPosition(var0)
	var3:SetMainFleetUnit()

	local var4 = var0.x

	if var4 < arg0._totalLeftBound or var4 > arg0._totalRightBound then
		var3:SetImmuneCommonBulletCLD()
	end

	var1:AppendPlayerUnit(var3)
	arg0:setShipUnitBound(var3)
	var5.AttachWeather(var3, arg0._weahter)
	arg0._cldSystem:InitShipCld(var3)

	local var5 = {
		type = var3.UnitType.PLAYER_UNIT,
		unit = var3
	}

	arg0:DispatchEvent(var0.Event.New(var1.ADD_UNIT, var5))

	return var3
end

function var9.SpawnSub(arg0, arg1, arg2)
	local var0
	local var1 = arg0:GetFleetByIFF(arg2)
	local var2 = #var1:GetSubList() + 1
	local var3 = var4.SUB_UNIT_OFFSET_X + (var5.GetPlayerShipTmpDataFromID(arg1.tmpID).summon_offset or 0)

	if arg2 == var4.FRIENDLY_CODE then
		var0 = Vector3(var3 + arg0._totalLeftBound, 0, var4.SUB_UNIT_POS_Z[var2])
	else
		var0 = Vector3(arg0._totalRightBound - var3, 0, var4.SUB_UNIT_POS_Z[var2])
	end

	local var4 = arg0:generatePlayerUnit(arg1, arg2, var0, arg0._subCommanderBuff)

	var1:AddSubMarine(var4)
	arg0:setShipUnitBound(var4)
	var5.AttachWeather(var4, arg0._weahter)
	arg0._cldSystem:InitShipCld(var4)

	local var5 = {
		type = var3.UnitType.PLAYER_UNIT,
		unit = var4
	}

	arg0:DispatchEvent(var0.Event.New(var1.ADD_UNIT, var5))

	return var4
end

function var9.SpawnManualSub(arg0, arg1, arg2)
	local var0 = arg0:GetVanguardBornCoordinate(arg2)
	local var1 = arg0:generatePlayerUnit(arg1, arg2, BuildVector3(var0), arg0._commanderBuff)

	arg0:GetFleetByIFF(arg2):AddManualSubmarine(var1)
	arg0:setShipUnitBound(var1)
	arg0._cldSystem:InitShipCld(var1)

	local var2 = {
		type = var3.UnitType.SUB_UNIT,
		unit = var1
	}

	arg0:DispatchEvent(var0.Event.New(var1.ADD_UNIT, var2))

	return var1
end

function var9.SpawnSupportUnit(arg0, arg1, arg2)
	local var0 = arg0:generateSupportPlayerUnit(arg1, arg2)

	arg0:GetFleetByIFF(arg2):AppendSupportUnit(var0)

	return var0
end

function var9.ShutdownPlayerUnit(arg0, arg1)
	local var0 = arg0._unitList[arg1]
	local var1 = var0:GetIFF()
	local var2 = arg0:GetFleetByIFF(var1)

	var2:RemovePlayerUnit(var0)

	local var3 = {}

	if var2:GetFleetAntiAirWeapon():GetRange() == 0 then
		var3.isShow = false
	end

	arg0:DispatchEvent(var0.Event.New(var1.ANTI_AIR_AREA, var3))

	local var4 = {
		unit = var0
	}

	arg0:DispatchEvent(var0.Event.New(var1.SHUT_DOWN_PLAYER, var4))
end

function var9.updateDeadList(arg0)
	local var0 = #arg0._deadUnitList

	while var0 > 0 do
		arg0._deadUnitList[var0]:Dispose()

		arg0._deadUnitList[var0] = nil
		var0 = var0 - 1
	end
end

function var9.KillUnit(arg0, arg1)
	local var0 = arg0._unitList[arg1]

	if var0 == nil then
		return
	end

	local var1 = var0:GetUnitType()

	arg0._cldSystem:DeleteShipCld(var0)
	var0:Clear()

	arg0._unitList[arg1] = nil

	if arg0._freeShipList[arg1] then
		arg0._freeShipList[arg1] = nil
	end

	local var2 = var0:GetIFF()
	local var3 = var0:GetDeathReason()

	if var0:GetAimBias() then
		local var4 = var0:GetAimBias()

		var4:RemoveCrew(var0)

		if var4:GetCurrentState() == var4.STATE_EXPIRE then
			arg0:DispatchEvent(var0.Event.New(var1.REMOVE_AIM_BIAS, {
				aimBias = var0:GetAimBias()
			}))
		end
	end

	if var0:IsSpectre() then
		arg0._spectreShipList[arg1] = nil
	elseif var2 == var4.FOE_CODE then
		arg0._foeShipList[arg1] = nil

		if var1 == var3.UnitType.ENEMY_UNIT or var1 == var3.UnitType.BOSS_UNIT then
			if var0:GetTeam() then
				var0:GetTeam():RemoveUnit(var0)
			end

			local var5 = var0:GetTemplate().type

			if table.contains(TeamType.SubShipType, var5) then
				arg0:UpdateHostileSubmarine(false)
			end

			local var6 = var0:GetWaveIndex()

			if var6 and arg0._waveSummonList[var6] then
				arg0._waveSummonList[var6][var0] = nil
			end
		end
	elseif var2 == var4.FRIENDLY_CODE then
		arg0._friendlyShipList[arg1] = nil
	end

	local var7 = {
		UID = arg1,
		type = var1,
		deadReason = var3,
		unit = var0
	}

	arg0:DispatchEvent(var0.Event.New(var1.REMOVE_UNIT, var7))
	table.insert(arg0._deadUnitList, var0)
end

function var9.KillAllEnemy(arg0)
	for iter0, iter1 in pairs(arg0._unitList) do
		if iter1:GetIFF() == var4.FOE_CODE and iter1:IsAlive() and not iter1:IsBoss() then
			iter1:DeadAction()
		end
	end
end

function var9.KillSubmarineByIFF(arg0, arg1)
	for iter0, iter1 in pairs(arg0._unitList) do
		if iter1:GetIFF() == arg1 and iter1:IsAlive() and table.contains(TeamType.SubShipType, iter1:GetTemplate().type) and not iter1:IsBoss() then
			iter1:DeadAction()
		end
	end
end

function var9.KillAllAircraft(arg0)
	for iter0, iter1 in pairs(arg0._aircraftList) do
		iter1:Clear()

		local var0 = {
			UID = iter0
		}

		arg0:DispatchEvent(var0.Event.New(var1.REMOVE_AIR_CRAFT, var0))

		arg0._aircraftList[iter0] = nil
	end
end

function var9.KillWaveSummonMonster(arg0, arg1)
	local var0 = arg0._waveSummonList[arg1]

	if var0 then
		for iter0, iter1 in pairs(var0) do
			local var1 = iter0:GetUniqueID()

			arg0:KillUnit(var1)
		end
	end

	arg0._waveSummonList[arg1] = nil
end

function var9.IsThereBoss(arg0)
	return arg0:GetActiveBossCount() > 0
end

function var9.GetActiveBossCount(arg0)
	local var0 = 0

	for iter0, iter1 in pairs(arg0:GetUnitList()) do
		if iter1:IsBoss() and iter1:IsAlive() then
			var0 = var0 + 1
		end
	end

	return var0
end

function var9.setShipUnitBound(arg0, arg1)
	local var0 = arg1:GetIFF()

	if arg1:GetFleetVO() then
		arg1:SetBound(arg1:GetFleetVO():GetUnitBound():GetBound())
	else
		arg1:SetBound(arg0:GetUnitBoundByIFF(var0))
	end
end

function var9.generatePlayerUnit(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:GenerateUnitID()
	local var1 = arg1.properties

	var1.level = arg1.level
	var1.formationID = var4.FORMATION_ID
	var1.id = arg1.id

	var6.AttrFixer(arg0._battleInitData.battleType, var1)

	local var2 = arg1.proficiency or {
		1,
		1,
		1
	}
	local var3 = var3.UnitType.PLAYER_UNIT
	local var4 = arg0._battleInitData.battleType

	if var4 == SYSTEM_SUBMARINE_RUN or var4 == SYSTEM_SUB_ROUTINE then
		var3 = var3.UnitType.SUB_UNIT
	elseif var4 == SYSTEM_AIRFIGHT then
		var3 = var3.UnitType.CONST_UNIT
	elseif var4 == SYSTEM_CARDPUZZLE then
		var3 = var3.UnitType.CARDPUZZLE_PLAYER_UNIT
	end

	local var5 = var5.CreateBattleUnitData(var0, var3, arg2, arg1.tmpID, arg1.skinId, arg1.equipment, var1, arg1.baseProperties, var2, arg1.baseList, arg1.preloasList)

	var5.AttachUltimateBonus(var5)
	var5:InitCurrentHP(arg1.initHPRate or 1)
	var5:SetRarity(arg1.rarity)
	var5:SetIntimacy(arg1.intimacy)
	var5:SetShipName(arg1.name)

	if arg1.spWeapon then
		var5:SetSpWeapon(arg1.spWeapon)
		_.each(arg1.spWeapon:GetLabel(), function(arg0)
			var5:AddLabelTag(arg0)
		end)
	end

	arg0._unitList[var0] = var5

	if var5:GetIFF() == var4.FRIENDLY_CODE then
		arg0._friendlyShipList[var0] = var5
	elseif var5:GetIFF() == var4.FOE_CODE then
		arg0._foeShipList[var0] = var5
	end

	if var4 == SYSTEM_WORLD then
		local var6 = var2.WorldMapRewardHealingRate(arg0._battleInitData.EnemyMapRewards, arg0._battleInitData.FleetMapRewards)

		var6.SetCurrent(var5, "healingRate", var6)
	end

	var5:SetPosition(arg3)
	var5.InitUnitSkill(arg1, var5, var4)
	var5.InitEquipSkill(arg1.equipment, var5, var4)
	var5.InitCommanderSkill(arg4, var5, var4)
	var5:SetGearScore(arg1.shipGS)

	if arg1.deathMark then
		var5:SetWorldDeathMark()
	end

	return var5
end

function var9.generateSupportPlayerUnit(arg0, arg1, arg2)
	local var0 = arg0:GenerateUnitID()
	local var1 = arg1.properties

	var1.level = arg1.level
	var1.formationID = var4.FORMATION_ID
	var1.id = arg1.id

	var6.AttrFixer(arg0._battleInitData.battleType, var1)

	local var2 = arg1.proficiency or {
		1,
		1,
		1
	}
	local var3 = var5.CreateBattleUnitData(var0, var3.UnitType.SUPPORT_UNIT, arg2, arg1.tmpID, arg1.skinId, arg1.equipment, var1, arg1.baseProperties, var2, arg1.baseList, arg1.preloasList)

	var3:InitCurrentHP(1)
	var3:SetShipName(arg1.name)

	arg0._spectreShipList[var0] = var3

	var3:SetPosition(Clone(var4.AirSupportUnitPos))

	return var3
end

function var9.SwitchSpectreUnit(arg0, arg1)
	local var0 = arg1:GetUniqueID()
	local var1 = arg1:GetIFF() == var4.FRIENDLY_CODE and arg0._friendlyShipList or arg0._foeShipList

	if arg1:IsSpectre() then
		var1[var0] = nil
		arg0._spectreShipList[var0] = arg1

		for iter0, iter1 in pairs(arg0._AOEList) do
			iter1:ForceExit(arg1:GetUniqueID())
		end

		arg0._cldSystem:DeleteShipCld(arg1)
	else
		arg0._spectreShipList[var0] = nil
		var1[var0] = arg1

		arg1:ActiveCldBox()
		arg0._cldSystem:InitShipCld(arg1)
	end
end

function var9.GetUnitList(arg0)
	return arg0._unitList
end

function var9.GetFriendlyShipList(arg0)
	return arg0._friendlyShipList
end

function var9.GetFoeShipList(arg0)
	return arg0._foeShipList
end

function var9.GetFoeAircraftList(arg0)
	return arg0._foeAircraftList
end

function var9.GetFreeShipList(arg0)
	return arg0._freeShipList
end

function var9.GetSpectreShipList(arg0)
	return arg0._spectreShipList
end

function var9.GenerateUnitID(arg0)
	arg0._unitCount = arg0._unitCount + 1

	return arg0._unitCount
end

function var9.GetCountDown(arg0)
	return arg0._countDown
end

function var9.SpawnAirFighter(arg0, arg1)
	local var0 = #arg0._airFighterList + 1
	local var1 = var5.GetFormationTmpDataFromID(arg1.formation).pos_offset
	local var2 = {
		currentNumber = 0,
		templateID = arg1.templateID,
		totalNumber = arg1.totalNumber or 0,
		onceNumber = arg1.onceNumber,
		timeDelay = arg1.interval or 3,
		maxTotalNumber = arg1.maxTotalNumber or 15
	}

	local function var3(arg0)
		local var0 = var2.currentNumber

		if var0 < var2.totalNumber then
			var2.currentNumber = var0 + 1

			local var1 = arg0:CreateAirFighter(arg1)

			var1:SetFormationOffset(var1[arg0])
			var1:SetFormationIndex(arg0)
			var1:SetDeadCallBack(function()
				var2.totalNumber = var2.totalNumber - 1
				var2.currentNumber = var2.currentNumber - 1

				arg0:DispatchEvent(var0.Event.New(var1.REMOVE_AIR_FIGHTER_ICON, {
					index = var0
				}))
				arg0:DispatchEvent(var0.Event.New(var1.UPDATE_AIR_SUPPORT_LABEL, {}))
			end)
			var1:SetLiveCallBack(function()
				var2.currentNumber = var2.currentNumber - 1
			end)
		end
	end

	local function var4()
		local var0 = var2.onceNumber

		if var2.totalNumber > 0 then
			for iter0 = 1, var0 do
				var3(iter0)
			end
		else
			pg.TimeMgr.GetInstance():RemoveBattleTimer(var2.timer)

			var2.timer = nil
		end
	end

	arg0._airFighterList[var0] = var2

	arg0:DispatchEvent(var0.Event.New(var1.ADD_AIR_FIGHTER_ICON, {
		index = var0
	}))
	arg0:DispatchEvent(var0.Event.New(var1.UPDATE_AIR_SUPPORT_LABEL, {}))

	var2.timer = pg.TimeMgr.GetInstance():AddBattleTimer("striker", -1, arg1.interval, var4)
end

function var9.ClearAirFighterTimer(arg0)
	for iter0, iter1 in ipairs(arg0._airFighterList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter1.timer)

		iter1.timer = nil
	end

	arg0._airFighterList = {}
end

function var9.KillAllAirStrike(arg0)
	for iter0, iter1 in pairs(arg0._aircraftList) do
		if iter1.__name == var0.Battle.BattleAirFighterUnit.__name then
			arg0._cldSystem:DeleteAircraftCld(iter1)

			iter1._aliveState = false
			arg0._aircraftList[iter0] = nil
			arg0._foeAircraftList[iter0] = nil

			local var0 = {
				UID = iter0
			}

			arg0:DispatchEvent(var0.Event.New(var1.REMOVE_AIR_CRAFT, var0))
		end
	end

	local var1 = true

	for iter2, iter3 in pairs(arg0._foeAircraftList) do
		var1 = false

		break
	end

	if var1 then
		arg0:DispatchEvent(var0.Event.New(var1.ANTI_AIR_AREA, {
			isShow = false
		}))
	end

	for iter4, iter5 in ipairs(arg0._airFighterList) do
		iter5.totalNumber = 0

		arg0:DispatchEvent(var0.Event.New(var1.REMOVE_AIR_FIGHTER_ICON, {
			index = iter4
		}))
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter5.timer)

		iter5.timer = nil
	end

	arg0._airFighterList = {}
end

function var9.GetAirFighterInfo(arg0, arg1)
	return arg0._airFighterList[arg1]
end

function var9.GetAirFighterList(arg0)
	return arg0._airFighterList
end

function var9.CreateAircraft(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:GenerateAircraftID()
	local var1 = var5.CreateAircraftUnit(var0, arg2, arg1, arg3)

	if arg4 then
		var1:SetSkinID(arg4)
	end

	local var2

	if arg1:GetIFF() == var4.FRIENDLY_CODE then
		-- block empty
	else
		var2 = true
	end

	arg0:doCreateAirUnit(var0, var1, var3.UnitType.AIRCRAFT_UNIT, var2)

	return var1
end

function var9.CreateAirFighter(arg0, arg1)
	local var0 = arg0:GenerateAircraftID()
	local var1 = var5.CreateAirFighterUnit(var0, arg1)

	arg0:doCreateAirUnit(var0, var1, var3.UnitType.AIRFIGHTER_UNIT, true)

	return var1
end

function var9.doCreateAirUnit(arg0, arg1, arg2, arg3, arg4)
	arg0._aircraftList[arg1] = arg2

	arg0._cldSystem:InitAircraftCld(arg2)
	arg2:SetBound(arg0._leftZoneUpperBound, arg0._leftZoneLowerBound)
	arg2:SetViewBoundData(arg0._cameraTop, arg0._cameraBottom, arg0._cameraLeft, arg0._cameraRight)
	arg0:DispatchEvent(var0.Event.New(var1.ADD_UNIT, {
		unit = arg2,
		type = arg3
	}))

	arg4 = arg4 or false

	if arg4 then
		arg0._foeAircraftList[arg1] = arg2

		arg0:DispatchEvent(var0.Event.New(var1.ANTI_AIR_AREA, {
			isShow = true
		}))
	end
end

function var9.KillAircraft(arg0, arg1)
	local var0 = arg0._aircraftList[arg1]

	if var0 == nil then
		return
	end

	var0:Clear()
	arg0._cldSystem:DeleteAircraftCld(var0)

	if var0:IsUndefeated() and var0:GetCurrentState() ~= var0.STRIKE_STATE_RECYCLE then
		local var1 = var0:GetIFF() * -1

		arg0:HandleAircraftMissDamage(var0, arg0._fleetList[var1])
	end

	var0._aliveState = false
	arg0._aircraftList[arg1] = nil
	arg0._foeAircraftList[arg1] = nil

	local var2 = true

	for iter0, iter1 in pairs(arg0._foeAircraftList) do
		var2 = false

		break
	end

	if var2 then
		arg0:DispatchEvent(var0.Event.New(var1.ANTI_AIR_AREA, {
			isShow = false
		}))
	end

	local var3 = {
		UID = arg1
	}

	arg0:DispatchEvent(var0.Event.New(var1.REMOVE_AIR_CRAFT, var3))
end

function var9.GetAircraftList(arg0)
	return arg0._aircraftList
end

function var9.GenerateAircraftID(arg0)
	arg0._aircraftCount = arg0._aircraftCount + 1

	return arg0._aircraftCount
end

function var9.CreateBulletUnit(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:GenerateBulletID()
	local var1, var2 = var5.CreateBattleBulletData(var0, arg1, arg2, arg3, arg4)

	if var2 then
		arg0._cldSystem:InitBulletCld(var1)
	end

	local var3, var4 = arg3:GetFixBulletRange()

	if var3 or var4 then
		var1:FixRange(var3, var4)
	end

	arg0._bulletList[var0] = var1

	return var1
end

function var9.RemoveBulletUnit(arg0, arg1)
	local var0 = arg0._bulletList[arg1]

	if var0 == nil then
		return
	end

	var0:DamageUnitListWriteback()

	if var0:GetIsCld() then
		arg0._cldSystem:DeleteBulletCld(var0)
	end

	arg0._bulletList[arg1] = nil

	local var1 = {
		UID = arg1
	}

	arg0:DispatchEvent(var0.Event.New(var1.REMOVE_BULLET, var1))
	var0:Dispose()
end

function var9.GetBulletList(arg0)
	return arg0._bulletList
end

function var9.GenerateBulletID(arg0)
	local var0 = arg0._bulletCount + 1

	arg0._bulletCount = var0

	return var0
end

function var9.CLSBullet(arg0, arg1, arg2)
	local var0 = true

	if arg0._battleInitData.battleType == SYSTEM_DUEL then
		var0 = false
	end

	if var0 then
		for iter0, iter1 in pairs(arg0._bulletList) do
			if iter1:GetIFF() ~= arg1 or not iter1:GetExist() or iter1:ImmuneCLS() or iter1:ImmuneBombCLS() and arg2 then
				-- block empty
			else
				arg0:RemoveBulletUnit(iter0)
			end
		end
	end
end

function var9.CLSAircraft(arg0, arg1)
	for iter0, iter1 in pairs(arg0._aircraftList) do
		if iter1:GetIFF() == arg1 then
			iter1:Clear()

			local var0 = {
				UID = iter0
			}

			arg0:DispatchEvent(var0.Event.New(var1.REMOVE_AIR_CRAFT, var0))

			arg0._aircraftList[iter0] = nil
		end
	end
end

function var9.CLSMinion(arg0)
	for iter0, iter1 in pairs(arg0._unitList) do
		if iter1:GetIFF() == var4.FOE_CODE and iter1:IsAlive() and not iter1:IsBoss() then
			iter1:SetDeathReason(var3.UnitDeathReason.CLS)
			iter1:DeadAction()
		end
	end
end

function var9.SpawnColumnArea(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
	arg7 = arg7 or false

	local var0 = arg0:GenerateAreaID()
	local var1 = var0.Battle.BattleAOEData.New(var0, arg2, arg6, arg8)
	local var2 = Clone(arg3)

	var1:SetPosition(var2)
	var1:SetRange(arg4)
	var1:SetAreaType(var3.AreaType.COLUMN)
	var1:SetLifeTime(arg5)
	var1:SetFieldType(arg1)
	var1:SetOpponentAffected(not arg7)
	arg0:CreateAreaOfEffect(var1)

	return var1
end

function var9.SpawnCubeArea(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9)
	arg8 = arg8 or false

	local var0 = arg0:GenerateAreaID()
	local var1 = var0.Battle.BattleAOEData.New(var0, arg2, arg7, arg9)
	local var2 = Clone(arg3)

	var1:SetPosition(var2)
	var1:SetWidth(arg4)
	var1:SetHeight(arg5)
	var1:SetAreaType(var3.AreaType.CUBE)
	var1:SetLifeTime(arg6)
	var1:SetFieldType(arg1)
	var1:SetOpponentAffected(not arg8)
	arg0:CreateAreaOfEffect(var1)

	return var1
end

function var9.SpawnLastingColumnArea(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11)
	arg8 = arg8 or false

	local var0 = arg0:GenerateAreaID()
	local var1 = var0.Battle.BattleLastingAOEData.New(var0, arg2, arg6, arg7, arg10, arg11)
	local var2 = Clone(arg3)

	var1:SetPosition(var2)
	var1:SetRange(arg4)
	var1:SetAreaType(var3.AreaType.COLUMN)
	var1:SetLifeTime(arg5)
	var1:SetFieldType(arg1)
	var1:SetOpponentAffected(not arg8)
	arg0:CreateAreaOfEffect(var1)

	if arg9 and arg9 ~= "" then
		local var3 = {
			area = var1,
			FXID = arg9
		}

		arg0:DispatchEvent(var0.Event.New(var1.ADD_AREA, var3))
	end

	return var1
end

function var9.SpawnLastingCubeArea(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10, arg11, arg12)
	arg9 = arg9 or false

	local var0 = arg0:GenerateAreaID()
	local var1 = var0.Battle.BattleLastingAOEData.New(var0, arg2, arg7, arg8, arg11, arg12)
	local var2 = Clone(arg3)

	var1:SetPosition(var2)
	var1:SetWidth(arg4)
	var1:SetHeight(arg5)
	var1:SetAreaType(var3.AreaType.CUBE)
	var1:SetLifeTime(arg6)
	var1:SetFieldType(arg1)
	var1:SetOpponentAffected(not arg9)
	arg0:CreateAreaOfEffect(var1)

	if arg10 and arg10 ~= "" then
		local var3 = {
			area = var1,
			FXID = arg10
		}

		arg0:DispatchEvent(var0.Event.New(var1.ADD_AREA, var3))
	end

	return var1
end

function var9.SpawnTriggerColumnArea(arg0, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8)
	arg6 = arg6 or false

	local var0 = arg0:GenerateAreaID()
	local var1 = var0.Battle.BattleTriggerAOEData.New(var0, arg2, arg8)
	local var2 = Clone(arg3)

	var1:SetPosition(var2)
	var1:SetRange(arg4)
	var1:SetAreaType(var3.AreaType.COLUMN)
	var1:SetLifeTime(arg5)
	var1:SetFieldType(arg1)
	var1:SetOpponentAffected(not arg6)
	arg0:CreateAreaOfEffect(var1)

	if arg7 and arg7 ~= "" then
		local var3 = {
			area = var1,
			FXID = arg7
		}

		arg0:DispatchEvent(var0.Event.New(var1.ADD_AREA, var3))
	end

	return var1
end

function var9.CreateAreaOfEffect(arg0, arg1)
	arg0._AOEList[arg1:GetUniqueID()] = arg1

	arg0._cldSystem:InitAOECld(arg1)
	arg1:StartTimer()
end

function var9.RemoveAreaOfEffect(arg0, arg1)
	local var0 = arg0._AOEList[arg1]

	if not var0 then
		return
	end

	var0:Dispose()

	arg0._AOEList[arg1] = nil

	arg0._cldSystem:DeleteAOECld(var0)
	arg0:DispatchEvent(var0.Event.New(var1.REMOVE_AREA, {
		id = arg1
	}))
end

function var9.GetAOEList(arg0)
	return arg0._AOEList
end

function var9.GenerateAreaID(arg0)
	arg0._AOECount = arg0._AOECount + 1

	return arg0._AOECount
end

function var9.SpawnWall(arg0, arg1, arg2, arg3, arg4)
	local var0 = arg0:GenerateWallID()
	local var1 = var0.Battle.BattleWallData.New(var0, arg1, arg2, arg3, arg4)

	arg0._wallList[var0] = var1

	arg0._cldSystem:InitWallCld(var1)

	return var1
end

function var9.RemoveWall(arg0, arg1)
	local var0 = arg0._wallList[arg1]

	arg0._wallList[arg1] = nil

	arg0._cldSystem:DeleteWallCld(var0)
end

function var9.SpawnShelter(arg0, arg1, arg2)
	local var0 = arg0:GernerateShelterID()
	local var1 = var0.Battle.BattleShelterData.New(var0)

	arg0._shelterList[var0] = var1

	return var1
end

function var9.RemoveShelter(arg0, arg1)
	local var0 = arg0._shelterList[arg1]
	local var1 = {
		uid = arg1
	}

	arg0:DispatchEvent(var0.Event.New(var1.REMOVE_SHELTER, var1))
	var0:Deactive()

	arg0._shelterList[arg1] = nil
end

function var9.GetWallList(arg0)
	return arg0._wallList
end

function var9.GenerateWallID(arg0)
	arg0._wallIndex = arg0._wallIndex + 1

	return arg0._wallIndex
end

function var9.GernerateShelterID(arg0)
	arg0._shelterIndex = arg0._shelterIndex + 1

	return arg0._shelterIndex
end

function var9.SpawnEnvironment(arg0, arg1)
	local var0 = arg0:GernerateEnvironmentID()
	local var1 = var0.Battle.BattleEnvironmentUnit.New(var0, var4.FOE_CODE)

	var1:SetTemplate(arg1)

	local var2 = var1:GetBehaviours()
	local var3 = Vector3(arg1.coordinate[1], arg1.coordinate[2], arg1.coordinate[3])

	local function var4(arg0)
		local var0 = {}

		for iter0, iter1 in ipairs(arg0) do
			if iter1.Active then
				local var1 = arg0._unitList[iter1.UID]

				if not var1:IsSpectre() then
					table.insert(var0, var1)
				end
			end
		end

		var1:UpdateFrequentlyCollide(var0)
	end

	local function var5()
		return
	end

	local function var6()
		return
	end

	local var7 = arg1.field_type or var3.BulletField.SURFACE
	local var8 = arg1.IFF or var4.FOE_CODE
	local var9 = 0
	local var10

	if #arg1.cld_data == 1 then
		local var11 = arg1.cld_data[1]

		var10 = arg0:SpawnLastingColumnArea(var7, var8, var3, var11, var9, var4, var5, false, arg1.prefab, var6, true)
	else
		local var12 = arg1.cld_data[1]
		local var13 = arg1.cld_data[2]

		var10 = arg0:SpawnLastingCubeArea(var7, var8, var3, var12, var13, var9, var4, var5, false, arg1.prefab, var6, true)
	end

	var1:SetAOEData(var10)

	arg0._environmentList[var0] = var1

	return var1
end

function var9.RemoveEnvironment(arg0, arg1)
	local var0 = arg0._environmentList[arg1]
	local var1 = var0:GetAOEData()

	arg0:RemoveAreaOfEffect(var1:GetUniqueID())
	var0:Dispose()

	arg0._environmentList[arg1] = nil
end

function var9.DispatchWarning(arg0, arg1, arg2)
	arg0:DispatchEvent(var0.Event.New(var1.UPDATE_ENVIRONMENT_WARNING, {
		isActive = arg1
	}))
end

function var9.GetEnvironmentList(arg0)
	return arg0._environmentList
end

function var9.GernerateEnvironmentID(arg0)
	arg0._environmentIndex = arg0._environmentIndex + 1

	return arg0._environmentIndex
end

function var9.SpawnEffect(arg0, arg1, arg2, arg3)
	arg0:DispatchEvent(var0.Event.New(var1.ADD_EFFECT, {
		FXID = arg1,
		position = arg2,
		localScale = arg3
	}))
end

function var9.SpawnUIFX(arg0, arg1, arg2, arg3, arg4)
	arg0:DispatchEvent(var0.Event.New(var1.ADD_UI_FX, {
		FXID = arg1,
		position = arg2,
		localScale = arg3,
		orderDiff = arg4
	}))
end

function var9.SpawnCameraFX(arg0, arg1, arg2, arg3, arg4)
	arg0:DispatchEvent(var0.Event.New(var1.ADD_CAMERA_FX, {
		FXID = arg1,
		position = arg2,
		localScale = arg3,
		orderDiff = arg4
	}))
end

function var9.GetFriendlyCode(arg0)
	return arg0._friendlyCode
end

function var9.GetFoeCode(arg0)
	return arg0._foeCode
end

function var9.GetOppoSideCode(arg0)
	if arg0 == var4.FRIENDLY_CODE then
		return var4.FOE_CODE
	elseif arg0 == var4.FOE_CODE then
		return var4.FRIENDLY_CODE
	end
end

function var9.GetStatistics(arg0)
	return arg0._statistics
end

function var9.BlockManualCast(arg0, arg1)
	local var0 = arg1 and 1 or -1

	for iter0, iter1 in pairs(arg0._fleetList) do
		iter1:SetWeaponBlock(var0)
	end
end

function var9.JamManualCast(arg0, arg1)
	arg0:DispatchEvent(var0.Event.New(var1.JAMMING, {
		jammingFlag = arg1
	}))
end

function var9.SubmarineStrike(arg0, arg1)
	local var0 = arg0:GetFleetByIFF(arg1)
	local var1 = var0:GetSubAidVO()

	if var0:GetWeaponBlock() or var1:GetCurrent() < 1 then
		return
	end

	local var2 = var0:GetSubUnitData()

	for iter0, iter1 in ipairs(var2) do
		local var3 = arg0:SpawnSub(iter1, arg1)

		arg0:InitAidUnitStatistics(var3)
	end

	var0:SubWarcry()

	local var4 = var0:GetSubList()

	for iter2, iter3 in ipairs(var4) do
		if iter2 == 1 then
			iter3:TriggerBuff(var3.BuffEffectType.ON_SUB_LEADER)
		elseif iter2 == 2 then
			iter3:TriggerBuff(var3.BuffEffectType.ON_UPPER_SUB_CONSORT)
		elseif iter2 == 3 then
			iter3:TriggerBuff(var3.BuffEffectType.ON_LOWER_SUB_CONSORT)
		end

		if iter3:GetAimBias() then
			arg0:DispatchEvent(var0.Event.New(var1.ADD_AIM_BIAS, {
				aimBias = iter3:GetAimBias()
			}))
		end
	end

	local var5 = var4[1]

	var1:Cast()
end

function var9.GetWaveFlags(arg0)
	return arg0._waveFlags
end

function var9.AddWaveFlag(arg0, arg1)
	if not arg1 then
		return
	end

	local var0 = arg0:GetWaveFlags()

	if table.contains(var0, arg1) then
		return
	end

	table.insert(var0, arg1)
end

function var9.RemoveFlag(arg0, arg1)
	if not arg1 then
		return
	end

	local var0 = arg0:GetWaveFlags()

	if not table.contains(var0, arg1) then
		return
	end

	table.removebyvalue(var0, arg1)
end

function var9.DispatchCustomWarning(arg0, arg1)
	arg0:DispatchEvent(var0.Event.New(var1.EDIT_CUSTOM_WARNING_LABEL, {
		labelData = arg1
	}))
end

function var9.DispatchGridmanSkill(arg0, arg1, arg2)
	arg0:DispatchEvent(var0.Event.New(var1.GRIDMAN_SKILL_FLOAT, {
		type = arg1,
		IFF = arg2
	}))
end

function var9.SpawnFusionUnit(arg0, arg1, arg2, arg3, arg4)
	local var0 = Clone(arg1:GetPosition())
	local var1 = arg1:GetIFF()
	local var2 = arg0:generatePlayerUnit(arg2, var1, var0, arg0._commanderBuff)

	var6.SetFusionAttrFromElement(var2, arg1, arg3, arg4)
	var2:SetCurrentHP(var2:GetMaxHP())
	arg1:GetFleetVO():AppendPlayerUnit(var2)
	arg0:setShipUnitBound(var2)
	var5.AttachWeather(var2, arg0._weahter)
	arg0._cldSystem:InitShipCld(var2)

	local var3 = {
		type = var3.UnitType.PLAYER_UNIT,
		unit = var2
	}

	arg0:DispatchEvent(var0.Event.New(var1.ADD_UNIT, var3))

	return var2
end

function var9.DefusionUnit(arg0, arg1)
	local var0 = arg1:GetIFF()
	local var1 = arg0:GetFleetByIFF(var0)

	var1:RemovePlayerUnit(arg1)

	local var2 = {}

	if var1:GetFleetAntiAirWeapon():GetRange() == 0 then
		var2.isShow = false
	end

	arg0:DispatchEvent(var0.Event.New(var1.ANTI_AIR_AREA, var2))
	arg1:SetDeathReason(var3.UnitDeathReason.DEFUSION)
	arg0:KillUnit(arg1:GetUniqueID())
end

function var9.FreezeUnit(arg0, arg1)
	var6.SetCurrent(arg1, var0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY, var4.FUSION_ELEMENT_UNIT_TYPE)
	arg1:UpdateBlindInvisibleBySpectre()
	arg0:SwitchSpectreUnit(arg1)

	if arg1:GetAimBias() then
		local var0 = arg1:GetAimBias()

		var0:RemoveCrew(arg1)

		if var0:GetCurrentState() == var0.STATE_EXPIRE then
			arg0:DispatchEvent(var0.Event.New(var1.REMOVE_AIM_BIAS, {
				aimBias = arg1:GetAimBias()
			}))
		end
	end

	arg1:Freeze()

	local var1 = arg1:GetFleetVO()

	if var1 then
		var1:FreezeUnit(arg1)
	end
end

function var9.ActiveFreezeUnit(arg0, arg1)
	var6.SetCurrent(arg1, var0.Battle.BattleBuffSetBattleUnitType.ATTR_KEY, var4.PLAYER_DEFAULT)
	arg1:UpdateBlindInvisibleBySpectre()
	arg0:SwitchSpectreUnit(arg1)
	var5.AttachWeather(arg1, arg0._weahter)
	arg1:ActiveFreeze()

	local var0 = arg1:GetFleetVO()

	if var0 then
		var0:ActiveFreezeUnit(arg1)
	end
end
