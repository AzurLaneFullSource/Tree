ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleDataFunction
local var2_0 = class("BattleSkillSonar", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillSonar = var2_0
var2_0.__name = "BattleSkillSonar"

function var2_0.Ctor(arg0_1, arg1_1)
	var2_0.super.Ctor(arg0_1, arg1_1, lv)

	arg0_1._range = arg0_1._tempData.arg_list.range
	arg0_1._duration = arg0_1._tempData.arg_list.duration
end

function var2_0.DoDataEffect(arg0_2, arg1_2)
	arg1_2:GetFleetVO():AppendIndieSonar(arg0_2._range, arg0_2._duration)
end

function var2_0.DataEffectWithoutTarget(arg0_3, arg1_3)
	arg1_3:GetFleetVO():AppendIndieSonar(arg0_3._range, arg0_3._duration)
end
