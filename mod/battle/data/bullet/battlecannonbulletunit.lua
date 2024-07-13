ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleCannonBulletUnit = class("BattleCannonBulletUnit", var0_0.Battle.BattleBulletUnit)
var0_0.Battle.BattleCannonBulletUnit.__name = "BattleCannonBulletUnit"

local var1_0 = var0_0.Battle.BattleCannonBulletUnit

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var1_0.Hit(arg0_2, arg1_2, arg2_2)
	var1_0.super.Hit(arg0_2, arg1_2, arg2_2)

	arg0_2._pierceCount = arg0_2._pierceCount - 1
end
