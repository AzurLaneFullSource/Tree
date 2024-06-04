ys = ys or {}

local var0 = ys

var0.Battle.BattleSwitchBGMWave = class("BattleSwitchBGMWave", var0.Battle.BattleWaveInfo)
var0.Battle.BattleSwitchBGMWave.__name = "BattleSwitchBGMWave"

local var1 = var0.Battle.BattleSwitchBGMWave

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.SetWaveData(arg0, arg1)
	var1.super.SetWaveData(arg0, arg1)

	arg0._bgmName = arg0._param.bgm
end

function var1.DoWave(arg0)
	var1.super.DoWave(arg0)
	pg.BgmMgr.GetInstance():Push(BattleScene.__cname, arg0._bgmName)
	arg0:doPass()
end
