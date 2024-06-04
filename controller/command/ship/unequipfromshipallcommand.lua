local var0 = class("UnEquipFromShipAllCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody().shipId
	local var1 = getProxy(BayProxy):getShipById(var0)

	if var1 == nil then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_error_noShip", var0))

		return
	end

	local var2 = #var1.equipments
	local var3 = 0

	for iter0, iter1 in pairs(var1.equipments) do
		if iter1 then
			var3 = var3 + 1
		end
	end

	local var4 = getProxy(PlayerProxy):getData()
	local var5 = getProxy(EquipmentProxy):getCapacity()

	if var4:getMaxEquipmentBag() < var5 + var3 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)

		return
	end

	local var6 = var1:GetSpWeapon()
	local var7 = getProxy(EquipmentProxy):GetSpWeaponCapacity()
	local var8 = getProxy(EquipmentProxy):GetSpWeaponCount()

	if var6 and var7 <= var8 then
		NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), OpenSpWeaponPage, gotoChargeScene)

		return
	end

	arg0:fun(var1, 1, var2, function()
		if var6 then
			arg0:sendNotification(GAME.EQUIP_SPWEAPON_TO_SHIP, {
				shipId = var0
			})
		end
	end)
end

function var0.fun(arg0, arg1, arg2, arg3, arg4)
	if arg3 < arg2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("ship_unequip_all_success"))
		arg0:sendNotification(GAME.UNEQUIP_FROM_SHIP_DONE, arg1)
		existCall(arg4)

		return
	end

	local var0 = getProxy(BayProxy)
	local var1 = arg1:getEquip(arg2)

	if not var1 then
		arg0:fun(arg1, arg2 + 1, arg3, arg4)

		return
	end

	pg.ConnectionMgr.GetInstance():Send(12006, {
		equip_id = 0,
		type = 0,
		ship_id = arg1.id,
		pos = arg2
	}, 12007, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(EquipmentProxy)

			arg1:updateEquip(arg2, nil)
			var0:updateShip(arg1)
			var0:addEquipment(var1)
			arg0:fun(arg1, arg2 + 1, arg3, arg4)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("ship_unequipFromShip", arg0.result))
		end
	end)
end

return var0
