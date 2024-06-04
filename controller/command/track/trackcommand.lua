local var0 = class("TrackCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.system
	local var2 = var0.id
	local var3 = var0.desc

	pg.ConnectionMgr.GetInstance():Send(10993, {
		action_arg = 0,
		action_system = var1,
		action_id = var2,
		action_des = var3
	})
end

return var0
