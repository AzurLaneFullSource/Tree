local var0_0 = class("IslandSetCardAchvsCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().achvIds
	local var1_1 = {}
	local var2_1 = pg.island_achievement

	for iter0_1, iter1_1 in ipairs(var0_1) do
		table.insert(var1_1, var2_1[iter1_1].group)
	end

	pg.ConnectionMgr.GetInstance():Send(21338, {
		group_list = var1_1
	}, 21339, function(arg0_2)
		if arg0_2.result == 0 then
			arg0_1:sendNotification(GAME.ISLAND_SET_CARD_ACHVS_DONE, {
				achvIds = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
