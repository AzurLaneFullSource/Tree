local var0 = class("QuotaShoppingCommand", pm.SimpleCommand)

var0.QUOTA_SHOP = 4

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.count
	local var3 = var0.type
	local var4 = getProxy(ShopsProxy)
	local var5 = var4:getQuotaShop():getGoodsCfg(var1)
	local var6 = Drop.New({
		type = var5.resource_category,
		id = var5.resource_type
	})

	if var6:getOwnedCount() < var5.resource_num * var2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var6:getName()))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(16201, {
		id = var1,
		type = var0.QUOTA_SHOP,
		count = var2
	}, 16202, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drop_list)
			local var1 = var4:getQuotaShop()

			var1:getGoodsById(var1):addBuyCount(var2)
			var4:updateQuotaShop(var1)
			reducePlayerOwn({
				type = var5.resource_category,
				id = var5.resource_type,
				count = var5.resource_num * var2
			})
			arg0:sendNotification(GAME.QUOTA_SHOPPING_DONE, {
				awards = var0,
				id = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
