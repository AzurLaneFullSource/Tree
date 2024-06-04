local var0 = ys.Battle.BattleDataProxy
local var1 = ys.Battle.BattleEvent
local var2 = ys.Battle.BattleFormulas
local var3 = ys.Battle.BattleConst
local var4 = ys.Battle.BattleConfig
local var5 = ys.Battle.BattleDataFunction
local var6 = ys.Battle.BattleAttr
local var7 = ys.Battle.BattleVariable

function var0.StatisticsInit(arg0, arg1)
	arg0._statistics = {}
	arg0._statistics._battleScore = var3.BattleScore.D
	arg0._statistics.kill_id_list = {}
	arg0._statistics._totalTime = 0
	arg0._statistics._deadCount = 0
	arg0._statistics._boss_destruct = 0
	arg0._statistics._botPercentage = 0
	arg0._statistics._maxBossHP = 0
	arg0._statistics._enemyInfoList = {}

	for iter0, iter1 in ipairs(arg1) do
		local var0 = {
			id = iter1:GetAttrByName("id")
		}

		var0.damage = 0
		var0.output = 0
		var0.kill_count = 0
		var0.bp = 0
		var0.max_hp = iter1:GetAttrByName("maxHP")
		var0.maxDamageOnce = 0
		var0.gearScore = iter1:GetGearScore()
		arg0._statistics[var0.id] = var0
	end
end

function var0.InitAidUnitStatistics(arg0, arg1)
	local var0 = {
		id = arg1:GetAttrByName("id")
	}

	var0.damage = 0
	var0.output = 0
	var0.kill_count = 0
	var0.bp = 0
	var0.max_hp = arg1:GetAttrByName("maxHP")
	var0.maxDamageOnce = 0
	var0.gearScore = arg1:GetGearScore()
	arg0._statistics[var0.id] = var0
	arg0._statistics.submarineAid = true
end

function var0.InitSpecificEnemyStatistics(arg0, arg1)
	local var0 = {
		id = arg1:GetAttrByName("id")
	}

	var0.damage = 0
	var0.output = 0
	var0.kill_count = 0
	var0.bp = 0
	var0.max_hp = arg1:GetAttrByName("maxHP")
	var0.init_hp = arg1:GetCurrentHP()
	var0.maxDamageOnce = 0
	var0.gearScore = arg1:GetGearScore()
	arg0._statistics[var0.id] = var0
end

function var0.RivalInit(arg0, arg1)
	arg0._statistics._rivalInfo = {}

	for iter0, iter1 in ipairs(arg1) do
		local var0 = iter1:GetAttrByName("id")

		arg0._statistics._rivalInfo[var0] = {}
		arg0._statistics._rivalInfo[var0].id = var0
	end
end

function var0.DodgemCountInit(arg0)
	arg0._dodgemStatistics = {}
	arg0._dodgemStatistics.kill = 0
	arg0._dodgemStatistics.combo = 0
	arg0._dodgemStatistics.miss = 0
	arg0._dodgemStatistics.fail = 0
	arg0._dodgemStatistics.score = 0
	arg0._dodgemStatistics.maxCombo = 0
end

function var0.SubmarineRunInit(arg0)
	arg0._subRunStatistics = {}
	arg0._subRunStatistics.score = 0
end

function var0.SetFlagShipID(arg0, arg1)
	if arg1 then
		arg0._statistics._flagShipID = arg1:GetAttrByName("id")
	end
end

function var0.DamageStatistics(arg0, arg1, arg2, arg3)
	if arg0._statistics[arg1] then
		arg0._statistics[arg1].output = arg0._statistics[arg1].output + arg3
		arg0._statistics[arg1].maxDamageOnce = math.max(arg0._statistics[arg1].maxDamageOnce, arg3)
	end

	if arg0._statistics[arg2] then
		arg0._statistics[arg2].damage = arg0._statistics[arg2].damage + arg3
	end
end

function var0.KillCountStatistics(arg0, arg1, arg2)
	if arg0._statistics[arg1] then
		arg0._statistics[arg1].kill_count = arg0._statistics[arg1].kill_count + 1
	end
end

