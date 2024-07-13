ys = ys or {}

local var0_0 = ys

var0_0.Battle.CardPuzzleMoveToState = class("CardPuzzleMoveToState", var0_0.Battle.CardPuzzleIMoveState)

local var1_0 = var0_0.Battle.CardPuzzleMoveToState

var1_0.__name = "CardPuzzleMoveToState"
var1_0.VALVE = 0.5

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.AddMoveToState(arg0_2, arg1_2)
	arg1_2:OnMoveToState()
end

function var1_0.AddRandomState(arg0_3, arg1_3)
	arg1_3:OnRandomState()
end

function var1_0.AddStayState(arg0_4, arg1_4)
	arg1_4:OnStayState()
end

function var1_0.IsFinish(arg0_5, arg1_5)
	return (arg0_5._referencePoint - arg1_5:GetFleetPosition()).magnitude < var1_0.VALVE
end

function var1_0.GetOutput(arg0_6, arg1_6)
	local var0_6 = (arg0_6._referencePoint - arg1_6:GetFleetPosition()).normalized

	return var0_6.x, var0_6.z
end

function var1_0.NextState(arg0_7)
	return var0_0.Battle.CardPuzzleMoveState.STATE_STAY
end
