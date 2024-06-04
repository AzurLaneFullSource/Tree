local var0 = class("SettingsNotificationPanel", import(".SettingsBasePanel"))

function var0.GetUIName(arg0)
	return "SettingsNotifications"
end

function var0.GetTitle(arg0)
	return i18n("Settings_title_Notification")
end

function var0.GetTitleEn(arg0)
	return "  / ENABLE NOTIFICATIONS"
end

function var0.OnInit(arg0)
	arg0.uilist = UIItemList.New(arg0._tf:Find("options"), arg0._tf:Find("options/notify_tpl"))

	arg0.uilist:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg0:UpdateItem(arg1 + 1, arg2)
		end
	end)
end

function var0.UpdateItem(arg0, arg1, arg2)
	local var0 = arg0.list[arg1]

	arg2:Find("mask/Text"):GetComponent("ScrollText"):SetText(var0.title)
	onButton(arg0, arg2:Find("mask/Text"), function()
		pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, var0)
	end, SFX_PANEL)
	removeOnToggle(arg2:Find("on"))

	if arg0:GetDefaultValue(var0) then
		triggerToggle(arg2:Find("on"), true)
	else
		triggerToggle(arg2:Find("off"), true)
	end

	onToggle(arg0, arg2:Find("on"), function(arg0)
		arg0:OnItemSwitch(var0, arg0)
	end, SFX_UI_TAG, SFX_UI_CANCEL)
	arg0:OnUpdateItem(var0)
	arg0:OnUpdateItemWithTr(var0, arg2)
end

function var0.OnUpdateItem(arg0, arg1)
	return
end

function var0.OnUpdateItemWithTr(arg0, arg1, arg2)
	return
end

function var0.OnItemSwitch(arg0, arg1, arg2)
	pg.PushNotificationMgr.GetInstance():setSwitch(arg1.id, arg2)
end

function var0.GetDefaultValue(arg0, arg1)
	return pg.PushNotificationMgr.GetInstance():isEnabled(arg1.id)
end

function var0.GetList(arg0)
	local var0 = {}

	for iter0, iter1 in ipairs(pg.push_data_template.all) do
		table.insert(var0, pg.push_data_template[iter1])
	end

	return var0
end

function var0.OnUpdate(arg0)
	arg0.list = arg0:GetList()

	arg0.uilist:align(#arg0.list)
end

return var0
