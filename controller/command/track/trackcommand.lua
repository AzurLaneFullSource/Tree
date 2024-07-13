local var0_0 = class("TrackCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.system
	local var2_1 = var0_1.id
	local var3_1 = var0_1.desc

	pg.ConnectionMgr.GetInstance():Send(10993, {
		action_arg = 0,
		action_system = var1_1,
		action_id = var2_1,
		action_des = var3_1
	})
end

return var0_0
