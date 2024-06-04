ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var0.Battle.BattleAttr

var0.Battle.DeepMineOxyState = class("DeepMineOxyState", var0.Battle.IOxyState)
var0.Battle.DeepMineOxyState.__name = "DeepMineOxyState"

local var3 = var0.Battle.DeepMineOxyState

function var3.Ctor(arg0)
	var3.super.Ctor(arg0)
end

function var3.UpdateCldData(arg0, arg1, arg2)
	local var0 = arg0:GetDiveState()

	arg1:GetCldData().Surface = var0
end

function var3.GetWeaponUseableList(arg0)
	return {
		var1.OXY_STATE.DIVE
	}
end

function var3.UpdateCldData(arg0, arg1)
	return
end

function var3.GetDiveState(arg0)
	return var1.OXY_STATE.DIVE
end

function var3.GetBubbleFlag(arg0)
	return false
end

function var3.IsVisible(arg0)
	return false
end

function var3.GetBarVisible(arg0)
	return true
end

function var3.RunMode(arg0)
	return false
end
