local var0 = class("SettingsPaintingDownloadPanel", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsPaintingDownload"
end

function var0.GetTitle(arg0)
	return i18n("painting_prefs_setting_label")
end

function var0.GetTitleEn(arg0)
	return "  / Painting Download"
end

var0.None = 0
var0.Min = 1
var0.Max = 2

function var0.OnInit(arg0)
	local var0 = {
		arg0._tf:Find("prefs/1"),
		arg0._tf:Find("prefs/2")
	}

	arg0.btns = {}

	for iter0, iter1 in ipairs(var0) do
		local function var1(arg0)
			if arg0 then
				local var0 = getProxy(SettingsProxy):GetPaintingDownloadPrefs()

				if iter0 == var0 then
					return
				else
					getProxy(SettingsProxy):SetPaintingDownloadPrefs(iter0)
					pg.TipsMgr.GetInstance():ShowTips(i18n("painting_prefs_switch_succ"))
				end
			end
		end

		onToggle(arg0, iter1, var1, SFX_PANEL)
		setText(iter1:Find("Text"), i18n("painting_prefs_setting_" .. iter0))

		arg0.btns[iter0] = iter1
	end
end

function var0.OnUpdate(arg0)
	local var0 = getProxy(SettingsProxy):GetPaintingDownloadPrefs()

	if IsUnityEditor and var0 == var0.None then
		var0 = var0.Max

		return
	end

	triggerToggle(arg0.btns[var0], true)
end

return var0
