local var0 = class("ConfirmReforgeSpWeaponCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.uid or 0
	local var2 = var0.shipId or 0
	local var3 = var0.op

	pg.ConnectionMgr.GetInstance():Send(14207, {
		ship_id = var2,
		spweapon_id = var1,
		cmd = var3
	}, 14208, function(arg0)
		if arg0.result == 0 then
			local var0, var1 = EquipmentProxy.StaticGetSpWeapon(var2, var1)

			if var3 == SpWeapon.CONFIRM_OP_EXCHANGE then
				local var2 = var0:GetAttributeOptions()

				var0:SetBaseAttributes(var2)
			end

			var0:SetAttributeOptions({
				0,
				0
			})

			if var1 then
				var1:UpdateSpWeapon(var0)
				getProxy(BayProxy):updateShip(var1)
			else
				getProxy(EquipmentProxy):AddSpWeapon(var0)
			end

			arg0:sendNotification(GAME.CONFIRM_REFORGE_SPWEAPON_DONE, var0)
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("common", arg0.result))
		end
	end)
end

return var0
