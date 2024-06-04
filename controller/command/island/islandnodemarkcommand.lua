local var0 = class("IslandNodeMarkCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 2,
		activity_id = var0.act_id,
		arg1 = var0.node_id
	}, 11203, function(arg0)
		if arg0.result == 0 then
			getProxy(IslandProxy):GetNode(var0.node_id).isNew = false

			pg.m02:sendNotification(GAME.ISLAND_NODE_MARK_DONE, {
				node_id = var0.node_id
			})
		else
			pg.TipsMgr.GetInstance():ShowTips("Trigger island event failed:" .. arg0.result)
		end
	end)
end

return var0
