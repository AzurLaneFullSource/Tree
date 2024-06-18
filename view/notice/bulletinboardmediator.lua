local var0_0 = class("BulletinBoardMediator", import("..base.ContextMediator"))

var0_0.SET_STOP_REMIND = "set_stop_remind"

function var0_0.register(arg0_1)
	local var0_1 = getProxy(ServerNoticeProxy)

	var0_1:setStopNewTip()

	local var1_1 = var0_1:getServerNotices(false)

	arg0_1.viewComponent:setNotices(var1_1)
	arg0_1:bind(arg0_1.SET_STOP_REMIND, function(arg0_2, arg1_2)
		getProxy(ServerNoticeProxy):setStopRemind(arg1_2)
	end)
end

function var0_0.listNotificationInterests(arg0_3)
	return {}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()
end

return var0_0
