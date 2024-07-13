ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleConst

var0_0.Battle.OxyState = class("OxyState")
var0_0.Battle.OxyState.__name = "OxyState"

local var3_0 = var0_0.Battle.OxyState

var3_0.STATE_IDLE = "STATE_IDLE"
var3_0.STATE_DIVE = "STATE_DIVE"
var3_0.STATE_FLOAT = "STATE_FLOAT"
var3_0.STATE_RAID = "STATE_RAID"
var3_0.STATE_RETREAT = "STATE_RETREAT"
var3_0.STATE_FREE_DIVE = "STATE_FREE_DIVE"
var3_0.STATE_FREE_FLOAT = "STATE_FREE_FLOAT"
var3_0.STATE_FREE_BENCH = "STATE_FREE_BENCH"
var3_0.STATE_DEEP_MINE = "STATE_DEEP_MINE"

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._target = arg1_1
	arg0_1._idleState = var0_0.Battle.IdleOxyState.New()
	arg0_1._diveState = var0_0.Battle.DiveOxyState.New()
	arg0_1._floatState = var0_0.Battle.FloatOxyState.New()
	arg0_1._raidState = var0_0.Battle.RaidOxyState.New()
	arg0_1._retreatState = var0_0.Battle.RetreatOxyState.New()
	arg0_1._freeDiveState = var0_0.Battle.FreeDiveOxyState.New()
	arg0_1._freeFloatState = var0_0.Battle.FreeFloatOxyState.New()
	arg0_1._freeBenchState = var0_0.Battle.FreeBenchOxyState.New()
	arg0_1._deepMineState = var0_0.Battle.DeepMineOxyState.New()

	local var0_1 = var0_0.Battle.BattleBuffUnit.New(8520)

	arg0_1._target:AddBuff(var0_1)
	arg0_1:OnIdleState()
end

function var3_0.SetRecycle(arg0_2, arg1_2)
	arg0_2._recycle = arg1_2
end

function var3_0.SetBubbleTemplate(arg0_3, arg1_3, arg2_3)
	arg0_3._bubbleInitial = arg1_3 or 0
	arg0_3._bubbleInterval = arg2_3 or 0
	arg0_3._bubbleTimpStamp = nil
end

function var3_0.UpdateOxygen(arg0_4)
	arg0_4._currentState:DoUpdateOxy(arg0_4)
end

function var3_0.GetNextBubbleStamp(arg0_5)
	if arg0_5._currentState:GetBubbleFlag() then
		if arg0_5._target:GetPosition().x < arg0_5._bubbleInitial and arg0_5._bubbleTimpStamp == nil then
			arg0_5._bubbleTimpStamp = 0
		end

		return arg0_5._bubbleTimpStamp
	else
		return nil
	end
end

function var3_0.SetForceExpose(arg0_6, arg1_6)
	arg0_6._forceExpose = arg1_6

	arg0_6._target:SetForceVisible()
end

function var3_0.GetForceExpose(arg0_7)
	return arg0_7._forceExpose
end

function var3_0.FlashBubbleStamp(arg0_8, arg1_8)
	arg0_8._bubbleTimpStamp = arg1_8 + arg0_8._bubbleInterval
end

function var3_0.ChangeState(arg0_9, arg1_9, arg2_9)
	if arg1_9 == var3_0.STATE_IDLE then
		arg0_9:OnIdleState()
	elseif arg1_9 == var3_0.STATE_DIVE then
		arg0_9:OnDiveState()
	elseif arg1_9 == var3_0.STATE_FLOAT then
		arg0_9:OnFloatState()
	elseif arg1_9 == var3_0.STATE_RAID then
		arg0_9:OnRaidState()
	elseif arg1_9 == var3_0.STATE_RETREAT then
		arg0_9:OnRetreatState()
	elseif arg1_9 == var3_0.STATE_FREE_DIVE then
		arg0_9:OnFreeDiveState()
	elseif arg1_9 == var3_0.STATE_FREE_FLOAT then
		arg0_9:OnFreeFloatState()
	elseif arg1_9 == var3_0.STATE_FREE_BENCH then
		arg0_9:OnFreeBenchState()
	elseif arg1_9 == var3_0.STATE_DEEP_MINE then
		arg0_9:OnDeepMineState()
	else
		assert(false, arg0_9._target.__name .. "'s oxygen state machine, unexcepted state: " .. arg1_9)
	end

	arg0_9._target:GetCldData().Surface = arg0_9._currentState:GetDiveState()
