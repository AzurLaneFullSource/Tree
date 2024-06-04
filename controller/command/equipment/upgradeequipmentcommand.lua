local var0 = class("UpGradeEquipmentCommands", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.pos
	local var3 = var0.equipmentId
	local var4

	if var1 then
		var4 = getProxy(BayProxy):getShipById(var1):getEquip(var2)

		assert(var4, "can not find equipment at ship.")
	else
		var4 = getProxy(EquipmentProxy):getEquipmentById(var3)

		assert(var4, "can not find equipment: " .. var3)
	end

	if not Equipment.canUpgrade(var4.configId) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_max_level"))

		return
	end

	local var5 = var1 and 14002 or 14004
	local var6 = var1 and 14003 or 14005
	local var7 = var1 and {
		ship_id = var1,
		pos = var2
	} or {
		type = 0,
		equip_id = var3
	}

	pg.ConnectionMgr.GetInstance():Send(var5, var7, var6, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(BayProxy)
			local var1 = getProxy(BagProxy)
			local var2 = getProxy(EquipmentProxy)
			local var3 = getProxy(PlayerProxy)
			local var4
			local var5

			if var1 then
				var4 = var0:getShipById(var1)
				var5 = var4:getEquip(var2)
			else
				var5 = var2:getEquipmentById(var3)
			end

			local var6 = var3:getData()
			local var7 = var5:getConfig("trans_use_gold")

			var6:consume({
				gold = var7
			})
			var3:updatePlayer(var6)

			local var8 = var5:getConfig("trans_use_item")

			for iter0, iter1 in ipairs(var8) do
				var1:removeItemById(iter1[1], iter1[2])
			end

			local var9 = var5:MigrateTo(var5:getConfig("next"))

			if var4 then
				var4:updateEquip(var2, var9)
				var0:updateShip(var4)
			elseif var5 then
				var2:removeEquipmentById(var5.id, 1)
				var2:addEquipmentById(var9.id, 1, true)
			end

			arg0:sendNotification(GAME.UPGRADE_EQUIPMENTS_DONE, {
				ship = var4,
				equip = var5,
				newEquip = var9
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_upgrade_erro", arg0.result))
		end
	end)
end

return var0
