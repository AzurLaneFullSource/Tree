ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffAddTag", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffAddTag = var1_0
var1_0.__name = "BattleBuffAddTag"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._labelTag = arg0_2._tempData.arg_list.tag
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	arg1_3:AddLabelTag(arg0_3._labelTag)
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4)
	arg1_4:RemoveLabelTag(arg0_4._labelTag)
end
