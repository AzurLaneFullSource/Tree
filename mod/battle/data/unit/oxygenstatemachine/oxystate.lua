ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleConst

var0.Battle.OxyState = class("OxyState")
var0.Battle.OxyState.__name = "OxyState"

local var3 = var0.Battle.OxyState

var3.STATE_IDLE = "STATE_IDLE"
var3.STATE_DIVE = "STATE_DIVE"
var3.STATE_FLOAT = "STATE_FLOAT"
var3.STATE_RAID = "STATE_RAID"
var3.STATE_RETREAT = "STATE_RETREAT"
var3.STATE_FREE_DIVE = "STATE_FREE_DIVE"
var3.STATE_FREE_FLOAT = "STATE_FREE_FLOAT"
var3.STATE_FREE_BENCH = "STATE_FREE_BENCH"
var3.STATE_DEEP_MINE = "STATE_DEEP_MINE"

function var3.Ctor(arg0, arg1)
	arg0._target = arg1
	arg0._idleState = var0.Battle.IdleOxyState.New()
	arg0._diveState = var0.Battle.DiveOxyState.New()
	arg0._floatState = var0.Battle.FloatOxyState.New()
	arg0._raidState = var0.Battle.RaidOxyState.New()
	arg0._retreatState = var0.Battle.RetreatOxyState.New()
	arg0._freeDiveState = var0.Battle.FreeDiveOxyState.New()
	arg0._freeFloatState = var0.Battle.FreeFloatOxyState.New()
	arg0._freeBenchState = var0.Battle.FreeBenchOxyState.New()
	arg0._deepMineState = var0.Battle.DeepMineOxyState.New()

	local var0 = var0.Battle.BattleBuffUnit.New(8520)

	arg0._target:AddBuff(var0)
	arg0:OnIdleState()
end

function var3.SetRecycle(arg0, arg1)
	arg0._recycle = arg1
end

function var3.SetBubbleTemplate(arg0, arg1, arg2)
	arg0._bubbleInitial = arg1 or 0
	arg0._bubbleInterval = arg2 or 0
	arg0._bubbleTimpStamp = nil
end

function var3.UpdateOxygen(arg0)
	arg0._currentState:DoUpdateOxy(arg0)
end

function var3.GetNextBubbleStamp(arg0)
	if arg0._currentState:GetBubbleFlag() then
		if arg0._target:GetPosition().x < arg0._bubbleInitial and arg0._bubbleTimpStamp == nil then
			arg0._bubbleTimpStamp = 0
		end

		return arg0._bubbleTimpStamp
	else
		return nil
	end
end

function var3.SetForceExpose(arg0, arg1)
	arg0._forceExpose = arg1

	arg0._target:SetForceVisible()
end

function var3.GetForceExpose(arg0)
	return arg0._forceExpose
end

function var3.FlashBubbleStamp(arg0, arg1)
	arg0._bubbleTimpStamp = arg1 + arg0._bubbleInterval
end

function var3.ChangeState(arg0, arg1, arg2)
	if arg1 == var3.STATE_IDLE then
		arg0:OnIdleState()
	elseif arg1 == var3.STATE_DIVE then
		arg0:OnDiveState()
	elseif arg1 == var3.STATE_FLOAT then
		arg0:OnFloatState()
	elseif arg1 == var3.STATE_RAID then
		arg0:OnRaidState()
	elseif arg1 == var3.STATE_RETREAT then
		arg0:OnRetreatState()
	elseif arg1 == var3.STATE_FREE_DIVE then
		arg0:OnFreeDiveState()
	elseif arg1 == var3.STATE_FREE_FLOAT then
		arg0:OnFreeFloatState()
	elseif arg1 == var3.STATE_FREE_BENCH then
		arg0:OnFreeBenchState()
	elseif arg1 == var3.STATE_DEEP_MINE then
		arg0:OnDeepMineState()
	else
		assert(false, arg0._target.__name .. "'s oxygen state machine, unexcepted state: " .. arg1)
	end

	arg0._target:GetCldData().Surface = arg0._currentState:GetDiveState()
end

function var3.OxyConsume(arg0)
	arg0._target:OxyConsume()
end

function var3.OxyRecover(arg0, arg1)
	arg0._target:OxyRecover(arg1)
end

function var3.OnIdleState(arg0)
	arg0._currentState = arg0._idleState
end

function var3.OnDiveState(arg0)
	local var0 = arg0._currentState:UpdateDive()
	local var1 = arg0._currentState

	arg0._currentState = arg0._diveState

	arg0._currentState:UpdateCldData(arg0._target, var1)
	arg0._target:ChangeWeaponDiveState()
	arg0._target:SetCrash(false)
	arg0._target:SetAI(var1.SUB_DEFAULT_ENGAGE_AI)

	if var0 then
		arg0._target:SetDiveInvisible(true)
	end

	arg0._target:StateChange(var0.Battle.UnitState.STATE_DIVE)
	arg0._target:TriggerBuff(var2.BuffEffectType.ON_SUBMARINE_DIVE, {})
	arg0._target:RemoveBuff(var1.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF)
	arg0._target:AddBuff(var0.Battle.BattleBuffUnit.New(var1.SUB_DIVE_IMMUNE_IGNITE_BUFF))
end

