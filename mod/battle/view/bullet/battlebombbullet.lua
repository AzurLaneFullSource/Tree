ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBulletEvent
local var2 = var0.Battle.BattleResourceManager
local var3 = var0.Battle.BattleConfig
local var4 = class("BattleBombBullet", var0.Battle.BattleBullet)

var0.Battle.BattleBombBullet = var4
var4.__name = "BattleBombBullet"

function var4.Ctor(arg0)
	var4.super.Ctor(arg0)
end

function var4.Dispose(arg0)
	if arg0._alert then
		arg0._alert:Dispose()
	end

	var4.super.Dispose(arg0)
end

function var4.AddBulletEvent(arg0)
	arg0._bulletData:RegisterEventListener(arg0, var1.EXPLODE, arg0.onBulletExplode)
end

function var4.RemoveBulletEvent(arg0)
	arg0._bulletData:UnregisterEventListener(arg0, var1.EXPLODE)
end

function var4.onBulletExplode(arg0, arg1)
	arg0._bulletHitFunc(arg0)
end

function var4.UpdatePosition(arg0)
	local var0 = Vector3.Lerp(arg0._tf.localPosition, arg0:GetPosition(), var3.BulletMotionRate)

	arg0._tf.localPosition = var0

	arg0._cacheTFPos:Set(var0.x, var0.y, var0.z)
end
