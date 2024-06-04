ys = ys or {}

local var0 = ys

var0.Battle.BattleJammingWave = class("BattleJammingWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleJammingWave.__name = "BattleJammingWave"

local var1 = var0.Battle.BattleJammingWave

var1.JAMMING_ENGAGE = 1
var1.JAMMING_DODGE = 2

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.DoWave(arg0)
	var1.super.DoWave(arg0)

	local var0 = var0.Battle.BattleDataProxy.GetInstance()
	local var1 = var0:GetInitData().KizunaJamming

	if var1 and table.contains(var1, var1.JAMMING_ENGAGE) then
		var0:KizunaJamming()
	end

	arg0:doFinish()
end
