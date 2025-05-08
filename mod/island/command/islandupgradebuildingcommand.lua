local var0_0 = class("IslandUpgradeBuildingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(IslandProxy):GetIsland():GetBuildingAgency()
	local var2_1 = var1_1:GetBuilding(var0_1)

	if not var2_1 or not var2_1:CanUpgrade() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21051, {
		building_id = var0_1
	}, 21052, function(arg0_2)
		if arg0_2.ret == 0 then
			var2_1:Upgrade()
			var1_1:UpdateBuilding(var2_1)

			for iter0_2, iter1_2 in ipairs(var2_1:GetUpgradeCost()) do
				local var0_2 = Drop.New({
					type = iter1_2[1],
					id = iter1_2[2],
					count = iter1_2[3]
				})

				arg0_1:sendNotification(GAME.CONSUME_ITEM, var0_2)
			end

			arg0_1:sendNotification(GAME.ISLAND_UPGRADE_BUILDING_DONE, {
				id = var0_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
