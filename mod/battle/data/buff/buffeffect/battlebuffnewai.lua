ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffNewAI = class("BattleBuffNewAI", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffNewAI.__name = "BattleBuffNewAI"

function var0_0.Battle.BattleBuffNewAI.Ctor(arg0_1, arg1_1)
	var0_0.Battle.BattleBuffNewAI.super.Ctor(arg0_1, arg1_1)
end

function var0_0.Battle.BattleBuffNewAI.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._AIOnAttach = arg0_2._tempData.arg_list.ai_onAttach
	arg0_2._AIOnRemove = arg0_2._tempData.arg_list.ai_onRemove
end

function var0_0.Battle.BattleBuffNewAI.onAttach(arg0_3, arg1_3, arg2_3)
	if arg0_3._AIOnAttach then
		arg1_3:SetAI(arg0_3._AIOnAttach)
	end
end

function var0_0.Battle.BattleBuffNewAI.onRemove(arg0_4, arg1_4, arg2_4)
	if arg0_4._AIOnRemove then
		arg1_4:SetAI(arg0_4._AIOnRemove)
	end
end
