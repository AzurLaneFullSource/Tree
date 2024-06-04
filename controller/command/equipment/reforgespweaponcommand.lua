local var0 = class("ReforgeSpWeaponCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.uid or 0
	local var2 = var0.shipId or 0
	local var3 = getProxy(BagProxy)
	local var4 = getProxy(PlayerProxy)
	local var5 = 0

	if not (function()
		local var0, var1 = EquipmentProxy.StaticGetSpWeapon(var2, var1)
		local var2 = var0:GetAttributeOptions()

		if not _.all(var2, function(arg0)
			return arg0 == 0
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_attr_modify"))

			return
		end

		local var3 = var3:getRawData()
		local var4 = var4:getData()
		local var5 = var0:GetUpgradeConfig()

		if not _.all(var5.reset_use_item, function(arg0)
			return arg0[2] <= (var3[arg0[1]] and var3[arg0[1]].count or 0)
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

			return
		end

		local var6 = var0:GetBaseAttributes()
		local var7 = var0:GetAttributesRange()

		if table.equal(var6, var7) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_transform_attrmax"))

			return
		end

		return true
	end)() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(14205, {
		ship_id = var2,
		spweapon_id = var1
	}, 14206, function(arg0)
		if arg0.result == 0 then
			local var0, var1 = EquipmentProxy.StaticGetSpWeapon(var2, var1)

			var0:SetAttributeOptions({
				arg0.attr_temp_1,
				arg0.attr_temp_2
			})

			if var1 then
				var1:UpdateSpWeapon(var0)
				getProxy(BayProxy):updateShip(var1)
			else
				getProxy(EquipmentProxy):AddSpWeapon(var0)
			end

			local var2 = var0:GetUpgradeConfig()

			_.each(var2.reset_use_item, function(arg0)
				var3:removeItemById(arg0[1], arg0[2])
			end)
			arg0:sendNotification(GAME.REFORGE_SPWEAPON_DONE, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("common", arg0.result))
		end
	end)
end

return var0
