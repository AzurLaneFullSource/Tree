local var0 = class("SettingsStorySpeedPanel", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsStorySpeed"
end

function var0.GetTitle(arg0)
	return i18n("story_setting_label")
end

function var0.GetTitleEn(arg0)
	return "  / AUTO SPEED"
end

function var0.OnInit(arg0)
	local var0 = arg0._tf:Find("speeds")

	arg0.btns = {}

	for iter0 = 1, var0.childCount do
		local var1 = var0:GetChild(iter0 - 1)

		onToggle(arg0, var1, function(arg0)
			if arg0 then
				local var0 = Story.STORY_AUTO_SPEED[iter0]

				getProxy(SettingsProxy):SetStorySpeed(var0)
			end
		end, SFX_PANEL)
		setText(var1:Find("Text"), i18n("setting_story_speed_" .. iter0))

		arg0.btns[iter0] = var1
	end
end

function var0.OnUpdate(arg0)
	local var0 = getProxy(SettingsProxy):GetStorySpeed()
	local var1 = table.indexof(Story.STORY_AUTO_SPEED, var0) or 2

	triggerToggle(arg0.btns[var1], true)
end

return var0
