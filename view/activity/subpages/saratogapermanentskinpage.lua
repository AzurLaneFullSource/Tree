local var0_0 = class("SaratogaPermanentSkinPage", import(".TemplatePage.PtTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	onButton(arg0_1, arg0_1.battleBtn, function()
		arg0_1:emit(ActivityMediator.SPECIAL_BATTLE_OPERA)
	end, SFX_PANEL)

	local var0_1, var1_1, var2_1 = arg0_1.ptData:GetResProgress()

	setText(arg0_1.progress, setColorStr(var0_1, "#FF8DB5") .. "/" .. var1_1)
	setText(arg0_1.bg:Find("Text"), i18n("activity_kill"))
end

return var0_0
