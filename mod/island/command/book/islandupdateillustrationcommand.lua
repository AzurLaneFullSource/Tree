local var0_0 = class("IslandUpdateIllustrationCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.linkId

	pg.ConnectionMgr.GetInstance():Send(21340, {
		type = var1_1,
		cond_id = var2_1
	}, 21341, function(arg0_2)
		if arg0_2.result == 0 then
			getProxy(IslandProxy):GetIsland():GetBookAgency():AddCanUnlock(var1_1, var2_1)
			arg0_1:sendNotification(GAME.ISLAND_UPDATE_ILLUSTRATION_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
