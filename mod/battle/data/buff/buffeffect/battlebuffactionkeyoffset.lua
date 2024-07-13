ys = ys or {}

local var0_0 = ys

var0_0.Battle.BattleBuffActionKeyOffset = class("BattleBuffActionKeyOffset", var0_0.Battle.BattleBuffEffect)
var0_0.Battle.BattleBuffActionKeyOffset.__name = "BattleBuffActionKeyOffset"

local var1_0 = var0_0.Battle.BattleBuffActionKeyOffset

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._actionKey = arg0_2._tempData.arg_list.key
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	if arg1_3:ActionKeyOffsetUseable() then
		arg1_3:SetActionKeyOffset(arg0_3._actionKey)
	end
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4)
	if arg1_4:ActionKeyOffsetUseable() then
		arg1_4:SetActionKeyOffset(nil)
	end
end
