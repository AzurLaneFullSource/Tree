local var0 = class("SettingsSoundPanle", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsSound"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_sound")
end

function var0.GetTitleEn(arg0)
	return "  / VOICE SETTINGS"
end

function var0.OnInit(arg0)
	arg0.bgmSlider = arg0._tf:Find("settings/bgm/slider")
	arg0.effectSlider = arg0._tf:Find("settings/sfx/slider")
	arg0.mainSlider = arg0._tf:Find("settings/cv/slider")
	arg0.soundRevertBtn = arg0._tf:Find("settings/buttons/reset")
	arg0.volumeSwitchToggleOn = arg0._tf:Find("settings/buttons/soundswitch/on")
	arg0.volumeSwitchToggleOff = arg0._tf:Find("settings/buttons/soundswitch/off")
	arg0.isMute = PlayerPrefs.GetInt("mute_audio", 0) == 1

	triggerToggle(arg0.volumeSwitchToggleOn, not arg0.isMute)
	triggerToggle(arg0.volumeSwitchToggleOff, arg0.isMute)
	onToggle(arg0, arg0.volumeSwitchToggleOn, function(arg0)
		arg0:OnVolumeSwitch(arg0)
	end, SFX_UI_TAG, SFX_UI_TAG)
	onButton(arg0, arg0.soundRevertBtn, function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("sure_resume_volume"),
			onYes = function()
				triggerToggle(arg0.volumeSwitchToggleOn, true)
				setSlider(arg0.bgmSlider, 0, 1, DEFAULT_BGMVOLUME)
				setSlider(arg0.effectSlider, 0, 1, DEFAULT_SEVOLUME)
				setSlider(arg0.mainSlider, 0, 1, DEFAULT_CVVOLUME)
			end
		})
	end, SFX_UI_CLICK)
	setText(arg0._tf:Find("settings/buttons/soundswitch/Text"), i18n("voice_control"))
	setText(arg0._tf:Find("settings/bgm/icon/Text"), i18n("settings_sound_title_bgm"))
	setText(arg0._tf:Find("settings/sfx/icon/Text"), i18n("settings_sound_title_effct"))
	setText(arg0._tf:Find("settings/cv/icon/Text"), i18n("settings_sound_title_cv"))
end

function var0.OnVolumeSwitch(arg0, arg1)
	if not arg1 then
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

	arg0.isMute = not arg1

	arg0:UpdateSlidersState()
end

function var0.InitBgmSlider(arg0)
	local var0 = pg.CriMgr.GetInstance():getBGMVolume()

	if arg0.isMute then
		var0 = PlayerPrefs.GetFloat("bgm_vol_mute_setting", DEFAULT_BGMVOLUME)
	end

	setSlider(arg0.bgmSlider, 0, 1, var0)
	OnSliderWithButton(arg0, arg0.bgmSlider, function(arg0)
		if arg0.isMute then
			return
		end

		pg.CriMgr.GetInstance():setBGMVolume(arg0)
	end)
end

function var0.InitEffectSlider(arg0)
	local var0 = pg.CriMgr.GetInstance():getSEVolume()

	if arg0.isMute then
		var0 = PlayerPrefs.GetFloat("se_vol_mute_setting", DEFAULT_SEVOLUME)
	end

	setSlider(arg0.effectSlider, 0, 1, var0)
	OnSliderWithButton(arg0, arg0.effectSlider, function(arg0)
		if arg0.isMute then
			return
		end

		pg.CriMgr.GetInstance():setSEVolume(arg0)
	end)
end

function var0.InitMainSlider(arg0)
	local var0 = pg.CriMgr.GetInstance():getCVVolume()

	if arg0.isMute then
		var0 = PlayerPrefs.GetFloat("cv_vol_mute_setting", DEFAULT_CVVOLUME)
	end

	setSlider(arg0.mainSlider, 0, 1, var0)
	OnSliderWithButton(arg0, arg0.mainSlider, function(arg0)
		if arg0.isMute then
			return
		end

		pg.CriMgr.GetInstance():setCVVolume(arg0)
	end)
end

function var0.OnUpdate(arg0)
	arg0:InitBgmSlider()
	arg0:InitEffectSlider()
	arg0:InitMainSlider()
	arg0:UpdateSlidersState()
end

function var0.UpdateSlidersState(arg0)
	local var0 = arg0.isMute

	arg0:SetSliderEnable(arg0.bgmSlider, not var0)
	arg0:SetSliderEnable(arg0.effectSlider, not var0)
	arg0:SetSliderEnable(arg0.mainSlider, not var0)
end

function var0.SetSliderEnable(arg0, arg1, arg2)
	arg2 = tobool(arg2)
	arg1:GetComponent("Slider").interactable = arg2

	setButtonEnabled(arg1:Find("up"), arg2)
	setButtonEnabled(arg1:Find("down"), arg2)
end

return var0
