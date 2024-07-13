ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConst.ActionName

var0_0.Battle.MoveState = class("MoveState", var0_0.Battle.IUnitState)
var0_0.Battle.MoveState.__name = "MoveState"

local var2_0 = var0_0.Battle.MoveState

function var2_0.Ctor(arg0_1)
	var2_0.super.Ctor()
end

function var2_0.AddIdleState(arg0_2, arg1_2, arg2_2)
	arg1_2:OnIdleState()
end

function var2_0.AddMoveState(arg0_3, arg1_3, arg2_3)
	return
end

function var2_0.AddMoveLeftState(arg0_4, arg1_4, arg2_4)
	arg1_4:OnMoveLeftState()
end

function var2_0.AddAttackState(arg0_5, arg1_5, arg2_5)
	arg1_5:OnAttackState(arg2_5)
end

function var2_0.AddDeadState(arg0_6, arg1_6, arg2_6)
	arg1_6:OnDeadState()
end

function var2_0.AddSkillState(arg0_7, arg1_7, arg2_7)
	return
end

function var2_0.AddSpellState(arg0_8, arg1_8, arg2_8)
	arg1_8:OnSpellState()
end

function var2_0.AddVictoryState(arg0_9, arg1_9, arg2_9)
	arg1_9:OnVictoryState()
end

function var2_0.AddVictorySwimState(arg0_10, arg1_10, arg2_10)
	arg1_10:OnVictorySwimState()
end

function var2_0.AddStandState(arg0_11, arg1_11, arg2_11)
	return
end

function var2_0.AddDiveState(arg0_12, arg1_12, arg2_12)
	arg1_12:OnDiveState()
end

function var2_0.AddDiveLeftState(arg0_13, arg1_13, arg2_13)
	arg1_13:OnDiveLeftState()
end

function var2_0.AddInterruptState(arg0_14, arg1_14, arg2_14)
	arg1_14:OnInterruptState()
end

function var2_0.AddDivingState(arg0_15, arg1_15, arg2_15)
	arg1_15:OnDivingState()
end

function var2_0.AddSkillStartState(arg0_16, arg1_16, arg2_16)
	arg1_16:OnSkillStartState()
end

function var2_0.AddSkillEndState(arg0_17, arg1_17, arg2_17)
	return
end

function var2_0.OnTrigger(arg0_18, arg1_18)
	return
end

function var2_0.OnStart(arg0_19, arg1_19)
	return
end

function var2_0.OnEnd(arg0_20, arg1_20)
	return
end

function var2_0.CacheWeapon(arg0_21)
	return true
end

function var2_0.FreshActionKeyOffset(arg0_22, arg1_22)
	return true
end

function var2_0.GetActionName(arg0_23, arg1_23)
	local var0_23 = var1_0.MOVE
	local var1_23 = arg1_23:ActionKeyOffset()

	if var1_23 then
		var0_23 = var0_23 .. var1_23
	end

	return var0_23
end
