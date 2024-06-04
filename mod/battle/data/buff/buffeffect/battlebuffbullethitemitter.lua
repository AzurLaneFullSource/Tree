ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffBulletHitEmitter = class("BattleBuffBulletHitEmitter", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffBulletHitEmitter.__name = "BattleBuffBulletHitEmitter"

function var0.Battle.BattleBuffBulletHitEmitter.Ctor(arg0, arg1)
	var0.Battle.BattleBuffBulletHitEmitter.super.Ctor(arg0, arg1)
end

function var0.Battle.BattleBuffBulletHitEmitter.SetArgs(arg0, arg1, arg2)
	arg0._number = arg0._tempData.arg_list.number
	arg0._rate = arg0._tempData.arg_list.rate or 10000
	arg0._hitEmitterArgs = arg0._tempData.arg_list
end

function var0.Battle.BattleBuffBulletHitEmitter.onBulletCreate(arg0, arg1, arg2, arg3)
	local var0 = arg3._bullet

	if var0.Battle.BattleFormulas.IsHappen(arg0._rate) then
		assert(false, "子弹弹射功能已经屏蔽")
	end
end
