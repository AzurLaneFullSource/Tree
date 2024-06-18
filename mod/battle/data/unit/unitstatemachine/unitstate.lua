ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst
local var2_0 = var1_0.ActionName

var0_0.Battle.UnitState = class("UnitState")
var0_0.Battle.UnitState.__name = "UnitState"
var0_0.Battle.UnitState.STATE_IDLE = "STATE_IDLE"
var0_0.Battle.UnitState.STATE_MOVE = "STATE_MOVE"
var0_0.Battle.UnitState.STATE_ATTACK = "STATE_ATTACK"
var0_0.Battle.UnitState.STATE_ATTACKLEFT = "STATE_ATTACKLEFT"
var0_0.Battle.UnitState.STATE_DEAD = "STATE_DEAD"
var0_0.Battle.UnitState.STATE_MOVELEFT = "STATE_MOVELEFT"
var0_0.Battle.UnitState.STATE_SKILL = "STATE_SKILL"
var0_0.Battle.UnitState.STATE_VICTORY = "STATE_VICTORY"
var0_0.Battle.UnitState.STATE_STAND = "STATE_STAND"
var0_0.Battle.UnitState.STATE_INTERRUPT = "STATE_INTERRUPT"
var0_0.Battle.UnitState.STATE_SKILL_START = "STATE_SKILL_START"
var0_0.Battle.UnitState.STATE_SKILL_END = "STATE_SKILL_END"
var0_0.Battle.UnitState.STATE_DIVING = "STATE_DIVING"
var0_0.Battle.UnitState.STATE_DIVE = "STATE_DIVE"
var0_0.Battle.UnitState.STATE_DIVELEFT = "STATE_DIVELEFT"
var0_0.Battle.UnitState.STATE_RAID = "STATE_RAID"
var0_0.Battle.UnitState.STATE_RAIDLEFT = "STATE_RAIDLEFT"

function var0_0.Battle.UnitState.Ctor(arg0_1, arg1_1)
	arg0_1._target = arg1_1
	arg0_1._idleState = var0_0.Battle.IdleState.New()
	arg0_1._moveState = var0_0.Battle.MoveState.New()
	arg0_1._attackState = var0_0.Battle.AttackState.New()
	arg0_1._attackLeftState = var0_0.Battle.AttackLeftState.New()
	arg0_1._deadState = var0_0.Battle.DeadState.New()
	arg0_1._moveLeftState = var0_0.Battle.MoveLeftState.New()
	arg0_1._victoryState = var0_0.Battle.VictoryState.New()
	arg0_1._victorySwimState = var0_0.Battle.VictorySwimState.New()
	arg0_1._standState = var0_0.Battle.StandState.New()
	arg0_1._spellState = var0_0.Battle.SpellState.New()
	arg0_1._interruptState = var0_0.Battle.InterruptState.New()
	arg0_1._skillStartState = var0_0.Battle.SkillStartState.New()
	arg0_1._skillEndState = var0_0.Battle.SkillEndState.New()
	arg0_1._diveState = var0_0.Battle.DiveState.New()
	arg0_1._diveLeftState = var0_0.Battle.DiveLeftState.New()
	arg0_1._raidState = var0_0.Battle.RaidState.New()
	arg0_1._raidLeftState = var0_0.Battle.RaidLeftState.New()

	arg0_1:OnIdleState()
end

function var0_0.Battle.UnitState.FreshActionKeyOffset(arg0_2)
	local var0_2 = arg0_2:ActionKeyOffset()

	if var0_2 then
		if string.find(arg0_2._currentAction, var0_2) == nil then
			arg0_2:SendAction(arg0_2._currentAction .. var0_2)
		end
	elseif arg0_2._offset ~= nil then
		local var1_2 = string.find(arg0_2._currentAction, arg0_2._offset)

		arg0_2:SendAction(string.sub(arg0_2._currentAction, 1, var1_2 - 1))
	end

	arg0_2._offset = var0_2
end

