ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleAttr

var0_0.Battle.IdleOxyState = class("IdleOxyState", var0_0.Battle.IOxyState)
var0_0.Battle.IdleOxyState.__name = "IdleOxyState"

local var3_0 = var0_0.Battle.IdleOxyState

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.GetWeaponUseableList(arg0_2)
	return {}
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

function var3_0.IsVisible(arg0_6)
	return false
end

function var3_0.GetBarVisible(arg0_7)
	return true
end

function var3_0.RunMode(arg0_8)
	return false
end

function var3_0.UpdateDive(arg0_9)
	return true
end
