local var0_0 = class("Dorm3dRecordVisitCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(28036, {
		ship_id = var0_1
	}, 28037, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(ApartmentProxy):getApartment(var0_1)

			var0_2.visitTime = pg.TimeMgr.GetInstance():GetServerTime()

			getProxy(ApartmentProxy):updateApartment(var0_2)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
