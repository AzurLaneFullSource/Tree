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

	if var3.type == DROP_TYPE_WORLD_ITEM and not nowWorld():IsActivate() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_shop_bag_unactivated"))

		return
	end

	local var4 = getProxy(PlayerProxy)
	local var5 = var4:getData()

	if var3.type == DROP_TYPE_ITEM then
		local var6 = var3.effect_args
		local var7 = Item.getConfigData(var6[1]).display_icon

		for iter0, iter1 in pairs(var7) do
			if iter1[1] == 1 then
				if iter1[2] == 1 and var5:GoldMax(iter1[3]) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

					return
				end

				if iter1[2] == 2 and var5:OilMax(iter1[3]) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

					return
				end
			end
		end
	end

	if var3.type == DROP_TYPE_RESOURCE then
		if var3.effect_args[1] == 1 and var5:GoldMax(var3.num * var2) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var3.effect_args[1] == 2 then
			local var8 = var3.num

			if var8 == -1 and var3.genre == ShopArgs.BuyOil then
				var8 = ShopArgs.getOilByLevel(var5.level)
			end

			if var5:OilMax(var8 * var2) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

				return
			end
		end
	end

	if var2 == 0 then
		return
	end

	local var9 = getProxy(ShopsProxy)
	local var10 = var9:getShopStreet()
	local var11 = false
	local var12 = var3.resource_num
	local var13 = getProxy(NavalAcademyProxy)

	if var12 == -1 then
		if var3.effect_args == ShopArgs.EffectShopStreetLevel then
			var12 = pg.navalacademy_shoppingstreet_template[var10.level].lv_up_cost[2] * var2
		else
			local var14 = switch(var3.effect_args, {
				[ShopArgs.EffectTradingPortLevel] = function()
					return var13._goldVO
				end,
				[ShopArgs.EffectOilFieldLevel] = function()
					return var13._oilVO
				end,
				[ShopArgs.EffectClassLevel] = function()
					return var13._classVO
				end
			})

			if var14 then
				var12 = var14:bindConfigTable()[var14:GetLevel()].use[2] * var2
			end
		end
	else
		var12 = var3.resource_num * var2

		if var10 and var3.genre == ShopArgs.ShoppingStreetLimit then
			var11 = true

			local var15 = var10:getGoodsById(var1)

			var12 = math.ceil(var15.discount / 100 * var12)
		end
	end

	if var3.limit_args then
		for iter2, iter3 in ipairs(var3.limit_args) do
			if type(iter3) == "table" and iter3[1] == "level" and iter3[2] > var5.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_limit_level", iter3[2]))

				return
			end
		end
	end

	if var3.discount ~= 0 and CommonCommodity.InCommodityDiscountTime(var3.id) then
		var12 = var12 * ((100 - var3.discount) / 100)
	end

	if var12 > var5[id2res(var3.resource_type)] then
		local var16 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var3.resource_type
		}):getName()

		if var3.resource_type == 1 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var12 - var5[id2res(var3.resource_type)],
					var12
				}
			})
		elseif var3.resource_type == 4 or var3.resource_type == 14 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
		elseif not ItemTipPanel.ShowItemTip(DROP_TYPE_RESOURCE, var3.resource_type) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var16))
		end

		return
	end

	local var17 = {}

	table.insert(var17, function(arg0)
		if var3.genre == ShopArgs.GiftPackage or var3.genre == ShopArgs.NewServerShop then
			local var0 = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = var3.effect_args[1]
			})
			local var1 = GetItemsOverflowDic({
				var0
			})
			local var2, var3 = CheckOverflow(var1)

			if not var2 then
				switch(var3, {
					gold = function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))
					end,
					oil = function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))
					end,
					equip = function()
						NoPosMsgBox(i18n("switch_to_shop_tip_noPos"), openDestroyEquip, gotoChargeScene)
					end,
					ship = function()
						NoPosMsgBox(i18n("switch_to_shop_tip_noDockyard"), openDockyardClear, gotoChargeScene, openDockyardIntensify)
					end
				})

				return
			end

			if not CheckShipExpOverflow(var1) then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("player_expResource_mail_fullBag"),
					onYes = arg0
				})

				return
			end
		end

		arg0()
	end)
	seriesAsync(var17, function()
		pg.ConnectionMgr.GetInstance():Send(16001, {
			id = var1,
			number = var2
		}, 16002, function(arg0)
			if arg0.result == 0 then
				local var0 = {}

				if var3.type == 0 then
					arg0:sendNotification(GAME.EXTEND, {
						id = var1,
						count = var2
					})
				else
					var0 = PlayerConst.addTranDrop(arg0.drop_list)

					pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
				end

				local var1 = var4:getData()

				var1:consume({
					[id2res(var3.resource_type)] = var12
				})

				local var2

				if var11 then
					local var3 = var9:getShopStreet()
					local var4 = var3:getGoodsById(var1)

					var2 = var3.type

					var4:reduceBuyCount()
					var9:UpdateShopStreet(var3)
				else
					switch(var3.genre, {
						[ShopArgs.BuyOil] = function()
							var1:increaseBuyOilCount()
						end,
						[ShopArgs.ArenaShopLimit] = function()
							local var0 = getProxy(ShopsProxy)
							local var1 = var0:getMeritorousShop()
							local var2 = var1:getGoodsById(var1)

							var2:increaseBuyCount()
							var1:updateGoods(var2)

							var2 = var1.type

							var0:updateMeritorousShop(var1)
						end,
						[ShopArgs.GiftPackage] = function()
							var9:GetNormalByID(var1):increaseBuyCount()
						end,
						[ShopArgs.NewServerShop] = function()
							var9:GetNormalByID(var1):increaseBuyCount()
						end,
						[ShopArgs.SkinShop] = function()
							assert(false, "must be used ShoppingCommand")
						end,
						[ShopArgs.SkinShopTimeLimit] = function()
							assert(false, "must be used ShoppingCommand")
						end,
						[ShopArgs.guildShop] = function()
							local var0 = getProxy(ShopsProxy):getGuildShop()

							var0:getGoodsById(var1):reduceBuyCount()
							var9:updateGuildShop(var0)
						end,
						[ShopArgs.WorldShop] = function()
							nowWorld():UpdateWorldShopGoods({
								{
									goods_id = var1,
									count = var2
								}
							})
						end,
						[ShopArgs.WorldCollection] = function()
							nowWorld():UpdateWorldShopGoods({
								{
									goods_id = var1,
									count = var2
								}
							})
						end
					})
				end

				var4:updatePlayer(var1)

				if var3.group > 0 then
					var9:updateNormalGroupList(var3.group, var3.group_buy_count)
				end

				switch(var3.effect_args, {
					[ShopArgs.EffecetShipBagSize] = function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("shop_extendship_success"))
					end,
					[ShopArgs.EffecetEquipBagSize] = function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("shop_extendequip_success"))
					end,
					[ShopArgs.EffectCommanderBagSize] = function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("shop_extendcommander_success"))
					end,
					[ShopArgs.EffectSpWeaponBagSize] = function()
						pg.TipsMgr.GetInstance():ShowTips(i18n("shop_spweapon_success"))
					end
				})

				if not var0.isQuickShopping then
					arg0:sendNotification(GAME.SHOPPING_DONE, {
						id = var1,
						shopType = var2,
						normalList = var9:GetNormalList(),
						normalGroupList = var9:GetNormalGroupList(),
						awards = var0
					})
				end
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
