local var0_0 = class("ChargeConfirmCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.payId
	local var2_1 = var0_1.bsId or ""
	local var3_1 = getProxy(ShopsProxy)

	pg.ConnectionMgr.GetInstance():Send(11504, {
		pay_id = var1_1,
		pay_id_bili = var2_1
	}, 11505, function(arg0_2)
		if arg0_2.result == 0 then
			var3_1:removeChargeTimer(var1_1)
			arg0_1:sendNotification(GAME.CHARGE_SUCCESS, {
				shopId = arg0_2.shop_id,
				payId = var1_1,
				gem = arg0_2.gem,
				gem_free = arg0_2.gem_free
			})
		elseif arg0_2.result == 4 then
			arg0_1:sendNotification(GAME.CHARGE_CONFIRM_FAILED, {
				payId = var1_1,
				bsId = var2_1
			})
		else
			var3_1:removeChargeTimer(var1_1)

			if arg0_2.result ~= 1 then
				pg.TipsMgr.GetInstance():ShowTips(errorTip("charge", arg0_2.result))
			end
		end
	end)
end

return var0_0
