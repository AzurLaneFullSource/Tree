ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = class("BattleTriggerAOEData", var0.Battle.BattleAOEData)

var0.Battle.BattleTriggerAOEData = var2
var2.__name = "BattleTriggerAOEData"

function var2.Ctor(arg0, arg1, arg2, arg3)
	var2.super.Ctor(arg0, arg1, arg2, arg3)
end

function var2.Settle(arg0)
	if #arg0._cldObjList > 0 then
		arg0.SortCldObjList(arg0._cldObjList)
		arg0._cldComponent:GetCldData().func(arg0._cldObjList)

		arg0._flag = false
	end
end
