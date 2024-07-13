ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleSpawnWave = class("BattleSpawnWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleSpawnWave.__name = "BattleSpawnWave"

local var1_0 = var0_0.Battle.BattleSpawnWave

var1_0.ASYNC_TIME_GAP = 0.03

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1._spawnUnitList = {}
	arg0_1._monsterList = {}
	arg0_1._reinforceKillCount = 0
	arg0_1._reinforceTotalKillCount = 0
	arg0_1._airStrikeTimerList = {}
	arg0_1._spawnTimerList = {}
	arg0_1._reinforceSpawnTimerList = {}
end

function var1_0.SetWaveData(arg0_2, arg1_2)
	var1_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._sapwnData = arg1_2.spawn or {}
	arg0_2._airStrike = arg1_2.airFighter or {}
	arg0_2._reinforce = arg1_2.reinforcement or {}
	arg0_2._reinforceCount = #arg0_2._reinforce
	arg0_2._spawnCount = #arg0_2._sapwnData
	arg0_2._reinforceDuration = arg0_2._reinforce.reinforceDuration or 0
	arg0_2._reinforeceExpire = false
	arg0_2._round = arg0_2._param.round
end

function var1_0.IsBossWave(arg0_3)
	local var0_3 = false
	local var1_3 = arg0_3._sapwnData

	for iter0_3, iter1_3 in ipairs(var1_3) do
		if iter1_3.bossData then
			var0_3 = true
		end
	end

	return var0_3
end

function var1_0.DoWave(arg0_4)
	var1_0.super.DoWave(arg0_4)

	if arg0_4._round then
		local var0_4 = false
		local var1_4 = var0_0.Battle.BattleDataProxy.GetInstance()

		if var1_4:GetInitData().ChallengeInfo then
			local var2_4 = var1_4:GetInitData().ChallengeInfo:getRound()

			if arg0_4._round.less and var2_4 < arg0_4._round.less then
				var0_4 = true
			end

			if arg0_4._round.more and var2_4 > arg0_4._round.more then
				var0_4 = true
			end

			if arg0_4._round.equal and table.contains(arg0_4._round.equal, var2_4) then
				var0_4 = true
			end
		end

		if not var0_4 then
			arg0_4:doPass()

			return
		end
	end

	for iter0_4, iter1_4 in ipairs(arg0_4._airStrike) do
		local var3_4 = iter1_4.delay + iter0_4 * var1_0.ASYNC_TIME_GAP

		if var3_4 <= 0 then
			arg0_4:doAirStrike(iter1_4)
		else
			arg0_4:airStrikeTimer(iter1_4, var3_4)
		end
	end

	local var4_4 = 0

	for iter2_4, iter3_4 in ipairs(arg0_4._sapwnData) do
		if iter3_4.bossData then
			var4_4 = var4_4 + 1
		end
	end

	local var5_4 = 0
	local var6_4 = 0

	for iter4_4, iter5_4 in ipairs(arg0_4._sapwnData) do
		if (iter5_4.chance or 1) >= math.random() then
			if iter5_4.bossData and var4_4 > 1 then
				var5_4 = var5_4 + 1
				iter5_4.bossData.bossCount = var5_4
			end

			local var7_4 = iter5_4.delay + var6_4

			if var7_4 <= 0 then
				arg0_4:doSpawn(iter5_4)
			else
				arg0_4:spawnTimer(iter5_4, var7_4, arg0_4._spawnTimerList)
			end
		else
			arg0_4._spawnCount = arg0_4._spawnCount - 1
		end

		var6_4 = var6_4 + var1_0.ASYNC_TIME_GAP
	end

	if arg0_4._reinforce then
		arg0_4:doReinforce(var6_4)
	end

	if arg0_4._spawnCount == 0 and arg0_4._reinforceDuration == 0 then
		arg0_4:doPass()
	end

	if arg0_4._reinforceDuration ~= 0 then
		arg0_4:reinforceDurationTimer(arg0_4._reinforceDuration)
	end

	var0_0.Battle.BattleState.GenerateVertifyData(1)

	local var8_4, var9_4 = var0_0.Battle.BattleState.Vertify()

	if not var8_4 then
		local var10_4 = 100 + var9_4

		var0_0.Battle.BattleState.GetInstance():GetCommandByName(var0_0.Battle.BattleSingleDungeonCommand.__name):SetVertifyFail(var10_4)
	end
end

function var1_0.AddMonster(arg0_5, arg1_5)
	if arg1_5:GetWaveIndex() ~= arg0_5._index then
		return
	end

	arg0_5._monsterList[arg1_5:GetUniqueID()] = arg1_5
end

function var1_0.RemoveMonster(arg0_6, arg1_6)
	arg0_6:onWaveUnitDie(arg1_6)
end

function var1_0.doSpawn(arg0_7, arg1_7)
	local var0_7 = var0_0.Battle.BattleConst.UnitType.ENEMY_UNIT

	if arg1_7.bossData then
		var0_7 = var0_0.Battle.BattleConst.UnitType.BOSS_UNIT
	end

	arg0_7._spawnFunc(arg1_7, arg0_7._index, var0_7)
end

function var1_0.spawnTimer(arg0_8, arg1_8, arg2_8, arg3_8)
	local var0_8

	local function var1_8()
		arg3_8[var0_8] = nil

		arg0_8:doSpawn(arg1_8)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0_8)
	end

	var0_8 = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, arg2_8, var1_8, true)
	arg3_8[var0_8] = true
