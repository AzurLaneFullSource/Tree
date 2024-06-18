ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleLabelWave = class("BattleLabelWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleLabelWave.__name = "BattleLabelWave"

local var1_0 = var0_0.Battle.BattleLabelWave

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.SetWaveData(arg0_2, arg1_2)
	var1_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._labelData = {
		op = arg0_2._param.op,
		key = arg0_2._param.key,
		x = arg0_2._param.x,
		y = arg0_2._param.y,
		dialogue = arg0_2._param.dialogue,
		duration = arg0_2._param.duration
	}
end

function var1_0.DoWave(arg0_3)
	var1_0.super.DoWave(arg0_3)
	var0_0.Battle.BattleState.GetInstance():GetProxyByName(var0_0.Battle.BattleDataProxy.__name):DispatchCustomWarning(arg0_3._labelData)
	arg0_3:doPass()
end
