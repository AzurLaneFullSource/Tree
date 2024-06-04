local var0 = class("ShipEquipAllChangeCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(BayProxy)
	local var2 = getProxy(EquipmentProxy)

	local function var3(arg0, arg1, arg2)
		return function(arg0)
			pg.ConnectionMgr.GetInstance():Send(12006, {
				type = 0,
				ship_id = arg0,
				equip_id = arg1,
				pos = arg2
			}, 12007, function(arg0)
				if arg0.result == 0 then
					local var0 = var1:getShipById(arg0)
					local var1 = var0:getEquip(arg2)

					if var1 then
						var2:addEquipment(var1)
					end

					local var2 = arg1 > 0 and var2:getEquipmentById(arg1) or nil

					if var2 then
						var2.count = 1

						var2:removeEquipmentById(arg1, 1)
					end

					var0:updateEquip(arg2, var2)
					var1:updateShip(var0)
					existCall(arg0)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0.result))
				end
			end)
		end
	end

	local function var4(arg0, arg1)
		return function(arg0)
			pg.ConnectionMgr.GetInstance():Send(14201, {
				spweapon_id = arg1,
				ship_id = arg0
			}, 14202, function(arg0)
				if arg0.result == 0 then
					local var0 = var1:getShipById(arg0)
					local var1 = var0:GetSpWeapon()

					if var1 then
						var2:AddSpWeapon(var1)
					end

					local var2 = arg1 > 0 and var2:GetSpWeaponByUid(arg1) or nil

					if var2 then
						var2:RemoveSpWeapon(var2)
					end

					var0:UpdateSpWeapon(var2)
					var1:updateShip(var0)
					existCall(arg0)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0.result))
				end
			end)
		end
	end

	local var5 = var0.shipId
	local var6 = var1:getShipById(var5)

	if not var6 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var5))

		return
	end

	local var7 = {}
	local var8 = {}
	local var9 = var0.equipData
	local var10 = 0
	local var11 = 0

	for iter0, iter1 in ipairs(var9) do
		local var12 = false

		if iter0 == 6 then
			if iter1 then
				var12 = iter1 and iter1.shipId == var5
			else
				var12 = not var6.spWeapon
			end

			if not var12 then
				if iter1 and iter1.shipId then
					table.insert(var8, var4(iter1.shipId, 0))
				end

				table.insert(var8, var4(var5, iter1 and iter1.uid or 0))

				if var6.spWeapon or iter1 and iter1.shipId then
					var11 = var11 + 1
				end
			end
		else
			if iter1 then
				var12 = iter1 and iter1.shipId == var5 and iter1.shipPos == iter0
			else
				var12 = not var6.equipments[iter0]
			end

			if not var12 then
				if var6.equipments[iter0] then
					table.insert(var7, var3(var5, 0, iter0))
				end

				if iter1 and iter1.shipId and iter1.shipId ~= var5 then
					table.insert(var8, var3(iter1.shipId, 0, iter1.shipPos))
				end

				table.insert(var8, var3(var5, iter1 and iter1.id or 0, iter0))

				if var6.equipments[iter0] or iter1 and iter1.shipId then
					var10 = var10 + 1
				end
			end
		end
	end

	if var10 > 0 and getProxy(PlayerProxy):getData():getMaxEquipmentBag() < var2:getCapacity() + var10 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

		return
	end

	if var11 > 0 and var2:GetSpWeaponCapacity() < var2:GetSpWeaponCount() + var11 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_bag_no_enough"))

		return
	end

	seriesAsync(table.mergeArray(var7, var8), function()
		arg0:sendNotification(GAME.SHIP_EQUIP_ALL_CHANGE_DONE, var5)
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_import_success"))
	end)
end

return var0
