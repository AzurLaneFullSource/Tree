local var0_0 = class("IslandSettingsCardShowPanel", import("view.Setting.panels.SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "IslandSettingsCardShow"
end

function var0_0.GetTitle(arg0_2)
	return i18n("grapihcs3d_setting_card_title")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / ISLAND CARD SETTINGS"
end

function var0_0.InitTitle(arg0_4)
	setText(arg0_4._tf:Find("title/title_point/title_text"), arg0_4:GetTitle())
end

function var0_0.OnInit(arg0_5)
	arg0_5.labelToggle = arg0_5._tf:Find("options/label/toggle")
	arg0_5.labelToggleCom = arg0_5.labelToggle:GetComponent(typeof(Toggle))

	setText(arg0_5._tf:Find("options/label/mask/Text"), i18n("grapihcs3d_setting_card_tag"))

	arg0_5.socialToggle = arg0_5._tf:Find("options/social/toggle")
	arg0_5.socialToggleCom = arg0_5.socialToggle:GetComponent(typeof(Toggle))

	setText(arg0_5._tf:Find("options/social/mask/Text"), i18n("grapihcs3d_setting_card_socialdata"))
end

function var0_0.OnUpdate(arg0_6)
	local var0_6 = getProxy(IslandProxy):GetIsland():GetSettingsAgency()

	arg0_6.labelFlag = var0_6:GetFlagByType(IslandSettingsAgency.FLAG_TYPES.SHOW_CARD_LABEL)
	arg0_6.socialFlag = var0_6:GetFlagByType(IslandSettingsAgency.FLAG_TYPES.SHOW_CARD_SOCIAL)

	triggerToggle(arg0_6.labelToggle, arg0_6.labelFlag == 1)
	triggerToggle(arg0_6.socialToggle, arg0_6.socialFlag == 1)
end

function var0_0.GetFlags(arg0_7)
	local var0_7 = {}
	local var1_7 = arg0_7.labelToggleCom.isOn and 1 or 0

	table.insert(var0_7, {
		type = IslandSettingsAgency.FLAG_TYPES.SHOW_CARD_LABEL,
		flag = var1_7
	})

	local var2_7 = arg0_7.socialToggleCom.isOn and 1 or 0

	table.insert(var0_7, {
		type = IslandSettingsAgency.FLAG_TYPES.SHOW_CARD_SOCIAL,
		flag = var2_7
	})

	return var0_7
end

return var0_0
