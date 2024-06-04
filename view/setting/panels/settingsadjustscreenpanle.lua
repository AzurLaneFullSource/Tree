local var0 = class("SettingsAdjustScreenPanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsAdjustScreen"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_AdjustScr")
end

function var0.GetTitleEn(arg0)
	return "  / SCREEN SETTING"
end

function var0.OnInit(arg0)
	arg0.notchSlider = findTF(arg0._tf, "slider")
end

function var0.OnUpdate(arg0)
	local var0 = getProxy(SettingsProxy)
	local var1 = Screen.width / Screen.height - 0.001

	setSlider(arg0.notchSlider, ADAPT_MIN, var1, var0:GetScreenRatio())
	OnSliderWithButton(arg0, arg0.notchSlider, function(arg0)
		var0:SetScreenRatio(arg0)

		NotchAdapt.CheckNotchRatio = arg0

		NotchAdapt.AdjustUI()
	end)
end

return var0
