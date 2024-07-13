local var0_0 = class("MainSceneTrackingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.trackType
	local var2_1 = var0_1.arg1
	local var3_1 = var0_1.arg2
	local var4_1 = var0_1.arg3
	local var5_1 = var0_1.arg4

	pg.ConnectionMgr.GetInstance():Send(11029, {
		track_typ = var1_1,
		int_arg1 = var2_1,
		int_arg2 = var3_1,
		int_arg3 = var4_1,
		str_arg1 = var5_1
	})
end

return var0_0
