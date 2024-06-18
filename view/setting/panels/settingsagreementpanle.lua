local var0_0 = class("SettingsAgreementPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsAgreement"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_agreement")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / VIEW AGREEMENT"
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("private"), function()
		pg.SdkMgr.GetInstance():ShowPrivate()
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("licence"), function()
		pg.SdkMgr.GetInstance():ShowLicence()
	end, SFX_PANEL)
end

function var0_0.OnUpdate(arg0_7)
	return
end

return var0_0
