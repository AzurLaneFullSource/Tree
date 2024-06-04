local var0 = class("SettingsStoryAutoPlayPanel", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsStoryAutoplay"
end

function var0.GetTitle(arg0)
	return i18n("story_autoplay_setting_label")
end

function var0.GetTitleEn(arg0)
	return "  / AUTO"
end

function var0.OnInit(arg0)
	local var0 = {
		arg0._tf:Find("speeds/1"),
		arg0._tf:Find("speeds/2")
	}

	arg0.btns = {}

	for iter0, iter1 in ipairs(var0) do
		onToggle(arg0, iter1, function(arg0)
			if arg0 then
				getProxy(SettingsProxy):SetStoryAutoPlayFlag(iter0 - 1)
			end
		end, SFX_PANEL)
		setText(iter1:Find("Text"), i18n("story_autoplay_setting_" .. iter0))

		arg0.btns[iter0] = iter1
	end
end

function var0.OnUpdate(arg0)
	local var0 = getProxy(SettingsProxy):GetStoryAutoPlayFlag() and 2 or 1

	triggerToggle(arg0.btns[var0], true)
end

return var0
