local var0_0 = class("UpgradeIslandInventoryCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	if not var1_1:CanUpgrade() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_bag_max_level"))

		return
	end

	local var2_1 = var1_1:GetUpgradeConsume()

	if _.any(var2_1, function(arg0_2)
		return Drop.New({
			type = arg0_2[1],
			id = arg0_2[2],
			count = arg0_2[3]
		}):getOwnedCount() < arg0_2[3]
	end) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21012, {
		type = 0
	}, 21013, function(arg0_3)
		if arg0_3.ret == 0 then
			for iter0_3, iter1_3 in ipairs(var2_1) do
				local var0_3 = Drop.New({
					type = iter1_3[1],
					id = iter1_3[2],
					count = iter1_3[3]
				})

				arg0_1:sendNotification(GAME.CONSUME_ITEM, var0_3)
			end

			var1_1:Upgrade()
			arg0_1:sendNotification(GAME.ISLAND_UPGRADE_INVENTORY_DONE)
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_bag_uprade_success"))
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandInventoryUpgrade(var1_1:GetLevel()))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.ret] .. arg0_3.ret)
		end
	end)
end

return var0_0
