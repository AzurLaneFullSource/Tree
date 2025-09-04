local var0_0 = class("SettingsMapBtn", import(".SettingsDownloadableBtn"))

function var0_0.GetDownloadGroup(arg0_1)
	return "MAP"
end

function var0_0.GetTitle(arg0_2)
	return i18n("setting_resdownload_title_map")
end

return var0_0
