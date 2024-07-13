local var0_0 = class("UnEquipFromShipAllCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().shipId
	local var1_1 = getProxy(BayProxy):getShipById(var0_1)

	if var1_1 == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var0_1))

		return
	end

	local var2_1 = #var1_1.equipments
	local var3_1 = 0

	for iter0_1, iter1_1 in pairs(var1_1.equipments) do
		if iter1_1 then
			var3_1 = var3_1 + 1
		end
	end

	local var4_1 = getProxy(PlayerProxy):getData()
	local var5_1 = getProxy(EquipmentProxy):getCapacity()

	if var4_1:getMaxEquipmentBag() < var5_1 + var3_1 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

		return
	end

	local var6_1 = var1_1:GetSpWeapon()
	local var7_1 = getProxy(EquipmentProxy):GetSpWeaponCapacity()
	local var8_1 = getProxy(EquipmentProxy):GetSpWeaponCount()

	if var6_1 and var7_1 <= var8_1 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), OpenSpWeaponPage, gotoChargeScene)

		return
	end

	arg0_1:fun(var1_1, 1, var2_1, function()
		if var6_1 then
			arg0_1:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
				shipId = var0_1
			})
		end
	end)
end

function var0_0.fun(arg0_3, arg1_3, arg2_3, arg3_3, arg4_3)
	if arg3_3 < arg2_3 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequip_all_success"))
		arg0_3:sendNotification(GAME.UNEQUIP_FROM_SHIP_DONE, arg1_3)
		existCall(arg4_3)

		return
	end

	local var0_3 = getProxy(BayProxy)
	local var1_3 = arg1_3:getEquip(arg2_3)

	if not var1_3 then
		arg0_3:fun(arg1_3, arg2_3 + 1, arg3_3, arg4_3)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12006, {
		equip_id = 0,
		type = 0,
		ship_id = arg1_3.id,
		pos = arg2_3
	}, 12007, function(arg0_4)
		if arg0_4.result == 0 then
			local var0_4 = getProxy(EquipmentProxy)

			arg1_3:updateEquip(arg2_3, nil)
			var0_3:updateShip(arg1_3)
			var0_4:addEquipment(var1_3)
			arg0_3:fun(arg1_3, arg2_3 + 1, arg3_3, arg4_3)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_unequipFromShip", arg0_4.result))
		end
	end)
end

return var0_0
