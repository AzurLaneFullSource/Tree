local var0 = class("EquipFromShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.equipmentId
	local var2 = var0.shipId
	local var3 = var0.pos
	local var4 = var0.oldShipId
	local var5 = var0.oldPos
	local var6 = getProxy(BayProxy)
	local var7 = getProxy(EquipmentProxy)
	local var8 = var6:getShipById(var2)

	if not var8 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var2))

		return
	end

	if var8:getEquip(var3) then
		local var9 = getProxy(PlayerProxy):getData()

		if var7:getCapacity() >= var9:getMaxEquipmentBag() then
			NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

			return
		end
	end

	local var10 = var6:getShipById(var4)

	if not var10 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var4))

		return
	end

	local var11 = var10:getEquip(var5)

	if not var11 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_error_noEquip"))

		return
	end

	local var12, var13 = var8:canEquipAtPos(var11, var3)

	if not var12 then
		pg.TipsMgr.GetInstance():ShowTips(var13)

		return
	end

	local var14 = {}

	table.insert(var14, function(arg0)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_equip_exchange_tip", var10:getName(), var11:getConfig("name"), var8:getName()),
			onYes = arg0
		})
	end)
	table.insert(var14, function(arg0)
		pg.ConnectionMgr.GetInstance():Send(12006, {
			equip_id = 0,
			type = 0,
			ship_id = var4,
			pos = var5
		}, 12007, function(arg0)
			if arg0.result == 0 then
				local var0 = var10:getEquip(var5)

				var10:updateEquip(var5, nil)
				var6:updateShip(var10)

				if var8.id == var10.id then
					var8 = var10
				end

				var7:addEquipment(var0)
				arg0(var8, var1, var2, var3)
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_unequipFromShip", arg0.result))
			end
		end)
	end)
	seriesAsync(var14, function(arg0, arg1, arg2, arg3)
		local var0 = var7:getEquipmentById(arg1)

		var0.count = 1

		assert(var0 and var0.count > 0)
		pg.ConnectionMgr.GetInstance():Send(12006, {
			type = 0,
			equip_id = arg1,
			ship_id = arg2,
			pos = arg3
		}, 12007, function(arg0)
			if arg0.result == 0 then
				local var0 = arg0:getEquip(arg3)
				local var1 = pg.equip_skin_template

				if var0 then
					var7:addEquipment(var0)
				end

				arg0:updateEquip(arg3, var0)
				var6:updateShip(arg0)
				var7:removeEquipmentById(arg1, 1)
				arg0:sendNotification(GAME.EQUIP_TO_SHIP_DONE, arg0)
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_ok", Equipment.getConfigData(arg1).name), "green")
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0.result))
			end
		end)
	end)
end

return var0
