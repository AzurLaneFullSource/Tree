ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleSkillEditTag", var0_0.Battle.BattleSkillEffect)

var0_0.Battle.BattleSkillEditTag = var1_0
var1_0.__name = "BattleSkillEditTag"
var1_0.TAG_OPERATION_APPEND = 1
var1_0.TAG_OPERATION_REMOVE = -1

function var1_0.Ctor(arg0_1, arg1_1, arg2_1)
	var1_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1._tag = arg0_1._tempData.arg_list.tag
	arg0_1._op = arg0_1._tempData.arg_list.operation
end

function var1_0.DoDataEffect(arg0_2, arg1_2, arg2_2)
	if arg0_2._op == var1_0.TAG_OPERATION_APPEND then
		arg2_2:AddLabelTag(arg0_2._tag)
	elseif arg0_2._op == var1_0.TAG_OPERATION_REMOVE then
		arg2_2:RemoveLabelTag(arg0_2._tag)
	end
end
