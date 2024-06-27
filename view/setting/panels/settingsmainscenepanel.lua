local var0_0 = class("SettingsMainScenePanel", import(".SettingsBasePanel"))

var0_0.STANDBY_MODE_KEY = "STANDBY_MODE_KEY"
var0_0.FLAGSHIP_INTERACTION_KEY = "FLAGSHIP_INTERACTION_KEY"

local var1_0 = var0_0.STANDBY_MODE_KEY
local var2_0 = "TIME_SYSTEM_KEY"
local var3_0 = var0_0.FLAGSHIP_INTERACTION_KEY
local var4_0 = "ENTER_STANDBY_MODE_TIME"
local var5_0 = {
	[0] = 60,
	180,
	600
}

function var0_0.IsEnableStandbyMode()
	return var0_0.GetIntegerCache(var1_0) == 1
end

function var0_0.IsEnable24HourSystem()
	return var0_0.GetIntegerCache(var2_0) == 1
end

function var0_0.IsEnableFlagShipInteraction()
	return var0_0.GetIntegerCache(var3_0) == 1
end

function var0_0.GetEnterFlagShipValue()
	return (var0_0.GetIntegerCache(var4_0))
end

function var0_0.GetEnterFlagShipTime()
	local var0_5 = var0_0.GetEnterFlagShipValue()

	return var5_0[var0_5] or 60
end

function var0_0.GetUIName(arg0_6)
	return "SettingsMainScene"
end

function var0_0.GetTitle(arg0_7)
	return i18n("main_scene_settings")
end

function var0_0.GetTitleEn(arg0_8)
	return "   / STANDBY MODE SETTINGS"
end

function var0_0.OnInit(arg0_9)
	arg0_9.subToggles = {}

	arg0_9:InitTimeSystemToggle()
	arg0_9:InitFlagShipInteractionToggle()
	arg0_9:InitEnterStandbyModeTime()
	arg0_9:InitStandbyModeToggle()
end

function var0_0.CommonToggleSetting(arg0_10, arg1_10, arg2_10, arg3_10, arg4_10, arg5_10)
	setScrollText(arg1_10:Find("mask/Text"), arg3_10)

	local var0_10 = arg1_10:Find("on")
	local var1_10 = arg1_10:Find("off")

	if arg4_10 then
		if arg5_10 then
			arg5_10(true)
		end

		triggerToggle(var0_10, true)
	else
		if arg5_10 then
			arg5_10(false)
		end

		triggerToggle(var1_10, true)
	end

	onToggle(arg0_10, var0_10, function(arg0_11)
		if arg0_11 then
			var0_0.SetIntegerCache(arg2_10, 1)

			if arg5_10 then
				arg5_10(true)
			end
		end
	end, SFX_PANEL)
	onToggle(arg0_10, var1_10, function(arg0_12)
		if arg0_12 then
			var0_0.SetIntegerCache(arg2_10, 0)

			if arg5_10 then
				arg5_10(false)
			end
		end
	end, SFX_PANEL)
end

function var0_0.InitStandbyModeToggle(arg0_13)
	local var0_13 = arg0_13._tf:Find("options/1")

	arg0_13:CommonToggleSetting(var0_13, var1_0, i18n("settings_enable_standby_mode"), var0_0.IsEnableStandbyMode(), function(arg0_14)
		arg0_13:EnableOrDisableSubToggles(arg0_14)
	end)
end

function var0_0.EnableOrDisableSubToggles(arg0_15, arg1_15)
	for iter0_15, iter1_15 in ipairs(arg0_15.subToggles) do
		local var0_15 = GetOrAddComponent(iter1_15, typeof(CanvasGroup))

		var0_15.alpha = arg1_15 and 1 or 0.7
		var0_15.blocksRaycasts = arg1_15
	end
end

function var0_0.InitTimeSystemToggle(arg0_16)
	local var0_16 = arg0_16._tf:Find("options/2")

	arg0_16:CommonToggleSetting(var0_16, var2_0, i18n("settings_time_system"), var0_0.IsEnable24HourSystem())
	table.insert(arg0_16.subToggles, var0_16)
end

function var0_0.InitFlagShipInteractionToggle(arg0_17)
	local var0_17 = arg0_17._tf:Find("options/3")

	arg0_17:CommonToggleSetting(var0_17, var3_0, i18n("settings_flagship_interaction"), var0_0.IsEnableFlagShipInteraction())
	table.insert(arg0_17.subToggles, var0_17)
end

function var0_0.InitEnterStandbyModeTime(arg0_18)
	local var0_18 = arg0_18._tf:Find("time")

	setScrollText(var0_18:Find("notify_tpl/mask/Text"), i18n("settings_enter_standby_mode_time"))

	local var1_18 = {
		[0] = var0_18:Find("notify_tpl/1"),
		var0_18:Find("notify_tpl/2"),
		(var0_18:Find("notify_tpl/3"))
	}

	table.insert(arg0_18.subToggles, var0_18)

	local var2_18 = var1_18[var0_0.GetEnterFlagShipValue()]

	if var2_18 then
		triggerToggle(var2_18, true)
	end

	for iter0_18, iter1_18 in pairs(var1_18) do
		onToggle(arg0_18, iter1_18, function(arg0_19)
			if arg0_19 then
				var0_0.SetIntegerCache(var4_0, iter0_18)
			end
		end, SFX_PANEL)
	end
end

function var0_0.SetIntegerCache(arg0_20, arg1_20)
	local var0_20 = arg0_20 .. "_" .. getProxy(PlayerProxy):getRawData().id

	PlayerPrefs.SetInt(var0_20, arg1_20)
	PlayerPrefs.Save()
end

function var0_0.GetIntegerCache(arg0_21)
	local var0_21 = arg0_21 .. "_" .. getProxy(PlayerProxy):getRawData().id

	return (PlayerPrefs.GetInt(var0_21, 0))
end

return var0_0
