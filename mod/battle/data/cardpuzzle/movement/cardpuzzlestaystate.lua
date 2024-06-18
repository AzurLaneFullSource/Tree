ys = ys or {}

local var0_0 = ys

var0_0.Battle.CardPuzzleStayState = class("CardPuzzleStayState", var0_0.Battle.CardPuzzleIMoveState)

local var1_0 = var0_0.Battle.CardPuzzleStayState

var1_0.__name = "CardPuzzleStayState"
var1_0.STAY_DURATION = 5000

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
	local var0_5 = arg1_5:GetStateChangeTimeStamp()

	return arg0_5._currentTime - var0_5 > var1_0.STAY_DURATION
end

function var1_0.NextState(arg0_6)
	return var0_0.Battle.CardPuzzleMoveState.STATE_RANDOM
end
