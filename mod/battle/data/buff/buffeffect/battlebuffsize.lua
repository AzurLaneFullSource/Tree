ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffSize = class("BattleBuffSize", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffSize.__name = "BattleBuffSize"

function var0.Battle.BattleBuffSize.Ctor(arg0, arg1)
	var0.Battle.BattleBuffSize.super.Ctor(arg0, arg1)
end

function var0.Battle.BattleBuffSize.SetArgs(arg0, arg1, arg2)
	arg0._number = arg0._tempData.arg_list.number or 1
end

function var0.Battle.BattleBuffSize.onAttach(arg0, arg1, arg2)
	local var0 = {
		size_ratio = arg0._number
	}

	arg1:DispatchEvent(var0.Event.New(var0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE, var0))
end

function var0.Battle.BattleBuffSize.onRemove(arg0, arg1, arg2)
	local var0 = {
		size_ratio = 1 / arg0._number
	}

	arg1:DispatchEvent(var0.Event.New(var0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE, var0))
end
