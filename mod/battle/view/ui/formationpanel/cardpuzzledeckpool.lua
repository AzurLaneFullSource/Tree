ys = ys or {}

local var0_0 = ys
local var1_0 = var0_0.Battle.BattleConfig
local var2_0 = var0_0.Battle.BattleCardPuzzleEvent

var0_0.Battle.CardPuzzleDeckPool = class("CardPuzzleDeckPool")

local var3_0 = var0_0.Battle.CardPuzzleDeckPool

var3_0.__name = "CardPuzzleDeckPool"

function var3_0.Ctor(arg0_1, arg1_1)
	arg0_1._go = arg1_1

	arg0_1:init()
end

function var3_0.SetCardPuzzleComponent(arg0_2, arg1_2)
	arg0_2._cardPuzzleInfo = arg1_2
	arg0_2._deck = arg0_2._cardPuzzleInfo:GetDeck()

	arg0_2._deck:RegisterEventListener(arg0_2, var2_0.UPDATE_CARDS, arg0_2.onUpdateDeckCard)
	arg0_2:onUpdateDeckCard()
end

function var3_0.onUpdateDeckCard(arg0_3, arg1_3)
	setText(arg0_3._deckCountLabel, arg0_3._deck:GetLength())
end

function var3_0.init(arg0_4)
	var0_0.EventListener.AttachEventListener(arg0_4)

	arg0_4._tf = arg0_4._go.transform
	arg0_4._deckCountLabel = arg0_4._tf:Find("count/text")

	setText(arg0_4._tf:Find("label"), i18n("card_puzzle_deck"))
end

function var3_0.Dispose(arg0_5)
	arg0_5._deckCountLabel = nil
	arg0_5._tf = nil
end
