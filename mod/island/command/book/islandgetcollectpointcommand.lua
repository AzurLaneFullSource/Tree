local var0_0 = class("IslandGetCollectPointCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().ids

	pg.ConnectionMgr.GetInstance():Send(21345, {
		book_ids = var0_1
	}, 21346, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetBookAgency()
			local var1_2 = var0_2:GetAllPoints()

			var0_2:OnGetPointDone(arg0_2.collect_list)

			local var2_2 = var0_2:GetAllPoints()

			pg.TipsMgr.GetInstance():ShowTips(i18n("island_get_collect_point_success", var2_2 - var1_2))
			arg0_1:sendNotification(GAME.ISLAND_GET_COLLECT_POINT_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
