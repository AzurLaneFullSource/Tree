local var0 = class("SetMonthCardRatioCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11601, {
		ratio = var0
	}, 11602, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(PlayerProxy)
			local var1 = var0:getData()
			local var2 = var1:getCardById(VipCard.MONTH)

			if var2 and not var2:isExpire() then
				var2.data = var0

				var1:addVipCard(var2)
				var0:updatePlayer(var1)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("month_card_set_ratio_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("month_card_set_ratio_fail", arg0.result))
		end
	end)
end

return var0
