local var0_0 = class("SettingsAgreementCHTPanle", import(".SettingsAgreementPanle"))

function var0_0.OnInit(arg0_1)
	local var0_1 = arg0_1._tf:Find("private")

	onButton(arg0_1, var0_1, function()
		pg.UserAgreementMgr.GetInstance():ShowChtPrivate()
	end, SFX_PANEL)

	local var1_1 = arg0_1._tf:Find("licence")

	onButton(arg0_1, var1_1, function()
		pg.UserAgreementMgr.GetInstance():ShowChtLicence()
	end, SFX_PANEL)
	setText(var0_1:Find("Text"), i18n("setting_label_private"))
	setText(var1_1:Find("Text"), i18n("setting_label_licence"))
end

return var0_0
