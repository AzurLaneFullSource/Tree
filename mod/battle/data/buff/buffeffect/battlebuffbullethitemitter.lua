ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffBulletHitEmitter = class("BattleBuffBulletHitEmitter", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffBulletHitEmitter.__name = "BattleBuffBulletHitEmitter"

function var0_0.Battle.BattleBuffBulletHitEmitter.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleBuffBulletHitEmitter.super.Ctor(arg0_1, arg1_1)
end

function var0_0.Battle.BattleBuffBulletHitEmitter.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._number = arg0_2._tempData.arg_list.number
	arg0_2._rate = arg0_2._tempData.arg_list.rate or 10000
	arg0_2._hitEmitterArgs = arg0_2._tempData.arg_list
end

function var0_0.Battle.BattleBuffBulletHitEmitter.onBulletCreate(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg3_3._bullet

	if var0_0.Battle.BattleFormulas.IsHappen(arg0_3._rate) then
		assert(false, "子弹弹射功能已经屏蔽")
	end
end
