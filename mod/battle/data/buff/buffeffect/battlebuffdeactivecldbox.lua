ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffDeactiveCLDBox = class("BattleBuffDeactiveCLDBox", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffDeactiveCLDBox.__name = "BattleBuffDeactiveCLDBox"

local var1_0 = var0_0.Battle.BattleBuffDeactiveCLDBox

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.GetEffectType(arg0_2)
	return var1_0.FX_TYPE
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	arg1_3:SetCldBoxImmune(true)
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4)
	arg1_4:SetCldBoxImmune(false)
end
