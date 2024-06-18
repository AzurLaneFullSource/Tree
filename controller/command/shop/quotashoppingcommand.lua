local var0_0 = class("QuotaShoppingCommand", pm.SimpleCommand)

var0_0.QUOTA_SHOP = 4

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.count
	local var3_1 = var0_1.type
	local var4_1 = getProxy(ShopsProxy)
	local var5_1 = var4_1:getQuotaShop():getGoodsCfg(var1_1)
	local var6_1 = Drop.New({
		type = var5_1.resource_category,
		id = var5_1.resource_type
	})

	if var6_1:getOwnedCount() < var5_1.resource_num * var2_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var6_1:getName()))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(16201, {
		id = var1_1,
		type = var0_0.QUOTA_SHOP,
		count = var2_1
	}, 16202, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)
			local var1_2 = var4_1:getQuotaShop()

			var1_2:getGoodsById(var1_1):addBuyCount(var2_1)
			var4_1:updateQuotaShop(var1_2)
			reducePlayerOwn({
				type = var5_1.resource_category,
				id = var5_1.resource_type,
				count = var5_1.resource_num * var2_1
			})
			arg0_1:sendNotification(GAME.QUOTA_SHOPPING_DONE, {
				awards = var0_2,
				id = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
