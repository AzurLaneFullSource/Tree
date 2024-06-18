ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = var0_0.Battle.BattleConfig

var0_0.Battle.CardPuzzleMoveState = class("CardPuzzleMoveState")

local var3_0 = var0_0.Battle.CardPuzzleMoveState

var3_0.__name = "CardPuzzleMoveState"
var3_0.STATE_MOVE = "STATE_MOVE"
var3_0.STATE_STAY = "STATE_STAY"
var3_0.STATE_RANDOM = "STATE_RANDOM"

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._fleet = arg1_1
	arg0_1._fleetMotion = arg1_1:GetMotion()
	arg0_1._moveToState = var0_0.Battle.CardPuzzleMoveToState.New()
	arg0_1._stayState = var0_0.Battle.CardPuzzleStayState.New()
	arg0_1._RandomState = var0_0.Battle.CardPuzzleRandomState.New()

	arg0_1:OnStayState()
end

function var3_0.SetReferencePoint(arg0_2, arg1_2)
	arg0_2._currentReferencePoint = arg1_2
end

function var3_0.ChangeState(arg0_3, arg1_3)
	local var0_3 = var0_0.Battle.CardPuzzleIMoveState.ADD_STATE_TABLE[arg1_3]

	arg0_3._currentState[var0_3](arg0_3._currentState, arg0_3)
end

function var3_0.Update(arg0_4)
	arg0_4._currentState:Update()

	if arg0_4._currentState:IsFinish(arg0_4) then
		if arg0_4._currentState == arg0_4._moveToState then
			arg0_4._callback()

			arg0_4._callback = nil
		end

		local var0_4 = arg0_4._currentState:NextState()

		arg0_4:ChangeState(var0_4)
	end
end

function var3_0.FinishCallback(arg0_5, arg1_5)
	arg0_5._callback = arg1_5
end

function var3_0.GetFleetPosition(arg0_6)
	return arg0_6._fleetMotion:GetPos()
end

function var3_0.GetDistance(arg0_7)
	return arg0_7._currentReferencePoint - arg0_7:GetFleetPosition()
end

function var3_0.GetDirection(arg0_8)
	local var0_8, var1_8 = arg0_8._currentState:GetOutput(arg0_8)

	return var0_8, var1_8
end

function var3_0.GetStateChangeTimeStamp(arg0_9)
	return arg0_9._stateChangeTimeStamp
end

function var3_0.OnMoveToState(arg0_10)
	arg0_10._currentState = arg0_10._moveToState

	arg0_10:HandleStateChange()
end

function var3_0.OnRandomState(arg0_11)
	arg0_11._currentState = arg0_11._RandomState

	arg0_11:HandleStateChange()
end

function var3_0.OnStayState(arg0_12)
	arg0_12._currentState = arg0_12._stayState

	arg0_12:HandleStateChange()
end

function var3_0.HandleStateChange(arg0_13)
	arg0_13._stateChangeTimeStamp = pg.TimeMgr.GetInstance():GetCombatTime()

	arg0_13._currentState:IntputReferencePoint(arg0_13._currentReferencePoint or arg0_13:GetFleetPosition())
end
