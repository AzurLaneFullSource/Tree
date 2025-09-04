local var0_0 = class("IslandShipBreakOutCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(IslandProxy):GetIsland()
	local var2_1 = var1_1:GetCharacterAgency():GetShipById(var0_1)

	if not var2_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21601, {
		ship_id = var0_1
	}, 21602, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
			local var1_2 = var2_1:GetBreakoutMatrials()

			for iter0_2, iter1_2 in ipairs(var1_2) do
				var0_2:RemoveItem(iter1_2.id, iter1_2.count)
			end

			local var2_2 = Clone(var2_1)
			local var3_2 = var2_2:GetSkill():IsUnlock()

			var2_1:UpgradeBreakOut()

			local var4_2 = var2_1:GetSkill():IsUnlock()
			local var5_2 = not var3_2 and var4_2

			if var5_2 then
				var1_1:GetGlobalBuffAgency():OnShipSkillUnlock(var0_1)
			end

			arg0_1:sendNotification(GAME.ISLAND_SHIP_BREAKOUT_DONE, {
				newShip = var2_1,
				oldShip = var2_2,
				isUnlockSkill = var5_2
			})
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShipBreakout(var0_1))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
