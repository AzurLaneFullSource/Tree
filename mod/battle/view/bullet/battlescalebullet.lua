ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleScaleBullet = class("BattleScaleBullet", var0_0.Battle.BattleBullet)
var0_0.Battle.BattleScaleBullet.__name = "BattleScaleBullet"

local var1_0 = var0_0.Battle.BattleScaleBullet

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.Update(arg0_2, arg1_2)
	var1_0.super.Update(arg0_2, arg1_2)
	arg0_2:updateModelScale()
end

function var1_0.updateModelScale(arg0_3)
	local var0_3

	var0_3.x, var0_3 = arg0_3._bulletData:GetBoxSize().x * 2, arg0_3._tf.localScale
	arg0_3._tf.localScale = var0_3
end
