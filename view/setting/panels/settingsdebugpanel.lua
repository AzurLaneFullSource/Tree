local var0_0 = class("SettingsDebugPanel", import(".SettingsBasePanel"))

function var0_0.GetUIName(arg0_1)
	return "SettingsNotifications"
end

function var0_0.GetTitle(arg0_2)
	return "测试面板"
end

function var0_0.GetTitleEn(arg0_3)
	return ""
end

function var0_0.OnInit(arg0_4)
	local var0_4 = arg0_4._tf:Find("options/notify_tpl")

	setActive(var0_4, false)

	arg0_4.container = arg0_4._tf:Find("options")
	arg0_4.toggleTpl = cloneTplTo(var0_4, arg0_4._tf, "toggleTpl")
	arg0_4.btnTpl = cloneTplTo(var0_4, arg0_4._tf, "btnTpl")

	GameObject.Destroy(findGO(arg0_4.btnTpl, "off"))
	GameObject.Destroy(findGO(arg0_4.btnTpl, "on"))
	RemoveComponent(arg0_4.btnTpl, "ToggleGroup")
	removeAllChildren(arg0_4.container)
	arg0_4:btn_brightness_permission()
	arg0_4:btn_brightness_setvalue()
	arg0_4:btn_alarm_permission()
	arg0_4:btn_notification_permission()
	arg0_4:toggle_notification_tag()
	arg0_4:btn_push_10s()
	arg0_4:btn_cancel_notification()
	arg0_4:btn_save_photo()
	arg0_4:btn_record_start()
	arg0_4:btn_record_stop()
end

function var0_0.createBtn(arg0_5, arg1_5)
	local var0_5 = cloneTplTo(arg0_5.btnTpl, arg0_5.container, arg1_5.go)
	local var1_5 = var0_5:Find("mask/Text")

	setText(var1_5, arg1_5.text)
	onButton(arg0_5, var0_5, arg1_5.func, SFX_PANEL)
end

function var0_0.createToggle(arg0_6, arg1_6)
	local var0_6 = cloneTplTo(arg0_6.toggleTpl, arg0_6.container, arg1_6.go)
	local var1_6 = var0_6:Find("mask/Text")
	local var2_6 = var0_6:Find("on")

	setText(var1_6, arg1_6.text)
	onToggle(arg0_6, var2_6, arg1_6.func, SFX_UI_TAG, SFX_UI_CANCEL)
end

function var0_0.btn_brightness_permission(arg0_7)
	local var0_7 = {
		go = "btn_brightness_permission",
		text = "检查亮度权限",
		func = function()
			if YSNormalTool.BrightnessTool.CanWriteSetting() then
				pg.TipsMgr.GetInstance():ShowTips("拥有权限")
			else
				YSNormalTool.OtherTool.OpenAndroidWriteSettings()
			end
		end
	}

	arg0_7:createBtn(var0_7)
end

function var0_0.btn_brightness_setvalue(arg0_9)
	local var0_9 = "循环设置亮度，当前亮度："
	local var1_9 = {
		go = "btn_brightness_setvalue",
		text = var0_9 .. YSNormalTool.BrightnessTool.GetBrightnessValue()
	}

	local function var2_9()
		local var0_10 = arg0_9.container:Find(var1_9.go .. "/mask/Text")

		setText(var0_10, var0_9 .. YSNormalTool.BrightnessTool.GetBrightnessValue())
	end

	function var1_9.func()
		local var0_11 = YSNormalTool.BrightnessTool.GetBrightnessValue() + 0.1

		if var0_11 > 1 then
			var0_11 = var0_11 - 1
		end

		YSNormalTool.BrightnessTool.SetBrightnessValue(var0_11)
		var2_9()
	end

	arg0_9:createBtn(var1_9)
end

function var0_0.btn_alarm_permission(arg0_12)
	local var0_12 = {
		go = "btn_alarm_permission",
		text = "检查安卓闹钟权限",
		func = function()
			if YSNormalTool.NotificationTool.CanScheduleExactAlarms() then
				pg.TipsMgr.GetInstance():ShowTips("拥有权限")
			else
				YSNormalTool.NotificationTool.RequestScheduleExactAlarmsPermission()
			end
		end
	}

	if PermissionHelper.IsAndroid() then
		arg0_12:createBtn(var0_12)
	end
end

