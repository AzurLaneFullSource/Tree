local var0_0 = class("IslandSettingsEscapePanel", import("view.Setting.panels.SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "IslandSettingsEscape"
end

function var0_0.GetTitle(arg0_2)
	return i18n("grapihcs3d_setting_common_title")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / "
end

function var0_0.InitTitle(arg0_4)
	setText(arg0_4._tf:Find("title/title_point/title_text"), arg0_4:GetTitle())
end

function var0_0.OnInit(arg0_5)
	arg0_5.escapeBtn = arg0_5._tf:Find("options/escape/btn")

	setText(arg0_5._tf:Find("options/escape/mask/Text"), i18n("grapihcs3d_setting_common_unstuck"))
	setText(arg0_5._tf:Find("options/escape/btn/Text"), i18n("grapihcs3d_setting_common_use"))
	onButton(arg0_5, arg0_5.escapeBtn, function()
		pg.m02:sendNotification(GAME.ISLAND_RESET_SP)
	end, SFX_PANEL)
end

function var0_0.GetFlags(arg0_7)
	return {}
end

return var0_0
