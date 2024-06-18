local var0_0 = class("EquipToShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.equipmentId
	local var2_1 = var0_1.shipId
	local var3_1 = var0_1.pos
	local var4_1 = var0_1.callback
	local var5_1 = getProxy(BayProxy)
	local var6_1 = var5_1:getShipById(var2_1)

	if var6_1 == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var2_1))

		if var4_1 then
			var4_1(100)
		end

		return
	end

	local var7_1 = getProxy(EquipmentProxy)
	local var8_1 = var7_1:getEquipmentById(var1_1)
	local var9_1, var10_1 = var6_1:canEquipAtPos(var8_1, var3_1)

	if not var9_1 then
		pg.TipsMgr.GetInstance():ShowTips(var10_1)

		return
	end

	if not var8_1 or var8_1.count == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_error_noEquip"))

		if var4_1 then
			var4_1(101)
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12006, {
		type = 0,
		equip_id = var1_1,
		ship_id = var2_1,
		pos = var3_1
	}, 12007, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var6_1:getEquip(var3_1)
			local var1_2 = var7_1:getEquipmentById(var1_1)

			assert(var1_2 and var1_2.count > 0)

			var1_2.count = 1

			if var0_2 then
				var7_1:addEquipment(var0_2)
			end

			var6_1:updateEquip(var3_1, var1_2)
			var5_1:updateShip(var6_1)
			var7_1:removeEquipmentById(var1_1, 1)
			arg0_1:sendNotification(GAME.EQUIP_TO_SHIP_DONE, var6_1)
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_ok", var1_2:getConfig("name")), "green")
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_EQUIPON)

			if var4_1 then
				var4_1()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0_2.result))

			if var4_1 then
				var4_1()
			end
		end
	end)
end

return var0_0
