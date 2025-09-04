local var0_0 = class("IslandUpgradeAgoraCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(IslandProxy):GetIsland()
	local var2_1 = var1_1:GetAgoraAgency()

	if not var2_1:CanUpgrade() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_agora_max_level"))

		return
	end

	local var3_1 = var2_1:GetUpgradeConsume()
	local var4_1 = var1_1:GetInventoryAgency():GetOwnCount(var3_1.id)

	if var3_1 and var4_1 < var3_1.count then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21305, {
		type = 0
	}, 21306, function(arg0_2)
		if arg0_2.result == 0 then
			var2_1:Upgrade()
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandAgoraUpgrade(var2_1:GetLevel()))

			if var3_1 then
				arg0_1:sendNotification(GAME.CONSUME_ITEM, var3_1)
			end
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
