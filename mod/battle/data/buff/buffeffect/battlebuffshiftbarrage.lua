ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffShiftBarrage = class("BattleBuffShiftBarrage", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffShiftBarrage.__name = "BattleBuffShiftBarrage"

local var1 = var0.Battle.BattleBuffShiftBarrage

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._barrageID = arg0._tempData.arg_list.barrage_id
end

function var1.onAttach(arg0, arg1, arg2)
	arg0:shiftBarrage(arg1, arg0._barrageID)
end

function var1.onRemove(arg0, arg1, arg2)
	arg0:shiftBarrage(arg1)
end

function var1.shiftBarrage(arg0, arg1, arg2)
	local var0 = arg1:GetAllWeapon()

	for iter0, iter1 in ipairs(arg0._indexRequire) do
		for iter2, iter3 in ipairs(var0) do
			if iter3:GetEquipmentIndex() == iter1 then
				if arg2 then
					iter3:ShiftBarrage(arg2)
				else
					iter3:RevertBarrage()
				end
			end
		end
	end
end
