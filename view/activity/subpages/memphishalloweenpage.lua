local var0 = class("MemphisHalloweenPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)
end

return var0
