local var0_0 = class("IslandSendRoleSkinColorCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.ship_id
	local var2_1 = var0_1.skin_id
	local var3_1 = var0_1.color_id
	local var4_1 = getProxy(IslandProxy):GetIsland()

	pg.ConnectionMgr.GetInstance():Send(21619, {
		ship_id = var1_1,
		skin_id = var2_1,
		color_id = var3_1
	}, 21620, function(arg0_2)
		if arg0_2.result == 0 then
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandUnlockColor(var1_1, var3_1))

			local var0_2 = getProxy(IslandProxy):GetIsland()

			var0_2:GetCharacterAgency():AddSkinColor(var1_1, var2_1, var3_1)
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.SKIN_ALL_COLOR)
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.SKIN_COLOR)

			local var1_2 = var0_2:GetInventoryAgency()
			local var2_2 = pg.island_skin_colordiff_template[var3_1].cost

			for iter0_2, iter1_2 in ipairs(var2_2) do
				var1_2:RemoveItem(iter1_2[1], iter1_2[2])
			end

			pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
			arg0_1:sendNotification(GAME.ISLAND_BUY_ROLE_SKIN_COLOR_DONE)
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
