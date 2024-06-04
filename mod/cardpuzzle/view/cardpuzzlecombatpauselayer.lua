local var0 = class("CardPuzzleCombatPauseLayer", BaseUI)

function var0.getUIName(arg0)
	return "CardTowerCombatPause"
end

function var0.init(arg0)
	var0.super.init(arg0)
	onButton(arg0, arg0:findTF("btn_quit"), function()
		arg0:emit(CardPuzzleCombatPauseMediator.QUIT_COMBAT, {})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("btn_resume"), function()
		arg0:OnBackward()
	end, SFX_PANEL)
end

function var0.OnBackward(arg0)
	arg0:emit(CardPuzzleCombatPauseMediator.RESUME_COMBAT)
	arg0:closeView()

	return true
end

function var0.willExit(arg0)
	return
end

return var0
