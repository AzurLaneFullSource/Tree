local var0_0 = class("SettingsGraphicsPanle", import(".SettingsBasePanel"))

var0_0.EVT_UPDTAE = "SettingsGraphicsPanle:EVT_UPDTAE"

function var0_0.GetUIName(arg0_1)
	return "SettingsStorySpeed"
end

function var0_0.GetTitle(arg0_2)
	return i18n("grapihcs3d_setting_quality")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / STANDBY MODE SETTINGS"
end

function var0_0.OnInit(arg0_4)
	local var0_4 = CustomIndexLayer.Clone2Full(arg0_4._tf:Find("speeds"), 4)

	arg0_4.lowToggle = var0_4[1]
	arg0_4.mediumToggle = var0_4[2]
	arg0_4.highToggle = var0_4[3]
	arg0_4.playerToggle = var0_4[4]

	for iter0_4 = 1, 4 do
		onToggle(arg0_4, var0_4[iter0_4], function(arg0_5)
			if arg0_5 then
				if PlayerPrefs.GetInt("dorm3d_graphics_settings", 0) ~= iter0_4 then
					pg.m02:sendNotification(GAME.APARTMENT_TRACK, Dorm3dTrackCommand.BuildDataGraphics(iter0_4))
					PlayerPrefs.SetInt("dorm3d_graphics_settings", iter0_4)
				end

				pg.m02:sendNotification(NewSettingsMediator.SelectGraphicSettingLevel)
			end
		end, SFX_UI_TAG, SFX_UI_TAG)
	end

	setText(arg0_4.lowToggle:Find("Text"), i18n("grapihcs3d_setting_quality_option_low"))
	setText(arg0_4.mediumToggle:Find("Text"), i18n("grapihcs3d_setting_quality_option_medium"))
	setText(arg0_4.highToggle:Find("Text"), i18n("grapihcs3d_setting_quality_option_high"))
	setText(arg0_4.playerToggle:Find("Text"), i18n("grapihcs3d_setting_quality_option_custom"))
end

function var0_0.OnUpdate(arg0_6)
	local var0_6 = PlayerPrefs.GetInt("dorm3d_graphics_settings", 2)

	if var0_6 == 1 then
		triggerToggle(arg0_6.lowToggle, true)
	elseif var0_6 == 2 then
		triggerToggle(arg0_6.mediumToggle, true)
	elseif var0_6 == 3 then
		triggerToggle(arg0_6.highToggle, true)
	else
		triggerToggle(arg0_6.playerToggle, true)
	end
end

return var0_0
