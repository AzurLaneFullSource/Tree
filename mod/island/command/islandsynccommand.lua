local var0_0 = class("IslandSyncCommand", pm.SimpleCommand)

local function var1_0(...)
	if false then
		warning(...)
	end
end

function var0_0.execute(arg0_2, arg1_2)
	local var0_2 = arg1_2:getBody()
	local var1_2 = _.map(var0_2.data, function(arg0_3)
		return arg0_3:Pack()
	end)

	var1_0("send")
	_.each(var0_2.data, function(arg0_4)
		var1_0(arg0_4:toString())
	end)
	pg.ConnectionMgr.GetInstance():Send(21211, {
		island_id = var0_2.islandId,
		sync_ob_list = var1_2
	})
end

return var0_0
