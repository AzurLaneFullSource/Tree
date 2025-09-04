local var0_0 = class("IslandGetFriendResumeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.callback

	if LOCK_ISLAND_DISPLAY then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21200, {
		island_id = var1_1
	}, 21201, function(arg0_2)
		local var0_2 = SharedIsland.New(arg0_2.island)

		var2_1(var0_2)
	end)
end

return var0_0
