ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffRemoteBone", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffRemoteBone = var1
var1.__name = "BattleBuffRemoteBone"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._group = arg2:GetID()
	arg0._targetChoice = arg0._tempData.arg_list.bone_target
	arg0._bone = arg0._tempData.arg_list.bone_name
end

function var1.onAttach(arg0, arg1, arg2)
	arg1:SetRemoteBoundBone(arg0._group, arg0._bone, arg0._targetChoice)
end

function var1.onRemove(arg0, arg1, arg2)
	arg1:RemoveRemoteBoundBone(arg0._group)
end
