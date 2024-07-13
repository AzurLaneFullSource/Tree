local var0_0 = class("UrExchangeTrackingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.trackType
	local var2_1 = var0_1.arg1
	local var3_1 = var0_1.arg2

	pg.ConnectionMgr.GetInstance():Send(11212, {
		track_typ = var1_1,
		ship_tid = var2_1,
		from = var3_1
	})
end

return var0_0
