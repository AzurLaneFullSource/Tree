local var0_0 = class("IslandSettingsAdjustScreenPanle", import("view.Setting.panels.SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "IslandSettingsAdjustScreen"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_AdjustScr")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / SCREEN SETTING"
end

function var0_0.InitTitle(arg0_4)
	setText(arg0_4._tf:Find("title/title_point/title_text"), arg0_4:GetTitle())
end

function var0_0.OnInit(arg0_5)
	arg0_5.notchSlider = findTF(arg0_5._tf, "slider")
end

function var0_0.OnUpdate(arg0_6)
	local var0_6 = getProxy(SettingsProxy)
	local var1_6 = math.clamp(Screen.width / Screen.height - 0.001, 1.33333333333333, 2.33333333333333)

	setSlider(arg0_6.notchSlider, ADAPT_MIN, var1_6, var0_6:GetScreenRatio())
	OnSliderWithButton(arg0_6, arg0_6.notchSlider, function(arg0_7)
		var0_6:SetScreenRatio(arg0_7)

		NotchAdapt.CheckNotchRatio = arg0_7
	end)
end

return var0_0
