ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffSwitchShader = class("BattleBuffSwitchShader", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffSwitchShader.__name = "BattleBuffSwitchShader"

local var1_0 = var0_0.Battle.BattleBuffSwitchShader

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._shader = arg0_2._tempData.arg_list.shader
	arg0_2._invisible = arg0_2._tempData.arg_list.invisible or 0.7
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3, arg3_3)
	local var0_3 = {
		invisible = arg0_3._invisible
	}

	arg1_3:SwitchShader(arg0_3._shader, nil, var0_3)
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4, arg3_4)
	arg1_4:SwitchShader("COLORED_ALPHA")
end
