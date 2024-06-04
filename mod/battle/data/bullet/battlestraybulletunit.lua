ys = ys or {}

local var0 = ys

var0.Battle.BattleStrayBulletUnit = class("BattleStrayBulletUnit", var0.Battle.BattleBulletUnit)
var0.Battle.BattleStrayBulletUnit.__name = "BattleStrayBulletUnit"

local var1 = var0.Battle.BattleStrayBulletUnit

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)
end

function var1.SetExplodePosition(arg0, arg1)
	arg0._explodePos = arg1
end

function var1.GetExplodePostion(arg0)
	return arg0._explodePos
end
