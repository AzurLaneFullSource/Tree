local var0_0 = class("SettingsFpsPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsFPS"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_FPS")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / FPS SETTING"
end

function var0_0.OnInit(arg0_4)
	arg0_4.fps30Toggle = arg0_4._tf:Find("options/30fps")
	arg0_4.fps60Toggle = arg0_4._tf:Find("options/60fps")

	onToggle(arg0_4, arg0_4.fps30Toggle, function(arg0_5)
		if arg0_5 then
			QualitySettings.vSyncCount = 0

			PlayerPrefs.SetInt("fps_limit", 30)

			Application.targetFrameRate = 30
		end
	end, SFX_UI_TAG, SFX_UI_TAG)
	onToggle(arg0_4, arg0_4.fps60Toggle, function(arg0_6)
		if arg0_6 then
			QualitySettings.vSyncCount = 0

			PlayerPrefs.SetInt("fps_limit", 60)

			Application.targetFrameRate = 60
		end
	end, SFX_UI_TAG, SFX_UI_TAG)
	setText(arg0_4._tf:Find("options/30fps/Text"), "30" .. i18n("word_frame"))
	setText(arg0_4._tf:Find("options/60fps/Text"), "60" .. i18n("word_frame"))
end

function var0_0.OnUpdate(arg0_7)
	local var0_7 = PlayerPrefs.GetInt("fps_limit", DevicePerformanceUtil.GetDefaultFps())

	if var0_7 == 30 then
		triggerToggle(arg0_7.fps30Toggle, true)
	end

	if var0_7 == 60 then
		triggerToggle(arg0_7.fps60Toggle, true)
	end
end

return var0_0
