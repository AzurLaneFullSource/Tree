local var0 = class("SettingsAgreementCHTPanle", import(".SettingsAgreementPanle"))

function var0.OnInit(arg0)
	local var0 = arg0._tf:Find("private")

	onButton(arg0, var0, function()
		pg.UserAgreementMgr.GetInstance():ShowChtPrivate()
	end, SFX_PANEL)

	local var1 = arg0._tf:Find("licence")

	onButton(arg0, var1, function()
		pg.UserAgreementMgr.GetInstance():ShowChtLicence()
	end, SFX_PANEL)
	setText(var0:Find("Text"), i18n("setting_label_private"))
	setText(var1:Find("Text"), i18n("setting_label_licence"))
end

return var0
