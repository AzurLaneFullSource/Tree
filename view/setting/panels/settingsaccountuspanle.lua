local var0_0 = class("SettingsAccountUSPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsAccountUS"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_LoginJP")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / ACCOUNT"
end

function var0_0.OnInit(arg0_4)
	arg0_4.userProxy = getProxy(UserProxy)

	local var0_4 = arg0_4._tf

	arg0_4.accountTwitterUI = findTF(var0_4, "page1")

	local var1_4 = findTF(arg0_4.accountTwitterUI, "btn_layout/yostar_con")

	arg0_4.yostarBtn = findTF(var1_4, "bind_yostar")

	setText(findTF(arg0_4.yostarBtn, "Text"), "Account Management")
	arg0_4:OnRegisterEvent()
end

function var0_0.OnRegisterEvent(arg0_5)
	onButton(arg0_5, arg0_5.yostarBtn, function()
		pg.SdkMgr.GetInstance():YoStarShowUserCenter()
	end)
end

function var0_0.OnUpdate(arg0_7)
	return
end

return var0_0
