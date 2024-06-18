local var0_0 = class("DockyardQuickSelectSettingPage", import("..base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "DockyardQuickSelectSettingUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:InitUI()
end

function var0_0.InitUI(arg0_3)
	setText(findTF(arg0_3._tf, "window/top/bg/obtain/title"), i18n("retire_title"))
	setText(findTF(arg0_3._tf, "window/notifications/options/notify_tpl_0/Text"), i18n("unique_ship_retire_protect"))

	local var0_3 = findTF(arg0_3._tf, "window/notifications/options/notify_tpl_0")
	local var1_3 = findTF(var0_3, "on")
	local var2_3 = findTF(var0_3, "off")

	onToggle(arg0_3, var1_3, function(arg0_4)
		local var0_4 = var1_3:GetComponent(typeof(Toggle))

		if arg0_4 then
			arg0_3.settingChanged = true

			PlayerPrefs.SetInt("RetireProtect", 0)
		end
	end)
	onToggle(arg0_3, var2_3, function(arg0_5)
		local var0_5 = var2_3:GetComponent(typeof(Toggle))

		if arg0_5 then
			arg0_3.settingChanged = true

			PlayerPrefs.SetInt("RetireProtect", 1)
		end
	end)

	local var3_3 = {
		findTF(arg0_3._tf, "window/notifications/options/notify_tpl_1"),
		findTF(arg0_3._tf, "window/notifications/options/notify_tpl_2"),
		findTF(arg0_3._tf, "window/notifications/options/notify_tpl_3")
	}
	local var4_3 = {
		sr = 4,
		n = 2,
		empty = 0,
		r = 3
	}
	local var5_3 = {}

	for iter0_3 = 1, #var3_3 do
		var5_3[iter0_3] = {}

		for iter1_3, iter2_3 in pairs(var4_3) do
			var5_3[iter0_3][iter1_3] = findTF(var3_3[iter0_3], iter1_3)
		end
	end

	for iter3_3 = 1, #var3_3 do
		for iter4_3, iter5_3 in pairs(var4_3) do
			onToggle(arg0_3, var5_3[iter3_3][iter4_3], function(arg0_6)
				local var0_6 = var5_3[iter3_3][iter4_3]:GetComponent(typeof(Toggle))

				if arg0_6 then
					arg0_3.settingChanged = true

					PlayerPrefs.SetInt("QuickSelectRarity" .. iter3_3, iter5_3)
				elseif not var0_6.group:AnyTogglesOn() then
					triggerToggle(var5_3[iter3_3].empty, true)
				end
			end)
		end
	end

	local var6_3 = findTF(arg0_3._tf, "window/notifications/options/notify_tpl_4")

	onToggle(arg0_3, findTF(var6_3, "keep_all"), function(arg0_7)
		if arg0_7 then
			arg0_3.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepAll")
		end
	end)
	onToggle(arg0_3, findTF(var6_3, "keep_one"), function(arg0_8)
		if arg0_8 then
			arg0_3.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepOne")
		end
	end)
	onToggle(arg0_3, findTF(var6_3, "keep_none"), function(arg0_9)
		if arg0_9 then
			arg0_3.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
		end
	end)

	local var7_3 = findTF(arg0_3._tf, "window/notifications/options/notify_tpl_5")

	onToggle(arg0_3, findTF(var7_3, "keep_all"), function(arg0_10)
		if arg0_10 then
			arg0_3.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWithoutMaxstar", "KeepAll")
		end
	end)
	onToggle(arg0_3, findTF(var7_3, "keep_needed"), function(arg0_11)
		if arg0_11 then
			arg0_3.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWithoutMaxstar", "KeepNeeded")
		end
	end)
	onToggle(arg0_3, findTF(var7_3, "keep_none"), function(arg0_12)
		if arg0_12 then
			arg0_3.settingChanged = true

			PlayerPrefs.SetString("QuickSelectWithoutMaxstar", "KeepNone")
		end
	end)
	onButton(arg0_3, findTF(arg0_3._tf, "window/top/btnBack"), function()
		arg0_3:Hide()
	end, SFX_CANCEL)
	onButton(arg0_3, findTF(arg0_3._tf, "window/top/bg/obtain/title/title_en/info"), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = i18n("retire_setting_help")
		})
	end, SFX_CONFIRM)

	local var8_3 = PlayerPrefs.GetInt("RetireProtect", 1)
	local var9_3 = PlayerPrefs.GetString("QuickSelectWhenHasAtLeastOneMaxstar", "KeepNone")
	local var10_3 = PlayerPrefs.GetString("QuickSelectWithoutMaxstar", "KeepAll")

	if var8_3 == 0 then
		triggerToggle(var1_3, true)
	elseif var8_3 == 1 then
		triggerToggle(var2_3, true)
	end

	if var9_3 == "KeepAll" then
		triggerToggle(findTF(var6_3, "keep_all"), true)
	elseif var9_3 == "KeepOne" then
		triggerToggle(findTF(var6_3, "keep_one"), true)
	elseif var9_3 == "KeepNone" then
		triggerToggle(findTF(var6_3, "keep_none"), true)
	end

	if var10_3 == "KeepAll" then
		triggerToggle(findTF(var7_3, "keep_all"), true)
	elseif var10_3 == "KeepNeeded" then
		triggerToggle(findTF(var7_3, "keep_needed"), true)
	elseif var10_3 == "KeepNone" then
		triggerToggle(findTF(var7_3, "keep_none"), true)
	end

	setText(findTF(arg0_3._tf, "window/notifications/options/notify_tpl_4/Text"), i18n("retire_1"))
	setText(findTF(arg0_3._tf, "window/notifications/options/notify_tpl_5/Text"), i18n("retire_2"))

	local var11_3 = {
		PlayerPrefs.GetInt("QuickSelectRarity1", 3),
		PlayerPrefs.GetInt("QuickSelectRarity2", 4),
		PlayerPrefs.GetInt("QuickSelectRarity3", 2)
	}

	for iter6_3 = 1, #var3_3 do
		setText(findTF(var3_3[iter6_3], "Text"), i18n("retire_rarity", iter6_3))

		for iter7_3, iter8_3 in pairs(var4_3) do
			if iter8_3 == var11_3[iter6_3] then
				triggerToggle(var5_3[iter6_3][iter7_3], true)
			end
		end
	end
end

function var0_0.Show(arg0_15)
	setActive(arg0_15._tf, true)
	pg.UIMgr.GetInstance():BlurPanel(arg0_15._tf)
end

function var0_0.Hide(arg0_16)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_16._tf, arg0_16._parentTf)
	setActive(arg0_16._tf, false)

	if arg0_16.settingChangedCB then
		arg0_16.settingChangedCB()
	end
end

function var0_0.OnDestroy(arg0_17)
	arg0_17.settingChangedCB = nil
end

function var0_0.OnSettingChanged(arg0_18, arg1_18)
	arg0_18.settingChangedCB = arg1_18
end

return var0_0