function var0_0.Battle.UnitState.ChangeState(arg0_3, arg1_3, arg2_3)
	if arg1_3 == arg0_3.STATE_IDLE then
		arg0_3._currentState:AddIdleState(arg0_3)
	elseif arg1_3 == arg0_3.STATE_MOVE then
		arg0_3._currentState:AddMoveState(arg0_3)
	elseif arg1_3 == arg0_3.STATE_MOVE then
		arg0_3._currentState:AddMoveState(arg0_3)
	elseif arg1_3 == arg0_3.STATE_ATTACK then
		arg0_3._currentState:AddAttackState(arg0_3, arg2_3)
	elseif arg1_3 == arg0_3.STATE_DEAD then
		arg0_3._currentState:AddDeadState(arg0_3)
	elseif arg1_3 == arg0_3.STATE_MOVELEFT then
		arg0_3._currentState:AddMoveLeftState(arg0_3)
	elseif arg1_3 == arg0_3.STATE_VICTORY then
		local var0_3 = arg0_3:GetTarget():GetOxyState()

		if var0_3 and var0_3:GetCurrentDiveState() == var1_0.OXY_STATE.DIVE then
			arg0_3._currentState:AddVictorySwimState(arg0_3)
		else
			arg0_3._currentState:AddVictoryState(arg0_3)
		end
	elseif arg1_3 == arg0_3.STATE_INTERRUPT then
		arg0_3._currentState:AddInterruptState(arg0_3)
	elseif arg1_3 == arg0_3.STATE_STAND then
		arg0_3._currentState:AddStandState(arg0_3)
	elseif arg1_3 == arg0_3.STATE_DIVE then
		arg0_3._currentState:AddDiveState(arg0_3)
	elseif arg1_3 == arg0_3.STATE_DIVELEFT then
		arg0_3._currentState:AddDiveLeftState(arg0_3)
	elseif arg1_3 == arg0_3.STATE_SKILL_START then
		arg0_3._currentState:AddSkillStartState(arg0_3)
	elseif arg1_3 == arg0_3.STATE_SKILL_END then
		arg0_3._currentState:AddSkillEndState(arg0_3)
	else
		assert(false, arg0_3._target.__name .. "'s state machine, unexcepted state: " .. arg1_3)
	end
end

function var0_0.Battle.UnitState.OnMoveState(arg0_4)
	arg0_4._currentState = arg0_4._moveState

	local var0_4 = arg0_4._currentState:GetActionName(arg0_4)

	arg0_4:SendAction(var0_4)
end

function var0_0.Battle.UnitState.OnMoveLeftState(arg0_5)
	arg0_5._currentState = arg0_5._moveLeftState

	local var0_5 = arg0_5._currentState:GetActionName(arg0_5)

	arg0_5:SendAction(var0_5)
end

function var0_0.Battle.UnitState.OnIdleState(arg0_6)
	arg0_6._currentState = arg0_6._idleState

	local var0_6 = arg0_6._currentState:GetActionName(arg0_6)

	arg0_6:SendAction(var0_6)
end

function var0_0.Battle.UnitState.OnAttackState(arg0_7, arg1_7)
	arg0_7._currentState = arg0_7._attackState

	local var0_7 = arg0_7._currentState:GetActionName(arg0_7, arg1_7)

	arg0_7:SendAction(var0_7)
end

function var0_0.Battle.UnitState.OnAttackLeftState(arg0_8, arg1_8)
	arg0_8._currentState = arg0_8._attackLeftState

	local var0_8 = arg0_8._currentState:GetActionName(arg0_8, arg1_8)

	arg0_8:SendAction(var0_8)
end

function var0_0.Battle.UnitState.OnDiveState(arg0_9)
	arg0_9._currentState = arg0_9._diveState

	local var0_9 = arg0_9._currentState:GetActionName(arg0_9)

	arg0_9:SendAction(var0_9)
end

function var0_0.Battle.UnitState.OnDiveLeftState(arg0_10)
	arg0_10._currentState = arg0_10._diveLeftState

	local var0_10 = arg0_10._currentState:GetActionName(arg0_10)

	arg0_10:SendAction(var0_10)
end

function var0_0.Battle.UnitState.OnRaidState(arg0_11, arg1_11)
	arg0_11._currentState = arg0_11._raidState

	local var0_11 = arg0_11._currentState:GetActionName(arg0_11)

	arg0_11:SendAction(var0_11)
