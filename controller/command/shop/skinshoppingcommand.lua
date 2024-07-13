local var0_0 = class("ShoppingCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = var0_1.id
	local var2_1 = var0_1.count
	local var3_1 = pg.shop_template[var1_1]

	if not var1_1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_shopId_noFound"))

		return
	end

	if var2_1 == 0 then
		return
	end

	local var4_1 = getProxy(ShopsProxy)
	local var5_1 = var4_1:getShopStreet()
	local var6_1 = false
	local var7_1 = var3_1.resource_num * var2_1
	local var8_1 = getProxy(PlayerProxy)
	local var9_1 = var8_1:getData()

	if var3_1.limit_args then
		for iter0_1, iter1_1 in ipairs(var3_1.limit_args) do
			if type(iter1_1) == "table" and iter1_1[1] == "level" and iter1_1[2] > var9_1.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_limit_level", iter1_1[2]))

				return
			end
		end
	end

	if var3_1.discount ~= 0 and CommonCommodity.InCommodityDiscountTime(var3_1.id) then
		var7_1 = var7_1 * ((100 - var3_1.discount) / 100)
	end

	if var7_1 > var9_1[id2res(var3_1.resource_type)] then
		local var10_1 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var3_1.resource_type
		}):getName()

		if var3_1.resource_type == 1 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var7_1 - var9_1[id2res(var3_1.resource_type)],
					var7_1
				}
			})
		elseif var3_1.resource_type == 4 or var3_1.resource_type == 14 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
		elseif not ItemTipPanel.ShowItemTip(DROP_TYPE_RESOURCE, var3_1.resource_type) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var10_1))
		end

		return
	end

	local var11_1 = {}

	seriesAsync(var11_1, function()
		pg.ConnectionMgr.GetInstance():Send(16001, {
			id = var1_1,
			number = var2_1
		}, 16002, function(arg0_3)
			if arg0_3.result == 0 then
				local var0_3 = {}
				local var1_3 = var8_1:getData()

				var1_3:consume({
					[id2res(var3_1.resource_type)] = var7_1
				})

				local var2_3

				switch(var3_1.genre, {
					[ShopArgs.SkinShop] = function()
						var0_3 = PlayerConst.addTranDrop(arg0_3.drop_list)

						local var0_4 = var3_1.effect_args[1]
						local var1_4 = getProxy(ShipSkinProxy)
						local var2_4 = ShipSkin.New({
							id = var0_4
						})

						var1_4:addSkin(var2_4)
					end,
					[ShopArgs.SkinShopTimeLimit] = function()
						local var0_5 = var3_1.effect_args[1]
						local var1_5 = getProxy(ShipSkinProxy)
						local var2_5 = var1_5:getSkinById(var0_5)

						if var2_5 and var2_5:isExpireType() then
							local var3_5 = var3_1.time_second * var2_1 + var2_5.endTime
							local var4_5 = ShipSkin.New({
								id = var0_5,
								end_time = var3_5
							})

							var1_5:addSkin(var4_5)
						elseif not var2_5 then
							local var5_5 = var3_1.time_second * var2_1 + pg.TimeMgr.GetInstance():GetServerTime()
							local var6_5 = ShipSkin.New({
								id = var0_5,
								end_time = var5_5
							})

							var1_5:addSkin(var6_5)
						end
					end
				})
				var8_1:updatePlayer(var1_3)

				if var3_1.group > 0 then
					var4_1:updateNormalGroupList(var3_1.group, var3_1.group_buy_count)
				end

				arg0_1:sendNotification(GAME.SKIN_SHOPPIGN_DONE, {
					id = var1_1,
					shopType = var2_3,
					normalList = var4_1:GetNormalList(),
					normalGroupList = var4_1:GetNormalGroupList(),
					awards = var0_3
				})
			else
				originalPrint(arg0_3.result)

				if arg0_3.result == 4400 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("shopping_error_time_limit"))
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_3.result))
				end
			end
		end)
	end)
end

return var0_0
