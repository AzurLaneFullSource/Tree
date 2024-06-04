ys = ys or {}

local var0 = ys

var0.Battle.BattleClearWave = class("BattleClearWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleClearWave.__name = "BattleClearWave"

local var1 = var0.Battle.BattleClearWave

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.DoWave(arg0)
	var1.super.DoWave(arg0)

	local var0 = var0.Battle.BattleState.GetInstance()
	local var1 = var0:GetProxyByName(var0.Battle.BattleDataProxy.__name)
	local var2 = var0:GetMediatorByName(var0.Battle.BattleSceneMediator.__name)

	var1:KillAllAircraft()
	var1:KillSubmarineByIFF(var0.Battle.BattleConfig.FOE_CODE)
	var2:AllBulletNeutralize()
	arg0:doPass()
end
