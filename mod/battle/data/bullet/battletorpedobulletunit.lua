ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = class("BattleTorpedoBulletUnit", var0_0.Battle.BattleBulletUnit)

var0_0.Battle.BattleTorpedoBulletUnit = var2_0
var2_0.__name = "BattleTorpedoBulletUnit"

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var2_0.calcSpeed(arg0_2)
	local var0_2 = 1 + var0_0.Battle.BattleAttr.GetCurrent(arg0_2, "bulletSpeedRatio")
	local var1_2 = math.max(0, arg0_2._velocity + var0_0.Battle.BattleAttr.GetCurrent(arg0_2, "torpedoSpeedExtra")) * var0_2
	local var2_2 = var1_0.ConvertBulletSpeed(var1_2)
	local var3_2 = math.deg2Rad * arg0_2._yAngle

	arg0_2._speed = Vector3(var2_2 * math.cos(var3_2), 0, var2_2 * math.sin(var3_2))
end

function var2_0.GetExplodePostion(arg0_3)
	return arg0_3._explodePos
end

function var2_0.SetExplodePosition(arg0_4, arg1_4)
	arg0_4._explodePos = arg1_4
end

function var2_0.InitCldComponent(arg0_5)
	var2_0.super.InitCldComponent(arg0_5)
	arg0_5:ResetCldSurface()
end

function var2_0.Hit(arg0_6, arg1_6, arg2_6)
	var2_0.super.Hit(arg0_6, arg1_6, arg2_6)

	arg0_6._pierceCount = arg0_6._pierceCount - 1
end
