local var0_0 = class("IslandShoppingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.shop
	local var2_1 = getProxy(ActivityProxy):getActivityById(var1_1.activityId)
	local var3_1 = var1_1:bindConfigTable()[var0_1.arg1]
	local var4_1 = var0_1.arg2 or 1
	local var5_1 = getProxy(PlayerProxy)
	local var6_1 = var5_1:getData()

	if var6_1[id2res(var3_1.resource_type)] < var3_1.resource_num * var4_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if var3_1.commodity_type == DROP_TYPE_RESOURCE then
		if var3_1.commodity_id == 1 and var6_1:GoldMax(var3_1.num * var4_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var3_1.commodity_id == 2 and var6_1:OilMax(var3_1.num * var4_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end
	elseif var3_1.commodity_type == DROP_TYPE_ITEM then
		local var7_1 = Item.getConfigData(var3_1.commodity_id).max_num

		if var7_1 > 0 and var7_1 < getProxy(BagProxy):getItemCountById(var3_1.commodity_id) + var3_1.num * var4_1 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_shop_limit_error"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var2_1.id,
		arg1 = var0_1.arg1,
		arg2 = var0_1.arg2
	}, 11203, function(arg0_2)
		if arg0_2.result == 0 then
			if table.contains(var2_1.data1_list, var0_1.arg1) then
				for iter0_2, iter1_2 in ipairs(var2_1.data1_list) do
					if iter1_2 == var0_1.arg1 then
						var2_1.data2_list[iter0_2] = var2_1.data2_list[iter0_2] + var0_1.arg2

						break
					end
				end
			else
				table.insert(var2_1.data1_list, var0_1.arg1)
				table.insert(var2_1.data2_list, var0_1.arg2)
			end

			local var0_2 = var1_1:bindConfigTable()[var0_1.arg1]
			local var1_2 = var0_2.resource_num * var0_1.arg2
			local var2_2 = var5_1:getData()

			var2_2:consume({
				[id2res(var0_2.resource_type)] = var1_2
			})
			var5_1:updatePlayer(var2_2)
			var1_1:getGoodsById(var0_1.arg1):addBuyCount(var0_1.arg2)
			getProxy(ActivityProxy):updateActivity(var2_1)

			local var3_2 = PlayerConst.GetTranAwards(var0_1, arg0_2)

			arg0_1:sendNotification(GAME.ISLAND_SHOPPING_DONE, {
				awards = var3_2,
				goodsId = var0_1.arg1
			})
		else
			arg0_1:sendNotification(ActivityProxy.ACTIVITY_OPERATION_ERRO, {
				actId = var2_1.id,
				code = arg0_2.result
			})
		end
	end)
end

return var0_0
