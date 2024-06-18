local var0_0 = class("EquipUpgradeMediator", import("..base.ContextMediator"))

var0_0.EQUIPMENT_UPGRDE = "EquipUpgradeMediator:EQUIPMENT_UPGRDE"
var0_0.REPLACE_EQUIP = "EquipUpgradeMediator:REPLACE_EQUIP"
var0_0.ON_ITEM = "EquipUpgradeMediator:ON_ITEM"

function var0_0.register(arg0_1)
	arg0_1.bagProxy = getProxy(BagProxy)

	local var0_1 = arg0_1.bagProxy:getData()

	arg0_1.viewComponent:setItems(var0_1)

	local var1_1 = getProxy(PlayerProxy)

	arg0_1.viewComponent:updateRes(var1_1:getData())
	arg0_1:bind(var0_0.EQUIPMENT_UPGRDE, function(arg0_2)
		arg0_1:sendNotification(GAME.UPGRADE_EQUIPMENTS, {
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos,
			equipmentId = arg0_1.contextData.equipmentId
		})
	end)
	arg0_1:bind(var0_0.ON_ITEM, function(arg0_3, arg1_3)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			hideNo = true,
			content = "",
			yesText = "text_confirm",
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				type = DROP_TYPE_ITEM,
				id = arg1_3,
				cfg = Item.getConfigData(arg1_3)
			},
			weight = LayerWeightConst.TOP_LAYER
		})
	end)

	local var2_1 = arg0_1.contextData.shipId

	if var2_1 ~= nil then
		local var3_1 = getProxy(BayProxy):getShipById(var2_1)

		arg0_1.contextData.shipVO = var3_1
		arg0_1.contextData.equipmentVO = var3_1:getEquip(arg0_1.contextData.pos)
	else
		local var4_1 = arg0_1.contextData.equipmentId

		if var4_1 ~= nil then
			local var5_1 = getProxy(EquipmentProxy)

			arg0_1.contextData.equipmentVO = var5_1:getEquipmentById(var4_1)
		end
	end
end

function var0_0.listNotificationInterests(arg0_4)
	return {
		GAME.UPGRADE_EQUIPMENTS_DONE,
		BagProxy.ITEM_UPDATED,
		PlayerProxy.UPDATED
	}
end

function var0_0.handleNotification(arg0_5, arg1_5)
	local var0_5 = arg1_5:getName()
	local var1_5 = arg1_5:getBody()

	if var0_5 == GAME.UPGRADE_EQUIPMENTS_DONE then
		local var2_5 = var1_5.ship
		local var3_5 = var1_5.equip
		local var4_5 = var1_5.newEquip

		arg0_5.contextData.shipVO = var2_5
		arg0_5.contextData.equipmentVO = var4_5

		arg0_5.viewComponent:updateAll()
		arg0_5.viewComponent:upgradeFinish(var3_5, var4_5)
	elseif var0_5 == BagProxy.ITEM_UPDATED then
		arg0_5.viewComponent:setItems(arg0_5.bagProxy:getData())
	elseif var0_5 == PlayerProxy.UPDATED then
		local var5_5 = getProxy(PlayerProxy)

		arg0_5.viewComponent:updateRes(var5_5:getData())
	end
end

return var0_0
