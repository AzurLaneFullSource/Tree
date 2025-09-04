local var0_0 = class("IslandSetAccessAuthorityCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.openList
	local var2_1 = var0_1.closeList

	pg.ConnectionMgr.GetInstance():Send(21002, {
		open_flag = var1_1,
		close_flag = var2_1
	}, 21003, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetAccessAgency()

			for iter0_2, iter1_2 in ipairs(var2_1) do
				var0_2:RemoveOpenFlag(iter1_2)
			end

			for iter2_2, iter3_2 in ipairs(var1_1) do
				var0_2:AddOpenFlag(iter3_2)
			end

			arg0_1:sendNotification(GAME.ISLAND_SET_ACCESS_TYPE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.ret)
		end
	end)
end

return var0_0
