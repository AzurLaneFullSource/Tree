local var0_0 = class("SetMonthCardRatioCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11601, {
		ratio = var0_1
	}, 11602, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(PlayerProxy)
			local var1_2 = var0_2:getData()
			local var2_2 = var1_2:getCardById(VipCard.MONTH)

			if var2_2 and not var2_2:isExpire() then
				var2_2.data = var0_1

				var1_2:addVipCard(var2_2)
				var0_2:updatePlayer(var1_2)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("month_card_set_ratio_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("month_card_set_ratio_fail", arg0_2.result))
		end
	end)
end

return var0_0
