local var0_0 = class("SettingsResPage", import(".SettingsOptionPage"))

function var0_0.getUIName(arg0_1)
	return "SettingsCombinationWithBgPage"
end

function var0_0.GetPanels(arg0_2)
	return {
		SettingsSoundPanle,
		SettingsResUpdatePanel
	}
end

return var0_0
