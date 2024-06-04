ys = ys or {}

local var0 = ys

var0.Battle.SuspiciousAntiSubState = class("SuspiciousAntiSubState", var0.Battle.IAntiSubState)
var0.Battle.SuspiciousAntiSubState.__name = "SuspiciousAntiSubState"

local var1 = var0.Battle.SuspiciousAntiSubState

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.OnVigilantEngage(arg0, arg1)
	arg1:OnVigilantState()
end

function var1.OnMineExplode(arg0, arg1)
	arg1:OnVigilantState()
end

function var1.OnSubmarinFloat(arg0, arg1)
	arg1:OnVigilantState()
end

function var1.ToPreLevel(arg0, arg1)
	arg1:OnCalmState()
end

function var1.OnHateChain(arg0, arg1)
	arg1:OnVigilantState()
end

function var1.GetWeaponUseable(arg0)
	return {}
end

function var1.CanDecay(arg0)
	return true
end

function var1.GetWarnMark(arg0)
	return 1
end

function var1.GetMeterSpeed(arg0)
	return 1
end

function var1.DecayDuration(arg0)
	return 1
end
