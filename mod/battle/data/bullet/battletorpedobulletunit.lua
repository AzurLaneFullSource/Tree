ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = class("BattleTorpedoBulletUnit", var0.Battle.BattleBulletUnit)

var0.Battle.BattleTorpedoBulletUnit = var2
var2.__name = "BattleTorpedoBulletUnit"

function var2.Ctor(arg0, arg1, arg2)
	var2.super.Ctor(arg0, arg1, arg2)
end

function var2.calcSpeed(arg0)
	local var0 = 1 + var0.Battle.BattleAttr.GetCurrent(arg0, "bulletSpeedRatio")
	local var1 = math.max(0, arg0._velocity + var0.Battle.BattleAttr.GetCurrent(arg0, "torpedoSpeedExtra")) * var0
	local var2 = var1.ConvertBulletSpeed(var1)
	local var3 = math.deg2Rad * arg0._yAngle

	arg0._speed = Vector3(var2 * math.cos(var3), 0, var2 * math.sin(var3))
end

function var2.GetExplodePostion(arg0)
	return arg0._explodePos
end

function var2.SetExplodePosition(arg0, arg1)
	arg0._explodePos = arg1
end

function var2.InitCldComponent(arg0)
	var2.super.InitCldComponent(arg0)
	arg0:ResetCldSurface()
end

function var2.Hit(arg0, arg1, arg2)
	var2.super.Hit(arg0, arg1, arg2)

	arg0._pierceCount = arg0._pierceCount - 1
end
