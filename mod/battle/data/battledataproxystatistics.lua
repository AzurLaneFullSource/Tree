local var0_0 = ys.Battle.BattleDataProxy
local var1_0 = ys.Battle.BattleEvent
local var2_0 = ys.Battle.BattleFormulas
local var3_0 = ys.Battle.BattleConst
local var4_0 = ys.Battle.BattleConfig
local var5_0 = ys.Battle.BattleDataFunction
local var6_0 = ys.Battle.BattleAttr
local var7_0 = ys.Battle.BattleVariable

function var0_0.StatisticsInit(arg0_1, arg1_1)
	arg0_1._statistics = {}
	arg0_1._statistics._battleScore = var3_0.BattleScore.D
	arg0_1._statistics.kill_id_list = {}
	arg0_1._statistics._totalTime = 0
	arg0_1._statistics._deadCount = 0
	arg0_1._statistics._boss_destruct = 0
	arg0_1._statistics._botPercentage = 0
	arg0_1._statistics._maxBossHP = 0
	arg0_1._statistics._enemyInfoList = {}

	for iter0_1, iter1_1 in ipairs(arg1_1) do
		local var0_1 = {
			id = iter1_1:GetAttrByName("id")
		}

		var0_1.damage = 0
		var0_1.output = 0
		var0_1.kill_count = 0
		var0_1.bp = 0
		var0_1.max_hp = iter1_1:GetAttrByName("maxHP")
		var0_1.maxDamageOnce = 0
		var0_1.gearScore = iter1_1:GetGearScore()
		arg0_1._statistics[var0_1.id] = var0_1
	end
end

function var0_0.InitAidUnitStatistics(arg0_2, arg1_2)
	local var0_2 = {
		id = arg1_2:GetAttrByName("id")
	}

	var0_2.damage = 0
	var0_2.output = 0
	var0_2.kill_count = 0
	var0_2.bp = 0
	var0_2.max_hp = arg1_2:GetAttrByName("maxHP")
	var0_2.maxDamageOnce = 0
	var0_2.gearScore = arg1_2:GetGearScore()
	arg0_2._statistics[var0_2.id] = var0_2
	arg0_2._statistics.submarineAid = true
end

function var0_0.InitSpecificEnemyStatistics(arg0_3, arg1_3)
	local var0_3 = {
		id = arg1_3:GetAttrByName("id")
	}

	var0_3.damage = 0
	var0_3.output = 0
	var0_3.kill_count = 0
	var0_3.bp = 0
	var0_3.max_hp = arg1_3:GetAttrByName("maxHP")
	var0_3.init_hp = arg1_3:GetCurrentHP()
	var0_3.maxDamageOnce = 0
	var0_3.gearScore = arg1_3:GetGearScore()
	arg0_3._statistics[var0_3.id] = var0_3
end

function var0_0.RivalInit(arg0_4, arg1_4)
	arg0_4._statistics._rivalInfo = {}

	for iter0_4, iter1_4 in ipairs(arg1_4) do
		local var0_4 = iter1_4:GetAttrByName("id")

		arg0_4._statistics._rivalInfo[var0_4] = {}
		arg0_4._statistics._rivalInfo[var0_4].id = var0_4
	end
end

function var0_0.DodgemCountInit(arg0_5)
	arg0_5._dodgemStatistics = {}
	arg0_5._dodgemStatistics.kill = 0
	arg0_5._dodgemStatistics.combo = 0
	arg0_5._dodgemStatistics.miss = 0
	arg0_5._dodgemStatistics.fail = 0
	arg0_5._dodgemStatistics.score = 0
	arg0_5._dodgemStatistics.maxCombo = 0
end

function var0_0.SubmarineRunInit(arg0_6)
	arg0_6._subRunStatistics = {}
	arg0_6._subRunStatistics.score = 0
end

function var0_0.SetFlagShipID(arg0_7, arg1_7)
	if arg1_7 then
		arg0_7._statistics._flagShipID = arg1_7:GetAttrByName("id")
	end
end

