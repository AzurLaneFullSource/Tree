local var0_0 = class("IslandShipAttrUpgradeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var1_1)

	if not var2_1 then
		return
	end

	local var3_1 = var0_1.attrKy
	local var4_1 = {}

	for iter0_1, iter1_1 in pairs(var0_1.list or {}) do
		table.insert(var4_1, {
			id = iter0_1,
			num = iter1_1
		})
	end

	pg.ConnectionMgr.GetInstance():Send(21605, {
		ship_id = var1_1,
		type = var3_1,
		item_list = var4_1
	}, 21606, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = Clone(var2_1)
			local var1_2 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
			local var2_2 = 0

			for iter0_2, iter1_2 in pairs(var0_1.list or {}) do
				local var3_2 = IslandItem.New({
					id = iter0_2
				})

				var2_2 = var2_2 + tonumber(var3_2:GetUseArg()) * iter1_2

				var1_2:RemoveItem(iter0_2, iter1_2)
			end

			local var4_2 = IslandShipAttr.GetAtrrName(var3_1)

			var2_1:AddExtraAttr(var4_2, var2_2)
			arg0_1:sendNotification(GAME.ISLNAD_SHIP_ATTR_UPGRADE_DONE)
			IslandAchievementHelper.OnShipAttrUpgrade(var0_2, var2_1)
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShipAttrUpgrade(var0_2, var2_1))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
