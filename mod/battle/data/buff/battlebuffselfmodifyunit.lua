ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleBuffEvent
local var2 = var0.Battle.BattleConst.BuffEffectType
local var3 = class("BattleBuffSelfModifyUnit", var0.Battle.BattleBuffUnit)

var0.Battle.BattleBuffSelfModifyUnit = var3
var3.__name = "BattleBuffSelfModifyUnit"

function var3.Ctor(arg0, arg1, arg2, arg3, arg4)
	arg0._selfModifyTempData = arg4

	var3.super.Ctor(arg0, arg1, arg2, arg3, arg4)
end

function var3.SetTemplate(arg0)
	arg0._tempData = arg0._selfModifyTempData
end
