local var0_0 = class("IslandRequestCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = pg.TimeMgr.GetInstance():GetServerTime()

	pg.ConnectionMgr.GetInstance():Send(26108, {
		act_id = var0_1.act_id
	}, 26109, function(arg0_2)
		if arg0_2.ret == 0 then
			local var0_2 = getProxy(IslandProxy)

			var0_2.timeStamp = var1_1
			var0_2.nodeDic = {}

			for iter0_2, iter1_2 in ipairs(arg0_2.node_list) do
				var0_2.nodeDic[iter1_2.id] = IslandNode.New(iter1_2)
			end

			existCall(var0_1.callback)
			pg.m02:sendNotification(GAME.REQUEST_NODE_LIST_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips("Request island data failed:" .. arg0_2.result)
		end
	end)
end

return var0_0
