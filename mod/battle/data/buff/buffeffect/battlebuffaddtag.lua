ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffAddTag", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffAddTag = var1
var1.__name = "BattleBuffAddTag"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._labelTag = arg0._tempData.arg_list.tag
end

function var1.onAttach(arg0, arg1, arg2)
	arg1:AddLabelTag(arg0._labelTag)
end

function var1.onRemove(arg0, arg1, arg2)
	arg1:RemoveLabelTag(arg0._labelTag)
end
