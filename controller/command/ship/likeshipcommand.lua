local var0 = class("LikeShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(17107, {
		ship_group_id = var0
	}, 17108, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(CollectionProxy)
			local var1 = var0:getShipGroup(var0)

			if var1 then
				var1.iheart = true
				var1.hearts = var1.hearts + 1
				var1.evaluation.hearts = var1.evaluation.hearts + 1

				var0:updateShipGroup(var1)
				arg0:sendNotification(CollectionProxy.GROUP_INFO_UPDATE, var0)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("like_ship_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("like_ship", arg0.result))
		end
	end)
end

return var0
