ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffSize = class("BattleBuffSize", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffSize.__name = "BattleBuffSize"

function var0_0.Battle.BattleBuffSize.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleBuffSize.super.Ctor(arg0_1, arg1_1)
end

function var0_0.Battle.BattleBuffSize.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._number = arg0_2._tempData.arg_list.number or 1
end

function var0_0.Battle.BattleBuffSize.onAttach(arg0_3, arg1_3, arg2_3)
	local var0_3 = {
		size_ratio = arg0_3._number
	}

	arg1_3:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE, var0_3))
end

function var0_0.Battle.BattleBuffSize.onRemove(arg0_4, arg1_4, arg2_4)
	local var0_4 = {
		size_ratio = 1 / arg0_4._number
	}

	arg1_4:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE, var0_4))
end
