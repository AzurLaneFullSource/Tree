local var0_0 = class("IslandSendRoleDressCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.ship_id
	local var2_1 = var0_1.dress_id
	local var3_1 = getProxy(IslandProxy):GetIsland()

	pg.ConnectionMgr.GetInstance():Send(21615, {
		ship_id = var1_1,
		dress_id = var2_1
	}, 21616, function(arg0_2)
		if arg0_2.result == 0 then
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandBindDress(var1_1, var2_1))

			local var0_2 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

			var0_2:ReduceDressItem(var2_1, 1)
			var0_2:GetShipById(var1_1):SetDressIdOwned(var2_1)
			arg0_1:sendNotification(GAME.ISLAND_SEND_ROLE_DRESS_DONE, {
				dress_id = var2_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
