ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffStun = class("BattleBuffStun", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffStun.__name = "BattleBuffStun"

local var1_0 = var0_0.Battle.BattleBuffStun

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2._tempData.arg_list
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	arg0_3:onTrigger(arg1_3, arg2_3)
end

function var1_0.onUpdate(arg0_4, arg1_4, arg2_4)
	arg0_4:onTrigger(arg1_4, arg2_4)
end

function var1_0.onTrigger(arg0_5, arg1_5, arg2_5)
	var1_0.super.onTrigger(arg0_5, arg1_5, arg2_5)
	var0_0.Battle.BattleAttr.Stun(arg1_5)
	arg1_5:UpdateMoveLimit()
end

function var1_0.onRemove(arg0_6, arg1_6, arg2_6)
	var0_0.Battle.BattleAttr.CancelStun(arg1_6)
	arg1_6:UpdateMoveLimit()
end
