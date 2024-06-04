local var0 = class("resumeMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	local var0 = arg0.contextData.player

	arg0.viewComponent:setPlayerVO(var0)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
