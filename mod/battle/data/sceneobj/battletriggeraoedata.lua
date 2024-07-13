ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = class("BattleTriggerAOEData", var0_0.Battle.BattleAOEData)

var0_0.Battle.BattleTriggerAOEData = var2_0
var2_0.__name = "BattleTriggerAOEData"

function var2_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	var2_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
end

function var2_0.Settle(arg0_2)
	if #arg0_2._cldObjList > 0 then
		arg0_2.SortCldObjList(arg0_2._cldObjList)
		arg0_2._cldComponent:GetCldData().func(arg0_2._cldObjList)

		arg0_2._flag = false
	end
end
