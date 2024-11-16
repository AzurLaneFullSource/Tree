local var0_0 = class("NewServerShopShoppingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.selectedList
	local var3_1 = var0_1.count or 1
	local var4_1 = var0_1.actType or ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP
	local var5_1 = getProxy(ActivityProxy):getActivityByType(var4_1)

	if not var5_1 or var5_1:isEnd() then
		return
	end

	local var6_1 = getProxy(ShopsProxy):GetNewServerShop(var4_1)

	if not var6_1 then
		return
	end

	local var7_1 = #var2_1 ~= 1 and #var2_1 or var3_1
	local var8_1 = getProxy(PlayerProxy)
	local var9_1 = var8_1:getData()
	local var10_1 = var6_1:GetCommodityById(var1_1)
	local var11_1 = var10_1:GetConsume()

	assert(var11_1.type == 1, "暂不支持资源以为的类型")

	local var12_1 = var9_1:getResource(var11_1.id)
	local var13_1 = var11_1.count

	if var12_1 < var13_1 * var7_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not var10_1:CanPurchaseMulTimes(var7_1) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_cnt_no_enough"))

		return
	end

	local var14_1 = {}

	for iter0_1, iter1_1 in ipairs(var2_1) do
		if not var14_1[iter1_1] then
			var14_1[iter1_1] = {
				itemid = iter1_1,
				count = var3_1
			}
		else
			var14_1[iter1_1].count = var14_1[iter1_1].count + 1
		end
	end

	local var15_1 = {}

	for iter2_1, iter3_1 in pairs(var14_1) do
		table.insert(var15_1, {
			itemid = iter3_1.itemid,
			count = iter3_1.count
		})
	end

	local var16_1 = var10_1:getConfig("type")
	local var17_1 = var10_1:getConfig("goods")[1]
	local var18_1 = var10_1:getConfig("num")

	if var16_1 == 1 then
		if var17_1 == 1 and var9_1:GoldMax(var18_1 * var7_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var17_1 == 2 and var9_1:OilMax(var18_1 * var7_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end
	end

	local var19_1 = Item.getConfigData(var17_1)

	if DROP_TYPE_ITEM == var16_1 and var19_1.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(var17_1) + var18_1 * var7_1 > var19_1.max_num then
		pg.TipsMgr.GetInstance():ShowTips(i18n("expbook_max_tip_title") .. i18n("resource_max_tip_shop"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(26043, {
		act_id = var5_1.id,
		goodsid = var1_1,
		selected = var15_1
	}, 26044, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = PlayerConst.addTranDrop(arg0_2.drop_list)

			var10_1:ReduceCnt(var7_1)

			if var10_1:LimitPurchaseSubGoods() then
				for iter0_2, iter1_2 in ipairs(var2_1) do
					var10_1:UpdateBoughtRecord(iter1_2)
				end
			end

			local var1_2 = getProxy(PlayerProxy):getData()
			local var2_2 = var10_1:getConfig("resource_type")

			var1_2:consume({
				[id2res(var2_2)] = var13_1 * var7_1
			})
			var8_1:updatePlayer(var1_2)
			arg0_1:sendNotification(GAME.NEW_SERVER_SHOP_SHOPPING_DONE, {
				awards = var0_2
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
