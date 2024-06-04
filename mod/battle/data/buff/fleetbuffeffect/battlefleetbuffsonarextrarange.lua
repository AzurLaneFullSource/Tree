ys = ys or {}

local var0 = ys

var0.Battle.BattleFleetBuffSonarExtraRange = class("BattleFleetBuffSonarExtraRange", var0.Battle.BattleFleetBuffEffect)
var0.Battle.BattleFleetBuffSonarExtraRange.__name = "BattleFleetBuffSonarExtraRange"

local var1 = var0.Battle.BattleFleetBuffSonarExtraRange

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._extraRange = arg0._tempData.arg_list.range
end

function var1.onAttach(arg0, arg1, arg2)
	arg0:appendRange(arg1)
end

function var1.onStack(arg0, arg1, arg2)
	arg0:appendRange(arg1)
end

function var1.appendRange(arg0, arg1)
	arg1:GetFleetSonar():AppendExtraSkillRange(arg0._extraRange)
end
