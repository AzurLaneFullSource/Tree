local var0 = class("MetaShoppingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = getProxy(ShopsProxy)
	local var2 = var1:GetMetaShop()

	assert(var2, "should exist shop")

	local var3 = var2:GetCommodityById(var0.arg1)

	assert(var3, "commodity cant not be nil")

	local var4 = getProxy(ActivityProxy):getActivityById(var0.activity_id)

	if not var4 or var4:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if not PlayerConst.CheckResForShopping(var3:GetConsume(), var0.arg2) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	local var5 = getProxy(PlayerProxy):getRawData()
	local var6 = var0.arg2
	local var7 = var3:getConfig("commodity_type")
	local var8 = var3:getConfig("commodity_id")
	local var9 = var3:getConfig("num")

	if var7 == 1 then
		if var8 == 1 and var5:GoldMax(var9 * var6) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var8 == 2 and var5:OilMax(var9 * var6) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0.activity_id,
		cmd = var0.cmd,
		arg1 = var0.arg1,
		arg2 = var0.arg2,
		arg_list = {}
	}, 11203, function(arg0)
		if arg0.result == 0 then
			local var0 = var1:GetMetaShop()

			if table.contains(var4.data1_list, var0.arg1) then
				for iter0, iter1 in ipairs(var4.data1_list) do
					if iter1 == var0.arg1 then
						var4.data2_list[iter0] = var4.data2_list[iter0] + var0.arg2

						break
					end
				end
			else
				table.insert(var4.data1_list, var0.arg1)
				table.insert(var4.data2_list, var0.arg2)
			end

			getProxy(ActivityProxy):updateActivity(var4)
			PlayerConst.ConsumeResForShopping(var3:GetConsume(), var0.arg2)

			local var1 = PlayerConst.GetTranAwards(var0, arg0)

			var1:UpdateMetaShopGoods(var0.arg1, var0.arg2)
			arg0:sendNotification(GAME.ON_META_SHOPPING_DONE, {
				awards = var1
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0.result] .. arg0.result)
		end
	end)
end

return var0
