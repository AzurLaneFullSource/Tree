local var0_0 = class("IslandShipAttrLimitUnlockCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody().id
	local var1_1 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var0_1)

	if not var1_1 then
		return
	end

	pg.ConnectionMgr.GetInstance():Send(21603, {
		ship_id = var0_1
	}, 21604, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = Clone(var1_1)

			var1_1:SetUnlockExtraAttLimit()
			arg0_1:sendNotification(GAME.ISLNAD_SHIP_ATTR_LIMIT_UNLOCK_DONE)
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShipAttrLimit(var0_2, var1_1))
		end
	end)
end

return var0_0
