ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffSetBattleUnitType = class("BattleBuffSetBattleUnitType", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffSetBattleUnitType.__name = "BattleBuffSetBattleUnitType"

local var1 = var0.Battle.BattleBuffSetBattleUnitType
local var2 = var0.Battle.BattleAttr

var1.FX_TYPE = var0.Battle.BattleBuffEffect.FX_TTPE_MOD_BATTLE_UNIT_TYPE
var1.ATTR_KEY = "battle_unit_type"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.GetEffectType(arg0)
	return var1.FX_TYPE
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._value = arg0._tempData.arg_list.value
end

function var1.onAttach(arg0, arg1, arg2)
	var2.SetCurrent(arg1, var1.ATTR_KEY, arg0._value)
	arg0.flash(arg1)
end

function var1.onRemove(arg0, arg1, arg2)
	var2.SetCurrent(arg1, var1.ATTR_KEY, nil)
	arg0.flash(arg1)
end

function var1.flash(arg0)
	arg0:UpdateBlindInvisibleBySpectre()
	var0.Battle.BattleDataProxy.GetInstance():SwitchSpectreUnit(arg0)
end
