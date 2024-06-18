ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var0_0.Battle.BattleAttr

var0_0.Battle.DeepMineOxyState = class("DeepMineOxyState", var0_0.Battle.IOxyState)
var0_0.Battle.DeepMineOxyState.__name = "DeepMineOxyState"

local var3_0 = var0_0.Battle.DeepMineOxyState

function var3_0.Ctor(arg0_1)
	var3_0.super.Ctor(arg0_1)
end

function var3_0.UpdateCldData(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg0_2:GetDiveState()

	arg1_2:GetCldData().Surface = var0_2
end

function var3_0.GetWeaponUseableList(arg0_3)
	return {
		var1_0.OXY_STATE.DIVE
	}
end

function var3_0.UpdateCldData(arg0_4, arg1_4)
	return
end

function var3_0.GetDiveState(arg0_5)
	return var1_0.OXY_STATE.DIVE
end

function var3_0.GetBubbleFlag(arg0_6)
	return false
end

function var3_0.IsVisible(arg0_7)
	return false
end

function var3_0.GetBarVisible(arg0_8)
	return true
end

function var3_0.RunMode(arg0_9)
	return false
end
