ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleDelayWave = class("BattleDelayWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleDelayWave.__name = "BattleDelayWave"

local var1_0 = var0_0.Battle.BattleDelayWave

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.SetWaveData(arg0_2, arg1_2)
	var1_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._duration = arg0_2._param.timeout
end

function var1_0.DoWave(arg0_3)
	var1_0.super.DoWave(arg0_3)

	local var0_3

	local function var1_3()
		arg0_3:doPass()
		pg.TimeMgr.GetInstance():RemoveBattleTimer(var0_3)
	end

	var0_3 = pg.TimeMgr.GetInstance():AddBattleTimer("delayWave", 1, arg0_3._duration, var1_3, true)
end
