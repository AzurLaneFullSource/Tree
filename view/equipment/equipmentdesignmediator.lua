local var0 = class("EquipmentDesignMediator", import("..base.ContextMediator"))

var0.MAKE_EQUIPMENT = "EquipmentDesignMediator:MAKE_EQUIPMENT"
var0.OPEN_EQUIPMENTDESIGN_INDEX = "EquipmentDesignMediator:OPEN_EQUIPMENTDESIGN_INDEX"

function var0.register(arg0)
	arg0.bagProxy = getProxy(BagProxy)

	arg0.viewComponent:setItems(arg0.bagProxy:getData())

	arg0.equipmentProxy = getProxy(EquipmentProxy)

	local var0 = arg0.equipmentProxy:getCapacity()

	arg0.viewComponent:setCapacity(var0)

	arg0.playerProxy = getProxy(PlayerProxy)

	local var1 = arg0.playerProxy:getData()

	arg0.viewComponent:setPlayer(var1)

	local var2 = arg0:getFacade():retrieveMediator(EquipmentMediator.__cname):getViewComponent()

	arg0.viewComponent:SetParentTF(var2._tf)
	arg0.viewComponent:SetTopContainer(var2.topPanel)
	arg0:bind(var0.MAKE_EQUIPMENT, function(arg0, arg1, arg2)
		arg0:sendNotification(GAME.COMPOSITE_EQUIPMENT, {
			id = arg1,
			count = arg2
		})
	end)
	arg0:bind(var0.OPEN_EQUIPMENTDESIGN_INDEX, function(arg0, arg1)
		arg0:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1
		}))
	end)
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.COMPOSITE_EQUIPMENT_DONE,
		BagProxy.ITEM_UPDATED,
		PlayerProxy.UPDATED,
		EquipmentProxy.EQUIPMENT_UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.COMPOSITE_EQUIPMENT_DONE then
		local var2 = var1.equipment
		local var3 = var1.count

		arg0.viewComponent:filter(arg0.contextData.index or 1, true)

		local var4 = var2:getConfig("name")

		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_newEquipLayer_getNewEquip", var4 .. " X" .. var3))
	elseif var0 == BagProxy.ITEM_UPDATED then
		arg0.viewComponent:setItems(arg0.bagProxy:getData())
	elseif var0 == PlayerProxy.UPDATED then
		arg0.viewComponent:setPlayer(arg0.playerProxy:getData())
	elseif var0 == EquipmentProxy.EQUIPMENT_UPDATED then
		arg0.viewComponent:setCapacity(arg0.equipmentProxy:getCapacity())
	end
end

return var0
