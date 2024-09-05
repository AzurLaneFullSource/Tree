local var0_0 = class("EvaluateShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.content

	pg.ConnectionMgr.GetInstance():Send(17103, {
		ship_group_id = var1_1,
		context = var2_1
	}, 17104, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(CollectionProxy)
			local var1_2 = var0_2:getShipGroup(var1_1)

			if var1_2 then
				var1_2.evaluation = ShipEvaluation.New(arg0_2.ship_discuss)

				var0_2:updateShipGroup(var1_2)
				arg0_1:sendNotification(CollectionProxy.GROUP_EVALUATION_UPDATE, var1_1)
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("eva_ship_success"))
		elseif arg0_2.result == 1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("report_ship_cannot_comment"))
		elseif arg0_2.result == 2011 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("evaluate_too_loog"))
		elseif arg0_2.result == 2013 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("evaluate_ban_word"))
		elseif arg0_2.result == 40 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("report_cannot_comment_level_2"))
		elseif arg0_2.result == 41 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("report_cannot_comment_level_1", arg0_2.need_level))
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("eva_ship", arg0_2.result))
		end
	end)
end

return var0_0
