local var0_0 = class("ImpeachShipEvaCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.groupId
	local var2_1 = var0_1.evaId
	local var3_1 = var0_1.reason

	pg.ConnectionMgr.GetInstance():Send(17109, {
		ship_group_id = var1_1,
		discuss_id = var2_1,
		reason = var3_1
	}, 17110, function(arg0_2)
		if arg0_2.result == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("report_sent_thank"))
		end
	end)
end

return var0_0
