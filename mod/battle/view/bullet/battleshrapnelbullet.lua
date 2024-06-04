ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBulletEvent
local var2 = class("BattleShrapnelBullet", var0.Battle.BattleBullet)

var0.Battle.BattleShrapnelBullet = var2
var2.__name = "BattleShrapnelBullet"

function var2.Ctor(arg0, arg1, arg2)
	var2.super.Ctor(arg0, arg1, arg2)
end

function var2.AddBulletEvent(arg0)
	var2.super.AddBulletEvent(arg0)
	arg0._bulletData:RegisterEventListener(arg0, var1.SPLIT, arg0.onBulletSplit)
end

function var2.RemoveBulletEvent(arg0)
	var2.super.RemoveBulletEvent(arg0)
	arg0._bulletData:UnregisterEventListener(arg0, var1.SPLIT)
end

function var2.onBulletSplit(arg0, arg1)
	arg0._bulletHitFunc(arg0)
end
