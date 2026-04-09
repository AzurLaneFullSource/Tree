local var0_0 = class("IslandCheaterOperateCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.type
	local var2_1 = var0_1.arg_list

	pg.ConnectionMgr.GetInstance():Send(23103, {
		type = var1_1,
		arg_list = var2_1
	}, 23104, function(arg0_2)
		if arg0_2.result == 0 then
			switch(var1_1, {
				[IslandCheaterTavernConst.PlayerOperateType.PutCard] = function()
					getProxy(IslandProxy):GetIsland():GetCheaterTavernAgency():MainPlayerPutCard(var2_1)
				end,
				[IslandCheaterTavernConst.PlayerOperateType.Query] = function()
					return
				end,
				[IslandCheaterTavernConst.PlayerOperateType.Shoot] = function()
					return
				end
			})
			arg0_1:sendNotification(GAME.ISLAND_PLAYER_CHEATER_OPERATE_DONE, {
				type = var1_1,
				arg_list = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end, false)
end

return var0_0
