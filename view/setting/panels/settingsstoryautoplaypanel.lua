local var0_0 = class("SettingsStoryAutoPlayPanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsStoryAutoplay"
end

function var0_0.GetTitle(arg0_2)
	return i18n("story_autoplay_setting_label")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / AUTO"
end

function var0_0.OnInit(arg0_4)
	local var0_4 = {
		arg0_4._tf:Find("speeds/1"),
		arg0_4._tf:Find("speeds/2")
	}

	arg0_4.btns = {}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		onToggle(arg0_4, iter1_4, function(arg0_5)
			if arg0_5 then
				getProxy(SettingsProxy):SetStoryAutoPlayFlag(iter0_4 - 1)
			end
		end, SFX_PANEL)
		setText(iter1_4:Find("Text"), i18n("story_autoplay_setting_" .. iter0_4))

		arg0_4.btns[iter0_4] = iter1_4
	end
end

function var0_0.OnUpdate(arg0_6)
	local var0_6 = getProxy(SettingsProxy):GetStoryAutoPlayFlag() and 2 or 1

	triggerToggle(arg0_6.btns[var0_6], true)
end

return var0_0
