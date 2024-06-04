ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleDataFunction
local var2 = class("BattleSkillSonar", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillSonar = var2
var2.__name = "BattleSkillSonar"

function var2.Ctor(arg0, arg1)
	var2.super.Ctor(arg0, arg1, lv)

	arg0._range = arg0._tempData.arg_list.range
	arg0._duration = arg0._tempData.arg_list.duration
end

function var2.DoDataEffect(arg0, arg1)
	arg1:GetFleetVO():AppendIndieSonar(arg0._range, arg0._duration)
end

function var2.DataEffectWithoutTarget(arg0, arg1)
	arg1:GetFleetVO():AppendIndieSonar(arg0._range, arg0._duration)
end