end

function var3_0.OxyConsume(arg0_10)
	arg0_10._target:OxyConsume()
end

function var3_0.OxyRecover(arg0_11, arg1_11)
	arg0_11._target:OxyRecover(arg1_11)
end

function var3_0.OnIdleState(arg0_12)
	arg0_12._currentState = arg0_12._idleState
end

function var3_0.OnDiveState(arg0_13)
	local var0_13 = arg0_13._currentState:UpdateDive()
	local var1_13 = arg0_13._currentState

	arg0_13._currentState = arg0_13._diveState

	arg0_13._currentState:UpdateCldData(arg0_13._target, var1_13)
	arg0_13._target:ChangeWeaponDiveState()
	arg0_13._target:SetCrash(false)
	arg0_13._target:SetAI(var1_0.SUB_DEFAULT_ENGAGE_AI)

	if var0_13 then
		arg0_13._target:SetDiveInvisible(true)
	end

	arg0_13._target:StateChange(var0_0.Battle.UnitState.STATE_DIVE)
	arg0_13._target:TriggerBuff(var2_0.BuffEffectType.ON_SUBMARINE_DIVE, {})
	arg0_13._target:RemoveBuff(var1_0.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF)
	arg0_13._target:AddBuff(var0_0.Battle.BattleBuffUnit.New(var1_0.SUB_DIVE_IMMUNE_IGNITE_BUFF))
end

function var3_0.OnFloatState(arg0_14)
	local var0_14 = arg0_14._currentState

	arg0_14._currentState = arg0_14._floatState

	arg0_14._currentState:UpdateCldData(arg0_14._target, var0_14)
	arg0_14._target:ChangeWeaponDiveState()
	arg0_14._target:SetDiveInvisible(false)
	arg0_14._target:StateChange(var0_0.Battle.UnitState.STATE_MOVE)
	arg0_14._target:RemoveSonarExpose()
	arg0_14._target:PlayFX("qianting_chushui", false)
	arg0_14._target:TriggerBuff(var2_0.BuffEffectType.ON_SUBMARINE_FLOAT, {})
	arg0_14._target:RemoveBuff(var1_0.SUB_DIVE_IMMUNE_IGNITE_BUFF)
	arg0_14._target:AddBuff(var0_0.Battle.BattleBuffUnit.New(var1_0.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF))
end

function var3_0.OnRaidState(arg0_15)
	local var0_15 = arg0_15._currentState:UpdateDive()
	local var1_15 = arg0_15._currentState

	arg0_15._currentState = arg0_15._raidState

	arg0_15._currentState:UpdateCldData(arg0_15._target, var1_15)
	arg0_15._target:ChangeWeaponDiveState()

	if var0_15 then
		arg0_15._target:SetDiveInvisible(true)
	end

	arg0_15._target:SetAI(var1_0.SUB_DEFAULT_STAY_AI)
	arg0_15._target:TriggerBuff(var2_0.BuffEffectType.ON_SUBMARINE_RAID, {})
	arg0_15._target:RemoveBuff(var1_0.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF)
	arg0_15._target:AddBuff(var0_0.Battle.BattleBuffUnit.New(var1_0.SUB_DIVE_IMMUNE_IGNITE_BUFF))
end

function var3_0.OnRetreatState(arg0_16)
	local var0_16 = arg0_16._currentState

	arg0_16._currentState = arg0_16._retreatState

	arg0_16._currentState:UpdateCldData(arg0_16._target, var0_16)
	arg0_16._target:ChangeWeaponDiveState()
	arg0_16._target:SetDiveInvisible(false)
	arg0_16._target:SetAI(var1_0.SUB_DEFAULT_RETREAT_AI)
	arg0_16._target:TriggerBuff(var2_0.BuffEffectType.ON_SUBMARINE_RETREAT, {})
	arg0_16._target:RemoveBuff(var1_0.SUB_DIVE_IMMUNE_IGNITE_BUFF)
	arg0_16._target:AddBuff(var0_0.Battle.BattleBuffUnit.New(var1_0.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF))
