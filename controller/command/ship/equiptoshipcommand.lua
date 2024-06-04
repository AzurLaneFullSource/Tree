local var0 = class("EquipToShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.equipmentId
	local var2 = var0.shipId
	local var3 = var0.pos
	local var4 = var0.callback
	local var5 = getProxy(BayProxy)
	local var6 = var5:getShipById(var2)

	if var6 == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var2))

		if var4 then
			var4(100)
		end

		return
	end

	local var7 = getProxy(EquipmentProxy)
	local var8 = var7:getEquipmentById(var1)
	local var9, var10 = var6:canEquipAtPos(var8, var3)

	if not var9 then
		pg.TipsMgr.GetInstance():ShowTips(var10)

		return
	end

	if not var8 or var8.count == 0 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_error_noEquip"))

		if var4 then
			var4(101)
		end

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12006, {
		type = 0,
		equip_id = var1,
		ship_id = var2,
		pos = var3
	}, 12007, function(arg0)
		if arg0.result == 0 then
			local var0 = var6:getEquip(var3)
			local var1 = var7:getEquipmentById(var1)

			assert(var1 and var1.count > 0)

			var1.count = 1

			if var0 then
				var7:addEquipment(var0)
			end

			var6:updateEquip(var3, var1)
			var5:updateShip(var6)
			var7:removeEquipmentById(var1, 1)
			arg0:sendNotification(GAME.EQUIP_TO_SHIP_DONE, var6)
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_ok", var1:getConfig("name")), "green")
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_EQUIPON)

			if var4 then
				var4()
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0.result))

			if var4 then
				var4()
			end
		end
	end)
end

return var0
