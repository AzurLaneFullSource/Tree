local var0 = class("FragmentShoppingCommand", pm.SimpleCommand)

var0.FRAG_SHOP = 2
var0.FRAG_NORMAL_SHOP = 3

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.count
	local var3 = var0.type
	local var4 = getProxy(PlayerProxy):getRawData()
	local var5 = getProxy(ShopsProxy)
	local var6 = var5:getFragmentShop()
	local var7 = var6:getGoodsCfg(var1)
	local var8 = Drop.New({
		type = var7.resource_category,
		id = var7.resource_type
	})

	if var8:getOwnedCount() < var7.resource_num * var2 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var8:getName()))

		return
	end

	if var7.commodity_type == 1 then
		if var7.commodity_id == 1 and var4:GoldMax(var7.num * var2) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var7.commodity_id == 2 and var4:OilMax(var7.num * var2) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end
	end

	local var9 = var6:GetCommodityById(var1)
	local var10 = var0.FRAG_SHOP

	if var9.type == Goods.TYPE_FRAGMENT_NORMAL then
		var10 = var0.FRAG_NORMAL_SHOP
	end

	pg.ConnectionMgr.GetInstance():Send(16201, {
		id = var1,
		type = var10,
		count = var2
	}, 16202, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drop_list)
			local var1 = var5:getFragmentShop()

			var1:getGoodsById(var1):addBuyCount(var2)
			var5:updateFragmentShop(var1)
			reducePlayerOwn({
				type = var7.resource_category,
				id = var7.resource_type,
				count = var7.resource_num * var2
			})
			arg0:sendNotification(GAME.FRAG_SHOPPING_DONE, {
				awards = var0,
				id = var1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
		end
	end)
end

return var0