end

function var3_0.OnFreeDiveState(arg0_17)
	local var0_17 = arg0_17._currentState

	arg0_17._currentState = arg0_17._freeDiveState

	arg0_17._currentState:UpdateCldData(arg0_17._target, var0_17)
	arg0_17._target:ChangeWeaponDiveState()
	arg0_17._target:SetCrash(false)
	arg0_17._target:SetDiveInvisible(true)
	arg0_17._target:StateChange(var0_0.Battle.UnitState.STATE_DIVE)
	arg0_17._target:PlayFX("qianting_rushui", false)
	arg0_17._target:TriggerBuff(var2_0.BuffEffectType.ON_SUBMARINE_DIVE, {})
	arg0_17._target:RemoveBuff(var1_0.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF)
	arg0_17._target:AddBuff(var0_0.Battle.BattleBuffUnit.New(var1_0.SUB_DIVE_IMMUNE_IGNITE_BUFF))
end

function var3_0.OnFreeFloatState(arg0_18)
	local var0_18 = arg0_18._currentState

	arg0_18._currentState = arg0_18._freeFloatState

	arg0_18._currentState:UpdateCldData(arg0_18._target, var0_18)
	arg0_18._target:ChangeWeaponDiveState()
	arg0_18._target:SetDiveInvisible(false)
	arg0_18._target:StateChange(var0_0.Battle.UnitState.STATE_MOVE)
	arg0_18._target:PlayFX("qianting_chushui", false)
	arg0_18._target:TriggerBuff(var2_0.BuffEffectType.ON_SUBMARINE_FLOAT, {})
	arg0_18._target:RemoveBuff(var1_0.SUB_DIVE_IMMUNE_IGNITE_BUFF)
	arg0_18._target:AddBuff(var0_0.Battle.BattleBuffUnit.New(var1_0.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF))
end

function var3_0.OnFreeBenchState(arg0_19)
	local var0_19 = arg0_19._currentState

	arg0_19._currentState = arg0_19._freeBenchState

	arg0_19._currentState:UpdateCldData(arg0_19._target, var0_19)
	arg0_19._target:ChangeWeaponDiveState()
	arg0_19._target:SetDiveInvisible(false)
	arg0_19._target:StateChange(var0_0.Battle.UnitState.STATE_MOVE)
	arg0_19._target:PlayFX("qianting_chushui", false)
	arg0_19._target:RemoveBuff(var1_0.SUB_DIVE_IMMUNE_IGNITE_BUFF)
	arg0_19._target:AddBuff(var0_0.Battle.BattleBuffUnit.New(var1_0.SUB_FLOAT_DISIMMUNE_IGNITE_BUFF))
end

function var3_0.OnDeepMineState(arg0_20)
	local var0_20 = arg0_20._currentState

	arg0_20._currentState = arg0_20._deepMineState

	arg0_20._currentState:UpdateCldData(arg0_20._target, var0_20)
	arg0_20._target:SetDiveInvisible(false)
	arg0_20._target:ChangeWeaponDiveState()
	arg0_20._target:SetAI(20005)
end

function var3_0.GetRecycle(arg0_21)
	return false
end

function var3_0.GetTarget(arg0_22)
	return arg0_22._target
end

function var3_0.GetCurrentState(arg0_23)
	return arg0_23._currentState
end

function var3_0.GetCurrentStateName(arg0_24)
	return arg0_24._currentState.__name
end

function var3_0.GetWeaponType(arg0_25)
	return arg0_25._currentState:GetWeaponUseableList()
end

function var3_0.GetBarVisible(arg0_26)
	return arg0_26._currentState:GetBarVisible()
end

function var3_0.GetRundMode(arg0_27)
	return arg0_27._currentState:RunMode()
end

function var3_0.GetCurrentDiveState(arg0_28)
	return arg0_28._currentState:GetDiveState()
end
