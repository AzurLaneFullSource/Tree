ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConst.ActionName

var0.Battle.VictorySwimState = class("VictorySwimState", var0.Battle.IUnitState)
var0.Battle.VictorySwimState.__name = "VictorySwimState"

local var2 = var0.Battle.VictorySwimState

function var2.Ctor(arg0)
	var2.super.Ctor()
end

function var2.AddIdleState(arg0, arg1, arg2)
	return
end

function var2.AddMoveState(arg0, arg1, arg2)
	return
end

function var2.AddMoveLeftState(arg0, arg1, arg2)
	return
end

function var2.AddAttackState(arg0, arg1, arg2)
	return
end

function var2.AddDeadState(arg0, arg1, arg2)
	return
end

function var2.AddSkillState(arg0, arg1, arg2)
	return
end

function var2.AddSpellState(arg0, arg1, arg2)
	return
end

function var2.AddVictoryState(arg0, arg1, arg2)
	return
end

function var2.AddVictorySwimState(arg0, arg1, arg2)
	return
end

function var2.AddStandState(arg0, arg1, arg2)
	return
end

function var2.AddDiveState(arg0, arg1, arg2)
	return
end

function var2.AddDiveLeftState(arg0, arg1, arg2)
	return
end

function var2.AddInterruptState(arg0, arg1, arg2)
	return
end

function var2.AddDivingState(arg0, arg1, arg2)
	return
end

function var2.AddSkillStartState(arg0, arg1, arg2)
	return
end

function var2.AddSkillEndState(arg0, arg1, arg2)
	return
end

function var2.OnTrigger(arg0, arg1)
	return
end

function var2.OnStart(arg0, arg1)
	return
end

function var2.OnEnd(arg0, arg1)
	return
end

function var2.CacheWeapon(arg0)
	return true
end

function var2.FreshActionKeyOffset(arg0)
	return false
end

function var2.GetActionName(arg0, arg1)
	return var1.VICTORY_SWIM
end
