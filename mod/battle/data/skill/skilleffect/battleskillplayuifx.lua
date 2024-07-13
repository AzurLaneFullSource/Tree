ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = class("BattleSkillPlayUIFX", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillPlayUIFX = var2_0
var2_0.__name = "BattleSkillPlayUIFX"

function var2_0.Ctor(arg0_1, arg1_1, arg2_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._FXID = arg0_1._tempData.arg_list.effect
	arg0_1._scale = arg0_1._tempData.arg_list.scale
	arg0_1._order = arg0_1._tempData.arg_list.order
end

function var2_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2.calcCorrdinate(arg0_2._tempData.arg_list, arg1_2, arg2_2)

	var0_0.Battle.BattleDataProxy.GetInstance():SpawnUIFX(arg0_2._FXID, var0_2, arg0_2._scale, arg0_2._order)
end

function var2_0.DoDataEffectWithoutTarget(arg0_3, arg1_3)
	local var0_3 = arg0_3.calcCorrdinate(arg0_3._tempData.arg_list, arg1_3)

	var0_0.Battle.BattleDataProxy.GetInstance():SpawnUIFX(arg0_3._FXID, var0_3, arg0_3._scale, arg0_3._order)
end
