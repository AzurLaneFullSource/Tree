local var0_0 = class("SettingsNotificationPanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsNotifications"
end

function var0_0.GetTitle(arg0_2)
	return i18n("Settings_title_Notification")
end

function var0_0.GetTitleEn(arg0_3)
	return "  / ENABLE NOTIFICATIONS"
end

function var0_0.OnInit(arg0_4)
	arg0_4.uilist = UIItemList.New(arg0_4._tf:Find("options"), arg0_4._tf:Find("options/notify_tpl"))

	arg0_4.uilist:make(function(arg0_5, arg1_5, arg2_5)
		if arg0_5 == UIItemList.EventUpdate then
			arg0_4:UpdateItem(arg1_5 + 1, arg2_5)
		end
	end)
end

function var0_0.UpdateItem(arg0_6, arg1_6, arg2_6)
	local var0_6 = arg0_6.list[arg1_6]

	arg2_6:Find("mask/Text"):GetComponent("ScrollText"):SetText(var0_6.title)
	onButton(arg0_6, arg2_6:Find("mask/Text"), function()
		pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, var0_6)
	end, SFX_PANEL)
	removeOnToggle(arg2_6:Find("on"))

	if arg0_6:GetDefaultValue(var0_6) then
		triggerToggle(arg2_6:Find("on"), true)
	else
		triggerToggle(arg2_6:Find("off"), true)
	end

	onToggle(arg0_6, arg2_6:Find("on"), function(arg0_8)
		arg0_6:OnItemSwitch(var0_6, arg0_8)
	end, SFX_UI_TAG, SFX_UI_CANCEL)
	arg0_6:OnUpdateItem(var0_6)
	arg0_6:OnUpdateItemWithTr(var0_6, arg2_6)
end

function var0_0.OnUpdateItem(arg0_9, arg1_9)
	return
end

function var0_0.OnUpdateItemWithTr(arg0_10, arg1_10, arg2_10)
	return
end

function var0_0.OnItemSwitch(arg0_11, arg1_11, arg2_11)
	pg.PushNotificationMgr.GetInstance():setSwitch(arg1_11.id, arg2_11)
end

function var0_0.GetDefaultValue(arg0_12, arg1_12)
	return pg.PushNotificationMgr.GetInstance():isEnabled(arg1_12.id)
end

function var0_0.GetList(arg0_13)
	local var0_13 = {}

	for iter0_13, iter1_13 in ipairs(pg.push_data_template.all) do
		table.insert(var0_13, pg.push_data_template[iter1_13])
	end

	return var0_13
end

function var0_0.OnUpdate(arg0_14)
	arg0_14.list = arg0_14:GetList()

	arg0_14.uilist:align(#arg0_14.list)
end

return var0_0
