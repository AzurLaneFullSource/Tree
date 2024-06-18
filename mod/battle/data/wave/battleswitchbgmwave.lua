ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleSwitchBGMWave = class("BattleSwitchBGMWave", var0_0.Battle.BattleWaveInfo)
var0_0.Battle.BattleSwitchBGMWave.__name = "BattleSwitchBGMWave"

local var1_0 = var0_0.Battle.BattleSwitchBGMWave

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.SetWaveData(arg0_2, arg1_2)
	var1_0.super.SetWaveData(arg0_2, arg1_2)

	arg0_2._bgmName = arg0_2._param.bgm
end

function var1_0.DoWave(arg0_3)
	var1_0.super.DoWave(arg0_3)
	pg.BgmMgr.GetInstance():Push(BattleScene.__cname, arg0_3._bgmName)
	arg0_3:doPass()
end
