local var0_0 = class("IslandShipSkillUpgradeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(IslandProxy):GetIsland()
	local var2_1 = var1_1:GetCharacterAgency():GetShipById(var0_1)

	if not var2_1 then
		return
	end

	if not var2_1:CanUpgradeSkill() then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21611, {
		ship_id = var0_1
	}, 21612, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var2_1:GetSkill()
			local var1_2 = var0_2:GetUpgradeMaterial()

			var0_2:Upgrade()

			local var2_2 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

			for iter0_2, iter1_2 in ipairs(var1_2) do
				var2_2:RemoveItem(iter1_2.id, iter1_2.count)
			end

			IslandAchievementHelper.OnShipSkillUpgrade(var0_2:GetLevel())
			var1_1:GetGlobalBuffAgency():OnShipSkillUpgrade(var0_1)
			arg0_1:sendNotification(GAME.ISLAND_SHIP_SKILL_UPGRADE_DONE)
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShipSkillUpgrade(var2_1.id, var0_2.id, var0_2:GetLevel()))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
