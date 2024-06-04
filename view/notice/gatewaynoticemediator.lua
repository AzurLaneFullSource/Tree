local var0 = class("GatewayNoticeMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	arg0:updateNotices()
end

function var0.updateNotices(arg0)
	local var0 = getProxy(GatewayNoticeProxy)

	arg0.viewComponent:updateNotices(var0:getGatewayNotices(false))
end

return var0
