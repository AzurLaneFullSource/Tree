local var0_0 = class("IslandInviteShipCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(IslandProxy):GetIsland():GetCharacterAgency()

	pg.ConnectionMgr.GetInstance():Send(21609, {
		ship_id = var0_1
	}, 21610, function(arg0_2)
		if arg0_2.result == 0 then
			var1_1:RemoveInvite(var0_1)

			local var0_2 = IslandShip.New(arg0_2.ship)

			var1_1:AddShip(var0_2)
			arg0_1:sendNotification(GAME.ISLAND_INVITE_SHIP_DONE, {
				ship = var0_2
			})
			IslandBookHelper.OnAddNewShip(var0_2.id)
			IslandTaskHelper.UpdateRuntimeTaskByTargetType(IslandTaskTargetType.UNLOCK_SHIP)
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandUnlockShip(var0_1))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
