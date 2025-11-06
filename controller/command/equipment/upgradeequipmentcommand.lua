local var0_0 = class("UpGradeEquipmentCommands", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.pos
	local var3_1 = var0_1.equipmentId
	local var4_1 = var0_1.target
	local var5_1 = var0_1.materials
	local var6_1 = var0_1.consume
	local var7_1

	if var1_1 then
		var7_1 = getProxy(BayProxy):getShipById(var1_1):getEquip(var2_1)

		assert(var7_1, "can not find equipment at ship.")
	else
		var7_1 = getProxy(EquipmentProxy):getEquipmentById(var3_1)

		assert(var7_1, "can not find equipment: " .. var3_1)
	end

	if not Equipment.canUpgrade(var7_1.configId) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipment_max_level"))

		return
	end

	local var8_1 = var1_1 and 14002 or 14004
	local var9_1 = var1_1 and 14003 or 14005
	local var10_1 = var1_1 and {
		ship_id = var1_1,
		pos = var2_1,
		lv = var4_1:getConfig("level") - var7_1:getConfig("level")
	} or {
		equip_id = var3_1,
		lv = var4_1:getConfig("level") - var7_1:getConfig("level")
	}

	pg.ConnectionMgr.GetInstance():Send(var8_1, var10_1, var9_1, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(BayProxy)
			local var1_2 = getProxy(BagProxy)
			local var2_2 = getProxy(EquipmentProxy)
			local var3_2 = getProxy(PlayerProxy)
			local var4_2
			local var5_2

			if var1_1 then
				var4_2 = var0_2:getShipById(var1_1)
				var5_2 = var4_2:getEquip(var2_1)
			else
				var5_2 = var2_2:getEquipmentById(var3_1)
			end

			reducePlayerOwn(Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = PlayerConst.ResGold,
				count = var6_1
			}))

			for iter0_2, iter1_2 in ipairs(var5_1) do
				reducePlayerOwn(iter1_2)
			end

			if var4_2 then
				var4_2:updateEquip(var2_1, var4_1)
				var0_2:updateShip(var4_2)
			elseif var5_2 then
				var2_2:removeEquipmentById(var5_2.id, 1)
				var2_2:addEquipmentById(var4_1.id, 1, true)
			end

			arg0_1:sendNotification(GAME.UPGRADE_EQUIPMENTS_DONE, {
				ship = var4_2,
				equip = var5_2,
				newEquip = var4_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("equipment_upgrade_erro", arg0_2.result))
		end
	end)
end

return var0_0
