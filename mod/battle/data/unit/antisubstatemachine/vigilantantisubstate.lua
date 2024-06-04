ys = ys or {}

local var0 = ys

var0.Battle.VigilantAntiSubState = class("VigilantAntiSubState", var0.Battle.IAntiSubState)
var0.Battle.VigilantAntiSubState.__name = "VigilantAntiSubState"

local var1 = var0.Battle.VigilantAntiSubState

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.OnVigilantEngage(arg0, arg1)
	return
end

function var1.OnMineExplode(arg0, arg1)
	return
end

function var1.OnSubmarinFloat(arg0, arg1)
	return
end

function var1.OnHateChain(arg0, arg1)
	arg1:OnEngageState(true)
end

function var1.ToPreLevel(arg0, arg1)
	arg1:OnSuspiciousState()
end

function var1.GetWeaponUseable(arg0)
	return {}
end

function var1.CanDecay(arg0)
	return true
end

function var1.GetWarnMark(arg0)
	return 2
end

function var1.GetMeterSpeed(arg0)
	return 1.3
end

function var1.DecayDuration(arg0)
	return 2
end
