local var0_0 = class("SettingsNotificationPanel", import(".SettingsBasePanel"))

var0_0.UPDATE_ALARM_PANEL = "SettingsNotificationPanel.UPDATE_ALARM_PANEL"

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
	arg0_4:UpdateAndroidAlarm()
end

function var0_0.UpdateAndroidAlarm(arg0_6)
	arg0_6.alarmBtn = arg0_6._tf:Find("android_alarm_btn")
	arg0_6.alarmPanel = arg0_6._tf:Find("android_alarm_panel")

	local var0_6 = CameraHelper.IsAndroid()
	local var1_6 = NotificationMgr.Inst:CanScheduleExactAlarms()

	if not var0_6 or LOCK_ANDROID_EXACT_ALARM then
		setActive(arg0_6.alarmBtn, false)
		setActive(arg0_6.alarmPanel, false)
	elseif not var1_6 then
		setActive(arg0_6.alarmBtn, true)
		setActive(arg0_6.alarmPanel, true)

		arg0_6.alarmPanelTipText = arg0_6.alarmPanel:Find("tip/Text")

		setText(arg0_6.alarmPanelTipText, i18n("notify_clock_tip"))
		onButton(arg0_6, arg0_6.alarmBtn, function()
			NotificationMgr.Inst:RequestScheduleExactAlarms()
		end, SFX_PANEL)
	else
		setActive(arg0_6.alarmBtn, false)
		setActive(arg0_6.alarmPanel, false)
	end
end

function var0_0.UpdateItem(arg0_8, arg1_8, arg2_8)
	local var0_8 = arg0_8.list[arg1_8]

	arg2_8:Find("mask/Text"):GetComponent("ScrollText"):SetText(var0_8.title)
	onButton(arg0_8, arg2_8:Find("mask/Text"), function()
		pg.m02:sendNotification(NewSettingsMediator.SHOW_DESC, var0_8)
	end, SFX_PANEL)
	removeOnToggle(arg2_8:Find("on"))

	if arg0_8:GetDefaultValue(var0_8) then
		triggerToggle(arg2_8:Find("on"), true)
	else
		triggerToggle(arg2_8:Find("off"), true)
	end

	onToggle(arg0_8, arg2_8:Find("on"), function(arg0_10)
		arg0_8:OnItemSwitch(var0_8, arg0_10)
	end, SFX_UI_TAG, SFX_UI_CANCEL)
	arg0_8:OnUpdateItem(var0_8)
	arg0_8:OnUpdateItemWithTr(var0_8, arg2_8)
end

function var0_0.OnUpdateItem(arg0_11, arg1_11)
	return
end

function var0_0.OnUpdateItemWithTr(arg0_12, arg1_12, arg2_12)
	return
end

function var0_0.OnItemSwitch(arg0_13, arg1_13, arg2_13)
	pg.PushNotificationMgr.GetInstance():setSwitch(arg1_13.id, arg2_13)
end

function var0_0.GetDefaultValue(arg0_14, arg1_14)
	return pg.PushNotificationMgr.GetInstance():isEnabled(arg1_14.id)
end

function var0_0.GetList(arg0_15)
	local var0_15 = {}

	for iter0_15, iter1_15 in ipairs(pg.push_data_template.all) do
		table.insert(var0_15, pg.push_data_template[iter1_15])
	end

	return var0_15
end

function var0_0.OnUpdate(arg0_16)
	arg0_16.list = arg0_16:GetList()

	arg0_16.uilist:align(#arg0_16.list)
end

return var0_0
