local var0_0 = class("SettingsServicePanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsServiceCH"
end

function var0_0.GetTitle(arg0_2)
	return "客服"
end

function var0_0.GetTitleEn(arg0_3)
	return "/ Service"
end

function var0_0.OnInit(arg0_4)
	arg0_4.serviceBtn = findTF(arg0_4._tf, "delete")

	onButton(arg0_4, arg0_4.serviceBtn, function()
		pg.SdkMgr.GetInstance():Service()
	end, SFX_PANEL)
end

function var0_0.OnUpdate(arg0_6)
	return
end

return var0_0
