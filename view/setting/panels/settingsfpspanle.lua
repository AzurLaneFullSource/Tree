local var0 = class("SettingsFpsPanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsFPS"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_FPS")
end

function var0.GetTitleEn(arg0)
	return "  / FPS SETTING"
end

function var0.OnInit(arg0)
	arg0.fps30Toggle = arg0._tf:Find("options/30fps")
	arg0.fps60Toggle = arg0._tf:Find("options/60fps")

	onToggle(arg0, arg0.fps30Toggle, function(arg0)
		if arg0 then
			QualitySettings.vSyncCount = 0

			PlayerPrefs.SetInt("fps_limit", 30)

			Application.targetFrameRate = 30
		end
	end, SFX_UI_TAG, SFX_UI_TAG)
	onToggle(arg0, arg0.fps60Toggle, function(arg0)
		if arg0 then
			QualitySettings.vSyncCount = 0

			PlayerPrefs.SetInt("fps_limit", 60)

			Application.targetFrameRate = 60
		end
	end, SFX_UI_TAG, SFX_UI_TAG)
	setText(arg0._tf:Find("options/30fps/Text"), "30" .. i18n("word_frame"))
	setText(arg0._tf:Find("options/60fps/Text"), "60" .. i18n("word_frame"))
end

function var0.OnUpdate(arg0)
	local var0 = PlayerPrefs.GetInt("fps_limit", DevicePerformanceUtil.GetDefaultFps())

	if var0 == 30 then
		triggerToggle(arg0.fps30Toggle, true)
	end

	if var0 == 60 then
		triggerToggle(arg0.fps60Toggle, true)
	end
end

return var0
