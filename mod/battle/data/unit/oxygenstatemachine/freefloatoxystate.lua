ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleAttr

var0_0.Battle.FreeFloatOxyState = class("FreeFloatOxyState", var0_0.Battle.IOxyState)
var0_0.Battle.FreeFloatOxyState.__name = "FreeFloatOxyState"

local var3_0 = var0_0.Battle.FreeFloatOxyState

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.GetWeaponUseableList(arg0_2)
	return {
		var1_0.OXY_STATE.DIVE,
		var1_0.OXY_STATE.FLOAT
	}
end

function var3_0.UpdateCldData(arg0_3, arg1_3, arg2_3)
	local var0_3 = arg2_3:GetDiveState()
	local var1_3 = arg0_3:GetDiveState()

	arg1_3:GetCldData().Surface = var1_3

	if var0_3 ~= var1_3 then
		var2_0.UnitCldEnable(arg1_3)
	end
end

function var3_0.GetDiveState(arg0_4)
	return var1_0.OXY_STATE.FLOAT
end

function var3_0.GetBubbleFlag(arg0_5)
	return false
end

function var3_0.DoUpdateOxy(arg0_6, arg1_6)
	arg1_6:OxyRecover(var0_0.Battle.OxyState.STATE_FREE_FLOAT)
end

function var3_0.IsVisible(arg0_7)
	return true
end

function var3_0.GetBarVisible(arg0_8)
	return true
end

function var3_0.RunMode(arg0_9)
	return true
end
