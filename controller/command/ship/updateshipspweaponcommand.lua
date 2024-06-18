local var0_0 = class("UpdateShipSpWeaponCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.spWeaponUid or 0
	local var2_1 = var0_1.shipId
	local var3_1 = var0_1.callback
	local var4_1 = getProxy(BayProxy)
	local var5_1 = getProxy(EquipmentProxy)
	local var6_1

	if var1_1 and var1_1 ~= 0 then
		var6_1 = var5_1:GetSpWeaponByUid(var1_1)

		assert(var6_1, "不存在该特殊兵装" .. var1_1)

		if not var6_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_error_noEquip"))

			return
		end
	end

	local var7_1 = var4_1:getShipById(var2_1)

	if var7_1 == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var2_1))

		return
	end

	local var8_1, var9_1 = ShipStatus.ShipStatusCheck("onModify", var7_1)

	if not var8_1 then
		pg.TipsMgr.GetInstance():ShowTips(var9_1)

		return
	end

	if not var6_1 then
		if not var7_1:GetSpWeapon() then
			return
		end

		if getProxy(EquipmentProxy):GetSpWeaponCapacity() <= getProxy(EquipmentProxy):GetSpWeaponCount() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_bag_no_enough"))

			return
		end
	end

	if var6_1 then
		local var10_1, var11_1 = var7_1:CanEquipSpWeapon(var6_1)

		if not var10_1 then
			pg.TipsMgr.GetInstance():ShowTips(var11_1)

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(14201, {
		spweapon_id = var1_1,
		ship_id = var2_1
	}, 14202, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var7_1:GetSpWeapon()
			local var1_2 = var6_1

			if var0_2 then
				var5_1:AddSpWeapon(var0_2)
			end

			var7_1:UpdateSpWeapon(var1_2)
			var4_1:updateShip(var7_1)

			if var1_1 and var1_1 ~= 0 then
				var5_1:RemoveSpWeapon(var1_2)
			end

			arg0_1:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP_DONE, var7_1)

			if var1_1 and var1_1 ~= 0 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_equipToShip_ok", var1_2:GetName()), "green")
			end

			if var0_2 then
				pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequipFromShip_ok", var0_2:GetName()), "red")
			end

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(SFX_UI_DOCKYARD_EQUIPON)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_equipToShip", arg0_2.result))
		end

		existCall(var3_1)
	end)
end

return var0_0
