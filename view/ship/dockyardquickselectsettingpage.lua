local var0 = class("DockyardQuickSelectSettingPage", import("..base.BaseSubView"))

function var0.getUIName(arg0)
	return "DockyardQuickSelectSettingUI"
end

function var0.OnInit(arg0)
	arg0:InitUI()
end

function var0.InitUI(arg0)
	setText(findTF(arg0._tf, "window/top/bg/obtain/title"), i18n("retire_title"))
	setText(findTF(arg0._tf, "window/notifications/options/notify_tpl_0/Text"), i18n("unique_ship_retire_protect"))

	local var0 = findTF(arg0._tf, "window/notifications/options/notify_tpl_0")
	local var1 = findTF(var0, "on")
	local var2 = findTF(var0, "off")

	onToggle(arg0, var1, function(arg0)
		local var0 = var1:GetComponent(typeof(Toggle))

		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetInt("RetireProtect", 0)
		end
	end)
	onToggle(arg0, var2, function(arg0)
		local var0 = var2:GetComponent(typeof(Toggle))

		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetInt("RetireProtect", 1)
		end
	end)

	local var3 = {
		findTF(arg0._tf, "window/notifications/options/notify_tpl_1"),
		findTF(arg0._tf, "window/notifications/options/notify_tpl_2"),
		findTF(arg0._tf, "window/notifications/options/notify_tpl_3")
	}
	local var4 = {
		sr = 4,
		n = 2,
		empty = 0,
		r = 3
	}
	local var5 = {}

	for iter0 = 1, #var3 do
		var5[iter0] = {}

		for iter1, iter2 in pairs(var4) do
			var5[iter0][iter1] = findTF(var3[iter0], iter1)
		end
	end

	for iter3 = 1, #var3 do
		for iter4, iter5 in pairs(var4) do
			onToggle(arg0, var5[iter3][iter4], function(arg0)
				local var0 = var5[iter3][iter4]:GetComponent(typeof(Toggle))

				if arg0 then
					arg0.settingChanged = true

					PlayerPrefs.SetInt("QuickSelectRarity" .. iter3, iter5)
				elseif not var0.group:AnyTogglesOn() then
					triggerToggle(var5[iter3].empty, true)
				end
			end)
		end
	end

	local var6 = findTF(arg0._tf, "window/notifications/options/notify_tpl_4")

	onToggle(arg0, findTF(var6, "keep_all"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepAll")
		end
	end)
	onToggle(arg0, findTF(var6, "keep_one"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepOne")
		end
	end)
	onToggle(arg0, findTF(var6, "keep_none"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
		end
	end)

	local var7 = findTF(arg0._tf, "window/notifications/options/notify_tpl_5")

	onToggle(arg0, findTF(var7, "keep_all"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWithoutMaxstar", "KeepAll")
		end
	end)
	onToggle(arg0, findTF(var7, "keep_needed"), function(arg0)
		if arg0 then
			arg0.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWithoutMaxstar", "KeepNeeded")
		end
	end)
	onToggle(arg0, findTF(var7, "keep_none"), function(arg0)
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

	local var8 = PlayerPrefs.GetInt("RetireProtect", 1)
	local var9 = PlayerPrefs.GetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
	local var10 = PlayerPrefs.GetString("QuickSelectWithoutMaxstar", "KeepAll")

	if var8 == 0 then
		triggerToggle(var1, true)
	elseif var8 == 1 then
		triggerToggle(var2, true)
	end

	if var9 == "KeepAll" then
		triggerToggle(findTF(var6, "keep_all"), true)
	elseif var9 == "KeepOne" then
		triggerToggle(findTF(var6, "keep_one"), true)
	elseif var9 == "KeepNone" then
		triggerToggle(findTF(var6, "keep_none"), true)
	end

	if var10 == "KeepAll" then
		triggerToggle(findTF(var7, "keep_all"), true)
	elseif var10 == "KeepNeeded" then
		triggerToggle(findTF(var7, "keep_needed"), true)
	elseif var10 == "KeepNone" then
		triggerToggle(findTF(var7, "keep_none"), true)
	end

	setText(findTF(arg0._tf, "window/notifications/options/notify_tpl_4/Text"), i18n("retire_1"))
	setText(findTF(arg0._tf, "window/notifications/options/notify_tpl_5/Text"), i18n("retire_2"))

	local var11 = {
		PlayerPrefs.GetInt("QuickSelectRarity1", 3),
		PlayerPrefs.GetInt("QuickSelectRarity2", 4),
		PlayerPrefs.GetInt("QuickSelectRarity3", 2)
	}

	for iter6 = 1, #var3 do
		setText(findTF(var3[iter6], "Text"), i18n("retire_rarity", iter6))

		for iter7, iter8 in pairs(var4) do
			if iter8 == var11[iter6] then
				triggerToggle(var5[iter6][iter7], true)
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
