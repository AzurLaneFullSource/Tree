ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffShiftCLDBox = class("BattleBuffShiftCLDBox", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffShiftCLDBox.__name = "BattleBuffShiftCLDBox"

local var1_0 = var0_0.Battle.BattleBuffShiftCLDBox

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._cldBox = arg0_2._tempData.arg_list.cld_box
	arg0_2._cldOffset = arg0_2._tempData.arg_list.cld_offset or {
		0,
		0,
		0
	}
end

function var1_0.GetEffectType(arg0_3)
	return var1_0.FX_TYPE
end

function var1_0.onAttach(arg0_4, arg1_4, arg2_4)
	arg1_4:ShiftCldComponent(arg0_4._cldBox, arg0_4._cldOffset)
end

function var1_0.onRemove(arg0_5, arg1_5, arg2_5)
	arg1_5:ResetCldComponent()
end
