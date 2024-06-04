ys = ys or {}

local var0 = ys

var0.Battle.BattleLabelWave = class("BattleLabelWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleLabelWave.__name = "BattleLabelWave"

local var1 = var0.Battle.BattleLabelWave

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.SetWaveData(arg0, arg1)
	var1.super.SetWaveData(arg0, arg1)

	arg0._labelData = {
		op = arg0._param.op,
		key = arg0._param.key,
		x = arg0._param.x,
		y = arg0._param.y,
		dialogue = arg0._param.dialogue,
		duration = arg0._param.duration
	}
end

function var1.DoWave(arg0)
	var1.super.DoWave(arg0)
	var0.Battle.BattleState.GetInstance():GetProxyByName(var0.Battle.BattleDataProxy.__name):DispatchCustomWarning(arg0._labelData)
	arg0:doPass()
end
