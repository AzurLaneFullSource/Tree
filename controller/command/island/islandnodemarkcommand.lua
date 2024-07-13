local var0_0 = class("IslandNodeMarkCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 2,
		activity_id = var0_1.act_id,
		arg1 = var0_1.node_id
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetNode(var0_1.node_id).isNew = false

			pg.m02:sendNotification(GAME.ISLAND_NODE_MARK_DONE, {
				node_id = var0_1.node_id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Trigger island event failed:" .. arg0_2.result)
		end
	end)
end

return var0_0
