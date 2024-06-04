ys = ys or {}

local var0 = ys

var0.Battle.BattleAntiAirBulletUnit = class("BattleAntiAirBulletUnit", var0.Battle.BattleBulletUnit)
var0.Battle.BattleAntiAirBulletUnit.__name = "BattleAntiAirBulletUnit"

local var1 = var0.Battle.BattleAntiAirBulletUnit

function var1.Ctor(arg0, arg1, arg2)
	var0.Battle.BattleAntiAirBulletUnit.super.Ctor(arg0, arg1, arg2)
end

function var1.Update(arg0, arg1)
	return
end

function var1.IsOutRange(arg0)
	return false
end

function var1.SetDirectHitUnit(arg0, arg1)
	arg0._directHitUnit = arg1
end

function var1.GetDirectHitUnit(arg0)
	return arg0._directHitUnit
end

function var1.Dispose(arg0)
	arg0._directHitUnit = nil

	var1.super.Dispose(arg0)
end
