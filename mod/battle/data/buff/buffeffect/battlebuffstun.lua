ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffStun = class("BattleBuffStun", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffStun.__name = "BattleBuffStun"

local var1 = var0.Battle.BattleBuffStun

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	local var0 = arg0._tempData.arg_list
end

function var1.onAttach(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var1.onUpdate(arg0, arg1, arg2)
	arg0:onTrigger(arg1, arg2)
end

function var1.onTrigger(arg0, arg1, arg2)
	var1.super.onTrigger(arg0, arg1, arg2)
	var0.Battle.BattleAttr.Stun(arg1)
	arg1:UpdateMoveLimit()
end

function var1.onRemove(arg0, arg1, arg2)
	var0.Battle.BattleAttr.CancelStun(arg1)
	arg1:UpdateMoveLimit()
end
