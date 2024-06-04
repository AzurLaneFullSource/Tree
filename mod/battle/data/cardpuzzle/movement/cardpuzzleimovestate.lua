ys = ys or {}

local var0 = ys
local var1 = var0.Battle.CardPuzzleMoveState

var0.Battle.CardPuzzleIMoveState = class("CardPuzzleIMoveState")

local var2 = var0.Battle.CardPuzzleIMoveState

var2.__name = "CardPuzzleIMoveState"
var2.ADD_STATE_TABLE = {
	[var1.STATE_STAY] = "AddStayState",
	[var1.STATE_RANDOM] = "AddRandomState",
	[var1.STATE_MOVE] = "AddMoveToState"
}

function var2.Ctor(arg0)
	arg0._hrz = 0
	arg0._vtc = 0
	arg0._timeStamp = 0
end

function var2.AddMoveToState(arg0, arg1)
	return
end

function var2.AddRandomState(arg0, arg1)
	return
end

function var2.AddStayState(arg0, arg1)
	return
end

function var2.IsFinish(arg0, arg1)
	return
end

function var2.Update(arg0)
	arg0._currentTime = pg.TimeMgr.GetInstance():GetCombatTime()
end

function var2.GetOutput(arg0, arg1)
	return arg0._hrz, arg0._vtc
end

function var2.IntputReferencePoint(arg0, arg1)
	arg0._referencePoint = arg1
end

function var2.NextState(arg0)
	return
end
