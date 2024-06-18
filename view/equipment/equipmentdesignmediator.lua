local var0_0 = class("EquipmentDesignMediator", import("..base.ContextMediator"))

var0_0.MAKE_EQUIPMENT = "EquipmentDesignMediator:MAKE_EQUIPMENT"
var0_0.OPEN_EQUIPMENTDESIGN_INDEX = "EquipmentDesignMediator:OPEN_EQUIPMENTDESIGN_INDEX"

function var0_0.register(arg0_1)
	arg0_1.bagProxy = getProxy(BagProxy)

	arg0_1.viewComponent:setItems(arg0_1.bagProxy:getData())

	arg0_1.equipmentProxy = getProxy(EquipmentProxy)

	local var0_1 = arg0_1.equipmentProxy:getCapacity()

	arg0_1.viewComponent:setCapacity(var0_1)

	arg0_1.playerProxy = getProxy(PlayerProxy)

	local var1_1 = arg0_1.playerProxy:getData()

	arg0_1.viewComponent:setPlayer(var1_1)

	local var2_1 = arg0_1:getFacade():retrieveMediator(EquipmentMediator.__cname):getViewComponent()

	arg0_1.viewComponent:SetParentTF(var2_1._tf)
	arg0_1.viewComponent:SetTopContainer(var2_1.topPanel)
	arg0_1:bind(var0_0.MAKE_EQUIPMENT, function(arg0_2, arg1_2, arg2_2)
		arg0_1:sendNotification(GAME.COMPOSITE_EQUIPMENT, {
			id = arg1_2,
			count = arg2_2
		})
	end)
	arg0_1:bind(var0_0.OPEN_EQUIPMENTDESIGN_INDEX, function(arg0_3, arg1_3)
		arg0_1:addSubLayers(Context.New({
			viewComponent = CustomIndexLayer,
			mediator = CustomIndexMediator,
			data = arg1_3
		}))
	end)
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.COMPOSITE_EQUIPMENT_DONE,
		BagProxy.ITEM_UPDATED,
		PlayerProxy.UPDATED,
		EquipmentProxy.EQUIPMENT_UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.COMPOSITE_EQUIPMENT_DONE then
		local var2_5 = var1_5.equipment
		local var3_5 = var1_5.count

		arg0_5.viewComponent:filter(arg0_5.contextData.index or 1, true)

		local var4_5 = var2_5:getConfig("name")

		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_newEquipLayer_getNewEquip", var4_5 .. " X" .. var3_5))
	elseif var0_5 == BagProxy.ITEM_UPDATED then
		arg0_5.viewComponent:setItems(arg0_5.bagProxy:getData())
	elseif var0_5 == PlayerProxy.UPDATED then
		arg0_5.viewComponent:setPlayer(arg0_5.playerProxy:getData())
	elseif var0_5 == EquipmentProxy.EQUIPMENT_UPDATED then
		arg0_5.viewComponent:setCapacity(arg0_5.equipmentProxy:getCapacity())
	end
end

return var0_0
