ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffRemoteBone", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffRemoteBone = var1_0
var1_0.__name = "BattleBuffRemoteBone"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._group = arg2_2:GetID()
	arg0_2._targetChoice = arg0_2._tempData.arg_list.bone_target
	arg0_2._bone = arg0_2._tempData.arg_list.bone_name
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	arg1_3:SetRemoteBoundBone(arg0_3._group, arg0_3._bone, arg0_3._targetChoice)
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4)
	arg1_4:RemoveRemoteBoundBone(arg0_4._group)
end
