local var0 = class("ShamShoppingCommand", pm.SimpleCommand)

var0.SHAM_SHOP = 1

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.count
	local var3 = var0.type
	local var4 = getProxy(PlayerProxy):getRawData()
	local var5 = getProxy(ShopsProxy)
	local var6 = var5:getShamShop():getGoodsCfg(var1)
	local var7 = Drop.New({
		type = var6.resource_category,
		id = var6.resource_type
	})

	if var7:getOwnedCount() < var6.resource_num * var2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var7:getName()))

		return
	end

	if var6.commodity_type == 1 then
		if var6.commodity_id == 1 and var4:GoldMax(var6.num * var2) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var6.commodity_id == 2 and var4:OilMax(var6.num * var2) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(16201, {
		id = var1,
		type = var0.SHAM_SHOP,
		count = var2
	}, 16202, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drop_list)
			local var1 = var5:getShamShop()

			var1:getGoodsById(var1):addBuyCount(var2)
			var5:updateShamShop(var1)
			reducePlayerOwn({
				type = var6.resource_category,
				id = var6.resource_type,
				count = var6.resource_num * var2
			})
			arg0:sendNotification(GAME.SHAM_SHOPPING_DONE, {
				awards = var0,
				id = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
