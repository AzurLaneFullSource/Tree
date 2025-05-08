local var0_0 = class("IslandSetAccessAuthorityCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().flag

	pg.ConnectionMgr.GetInstance():Send(21300, {
		open_flag = var0_1
	}, 21301, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetAccessAgency():SetAccessType(var0_1)
			arg0_1:sendNotification(GAME.ISLAND_SET_ACCESS_TYPE_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.ret)
		end
	end)
end

return var0_0
