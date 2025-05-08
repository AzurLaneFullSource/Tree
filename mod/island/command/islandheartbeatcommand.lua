local var0_0 = class("IslandHeartBeatCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(21215, {
		island_id = var0_1
	})
end

return var0_0
