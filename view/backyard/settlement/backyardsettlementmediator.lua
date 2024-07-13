local var0_0 = class("BackYardSettlementMediator", import("...base.ContextMediator"))

function var0_0.register(arg0_1)
	local var0_1 = getProxy(DormProxy)

	arg0_1.viewComponent:setShipVOs(arg0_1.contextData.oldShips, arg0_1.contextData.newShips)
	arg0_1.viewComponent:setDormVO(var0_1:getRawData())
end

function var0_0.listNotificationInterests(arg0_2)
	return {}
end

function var0_0.handleNotification(arg0_3)
	return
end

return var0_0
