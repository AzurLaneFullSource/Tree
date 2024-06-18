ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffBulletPierce = class("BattleBuffBulletPierce", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffBulletPierce.__name = "BattleBuffBulletPierce"

function var0_0.Battle.BattleBuffBulletPierce.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleBuffBulletPierce.super.Ctor(arg0_1, arg1_1)
end

function var0_0.Battle.BattleBuffBulletPierce.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._number = arg0_2._tempData.arg_list.number
	arg0_2._rate = arg0_2._tempData.arg_list.rate
	arg0_2._bulletType = arg0_2._tempData.arg_list.bulletType or 0
end

function var0_0.Battle.BattleBuffBulletPierce.onBulletCreate(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = arg3_3._bullet

	if arg0_3:IsHappen(tonumber(arg0_3._rate)) and (arg0_3._bulletType == var0_3._tempData.type or arg0_3._bulletType == 0) then
		var0_3._pierceCount = arg0_3._number
	end
end
