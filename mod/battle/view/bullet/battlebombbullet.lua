ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBulletEvent
local var2_0 = var0_0.Battle.BattleResourceManager
local var3_0 = var0_0.Battle.BattleConfig
local var4_0 = class("BattleBombBullet", var0_0.Battle.BattleBullet)

var0_0.Battle.BattleBombBullet = var4_0
var4_0.__name = "BattleBombBullet"

function var4_0.Ctor(arg0_1)
	var4_0.super.Ctor(arg0_1)
end

function var4_0.Dispose(arg0_2)
	if arg0_2._alert then
		arg0_2._alert:Dispose()
	end

	var4_0.super.Dispose(arg0_2)
end

function var4_0.AddBulletEvent(arg0_3)
	arg0_3._bulletData:RegisterEventListener(arg0_3, var1_0.EXPLODE, arg0_3.onBulletExplode)
end

function var4_0.RemoveBulletEvent(arg0_4)
	arg0_4._bulletData:UnregisterEventListener(arg0_4, var1_0.EXPLODE)
end

function var4_0.onBulletExplode(arg0_5, arg1_5)
	arg0_5._bulletHitFunc(arg0_5)
end

function var4_0.UpdatePosition(arg0_6)
	local var0_6 = Vector3.Lerp(arg0_6._tf.localPosition, arg0_6:GetPosition(), var3_0.BulletMotionRate)

	arg0_6._tf.localPosition = var0_6

	arg0_6._cacheTFPos:Set(var0_6.x, var0_6.y, var0_6.z)
end
