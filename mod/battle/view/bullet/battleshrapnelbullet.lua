ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBulletEvent
local var2_0 = class("BattleShrapnelBullet", var0_0.Battle.BattleBullet)

var0_0.Battle.BattleShrapnelBullet = var2_0
var2_0.__name = "BattleShrapnelBullet"

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var2_0.AddBulletEvent(arg0_2)
	var2_0.super.AddBulletEvent(arg0_2)
	arg0_2._bulletData:RegisterEventListener(arg0_2, var1_0.SPLIT, arg0_2.onBulletSplit)
end

function var2_0.RemoveBulletEvent(arg0_3)
	var2_0.super.RemoveBulletEvent(arg0_3)
	arg0_3._bulletData:UnregisterEventListener(arg0_3, var1_0.SPLIT)
end

function var2_0.onBulletSplit(arg0_4, arg1_4)
	arg0_4._bulletHitFunc(arg0_4)
end
