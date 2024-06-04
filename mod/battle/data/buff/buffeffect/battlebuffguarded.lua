ys = ys or {}

local var0 = ys
local var1 = class("BattleBuffGuarded", var0.Battle.BattleBuffEffect)

var0.Battle.BattleBuffGuarded = var1
var1.__name = "BattleBuffGuarded"

function var1.Ctor(arg0, arg1)
	var1.super.Ctor(arg0, arg1)
end

function var1.SetArgs(arg0, arg1, arg2)
	arg0._casterUID = arg2:GetCaster():GetUniqueID()
end

function var1.onAttach(arg0, arg1, arg2)
	var0.Battle.BattleAttr.AddGuardianID(arg1, arg0._casterUID)
end

function var1.onRemove(arg0, arg1, arg2)
	var0.Battle.BattleAttr.RemoveGuardianID(arg1, arg0._casterUID)
end
