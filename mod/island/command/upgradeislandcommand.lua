local var0_0 = class("UpgradeIslandCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().callback

	arg0_1:DoUpgrade(var0_1)
end

function var0_0.DoUpgrade(arg0_2, arg1_2)
	if not getProxy(IslandProxy):GetIsland():CanLevelUp() then
		arg1_2()

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21000, {
		type = 0
	}, 21001, function(arg0_3)
		if arg0_3.ret == 0 then
			local var0_3 = getProxy(IslandProxy):GetIsland()

			var0_3:Upgrade()

			local var1_3 = IslandDropHelper.AddItems(arg0_3)

			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.ISLAND_LV)
			IslandAchievementHelper.UpdateRecord(IslandAchievementType.ISLAND_LV, 0, var0_3:GetLevel())
			arg0_2:sendNotification(GAME.ISLAND_UPGRADE_DONE, {
				dropData = var1_3,
				callback = function()
					arg0_2:DoUpgrade(arg1_2)
				end
			})
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandUpgrade(var0_3:GetLevel()))
			var0_3:GetTechnologyAgency():TryAutoUnlock()
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_3.ret] .. arg0_3.ret)
		end
	end)
end

return var0_0
