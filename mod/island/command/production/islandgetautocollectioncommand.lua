local var0_0 = class("IslandGetAutoCollectionCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().type

	pg.ConnectionMgr.GetInstance():Send(21541, {
		type = var0_1
	}, 21542, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.ISLAND_GET_AUTO_COLLECTION_DATA_DONE, {
				data = arg0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
