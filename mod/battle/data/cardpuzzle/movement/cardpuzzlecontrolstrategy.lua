ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleFormulas
local var2 = var0.Battle.BattleConfig

var0.Battle.CardPuzzleControlStrategy = class("CardPuzzleControlStrategy", var0.Battle.BattleJoyStickBotBaseStrategy)

local var3 = var0.Battle.CardPuzzleControlStrategy

var3.__name = "CardPuzzleControlStrategy"

function var3.Ctor(arg0, arg1)
	var3.super.Ctor(arg0, arg1)
	arg0._fleetVO:GetCardPuzzleComponent():AttachMoveController(arg0)

	arg0._moveState = var0.Battle.CardPuzzleMoveState.New(arg0._fleetVO)
end

function var3.GetStrategyType(arg0)
	return var0.Battle.BattleJoyStickAutoBot.CARD_PUZZLE_CONTROL
end

function var3.InputTargetPoint(arg0, arg1, arg2)
	arg0._moveState:SetReferencePoint(arg1)
	arg0._moveState:FinishCallback(arg2)
	arg0._moveState:ChangeState(arg0._moveState.STATE_MOVE)
end

function var3.analysis(arg0)
	local var0, var1 = arg0._moveState:GetDirection()

	arg0._hrz = var0
	arg0._vtc = var1
end

function var3.Output(arg0)
	arg0._moveState:Update()
	arg0:analysis()

	return arg0._hrz, arg0._vtc
end
