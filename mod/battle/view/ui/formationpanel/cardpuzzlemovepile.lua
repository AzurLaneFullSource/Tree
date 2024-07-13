ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleCardPuzzleEvent

var0_0.Battle.CardPuzzleMovePile = class("CardPuzzleMovePile")

local var3_0 = var0_0.Battle.CardPuzzleMovePile

var3_0.__name = "CardPuzzleMovePile"

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1

	arg0_1:init()
end

function var3_0.SetCardPuzzleComponent(arg0_2, arg1_2)
	arg0_2._cardPuzzleInfo = arg1_2
	arg0_2._moveDeck = arg0_2._cardPuzzleInfo:GetMoveDeck()

	arg0_2._moveDeck:RegisterEventListener(arg0_2, var2_0.UPDATE_CARDS, arg0_2.onUpdateMoveCards)
	arg0_2:onUpdateMoveCards()
end

function var3_0.onUpdateMoveCards(arg0_3, arg1_3)
	setText(arg0_3._moveCountLabel, "X" .. arg0_3._moveDeck:GetLength())
end

function var3_0.Update(arg0_4)
	return
end

function var3_0.init(arg0_5)
	var0_0.EventListener.AttachEventListener(arg0_5)

	arg0_5._tf = arg0_5._go.transform
	arg0_5._btnTF = arg0_5._tf:Find("card")
	arg0_5._moveCountLabel = arg0_5._btnTF:Find("count")
	arg0_5._moveProgress = arg0_5._btnTF:Find("progress"):GetComponent(typeof(Image))
	arg0_5._moveProgress.fillAmount = 1
end

function var3_0.updateMoveProgress(arg0_6)
	local var0_6 = arg0_6._moveDeck:GetGeneratePorcess()

	if var0_6 ~= arg0_6._progressCache then
		arg0_6._moveProgress.fillAmount = var0_6
	end

	arg0_6._progressCache = var0_6
end

function var3_0.Dispose(arg0_7)
	arg0_7._moveCountLabel = nil
	arg0_7._moveProgress = nil
	arg0_7._btnTF = nil
	arg0_7._tf = nil
end
