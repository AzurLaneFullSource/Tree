ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffDeactiveCLDBox = class("BattleBuffDeactiveCLDBox", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffDeactiveCLDBox.__name = "BattleBuffDeactiveCLDBox"

local var1 = var0.Battle.BattleBuffDeactiveCLDBox

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.GetEffectType(arg0)
	return var1.FX_TYPE
end

function var1.onAttach(arg0, arg1, arg2)
	arg1:SetCldBoxImmune(true)
end

function var1.onRemove(arg0, arg1, arg2)
	arg1:SetCldBoxImmune(false)
end
