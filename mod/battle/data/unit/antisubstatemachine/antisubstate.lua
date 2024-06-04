ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst.ActionName

var0.Battle.AntiSubState = class("AntiSubState")
var0.Battle.AntiSubState.__name = "AntiSubState"

local var2 = var0.Battle.AntiSubState

function var2.Ctor(arg0, arg1)
	arg0._client = arg1
	arg0._calmState = var0.Battle.CalmAntiSubState.New()
	arg0._suspiciousState = var0.Battle.SuspiciousAntiSubState.New()
	arg0._vigilantState = var0.Battle.VigilantAntiSubState.New()
	arg0._engageState = var0.Battle.EngageAntiSubState.New()
	arg0._currentState = arg0._calmState
	arg0._vigilantValue = 0
	arg0._vigilantDecayTimeStamp = nil
	arg0._decayFlag = false
	arg0._engageRage = false
	arg0._lastSonarDected = false
end

function var2.Update(arg0, arg1, arg2)
	if arg2 > 0 and arg0:checkDecayRage() then
		arg0:OnEngageState()
	end

	if arg1 + arg2 > 0 then
		arg0:resetVigilantDecay()
	end

	local var0 = pg.TimeMgr.GetInstance():GetCombatTime()

	if arg0._vigilantDecayTimeStamp then
		arg0:updateVigilantDecay(var0)
	elseif arg0._currentState:CanDecay() and arg1 + arg2 == 0 then
		arg0._vigilantDecayTimeStamp = var0
	end

	local var1 = arg0._currentState:GetMeterSpeed()

	if arg0._decayFlag then
		var1 = math.min(0, var1)
	end

	arg0._vigilantValue = math.clamp(arg0._vigilantValue + var1, 0, 100)

	if arg0._vigilantValue >= 100 and arg0._currentState ~= arg0._engageState then
		arg0:OnEngageState()
	end
end

function var2.updateVigilantDecay(arg0, arg1)
	if arg1 - arg0._vigilantDecayTimeStamp >= arg0._currentState:DecayDuration() then
		arg0._vigilantValue = arg0._vigilantValue - 0.01

		arg0._currentState:ToPreLevel(arg0)

		arg0._decayFlag = true
	end
end

function var2.resetVigilantDecay(arg0)
	arg0._vigilantDecayTimeStamp = nil
	arg0._decayFlag = false
end

function var2.checkDecayRage(arg0)
	return arg0._vigilantDecayTimeStamp and arg0._engageRage
end

function var2.HateChain(arg0)
	arg0:resetVigilantDecay()
	arg0._currentState:OnHateChain(arg0)
end

function var2.InitCheck(arg0, arg1)
	if arg1 > 0 then
		arg0:SubmarineFloat()
	end
end

function var2.MineExplode(arg0)
	if arg0:checkDecayRage() then
		arg0:OnEngageState()

		return
	end

	arg0:resetVigilantDecay()
	arg0._currentState:OnMineExplode(arg0)
end

function var2.SubmarineFloat(arg0)
	if arg0:checkDecayRage() then
		arg0:OnEngageState()

		return
	end

	arg0:resetVigilantDecay()
	arg0._currentState:OnSubmarinFloat(arg0)
end

function var2.VigilantAreaEngage(arg0)
	arg0:resetVigilantDecay()
	arg0._currentState:OnVigilantEngage(arg0)
end

function var2.SonarDetect(arg0, arg1)
	arg0:DispatchSonarCheck()

	local var0 = arg1 > 0

	if arg0._lastSonarDected and var0 then
		arg0:OnEngageState()
	elseif var0 then
		arg0:OnVigilantState()
	end

	arg0._lastSonarDected = var0
end

function var2.OnCalmState(arg0)
	arg0:resetVigilantDecay()

	arg0._currentState = arg0._calmState
	arg0._engageRage = false

	arg0:DispatchStateChange()
end

function var2.OnSuspiciousState(arg0)
	arg0:resetVigilantDecay()

	arg0._currentState = arg0._suspiciousState

	arg0:DispatchStateChange()
end

function var2.OnVigilantState(arg0)
	arg0:resetVigilantDecay()

	arg0._currentState = arg0._vigilantState

	arg0:DispatchStateChange()
end

function var2.OnEngageState(arg0, arg1)
	arg0:resetVigilantDecay()

	arg0._currentState = arg0._engageState
	arg0._engageRage = true

	arg0:DispatchStateChange()

	if not arg1 then
		arg0:DispatchHateChain()
	end
end

function var2.IsWeaponUseable(arg0)
	return #arg0._currentState:GetWeaponUseable() > 0
end

function var2.GetVigilantRate(arg0)
	return arg0._vigilantValue * 0.01
end

function var2.DispatchStateChange(arg0)
	local var0 = var0.Event.New(var0.Battle.BattleUnitEvent.CHANGE_ANTI_SUB_VIGILANCE)

	arg0._client:DispatchEvent(var0)
end

function var2.DispatchSonarCheck(arg0)
	local var0 = var0.Event.New(var0.Battle.BattleUnitEvent.ANTI_SUB_VIGILANCE_SONAR_CHECK)

	arg0._client:DispatchEvent(var0)
end

function var2.DispatchHateChain(arg0)
	local var0 = var0.Event.New(var0.Battle.BattleUnitEvent.ANTI_SUB_VIGILANCE_HATE_CHAIN)

	arg0._client:DispatchEvent(var0)
end

function var2.GetVigilantMark(arg0)
	return arg0._currentState:GetWarnMark()
end
