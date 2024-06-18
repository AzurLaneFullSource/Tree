local var0_0 = class("SecondaryPasswordMediator", import("view.base.ContextMediator"))

var0_0.CONFIRM_PASSWORD = "SecondaryPasswordMediator:CONFIRM_PASSWORD"
var0_0.SET_PASSWORD = "SecondaryPasswordMediator:SET_PASSWORD"
var0_0.CANCEL_OPERATION = "SecondaryPasswordMediator:CANCEL_OPERATION"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.CONFIRM_PASSWORD, function(arg0_2, arg1_2)
		if arg0_1.contextData.type == pg.SecondaryPWDMgr.CHANGE_SETTING or arg0_1.contextData.type == pg.SecondaryPWDMgr.CLOSE_PASSWORD then
			arg0_1:sendNotification(GAME.SET_PASSWORD_SETTINGS, {
				pwd = arg1_2,
				settings = arg0_1.contextData.settings
			})
		else
			arg0_1:sendNotification(GAME.CONFIRM_PASSWORD, {
				pwd = arg1_2
			})
		end
	end)
	arg0_1:bind(var0_0.SET_PASSWORD, function(arg0_3, arg1_3, arg2_3)
		arg2_3 = var0_0.ClipUnicodeStr(arg2_3, 20)

		arg0_1:sendNotification(GAME.SET_PASSWORD, {
			pwd = arg1_3,
			tip = arg2_3,
			settings = arg0_1.contextData.settings
		})
	end)
	arg0_1:bind(var0_0.CANCEL_OPERATION, function()
		arg0_1:sendNotification(GAME.CANCEL_LIMITED_OPERATION)
	end)
end

function var0_0.listNotificationInterests(arg0_5)
	return {
		GAME.CONFIRM_PASSWORD_DONE,
		GAME.SET_PASSWORD_SETTINGS_DONE,
		GAME.FETCH_PASSWORD_STATE_DONE,
		GAME.SET_PASSWORD_DONE
	}
end

function var0_0.handleNotification(arg0_6, arg1_6)
	local var0_6 = arg1_6:getName()
	local var1_6 = arg1_6:getBody()
	local var2_6 = getProxy(SecondaryPWDProxy)
	local var3_6 = var2_6:getRawData()

	if var0_6 == GAME.FETCH_PASSWORD_STATE_DONE then
		if not var2_6:GetPermissionState() then
			arg0_6:sendNotification(GAME.CANCEL_LIMITED_OPERATION)

			local var4_6 = {
				mode = "showresttime",
				title = "warning",
				hideNo = true,
				type = MSGBOX_TYPE_SECONDPWD,
				onPreShow = function()
					arg0_6.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var4_6)
		end
	elseif var0_6 == GAME.CONFIRM_PASSWORD_DONE or var0_6 == GAME.SET_PASSWORD_SETTINGS_DONE then
		local var5_6 = var1_6.result

		if var5_6 > 0 then
			if var5_6 == 9 then
				var3_6.fail_count = var3_6.fail_count + 1

				if var3_6.fail_count >= 5 then
					arg0_6:sendNotification(GAME.FETCH_PASSWORD_STATE)
				else
					pg.TipsMgr.GetInstance():ShowTips(string.format(i18n("secondarypassword_incorrectpwd_error"), 5 - var3_6.fail_count))
				end
			elseif var5_6 == 40 or var5_6 == 1 then
				arg0_6:sendNotification(GAME.FETCH_PASSWORD_STATE)
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("", var5_6))
			end

			arg0_6.viewComponent:UpdateView()
			arg0_6.viewComponent:ClearInputs()
		else
			arg0_6:CloseAndCallback()
		end
	elseif var0_6 == GAME.SET_PASSWORD_DONE then
		local var6_6 = var1_6.result

		if var6_6 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", var6_6))
			arg0_6:sendNotification(GAME.FETCH_PASSWORD_STATE)
		else
			arg0_6:CloseAndCallback()
		end
	end
end

function var0_0.CloseAndCallback(arg0_8)
	local var0_8 = arg0_8.contextData.callback

	arg0_8.viewComponent:emit(BaseUI.ON_CLOSE)

	if var0_8 then
		var0_8()
	end
end

function var0_0.ClipUnicodeStr(arg0_9, arg1_9)
	local var0_9, var1_9 = utf8_to_unicode(arg0_9)

	if arg1_9 < var1_9 then
		local var2_9 = string.sub(var0_9, 1, -7)
		local var3_9, var4_9 = utf8_to_unicode(unicode_to_utf8(var2_9))

		while arg1_9 < var4_9 - 1 do
			var2_9 = string.sub(var2_9, 1, -7)

			local var5_9

			var5_9, var4_9 = utf8_to_unicode(unicode_to_utf8(var2_9))
		end

		return string.sub(unicode_to_utf8(var2_9), 1, -2)
	end

	return arg0_9
end

return var0_0
