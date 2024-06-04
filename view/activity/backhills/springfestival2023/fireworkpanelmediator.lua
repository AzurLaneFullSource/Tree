local var0 = class("FireworkPanelMediator", import("view.base.ContextMediator"))

var0.LET_OFF_FIREWORKS = "LET_OFF_FIREWORKS"

function var0.register(arg0)
	arg0:bind(var0.LET_OFF_FIREWORKS, function(arg0, arg1)
		arg0:sendNotification(SpringFestival2023Mediator.PLAY_FIREWORKS, arg1)
		arg0.viewComponent:closeView()
	end)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
