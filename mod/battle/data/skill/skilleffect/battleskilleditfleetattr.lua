ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillEditFleetAttr", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillEditFleetAttr = var1_0
var1_0.__name = "BattleSkillEditFleetAttr"

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._fleetAttrName = arg0_1._tempData.arg_list.attr
	arg0_1._value = arg0_1._tempData.arg_list.value
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	if arg1_2:GetFleetVO() then
		local var0_2 = arg1_2:GetFleetVO():GetFleetAttr()
		local var1_2 = var0_2:GetCurrent(arg0_2._fleetAttrName) + arg0_2._value

		var0_2:SetCurrent(arg0_2._fleetAttrName, var1_2)
	end
end
