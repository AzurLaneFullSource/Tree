ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffFixAmmo = class("BattleBuffFixAmmo", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffFixAmmo.__name = "BattleBuffFixAmmo"

local var1 = var0.Battle.BattleBuffFixAmmo

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._damageRate = arg0._tempData.arg_list.damage_rate
end

function var1.onAttach(arg0, arg1, arg2)
	arg0:updateAmmo(arg1, arg0._damageRate)
end

function var1.onRemove(arg0, arg1, arg2)
	arg0:updateAmmo(arg1)
end

function var1.updateAmmo(arg0, arg1, arg2)
	local var0 = arg1:GetAllWeapon()

	for iter0, iter1 in ipairs(arg0._indexRequire) do
		for iter2, iter3 in ipairs(var0) do
			if iter3:GetEquipmentIndex() == iter1 then
				iter3:FixAmmo(arg2)
			end
		end
	end
end
