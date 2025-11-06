local var0_0 = class("EquipUpgradeMediator", import("..base.ContextMediator"))

var0_0.EQUIPMENT_UPGRDE = "EquipUpgradeMediator:EQUIPMENT_UPGRDE"
var0_0.REPLACE_EQUIP = "EquipUpgradeMediator:REPLACE_EQUIP"

function var0_0.register(arg0_1)
	arg0_1:bind(var0_0.EQUIPMENT_UPGRDE, function(arg0_2, arg1_2, arg2_2, arg3_2)
		pg.UIMgr.GetInstance():LoadingOn()
		arg0_1:sendNotification(GAME.UPGRADE_EQUIPMENTS, {
			shipId = arg0_1.contextData.shipId,
			pos = arg0_1.contextData.pos,
			equipmentId = arg0_1.contextData.equipmentId,
			target = arg1_2,
			materials = arg2_2,
			consume = arg3_2
		})
	end)

	local var0_1 = arg0_1.contextData.shipId

	if var0_1 ~= nil then
		local var1_1 = getProxy(BayProxy):getShipById(var0_1)

		arg0_1.contextData.shipVO = var1_1
		arg0_1.contextData.equipmentVO = var1_1:getEquip(arg0_1.contextData.pos)
	else
		local var2_1 = arg0_1.contextData.equipmentId

		if var2_1 ~= nil then
			local var3_1 = getProxy(EquipmentProxy)

			arg0_1.contextData.equipmentVO = var3_1:getEquipmentById(var2_1)
		end
	end
end

function var0_0.listNotificationInterests(arg0_3)
	return {
		GAME.UPGRADE_EQUIPMENTS_DONE
	}
end

function var0_0.handleNotification(arg0_4, arg1_4)
	local var0_4 = arg1_4:getName()
	local var1_4 = arg1_4:getBody()

	if var0_4 == GAME.UPGRADE_EQUIPMENTS_DONE then
		local var2_4 = var1_4.ship
		local var3_4 = var1_4.equip
		local var4_4 = var1_4.newEquip

		arg0_4.contextData.shipVO = var2_4
		arg0_4.contextData.equipmentVO = var4_4

		arg0_4.viewComponent:updateAll()
		arg0_4.viewComponent:upgradeFinish(var3_4, var4_4)
		pg.UIMgr.GetInstance():LoadingOff()
	end
end

return var0_0
