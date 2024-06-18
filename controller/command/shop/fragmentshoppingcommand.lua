local var0_0 = class("FragmentShoppingCommand", pm.SimpleCommand)

var0_0.FRAG_SHOP = 2
var0_0.FRAG_NORMAL_SHOP = 3

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.count
	local var3_1 = var0_1.type
	local var4_1 = getProxy(PlayerProxy):getRawData()
	local var5_1 = getProxy(ShopsProxy)
	local var6_1 = var5_1:getFragmentShop()
	local var7_1 = var6_1:getGoodsCfg(var1_1)
	local var8_1 = Drop.New({
		type = var7_1.resource_category,
		id = var7_1.resource_type
	})

	if var8_1:getOwnedCount() < var7_1.resource_num * var2_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_x", var8_1:getName()))

		return
	end

	if var7_1.commodity_type == 1 then
		if var7_1.commodity_id == 1 and var4_1:GoldMax(var7_1.num * var2_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var7_1.commodity_id == 2 and var4_1:OilMax(var7_1.num * var2_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end
	end

	local var9_1 = var6_1:GetCommodityById(var1_1)
	local var10_1 = var0_0.FRAG_SHOP

	if var9_1.type == Goods.TYPE_FRAGMENT_NORMAL then
		var10_1 = var0_0.FRAG_NORMAL_SHOP
	end

	pg.ConnectionMgr.GetInstance():Send(16201, {
		id = var1_1,
		type = var10_1,
		count = var2_1
	}, 16202, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)
			local var1_2 = var5_1:getFragmentShop()

			var1_2:getGoodsById(var1_1):addBuyCount(var2_1)
			var5_1:updateFragmentShop(var1_2)
			reducePlayerOwn({
				type = var7_1.resource_category,
				id = var7_1.resource_type,
				count = var7_1.resource_num * var2_1
			})
			arg0_1:sendNotification(GAME.FRAG_SHOPPING_DONE, {
				awards = var0_2,
				id = var1_1
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_2.result))
		end
	end)
end

return var0_0
