local var0 = class("IslandRequestCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = pg.TimeMgr.GetInstance():GetServerTime()

	pg.ConnectionMgr.GetInstance():Send(26108, {
		act_id = var0.act_id
	}, 26109, function(arg0)
		if arg0.ret == 0 then
			local var0 = getProxy(IslandProxy)

			var0.timeStamp = var1
			var0.nodeDic = {}

			for iter0, iter1 in ipairs(arg0.node_list) do
				var0.nodeDic[iter1.id] = IslandNode.New(iter1)
			end

			existCall(var0.callback)
			pg.m02:sendNotification(GAME.REQUEST_NODE_LIST_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("Request island data failed:" .. arg0.result)
		end
	end)
end

return var0