function var0.HPRatioStatistics(arg0)
	for iter0, iter1 in pairs(arg0._fleetList) do
		iter1:UndoFusion()
	end

	local var0 = arg0._fleetList[1]:GetUnitList()

	for iter2, iter3 in ipairs(var0) do
		arg0._statistics[iter3:GetAttrByName("id")].bp = math.ceil(iter3:GetHPRate() * 10000)
	end
end

function var0.BotPercentage(arg0, arg1)
	local var0 = arg0._currentStageData.timeCount - arg0._countDown

	arg0._statistics._botPercentage = Mathf.Clamp(math.floor(arg1 / var0 * 100), 0, 100)
end

function var0.CalcBattleScoreWhenDead(arg0, arg1)
	local var0 = arg1:GetIFF()

	if var0 == var4.FRIENDLY_CODE then
		if not table.contains(TeamType.SubShipType, arg1:GetTemplate().type) then
			arg0:DelScoreWhenPlayerDead(arg1)
		end
	elseif var0 == var4.FOE_CODE then
		arg0:AddScoreWhenEnemyDead(arg1)
	end
end

function var0.AddScoreWhenBossDestruct(arg0)
	arg0._statistics._boss_destruct = arg0._statistics._boss_destruct + 1
end

function var0.AddScoreWhenEnemyDead(arg0, arg1)
	if arg1:GetDeathReason() == var3.UnitDeathReason.KILLED then
		arg0._statistics.kill_id_list[#arg0._statistics.kill_id_list + 1] = arg1:GetTemplateID()
	end
end

function var0.DelScoreWhenPlayerDead(arg0, arg1)
	arg0._statistics._deadCount = arg0._statistics._deadCount + 1
end

function var0.CalcBPWhenPlayerLeave(arg0, arg1)
	arg0._statistics[arg1:GetAttrByName("id")].bp = math.ceil(arg1:GetHPRate() * 10000)
end

function var0.isTimeOut(arg0)
	return arg0._currentStageData.timeCount - arg0._countDown >= 180
end

function var0.CalcCardPuzzleScoreAtEnd(arg0, arg1)
	arg0._statistics._deadUnit = true
	arg0._statistics._badTime = true

	local var0 = arg1:GetCardPuzzleComponent():GetCurrentCommonHP()

	arg0._statistics._battleScore = var0 > 0 and var3.BattleScore.S or var3.BattleScore.D
	arg0._statistics._cardPuzzleStatistics = {}
	arg0._statistics._cardPuzzleStatistics.common_hp_rest = var0

	local var1 = arg0._currentStageData.timeCount - arg0._countDown

	arg0._statistics._totalTime = var1

	arg0:AirFightInit()
end

function var0.CalcSingleDungeonScoreAtEnd(arg0, arg1)
	arg0._statistics._deadUnit = true
	arg0._statistics._badTime = true

	local var0 = arg0._currentStageData.timeCount - arg0._countDown

	arg0._statistics._totalTime = var0

	local var1 = arg0._expeditionTmp.limit_type
	local var2 = arg0._expeditionTmp.sink_limit
	local var3 = arg0._expeditionTmp.time_limit

	if var2 > arg0._statistics._deadCount then
		arg0._statistics._deadUnit = false
	end

	local var4 = arg1:GetFlagShip()
	local var5 = arg1:GetScoutList()

	if var1 == 2 then
		if not var4:IsAlive() or #var5 <= 0 then
			arg0._statistics._battleScore = var3.BattleScore.D
			arg0._statistics._boss_destruct = 1
		else
			arg0._statistics._battleScore = var3.BattleScore.S
		end
	elseif arg0._countDown <= 0 then
		arg0._statistics._battleScore = var3.BattleScore.C
		arg0._statistics._boss_destruct = 1
	elseif var4 and not var4:IsAlive() then
		arg0._statistics._battleScore = var3.BattleScore.D
		arg0._statistics._boss_destruct = 1
		arg0._statistics._scoreMark = var3.DEAD_FLAG
	elseif #var5 <= 0 then
		arg0._statistics._battleScore = var3.BattleScore.D
		arg0._statistics._boss_destruct = 1
	else
		local var6 = 0

		if arg0._statistics._deadUnit then
			var6 = var6 + 1
		end

		if var3 < var0 then
			var6 = var6 + 1
		else
			arg0._statistics._badTime = false
		end

		if arg0._statistics._boss_destruct > 0 then
			var6 = var6 + 1
		end

		if var6 >= 2 then
			arg0._statistics._battleScore = var3.BattleScore.B
		elseif var6 == 1 then
			arg0._statistics._battleScore = var3.BattleScore.A
		elseif var6 == 0 then
			arg0._statistics._battleScore = var3.BattleScore.S
		end
	end

	arg0._statistics._timeout = arg0:isTimeOut()

	if arg0._battleInitData.CMDArgs then
		arg0:CalcSpecificEnemyInfo({
			arg0._battleInitData.CMDArgs
		})
	end
end

function var0.CalcMaxRestHPRateBossRate(arg0, arg1)
	arg0._statistics._maxBossHP = arg1
end

function var0.CalcDuelScoreAtTimesUp(arg0, arg1, arg2, arg3, arg4)
	arg0._statistics._deadUnit = true
	arg0._statistics._badTime = true
	arg0._statistics._timeout = false

	local var0 = arg0._currentStageData.timeCount - arg0._countDown

	arg0._statistics._totalTime = var0

	if arg0._expeditionTmp.sink_limit > arg0._statistics._deadCount then
		arg0._statistics._deadUnit = false
	end

	if arg2 < arg1 then
		arg0._statistics._battleScore = var3.BattleScore.S
	elseif arg1 < arg2 then
		arg0._statistics._battleScore = var3.BattleScore.D
	elseif arg4 <= arg3 then
		arg0._statistics._battleScore = var3.BattleScore.S
	elseif arg3 < arg4 then
		arg0._statistics._battleScore = var3.BattleScore.D
	end
end

function var0.CalcDuelScoreAtEnd(arg0, arg1, arg2)
	arg0._statistics._deadUnit = true
	arg0._statistics._badTime = true

	local var0 = arg0._currentStageData.timeCount - arg0._countDown

	arg0._statistics._totalTime = var0

	local var1 = #arg1:GetUnitList()
	local var2 = #arg2:GetUnitList()
	local var3 = arg0._expeditionTmp.sink_limit
	local var4 = arg0._expeditionTmp.time_limit

	if var3 > arg0._statistics._deadCount then
		arg0._statistics._deadUnit = false
	end

	if var1 == 0 then
		arg0._statistics._battleScore = var3.BattleScore.D
	elseif var2 == 0 then
		arg0._statistics._battleScore = var3.BattleScore.S
	end

	arg0._statistics._timeout = arg0:isTimeOut()
end

function var0.CalcSimulationScoreAtEnd(arg0, arg1, arg2)
	arg0._statistics._deadUnit = true
	arg0._statistics._badTime = true

	local var0 = arg0._currentStageData.timeCount - arg0._countDown

	arg0._statistics._totalTime = var0

	local var1 = #arg1:GetUnitList()
	local var2 = arg1:GetMaxCount()
	local var3 = #arg1:GetScoutList()
	local var4 = #arg2:GetUnitList()
	local var5 = arg0._expeditionTmp.sink_limit
	local var6 = arg0._expeditionTmp.time_limit

	if arg0._statistics._deadCount <= 0 then
		arg0._statistics._deadUnit = false
	end

	if not arg1:GetFlagShip():IsAlive() then
		arg0._statistics._battleScore = var3.BattleScore.D
		arg0._statistics._scoreMark = var3.DEAD_FLAG
	elseif var3 == 0 then
		arg0._statistics._battleScore = var3.BattleScore.D
	elseif var4 == 0 then
		arg0._statistics._battleScore = var3.BattleScore.S
	end

	arg0._statistics._timeout = arg0:isTimeOut()

	arg0:overwriteRivalStatistics(arg2)
end

function var0.CalcSimulationScoreAtTimesUp(arg0, arg1, arg2, arg3, arg4, arg5)
	arg0._statistics._deadUnit = true
	arg0._statistics._badTime = true
	arg0._statistics._timeout = false

	local var0 = arg0._currentStageData.timeCount - arg0._countDown

	arg0._statistics._totalTime = var0

	if arg0._statistics._deadCount <= 0 then
		arg0._statistics._deadUnit = false
	end

	arg0._statistics._battleScore = var3.BattleScore.D

	arg0:overwriteRivalStatistics(arg5)
end

function var0.overwriteRivalStatistics(arg0, arg1)
	for iter0, iter1 in pairs(arg0._statistics._rivalInfo) do
		local var0 = false

		for iter2, iter3 in ipairs(arg1:GetUnitList()) do
			if iter3:GetAttrByName("id") == iter0 then
				iter1.bp = math.ceil(iter3:GetHPRate() * 10000)
				var0 = true

				break
			end
		end

		if not var0 then
			iter1.bp = 0
		end
	end
end

function var0.CalcChallengeScore(arg0, arg1)
	if arg1 then
		arg0._statistics._battleScore = var3.BattleScore.S
	else
		arg0._statistics._battleScore = var3.BattleScore.D
	end

	arg0._statistics._totalTime = arg0._totalTime
end

function var0.CalcDodgemCount(arg0, arg1)
	local var0 = arg1:GetDeathReason()
	local var1 = arg1:GetTemplate().type

	if var0 == ys.Battle.BattleConst.UnitDeathReason.CRUSH then
		arg0._dodgemStatistics.kill = arg0._dodgemStatistics.kill + 1

		if var1 == ShipType.JinBi then
			arg0._dodgemStatistics.combo = arg0._dodgemStatistics.combo + 1
			arg0._dodgemStatistics.maxCombo = math.max(arg0._dodgemStatistics.maxCombo, arg0._dodgemStatistics.combo)

			local var2 = arg0._dodgemStatistics.score + arg0:GetScorePoint()

			arg0._dodgemStatistics.score = var2

			arg0:DispatchEvent(ys.Event.New(var1.UPDATE_DODGEM_SCORE, {
				totalScore = var2
			}))
		elseif var1 == ShipType.ZiBao then
			arg0._dodgemStatistics.fail = arg0._dodgemStatistics.fail + 1
			arg0._dodgemStatistics.combo = 0
		end

		arg0:DispatchEvent(ys.Event.New(var1.UPDATE_DODGEM_COMBO, {
			combo = arg0._dodgemStatistics.combo
		}))
	elseif var1 == ShipType.JinBi then
		arg0._dodgemStatistics.miss = arg0._dodgemStatistics.miss + 1
	end
end

function var0.GetScorePoint(arg0)
	local var0

	if arg0._dodgemStatistics.combo == 1 then
		var0 = 1
	elseif arg0._dodgemStatistics.combo == 2 then
		var0 = 2
	elseif arg0._dodgemStatistics.combo > 2 then
		var0 = 3
	end

	return var0
end

function var0.CalcDodgemScore(arg0)
	if arg0._dodgemStatistics.score >= var4.BATTLE_DODGEM_PASS_SCORE then
		arg0._statistics._battleScore = var3.BattleScore.S
	else
		arg0._statistics._battleScore = var3.BattleScore.B
	end

	arg0._statistics.dodgemResult = arg0._dodgemStatistics
end

function var0.CalcActBossDamageInfo(arg0, arg1)
	local var0 = var5.GetSpecificEnemyList(arg1, arg0._expeditionID)

	arg0:CalcSpecificEnemyInfo(var0)
end

function var0.CalcWorldBossDamageInfo(arg0, arg1, arg2, arg3)
	local var0 = var5.GetSpecificWorldJointEnemyList(arg1, arg2, arg3)

	arg0:CalcSpecificEnemyInfo(var0)
end

function var0.CalcGuildBossEnemyInfo(arg0, arg1)
	local var0 = var5.GetSpecificGuildBossEnemyList(arg1, arg0._expeditionID)

	arg0:CalcSpecificEnemyInfo(var0)
end

function var0.CalcSpecificEnemyInfo(arg0, arg1)
	arg0._statistics.specificDamage = 0

	for iter0, iter1 in ipairs(arg1) do
		if arg0._statistics["enemy_" .. iter1] then
			local var0 = arg0._statistics["enemy_" .. iter1].damage

			if table.contains(arg0._statistics.kill_id_list, iter1) then
				var0 = arg0._statistics["enemy_" .. iter1].init_hp
			end

			arg0._statistics.specificDamage = arg0._statistics.specificDamage + var0

			local var1 = {
				id = iter1,
				damage = var0,
				totalHp = arg0._statistics["enemy_" .. iter1].max_hp
			}

			table.insert(arg0._statistics._enemyInfoList, var1)
		end
	end
end

function var0.CalcKillingSupplyShip(arg0)
	arg0._subRunStatistics.score = arg0._subRunStatistics.score + 1
end

function var0.CalcSubRunTimeUp(arg0)
	arg0._statistics._battleScore = var3.BattleScore.B
	arg0._statistics.subRunResult = arg0._subRunStatistics
end

function var0.CalcSubRunScore(arg0)
	arg0._statistics._battleScore = var3.BattleScore.S
	arg0._statistics.subRunResult = arg0._subRunStatistics
end

function var0.CalcSubRunDead(arg0)
	arg0._statistics._battleScore = var3.BattleScore.D
	arg0._statistics.subRunResult = arg0._subRunStatistics
end

function var0.CalcKillingSupplyShip(arg0)
	arg0._subRunStatistics.score = arg0._subRunStatistics.score + 1
end

function var0.CalcSubRountineTimeUp(arg0)
	arg0._statistics._badTime = true

	arg0:CalcSubRoutineScore()

	arg0._statistics._battleScore = var3.BattleScore.C
end

function var0.CalcSubRountineElimate(arg0)
	arg0._statistics._elimated = true

	arg0:CalcSubRoutineScore()

	arg0._statistics._battleScore = var3.BattleScore.D
end

function var0.CalcSubRoutineScore(arg0)
	local var0 = arg0._statistics._deadCount * var4.SR_CONFIG.DEAD_POINT
	local var1 = arg0._subRunStatistics.score * var4.SR_CONFIG.POINT
	local var2 = (arg0._statistics._badTime or arg0._statistics._elimated) and 0 or var4.SR_CONFIG.BASE_POINT
	local var3 = var2 + var1 - var0

	if var3 >= var4.SR_CONFIG.BASE_POINT + var4.SR_CONFIG.M * var4.SR_CONFIG.POINT then
		arg0._statistics._battleScore = var3.BattleScore.S
	elseif var3 >= var4.SR_CONFIG.BASE_POINT then
		arg0._statistics._battleScore = var3.BattleScore.A
	elseif var3 >= var4.SR_CONFIG.BASE_POINT - 2 * var4.SR_CONFIG.DEAD_POINT then
		arg0._statistics._battleScore = var3.BattleScore.B
	else
		arg0._statistics._battleScore = var3.BattleScore.D
	end

	arg0._subRunStatistics.basePoint = var2
	arg0._subRunStatistics.deadCount = arg0._statistics._deadCount
	arg0._subRunStatistics.losePoint = var0
	arg0._subRunStatistics.point = var1
	arg0._subRunStatistics.total = var3
	arg0._statistics.subRunResult = arg0._subRunStatistics
end

function var0.AirFightInit(arg0)
	arg0._statistics._airFightStatistics = {}
	arg0._statistics._airFightStatistics.kill = 0
	arg0._statistics._airFightStatistics.score = 0
	arg0._statistics._airFightStatistics.hit = 0
	arg0._statistics._airFightStatistics.lose = 0
	arg0._statistics._airFightStatistics.total = 0
end

function var0.AddAirFightScore(arg0, arg1)
	arg0._statistics._airFightStatistics.score = arg0._statistics._airFightStatistics.score + arg1
	arg0._statistics._airFightStatistics.kill = arg0._statistics._airFightStatistics.kill + 1
	arg0._statistics._airFightStatistics.total = math.max(arg0._statistics._airFightStatistics.score - arg0._statistics._airFightStatistics.lose, 0)

	arg0:DispatchEvent(ys.Event.New(var1.UPDATE_DODGEM_SCORE, {
		totalScore = arg0._statistics._airFightStatistics.total
	}))
end

function var0.DecreaseAirFightScore(arg0, arg1)
	arg0._statistics._airFightStatistics.lose = arg0._statistics._airFightStatistics.lose + arg1
	arg0._statistics._airFightStatistics.hit = arg0._statistics._airFightStatistics.hit + 1
	arg0._statistics._airFightStatistics.total = math.max(arg0._statistics._airFightStatistics.score - arg0._statistics._airFightStatistics.lose, 0)

	arg0:DispatchEvent(ys.Event.New(var1.UPDATE_DODGEM_SCORE, {
		totalScore = arg0._statistics._airFightStatistics.total
	}))
end

function var0.CalcAirFightScore(arg0)
	arg0._statistics._battleScore = var3.BattleScore.S
end
