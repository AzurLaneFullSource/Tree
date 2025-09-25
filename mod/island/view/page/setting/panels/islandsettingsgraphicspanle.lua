local var0_0 = class("IslandSettingsGraphicsPanle", import("view.Setting.panels.SettingsBasePanel"))

var0_0.EVT_UPDTAE = "IslandSettingsGraphicsPanle:EVT_UPDTAE"

function var0_0.GetUIName(arg0_1)
	return "IslandSettingsStorySpeed"
end

function var0_0.GetTitle(arg0_2)
	return i18n("grapihcs3d_setting_quality")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / STANDBY MODE SETTINGS"
end

function var0_0.InitTitle(arg0_4)
	setText(arg0_4._tf:Find("title/title_point/title_text"), arg0_4:GetTitle())
end

function var0_0.OnInit(arg0_5)
	local var0_5 = CustomIndexLayer.Clone2Full(arg0_5._tf:Find("speeds"), 4)

	arg0_5.lowToggle = var0_5[1]
	arg0_5.mediumToggle = var0_5[2]
	arg0_5.highToggle = var0_5[3]
	arg0_5.playerToggle = var0_5[4]

	for iter0_5 = 1, 4 do
		onToggle(arg0_5, var0_5[iter0_5], function(arg0_6)
			if arg0_6 then
				if PlayerPrefs.GetInt(GraphicSettingConst.PlayerGraphicLevelIsland, 0) ~= iter0_5 then
					PlayerPrefs.SetInt(GraphicSettingConst.PlayerGraphicLevelIsland, iter0_5)
				end

				pg.m02:sendNotification(IslandSettingsPage.SELECTGRAPHICSETTINGLEVEL)
			end
		end, SFX_UI_TAG, SFX_UI_TAG)
	end

	setText(arg0_5.lowToggle:Find("off/Text"), i18n("grapihcs3d_setting_quality_option_low"))
	setText(arg0_5.lowToggle:Find("on/Text"), i18n("grapihcs3d_setting_quality_option_low"))
	setText(arg0_5.mediumToggle:Find("off/Text"), i18n("grapihcs3d_setting_quality_option_medium"))
	setText(arg0_5.mediumToggle:Find("on/Text"), i18n("grapihcs3d_setting_quality_option_medium"))
	setText(arg0_5.highToggle:Find("off/Text"), i18n("grapihcs3d_setting_quality_option_high"))
	setText(arg0_5.highToggle:Find("on/Text"), i18n("grapihcs3d_setting_quality_option_high"))
	setText(arg0_5.playerToggle:Find("off/Text"), i18n("grapihcs3d_setting_quality_option_custom"))
	setText(arg0_5.playerToggle:Find("on/Text"), i18n("grapihcs3d_setting_quality_option_custom"))
end

function var0_0.OnUpdate(arg0_7)
	local var0_7 = PlayerPrefs.GetInt(GraphicSettingConst.PlayerGraphicLevelIsland, 2)

	if var0_7 == 1 then
		triggerToggle(arg0_7.lowToggle, true)
	elseif var0_7 == 2 then
		triggerToggle(arg0_7.mediumToggle, true)
	elseif var0_7 == 3 then
		triggerToggle(arg0_7.highToggle, true)
	else
		triggerToggle(arg0_7.playerToggle, true)
	end
end

return var0_0
