local var0_0 = class("IslandUseShipExpBookCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var1_1)

	if not var2_1 then
		return
	end

	local var3_1 = {}

	for iter0_1, iter1_1 in pairs(var0_1.list or {}) do
		table.insert(var3_1, {
			id = iter0_1,
			num = iter1_1
		})
	end

	pg.ConnectionMgr.GetInstance():Send(21607, {
		ship_id = var1_1,
		item_list = var3_1
	}, 21608, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var2_1:GetLevel()

			var2_1:AddExp(arg0_2.add_exp)

			local var1_2 = var2_1:GetLevel()

			if var0_2 < var1_2 then
				IslandAchievementHelper.OnShipUpgrade(var0_2, var1_2)
				pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShipUpgrade(var2_1.id, var1_2))
			end

			local var2_2 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

			for iter0_2, iter1_2 in pairs(var0_1.list or {}) do
				var2_2:RemoveItem(iter0_2, iter1_2)
			end

			arg0_1:sendNotification(GAME.ISLAND_USE_SHIP_EXP_BOOK_DONE)
		end
	end)
end

return var0_0
