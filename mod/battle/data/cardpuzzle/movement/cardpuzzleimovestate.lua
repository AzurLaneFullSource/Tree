ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.CardPuzzleMoveState

var0_0.Battle.CardPuzzleIMoveState = class("CardPuzzleIMoveState")

local var2_0 = var0_0.Battle.CardPuzzleIMoveState

var2_0.__name = "CardPuzzleIMoveState"
var2_0.ADD_STATE_TABLE = {
	[var1_0.STATE_STAY] = "AddStayState",
	[var1_0.STATE_RANDOM] = "AddRandomState",
	[var1_0.STATE_MOVE] = "AddMoveToState"
}

function var2_0.Ctor(arg0_1)
	arg0_1._hrz = 0
	arg0_1._vtc = 0
	arg0_1._timeStamp = 0
end

function var2_0.AddMoveToState(arg0_2, arg1_2)
	return
end

function var2_0.AddRandomState(arg0_3, arg1_3)
	return
end

function var2_0.AddStayState(arg0_4, arg1_4)
	return
end

function var2_0.IsFinish(arg0_5, arg1_5)
	return
end

function var2_0.Update(arg0_6)
	arg0_6._currentTime = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var2_0.GetOutput(arg0_7, arg1_7)
	return arg0_7._hrz, arg0_7._vtc
end

function var2_0.IntputReferencePoint(arg0_8, arg1_8)
	arg0_8._referencePoint = arg1_8
end

function var2_0.NextState(arg0_9)
	return
end
