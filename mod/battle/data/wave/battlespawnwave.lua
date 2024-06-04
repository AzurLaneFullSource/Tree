ys = ys or {}

local var0 = ys

var0.Battle.BattleSpawnWave = class("BattleSpawnWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleSpawnWave.__name = "BattleSpawnWave"

local var1 = var0.Battle.BattleSpawnWave

var1.ASYNC_TIME_GAP = 0.03

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)

	arg0._spawnUnitList = {}
	arg0._monsterList = {}
	arg0._reinforceKillCount = 0
	arg0._reinforceTotalKillCount = 0
	arg0._airStrikeTimerList = {}
	arg0._spawnTimerList = {}
	arg0._reinforceSpawnTimerList = {}
end

function var1.SetWaveData(arg0, arg1)
	var1.super.SetWaveData(arg0, arg1)

	arg0._sapwnData = arg1.spawn or {}
	arg0._airStrike = arg1.airFighter or {}
	arg0._reinforce = arg1.reinforcement or {}
	arg0._reinforceCount = #arg0._reinforce
	arg0._spawnCount = #arg0._sapwnData
	arg0._reinforceDuration = arg0._reinforce.reinforceDuration or 0
	arg0._reinforeceExpire = false
	arg0._round = arg0._param.round
end

function var1.IsBossWave(arg0)
	local var0 = false
	local var1 = arg0._sapwnData

	for iter0, iter1 in ipairs(var1) do
		if iter1.bossData then
			var0 = true
		end
	end

	return var0
end

function var1.DoWave(arg0)
	var1.super.DoWave(arg0)

	if arg0._round then
		local var0 = false
		local var1 = var0.Battle.BattleDataProxy.GetInstance()

		if var1:GetInitData().ChallengeInfo then
			local var2 = var1:GetInitData().ChallengeInfo:getRound()

			if arg0._round.less and var2 < arg0._round.less then
				var0 = true
			end

			if arg0._round.more and var2 > arg0._round.more then
				var0 = true
			end

			if arg0._round.equal and table.contains(arg0._round.equal, var2) then
				var0 = true
			end
		end

		if not var0 then
			arg0:doPass()

			return
		end
	end

	for iter0, iter1 in ipairs(arg0._airStrike) do
		local var3 = iter1.delay + iter0 * var1.ASYNC_TIME_GAP

		if var3 <= 0 then
			arg0:doAirStrike(iter1)
		else
			arg0:airStrikeTimer(iter1, var3)
		end
	end

	local var4 = 0

	for iter2, iter3 in ipairs(arg0._sapwnData) do
		if iter3.bossData then
			var4 = var4 + 1
		end
	end

	local var5 = 0
	local var6 = 0

	for iter4, iter5 in ipairs(arg0._sapwnData) do
		if (iter5.chance or 1) >= math.random() then
			if iter5.bossData and var4 > 1 then
				var5 = var5 + 1
				iter5.bossData.bossCount = var5
			end

			local var7 = iter5.delay + var6

			if var7 <= 0 then
				arg0:doSpawn(iter5)
			else
				arg0:spawnTimer(iter5, var7, arg0._spawnTimerList)
			end
		else
			arg0._spawnCount = arg0._spawnCount - 1
		end

		var6 = var6 + var1.ASYNC_TIME_GAP
	end

	if arg0._reinforce then
		arg0:doReinforce(var6)
	end

	if arg0._spawnCount == 0 and arg0._reinforceDuration == 0 then
		arg0:doPass()
	end

	if arg0._reinforceDuration ~= 0 then
		arg0:reinforceDurationTimer(arg0._reinforceDuration)
	end

	var0.Battle.BattleState.GenerateVertifyData(1)

	local var8, var9 = var0.Battle.BattleState.Vertify()

	if not var8 then
		local var10 = 100 + var9

		var0.Battle.BattleState.GetInstance():GetCommandByName(var0.Battle.BattleSingleDungeonCommand.__name):SetVertifyFail(var10)
	end
end

function var1.AddMonster(arg0, arg1)
	if arg1:GetWaveIndex() ~= arg0._index then
		return
	end

	arg0._monsterList[arg1:GetUniqueID()] = arg1
end

function var1.RemoveMonster(arg0, arg1)
	arg0:onWaveUnitDie(arg1)
end

function var1.doSpawn(arg0, arg1)
	local var0 = var0.Battle.BattleConst.UnitType.ENEMY_UNIT

	if arg1.bossData then
		var0 = var0.Battle.BattleConst.UnitType.BOSS_UNIT
	end

	arg0._spawnFunc(arg1, arg0._index, var0)
end

