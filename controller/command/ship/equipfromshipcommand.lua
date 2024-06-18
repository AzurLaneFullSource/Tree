local var0_0 = class("EquipFromShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.equipmentId
	local var2_1 = var0_1.shipId
	local var3_1 = var0_1.pos
	local var4_1 = var0_1.oldShipId
	local var5_1 = var0_1.oldPos
	local var6_1 = getProxy(BayProxy)
	local var7_1 = getProxy(EquipmentProxy)
	local var8_1 = var6_1:getShipById(var2_1)

	if not var8_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var2_1))

		return
	end

	if var8_1:getEquip(var3_1) then
		local var9_1 = getProxy(PlayerProxy):getData()

		if var7_1:getCapacity() >= var9_1:getMaxEquipmentBag() then
			NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

			return
		end
	end

	local var10_1 = var6_1:getShipById(var4_1)

	if not var10_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var4_1))

		return
	end

	local var11_1 = var10_1:getEquip(var5_1)

	if not var11_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_error_noEquip"))

		return
	end

	local var12_1, var13_1 = var8_1:canEquipAtPos(var11_1, var3_1)

	if not var12_1 then
		pg.TipsMgr.GetInstance():ShowTips(var13_1)

		return
	end

	local var14_1 = {}

	table.insert(var14_1, function(arg0_2)
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("ship_equip_exchange_tip", var10_1:getName(), var11_1:getConfig("name"), var8_1:getName()),
			onYes = arg0_2
		})
	end)
	table.insert(var14_1, function(arg0_3)
		pg.ConnectionMgr.GetInstance():Send(12006, {
			equip_id = 0,
			type = 0,
			ship_id = var4_1,
			pos = var5_1
		}, 12007, function(arg0_4)
			if arg0_4.result == 0 then
				local var0_4 = var10_1:getEquip(var5_1)

				var10_1:updateEquip(var5_1, nil)
				var6_1:updateShip(var10_1)

				if var8_1.id == var10_1.id then
					var8_1 = var10_1
				end

				var7_1:addEquipment(var0_4)
				arg0_3(var8_1, var1_1, var2_1, var3_1)
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_unequipFromShip", arg0_4.result))
			end
		end)
	end)
	seriesAsync(var14_1, function(arg0_5, arg1_5, arg2_5, arg3_5)
		local var0_5 = var7_1:getEquipmentById(arg1_5)

		var0_5.count = 1

		assert(var0_5 and var0_5.count > 0)
		pg.ConnectionMgr.GetInstance():Send(12006, {
			type = 0,
			equip_id = arg1_5,
			ship_id = arg2_5,
			pos = arg3_5
		}, 12007, function(arg0_6)
			if arg0_6.result == 0 then
				local var0_6 = arg0_5:getEquip(arg3_5)
				local var1_6 = pg.equip_skin_template

				if var0_6 then
					var7_1:addEquipment(var0_6)
				end

				arg0_5:updateEquip(arg3_5, var0_5)
				var6_1:updateShip(arg0_5)
				var7_1:removeEquipmentById(arg1_5, 1)
				arg0_1:sendNotification(GAME.EQUIP_TO_SHIP_DONE, arg0_5)
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_ok", Equipment.getConfigData(arg1_5).name), "green")
			else
				pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0_6.result))
			end
		end)
	end)
end

return var0_0
