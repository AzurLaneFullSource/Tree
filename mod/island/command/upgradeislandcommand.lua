local var0_0 = class("UpgradeIslandCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()

	if not getProxy(IslandProxy):GetIsland():CanLevelUp() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21000, {
		type = 0
	}, 21001, function(arg0_2)
		if arg0_2.ret == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland()

			var0_2:Upgrade()

			local var1_2 = IslandDropHelper.AddItems(arg0_2)
			local var2_2 = var0_2:GetUpgradeConsume()

			for iter0_2, iter1_2 in pairs(var2_2) do
				local var3_2 = Drop.New({
					type = iter1_2[1],
					id = iter1_2[2],
					count = iter1_2[3]
				})

				arg0_1:sendNotification(GAME.CONSUME_ITEM, var3_2)
			end

			arg0_1:sendNotification(GAME.ISLAND_UPGRADE_DONE, {
				dropData = var1_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.ret] .. arg0_2.ret)
		end
	end)
end

return var0_0
