local var0 = class("MedalShopCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.goodsId
	local var2 = var0.selectedId
	local var3 = #var2
	local var4 = getProxy(BagProxy)
	local var5 = var4:getItemCountById(ITEM_ID_SILVER_HOOK)
	local var6 = getProxy(ShopsProxy)
	local var7 = var6:GetMedalShop()
	local var8 = var7:getGoodsById(var1)
	local var9 = var8:GetPrice()

	if var5 < var9 * var3 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if not var8:CanPurchaseCnt(var3) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("guild_shop_cnt_no_enough"))

		return
	end

	local var10 = {}

	for iter0, iter1 in ipairs(var2) do
		if not var10[iter1] then
			var10[iter1] = {
				count = 1,
				id = iter1
			}
		else
			var10[iter1].count = var10[iter1].count + 1
		end
	end

	pg.ConnectionMgr.GetInstance():Send(16108, {
		flash_time = var7.nextTime,
		shopid = var8.configId,
		selected = _.values(var10)
	}, 16109, function(arg0)
		if arg0.result == 0 then
			local var0 = PlayerConst.addTranDrop(arg0.drop_list)
			local var1 = var6:GetMedalShop()

			var1:UpdateGoodsCnt(var1, var3)
			var6:UpdateMedalShop(var1)
			var4:removeItemById(ITEM_ID_SILVER_HOOK, var9 * var3)
			arg0:sendNotification(GAME.ON_MEDAL_SHOP_PURCHASE_DONE, {
				awards = var0
			})
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
