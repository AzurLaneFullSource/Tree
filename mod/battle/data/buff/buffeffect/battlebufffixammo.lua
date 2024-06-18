ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffFixAmmo = class("BattleBuffFixAmmo", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffFixAmmo.__name = "BattleBuffFixAmmo"

local var1_0 = var0_0.Battle.BattleBuffFixAmmo

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._damageRate = arg0_2._tempData.arg_list.damage_rate
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	arg0_3:updateAmmo(arg1_3, arg0_3._damageRate)
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4)
	arg0_4:updateAmmo(arg1_4)
end

function var1_0.updateAmmo(arg0_5, arg1_5, arg2_5)
	local var0_5 = arg1_5:GetAllWeapon()

	for iter0_5, iter1_5 in ipairs(arg0_5._indexRequire) do
		for iter2_5, iter3_5 in ipairs(var0_5) do
			if iter3_5:GetEquipmentIndex() == iter1_5 then
				iter3_5:FixAmmo(arg2_5)
			end
		end
	end
end
