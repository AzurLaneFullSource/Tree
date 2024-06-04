local var0 = class("DockyardQuickSelectSettingPage", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "DockyardQuickSelectSettingUI"
end

function var0.OnInit(arg0)
	arg0:InitUI()
end

function var0.InitUI(arg0)
	setText(findTF(arg0._tf, "window/top/bg/obtain/title"), i18n("retire_title"))

	local var0 = {
		findTF(arg0._tf, "window/notifications/options/notify_tpl_1"),
		findTF(arg0._tf, "window/notifications/options/notify_tpl_2"),
		findTF(arg0._tf, "window/notifications/options/notify_tpl_3")
	}
	local var1 = {
		sr = 4,
		n = 2,
		empty = 0,
		r = 3
	}
	local var2 = {}

	for iter0 = 1, #var0 do
		var2[iter0] = {}

		for iter1, iter2 in pairs(var1) do
			var2[iter0][iter1] = findTF(var0[iter0], iter1)
		end
	end

	for iter3 = 1, #var0 do
		for iter4, iter5 in pairs(var1) do
			onToggle(arg0, var2[iter3][iter4], function(arg0)
				local var0 = var2[iter3][iter4]:GetComponent(typeof(Toggle))

				if arg0 then
					arg0.settingChanged = true

					PlayerPrefs.SetInt("QuickSelectRarity" .. iter3, iter5)
				elseif not var0.group:AnyTogglesOn() then
					triggerToggle(var2[iter3].empty, true)
				end
			end)
		end
	end

	local var3 = findTF(arg0._tf, "window/notifications/options/notify_tpl_4")

	onToggle(arg0, findTF(var3, "keep_all"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepAll")
		end
	end)
	onToggle(arg0, findTF(var3, "keep_one"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepOne")
		end
	end)
	onToggle(arg0, findTF(var3, "keep_none"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
		end
	end)

	local var4 = findTF(arg0._tf, "window/notifications/options/notify_tpl_5")

	onToggle(arg0, findTF(var4, "keep_all"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWithoutMaxstar", "KeepAll")
		end
	end)
	onToggle(arg0, findTF(var4, "keep_needed"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWithoutMaxstar", "KeepNeeded")
		end
	end)
	onToggle(arg0, findTF(var4, "keep_none"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWithoutMaxstar", "KeepNone")
		end
	end)
	onButton(arg0, findTF(arg0._tf, "window/top/btnBack"), function()
		arg0:Hide()
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0._tf, "window/top/bg/obtain/title/title_en/info"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("retire_setting_help")
		})
	end, SFX_CONFIRM)

	local var5 = PlayerPrefs.GetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
	local var6 = PlayerPrefs.GetString("QuickSelectWithoutMaxstar", "KeepAll")

	if var5 == "KeepAll" then
		triggerToggle(findTF(var3, "keep_all"), true)
	elseif var5 == "KeepOne" then
		triggerToggle(findTF(var3, "keep_one"), true)
	elseif var5 == "KeepNone" then
		triggerToggle(findTF(var3, "keep_none"), true)
	end

	if var6 == "KeepAll" then
		triggerToggle(findTF(var4, "keep_all"), true)
	elseif var6 == "KeepNeeded" then
		triggerToggle(findTF(var4, "keep_needed"), true)
	elseif var6 == "KeepNone" then
		triggerToggle(findTF(var4, "keep_none"), true)
	end

	setText(findTF(arg0._tf, "window/notifications/options/notify_tpl_4/Text"), i18n("retire_1"))
	setText(findTF(arg0._tf, "window/notifications/options/notify_tpl_5/Text"), i18n("retire_2"))

	local var7 = {
		PlayerPrefs.GetInt("QuickSelectRarity1", 3),
		PlayerPrefs.GetInt("QuickSelectRarity2", 4),
		PlayerPrefs.GetInt("QuickSelectRarity3", 2)
	}

	for iter6 = 1, #var0 do
		setText(findTF(var0[iter6], "Text"), i18n("retire_rarity", iter6))

		for iter7, iter8 in pairs(var1) do
			if iter8 == var7[iter6] then
				triggerToggle(var2[iter6][iter7], true)
			end
		end
	end
end

function var0.Show(arg0)
	setActive(arg0._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
end

function var0.Hide(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf, arg0._parentTf)
	setActive(arg0._tf, false)

	if arg0.settingChangedCB then
		arg0.settingChangedCB()
	end
end

function var0.OnDestroy(arg0)
	arg0.settingChangedCB = nil
end

function var0.OnSettingChanged(arg0, arg1)
	arg0.settingChangedCB = arg1
end

return var0
