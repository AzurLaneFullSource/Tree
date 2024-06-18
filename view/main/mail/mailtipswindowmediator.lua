local var0_0 = class("MailTipsWindowMediator", import("view.base.ContextMediator"))

function var0_0.register(arg0_1)
	return
end

function var0_0.listNotificationInterests(arg0_2)
	return {}
end

function var0_0.remove(arg0_3)
	if arg0_3.contextData.onClose then
		arg0_3.contextData.onClose()
	end
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()
end

return var0_0
