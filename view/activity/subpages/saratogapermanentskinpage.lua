local var0 = class("SaratogaPermanentSkinPage", import(".TemplatePage.PtTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	onButton(arg0, arg0.battleBtn, function()
		arg0:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)

	local var0, var1, var2 = arg0.ptData:GetResProgress()

	setText(arg0.progress, setColorStr(var0, "#FF8DB5") .. "/" .. var1)
	setText(arg0.bg:Find("Text"), i18n("activity_kill"))
end

return var0
