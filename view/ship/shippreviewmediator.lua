local var0 = class("ShipPreviewMediator", import("..base.ContextMediator"))

function var0.register(arg0)
	assert(arg0.contextData.shipVO, "shipVO is nil")
	assert(arg0.contextData.weaponIds, "weaponIds is nil")
	assert(arg0.contextData.equipSkinId, "equipment skin id is nil")
	arg0.viewComponent:setShip(arg0.contextData.shipVO, arg0.contextData.weaponIds, arg0.contextData.equipSkinId)
end

function var0.listNotificationInterests(arg0)
	return {}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()
end

return var0
