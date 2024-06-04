ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst
local var2 = var1.ActionName

var0.Battle.UnitState = class("UnitState")
var0.Battle.UnitState.__name = "UnitState"
var0.Battle.UnitState.STATE_IDLE = "STATE_IDLE"
var0.Battle.UnitState.STATE_MOVE = "STATE_MOVE"
var0.Battle.UnitState.STATE_ATTACK = "STATE_ATTACK"
var0.Battle.UnitState.STATE_ATTACKLEFT = "STATE_ATTACKLEFT"
var0.Battle.UnitState.STATE_DEAD = "STATE_DEAD"
var0.Battle.UnitState.STATE_MOVELEFT = "STATE_MOVELEFT"
var0.Battle.UnitState.STATE_SKILL = "STATE_SKILL"
var0.Battle.UnitState.STATE_VICTORY = "STATE_VICTORY"
var0.Battle.UnitState.STATE_STAND = "STATE_STAND"
var0.Battle.UnitState.STATE_INTERRUPT = "STATE_INTERRUPT"
var0.Battle.UnitState.STATE_SKILL_START = "STATE_SKILL_START"
var0.Battle.UnitState.STATE_SKILL_END = "STATE_SKILL_END"
var0.Battle.UnitState.STATE_DIVING = "STATE_DIVING"
var0.Battle.UnitState.STATE_DIVE = "STATE_DIVE"
var0.Battle.UnitState.STATE_DIVELEFT = "STATE_DIVELEFT"
var0.Battle.UnitState.STATE_RAID = "STATE_RAID"
var0.Battle.UnitState.STATE_RAIDLEFT = "STATE_RAIDLEFT"

function var0.Battle.UnitState.Ctor(arg0, arg1)
	arg0._target = arg1
	arg0._idleState = var0.Battle.IdleState.New()
	arg0._moveState = var0.Battle.MoveState.New()
	arg0._attackState = var0.Battle.AttackState.New()
	arg0._attackLeftState = var0.Battle.AttackLeftState.New()
	arg0._deadState = var0.Battle.DeadState.New()
	arg0._moveLeftState = var0.Battle.MoveLeftState.New()
	arg0._victoryState = var0.Battle.VictoryState.New()
	arg0._victorySwimState = var0.Battle.VictorySwimState.New()
	arg0._standState = var0.Battle.StandState.New()
	arg0._spellState = var0.Battle.SpellState.New()
	arg0._interruptState = var0.Battle.InterruptState.New()
	arg0._skillStartState = var0.Battle.SkillStartState.New()
	arg0._skillEndState = var0.Battle.SkillEndState.New()
	arg0._diveState = var0.Battle.DiveState.New()
	arg0._diveLeftState = var0.Battle.DiveLeftState.New()
	arg0._raidState = var0.Battle.RaidState.New()
	arg0._raidLeftState = var0.Battle.RaidLeftState.New()

	arg0:OnIdleState()
end

function var0.Battle.UnitState.FreshActionKeyOffset(arg0)
	local var0 = arg0:ActionKeyOffset()

	if var0 then
		if string.find(arg0._currentAction, var0) == nil then
			arg0:SendAction(arg0._currentAction .. var0)
		end
	elseif arg0._offset ~= nil then
		local var1 = string.find(arg0._currentAction, arg0._offset)

		arg0:SendAction(string.sub(arg0._currentAction, 1, var1 - 1))
	end

	arg0._offset = var0
end

