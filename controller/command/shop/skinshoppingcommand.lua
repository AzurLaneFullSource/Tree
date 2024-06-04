local var0 = class("ShoppingCommand", pm.SimpleCommand)

function var0.execute(arg0, arg1)
	local var0 = arg1:getBody()
	local var1 = var0.id
	local var2 = var0.count
	local var3 = pg.shop_template[var1]

	if not var1 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("common_shopId_noFound"))

		return
	end

	if var2 == 0 then
		return
	end

	local var4 = getProxy(ShopsProxy)
	local var5 = var4:getShopStreet()
	local var6 = false
	local var7 = var3.resource_num * var2
	local var8 = getProxy(PlayerProxy)
	local var9 = var8:getData()

	if var3.limit_args then
		for iter0, iter1 in ipairs(var3.limit_args) do
			if type(iter1) == "table" and iter1[1] == "level" and iter1[2] > var9.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_limit_level", iter1[2]))

				return
			end
		end
	end

	if var3.discount ~= 0 and CommonCommodity.InCommodityDiscountTime(var3.id) then
		var7 = var7 * ((100 - var3.discount) / 100)
	end

	if var7 > var9[id2res(var3.resource_type)] then
		local var10 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var3.resource_type
		}):getName()

		if var3.resource_type == 1 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var7 - var9[id2res(var3.resource_type)],
					var7
				}
			})
		elseif var3.resource_type == 4 or var3.resource_type == 14 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
		elseif not ItemTipPanel.ShowItemTip(DROP_TYPE_RESOURCE, var3.resource_type) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var10))
		end

		return
	end

	local var11 = {}

	seriesAsync(var11, function()
		pg.ConnectionMgr.GetInstance():Send(16001, {
			id = var1,
			number = var2
		}, 16002, function(arg0)
			if arg0.result == 0 then
				local var0 = {}
				local var1 = var8:getData()

				var1:consume({
					[id2res(var3.resource_type)] = var7
				})

				local var2

				switch(var3.genre, {
					[ShopArgs.SkinShop] = function()
						var0 = PlayerConst.addTranDrop(arg0.drop_list)

						local var0 = var3.effect_args[1]
						local var1 = getProxy(ShipSkinProxy)
						local var2 = ShipSkin.New({
							id = var0
						})

						var1:addSkin(var2)
					end,
					[ShopArgs.SkinShopTimeLimit] = function()
						local var0 = var3.effect_args[1]
						local var1 = getProxy(ShipSkinProxy)
						local var2 = var1:getSkinById(var0)

						if var2 and var2:isExpireType() then
							local var3 = var3.time_second * var2 + var2.endTime
							local var4 = ShipSkin.New({
								id = var0,
								end_time = var3
							})

							var1:addSkin(var4)
						elseif not var2 then
							local var5 = var3.time_second * var2 + pg.TimeMgr.GetInstance():GetServerTime()
							local var6 = ShipSkin.New({
								id = var0,
								end_time = var5
							})

							var1:addSkin(var6)
						end
					end
				})
				var8:updatePlayer(var1)

				if var3.group > 0 then
					var4:updateNormalGroupList(var3.group, var3.group_buy_count)
				end

				arg0:sendNotification(GAME.SKIN_SHOPPIGN_DONE, {
					id = var1,
					shopType = var2,
					normalList = var4:GetNormalList(),
					normalGroupList = var4:GetNormalGroupList(),
					awards = var0
				})
			else
				originalPrint(arg0.result)

				if arg0.result == 4400 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("shopping_error_time_limit"))
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0.result))
				end
			end
		end)
	end)
end

return var0
