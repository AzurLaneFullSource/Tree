ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleClearWave = class("BattleClearWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleClearWave.__name = "BattleClearWave"

local var1_0 = var0_0.Battle.BattleClearWave

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.DoWave(arg0_2)
	var1_0.super.DoWave(arg0_2)

	local var0_2 = var0_0.Battle.BattleState.GetInstance()
	local var1_2 = var0_2:GetProxyByName(var0_0.Battle.BattleDataProxy.__name)
	local var2_2 = var0_2:GetMediatorByName(var0_0.Battle.BattleSceneMediator.__name)

	var1_2:KillAllAircraft()
	var1_2:KillSubmarineByIFF(var0_0.Battle.BattleConfig.FOE_CODE)
	var2_2:AllBulletNeutralize()
	arg0_2:doPass()
end
