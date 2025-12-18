ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffSize = class("BattleBuffSize", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffSize.__name = "BattleBuffSize"

local var1_0 = var0_0.Battle.BattleBuffSize

function var1_0.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleBuffSize.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._base = arg0_2._tempData.arg_list.number or 1
	arg0_2._hpScale = arg0_2._tempData.arg_list.hp_scale or 0
end

function var1_0.onHPRatioUpdate(arg0_3, arg1_3, arg2_3)
	arg0_3:doScale(arg1_3)
end

function var1_0.onAttach(arg0_4, arg1_4, arg2_4)
	arg0_4:doScale(arg1_4)
end

function var1_0.onRemove(arg0_5, arg1_5, arg2_5)
	local var0_5 = {
		size = initScale
	}

	arg1_5:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE, var0_5))
end

function var1_0.doScale(arg0_6, arg1_6)
	local var0_6 = arg1_6:GetHPRate()
	local var1_6 = arg0_6._base + var0_6 * arg0_6._hpScale
	local var2_6 = {
		size = var1_6
	}

	arg1_6:DispatchEvent(var0_0.Event.New(var0_0.Battle.BattleBuffEvent.BUFF_EFFECT_CHNAGE_SIZE, var2_6))
end
