local var0 = class("NewServerShopShoppingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.selectedList
	local var3 = var0.count or 1
	local var4 = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_NEWSERVER_SHOP)

	if not var4 or var4:isEnd() then
		return
	end

	local var5 = getProxy(ShopsProxy):GetNewServerShop()

	if not var5 then
		return
	end

	local var6 = #var2 ~= 1 and #var2 or var3
	local var7 = getProxy(PlayerProxy)
	local var8 = var7:getData()
	local var9 = var5:GetCommodityById(var1)
	local var10 = var9:GetConsume()

	assert(var10.type == 1, "暂不支持资源以为的类型")

	local var11 = var8:getResource(var10.id)
	local var12 = var10.count

	if var11 < var12 * var6 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not var9:CanPurchaseMulTimes(var6) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_cnt_no_enough"))

		return
	end

	local var13 = {}

	for iter0, iter1 in ipairs(var2) do
		if not var13[iter1] then
			var13[iter1] = {
				itemid = iter1,
				count = var3
			}
		else
			var13[iter1].count = var13[iter1].count + 1
		end
	end

	local var14 = {}

	for iter2, iter3 in pairs(var13) do
		table.insert(var14, {
			itemid = iter3.itemid,
			count = iter3.count
		})
	end

	local var15 = var9:getConfig("type")
	local var16 = var9:getConfig("goods")[1]
	local var17 = var9:getConfig("num")

	if var15 == 1 then
		if var16 == 1 and var8:GoldMax(var17 * var6) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var16 == 2 and var8:OilMax(var17 * var6) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end
	end

	local var18 = Item.getConfigData(var16)

	if DROP_TYPE_ITEM == var15 and var18.type == Item.EXP_BOOK_TYPE and getProxy(BagProxy):getItemCountById(var16) + var17 * var6 > var18.max_num then
		pg.TipsMgr.GetInstance():ShowTips(i18n("expbook_max_tip_title") .. i18n("resource_max_tip_shop"))

		return
	end

	pg.ConnectionMgr.GetInstance():Send(26043, {
		act_id = var4.id,
		goodsid = var1,
		selected = var14
	}, 26044, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drop_list)

			var9:ReduceCnt(var6)

			if var9:LimitPurchaseSubGoods() then
				for iter0, iter1 in ipairs(var2) do
					var9:UpdateBoughtRecord(iter1)
				end
			end

			local var1 = getProxy(PlayerProxy):getData()

			var1:consume({
				[id2res(var5:GetPtId())] = var12 * var6
			})
			var7:updatePlayer(var1)
			arg0:sendNotification(GAME.NEW_SERVER_SHOP_SHOPPING_DONE, {
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
