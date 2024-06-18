ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleJammingWave = class("BattleJammingWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleJammingWave.__name = "BattleJammingWave"

local var1_0 = var0_0.Battle.BattleJammingWave

var1_0.JAMMING_ENGAGE = 1
var1_0.JAMMING_DODGE = 2

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.DoWave(arg0_2)
	var1_0.super.DoWave(arg0_2)

	local var0_2 = var0_0.Battle.BattleDataProxy.GetInstance()
	local var1_2 = var0_2:GetInitData().KizunaJamming

	if var1_2 and table.contains(var1_2, var1_0.JAMMING_ENGAGE) then
		var0_2:KizunaJamming()
	end

	arg0_2:doFinish()
end
