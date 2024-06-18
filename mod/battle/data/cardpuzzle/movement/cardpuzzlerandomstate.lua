ys = ys or {}

local var0_0 = ys

var0_0.Battle.CardPuzzleRandomState = class("CardPuzzleRandomState", var0_0.Battle.CardPuzzleIMoveState)

local var1_0 = var0_0.Battle.CardPuzzleRandomState

var1_0.__name = "CardPuzzleRandomState"
var1_0.VALVE = 0.5
var1_0.RANDOM_RANGE = 10

function var1_0.Ctor(arg0_1)
	var1_0.super.Ctor(arg0_1)
end

function var1_0.AddMoveToState(arg0_2, arg1_2)
	arg1_2:OnMoveToState()
end

function var1_0.AddRandomState(arg0_3, arg1_3)
	return
end

function var1_0.AddStayState(arg0_4, arg1_4)
	arg1_4:OnStayState()
end

function var1_0.IntputReferencePoint(arg0_5, arg1_5)
	local var0_5 = {
		X1 = arg1_5.x - var1_0.RANDOM_RANGE,
		X2 = arg1_5.x + var1_0.RANDOM_RANGE,
		Z1 = arg1_5.z - var1_0.RANDOM_RANGE,
		Z2 = arg1_5.z + var1_0.RANDOM_RANGE
	}

	arg0_5._referencePoint = var0_0.Battle.BattleFormulas.RandomPos(var0_5)
end

function var1_0.IsFinish(arg0_6, arg1_6)
	return (arg0_6._referencePoint - arg1_6:GetFleetPosition()).magnitude < var1_0.VALVE
end

function var1_0.GetOutput(arg0_7, arg1_7)
	local var0_7 = (arg0_7._referencePoint - arg1_7:GetFleetPosition()).normalized

	return var0_7.x, var0_7.z
end

function var1_0.NextState(arg0_8)
	return var0_0.Battle.CardPuzzleMoveState.STATE_STAY
end
