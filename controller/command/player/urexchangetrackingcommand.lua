local var0 = class("UrExchangeTrackingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.trackType
	local var2 = var0.arg1
	local var3 = var0.arg2

	pg.ConnectionMgr.GetInstance():Send(11212, {
		track_typ = var1,
		ship_tid = var2,
		from = var3
	})
end

return var0
