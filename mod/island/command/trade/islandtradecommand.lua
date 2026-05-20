local var0_0 = class("IslandTradeCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.islandId
	local var2_1 = var0_1.op
	local var3_1 = var0_1.num
	local var4_1 = var0_1.price
	local var5_1 = getProxy(IslandProxy):GetIsland()
	local var6_1 = var5_1:GetInventoryAgency()
	local var7_1 = var5_1:GetTradeAgency()

	if var2_1 == IslandConst.TRADE_PURCHASE then
		if not var6_1:CanAddItem(IslandItem.PEARL_ID, var3_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_trade_bag_full_label"))

			return
		end
	elseif var2_1 == IslandConst.TRADE_SELL and var3_1 > var7_1:GetCanSellCnt(var1_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_trade_sell_failed_label2"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21240, {
		island_id = var1_1,
		type = var2_1,
		num = var3_1
	}, 21241, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = IslandDropHelper.AddItems(arg0_2)
			local var1_2 = {}

			if var2_1 == IslandConst.TRADE_PURCHASE then
				table.insert(var1_2, {
					id = IslandItem.GOLD_ID,
					count = var3_1 * var4_1
				})
				var7_1:UpdateWeekNum(var3_1)
			elseif var2_1 == IslandConst.TRADE_SELL then
				if var1_1 ~= var5_1.id then
					var7_1:UpdateSellLimit(var1_1, var3_1)
				end

				table.insert(var1_2, {
					id = IslandItem.PEARL_ID,
					count = var3_1
				})
			end

			for iter0_2, iter1_2 in ipairs(var1_2) do
				var6_1:RemoveItem(iter1_2.id, iter1_2.count)
			end

			arg0_1:sendNotification(GAME.ISLAND_TRADE_DONE, {
				dropData = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
