ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffBulletPierce = class("BattleBuffBulletPierce", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffBulletPierce.__name = "BattleBuffBulletPierce"

function var0.Battle.BattleBuffBulletPierce.Ctor(arg0, arg1)
	var0.Battle.BattleBuffBulletPierce.super.Ctor(arg0, arg1)
end

function var0.Battle.BattleBuffBulletPierce.SetArgs(arg0, arg1, arg2)
	arg0._number = arg0._tempData.arg_list.number
	arg0._rate = arg0._tempData.arg_list.rate
	arg0._bulletType = arg0._tempData.arg_list.bulletType or 0
end

function var0.Battle.BattleBuffBulletPierce.onBulletCreate(arg0, arg1, arg2, arg3)
	local var0 = arg3._bullet

	if arg0:IsHappen(tonumber(arg0._rate)) and (arg0._bulletType == var0._tempData.type or arg0._bulletType == 0) then
		var0._pierceCount = arg0._number
	end
end