function var1.spawnTimer(arg0, arg1, arg2, arg3)
	local var0

	local function var1()
		arg3[var0] = nil

		arg0:doSpawn(arg1)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0)
	end

	var0 = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, arg2, var1, true)
	arg3[var0] = true
end

function var1.doAirStrike(arg0, arg1)
	arg0._airFunc(arg1)
end

function var1.airStrikeTimer(arg0, arg1, arg2)
	local var0

	local function var1()
		arg0._airStrikeTimerList[var0] = nil

		arg0:doAirStrike(arg1)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0)
	end

	var0 = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, arg2, var1, true)
	arg0._airStrikeTimerList[var0] = true
end

function var1.doReinforce(arg0, arg1)
	arg0._reinforceKillCount = 0

	if arg0._reinforeceExpire then
		return
	end

	arg1 = arg1 or 0

	for iter0, iter1 in ipairs(arg0._reinforce) do
		iter1.reinforce = true

		local var0 = iter1.delay + arg1

		if var0 <= 0 then
			arg0:doSpawn(iter1)
		else
			arg0:spawnTimer(iter1, var0, arg0._reinforceSpawnTimerList)
		end

		arg1 = arg1 + var1.ASYNC_TIME_GAP
	end
end

function var1.reinforceTimer(arg0, arg1)
	arg0:clearReinforceTimer()

	local function var0()
		arg0:doReinforce()
		arg0:clearReinforceTimer()
	end

	arg0._reinforceTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, arg1, var0, true)
end

function var1.clearReinforceTimer(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._reinforceTimer)

	arg0._reinforceTimer = nil
end

function var1.reinforceDurationTimer(arg0, arg1)
	local function var0()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._reinforceDurationTimer)

		arg0._reinforeceExpire = true
		arg0._reinforceDuration = nil

		arg0:clearReinforceTimer()
		arg0.clearTimerList(arg0._reinforceSpawnTimerList)

		if arg0._spawnCount == 0 then
			arg0:doPass()
		end
	end

	arg0._reinforceDurationTimer = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, arg1, var0, true)
end

function var1.clearReinforceDurationTimer(arg0)
	pg.TimeMgr.GetInstance():RemoveBattleTimer(arg0._reinforceDurationTimer)

	arg0._reinforceDurationTimer = nil
end

function var1.onWaveUnitDie(arg0, arg1)
	local var0 = arg0._monsterList[arg1]

	if var0 == nil then
		return
	end

	local var1

	if var0:IsReinforcement() then
		arg0._reinforceKillCount = arg0._reinforceKillCount + 1
		arg0._reinforceTotalKillCount = arg0._reinforceTotalKillCount + 1

		if arg0._reinforceCount ~= 0 and arg0._reinforceCount == arg0._reinforceKillCount then
			var1 = true
		end
	end

	local function var2(arg0)
		if var1 and arg0 then
			if arg0 == 0 then
				arg0:doReinforce()
			else
				arg0:reinforceTimer(arg0)
			end

			var1 = false
		end
	end

	local var3 = 0
	local var4 = 0

	for iter0, iter1 in pairs(arg0._monsterList) do
		if iter1:IsAlive() == false then
			if not iter1:IsReinforcement() then
				var3 = var3 + 1
			end
		else
			var4 = var4 + 1

			var2(iter1:GetReinforceCastTime())
		end
	end

	if arg0._reinforceDuration ~= 0 and not arg0._reinforeceExpire then
		var2(0)
	end

	if var4 == 0 and var3 >= arg0._spawnCount and arg0._reinforceTotalKillCount >= arg0._reinforceCount and (arg0._reinforceDuration == 0 or arg0._reinforeceExpire) then
		arg0:doPass()
	end
end

function var1.doPass(arg0)
	arg0.clearTimerList(arg0._spawnTimerList)
	arg0.clearTimerList(arg0._reinforceSpawnTimerList)
	arg0:clearReinforceTimer()
	arg0:clearReinforceDurationTimer()
	var0.Battle.BattleDataProxy.GetInstance():KillWaveSummonMonster(arg0._index)
	var1.super.doPass(arg0)
end

function var1.clearTimerList(arg0)
	for iter0, iter1 in pairs(arg0) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter0)
	end
end

function var1.Dispose(arg0)
	arg0.clearTimerList(arg0._airStrikeTimerList)

	arg0._airStrikeTimerList = nil

	arg0.clearTimerList(arg0._spawnTimerList)

	arg0._spawnTimerList = nil

	arg0.clearTimerList(arg0._reinforceSpawnTimerList)

	arg0._reinforceSpawnTimerList = nil

	arg0:clearReinforceTimer()
	arg0:clearReinforceDurationTimer()
	var1.super.Dispose(arg0)
end
