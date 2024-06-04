local var0 = class("EducateShoppingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1

	var1 = var0 and var0.callback

	local var2 = getProxy(EducateProxy)
	local var3 = var2:GetShopProxy()
	local var4 = var3:GetShopWithId(var0.shopId)
	local var5 = var3:GetDiscountById(var0.shopId)
	local var6 = {}

	for iter0, iter1 in ipairs(var0.goods) do
		table.insert(var6, var4:GetGoodById(iter1.id):GetCost(var5))
	end

	pg.ConnectionMgr.GetInstance():Send(27033, {
		shop_id = var0.shopId,
		goods = var0.goods
	}, 27034, function(arg0)
		if arg0.result == 0 then
			var2:ReduceResForCosts(var6)
			EducateHelper.UpdateDropsData(arg0.drops)

			for iter0, iter1 in ipairs(var0.goods) do
				local var0 = var4:GetGoodById(iter1.id)

				var0:ReduceRemainCnt(iter1.num)
				var4:UpdateGood(var0)
			end

			var3:UpdateShop(var4)
			arg0:sendNotification(GAME.EDUCATE_SHOPPING_DONE, {
				id = var0.shopId,
				drops = arg0.drops
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("educate shop buy error: ", arg0.result))
		end
	end)
end

return var0
