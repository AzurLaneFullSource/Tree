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

	if var3_1.type == DROP_TYPE_WORLD_ITEM and not nowWorld():IsActivate() then
		pg.TipsMgr.GetInstance():ShowTips(i18n("world_shop_bag_unactivated"))

		return
	end

	local var4_1 = getProxy(PlayerProxy)
	local var5_1 = var4_1:getData()

	if var3_1.type == DROP_TYPE_ITEM then
		local var6_1 = var3_1.effect_args
		local var7_1 = Item.getConfigData(var6_1[1]).display_icon

		for iter0_1, iter1_1 in pairs(var7_1) do
			if iter1_1[1] == 1 then
				if iter1_1[2] == 1 and var5_1:GoldMax(iter1_1[3]) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

					return
				end

				if iter1_1[2] == 2 and var5_1:OilMax(iter1_1[3]) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

					return
				end
			end
		end
	end

	if var3_1.type == DROP_TYPE_RESOURCE then
		if var3_1.effect_args[1] == 1 and var5_1:GoldMax(var3_1.num * var2_1) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("gold_max_tip_title") .. i18n("resource_max_tip_shop"))

			return
		end

		if var3_1.effect_args[1] == 2 then
			local var8_1 = var3_1.num

			if var8_1 == -1 and var3_1.genre == ShopArgs.BuyOil then
				var8_1 = ShopArgs.getOilByLevel(var5_1.level)
			end

			if var5_1:OilMax(var8_1 * var2_1) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("oil_max_tip_title") .. i18n("resource_max_tip_shop"))

				return
			end
		end
	end

	if var2_1 == 0 then
		return
	end

	local var9_1 = getProxy(ShopsProxy)
	local var10_1 = var9_1:getShopStreet()
	local var11_1 = false
	local var12_1 = var3_1.resource_num
	local var13_1 = getProxy(NavalAcademyProxy)

	if var12_1 == -1 then
		if var3_1.effect_args == ShopArgs.EffectShopStreetLevel then
			var12_1 = pg.navalacademy_shoppingstreet_template[var10_1.level].lv_up_cost[2] * var2_1
		else
			local var14_1 = switch(var3_1.effect_args, {
				[ShopArgs.EffectTradingPortLevel] = function()
					return var13_1._goldVO
				end,
				[ShopArgs.EffectOilFieldLevel] = function()
					return var13_1._oilVO
				end,
				[ShopArgs.EffectClassLevel] = function()
					return var13_1._classVO
				end
			})

			if var14_1 then
				var12_1 = var14_1:bindConfigTable()[var14_1:GetLevel()].use[2] * var2_1
			end
		end
	else
		var12_1 = var3_1.resource_num * var2_1

		if var10_1 and var3_1.genre == ShopArgs.ShoppingStreetLimit then
			var11_1 = true

			local var15_1 = var10_1:getGoodsById(var1_1)

			var12_1 = math.ceil(var15_1.discount / 100 * var12_1)
		end
	end

	if var3_1.limit_args then
		for iter2_1, iter3_1 in ipairs(var3_1.limit_args) do
			if type(iter3_1) == "table" and iter3_1[1] == "level" and iter3_1[2] > var5_1.level then
				pg.TipsMgr.GetInstance():ShowTips(i18n("common_limit_level", iter3_1[2]))

				return
			end
		end
	end

	if var3_1.discount ~= 0 and CommonCommodity.InCommodityDiscountTime(var3_1.id) then
		var12_1 = var12_1 * ((100 - var3_1.discount) / 100)
	end

	if var12_1 > var5_1[id2res(var3_1.resource_type)] then
		local var16_1 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var3_1.resource_type
		}):getName()

		if var3_1.resource_type == 1 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
				{
					59001,
					var12_1 - var5_1[id2res(var3_1.resource_type)],
					var12_1
				}
			})
		elseif var3_1.resource_type == 4 or var3_1.resource_type == 14 then
			GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
		elseif not ItemTipPanel.ShowItemTip(DROP_TYPE_RESOURCE, var3_1.resource_type) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var16_1))
		end

		return
	end

	local var17_1 = {}

	table.insert(var17_1, function(arg0_5)
		if var3_1.genre == ShopArgs.GiftPackage or var3_1.genre == ShopArgs.NewServerShop then
			local var0_5 = Drop.New({
				count = 1,
				type = DROP_TYPE_ITEM,
				id = var3_1.effect_args[1]
			})
			local var1_5 = GetItemsOverflowDic({
				var0_5
			})
			local var2_5, var3_5 = CheckOverflow(var1_5)

			if not var2_5 then
				switch(var3_5, {
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

			if not CheckShipExpOverflow(var1_5) then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("player_expResource_mail_fullBag"),
					onYes = arg0_5
				})

				return
			end
		end

		arg0_5()
	end)
	seriesAsync(var17_1, function()
		pg.ConnectionMgr.GetInstance():Send(16001, {
			id = var1_1,
			number = var2_1
		}, 16002, function(arg0_11)
			if arg0_11.result == 0 then
				local var0_11 = {}

				if var3_1.type == 0 then
					arg0_1:sendNotification(GAME.EXTEND, {
						id = var1_1,
						count = var2_1
					})
				else
					var0_11 = PlayerConst.addTranDrop(arg0_11.drop_list)

					pg.TipsMgr.GetInstance():ShowTips(i18n("common_buy_success"))
				end

				local var1_11 = var4_1:getData()

				var1_11:consume({
					[id2res(var3_1.resource_type)] = var12_1
				})

				local var2_11

				if var11_1 then
					local var3_11 = var9_1:getShopStreet()
					local var4_11 = var3_11:getGoodsById(var1_1)

					var2_11 = var3_11.type

					var4_11:reduceBuyCount()
					var9_1:UpdateShopStreet(var3_11)
				else
					switch(var3_1.genre, {
						[ShopArgs.BuyOil] = function()
							var1_11:increaseBuyOilCount()
						end,
						[ShopArgs.ArenaShopLimit] = function()
							local var0_13 = getProxy(ShopsProxy)
							local var1_13 = var0_13:getMeritorousShop()
							local var2_13 = var1_13:getGoodsById(var1_1)

							var2_13:increaseBuyCount()
							var1_13:updateGoods(var2_13)

							var2_11 = var1_13.type

							var0_13:updateMeritorousShop(var1_13)
						end,
						[ShopArgs.GiftPackage] = function()
							var9_1:GetNormalByID(var1_1):increaseBuyCount()
						end,
						[ShopArgs.NewServerShop] = function()
							var9_1:GetNormalByID(var1_1):increaseBuyCount()
						end,
						[ShopArgs.SkinShop] = function()
							assert(false, "must be used ShoppingCommand")
						end,
						[ShopArgs.SkinShopTimeLimit] = function()
							assert(false, "must be used ShoppingCommand")
						end,
						[ShopArgs.guildShop] = function()
							local var0_18 = getProxy(ShopsProxy):getGuildShop()

							var0_18:getGoodsById(var1_1):reduceBuyCount()
							var9_1:updateGuildShop(var0_18)
						end,
						[ShopArgs.WorldShop] = function()
							nowWorld():UpdateWorldShopGoods({
								{
									goods_id = var1_1,
									count = var2_1
								}
							})
						end,
						[ShopArgs.WorldCollection] = function()
							nowWorld():UpdateWorldShopGoods({
								{
									goods_id = var1_1,
									count = var2_1
								}
							})
						end
					})
				end

				var4_1:updatePlayer(var1_11)

				if var3_1.group > 0 then
					var9_1:updateNormalGroupList(var3_1.group, var3_1.group_buy_count)
				end

				switch(var3_1.effect_args, {
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

				if not var0_1.isQuickShopping then
					arg0_1:sendNotification(GAME.SHOPPING_DONE, {
						id = var1_1,
						shopType = var2_11,
						normalList = var9_1:GetNormalList(),
						normalGroupList = var9_1:GetNormalGroupList(),
						awards = var0_11
					})
				end
			else
				originalPrint(arg0_11.result)

				if arg0_11.result == 4400 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("shopping_error_time_limit"))
				else
					pg.TipsMgr.GetInstance():ShowTips(errorTip("", arg0_11.result))
				end
			end
		end)
	end)
end

return var0_0
