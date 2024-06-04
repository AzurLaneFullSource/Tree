local var0 = class("ImpeachShipEvaCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.groupId
	local var2 = var0.evaId
	local var3 = var0.reason

	pg.ConnectionMgr.GetInstance():Send(17109, {
		ship_group_id = var1,
		discuss_id = var2,
		reason = var3
	}, 17110, function(arg0)
		if arg0.result == 0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("report_sent_thank"))
		end
	end)
end

return var0
