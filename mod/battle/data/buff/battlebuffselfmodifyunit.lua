ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleBuffEvent
local var2_0 = var0_0.Battle.BattleConst.BuffEffectType
local var3_0 = class("BattleBuffSelfModifyUnit", var0_0.Battle.BattleBuffUnit)

var0_0.Battle.BattleBuffSelfModifyUnit = var3_0
var3_0.__name = "BattleBuffSelfModifyUnit"

function var3_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	arg0_1._selfModifyTempData = arg4_1

	var3_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
end

function var3_0.SetTemplate(arg0_2)
	arg0_2._tempData = arg0_2._selfModifyTempData
end
