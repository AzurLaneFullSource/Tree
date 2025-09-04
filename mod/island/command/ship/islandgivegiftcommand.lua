local var0_0 = class("IslandGiveGiftCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.itemId

	pg.ConnectionMgr.GetInstance():Send(21613, {
		ship_id = var1_1,
		gift_id = var2_1
	}, 21614, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = IslandItem.StaticGetUsageArg(var2_1)
			local var1_2 = getProxy(IslandProxy):GetIsland():GetCharacterAgency():GetShipById(var1_1)
			local var2_2 = var1_2:IsFavoriteGift(var2_1) and IslandConst.GIFT_INDEX_FAVORITE or IslandConst.GIFT_INDEX_COMMON

			for iter0_2, iter1_2 in ipairs(var0_2) do
				if var2_2 == iter0_2 then
					local var3_2 = iter1_2[1]
					local var4_2 = iter1_2[2]

					for iter2_2, iter3_2 in ipairs(var4_2) do
						local var5_2 = IslandShipStatus.New({
							id = iter3_2,
							start_time = pg.TimeMgr.GetInstance():GetServerTime()
						})

						var1_2:AddStatus(var5_2)
					end

					var1_2:AddEnergy(var3_2)
				end
			end

			getProxy(IslandProxy):GetIsland():GetInventoryAgency():RemoveItem(var2_1, 1)
			arg0_1:sendNotification(GAME.ISLAND_GIVE_GIFT_DONE)
			pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShipGiveGift(var1_1, var2_1))
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_give_gift_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
