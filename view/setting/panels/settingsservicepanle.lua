local var0 = class("SettingsServicePanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsServiceCH"
end

function var0.GetTitle(arg0)
	return "客服"
end

function var0.GetTitleEn(arg0)
	return "/ Service"
end

function var0.OnInit(arg0)
	arg0.serviceBtn = findTF(arg0._tf, "delete")

	onButton(arg0, arg0.serviceBtn, function()
		pg.SdkMgr.GetInstance():Service()
	end, SFX_PANEL)
end

function var0.OnUpdate(arg0)
	return
end

return var0
