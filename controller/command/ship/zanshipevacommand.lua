local var0_0 = class("ZanShipEvaCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.evaId
	local var3_1 = var0_1.operation

	pg.ConnectionMgr.GetInstance():Send(17105, {
		ship_group_id = var1_1,
		discuss_id = var2_1,
		good_or_bad = var3_1
	}, 17106, function(arg0_2)
		local var0_2 = getProxy(CollectionProxy)
		local var1_2 = var0_2:getShipGroup(var1_1)
		local var2_2

		if var1_2 then
			local var3_2 = var1_2.evaluation

			if var3_2 then
				var2_2 = _.detect(var3_2.evas, function(arg0_3)
					return arg0_3.id == var2_1
				end)
			end
		end

		if arg0_2.result == 0 then
			if var2_2 then
				if var3_1 == 0 then
					var2_2.good_count = var2_2.good_count + 1
				elseif var3_1 == 1 then
					var2_2.bad_count = var2_2.bad_count + 1
				end

				var2_2.izan = true

				var1_2.evaluation:sortEvas()
				var0_2:updateShipGroup(var1_2)
				arg0_1:sendNotification(CollectionProxy.GROUP_EVALUATION_UPDATE, var1_1)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("zan_ship_eva_success"))
		elseif arg0_2.result == 7 then
			if var2_2 then
				var2_2.izan = true

				var0_2:updateShipGroup(var1_2)
				arg0_1:sendNotification(CollectionProxy.GROUP_EVALUATION_UPDATE, var1_1)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("zan_ship_eva_error_7"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("zan_ship_eva", arg0_2.result))
		end
	end)
end

return var0_0
