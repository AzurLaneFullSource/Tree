ys = ys or {}

local var0 = ys

var0.Battle.BattleEnvironmentWave = class("BattleEnvironmentWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleEnvironmentWave.__name = "BattleEnvironmentWave"

local var1 = var0.Battle.BattleEnvironmentWave

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)

	arg0._spawnTimerList = {}
end

function var1.SetWaveData(arg0, arg1)
	var1.super.SetWaveData(arg0, arg1)

	arg0._sapwnData = arg1.spawn or {}
	arg0._environWarning = arg1.warning
end

function var1.DoWave(arg0)
	var1.super.DoWave(arg0)

	for iter0, iter1 in ipairs(arg0._sapwnData) do
		if iter1.delay and iter1.delay > 0 then
			arg0:spawnTimer(iter1)
		else
			arg0:doSpawn(iter1)
		end
	end

	if arg0._environWarning then
		var0.Battle.BattleDataProxy.GetInstance():DispatchWarning(true)
	end
end

function var1.doSpawn(arg0, arg1)
	local var0 = var0.Battle.BattleDataProxy.GetInstance():SpawnEnvironment(arg1)

	local function var1()
		arg0:doPass()
	end

	var0:ConfigCallback(var1)
end

function var1.doPass(arg0)
	if arg0._environWarning then
		var0.Battle.BattleDataProxy.GetInstance():DispatchWarning(false)
	end
end

function var1.spawnTimer(arg0, arg1)
	local var0
	local var1 = arg1.delay

	local function var2()
		arg0:doSpawn(arg1)
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0)
	end

	var0 = pg.TimeMgr.GetInstance():AddBattleTimer("", 1, var1, var2, true)
	arg0._spawnTimerList[var0] = true
end

function var1.Dispose(arg0)
	for iter0, iter1 in pairs(arg0._spawnTimerList) do
		pg.TimeMgr.GetInstance():RemoveBattleTimer(iter0)
	end

	arg0._spawnTimerList = nil
end
