local var0 = class("SettingsAgreementPanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsAgreement"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_agreement")
end

function var0.GetTitleEn(arg0)
	return "  / VIEW AGREEMENT"
end

function var0.OnInit(arg0)
	onButton(arg0, arg0._tf:Find("private"), function()
		pg.SdkMgr.GetInstance():ShowPrivate()
	end, SFX_PANEL)
	onButton(arg0, arg0._tf:Find("licence"), function()
		pg.SdkMgr.GetInstance():ShowLicence()
	end, SFX_PANEL)
end

function var0.OnUpdate(arg0)
	return
end

return var0
