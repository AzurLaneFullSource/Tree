local var0 = class("EquipmentTransformTreeMediator", import("view.base.ContextMediator"))

var0.OPEN_LAYER = "OPEN_LAYER"

function var0.register(arg0)
	arg0:BindEvent()

	arg0.env = {}

	arg0:getViewComponent():SetEnv(arg0.env)

	arg0.env.tracebackHelper = getProxy(EquipmentProxy):GetWeakEquipsDict()
	arg0.env.nationsTree = EquipmentProxy.EquipmentTransformTreeTemplate
end

function var0.BindEvent(arg0)
	arg0:bind(var0.OPEN_LAYER, function(arg0, ...)
		arg0:addSubLayers(...)
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.TRANSFORM_EQUIPMENT_DONE,
		PlayerProxy.UPDATED,
		BagProxy.ITEM_UPDATED,
		EquipmentProxy.EQUIPMENT_UPDATED,
		EquipmentTransformMediator.UPDATE_NEW_FLAG
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == PlayerProxy.UPDATED or var0 == BagProxy.ITEM_UPDATED then
		arg0:getViewComponent():UpdateItemNodes()
	elseif var0 == EquipmentProxy.EQUIPMENT_UPDATED then
		if var1.count == 0 then
			arg0:getViewComponent():UpdateItemNodes()
		end
	elseif var0 == EquipmentTransformMediator.UPDATE_NEW_FLAG then
		arg0:getViewComponent():UpdateItemNodeByID(var1)
	end
end

return var0
