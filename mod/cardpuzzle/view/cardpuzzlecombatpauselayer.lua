local var0_0 = class("CardPuzzleCombatPauseLayer", BaseUI)

function var0_0.getUIName(arg0_1)
	return "CardTowerCombatPause"
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)
	onButton(arg0_2, arg0_2:findTF("btn_quit"), function()
		arg0_2:emit(CardPuzzleCombatPauseMediator.QUIT_COMBAT, {})
	end, SFX_PANEL)
	onButton(arg0_2, arg0_2:findTF("btn_resume"), function()
		arg0_2:OnBackward()
	end, SFX_PANEL)
end

function var0_0.OnBackward(arg0_5)
	arg0_5:emit(CardPuzzleCombatPauseMediator.RESUME_COMBAT)
	arg0_5:closeView()

	return true
end

function var0_0.willExit(arg0_6)
	return
end

return var0_0
