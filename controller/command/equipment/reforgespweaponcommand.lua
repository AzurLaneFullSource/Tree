local var0_0 = class("ReforgeSpWeaponCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.uid or 0
	local var2_1 = var0_1.shipId or 0
	local var3_1 = getProxy(BagProxy)
	local var4_1 = getProxy(PlayerProxy)
	local var5_1 = 0

	if not (function()
		local var0_2, var1_2 = EquipmentProxy.StaticGetSpWeapon(var2_1, var1_1)
		local var2_2 = var0_2:GetAttributeOptions()

		if not _.all(var2_2, function(arg0_3)
			return arg0_3 == 0
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_attr_modify"))

			return
		end

		local var3_2 = var3_1:getRawData()
		local var4_2 = var4_1:getData()
		local var5_2 = var0_2:GetUpgradeConfig()

		if not _.all(var5_2.reset_use_item, function(arg0_4)
			return arg0_4[2] <= (var3_2[arg0_4[1]] and var3_2[arg0_4[1]].count or 0)
		end) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_materal_no_enough"))

			return
		end

		local var6_2 = var0_2:GetBaseAttributes()
		local var7_2 = var0_2:GetAttributesRange()

		if table.equal(var6_2, var7_2) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("spweapon_tip_transform_attrmax"))

			return
		end

		return true
	end)() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(14205, {
		ship_id = var2_1,
		spweapon_id = var1_1
	}, 14206, function(arg0_5)
		if arg0_5.result == 0 then
			local var0_5, var1_5 = EquipmentProxy.StaticGetSpWeapon(var2_1, var1_1)

			var0_5:SetAttributeOptions({
				arg0_5.attr_temp_1,
				arg0_5.attr_temp_2
			})

			if var1_5 then
				var1_5:UpdateSpWeapon(var0_5)
				getProxy(BayProxy):updateShip(var1_5)
			else
				getProxy(EquipmentProxy):AddSpWeapon(var0_5)
			end

			local var2_5 = var0_5:GetUpgradeConfig()

			_.each(var2_5.reset_use_item, function(arg0_6)
				var3_1:removeItemById(arg0_6[1], arg0_6[2])
			end)
			arg0_1:sendNotification(GAME.REFORGE_SPWEAPON_DONE, var0_5)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("common", arg0_5.result))
		end
	end)
end

return var0_0
