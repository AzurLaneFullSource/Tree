local var0 = class("NewTrackingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.type
	local var2 = var0.eventId
	local var3 = var0.para1 or ""
	local var4 = var0.para2 or ""
	local var5 = var0.para3 or ""

	print(var1, var2, var3)
	pg.ConnectionMgr.GetInstance():Send(10992, {
		track_type = var1,
		event_id = var2,
		para1 = var3,
		para2 = var4,
		para3 = var5
	})
end

return var0
