﻿ys = ys or {}

local var0_0 = ys

var0_0.Battle.SuspiciousAntiSubState = class("SuspiciousAntiSubState", var0_0.Battle.IAntiSubState)
var0_0.Battle.SuspiciousAntiSubState.__name = "SuspiciousAntiSubState"

local var1_0 = var0_0.Battle.SuspiciousAntiSubState

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.OnVigilantEngage(arg0_2, arg1_2)
	arg1_2:OnVigilantState()
end

function var1_0.OnMineExplode(arg0_3, arg1_3)
	arg1_3:OnVigilantState()
end

function var1_0.OnSubmarinFloat(arg0_4, arg1_4)
	arg1_4:OnVigilantState()
end

function var1_0.ToPreLevel(arg0_5, arg1_5)
	arg1_5:OnCalmState()
end

function var1_0.OnHateChain(arg0_6, arg1_6)
	arg1_6:OnVigilantState()
end

function var1_0.GetWeaponUseable(arg0_7)
	return {}
end

function var1_0.CanDecay(arg0_8)
	return true
end

function var1_0.GetWarnMark(arg0_9)
	return 1
end

function var1_0.GetMeterSpeed(arg0_10)
	return 1
end

function var1_0.DecayDuration(arg0_11)
	return 1
end