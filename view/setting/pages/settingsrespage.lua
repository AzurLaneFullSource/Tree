local var0 = class("SettingsResPage", import(".SettingsOptionPage"))

function var0.getUIName(arg0)
	return "SettingsCombinationWithBgPage"
end

function var0.GetPanels(arg0)
	return {
		SettingsSoundPanle,
		SettingsResUpdatePanel
	}
end

return var0
