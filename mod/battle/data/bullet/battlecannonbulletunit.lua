ys = ys or {}

local var0 = ys

var0.Battle.BattleCannonBulletUnit = class("BattleCannonBulletUnit", var0.Battle.BattleBulletUnit)
var0.Battle.BattleCannonBulletUnit.__name = "BattleCannonBulletUnit"

local var1 = var0.Battle.BattleCannonBulletUnit

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)
end

function var1.Hit(arg0, arg1, arg2)
	var1.super.Hit(arg0, arg1, arg2)

	arg0._pierceCount = arg0._pierceCount - 1
end
