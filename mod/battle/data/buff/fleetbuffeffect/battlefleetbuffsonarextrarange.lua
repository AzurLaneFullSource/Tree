ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleFleetBuffSonarExtraRange = class("BattleFleetBuffSonarExtraRange", var0_0.Battle.BattleFleetBuffEffect)
var0_0.Battle.BattleFleetBuffSonarExtraRange.__name = "BattleFleetBuffSonarExtraRange"

local var1_0 = var0_0.Battle.BattleFleetBuffSonarExtraRange

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._extraRange = arg0_2._tempData.arg_list.range
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	arg0_3:appendRange(arg1_3)
end

function var1_0.onStack(arg0_4, arg1_4, arg2_4)
	arg0_4:appendRange(arg1_4)
end

function var1_0.appendRange(arg0_5, arg1_5)
	arg1_5:GetFleetSonar():AppendExtraSkillRange(arg0_5._extraRange)
end