function var0_0.DamageStatistics(arg0_8, arg1_8, arg2_8, arg3_8)
	if arg0_8._statistics[arg1_8] then
		arg0_8._statistics[arg1_8].output = arg0_8._statistics[arg1_8].output + arg3_8
		arg0_8._statistics[arg1_8].maxDamageOnce = math.max(arg0_8._statistics[arg1_8].maxDamageOnce, arg3_8)
	end

	if arg0_8._statistics[arg2_8] then
		arg0_8._statistics[arg2_8].damage = arg0_8._statistics[arg2_8].damage + arg3_8
	end
end

function var0_0.KillCountStatistics(arg0_9, arg1_9, arg2_9)
	if arg0_9._statistics[arg1_9] then
		arg0_9._statistics[arg1_9].kill_count = arg0_9._statistics[arg1_9].kill_count + 1
	end
end

function var0_0.HPRatioStatistics(arg0_10)
	for iter0_10, iter1_10 in pairs(arg0_10._fleetList) do
		iter1_10:UndoFusion()
	end

	local var0_10 = arg0_10._fleetList[1]:GetUnitList()

	for iter2_10, iter3_10 in ipairs(var0_10) do
		arg0_10._statistics[iter3_10:GetAttrByName("id")].bp = math.ceil(iter3_10:GetHPRate() * 10000)
	end
end

function var0_0.BotPercentage(arg0_11, arg1_11)
	local var0_11 = arg0_11._currentStageData.timeCount - arg0_11._countDown

	arg0_11._statistics._botPercentage = Mathf.Clamp(math.floor(arg1_11 / var0_11 * 100), 0, 100)
end

function var0_0.CalcBattleScoreWhenDead(arg0_12, arg1_12)
	local var0_12 = arg1_12:GetIFF()

	if var0_12 == var4_0.FRIENDLY_CODE then
		if not table.contains(TeamType.SubShipType, arg1_12:GetTemplate().type) then
			arg0_12:DelScoreWhenPlayerDead(arg1_12)
		end
	elseif var0_12 == var4_0.FOE_CODE then
		arg0_12:AddScoreWhenEnemyDead(arg1_12)
	end
end

function var0_0.AddScoreWhenBossDestruct(arg0_13)
	arg0_13._statistics._boss_destruct = arg0_13._statistics._boss_destruct + 1
end

