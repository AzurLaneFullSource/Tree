ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst

var0_0.Battle.EngageAntiSubState = class("EngageAntiSubState", var0_0.Battle.IAntiSubState)
var0_0.Battle.EngageAntiSubState.__name = "EngageAntiSubState"

local var2_0 = var0_0.Battle.EngageAntiSubState

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor(arg0_1)
end

function var2_0.OnVigilantEngage(arg0_2, arg1_2)
	return
end

function var2_0.OnMineExplode(arg0_3, arg1_3)
	return
end

function var2_0.OnSubmarinFloat(arg0_4, arg1_4)
	return
end

function var2_0.ToPreLevel(arg0_5, arg1_5)
	arg1_5:OnVigilantState()
end

function var2_0.OnHateChain(arg0_6)
	return
end

function var2_0.GetWeaponUseable(arg0_7)
	return {
		var1_0.OXY_STATE.FLOAT
	}
end

function var2_0.CanDecay(arg0_8)
	return true
end

function var2_0.GetWarnMark(arg0_9)
	return 3
end

function var2_0.GetMeterSpeed(arg0_10)
	return 5
end

function var2_0.DecayDuration(arg0_11)
	return 3
end
