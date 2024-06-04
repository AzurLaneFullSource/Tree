local var0 = class("SecondaryPasswordMediator", import("view.base.ContextMediator"))

var0.CONFIRM_PASSWORD = "SecondaryPasswordMediator:CONFIRM_PASSWORD"
var0.SET_PASSWORD = "SecondaryPasswordMediator:SET_PASSWORD"
var0.CANCEL_OPERATION = "SecondaryPasswordMediator:CANCEL_OPERATION"

function var0.register(arg0)
	arg0:bind(var0.CONFIRM_PASSWORD, function(arg0, arg1)
		if arg0.contextData.type == pg.SecondaryPWDMgr.CHANGE_SETTING or arg0.contextData.type == pg.SecondaryPWDMgr.CLOSE_PASSWORD then
			arg0:sendNotification(GAME.SET_PASSWORD_SETTINGS, {
				pwd = arg1,
				settings = arg0.contextData.settings
			})
		else
			arg0:sendNotification(GAME.CONFIRM_PASSWORD, {
				pwd = arg1
			})
		end
	end)
	arg0:bind(var0.SET_PASSWORD, function(arg0, arg1, arg2)
		arg2 = var0.ClipUnicodeStr(arg2, 20)

		arg0:sendNotification(GAME.SET_PASSWORD, {
			pwd = arg1,
			tip = arg2,
			settings = arg0.contextData.settings
		})
	end)
	arg0:bind(var0.CANCEL_OPERATION, function()
		arg0:sendNotification(GAME.CANCEL_LIMITED_OPERATION)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.CONFIRM_PASSWORD_DONE,
		GAME.SET_PASSWORD_SETTINGS_DONE,
		GAME.FETCH_PASSWORD_STATE_DONE,
		GAME.SET_PASSWORD_DONE
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
	local var2 = getProxy(SecondaryPWDProxy)
	local var3 = var2:getRawData()

	if var0 == GAME.FETCH_PASSWORD_STATE_DONE then
		if not var2:GetPermissionState() then
			arg0:sendNotification(GAME.CANCEL_LIMITED_OPERATION)

			local var4 = {
				mode = "showresttime",
				title = "warning",
				hideNo = true,
				type = MSGBOX_TYPE_SECONDPWD,
				onPreShow = function()
					arg0.viewComponent:emit(BaseUI.ON_CLOSE)
				end
			}

			pg.MsgboxMgr.GetInstance():ShowMsgBox(var4)
		end
	elseif var0 == GAME.CONFIRM_PASSWORD_DONE or var0 == GAME.SET_PASSWORD_SETTINGS_DONE then
		local var5 = var1.result

		if var5 > 0 then
			if var5 == 9 then
				var3.fail_count = var3.fail_count + 1

				if var3.fail_count >= 5 then
					arg0:sendNotification(GAME.FETCH_PASSWORD_STATE)
				else
					pg.TipsMgr.GetInstance():ShowTips(string.format(i18n("secondarypassword_incorrectpwd_error"), 5 - var3.fail_count))
				end
			elseif var5 == 40 or var5 == 1 then
				arg0:sendNotification(GAME.FETCH_PASSWORD_STATE)
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("", var5))
			end

			arg0.viewComponent:UpdateView()
			arg0.viewComponent:ClearInputs()
		else
			arg0:CloseAndCallback()
		end
	elseif var0 == GAME.SET_PASSWORD_DONE then
		local var6 = var1.result

		if var6 > 0 then
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", var6))
			arg0:sendNotification(GAME.FETCH_PASSWORD_STATE)
		else
			arg0:CloseAndCallback()
		end
	end
end

function var0.CloseAndCallback(arg0)
	local var0 = arg0.contextData.callback

	arg0.viewComponent:emit(BaseUI.ON_CLOSE)

	if var0 then
		var0()
	end
end

function var0.ClipUnicodeStr(arg0, arg1)
	local var0, var1 = utf8_to_unicode(arg0)

	if arg1 < var1 then
		local var2 = string.sub(var0, 1, -7)
		local var3, var4 = utf8_to_unicode(unicode_to_utf8(var2))

		while arg1 < var4 - 1 do
			var2 = string.sub(var2, 1, -7)

			local var5

			var5, var4 = utf8_to_unicode(unicode_to_utf8(var2))
		end

		return string.sub(unicode_to_utf8(var2), 1, -2)
	end

	return arg0
end

return var0
