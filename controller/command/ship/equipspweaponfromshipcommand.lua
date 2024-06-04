local var0 = class("EquipSpWeaponFromShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shipId
	local var2 = var0.oldShipId
	local var3 = var0.spWeaponUid
	local var4 = getProxy(BayProxy)
	local var5 = getProxy(EquipmentProxy)
	local var6
	local var7
	local var8

	if not (function()
		var7 = var4:getShipById(var1)

		if var7 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var1))

			return
		end

		local var0, var1 = ShipStatus.ShipStatusCheck("onModify", var7)

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(var1)

			return
		end

		if var7:GetSpWeapon() and getProxy(EquipmentProxy):GetSpWeaponCapacity() <= getProxy(EquipmentProxy):GetSpWeaponCount() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_bag_no_enough"))

			return
		end

		var8 = var4:getShipById(var2)

		if var8 == nil then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var2))

			return
		end

		local var2, var3 = ShipStatus.ShipStatusCheck("onModify", var8)
		local var4 = var3

		if not var2 then
			pg.TipsMgr.GetInstance():ShowTips(var4)

			return
		end

		local var5, var6 = ShipStatus.ShipStatusCheck("onModify", var8)

		if not var5 then
			pg.TipsMgr.GetInstance():ShowTips(var6)
		end

		var6 = var8:GetSpWeapon()

		if not var6 or var6:GetUID() ~= var3 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_error_noEquip"))

			return
		end

		local var7, var8 = var7:CanEquipSpWeapon(var6)

		if not var7 then
			pg.TipsMgr.GetInstance():ShowTips(var8)

			return
		end

		return true
	end)() then
		return
	end

	seriesAsync({
		function(arg0)
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("ship_equip_exchange_tip", var8:getName(), var6:GetName(), var7:getName()),
				onYes = arg0
			})
		end,
		function(arg0)
			pg.ConnectionMgr.GetInstance():Send(14201, {
				spweapon_id = 0,
				ship_id = var2
			}, 14202, function(arg0)
				if arg0.result == 0 then
					local var0 = var4:getShipById(var2)
					local var1 = var0:GetSpWeapon()

					var0:UpdateSpWeapon(nil)
					var4:updateShip(var0)
					var5:AddSpWeapon(var1)
					arg0(var1:GetUID())
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_unequipFromShip", arg0.result))
				end
			end)
		end,
		function(arg0, arg1)
			pg.ConnectionMgr.GetInstance():Send(14201, {
				spweapon_id = arg1,
				ship_id = var1
			}, 14202, function(arg0)
				if arg0.result == 0 then
					local var0 = var4:getShipById(var1)
					local var1 = var0:GetSpWeapon()

					if var1 then
						var5:AddSpWeapon(var1)
					end

					local var2 = var5:GetSpWeaponByUid(arg1)

					var0:UpdateSpWeapon(var2)
					var4:updateShip(var0)
					var5:RemoveSpWeapon(var2)
					arg0:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP_DONE, var0)
					pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_ok", var2:GetName()), "green")
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0.result))
				end
			end)
		end
	})
end

return var0
