local var0_0 = class("resumeMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	local var0_1 = arg0_1.contextData.player

	arg0_1.viewComponent:setPlayerVO(var0_1)
end

function var0_0.listNotificationInterests(arg0_2)
	return {}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()
end

return var0_0
