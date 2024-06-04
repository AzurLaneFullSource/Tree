local var0 = class("BackYardSettlementMediator", import("...base.ContextMediator"))

function var0.register(arg0)
	local var0 = getProxy(DormProxy)

	arg0.viewComponent:setShipVOs(arg0.contextData.oldShips, arg0.contextData.newShips)
	arg0.viewComponent:setDormVO(var0:getRawData())
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0)
	return
end

return var0
