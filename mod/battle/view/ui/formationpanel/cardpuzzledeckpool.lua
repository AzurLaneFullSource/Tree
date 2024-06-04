ys = ys or {}

local var0 = ys
local var1 = var0.Battle.BattleConfig
local var2 = var0.Battle.BattleCardPuzzleEvent

var0.Battle.CardPuzzleDeckPool = class("CardPuzzleDeckPool")

local var3 = var0.Battle.CardPuzzleDeckPool

var3.__name = "CardPuzzleDeckPool"

function var3.Ctor(arg0, arg1)
	arg0._go = arg1

	arg0:init()
end

function var3.SetCardPuzzleComponent(arg0, arg1)
	arg0._cardPuzzleInfo = arg1
	arg0._deck = arg0._cardPuzzleInfo:GetDeck()

	arg0._deck:RegisterEventListener(arg0, var2.UPDATE_CARDS, arg0.onUpdateDeckCard)
	arg0:onUpdateDeckCard()
end

function var3.onUpdateDeckCard(arg0, arg1)
	setText(arg0._deckCountLabel, arg0._deck:GetLength())
end

function var3.init(arg0)
	var0.EventListener.AttachEventListener(arg0)

	arg0._tf = arg0._go.transform
	arg0._deckCountLabel = arg0._tf:Find("count/text")

	setText(arg0._tf:Find("label"), i18n("card_puzzle_deck"))
end

function var3.Dispose(arg0)
	arg0._deckCountLabel = nil
	arg0._tf = nil
end
