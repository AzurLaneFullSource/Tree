ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst.ActionName

var0_0.Battle.AntiSubState = class("AntiSubState")
var0_0.Battle.AntiSubState.__name = "AntiSubState"

local var2_0 = var0_0.Battle.AntiSubState

function var2_0.Ctor(arg0_1, arg1_1)
	arg0_1._client = arg1_1
	arg0_1._calmState = var0_0.Battle.CalmAntiSubState.New()
	arg0_1._suspiciousState = var0_0.Battle.SuspiciousAntiSubState.New()
	arg0_1._vigilantState = var0_0.Battle.VigilantAntiSubState.New()
	arg0_1._engageState = var0_0.Battle.EngageAntiSubState.New()
	arg0_1._currentState = arg0_1._calmState
	arg0_1._vigilantValue = 0
	arg0_1._vigilantDecayTimeStamp = nil
	arg0_1._decayFlag = false
	arg0_1._engageRage = false
	arg0_1._lastSonarDected = false
end

function var2_0.Update(arg0_2, arg1_2, arg2_2)
	if arg2_2 > 0 and arg0_2:checkDecayRage() then
		arg0_2:OnEngageState()
	end

	if arg1_2 + arg2_2 > 0 then
		arg0_2:resetVigilantDecay()
	end

	local var0_2 = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg0_2._vigilantDecayTimeStamp then
		arg0_2:updateVigilantDecay(var0_2)
	elseif arg0_2._currentState:CanDecay() and arg1_2 + arg2_2 == 0 then
		arg0_2._vigilantDecayTimeStamp = var0_2
	end

	local var1_2 = arg0_2._currentState:GetMeterSpeed()

	if arg0_2._decayFlag then
		var1_2 = math.min(0, var1_2)
	end

	arg0_2._vigilantValue = math.clamp(arg0_2._vigilantValue + var1_2, 0, 100)

	if arg0_2._vigilantValue >= 100 and arg0_2._currentState ~= arg0_2._engageState then
		arg0_2:OnEngageState()
	end
end

function var2_0.updateVigilantDecay(arg0_3, arg1_3)
	if arg1_3 - arg0_3._vigilantDecayTimeStamp >= arg0_3._currentState:DecayDuration() then
		arg0_3._vigilantValue = arg0_3._vigilantValue - 0.01

		arg0_3._currentState:ToPreLevel(arg0_3)

		arg0_3._decayFlag = true
	end
end

function var2_0.resetVigilantDecay(arg0_4)
	arg0_4._vigilantDecayTimeStamp = nil
	arg0_4._decayFlag = false
end

function var2_0.checkDecayRage(arg0_5)
	return arg0_5._vigilantDecayTimeStamp and arg0_5._engageRage
end

function var2_0.HateChain(arg0_6)
	arg0_6:resetVigilantDecay()
	arg0_6._currentState:OnHateChain(arg0_6)
end

function var2_0.InitCheck(arg0_7, arg1_7)
	if arg1_7 > 0 then
		arg0_7:SubmarineFloat()
	end
end

function var2_0.MineExplode(arg0_8)
	if arg0_8:checkDecayRage() then
		arg0_8:OnEngageState()

		return
	end

	arg0_8:resetVigilantDecay()
	arg0_8._currentState:OnMineExplode(arg0_8)
end

function var2_0.SubmarineFloat(arg0_9)
	if arg0_9:checkDecayRage() then
		arg0_9:OnEngageState()

		return
	end

	arg0_9:resetVigilantDecay()
	arg0_9._currentState:OnSubmarinFloat(arg0_9)
end

function var2_0.VigilantAreaEngage(arg0_10)
	arg0_10:resetVigilantDecay()
	arg0_10._currentState:OnVigilantEngage(arg0_10)
end

function var2_0.SonarDetect(arg0_11, arg1_11)
	arg0_11:DispatchSonarCheck()

	local var0_11 = arg1_11 > 0

	if arg0_11._lastSonarDected and var0_11 then
		arg0_11:OnEngageState()
	elseif var0_11 then
		arg0_11:OnVigilantState()
	end

	arg0_11._lastSonarDected = var0_11
end

function var2_0.OnCalmState(arg0_12)
	arg0_12:resetVigilantDecay()

	arg0_12._currentState = arg0_12._calmState
	arg0_12._engageRage = false

	arg0_12:DispatchStateChange()
end

function var2_0.OnSuspiciousState(arg0_13)
	arg0_13:resetVigilantDecay()

	arg0_13._currentState = arg0_13._suspiciousState

	arg0_13:DispatchStateChange()
end

function var2_0.OnVigilantState(arg0_14)
	arg0_14:resetVigilantDecay()

	arg0_14._currentState = arg0_14._vigilantState

	arg0_14:DispatchStateChange()
end

function var2_0.OnEngageState(arg0_15, arg1_15)
	arg0_15:resetVigilantDecay()

	arg0_15._currentState = arg0_15._engageState
	arg0_15._engageRage = true

	arg0_15:DispatchStateChange()

	if not arg1_15 then
		arg0_15:DispatchHateChain()
	end
end

function var2_0.IsWeaponUseable(arg0_16)
	return #arg0_16._currentState:GetWeaponUseable() > 0
end

function var2_0.GetVigilantRate(arg0_17)
	return arg0_17._vigilantValue * 0.01
end

function var2_0.DispatchStateChange(arg0_18)
	local var0_18 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CHANGE_ANTI_SUB_VIGILANCE)

	arg0_18._client:DispatchEvent(var0_18)
end

function var2_0.DispatchSonarCheck(arg0_19)
	local var0_19 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.ANTI_SUB_VIGILANCE_SONAR_CHECK)

	arg0_19._client:DispatchEvent(var0_19)
end

function var2_0.DispatchHateChain(arg0_20)
	local var0_20 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.ANTI_SUB_VIGILANCE_HATE_CHAIN)

	arg0_20._client:DispatchEvent(var0_20)
end

function var2_0.GetVigilantMark(arg0_21)
	return arg0_21._currentState:GetWarnMark()
end
