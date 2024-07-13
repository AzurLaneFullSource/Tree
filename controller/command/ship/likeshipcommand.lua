local var0_0 = class("LikeShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(17107, {
		ship_group_id = var0_1
	}, 17108, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(CollectionProxy)
			local var1_2 = var0_2:getShipGroup(var0_1)

			if var1_2 then
				var1_2.iheart = true
				var1_2.hearts = var1_2.hearts + 1
				var1_2.evaluation.hearts = var1_2.evaluation.hearts + 1

				var0_2:updateShipGroup(var1_2)
				arg0_1:sendNotification(CollectionProxy.GROUP_INFO_UPDATE, var0_1)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("like_ship_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("like_ship", arg0_2.result))
		end
	end)
end

return var0_0
