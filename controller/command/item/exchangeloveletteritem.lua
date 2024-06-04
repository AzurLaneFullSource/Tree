local var0 = class("ExchangeLoveLetterItem", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ActivityProxy)
	local var2 = var1:getActivityById(var0.activity_id)

	if not var2 or var2:isEnd() or var2.data1 <= 0 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var0.activity_id
	}, 11203, function(arg0)
		if arg0.result == 0 then
			var2 = var1:getActivityById(var0.activity_id)
			var2.data1 = var2.data1 - 1

			var1:updateActivity(var2)

			for iter0, iter1 in ipairs(arg0.award_list) do
				local var0 = Drop.New({
					type = iter1.type,
					id = iter1.id,
					count = iter1.number
				}):getSubClass()
				local var1 = getProxy(BagProxy)

				var1:removeExtraData(var0.id, var0.extra)
				var1:removeItemById(var0.id, var0.count)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_exchange_tip3"))
		elseif arg0.result == 20 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_exchange_tip1"))
		elseif arg0.result == 21 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("loveletter_exchange_tip2"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
