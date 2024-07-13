local var0_0 = class("EquipmentTransformTreeMediator", import("view.base.ContextMediator"))

var0_0.OPEN_LAYER = "OPEN_LAYER"

function var0_0.register(arg0_1)
	arg0_1:BindEvent()

	arg0_1.env = {}

	arg0_1:getViewComponent():SetEnv(arg0_1.env)

	arg0_1.env.tracebackHelper = getProxy(EquipmentProxy):GetWeakEquipsDict()
	arg0_1.env.nationsTree = EquipmentProxy.EquipmentTransformTreeTemplate
end

function var0_0.BindEvent(arg0_2)
	arg0_2:bind(var0_0.OPEN_LAYER, function(arg0_3, ...)
		arg0_2:addSubLayers(...)
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.TRANSFORM_EQUIPMENT_DONE,
		PlayerProxy.UPDATED,
		BagProxy.ITEM_UPDATED,
		EquipmentProxy.EQUIPMENT_UPDATED,
		EquipmentTransformMediator.UPDATE_NEW_FLAG
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == PlayerProxy.UPDATED or var0_5 == BagProxy.ITEM_UPDATED then
		arg0_5:getViewComponent():UpdateItemNodes()
	elseif var0_5 == EquipmentProxy.EQUIPMENT_UPDATED then
		if var1_5.count == 0 then
			arg0_5:getViewComponent():UpdateItemNodes()
		end
	elseif var0_5 == EquipmentTransformMediator.UPDATE_NEW_FLAG then
		arg0_5:getViewComponent():UpdateItemNodeByID(var1_5)
	end
end

return var0_0