function var0_0.btn_notification_permission(arg0_14)
	local var0_14 = {
		go = "btn_notification_permission",
		text = "检查通知权限",
		func = function()
			local var0_15 = {
				YSNormalTool.PermissionTool.Notification
			}

			YSNormalTool.PermissionTool.RequestMultiPermission(var0_15, function(arg0_16, arg1_16)
				local var0_16 = true
				local var1_16 = arg1_16.Length

				for iter0_16 = 0, var1_16 - 1 do
					if arg1_16[iter0_16] ~= 0 then
						var0_16 = false

						break
					end
				end

				if var0_16 then
					pg.TipsMgr.GetInstance():ShowTips("授权成功")
				else
					pg.TipsMgr.GetInstance():ShowTips("授权失败")
				end
			end)
		end
	}

	arg0_14:createBtn(var0_14)
end

function var0_0.toggle_notification_tag(arg0_17)
	local var0_17 = {
		go = "btn_push_10s",
		text = "开启则可切到后台测试通知，测完需要关闭",
		func = function(arg0_18)
			if arg0_18 then
				PUSH_NOTIFICATION_TEST_TAG = true
			else
				PUSH_NOTIFICATION_TEST_TAG = false
			end
		end
	}

	arg0_17:createToggle(var0_17)
end

function var0_0.btn_push_10s(arg0_19)
	local var0_19 = {
		go = "btn_push_10s",
		text = "10秒后推送通知",
		func = function()
			pg.TipsMgr.GetInstance():ShowTips("推送测试通知")

			local var0_20 = pg.TimeMgr.GetInstance():STimeDescS(pg.TimeMgr.GetInstance():GetServerTime(), "*t")
			local var1_20 = var0_20.year .. var0_20.month .. var0_20.day .. var0_20.hour .. var0_20.min .. var0_20.sec
			local var2_20 = pg.TimeMgr.GetInstance():GetServerTime() + 10

			pg.PushNotificationMgr.GetInstance():Push("测试标题11111", var1_20, var2_20)
			pg.PushNotificationMgr.GetInstance():Push("测试标题22222", var1_20, var2_20)
			pg.PushNotificationMgr.GetInstance():Push("测试标题33333", var1_20, var2_20)
			pg.PushNotificationMgr.GetInstance():PushCache()
		end
	}

	arg0_19:createBtn(var0_19)
end

function var0_0.btn_cancel_notification(arg0_21)
	local var0_21 = {
		go = "btn_cancel_notification",
		text = "取消所有通知",
		func = function()
			YSNormalTool.NotificationTool.CancelAllNotification()
		end
	}

	arg0_21:createBtn(var0_21)
end

function var0_0.btn_save_photo(arg0_23)
	local var0_23 = {
		go = "btn_save_photo",
		text = "保存截图",
		func = function()
			local var0_24 = YSTool.YSScreenShoter.TakeScreenShotDirectly()

			YSNormalTool.MediaTool.SaveImageWithBytes(var0_24, function(arg0_25, arg1_25)
				if arg0_25 then
					pg.TipsMgr.GetInstance():ShowTips("保存截图成功")
				else
					pg.TipsMgr.GetInstance():ShowTips("保存截图失败：" .. arg1_25)
				end
			end)
		end
	}

	arg0_23:createBtn(var0_23)
end

function var0_0.btn_record_start(arg0_26)
	local var0_26 = {
		go = "btn_record_start",
		text = "开始录屏"
	}

	local function var1_26(arg0_27)
		if not arg0_27 then
			pg.TipsMgr.GetInstance():ShowTips("开始录屏失败")
		else
			pg.TipsMgr.GetInstance():ShowTips("开始录屏成功")
		end
	end

	function var0_26.func()
		PermissionHelper.RequestCamera(function()
			arg0_26.recordFilePath = YSNormalTool.RecordTool.GenRecordFilePath()

			YSNormalTool.RecordTool.StartRecording(var1_26, arg0_26.recordFilePath)
		end, function()
			pg.TipsMgr.GetInstance():ShowTips("请求录屏所需权限失败")
		end)
	end

	arg0_26:createBtn(var0_26)
end

function var0_0.btn_record_stop(arg0_31)
	local var0_31 = {
		go = "btn_record_stop",
		text = "结束录屏"
	}

	local function var1_31(arg0_32)
		if arg0_32 and PLATFORM == PLATFORM_ANDROID then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("word_save_video"),
				onNo = function()
					if System.IO.File.Exists(arg0_31.recordFilePath) then
						System.IO.File.Delete(arg0_31.recordFilePath)
					end
				end,
				onYes = function()
					YSNormalTool.MediaTool.SaveVideoToAlbum(arg0_31.recordFilePath, function(arg0_35, arg1_35)
						if arg0_35 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("word_save_ok"))

							if System.IO.File.Exists(arg0_31.recordFilePath) then
								System.IO.File.Delete(arg0_31.recordFilePath)
							end
						end
					end)
				end
			})
		end
	end

	function var0_31.func()
		YSNormalTool.RecordTool.StopRecording(var1_31)
	end

	arg0_31:createBtn(var0_31)
end

return var0_0
