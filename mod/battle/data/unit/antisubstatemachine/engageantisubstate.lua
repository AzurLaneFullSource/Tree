ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst

var0.Battle.EngageAntiSubState = class("EngageAntiSubState", var0.Battle.IAntiSubState)
var0.Battle.EngageAntiSubState.__name = "EngageAntiSubState"

local var2 = var0.Battle.EngageAntiSubState

function var2.Ctor(arg0)
	var2.super.Ctor(arg0)
end

function var2.OnVigilantEngage(arg0, arg1)
	return
end

function var2.OnMineExplode(arg0, arg1)
	return
end

function var2.OnSubmarinFloat(arg0, arg1)
	return
end

function var2.ToPreLevel(arg0, arg1)
	arg1:OnVigilantState()
end

function var2.OnHateChain(arg0)
	return
end

function var2.GetWeaponUseable(arg0)
	return {
		var1.OXY_STATE.FLOAT
	}
end

function var2.CanDecay(arg0)
	return true
end

function var2.GetWarnMark(arg0)
	return 3
end

function var2.GetMeterSpeed(arg0)
	return 5
end

function var2.DecayDuration(arg0)
	return 3
end
