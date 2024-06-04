local var0 = class("MainSceneTrackingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.trackType
	local var2 = var0.arg1
	local var3 = var0.arg2
	local var4 = var0.arg3
	local var5 = var0.arg4

	pg.ConnectionMgr.GetInstance():Send(11029, {
		track_typ = var1,
		int_arg1 = var2,
		int_arg2 = var3,
		int_arg3 = var4,
		str_arg1 = var5
	})
end

return var0
