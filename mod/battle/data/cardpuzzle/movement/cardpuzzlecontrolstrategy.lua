ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleFormulas
local var2_0 = var0_0.Battle.BattleConfig

var0_0.Battle.CardPuzzleControlStrategy = class("CardPuzzleControlStrategy", var0_0.Battle.BattleJoyStickBotBaseStrategy)

local var3_0 = var0_0.Battle.CardPuzzleControlStrategy

var3_0.__name = "CardPuzzleControlStrategy"

function var3_0.Ctor(arg0_1, arg1_1)
	var3_0.super.Ctor(arg0_1, arg1_1)
	arg0_1._fleetVO:GetCardPuzzleComponent():AttachMoveController(arg0_1)

	arg0_1._moveState = var0_0.Battle.CardPuzzleMoveState.New(arg0_1._fleetVO)
end

function var3_0.GetStrategyType(arg0_2)
	return var0_0.Battle.BattleJoyStickAutoBot.CARD_PUZZLE_CONTROL
end

function var3_0.InputTargetPoint(arg0_3, arg1_3, arg2_3)
	arg0_3._moveState:SetReferencePoint(arg1_3)
	arg0_3._moveState:FinishCallback(arg2_3)
	arg0_3._moveState:ChangeState(arg0_3._moveState.STATE_MOVE)
end

function var3_0.analysis(arg0_4)
	local var0_4, var1_4 = arg0_4._moveState:GetDirection()

	arg0_4._hrz = var0_4
	arg0_4._vtc = var1_4
end

function var3_0.Output(arg0_5)
	arg0_5._moveState:Update()
	arg0_5:analysis()

	return arg0_5._hrz, arg0_5._vtc
end