end

function var1_0.doAirStrike(arg0_10, arg1_10)
	arg0_10._airFunc(arg1_10)
end

function var1_0.airStrikeTimer(arg0_11, arg1_11, arg2_11)
	local var0_11

	local function var1_11()
		arg0_11._airStrikeTimerList[var0_11] = nil

		arg0_11:doAirStrike(arg1_11)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0_11)
	end

	var0_11 = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, arg2_11, var1_11, true)
	arg0_11._airStrikeTimerList[var0_11] = true
end

function var1_0.doReinforce(arg0_13, arg1_13)
	arg0_13._reinforceKillCount = 0

	if arg0_13._reinforeceExpire then
		return
	end

	arg1_13 = arg1_13 or 0

	for iter0_13, iter1_13 in ipairs(arg0_13._reinforce) do
		iter1_13.reinforce = true

		local var0_13 = iter1_13.delay + arg1_13

		if var0_13 <= 0 then
			arg0_13:doSpawn(iter1_13)
		else
			arg0_13:spawnTimer(iter1_13, var0_13, arg0_13._reinforceSpawnTimerList)
		end

		arg1_13 = arg1_13 + var1_0.ASYNC_TIME_GAP
	end
end

function var1_0.reinforceTimer(arg0_14, arg1_14)
	arg0_14:clearReinforceTimer()

	local function var0_14()
		arg0_14:doReinforce()
		arg0_14:clearReinforceTimer()
	end

	arg0_14._reinforceTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, arg1_14, var0_14, true)
end

function var1_0.clearReinforceTimer(arg0_16)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_16._reinforceTimer)

	arg0_16._reinforceTimer = nil
end

function var1_0.reinforceDurationTimer(arg0_17, arg1_17)
	local function var0_17()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_17._reinforceDurationTimer)

		arg0_17._reinforeceExpire = true
		arg0_17._reinforceDuration = nil

		arg0_17:clearReinforceTimer()
		arg0_17.clearTimerList(arg0_17._reinforceSpawnTimerList)

		if arg0_17._spawnCount == 0 then
			arg0_17:doPass()
		end
	end

	arg0_17._reinforceDurationTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, arg1_17, var0_17, true)
end

function var1_0.clearReinforceDurationTimer(arg0_19)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0_19._reinforceDurationTimer)

	arg0_19._reinforceDurationTimer = nil
end

function var1_0.onWaveUnitDie(arg0_20, arg1_20)
	local var0_20 = arg0_20._monsterList[arg1_20]

	if var0_20 == nil then
		return
	end

	local var1_20

	if var0_20:IsReinforcement() then
		arg0_20._reinforceKillCount = arg0_20._reinforceKillCount + 1
		arg0_20._reinforceTotalKillCount = arg0_20._reinforceTotalKillCount + 1

		if arg0_20._reinforceCount ~= 0 and arg0_20._reinforceCount == arg0_20._reinforceKillCount then
			var1_20 = true
		end
	end

	local function var2_20(arg0_21)
		if var1_20 and arg0_21 then
			if arg0_21 == 0 then
				arg0_20:doReinforce()
			else
				arg0_20:reinforceTimer(arg0_21)
			end

			var1_20 = false
		end
	end

	local var3_20 = 0
	local var4_20 = 0

	for iter0_20, iter1_20 in pairs(arg0_20._monsterList) do
		if iter1_20:IsAlive() == false then
			if not iter1_20:IsReinforcement() then
				var3_20 = var3_20 + 1
			end
		else
			var4_20 = var4_20 + 1

			var2_20(iter1_20:GetReinforceCastTime())
		end
	end

	if arg0_20._reinforceDuration ~= 0 and not arg0_20._reinforeceExpire then
		var2_20(0)
	end

	if var4_20 == 0 and var3_20 >= arg0_20._spawnCount and arg0_20._reinforceTotalKillCount >= arg0_20._reinforceCount and (arg0_20._reinforceDuration == 0 or arg0_20._reinforeceExpire) then
		arg0_20:doPass()
	end
end

function var1_0.doPass(arg0_22)
	arg0_22.clearTimerList(arg0_22._spawnTimerList)
	arg0_22.clearTimerList(arg0_22._reinforceSpawnTimerList)
	arg0_22:clearReinforceTimer()
	arg0_22:clearReinforceDurationTimer()
	var0_0.Battle.BattleDataProxy.GetInstance():KillWaveSummonMonster(arg0_22._index)
	var1_0.super.doPass(arg0_22)
end

function var1_0.clearTimerList(arg0_23)
	for iter0_23, iter1_23 in pairs(arg0_23) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter0_23)
	end
end

function var1_0.Dispose(arg0_24)
	arg0_24.clearTimerList(arg0_24._airStrikeTimerList)

	arg0_24._airStrikeTimerList = nil

	arg0_24.clearTimerList(arg0_24._spawnTimerList)

	arg0_24._spawnTimerList = nil

	arg0_24.clearTimerList(arg0_24._reinforceSpawnTimerList)

	arg0_24._reinforceSpawnTimerList = nil

	arg0_24:clearReinforceTimer()
	arg0_24:clearReinforceDurationTimer()
	var1_0.super.Dispose(arg0_24)
end
