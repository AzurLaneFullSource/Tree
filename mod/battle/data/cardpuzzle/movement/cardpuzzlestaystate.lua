ys = ys or {}

local var0 = ys

var0.Battle.CardPuzzleStayState = class("CardPuzzleStayState", var0.Battle.CardPuzzleIMoveState)

local var1 = var0.Battle.CardPuzzleStayState

var1.__name = "CardPuzzleStayState"
var1.STAY_DURATION = 5000

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
	local var0 = arg1:GetStateChangeTimeStamp()

	return arg0._currentTime - var0 > var1.STAY_DURATION
end

function var1.NextState(arg0)
	return var0.Battle.CardPuzzleMoveState.STATE_RANDOM
end
