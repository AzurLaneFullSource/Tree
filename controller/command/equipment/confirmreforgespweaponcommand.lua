local var0_0 = class("ConfirmReforgeSpWeaponCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.uid or 0
	local var2_1 = var0_1.shipId or 0
	local var3_1 = var0_1.op

	pg.ConnectionMgr.GetInstance():Send(14207, {
		ship_id = var2_1,
		spweapon_id = var1_1,
		cmd = var3_1
	}, 14208, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2, var1_2 = EquipmentProxy.StaticGetSpWeapon(var2_1, var1_1)

			if var3_1 == SpWeapon.CONFIRM_OP_EXCHANGE then
				local var2_2 = var0_2:GetAttributeOptions()

				var0_2:SetBaseAttributes(var2_2)
			end

			var0_2:SetAttributeOptions({
				0,
				0
			})

			if var1_2 then
				var1_2:UpdateSpWeapon(var0_2)
				getProxy(BayProxy):updateShip(var1_2)
			else
				getProxy(EquipmentProxy):AddSpWeapon(var0_2)
			end

			arg0_1:sendNotification(GAME.CONFIRM_REFORGE_SPWEAPON_DONE, var0_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("common", arg0_2.result))
		end
	end)
end

return var0_0
