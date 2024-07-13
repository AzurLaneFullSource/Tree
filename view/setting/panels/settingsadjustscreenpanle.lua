local var0_0 = class("SettingsAdjustScreenPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsAdjustScreen"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_AdjustScr")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / SCREEN SETTING"
end

function var0_0.OnInit(arg0_4)
	arg0_4.notchSlider = findTF(arg0_4._tf, "slider")
end

function var0_0.OnUpdate(arg0_5)
	local var0_5 = getProxy(SettingsProxy)
	local var1_5 = Screen.width / Screen.height - 0.001

	setSlider(arg0_5.notchSlider, ADAPT_MIN, var1_5, var0_5:GetScreenRatio())
	OnSliderWithButton(arg0_5, arg0_5.notchSlider, function(arg0_6)
		var0_5:SetScreenRatio(arg0_6)

		NotchAdapt.CheckNotchRatio = arg0_6

		NotchAdapt.AdjustUI()
	end)
end

return var0_0
