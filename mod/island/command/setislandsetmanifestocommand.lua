local var0_0 = class("SetIslandSetManifestoCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().manifesto

	pg.ConnectionMgr.GetInstance():Send(21006, {
		signature = var0_1
	}, 21007, function(arg0_2)
		if arg0_2.ret == 0 then
			getProxy(IslandProxy):GetIsland():SetManifesto(var0_1)
			arg0_1:sendNotification(GAME.ISLAND_SET_MANIFESTO_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.ret] .. arg0_2.ret)
		end
	end)
end

return var0_0
