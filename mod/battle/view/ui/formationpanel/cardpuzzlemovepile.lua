ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleCardPuzzleEvent

var0.Battle.CardPuzzleMovePile = class("CardPuzzleMovePile")

local var3 = var0.Battle.CardPuzzleMovePile

var3.__name = "CardPuzzleMovePile"

function var3.Ctor(arg0, arg1)
	arg0._go = arg1

	arg0:init()
end

function var3.SetCardPuzzleComponent(arg0, arg1)
	arg0._cardPuzzleInfo = arg1
	arg0._moveDeck = arg0._cardPuzzleInfo:GetMoveDeck()

	arg0._moveDeck:RegisterEventListener(arg0, var2.UPDATE_CARDS, arg0.onUpdateMoveCards)
	arg0:onUpdateMoveCards()
end

function var3.onUpdateMoveCards(arg0, arg1)
	setText(arg0._moveCountLabel, "X" .. arg0._moveDeck:GetLength())
end

function var3.Update(arg0)
	return
end

function var3.init(arg0)
	var0.EventListener.AttachEventListener(arg0)

	arg0._tf = arg0._go.transform
	arg0._btnTF = arg0._tf:Find("card")
	arg0._moveCountLabel = arg0._btnTF:Find("count")
	arg0._moveProgress = arg0._btnTF:Find("progress"):GetComponent(typeof(Image))
	arg0._moveProgress.fillAmount = 1
end

function var3.updateMoveProgress(arg0)
	local var0 = arg0._moveDeck:GetGeneratePorcess()

	if var0 ~= arg0._progressCache then
		arg0._moveProgress.fillAmount = var0
	end

	arg0._progressCache = var0
end

function var3.Dispose(arg0)
	arg0._moveCountLabel = nil
	arg0._moveProgress = nil
	arg0._btnTF = nil
	arg0._tf = nil
end
