local var0 = class("SettingsAccountCHPanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsAccountCH"
end

function var0.GetTitle(arg0)
	return "注销账户"
end

function var0.GetTitleEn(arg0)
	return "/ Account Deactivation"
end

function var0.OnInit(arg0)
	onButton(arg0, findTF(arg0._tf, "delete"), function()
		pg.SdkMgr.GetInstance():DeleteAccount()
	end, SFX_PANEL)
end

return var0
