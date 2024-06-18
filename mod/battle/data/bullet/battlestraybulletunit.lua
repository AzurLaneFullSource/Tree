ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleStrayBulletUnit = class("BattleStrayBulletUnit", var0_0.Battle.BattleBulletUnit)
var0_0.Battle.BattleStrayBulletUnit.__name = "BattleStrayBulletUnit"

local var1_0 = var0_0.Battle.BattleStrayBulletUnit

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var1_0.SetExplodePosition(arg0_2, arg1_2)
	arg0_2._explodePos = arg1_2
end

function var1_0.GetExplodePostion(arg0_3)
	return arg0_3._explodePos
end
