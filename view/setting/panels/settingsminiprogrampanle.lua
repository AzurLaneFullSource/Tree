local var0_0 = class("SettingsMiniProgramPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsMiniProgramCH"
end

function var0_0.GetTitle(arg0_2)
	return "小程序"
end

function var0_0.GetTitleEn(arg0_3)
	return "/ MiniProgram"
end

function var0_0.OnInit(arg0_4)
	arg0_4.serviceBtn = findTF(arg0_4._tf, "delete")

	onButton(arg0_4, arg0_4.serviceBtn, function()
		pg.SdkMgr.GetInstance():OpenMiniProgram()
	end, SFX_PANEL)
end

function var0_0.OnUpdate(arg0_6)
	return
end

return var0_0