function var0_0.AddScoreWhenEnemyDead(arg0_14, arg1_14)
	if arg1_14:GetDeathReason() == var3_0.UnitDeathReason.KILLED then
		arg0_14._statistics.kill_id_list[#arg0_14._statistics.kill_id_list + 1] = arg1_14:GetTemplateID()
	end
end

function var0_0.DelScoreWhenPlayerDead(arg0_15, arg1_15)
	arg0_15._statistics._deadCount = arg0_15._statistics._deadCount + 1
end

function var0_0.CalcBPWhenPlayerLeave(arg0_16, arg1_16)
	arg0_16._statistics[arg1_16:GetAttrByName("id")].bp = math.ceil(arg1_16:GetHPRate() * 10000)
end

function var0_0.isTimeOut(arg0_17)
	return arg0_17._currentStageData.timeCount - arg0_17._countDown >= 180
end

function var0_0.CalcCardPuzzleScoreAtEnd(arg0_18, arg1_18)
	arg0_18._statistics._deadUnit = true
	arg0_18._statistics._badTime = true

	local var0_18 = arg1_18:GetCardPuzzleComponent():GetCurrentCommonHP()

	arg0_18._statistics._battleScore = var0_18 > 0 and var3_0.BattleScore.S or var3_0.BattleScore.D
	arg0_18._statistics._cardPuzzleStatistics = {}
	arg0_18._statistics._cardPuzzleStatistics.common_hp_rest = var0_18

	local var1_18 = arg0_18._currentStageData.timeCount - arg0_18._countDown

	arg0_18._statistics._totalTime = var1_18

	arg0_18:AirFightInit()
end

function var0_0.CalcSingleDungeonScoreAtEnd(arg0_19, arg1_19)
	arg0_19._statistics._deadUnit = true
	arg0_19._statistics._badTime = true

	local var0_19 = arg0_19._currentStageData.timeCount - arg0_19._countDown

	arg0_19._statistics._totalTime = var0_19

	local var1_19 = arg0_19._expeditionTmp.limit_type
	local var2_19 = arg0_19._expeditionTmp.sink_limit
	local var3_19 = arg0_19._expeditionTmp.time_limit

	if var2_19 > arg0_19._statistics._deadCount then
		arg0_19._statistics._deadUnit = false
	end

	local var4_19 = arg1_19:GetFlagShip()
	local var5_19 = arg1_19:GetScoutList()

	if var1_19 == 2 then
		if not var4_19:IsAlive() or #var5_19 <= 0 then
			arg0_19._statistics._battleScore = var3_0.BattleScore.D
			arg0_19._statistics._boss_destruct = 1
		else
			arg0_19._statistics._battleScore = var3_0.BattleScore.S
		end
	elseif arg0_19._countDown <= 0 then
		arg0_19._statistics._battleScore = var3_0.BattleScore.C
		arg0_19._statistics._boss_destruct = 1
	elseif var4_19 and not var4_19:IsAlive() then
		arg0_19._statistics._battleScore = var3_0.BattleScore.D
		arg0_19._statistics._boss_destruct = 1
		arg0_19._statistics._scoreMark = var3_0.DEAD_FLAG
	elseif #var5_19 <= 0 then
		arg0_19._statistics._battleScore = var3_0.BattleScore.D
		arg0_19._statistics._boss_destruct = 1
	else
		local var6_19 = 0

		if arg0_19._statistics._deadUnit then
			var6_19 = var6_19 + 1
		end

		if var3_19 < var0_19 then
			var6_19 = var6_19 + 1
		else
			arg0_19._statistics._badTime = false
		end

		if arg0_19._statistics._boss_destruct > 0 then
			var6_19 = var6_19 + 1
		end

		if var6_19 >= 2 then
			arg0_19._statistics._battleScore = var3_0.BattleScore.B
		elseif var6_19 == 1 then
			arg0_19._statistics._battleScore = var3_0.BattleScore.A
		elseif var6_19 == 0 then
			arg0_19._statistics._battleScore = var3_0.BattleScore.S
		end
	end

	arg0_19._statistics._timeout = arg0_19:isTimeOut()

	if arg0_19._battleInitData.CMDArgs then
		arg0_19:CalcSpecificEnemyInfo({
			arg0_19._battleInitData.CMDArgs
		})
	end
end

function var0_0.CalcMaxRestHPRateBossRate(arg0_20, arg1_20)
	arg0_20._statistics._maxBossHP = arg1_20
end

function var0_0.CalcDuelScoreAtTimesUp(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21)
	arg0_21._statistics._deadUnit = true
	arg0_21._statistics._badTime = true
	arg0_21._statistics._timeout = false

	local var0_21 = arg0_21._currentStageData.timeCount - arg0_21._countDown

	arg0_21._statistics._totalTime = var0_21

	if arg0_21._expeditionTmp.sink_limit > arg0_21._statistics._deadCount then
		arg0_21._statistics._deadUnit = false
	end

	if arg2_21 < arg1_21 then
		arg0_21._statistics._battleScore = var3_0.BattleScore.S
	elseif arg1_21 < arg2_21 then
		arg0_21._statistics._battleScore = var3_0.BattleScore.D
	elseif arg4_21 <= arg3_21 then
		arg0_21._statistics._battleScore = var3_0.BattleScore.S
	elseif arg3_21 < arg4_21 then
		arg0_21._statistics._battleScore = var3_0.BattleScore.D
	end
end

function var0_0.CalcDuelScoreAtEnd(arg0_22, arg1_22, arg2_22)
	arg0_22._statistics._deadUnit = true
	arg0_22._statistics._badTime = true

	local var0_22 = arg0_22._currentStageData.timeCount - arg0_22._countDown

	arg0_22._statistics._totalTime = var0_22

	local var1_22 = #arg1_22:GetUnitList()
	local var2_22 = #arg2_22:GetUnitList()
	local var3_22 = arg0_22._expeditionTmp.sink_limit
	local var4_22 = arg0_22._expeditionTmp.time_limit

	if var3_22 > arg0_22._statistics._deadCount then
		arg0_22._statistics._deadUnit = false
	end

	if var1_22 == 0 then
		arg0_22._statistics._battleScore = var3_0.BattleScore.D
	elseif var2_22 == 0 then
		arg0_22._statistics._battleScore = var3_0.BattleScore.S
	end

	arg0_22._statistics._timeout = arg0_22:isTimeOut()
end

function var0_0.CalcSimulationScoreAtEnd(arg0_23, arg1_23, arg2_23)
	arg0_23._statistics._deadUnit = true
	arg0_23._statistics._badTime = true

	local var0_23 = arg0_23._currentStageData.timeCount - arg0_23._countDown

	arg0_23._statistics._totalTime = var0_23

	local var1_23 = #arg1_23:GetUnitList()
	local var2_23 = arg1_23:GetMaxCount()
	local var3_23 = #arg1_23:GetScoutList()
	local var4_23 = #arg2_23:GetUnitList()
	local var5_23 = arg0_23._expeditionTmp.sink_limit
	local var6_23 = arg0_23._expeditionTmp.time_limit

	if arg0_23._statistics._deadCount <= 0 then
		arg0_23._statistics._deadUnit = false
	end

	if not arg1_23:GetFlagShip():IsAlive() then
		arg0_23._statistics._battleScore = var3_0.BattleScore.D
		arg0_23._statistics._scoreMark = var3_0.DEAD_FLAG
	elseif var3_23 == 0 then
		arg0_23._statistics._battleScore = var3_0.BattleScore.D
	elseif var4_23 == 0 then
		arg0_23._statistics._battleScore = var3_0.BattleScore.S
	end

	arg0_23._statistics._timeout = arg0_23:isTimeOut()

	arg0_23:overwriteRivalStatistics(arg2_23)
end

function var0_0.CalcSimulationScoreAtTimesUp(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24, arg5_24)
	arg0_24._statistics._deadUnit = true
	arg0_24._statistics._badTime = true
	arg0_24._statistics._timeout = false

	local var0_24 = arg0_24._currentStageData.timeCount - arg0_24._countDown

	arg0_24._statistics._totalTime = var0_24

	if arg0_24._statistics._deadCount <= 0 then
		arg0_24._statistics._deadUnit = false
	end

	arg0_24._statistics._battleScore = var3_0.BattleScore.D

	arg0_24:overwriteRivalStatistics(arg5_24)
end

function var0_0.overwriteRivalStatistics(arg0_25, arg1_25)
	for iter0_25, iter1_25 in pairs(arg0_25._statistics._rivalInfo) do
		local var0_25 = false

		for iter2_25, iter3_25 in ipairs(arg1_25:GetUnitList()) do
			if iter3_25:GetAttrByName("id") == iter0_25 then
				iter1_25.bp = math.ceil(iter3_25:GetHPRate() * 10000)
				var0_25 = true

				break
			end
		end

		if not var0_25 then
			iter1_25.bp = 0
		end
	end
end

function var0_0.CalcChallengeScore(arg0_26, arg1_26)
	if arg1_26 then
		arg0_26._statistics._battleScore = var3_0.BattleScore.S
	else
		arg0_26._statistics._battleScore = var3_0.BattleScore.D
	end

	arg0_26._statistics._totalTime = arg0_26._totalTime
end

function var0_0.CalcDodgemCount(arg0_27, arg1_27)
	local var0_27 = arg1_27:GetDeathReason()
	local var1_27 = arg1_27:GetTemplate().type

	if var0_27 == ys.Battle.BattleConst.UnitDeathReason.CRUSH then
		arg0_27._dodgemStatistics.kill = arg0_27._dodgemStatistics.kill + 1

		if var1_27 == ShipType.JinBi then
			arg0_27._dodgemStatistics.combo = arg0_27._dodgemStatistics.combo + 1
			arg0_27._dodgemStatistics.maxCombo = math.max(arg0_27._dodgemStatistics.maxCombo, arg0_27._dodgemStatistics.combo)

			local var2_27 = arg0_27._dodgemStatistics.score + arg0_27:GetScorePoint()

			arg0_27._dodgemStatistics.score = var2_27

			arg0_27:DispatchEvent(ys.Event.New(var1_0.UPDATE_DODGEM_SCORE, {
				totalScore = var2_27
			}))
		elseif var1_27 == ShipType.ZiBao then
			arg0_27._dodgemStatistics.fail = arg0_27._dodgemStatistics.fail + 1
			arg0_27._dodgemStatistics.combo = 0
		end

		arg0_27:DispatchEvent(ys.Event.New(var1_0.UPDATE_DODGEM_COMBO, {
			combo = arg0_27._dodgemStatistics.combo
		}))
	elseif var1_27 == ShipType.JinBi then
		arg0_27._dodgemStatistics.miss = arg0_27._dodgemStatistics.miss + 1
	end
end

function var0_0.GetScorePoint(arg0_28)
	local var0_28

	if arg0_28._dodgemStatistics.combo == 1 then
		var0_28 = 1
	elseif arg0_28._dodgemStatistics.combo == 2 then
		var0_28 = 2
	elseif arg0_28._dodgemStatistics.combo > 2 then
		var0_28 = 3
	end

	return var0_28
end

function var0_0.CalcDodgemScore(arg0_29)
	if arg0_29._dodgemStatistics.score >= var4_0.BATTLE_DODGEM_PASS_SCORE then
		arg0_29._statistics._battleScore = var3_0.BattleScore.S
	else
		arg0_29._statistics._battleScore = var3_0.BattleScore.B
	end

	arg0_29._statistics.dodgemResult = arg0_29._dodgemStatistics
end

function var0_0.CalcActBossDamageInfo(arg0_30, arg1_30)
	local var0_30 = var5_0.GetSpecificEnemyList(arg1_30, arg0_30._expeditionID)

	arg0_30:CalcSpecificEnemyInfo(var0_30)
end

function var0_0.CalcWorldBossDamageInfo(arg0_31, arg1_31, arg2_31, arg3_31)
	local var0_31 = var5_0.GetSpecificWorldJointEnemyList(arg1_31, arg2_31, arg3_31)

	arg0_31:CalcSpecificEnemyInfo(var0_31)
end

function var0_0.CalcGuildBossEnemyInfo(arg0_32, arg1_32)
	local var0_32 = var5_0.GetSpecificGuildBossEnemyList(arg1_32, arg0_32._expeditionID)

	arg0_32:CalcSpecificEnemyInfo(var0_32)
end

function var0_0.CalcSpecificEnemyInfo(arg0_33, arg1_33)
	arg0_33._statistics.specificDamage = 0

	for iter0_33, iter1_33 in ipairs(arg1_33) do
		if arg0_33._statistics["enemy_" .. iter1_33] then
			local var0_33 = arg0_33._statistics["enemy_" .. iter1_33].damage

			if table.contains(arg0_33._statistics.kill_id_list, iter1_33) then
				var0_33 = arg0_33._statistics["enemy_" .. iter1_33].init_hp
			end

			arg0_33._statistics.specificDamage = arg0_33._statistics.specificDamage + var0_33

			local var1_33 = {
				id = iter1_33,
				damage = var0_33,
				totalHp = arg0_33._statistics["enemy_" .. iter1_33].max_hp
			}

			table.insert(arg0_33._statistics._enemyInfoList, var1_33)
		end
	end
end

function var0_0.CalcKillingSupplyShip(arg0_34)
	arg0_34._subRunStatistics.score = arg0_34._subRunStatistics.score + 1
end

function var0_0.CalcSubRunTimeUp(arg0_35)
	arg0_35._statistics._battleScore = var3_0.BattleScore.B
	arg0_35._statistics.subRunResult = arg0_35._subRunStatistics
end

function var0_0.CalcSubRunScore(arg0_36)
	arg0_36._statistics._battleScore = var3_0.BattleScore.S
	arg0_36._statistics.subRunResult = arg0_36._subRunStatistics
end

function var0_0.CalcSubRunDead(arg0_37)
	arg0_37._statistics._battleScore = var3_0.BattleScore.D
	arg0_37._statistics.subRunResult = arg0_37._subRunStatistics
end

function var0_0.CalcKillingSupplyShip(arg0_38)
	arg0_38._subRunStatistics.score = arg0_38._subRunStatistics.score + 1
end

function var0_0.CalcSubRountineTimeUp(arg0_39)
	arg0_39._statistics._badTime = true

	arg0_39:CalcSubRoutineScore()

	arg0_39._statistics._battleScore = var3_0.BattleScore.C
end

function var0_0.CalcSubRountineElimate(arg0_40)
	arg0_40._statistics._elimated = true

	arg0_40:CalcSubRoutineScore()

	arg0_40._statistics._battleScore = var3_0.BattleScore.D
end

function var0_0.CalcSubRoutineScore(arg0_41)
	local var0_41 = arg0_41._statistics._deadCount * var4_0.SR_CONFIG.DEAD_POINT
	local var1_41 = arg0_41._subRunStatistics.score * var4_0.SR_CONFIG.POINT
	local var2_41 = (arg0_41._statistics._badTime or arg0_41._statistics._elimated) and 0 or var4_0.SR_CONFIG.BASE_POINT
	local var3_41 = var2_41 + var1_41 - var0_41

	if var3_41 >= var4_0.SR_CONFIG.BASE_POINT + var4_0.SR_CONFIG.M * var4_0.SR_CONFIG.POINT then
		arg0_41._statistics._battleScore = var3_0.BattleScore.S
	elseif var3_41 >= var4_0.SR_CONFIG.BASE_POINT then
		arg0_41._statistics._battleScore = var3_0.BattleScore.A
	elseif var3_41 >= var4_0.SR_CONFIG.BASE_POINT - 2 * var4_0.SR_CONFIG.DEAD_POINT then
		arg0_41._statistics._battleScore = var3_0.BattleScore.B
	else
		arg0_41._statistics._battleScore = var3_0.BattleScore.D
	end

	arg0_41._subRunStatistics.basePoint = var2_41
	arg0_41._subRunStatistics.deadCount = arg0_41._statistics._deadCount
	arg0_41._subRunStatistics.losePoint = var0_41
	arg0_41._subRunStatistics.point = var1_41
	arg0_41._subRunStatistics.total = var3_41
	arg0_41._statistics.subRunResult = arg0_41._subRunStatistics
end

function var0_0.AirFightInit(arg0_42)
	arg0_42._statistics._airFightStatistics = {}
	arg0_42._statistics._airFightStatistics.kill = 0
	arg0_42._statistics._airFightStatistics.score = 0
	arg0_42._statistics._airFightStatistics.hit = 0
	arg0_42._statistics._airFightStatistics.lose = 0
	arg0_42._statistics._airFightStatistics.total = 0
end

function var0_0.AddAirFightScore(arg0_43, arg1_43)
	arg0_43._statistics._airFightStatistics.score = arg0_43._statistics._airFightStatistics.score + arg1_43
	arg0_43._statistics._airFightStatistics.kill = arg0_43._statistics._airFightStatistics.kill + 1
	arg0_43._statistics._airFightStatistics.total = math.max(arg0_43._statistics._airFightStatistics.score - arg0_43._statistics._airFightStatistics.lose, 0)

	arg0_43:DispatchEvent(ys.Event.New(var1_0.UPDATE_DODGEM_SCORE, {
		totalScore = arg0_43._statistics._airFightStatistics.total
	}))
end

function var0_0.DecreaseAirFightScore(arg0_44, arg1_44)
	arg0_44._statistics._airFightStatistics.lose = arg0_44._statistics._airFightStatistics.lose + arg1_44
	arg0_44._statistics._airFightStatistics.hit = arg0_44._statistics._airFightStatistics.hit + 1
	arg0_44._statistics._airFightStatistics.total = math.max(arg0_44._statistics._airFightStatistics.score - arg0_44._statistics._airFightStatistics.lose, 0)

	arg0_44:DispatchEvent(ys.Event.New(var1_0.UPDATE_DODGEM_SCORE, {
		totalScore = arg0_44._statistics._airFightStatistics.total
	}))
end

function var0_0.CalcAirFightScore(arg0_45)
	arg0_45._statistics._battleScore = var3_0.BattleScore.S
end
