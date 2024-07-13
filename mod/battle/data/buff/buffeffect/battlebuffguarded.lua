ys = ys or {}

local var0_0 = ys
local var1_0 = class("BattleBuffGuarded", var0_0.Battle.BattleBuffEffect)

var0_0.Battle.BattleBuffGuarded = var1_0
var1_0.__name = "BattleBuffGuarded"

function var1_0.Ctor(arg0_1, arg1_1)
	var1_0.super.Ctor(arg0_1, arg1_1)
end

function var1_0.SetArgs(arg0_2, arg1_2, arg2_2)
	arg0_2._casterUID = arg2_2:GetCaster():GetUniqueID()
end

function var1_0.onAttach(arg0_3, arg1_3, arg2_3)
	var0_0.Battle.BattleAttr.AddGuardianID(arg1_3, arg0_3._casterUID)
end

function var1_0.onRemove(arg0_4, arg1_4, arg2_4)
	var0_0.Battle.BattleAttr.RemoveGuardianID(arg1_4, arg0_4._casterUID)
end
