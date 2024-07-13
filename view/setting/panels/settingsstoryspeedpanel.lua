local var0_0 = class("SettingsStorySpeedPanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsStorySpeed"
end

function var0_0.GetTitle(arg0_2)
	return i18n("story_setting_label")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / AUTO SPEED"
end

function var0_0.OnInit(arg0_4)
	local var0_4 = arg0_4._tf:Find("speeds")

	arg0_4.btns = {}

	for iter0_4 = 1, var0_4.childCount do
		local var1_4 = var0_4:GetChild(iter0_4 - 1)

		onToggle(arg0_4, var1_4, function(arg0_5)
			if arg0_5 then
				local var0_5 = Story.STORY_AUTO_SPEED[iter0_4]

				getProxy(SettingsProxy):SetStorySpeed(var0_5)
			end
		end, SFX_PANEL)
		setText(var1_4:Find("Text"), i18n("setting_story_speed_" .. iter0_4))

		arg0_4.btns[iter0_4] = var1_4
	end
end

function var0_0.OnUpdate(arg0_6)
	local var0_6 = getProxy(SettingsProxy):GetStorySpeed()
	local var1_6 = table.indexof(Story.STORY_AUTO_SPEED, var0_6) or 2

	triggerToggle(arg0_6.btns[var1_6], true)
end

return var0_0
