local var0_0 = class("EducateShoppingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1

	var1_1 = var0_1 and var0_1.callback

	local var2_1 = getProxy(EducateProxy)
	local var3_1 = var2_1:GetShopProxy()
	local var4_1 = var3_1:GetShopWithId(var0_1.shopId)
	local var5_1 = var3_1:GetDiscountById(var0_1.shopId)
	local var6_1 = {}

	for iter0_1, iter1_1 in ipairs(var0_1.goods) do
		table.insert(var6_1, var4_1:GetGoodById(iter1_1.id):GetCost(var5_1))
	end

	pg.ConnectionMgr.GetInstance():Send(27033, {
		shop_id = var0_1.shopId,
		goods = var0_1.goods
	}, 27034, function(arg0_2)
		if arg0_2.result == 0 then
			var2_1:ReduceResForCosts(var6_1)
			EducateHelper.UpdateDropsData(arg0_2.drops)

			for iter0_2, iter1_2 in ipairs(var0_1.goods) do
				local var0_2 = var4_1:GetGoodById(iter1_2.id)

				var0_2:ReduceRemainCnt(iter1_2.num)
				var4_1:UpdateGood(var0_2)
			end

			var3_1:UpdateShop(var4_1)
			arg0_1:sendNotification(GAME.EDUCATE_SHOPPING_DONE, {
				id = var0_1.shopId,
				drops = arg0_2.drops
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate shop buy error: ", arg0_2.result))
		end
	end)
end

return var0_0
