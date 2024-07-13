ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleEnvironmentWave = class("BattleEnvironmentWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleEnvironmentWave.__name = "BattleEnvironmentWave"

local var1_0 = var0_0.Battle.BattleEnvironmentWave

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)

	arg0_1._spawnTimerList = {}
end

function var1_0.SetWaveData(arg0_2, arg1_2)
	var1_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._sapwnData = arg1_2.spawn or {}
	arg0_2._environWarning = arg1_2.warning
end

function var1_0.DoWave(arg0_3)
	var1_0.super.DoWave(arg0_3)

	for iter0_3, iter1_3 in ipairs(arg0_3._sapwnData) do
		if iter1_3.delay and iter1_3.delay > 0 then
			arg0_3:spawnTimer(iter1_3)
		else
			arg0_3:doSpawn(iter1_3)
		end
	end

	if arg0_3._environWarning then
		var0_0.Battle.BattleDataProxy.GetInstance():DispatchWarning(true)
	end
end

function var1_0.doSpawn(arg0_4, arg1_4)
	local var0_4 = var0_0.Battle.BattleDataProxy.GetInstance():SpawnEnvironment(arg1_4)

	local function var1_4()
		arg0_4:doPass()
	end

	var0_4:ConfigCallback(var1_4)
end

function var1_0.doPass(arg0_6)
	if arg0_6._environWarning then
		var0_0.Battle.BattleDataProxy.GetInstance():DispatchWarning(false)
	end
end

function var1_0.spawnTimer(arg0_7, arg1_7)
	local var0_7
	local var1_7 = arg1_7.delay

	local function var2_7()
		arg0_7:doSpawn(arg1_7)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0_7)
	end

	var0_7 = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, var1_7, var2_7, true)
	arg0_7._spawnTimerList[var0_7] = true
end

function var1_0.Dispose(arg0_9)
	for iter0_9, iter1_9 in pairs(arg0_9._spawnTimerList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter0_9)
	end

	arg0_9._spawnTimerList = nil
end
