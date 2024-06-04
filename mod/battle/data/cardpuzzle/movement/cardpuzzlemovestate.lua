ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = var0.Battle.BattleConfig

var0.Battle.CardPuzzleMoveState = class("CardPuzzleMoveState")

local var3 = var0.Battle.CardPuzzleMoveState

var3.__name = "CardPuzzleMoveState"
var3.STATE_MOVE = "STATE_MOVE"
var3.STATE_STAY = "STATE_STAY"
var3.STATE_RANDOM = "STATE_RANDOM"

function var3.Ctor(arg0, arg1)
	arg0._fleet = arg1
	arg0._fleetMotion = arg1:GetMotion()
	arg0._moveToState = var0.Battle.CardPuzzleMoveToState.New()
	arg0._stayState = var0.Battle.CardPuzzleStayState.New()
	arg0._RandomState = var0.Battle.CardPuzzleRandomState.New()

	arg0:OnStayState()
end

function var3.SetReferencePoint(arg0, arg1)
	arg0._currentReferencePoint = arg1
end

function var3.ChangeState(arg0, arg1)
	local var0 = var0.Battle.CardPuzzleIMoveState.ADD_STATE_TABLE[arg1]

	arg0._currentState[var0](arg0._currentState, arg0)
end

function var3.Update(arg0)
	arg0._currentState:Update()

	if arg0._currentState:IsFinish(arg0) then
		if arg0._currentState == arg0._moveToState then
			arg0._callback()

			arg0._callback = nil
		end

		local var0 = arg0._currentState:NextState()

		arg0:ChangeState(var0)
	end
end

function var3.FinishCallback(arg0, arg1)
	arg0._callback = arg1
end

function var3.GetFleetPosition(arg0)
	return arg0._fleetMotion:GetPos()
end

function var3.GetDistance(arg0)
	return arg0._currentReferencePoint - arg0:GetFleetPosition()
end

function var3.GetDirection(arg0)
	local var0, var1 = arg0._currentState:GetOutput(arg0)

	return var0, var1
end

function var3.GetStateChangeTimeStamp(arg0)
	return arg0._stateChangeTimeStamp
end

function var3.OnMoveToState(arg0)
	arg0._currentState = arg0._moveToState

	arg0:HandleStateChange()
end

function var3.OnRandomState(arg0)
	arg0._currentState = arg0._RandomState

	arg0:HandleStateChange()
end

function var3.OnStayState(arg0)
	arg0._currentState = arg0._stayState

	arg0:HandleStateChange()
end

function var3.HandleStateChange(arg0)
	arg0._stateChangeTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0._currentState:IntputReferencePoint(arg0._currentReferencePoint or arg0:GetFleetPosition())
end