function var0.Battle.UnitState.ChangeState(arg0, arg1, arg2)
	if arg1 == arg0.STATE_IDLE then
		arg0._currentState:AddIdleState(arg0)
	elseif arg1 == arg0.STATE_MOVE then
		arg0._currentState:AddMoveState(arg0)
	elseif arg1 == arg0.STATE_MOVE then
		arg0._currentState:AddMoveState(arg0)
	elseif arg1 == arg0.STATE_ATTACK then
		arg0._currentState:AddAttackState(arg0, arg2)
	elseif arg1 == arg0.STATE_DEAD then
		arg0._currentState:AddDeadState(arg0)
	elseif arg1 == arg0.STATE_MOVELEFT then
		arg0._currentState:AddMoveLeftState(arg0)
	elseif arg1 == arg0.STATE_VICTORY then
		local var0 = arg0:GetTarget():GetOxyState()

		if var0 and var0:GetCurrentDiveState() == var1.OXY_STATE.DIVE then
			arg0._currentState:AddVictorySwimState(arg0)
		else
			arg0._currentState:AddVictoryState(arg0)
		end
	elseif arg1 == arg0.STATE_INTERRUPT then
		arg0._currentState:AddInterruptState(arg0)
	elseif arg1 == arg0.STATE_STAND then
		arg0._currentState:AddStandState(arg0)
	elseif arg1 == arg0.STATE_DIVE then
		arg0._currentState:AddDiveState(arg0)
	elseif arg1 == arg0.STATE_DIVELEFT then
		arg0._currentState:AddDiveLeftState(arg0)
	elseif arg1 == arg0.STATE_SKILL_START then
		arg0._currentState:AddSkillStartState(arg0)
	elseif arg1 == arg0.STATE_SKILL_END then
		arg0._currentState:AddSkillEndState(arg0)
	else
		assert(false, arg0._target.__name .. "'s state machine, unexcepted state: " .. arg1)
	end
end

function var0.Battle.UnitState.OnMoveState(arg0)
	arg0._currentState = arg0._moveState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnMoveLeftState(arg0)
	arg0._currentState = arg0._moveLeftState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnIdleState(arg0)
	arg0._currentState = arg0._idleState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnAttackState(arg0, arg1)
	arg0._currentState = arg0._attackState

	local var0 = arg0._currentState:GetActionName(arg0, arg1)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnAttackLeftState(arg0, arg1)
	arg0._currentState = arg0._attackLeftState

	local var0 = arg0._currentState:GetActionName(arg0, arg1)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnDiveState(arg0)
	arg0._currentState = arg0._diveState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnDiveLeftState(arg0)
	arg0._currentState = arg0._diveLeftState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnRaidState(arg0, arg1)
	arg0._currentState = arg0._raidState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnRaidLeftState(arg0, arg1)
	arg0._currentState = arg0._raidLeftState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnDeadState(arg0)
	arg0._currentState = arg0._deadState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnVictoryState(arg0)
	arg0._currentState = arg0._victoryState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnVictorySwimState(arg0)
	arg0._currentState = arg0._victorySwimState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnStandState(arg0)
	arg0._currentState = arg0._standState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnInterruptState(arg0)
	arg0._currentState = arg0._interruptState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnSkillStartState(arg0)
	arg0._currentState = arg0._skillStartState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.OnSkillEndState(arg0)
	arg0._currentState = arg0._skillEndState

	local var0 = arg0._currentState:GetActionName(arg0)

	arg0:SendAction(var0)
end

function var0.Battle.UnitState.ChangeToMoveState(arg0)
	local var0 = arg0:GetTarget():GetSpeed().x
	local var1 = arg0:GetTarget():GetOxyState()

	if var1 and var1:GetCurrentDiveState() == var1.OXY_STATE.DIVE then
		if var0 >= 0 then
			arg0:OnDiveState()
		else
			arg0:OnDiveLeftState()
		end
	elseif var0 >= 0 then
		arg0:OnMoveState()
	else
		arg0:OnMoveLeftState()
	end
end

function var0.Battle.UnitState.SendAction(arg0, arg1)
	arg0._currentAction = arg1

	local var0 = var0.Event.New(var0.Battle.BattleUnitEvent.CHANGE_ACTION, {
		actionType = arg1
	})

	arg0._target:DispatchEvent(var0)
end

function var0.Battle.UnitState.ChangeOxyState(arg0, arg1)
	arg0._target:ChangeOxygenState(arg1)
end

function var0.Battle.UnitState.GetTarget(arg0)
	return arg0._target
end

function var0.Battle.UnitState.ActionKeyOffset(arg0)
	return arg0._target:GetActionKeyOffset()
end

function var0.Battle.UnitState.GetCurrentStateName(arg0)
	return arg0._currentState.__name
end

function var0.Battle.UnitState.NeedWeaponCache(arg0)
	return arg0._currentState:CacheWeapon()
end

function var0.Battle.UnitState.OnActionStart(arg0)
	arg0._currentState:OnStart(arg0)
end

function var0.Battle.UnitState.OnActionTrigger(arg0)
	arg0._currentState:OnTrigger(arg0)
end

function var0.Battle.UnitState.OnActionEnd(arg0)
	arg0._currentState:OnEnd(arg0)
end
