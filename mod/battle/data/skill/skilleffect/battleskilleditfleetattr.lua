ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillEditFleetAttr", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillEditFleetAttr = var1
var1.__name = "BattleSkillEditFleetAttr"

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)

	arg0._fleetAttrName = arg0._tempData.arg_list.attr
	arg0._value = arg0._tempData.arg_list.value
end

function var1.DoDataEffect(arg0, arg1, arg2)
	if arg1:GetFleetVO() then
		local var0 = arg1:GetFleetVO():GetFleetAttr()
		local var1 = var0:GetCurrent(arg0._fleetAttrName) + arg0._value

		var0:SetCurrent(arg0._fleetAttrName, var1)
	end
end
