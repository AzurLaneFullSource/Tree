local var0_0 = class("UnequipFromShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.pos
	local var3_1 = var0_1.callback
	local var4_1 = getProxy(BayProxy)
	local var5_1 = var4_1:getShipById(var1_1)
	local var6_1 = getProxy(PlayerProxy):getData()

	if getProxy(EquipmentProxy):getCapacity() >= var6_1:getMaxEquipmentBag() then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

		if var3_1 then
			var3_1()
		end

		return
	end

	if var5_1 == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var1_1))

		if var3_1 then
			var3_1()
		end

		return
	end

	local var7_1 = var5_1:getEquip(var2_1)

	if not var7_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequipFromShip_error_noEquip"))

		if var3_1 then
			var3_1()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12006, {
		equip_id = 0,
		type = 0,
		ship_id = var1_1,
		pos = var2_1
	}, 12007, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(EquipmentProxy)

			var5_1:updateEquip(var2_1, nil)
			var4_1:updateShip(var5_1)
			var7_1:setSkinId(0)
			var0_2:addEquipment(var7_1)
			arg0_1:sendNotification(GAME.UNEQUIP_FROM_SHIP_DONE, var5_1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequipFromShip_ok", var7_1:getConfig("name")), "red")

			if var5_1:getEquipSkin(var2_1) > 0 and not var5_1:checkCanEquipSkin(var2_1, var5_1:getEquipSkin(var2_1)) then
				arg0_1:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
					equipmentSkinId = 0,
					shipId = var1_1,
					pos = var2_1
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_unequipFromShip", arg0_2.result))
		end

		if var3_1 then
			var3_1()
		end
	end)
end

return var0_0
