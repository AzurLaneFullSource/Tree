local var0_0 = class("MetaShoppingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(ShopsProxy)
	local var2_1 = var1_1:GetMetaShop()

	assert(var2_1, "should exist shop")

	local var3_1 = var2_1:GetCommodityById(var0_1.arg1)

	assert(var3_1, "commodity cant not be nil")

	local var4_1 = getProxy(ActivityProxy):getActivityById(var0_1.activity_id)

	if not var4_1 or var4_1:isEnd() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_activity_end"))

		return
	end

	if not PlayerConst.CheckResForShopping(var3_1:GetConsume(), var0_1.arg2) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	local var5_1 = getProxy(PlayerProxy):getRawData()
	local var6_1 = var0_1.arg2
	local var7_1 = var3_1:getConfig("commodity_type")
	local var8_1 = var3_1:getConfig("commodity_id")
	local var9_1 = var3_1:getConfig("num")

	if var7_1 == 1 then
		if var8_1 == 1 and var5_1:GoldMax(var9_1 * var6_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var8_1 == 2 and var5_1:OilMax(var9_1 * var6_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		activity_id = var0_1.activity_id,
		cmd = var0_1.cmd,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2,
		arg_list = {},
		kvargs1 = var0_1.kvargs1 or {}
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			local var0_2 = var1_1:GetMetaShop()

			if table.contains(var4_1.data1_list, var0_1.arg1) then
				for iter0_2, iter1_2 in ipairs(var4_1.data1_list) do
					if iter1_2 == var0_1.arg1 then
						var4_1.data2_list[iter0_2] = var4_1.data2_list[iter0_2] + var0_1.arg2

						break
					end
				end
			else
				table.insert(var4_1.data1_list, var0_1.arg1)
				table.insert(var4_1.data2_list, var0_1.arg2)
			end

			getProxy(ActivityProxy):updateActivity(var4_1)
			PlayerConst.ConsumeResForShopping(var3_1:GetConsume(), var0_1.arg2)

			local var1_2 = PlayerConst.GetTranAwards(var0_1, arg0_2)

			var1_1:UpdateMetaShopGoods(var0_1.arg1, var0_1.arg2)
			arg0_1:sendNotification(GAME.ON_META_SHOPPING_DONE, {
				awards = var1_2
			})
			pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
		else
			pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_2.result] .. arg0_2.result)
		end
	end)
end

return var0_0
