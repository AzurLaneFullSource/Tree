local var0 = class("BulletinBoardMediator", import("..base.ContextMediator"))

var0.SET_STOP_REMIND = "set_stop_remind"

function var0.register(arg0)
	local var0 = getProxy(ServerNoticeProxy)

	var0:setStopNewTip()

	local var1 = var0:getServerNotices(false)

	arg0.viewComponent:setNotices(var1)
	arg0:bind(arg0.SET_STOP_REMIND, function(arg0, arg1)
		getProxy(ServerNoticeProxy):setStopRemind(arg1)
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
