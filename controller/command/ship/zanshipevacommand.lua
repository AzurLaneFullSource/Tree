local var0 = class("ZanShipEvaCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.evaId
	local var3 = var0.operation

	pg.ConnectionMgr.GetInstance():Send(17105, {
		ship_group_id = var1,
		discuss_id = var2,
		good_or_bad = var3
	}, 17106, function(arg0)
		local var0 = getProxy(CollectionProxy)
		local var1 = var0:getShipGroup(var1)
		local var2

		if var1 then
			local var3 = var1.evaluation

			if var3 then
				var2 = _.detect(var3.evas, function(arg0)
					return arg0.id == var2
				end)
			end
		end

		if arg0.result == 0 then
			if var2 then
				if var3 == 0 then
					var2.good_count = var2.good_count + 1
				elseif var3 == 1 then
					var2.bad_count = var2.bad_count + 1
				end

				var2.izan = true

				var1.evaluation:sortEvas()
				var0:updateShipGroup(var1)
				arg0:sendNotification(CollectionProxy.GROUP_EVALUATION_UPDATE, var1)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("zan_ship_eva_success"))
		elseif arg0.result == 7 then
			if var2 then
				var2.izan = true

				var0:updateShipGroup(var1)
				arg0:sendNotification(CollectionProxy.GROUP_EVALUATION_UPDATE, var1)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("zan_ship_eva_error_7"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("zan_ship_eva", arg0.result))
		end
	end)
end

return var0
