ys = ys or {}

local var0 = ys

var0.Battle.BattleDelayWave = class("BattleDelayWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleDelayWave.__name = "BattleDelayWave"

local var1 = var0.Battle.BattleDelayWave

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.SetWaveData(arg0, arg1)
	var1.super.SetWaveData(arg0, arg1)

	arg0._duration = arg0._param.timeout
end

function var1.DoWave(arg0)
	var1.super.DoWave(arg0)

	local var0

	local function var1()
		arg0:doPass()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0)
	end

	var0 = pg.TimeMgr.GetInstance():AddBattleTimer("delayWave", 1, arg0._duration, var1, true)
end
