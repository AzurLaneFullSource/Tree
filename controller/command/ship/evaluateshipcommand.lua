local var0 = class("EvaluateShipCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.content

	pg.ConnectionMgr.GetInstance():Send(17103, {
		ship_group_id = var1,
		context = var2
	}, 17104, function(arg0)
		if arg0.result == 0 then
			local var0 = getProxy(CollectionProxy)
			local var1 = var0:getShipGroup(var1)

			if var1 then
				var1.evaluation = ShipEvaluation.New(arg0.ship_discuss)

				var0:updateShipGroup(var1)
				arg0:sendNotification(CollectionProxy.GROUP_EVALUATION_UPDATE, var1)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("eva_ship_success"))
		elseif arg0.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("report_ship_cannot_comment"))
		elseif arg0.result == 2011 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("evaluate_too_loog"))
		elseif arg0.result == 2013 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("evaluate_ban_word"))
		elseif arg0.result == 40 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("report_cannot_comment"))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("eva_ship", arg0.result))
		end
	end)
end

return var0
