ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffNewAI = class("BattleBuffNewAI", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffNewAI.__name = "BattleBuffNewAI"

function var0.Battle.BattleBuffNewAI.Ctor(arg0, arg1)
	var0.Battle.BattleBuffNewAI.super.Ctor(arg0, arg1)
end

function var0.Battle.BattleBuffNewAI.SetArgs(arg0, arg1, arg2)
	arg0._AIOnAttach = arg0._tempData.arg_list.ai_onAttach
	arg0._AIOnRemove = arg0._tempData.arg_list.ai_onRemove
end

function var0.Battle.BattleBuffNewAI.onAttach(arg0, arg1, arg2)
	if arg0._AIOnAttach then
		arg1:SetAI(arg0._AIOnAttach)
	end
end

function var0.Battle.BattleBuffNewAI.onRemove(arg0, arg1, arg2)
	if arg0._AIOnRemove then
		arg1:SetAI(arg0._AIOnRemove)
	end
end
