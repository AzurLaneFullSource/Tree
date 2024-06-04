local var0 = class("UpdateShipSpWeaponCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.spWeaponUid or 0
	local var2 = var0.shipId
	local var3 = var0.callback
	local var4 = getProxy(BayProxy)
	local var5 = getProxy(EquipmentProxy)
	local var6

	if var1 and var1 ~= 0 then
		var6 = var5:GetSpWeaponByUid(var1)

		assert(var6, "不存在该特殊兵装" .. var1)

		if not var6 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_error_noEquip"))

			return
		end
	end

	local var7 = var4:getShipById(var2)

	if var7 == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var2))

		return
	end

	local var8, var9 = ShipStatus.ShipStatusCheck("onModify", var7)

	if not var8 then
		pg.TipsMgr.GetInstance():ShowTips(var9)

		return
	end

	if not var6 then
		if not var7:GetSpWeapon() then
			return
		end

		if getProxy(EquipmentProxy):GetSpWeaponCapacity() <= getProxy(EquipmentProxy):GetSpWeaponCount() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_bag_no_enough"))

			return
		end
	end

	if var6 then
		local var10, var11 = var7:CanEquipSpWeapon(var6)

		if not var10 then
			pg.TipsMgr.GetInstance():ShowTips(var11)

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(14201, {
		spweapon_id = var1,
		ship_id = var2
	}, 14202, function(arg0)
		if arg0.result == 0 then
			local var0 = var7:GetSpWeapon()
			local var1 = var6

			if var0 then
				var5:AddSpWeapon(var0)
			end

			var7:UpdateSpWeapon(var1)
			var4:updateShip(var7)

			if var1 and var1 ~= 0 then
				var5:RemoveSpWeapon(var1)
			end

			arg0:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP_DONE, var7)

			if var1 and var1 ~= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_ok", var1:GetName()), "green")
			end

			if var0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequipFromShip_ok", var0:GetName()), "red")
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_EQUIPON)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0.result))
		end

		existCall(var3)
	end)
end

return var0
