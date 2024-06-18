local var0_0 = class("SettingsSoundPanle", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsSound"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_sound")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / VOICE SETTINGS"
end

function var0_0.OnInit(arg0_4)
	arg0_4.bgmSlider = arg0_4._tf:Find("settings/bgm/slider")
	arg0_4.effectSlider = arg0_4._tf:Find("settings/sfx/slider")
	arg0_4.mainSlider = arg0_4._tf:Find("settings/cv/slider")
	arg0_4.soundRevertBtn = arg0_4._tf:Find("settings/buttons/reset")
	arg0_4.volumeSwitchToggleOn = arg0_4._tf:Find("settings/buttons/soundswitch/on")
	arg0_4.volumeSwitchToggleOff = arg0_4._tf:Find("settings/buttons/soundswitch/off")
	arg0_4.isMute = PlayerPrefs.GetInt("mute_audio", 0) == 1

	triggerToggle(arg0_4.volumeSwitchToggleOn, not arg0_4.isMute)
	triggerToggle(arg0_4.volumeSwitchToggleOff, arg0_4.isMute)
	onToggle(arg0_4, arg0_4.volumeSwitchToggleOn, function(arg0_5)
		arg0_4:OnVolumeSwitch(arg0_5)
	end, SFX_UI_TAG, SFX_UI_TAG)
	onButton(arg0_4, arg0_4.soundRevertBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("sure_resume_volume"),
			onYes = function()
				triggerToggle(arg0_4.volumeSwitchToggleOn, true)
				setSlider(arg0_4.bgmSlider, 0, 1, DEFAULT_BGMVOLUME)
				setSlider(arg0_4.effectSlider, 0, 1, DEFAULT_SEVOLUME)
				setSlider(arg0_4.mainSlider, 0, 1, DEFAULT_CVVOLUME)
			end
		})
	end, SFX_UI_CLICK)
	setText(arg0_4._tf:Find("settings/buttons/soundswitch/Text"), i18n("voice_control"))
	setText(arg0_4._tf:Find("settings/bgm/icon/Text"), i18n("settings_sound_title_bgm"))
	setText(arg0_4._tf:Find("settings/sfx/icon/Text"), i18n("settings_sound_title_effct"))
	setText(arg0_4._tf:Find("settings/cv/icon/Text"), i18n("settings_sound_title_cv"))
end

function var0_0.OnVolumeSwitch(arg0_8, arg1_8)
	if not arg1_8 then
		PlayerPrefs.SetFloat("bgm_vol_mute_setting", pg.CriMgr.GetInstance():getBGMVolume())
		PlayerPrefs.SetFloat("se_vol_mute_setting", pg.CriMgr.GetInstance():getSEVolume())
		PlayerPrefs.SetFloat("cv_vol_mute_setting", pg.CriMgr.GetInstance():getCVVolume())
		pg.CriMgr.GetInstance():setBGMVolume(0)
		pg.CriMgr.GetInstance():setSEVolume(0)
		pg.CriMgr.GetInstance():setCVVolume(0)
		PlayerPrefs.SetInt("mute_audio", 1)
	else
		pg.CriMgr.GetInstance():setBGMVolume(PlayerPrefs.GetFloat("bgm_vol_mute_setting", DEFAULT_BGMVOLUME))
		pg.CriMgr.GetInstance():setSEVolume(PlayerPrefs.GetFloat("se_vol_mute_setting", DEFAULT_SEVOLUME))
		pg.CriMgr.GetInstance():setCVVolume(PlayerPrefs.GetFloat("cv_vol_mute_setting", DEFAULT_CVVOLUME))
		PlayerPrefs.SetInt("mute_audio", 0)
	end

	arg0_8.isMute = not arg1_8

	arg0_8:UpdateSlidersState()
end

function var0_0.InitBgmSlider(arg0_9)
	local var0_9 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0_9.isMute then
		var0_9 = PlayerPrefs.GetFloat("bgm_vol_mute_setting", DEFAULT_BGMVOLUME)
	end

	setSlider(arg0_9.bgmSlider, 0, 1, var0_9)
	OnSliderWithButton(arg0_9, arg0_9.bgmSlider, function(arg0_10)
		if arg0_9.isMute then
			return
		end

		pg.CriMgr.GetInstance():setBGMVolume(arg0_10)
	end)
end

function var0_0.InitEffectSlider(arg0_11)
	local var0_11 = pg.CriMgr.GetInstance():getSEVolume()

	if arg0_11.isMute then
		var0_11 = PlayerPrefs.GetFloat("se_vol_mute_setting", DEFAULT_SEVOLUME)
	end

	setSlider(arg0_11.effectSlider, 0, 1, var0_11)
	OnSliderWithButton(arg0_11, arg0_11.effectSlider, function(arg0_12)
		if arg0_11.isMute then
			return
		end

		pg.CriMgr.GetInstance():setSEVolume(arg0_12)
	end)
end

function var0_0.InitMainSlider(arg0_13)
	local var0_13 = pg.CriMgr.GetInstance():getCVVolume()

	if arg0_13.isMute then
		var0_13 = PlayerPrefs.GetFloat("cv_vol_mute_setting", DEFAULT_CVVOLUME)
	end

	setSlider(arg0_13.mainSlider, 0, 1, var0_13)
	OnSliderWithButton(arg0_13, arg0_13.mainSlider, function(arg0_14)
		if arg0_13.isMute then
			return
		end

		pg.CriMgr.GetInstance():setCVVolume(arg0_14)
	end)
end

function var0_0.OnUpdate(arg0_15)
	arg0_15:InitBgmSlider()
	arg0_15:InitEffectSlider()
	arg0_15:InitMainSlider()
	arg0_15:UpdateSlidersState()
end

function var0_0.UpdateSlidersState(arg0_16)
	local var0_16 = arg0_16.isMute

	arg0_16:SetSliderEnable(arg0_16.bgmSlider, not var0_16)
	arg0_16:SetSliderEnable(arg0_16.effectSlider, not var0_16)
	arg0_16:SetSliderEnable(arg0_16.mainSlider, not var0_16)
end

function var0_0.SetSliderEnable(arg0_17, arg1_17, arg2_17)
	arg2_17 = tobool(arg2_17)
	arg1_17:GetComponent("Slider").interactable = arg2_17

	setButtonEnabled(arg1_17:Find("up"), arg2_17)
	setButtonEnabled(arg1_17:Find("down"), arg2_17)
end

return var0_0
