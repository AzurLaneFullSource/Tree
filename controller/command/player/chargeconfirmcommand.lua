local var0 = class("ChargeConfirmCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.payId
	local var2 = var0.bsId or ""
	local var3 = getProxy(ShopsProxy)

	pg.ConnectionMgr.GetInstance():Send(11504, {
		pay_id = var1,
		pay_id_bili = var2
	}, 11505, function(arg0)
		if arg0.result == 0 then
			var3:removeChargeTimer(var1)
			arg0:sendNotification(GAME.CHARGE_SUCCESS, {
				shopId = arg0.shop_id,
				payId = var1,
				gem = arg0.gem,
				gem_free = arg0.gem_free
			})
		elseif arg0.result == 4 then
			arg0:sendNotification(GAME.CHARGE_CONFIRM_FAILED, {
				payId = var1,
				bsId = var2
			})
		else
			var3:removeChargeTimer(var1)

			if arg0.result ~= 1 then
				pg.TipsMgr.GetInstance():ShowTips(errorTip("charge", arg0.result))
			end
		end
	end)
end

return var0
