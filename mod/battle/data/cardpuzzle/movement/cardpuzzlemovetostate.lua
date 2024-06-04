ys = ys or {}

local var0 = ys

var0.Battle.CardPuzzleMoveToState = class("CardPuzzleMoveToState", var0.Battle.CardPuzzleIMoveState)

local var1 = var0.Battle.CardPuzzleMoveToState

var1.__name = "CardPuzzleMoveToState"
var1.VALVE = 0.5

function var1.Ctor(arg0)
	var1.super.Ctor(arg0)
end

function var1.AddMoveToState(arg0, arg1)
	arg1:OnMoveToState()
end

function var1.AddRandomState(arg0, arg1)
	arg1:OnRandomState()
end

function var1.AddStayState(arg0, arg1)
	arg1:OnStayState()
end

function var1.IsFinish(arg0, arg1)
	return (arg0._referencePoint - arg1:GetFleetPosition()).magnitude < var1.VALVE
end

function var1.GetOutput(arg0, arg1)
	local var0 = (arg0._referencePoint - arg1:GetFleetPosition()).normalized

	return var0.x, var0.z
end

function var1.NextState(arg0)
	return var0.Battle.CardPuzzleMoveState.STATE_STAY
end
