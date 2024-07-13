local var0_0 = class("EquipSpWeaponFromShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shipId
	local var2_1 = var0_1.oldShipId
	local var3_1 = var0_1.spWeaponUid
	local var4_1 = getProxy(BayProxy)
	local var5_1 = getProxy(EquipmentProxy)
	local var6_1
	local var7_1
	local var8_1

	if not (function()
		var7_1 = var4_1:getShipById(var1_1)

		if var7_1 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var1_1))

			return
		end

		local var0_2, var1_2 = ShipStatus.ShipStatusCheck("onModify", var7_1)

		if not var0_2 then
			pg.TipsMgr.GetInstance():ShowTips(var1_2)

			return
		end

		if var7_1:GetSpWeapon() and getProxy(EquipmentProxy):GetSpWeaponCapacity() <= getProxy(EquipmentProxy):GetSpWeaponCount() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_bag_no_enough"))

			return
		end

		var8_1 = var4_1:getShipById(var2_1)

		if var8_1 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var2_1))

			return
		end

		local var2_2, var3_2 = ShipStatus.ShipStatusCheck("onModify", var8_1)
		local var4_2 = var3_2

		if not var2_2 then
			pg.TipsMgr.GetInstance():ShowTips(var4_2)

			return
		end

		local var5_2, var6_2 = ShipStatus.ShipStatusCheck("onModify", var8_1)

		if not var5_2 then
			pg.TipsMgr.GetInstance():ShowTips(var6_2)
		end

		var6_1 = var8_1:GetSpWeapon()

		if not var6_1 or var6_1:GetUID() ~= var3_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_error_noEquip"))

			return
		end

		local var7_2, var8_2 = var7_1:CanEquipSpWeapon(var6_1)

		if not var7_2 then
			pg.TipsMgr.GetInstance():ShowTips(var8_2)

			return
		end

		return true
	end)() then
		return
	end

	seriesAsync({
		function(arg0_3)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("ship_equip_exchange_tip", var8_1:getName(), var6_1:GetName(), var7_1:getName()),
				onYes = arg0_3
			})
		end,
		function(arg0_4)
			pg.ConnectionMgr.GetInstance():Send(14201, {
				spweapon_id = 0,
				ship_id = var2_1
			}, 14202, function(arg0_5)
				if arg0_5.result == 0 then
					local var0_5 = var4_1:getShipById(var2_1)
					local var1_5 = var0_5:GetSpWeapon()

					var0_5:UpdateSpWeapon(nil)
					var4_1:updateShip(var0_5)
					var5_1:AddSpWeapon(var1_5)
					arg0_4(var1_5:GetUID())
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_unequipFromShip", arg0_5.result))
				end
			end)
		end,
		function(arg0_6, arg1_6)
			pg.ConnectionMgr.GetInstance():Send(14201, {
				spweapon_id = arg1_6,
				ship_id = var1_1
			}, 14202, function(arg0_7)
				if arg0_7.result == 0 then
					local var0_7 = var4_1:getShipById(var1_1)
					local var1_7 = var0_7:GetSpWeapon()

					if var1_7 then
						var5_1:AddSpWeapon(var1_7)
					end

					local var2_7 = var5_1:GetSpWeaponByUid(arg1_6)

					var0_7:UpdateSpWeapon(var2_7)
					var4_1:updateShip(var0_7)
					var5_1:RemoveSpWeapon(var2_7)
					arg0_1:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP_DONE, var0_7)
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_ok", var2_7:GetName()), "green")
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0_7.result))
				end
			end)
		end
	})
end

return var0_0
