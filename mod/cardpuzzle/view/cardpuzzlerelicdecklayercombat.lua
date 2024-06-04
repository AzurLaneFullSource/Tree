local var0 = class("CardPuzzleRelicDeckLayerCombat", CardPuzzleRelicDeckLayer)

function var0.getUIName(arg0)
	return "CardTowerGiftDeckCombat"
end

function var0.init(arg0)
	var0.super.init(arg0)
	onButton(arg0, arg0:findTF("backBtn"), function()
		arg0:OnBackward()
	end, SFX_PANEL)
end

function var0.OnBackward(arg0)
	arg0:emit(CardPuzzleCardDeckMediator.CLOSE_LAYER)

	return var0.super.OnBackward(arg0)
end

function var0.willExit(arg0)
	return
end

return var0