function var3.OnFloatState(arg0)
	local var0 = arg0._currentState

	arg0._currentState = arg0._floatState

	arg0._currentState:UpdateCldData(arg0._target, var0)
	arg0._target:ChangeWeaponDiveState()
	arg0._target:SetDiveInvisible(false)
	arg0._target:StateChange(var0.Battle.UnitState.STATE_MOVE)
	arg0._target:RemoveSonarExpose()
	arg0._target:PlayFX("qianting_chushui", false)
	arg0._target:TriggerBuff(var2.BuffEffectType.ON_SUBMARINE_FLOAT, {})
	arg0._target:RemoveBuff(var1.SUB_DIVE_IMMUNE_IGNITE_BUFF)
	arg0._target:AddBuff(var0.Battle.BattleBuffUnit.New(var1.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF))
end

function var3.OnRaidState(arg0)
	local var0 = arg0._currentState:UpdateDive()
	local var1 = arg0._currentState

	arg0._currentState = arg0._raidState

	arg0._currentState:UpdateCldData(arg0._target, var1)
	arg0._target:ChangeWeaponDiveState()

	if var0 then
		arg0._target:SetDiveInvisible(true)
	end

	arg0._target:SetAI(var1.SUB_DEFAULT_STAY_AI)
	arg0._target:TriggerBuff(var2.BuffEffectType.ON_SUBMARINE_RAID, {})
	arg0._target:RemoveBuff(var1.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF)
	arg0._target:AddBuff(var0.Battle.BattleBuffUnit.New(var1.SUB_DIVE_IMMUNE_IGNITE_BUFF))
end

function var3.OnRetreatState(arg0)
	local var0 = arg0._currentState

	arg0._currentState = arg0._retreatState

	arg0._currentState:UpdateCldData(arg0._target, var0)
	arg0._target:ChangeWeaponDiveState()
	arg0._target:SetDiveInvisible(false)
	arg0._target:SetAI(var1.SUB_DEFAULT_RETREAT_AI)
	arg0._target:TriggerBuff(var2.BuffEffectType.ON_SUBMARINE_RETREAT, {})
	arg0._target:RemoveBuff(var1.SUB_DIVE_IMMUNE_IGNITE_BUFF)
	arg0._target:AddBuff(var0.Battle.BattleBuffUnit.New(var1.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF))
end

function var3.OnFreeDiveState(arg0)
	local var0 = arg0._currentState

	arg0._currentState = arg0._freeDiveState

	arg0._currentState:UpdateCldData(arg0._target, var0)
	arg0._target:ChangeWeaponDiveState()
	arg0._target:SetCrash(false)
	arg0._target:SetDiveInvisible(true)
	arg0._target:StateChange(var0.Battle.UnitState.STATE_DIVE)
	arg0._target:PlayFX("qianting_rushui", false)
	arg0._target:TriggerBuff(var2.BuffEffectType.ON_SUBMARINE_DIVE, {})
	arg0._target:RemoveBuff(var1.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF)
	arg0._target:AddBuff(var0.Battle.BattleBuffUnit.New(var1.SUB_DIVE_IMMUNE_IGNITE_BUFF))
end

function var3.OnFreeFloatState(arg0)
	local var0 = arg0._currentState

	arg0._currentState = arg0._freeFloatState

	arg0._currentState:UpdateCldData(arg0._target, var0)
	arg0._target:ChangeWeaponDiveState()
	arg0._target:SetDiveInvisible(false)
	arg0._target:StateChange(var0.Battle.UnitState.STATE_MOVE)
	arg0._target:PlayFX("qianting_chushui", false)
	arg0._target:TriggerBuff(var2.BuffEffectType.ON_SUBMARINE_FLOAT, {})
	arg0._target:RemoveBuff(var1.SUB_DIVE_IMMUNE_IGNITE_BUFF)
	arg0._target:AddBuff(var0.Battle.BattleBuffUnit.New(var1.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF))
end

function var3.OnFreeBenchState(arg0)
	local var0 = arg0._currentState

	arg0._currentState = arg0._freeBenchState

	arg0._currentState:UpdateCldData(arg0._target, var0)
	arg0._target:ChangeWeaponDiveState()
	arg0._target:SetDiveInvisible(false)
	arg0._target:StateChange(var0.Battle.UnitState.STATE_MOVE)
	arg0._target:PlayFX("qianting_chushui", false)
	arg0._target:RemoveBuff(var1.SUB_DIVE_IMMUNE_IGNITE_BUFF)
	arg0._target:AddBuff(var0.Battle.BattleBuffUnit.New(var1.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF))
end

function var3.OnDeepMineState(arg0)
	local var0 = arg0._currentState

	arg0._currentState = arg0._deepMineState

	arg0._currentState:UpdateCldData(arg0._target, var0)
	arg0._target:SetDiveInvisible(false)
	arg0._target:ChangeWeaponDiveState()
	arg0._target:SetAI(20005)
end

function var3.GetRecycle(arg0)
	return false
end

function var3.GetTarget(arg0)
	return arg0._target
end

function var3.GetCurrentState(arg0)
	return arg0._currentState
end

function var3.GetCurrentStateName(arg0)
	return arg0._currentState.__name
end

function var3.GetWeaponType(arg0)
	return arg0._currentState:GetWeaponUseableList()
end

function var3.GetBarVisible(arg0)
	return arg0._currentState:GetBarVisible()
end

function var3.GetRundMode(arg0)
	return arg0._currentState:RunMode()
end

function var3.GetCurrentDiveState(arg0)
	return arg0._currentState:GetDiveState()
end
