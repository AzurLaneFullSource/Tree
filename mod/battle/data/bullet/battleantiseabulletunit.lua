ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleAntiSeaBulletUnit = class("BattleAntiSeaBulletUnit", var0_0.Battle.BattleBulletUnit)
var0_0.Battle.BattleAntiSeaBulletUnit.__name = "BattleAntiSeaBulletUnit"

local var1_0 = var0_0.Battle.BattleAntiSeaBulletUnit

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var1_0.Update(arg0_2, arg1_2)
	return
end

function var1_0.IsOutRange(arg0_3)
	return false
end

function var1_0.SetDirectHitUnit(arg0_4, arg1_4)
	arg0_4._directHitUnit = arg1_4
end

function var1_0.GetDirectHitUnit(arg0_5)
	return arg0_5._directHitUnit
end

function var1_0.Dispose(arg0_6)
	arg0_6._directHitUnit = nil

	var1_0.super.Dispose(arg0_6)
end
