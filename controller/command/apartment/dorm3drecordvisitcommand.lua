local var0_0 = class("Dorm3dRecordVisitCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(28036, {
		ship_id = var0_1
	}, 28037, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(ApartmentProxy):ModifyApartment(var0_1, {
				visitTime = pg.TimeMgr.GetInstance():GetServerTime()
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