end

function var0_0.Battle.UnitState.OnRaidLeftState(arg0_12, arg1_12)
	arg0_12._currentState = arg0_12._raidLeftState

	local var0_12 = arg0_12._currentState:GetActionName(arg0_12)

	arg0_12:SendAction(var0_12)
end

function var0_0.Battle.UnitState.OnDeadState(arg0_13)
	arg0_13._currentState = arg0_13._deadState

	local var0_13 = arg0_13._currentState:GetActionName(arg0_13)

	arg0_13:SendAction(var0_13)
end

function var0_0.Battle.UnitState.OnVictoryState(arg0_14)
	arg0_14._currentState = arg0_14._victoryState

	local var0_14 = arg0_14._currentState:GetActionName(arg0_14)

	arg0_14:SendAction(var0_14)
end

function var0_0.Battle.UnitState.OnVictorySwimState(arg0_15)
	arg0_15._currentState = arg0_15._victorySwimState

	local var0_15 = arg0_15._currentState:GetActionName(arg0_15)

	arg0_15:SendAction(var0_15)
end

function var0_0.Battle.UnitState.OnStandState(arg0_16)
	arg0_16._currentState = arg0_16._standState

	local var0_16 = arg0_16._currentState:GetActionName(arg0_16)

	arg0_16:SendAction(var0_16)
end

function var0_0.Battle.UnitState.OnInterruptState(arg0_17)
	arg0_17._currentState = arg0_17._interruptState

	local var0_17 = arg0_17._currentState:GetActionName(arg0_17)

	arg0_17:SendAction(var0_17)
end

function var0_0.Battle.UnitState.OnSkillStartState(arg0_18)
	arg0_18._currentState = arg0_18._skillStartState

	local var0_18 = arg0_18._currentState:GetActionName(arg0_18)

	arg0_18:SendAction(var0_18)
end

function var0_0.Battle.UnitState.OnSkillEndState(arg0_19)
	arg0_19._currentState = arg0_19._skillEndState

	local var0_19 = arg0_19._currentState:GetActionName(arg0_19)

	arg0_19:SendAction(var0_19)
end

function var0_0.Battle.UnitState.ChangeToMoveState(arg0_20)
	local var0_20 = arg0_20:GetTarget():GetSpeed().x
	local var1_20 = arg0_20:GetTarget():GetOxyState()

	if var1_20 and var1_20:GetCurrentDiveState() == var1_0.OXY_STATE.DIVE then
		if var0_20 >= 0 then
			arg0_20:OnDiveState()
		else
			arg0_20:OnDiveLeftState()
		end
	elseif var0_20 >= 0 then
		arg0_20:OnMoveState()
	else
		arg0_20:OnMoveLeftState()
	end
end

function var0_0.Battle.UnitState.SendAction(arg0_21, arg1_21)
	arg0_21._currentAction = arg1_21

	local var0_21 = var0_0.Event.New(var0_0.Battle.BattleUnitEvent.CHANGE_ACTION, {
		actionType = arg1_21
	})

	arg0_21._target:DispatchEvent(var0_21)
end

function var0_0.Battle.UnitState.ChangeOxyState(arg0_22, arg1_22)
	arg0_22._target:ChangeOxygenState(arg1_22)
end

function var0_0.Battle.UnitState.GetTarget(arg0_23)
	return arg0_23._target
end

function var0_0.Battle.UnitState.ActionKeyOffset(arg0_24)
	return arg0_24._target:GetActionKeyOffset()
end

function var0_0.Battle.UnitState.GetCurrentStateName(arg0_25)
	return arg0_25._currentState.__name
end

function var0_0.Battle.UnitState.NeedWeaponCache(arg0_26)
	return arg0_26._currentState:CacheWeapon()
end

function var0_0.Battle.UnitState.OnActionStart(arg0_27)
	arg0_27._currentState:OnStart(arg0_27)
end

function var0_0.Battle.UnitState.OnActionTrigger(arg0_28)
	arg0_28._currentState:OnTrigger(arg0_28)
end

function var0_0.Battle.UnitState.OnActionEnd(arg0_29)
	arg0_29._currentState:OnEnd(arg0_29)
end
