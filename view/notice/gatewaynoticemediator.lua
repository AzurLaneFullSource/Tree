local var0_0 = class("GatewayNoticeMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	arg0_1:updateNotices()
end

function var0_0.updateNotices(arg0_2)
	local var0_2 = getProxy(GatewayNoticeProxy)

	arg0_2.viewComponent:updateNotices(var0_2:getGatewayNotices(false))
end

return var0_0
