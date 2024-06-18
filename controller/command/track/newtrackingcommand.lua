local var0_0 = class("NewTrackingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.eventId
	local var3_1 = var0_1.para1 or ""
	local var4_1 = var0_1.para2 or ""
	local var5_1 = var0_1.para3 or ""

	print(var1_1, var2_1, var3_1)
	pg.ConnectionMgr.GetInstance():Send(10992, {
		track_type = var1_1,
		event_id = var2_1,
		para1 = var3_1,
		para2 = var4_1,
		para3 = var5_1
	})
end

return var0_0
