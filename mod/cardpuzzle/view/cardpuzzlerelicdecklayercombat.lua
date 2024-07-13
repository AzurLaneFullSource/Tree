local var0_0 = class("CardPuzzleRelicDeckLayerCombat", CardPuzzleRelicDeckLayer)

function var0_0.getUIName(arg0_1)
	return "CardTowerGiftDeckCombat"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
	onButton(arg0_2, arg0_2:findTF("backBtn"), function()
		arg0_2:OnBackward()
	end, SFX_PANEL)
end

function var0_0.OnBackward(arg0_4)
	arg0_4:emit(CardPuzzleCardDeckMediator.CLOSE_LAYER)

	return var0_0.super.OnBackward(arg0_4)
end

function var0_0.willExit(arg0_5)
	return
end

return var0_0
