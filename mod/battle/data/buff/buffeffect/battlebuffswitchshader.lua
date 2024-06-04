ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffSwitchShader = class("BattleBuffSwitchShader", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffSwitchShader.__name = "BattleBuffSwitchShader"

local var1 = var0.Battle.BattleBuffSwitchShader

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._shader = arg0._tempData.arg_list.shader
	arg0._invisible = arg0._tempData.arg_list.invisible or 0.7
end

function var1.onAttach(arg0, arg1, arg2, arg3)
	local var0 = {
		invisible = arg0._invisible
	}

	arg1:SwitchShader(arg0._shader, nil, var0)
end

function var1.onRemove(arg0, arg1, arg2, arg3)
	arg1:SwitchShader("COLORED_ALPHA")
end
