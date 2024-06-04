local var0 = class("IslandShoppingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.shop
	local var2 = getProxy(ActivityProxy):getActivityById(var1.activityId)
	local var3 = var1:bindConfigTable()[var0.arg1]
	local var4 = var0.arg2 or 1
	local var5 = getProxy(PlayerProxy)
	local var6 = var5:getData()

	if var6[id2res(var3.resource_type)] < var3.resource_num * var4 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

		return
	end

	if var3.commodity_type == DROP_TYPE_RESOURCE then
		if var3.commodity_id == 1 and var6:GoldMax(var3.num * var4) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var3.commodity_id == 2 and var6:OilMax(var3.num * var4) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end
	elseif var3.commodity_type == DROP_TYPE_ITEM then
		local var7 = Item.getConfigData(var3.commodity_id).max_num

		if var7 > 0 and var7 < getProxy(BagProxy):getItemCountById(var3.commodity_id) + var3.num * var4 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("island_shop_limit_error"))

			return
		end
	end

	pg.ConnectionMgr.GetInstance():Send(11202, {
		cmd = 1,
		activity_id = var2.id,
		arg1 = var0.arg1,
		arg2 = var0.arg2
	}, 11203, function(arg0)
		if arg0.result == 0 then
			if table.contains(var2.data1_list, var0.arg1) then
				for iter0, iter1 in ipairs(var2.data1_list) do
					if iter1 == var0.arg1 then
						var2.data2_list[iter0] = var2.data2_list[iter0] + var0.arg2

						break
					end
				end
			else
				table.insert(var2.data1_list, var0.arg1)
				table.insert(var2.data2_list, var0.arg2)
			end

			local var0 = var1:bindConfigTable()[var0.arg1]
			local var1 = var0.resource_num * var0.arg2
			local var2 = var5:getData()

			var2:consume({
				[id2res(var0.resource_type)] = var1
			})
			var5:updatePlayer(var2)
			var1:getGoodsById(var0.arg1):addBuyCount(var0.arg2)
			getProxy(ActivityProxy):updateActivity(var2)

			local var3 = PlayerConst.GetTranAwards(var0, arg0)

			arg0:sendNotification(GAME.ISLAND_SHOPPING_DONE, {
				awards = var3,
				goodsId = var0.arg1
			})
		else
			arg0:sendNotification(ActivityProxy.ACTIVITY_OPERATION_ERRO, {
				actId = var2.id,
				code = arg0.result
			})
		end
	end)
end

return var0
