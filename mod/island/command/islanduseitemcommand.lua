local var0_0 = class("IslandUseItemCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.count or 1
	local var3_1 = var0_1.arg or {}
	local var4_1 = getProxy(IslandProxy):GetIsland()
	local var5_1 = var4_1:GetInventoryAgency()

	if var2_1 > var5_1:GetOwnCount(var1_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(21026, {
		id = var1_1,
		count = var2_1,
		arg = var3_1
	}, 21027, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = IslandDropHelper.AddItems(arg0_2)

			for iter0_2, iter1_2 in ipairs(arg0_2.ship_list) do
				var4_1:GetCharacterAgency():AddShip(IslandShip.New(iter1_2))
			end

			var5_1:RemoveItem(var1_1, var2_1)
			arg0_1:HandleUsageEffect(var1_1, var3_1)
			arg0_1:sendNotification(GAME.ISLAND_USE_ITEM_DONE, {
				dropData = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

function var0_0.HandleUsageEffect(arg0_3, arg1_3, arg2_3)
	local var0_3 = IslandItem.StaticGetUsageType(arg1_3)
end

return var0_0
