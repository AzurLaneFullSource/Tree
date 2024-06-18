local var0_0 = class("SettingsAccountCHPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsAccountCH"
end

function var0_0.GetTitle(arg0_2)
	return "注销账户"
end

function var0_0.GetTitleEn(arg0_3)
	return "/ Account Deactivation"
end

function var0_0.OnInit(arg0_4)
	onButton(arg0_4, findTF(arg0_4._tf, "delete"), function()
		pg.SdkMgr.GetInstance():DeleteAccount()
	end, SFX_PANEL)
end

return var0_0
