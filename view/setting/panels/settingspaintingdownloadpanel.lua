local var0_0 = class("SettingsPaintingDownloadPanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsPaintingDownload"
end

function var0_0.GetTitle(arg0_2)
	return i18n("painting_prefs_setting_label")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / Painting Download"
end

var0_0.None = 0
var0_0.Min = 1
var0_0.Max = 2

function var0_0.OnInit(arg0_4)
	local var0_4 = {
		arg0_4._tf:Find("prefs/1"),
		arg0_4._tf:Find("prefs/2")
	}

	arg0_4.btns = {}

	for iter0_4, iter1_4 in ipairs(var0_4) do
		local function var1_4(arg0_5)
			if arg0_5 then
				local var0_5 = getProxy(SettingsProxy):GetPaintingDownloadPrefs()

				if iter0_4 == var0_5 then
					return
				else
					getProxy(SettingsProxy):SetPaintingDownloadPrefs(iter0_4)
					pg.TipsMgr.GetInstance():ShowTips(i18n("painting_prefs_switch_succ"))
				end
			end
		end

		onToggle(arg0_4, iter1_4, var1_4, SFX_PANEL)
		setText(iter1_4:Find("Text"), i18n("painting_prefs_setting_" .. iter0_4))

		arg0_4.btns[iter0_4] = iter1_4
	end
end

function var0_0.OnUpdate(arg0_6)
	local var0_6 = getProxy(SettingsProxy):GetPaintingDownloadPrefs()

	if IsUnityEditor and var0_6 == var0_0.None then
		var0_6 = var0_0.Max

		return
	end

	triggerToggle(arg0_6.btns[var0_6], true)
end

return var0_0
