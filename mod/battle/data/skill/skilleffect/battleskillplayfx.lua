ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = class("BattleSkillPlayFX", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillPlayFX = var2
var2.__name = "BattleSkillPlayFX"

function var2.Ctor(arg0, arg1, arg2)
	var2.super.Ctor(arg0, arg1, arg2)

	arg0._FXID = arg0._tempData.arg_list.effect
end

function var2.DoDataEffect(arg0, arg1, arg2)
	local var0 = arg0.calcCorrdinate(arg0._tempData.arg_list, arg1, arg2)

	var0.Battle.BattleDataProxy.GetInstance():SpawnEffect(arg0._FXID, var0)
end

function var2.DoDataEffectWithoutTarget(arg0, arg1)
	local var0 = arg0.calcCorrdinate(arg0._tempData.arg_list, arg1)

	var0.Battle.BattleDataProxy.GetInstance():SpawnEffect(arg0._FXID, var0)
end
