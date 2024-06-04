ys = ys or {}

local var0 = ys
local var1 = class("BattleSkillEditTag", var0.Battle.BattleSkillEffect)

var0.Battle.BattleSkillEditTag = var1
var1.__name = "BattleSkillEditTag"
var1.TAG_OPERATION_APPEND = 1
var1.TAG_OPERATION_REMOVE = -1

function var1.Ctor(arg0, arg1, arg2)
	var1.super.Ctor(arg0, arg1, arg2)

	arg0._tag = arg0._tempData.arg_list.tag
	arg0._op = arg0._tempData.arg_list.operation
end

function var1.DoDataEffect(arg0, arg1, arg2)
	if arg0._op == var1.TAG_OPERATION_APPEND then
		arg2:AddLabelTag(arg0._tag)
	elseif arg0._op == var1.TAG_OPERATION_REMOVE then
		arg2:RemoveLabelTag(arg0._tag)
	end
end
