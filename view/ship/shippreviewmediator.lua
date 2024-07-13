local var0_0 = class("ShipPreviewMediator", import("..base.ContextMediator"))

function var0_0.register(arg0_1)
	assert(arg0_1.contextData.shipVO, "shipVO is nil")
	assert(arg0_1.contextData.weaponIds, "weaponIds is nil")
	assert(arg0_1.contextData.equipSkinId, "equipment skin id is nil")
	arg0_1.viewComponent:setShip(arg0_1.contextData.shipVO, arg0_1.contextData.weaponIds, arg0_1.contextData.equipSkinId)
end

function var0_0.listNotificationInterests(arg0_2)
	return {}
end

function var0_0.handleNotification(arg0_3, arg1_3)
	local var0_3 = arg1_3:getName()
	local var1_3 = arg1_3:getBody()
end

return var0_0
