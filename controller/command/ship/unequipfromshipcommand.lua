local var0 = class("UnequipFromShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.pos
	local var3 = var0.callback
	local var4 = getProxy(BayProxy)
	local var5 = var4:getShipById(var1)
	local var6 = getProxy(PlayerProxy):getData()

	if getProxy(EquipmentProxy):getCapacity() >= var6:getMaxEquipmentBag() then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

		if var3 then
			var3()
		end

		return
	end

	if var5 == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var1))

		if var3 then
			var3()
		end

		return
	end

	local var7 = var5:getEquip(var2)

	if not var7 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequipFromShip_error_noEquip"))

		if var3 then
			var3()
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12006, {
		equip_id = 0,
		type = 0,
		ship_id = var1,
		pos = var2
	}, 12007, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(EquipmentProxy)

			var5:updateEquip(var2, nil)
			var4:updateShip(var5)
			var7:setSkinId(0)
			var0:addEquipment(var7)
			arg0:sendNotification(GAME.UNEQUIP_FROM_SHIP_DONE, var5)
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequipFromShip_ok", var7:getConfig("name")), "red")

			if var5:getEquipSkin(var2) > 0 and not var5:checkCanEquipSkin(var2, var5:getEquipSkin(var2)) then
				arg0:sendNotification(GAME.EQUIP_EQUIPMENTSKIN_TO_SHIP, {
					equipmentSkinId = 0,
					shipId = var1,
					pos = var2
				})
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_unequipFromShip", arg0.result))
		end

		if var3 then
			var3()
		end
	end)
end

return var0
