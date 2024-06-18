local var0_0 = class("ShipEquipAllChangeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(BayProxy)
	local var2_1 = getProxy(EquipmentProxy)

	local function var3_1(arg0_2, arg1_2, arg2_2)
		return function(arg0_3)
			pg.ConnectionMgr.GetInstance():Send(12006, {
				type = 0,
				ship_id = arg0_2,
				equip_id = arg1_2,
				pos = arg2_2
			}, 12007, function(arg0_4)
				if arg0_4.result == 0 then
					local var0_4 = var1_1:getShipById(arg0_2)
					local var1_4 = var0_4:getEquip(arg2_2)

					if var1_4 then
						var2_1:addEquipment(var1_4)
					end

					local var2_4 = arg1_2 > 0 and var2_1:getEquipmentById(arg1_2) or nil

					if var2_4 then
						var2_4.count = 1

						var2_1:removeEquipmentById(arg1_2, 1)
					end

					var0_4:updateEquip(arg2_2, var2_4)
					var1_1:updateShip(var0_4)
					existCall(arg0_3)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0_4.result))
				end
			end)
		end
	end

	local function var4_1(arg0_5, arg1_5)
		return function(arg0_6)
			pg.ConnectionMgr.GetInstance():Send(14201, {
				spweapon_id = arg1_5,
				ship_id = arg0_5
			}, 14202, function(arg0_7)
				if arg0_7.result == 0 then
					local var0_7 = var1_1:getShipById(arg0_5)
					local var1_7 = var0_7:GetSpWeapon()

					if var1_7 then
						var2_1:AddSpWeapon(var1_7)
					end

					local var2_7 = arg1_5 > 0 and var2_1:GetSpWeaponByUid(arg1_5) or nil

					if var2_7 then
						var2_1:RemoveSpWeapon(var2_7)
					end

					var0_7:UpdateSpWeapon(var2_7)
					var1_1:updateShip(var0_7)
					existCall(arg0_6)
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0_7.result))
				end
			end)
		end
	end

	local var5_1 = var0_1.shipId
	local var6_1 = var1_1:getShipById(var5_1)

	if not var6_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var5_1))

		return
	end

	local var7_1 = {}
	local var8_1 = {}
	local var9_1 = var0_1.equipData
	local var10_1 = 0
	local var11_1 = 0

	for iter0_1, iter1_1 in ipairs(var9_1) do
		local var12_1 = false

		if iter0_1 == 6 then
			if iter1_1 then
				var12_1 = iter1_1 and iter1_1.shipId == var5_1
			else
				var12_1 = not var6_1.spWeapon
			end

			if not var12_1 then
				if iter1_1 and iter1_1.shipId then
					table.insert(var8_1, var4_1(iter1_1.shipId, 0))
				end

				table.insert(var8_1, var4_1(var5_1, iter1_1 and iter1_1.uid or 0))

				if var6_1.spWeapon or iter1_1 and iter1_1.shipId then
					var11_1 = var11_1 + 1
				end
			end
		else
			if iter1_1 then
				var12_1 = iter1_1 and iter1_1.shipId == var5_1 and iter1_1.shipPos == iter0_1
			else
				var12_1 = not var6_1.equipments[iter0_1]
			end

			if not var12_1 then
				if var6_1.equipments[iter0_1] then
					table.insert(var7_1, var3_1(var5_1, 0, iter0_1))
				end

				if iter1_1 and iter1_1.shipId and iter1_1.shipId ~= var5_1 then
					table.insert(var8_1, var3_1(iter1_1.shipId, 0, iter1_1.shipPos))
				end

				table.insert(var8_1, var3_1(var5_1, iter1_1 and iter1_1.id or 0, iter0_1))

				if var6_1.equipments[iter0_1] or iter1_1 and iter1_1.shipId then
					var10_1 = var10_1 + 1
				end
			end
		end
	end

	if var10_1 > 0 and getProxy(PlayerProxy):getData():getMaxEquipmentBag() < var2_1:getCapacity() + var10_1 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

		return
	end

	if var11_1 > 0 and var2_1:GetSpWeaponCapacity() < var2_1:GetSpWeaponCount() + var11_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_bag_no_enough"))

		return
	end

	seriesAsync(table.mergeArray(var7_1, var8_1), function()
		arg0_1:sendNotification(GAME.SHIP_EQUIP_ALL_CHANGE_DONE, var5_1)
		pg.TipsMgr.GetInstance():ShowTips(i18n("equipcode_import_success"))
	end)
end

return var0_0
