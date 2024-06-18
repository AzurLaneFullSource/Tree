ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffSetBattleUnitType = class("BattleBuffSetBattleUnitType", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffSetBattleUnitType.__name = "BattleBuffSetBattleUnitType"

local var1_0 = var0_0.Battle.BattleBuffSetBattleUnitType
local var2_0 = var0_0.Battle.BattleAttr

var1_0.FX_TYPE = var0_0.Battle.BattleBuffEffect.FX_TTPE_MOD_BATTLE_UNIT_TYPE
var1_0.ATTR_KEY = "battle_unit_type"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectType(arg0_2)
	return var1_0.FX_TYPE
end

function var1_0.SetArgs(arg0_3, arg1_3, arg2_3)
	arg0_3._value = arg0_3._tempData.arg_list.value
end

function var1_0.onAttach(arg0_4, arg1_4, arg2_4)
	var2_0.SetCurrent(arg1_4, var1_0.ATTR_KEY, arg0_4._value)
	arg0_4.flash(arg1_4)
end

function var1_0.onRemove(arg0_5, arg1_5, arg2_5)
	var2_0.SetCurrent(arg1_5, var1_0.ATTR_KEY, nil)
	arg0_5.flash(arg1_5)
end

function var1_0.flash(arg0_6)
	arg0_6:UpdateBlindInvisibleBySpectre()
	var0_0.Battle.BattleDataProxy.GetInstance():SwitchSpectreUnit(arg0_6)
end
