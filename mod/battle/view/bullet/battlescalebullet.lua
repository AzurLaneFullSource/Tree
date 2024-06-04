ys = ys or {}

local var0 = ys

var0.Battle.BattleScaleBullet = class("BattleScaleBullet", var0.Battle.BattleBullet)
var0.Battle.BattleScaleBullet.__name = "BattleScaleBullet"

local var1 = var0.Battle.BattleScaleBullet

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.Update(arg0, arg1)
	var1.super.Update(arg0, arg1)
	arg0:updateModelScale()
end

function var1.updateModelScale(arg0)
	local var0

	var0.x, var0 = arg0._bulletData:GetBoxSize().x * 2, arg0._tf.localScale
	arg0._tf.localScale = var0
end
