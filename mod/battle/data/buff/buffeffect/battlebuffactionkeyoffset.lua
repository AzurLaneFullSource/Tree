ys = ys or {}

local var0 = ys

var0.Battle.BattleBuffActionKeyOffset = class("BattleBuffActionKeyOffset", var0.Battle.BattleBuffEffect)
var0.Battle.BattleBuffActionKeyOffset.__name = "BattleBuffActionKeyOffset"

local var1 = var0.Battle.BattleBuffActionKeyOffset

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._actionKey = arg0._tempData.arg_list.key
end

function var1.onAttach(arg0, arg1, arg2)
	if arg1:ActionKeyOffsetUseable() then
		arg1:SetActionKeyOffset(arg0._actionKey)
	end
end

function var1.onRemove(arg0, arg1, arg2)
	if arg1:ActionKeyOffsetUseable() then
		arg1:SetActionKeyOffset(nil)
	end
end
