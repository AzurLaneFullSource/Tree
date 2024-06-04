local var0 = class("EquipUpgradeMediator", import("..base.ContextMediator"))

var0.EQUIPMENT_UPGRDE = "EquipUpgradeMediator:EQUIPMENT_UPGRDE"
var0.REPLACE_EQUIP = "EquipUpgradeMediator:REPLACE_EQUIP"
var0.ON_ITEM = "EquipUpgradeMediator:ON_ITEM"

function var0.register(arg0)
	arg0.bagProxy = getProxy(BagProxy)

	local var0 = arg0.bagProxy:getData()

	arg0.viewComponent:setItems(var0)

	local var1 = getProxy(PlayerProxy)

	arg0.viewComponent:updateRes(var1:getData())
	arg0:bind(var0.EQUIPMENT_UPGRDE, function(arg0)
		arg0:sendNotification(GAME.UPGRADE_EQUIPMENTS, {
			shipId = arg0.contextData.shipId,
			pos = arg0.contextData.pos,
			equipmentId = arg0.contextData.equipmentId
		})
	end)
	arg0:bind(var0.ON_ITEM, function(arg0, arg1)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = "",
			yesText = "text_confirm",
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1,
				cfg = Item.getConfigData(arg1)
			},
			weight = LayerWeightConst.TOP_LAYER
		})
	end)

	local var2 = arg0.contextData.shipId

	if var2 ~= nil then
		local var3 = getProxy(BayProxy):getShipById(var2)

		arg0.contextData.shipVO = var3
		arg0.contextData.equipmentVO = var3:getEquip(arg0.contextData.pos)
	else
		local var4 = arg0.contextData.equipmentId

		if var4 ~= nil then
			local var5 = getProxy(EquipmentProxy)

			arg0.contextData.equipmentVO = var5:getEquipmentById(var4)
		end
	end
end

function var0.listNotificationInterests(arg0)
	return {
		GAME.UPGRADE_EQUIPMENTS_DONE,
		BagProxy.ITEM_UPDATED,
		PlayerProxy.UPDATED
	}
end

function var0.handleNotification(arg0, arg1)
	local var0 = arg1:getName()
	local var1 = arg1:getBody()

	if var0 == GAME.UPGRADE_EQUIPMENTS_DONE then
		local var2 = var1.ship
		local var3 = var1.equip
		local var4 = var1.newEquip

		arg0.contextData.shipVO = var2
		arg0.contextData.equipmentVO = var4

		arg0.viewComponent:updateAll()
		arg0.viewComponent:upgradeFinish(var3, var4)
	elseif var0 == BagProxy.ITEM_UPDATED then
		arg0.viewComponent:setItems(arg0.bagProxy:getData())
	elseif var0 == PlayerProxy.UPDATED then
		local var5 = getProxy(PlayerProxy)

		arg0.viewComponent:updateRes(var5:getData())
	end
end

return var0
