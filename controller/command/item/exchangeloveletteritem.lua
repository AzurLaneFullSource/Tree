local var0_0 = class("ExchangeLoveLetterItem", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ActivityProxy)
	local var2_1 = var1_1:getActivityById(var0_1.activity_id)

	if not var2_1 or var2_1:isEnd() or var2_1.data1 <= 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var0_1.activity_id
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			var2_1 = var1_1:getActivityById(var0_1.activity_id)
			var2_1.data1 = var2_1.data1 - 1

			var1_1:updateActivity(var2_1)

			for iter0_2, iter1_2 in ipairs(arg0_2.award_list) do
				local var0_2 = Drop.New({
					type = iter1_2.type,
					id = iter1_2.id,
					count = iter1_2.number
				}):getSubClass()
				local var1_2 = getProxy(BagProxy)

				var1_2:removeExtraData(var0_2.id, var0_2.extra)
				var1_2:removeItemById(var0_2.id, var0_2.count)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_exchange_tip3"))
		elseif arg0_2.result == 20 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_exchange_tip1"))
		elseif arg0_2.result == 21 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_exchange_tip2"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
