local var0_0 = class("IslandShopOpCommand", pm.SimpleCommand)

function var0_0.execute(arg0_1, arg1_1)
	local var0_1 = arg1_1:getBody()
	local var1_1 = getProxy(IslandProxy):GetIsland():GetShopAgency()
	local var2_1 = getProxy(IslandProxy):GetIsland():GetInventoryAgency()

	if var0_1.operation == IslandConst.SHOP_GET_DATA then
		pg.ConnectionMgr.GetInstance():Send(21016, {
			shop_id = var0_1.shopId
		}, 21017, function(arg0_2)
			if arg0_2.result == 0 then
				var1_1:UpdateShop(var0_1.shopId, arg0_2.shop_info)
				arg0_1:sendNotification(GAME.ISLAND_SHOP_OP_DONE, {
					operation = var0_1.operation,
					refreshAll = var0_1.refreshAll
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				var1_1:UpdateShop(var0_1.shopId, nil)
			end
		end)
	elseif var0_1.operation == IslandConst.SHOP_BUY_COMMODITY then
		local var3_1 = getProxy(PlayerProxy):getData()
		local var4_1 = {}
		local var5_1 = {}
		local var6_1 = 0
		local var7_1 = {}

		for iter0_1, iter1_1 in ipairs(var0_1.commodityList) do
			local var8_1 = iter1_1.key
			local var9_1 = iter1_1.value1
			local var10_1 = iter1_1.value2
			local var11_1 = var1_1:GetShopCommodity(var8_1, var9_1)

			table.insert(var4_1, var11_1)
			table.insertto(var7_1, var11_1:GetItems())

			if not var11_1 then
				return
			end

			if var10_1 == 0 then
				return
			end

			local var12_1 = Clone(var11_1:GetResourceConsume())
			local var13_1 = var12_1[3] * var10_1

			var12_1[3] = math.ceil((100 - var11_1:GetDiscount()) / 100 * var13_1)

			local var14_1 = false

			for iter2_1, iter3_1 in ipairs(var5_1) do
				if iter3_1[1] == var12_1[1] and iter3_1[2] == var12_1[2] then
					var14_1 = true
					iter3_1[3] = iter3_1[3] + var12_1[3]

					break
				end
			end

			if not var14_1 then
				table.insert(var5_1, var12_1)
			end

			var6_1 = var6_1 + pg.island_shop_goods[var9_1].pt_award * var10_1

			local var15_1 = {}
			local var16_1 = var11_1:GetItems()

			for iter4_1, iter5_1 in ipairs(var16_1) do
				if iter5_1[1] ~= DROP_TYPE_ISLAND_ITEM then
					local var17_1 = Drop.New({
						type = iter5_1[1],
						id = iter5_1[2],
						count = iter5_1[3]
					})

					table.insert(var15_1, var17_1)
				end
			end

			local var18_1 = GetItemsOverflowDic(var15_1)
			local var19_1, var20_1 = CheckOverflow(var18_1)

			if not var19_1 then
				switch(var20_1, {
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

			if not CheckShipExpOverflow(var18_1) then
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("player_expResource_mail_fullBag"),
					onYes = next
				})

				return
			end
		end

		local var21_1 = false

		for iter6_1, iter7_1 in ipairs(var7_1) do
			if iter7_1[1] == DROP_TYPE_ISLAND_ITEM then
				var21_1 = true
			end
		end

		if var21_1 and var2_1:ExistAnyOverFlowItem() then
			pg.TipsMgr.GetInstance():ShowTips("岛屿内背包已满")

			return
		end

		for iter8_1, iter9_1 in ipairs(var5_1) do
			local var22_1 = iter9_1[3]

			if iter9_1[1] == DROP_TYPE_RESOURCE then
				if var22_1 > var3_1[id2res(iter9_1[2])] then
					local var23_1 = Drop.New({
						type = DROP_TYPE_RESOURCE,
						id = iter9_1[2]
					}):getName()

					if iter9_1[2] == 1 then
						pg.TipsMgr.GetInstance():ShowTips("物资不足")
					elseif iter9_1[2] == 4 or iter9_1[2] == 14 then
						pg.TipsMgr.GetInstance():ShowTips("钻石不足")
					elseif not ItemTipPanel.ShowItemTip(DROP_TYPE_RESOURCE, iter9_1[2]) then
						pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var23_1))
					end

					return
				end
			elseif iter9_1[1] == DROP_TYPE_ISLAND_ITEM and var22_1 > var2_1:GetOwnCount(iter9_1[2]) then
				pg.TipsMgr.GetInstance():ShowTips("岛屿内道具不足")

				local var24_1 = pg.island_item_data_template[iter9_1[2]].jump_page

				return
			end
		end

		if var4_1[1]:GetPayId() == 0 then
			pg.ConnectionMgr.GetInstance():Send(21018, {
				goods_list = var0_1.commodityList
			}, 21019, function(arg0_7)
				if arg0_7.result == 0 then
					for iter0_7, iter1_7 in ipairs(var5_1) do
						arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.New({
							type = iter1_7[1],
							id = iter1_7[2],
							count = iter1_7[3]
						}))
					end

					local var0_7 = {}

					for iter2_7, iter3_7 in ipairs(arg0_7.drop_list) do
						table.insert(var0_7, iter3_7)
					end

					local var1_7 = {
						id = 0,
						type = VIRTUAL_DROP_TYPE_ISLAND_SEASON_PT,
						count = var6_1
					}

					table.insert(var0_7, var1_7)

					local var2_7 = IslandDropHelper.AddItems({
						drop_list = var0_7
					})

					for iter4_7, iter5_7 in ipairs(var0_1.commodityList) do
						var1_1:UpdateShopCommodity(iter5_7.key, iter5_7.value1, iter5_7.value2)
						pg.GameTrackerMgr.GetInstance():Record(GameTrackerBuilder.BuildIslandShopBuy(iter5_7.key, iter5_7.value1))
					end

					arg0_1:sendNotification(GAME.ISLAND_SHOP_OP_DONE, {
						operation = var0_1.operation,
						awards = arg0_7.drop_list,
						ptAward = var1_7
					})

					if var0_1.callback then
						var0_1.callback()
					end
				else
					pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_7.result] .. arg0_7.result)
				end
			end)
		end
	elseif var0_1.operation == IslandConst.SHOP_REFRESH_BY_PLAYER then
		local var25_1 = var0_1.refreshResource
		local var26_1 = getProxy(PlayerProxy):getData()
		local var27_1 = var25_1[3]

		if var27_1 ~= 0 then
			if var25_1[1] == DROP_TYPE_RESOURCE then
				if var27_1 > var26_1[id2res(var25_1[2])] then
					local var28_1 = Drop.New({
						type = DROP_TYPE_RESOURCE,
						id = var25_1[2]
					}):getName()

					if var25_1[2] == 1 then
						GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
							{
								59001,
								var27_1 - var26_1[id2res(var25_1[2])],
								var27_1
							}
						})
					elseif var25_1[2] == 4 or var25_1[2] == 14 then
						GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
					elseif not ItemTipPanel.ShowItemTip(DROP_TYPE_RESOURCE, var25_1[2]) then
						pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var28_1))
					end

					return
				end
			elseif var25_1[1] == DROP_TYPE_ISLAND_ITEM and var27_1 > var2_1:GetOwnCount(var25_1[2]) then
				local var29_1 = pg.island_item_data_template[var25_1[2]].name

				pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var29_1))

				return
			end
		end

		pg.ConnectionMgr.GetInstance():Send(21020, {
			shop_id = var0_1.shopId
		}, 21021, function(arg0_8)
			if arg0_8.result == 0 then
				if var27_1 ~= 0 then
					arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.New({
						type = var25_1[1],
						id = var25_1[2],
						count = var27_1
					}))
				end

				var1_1:UpdateShop(var0_1.shopId, arg0_8.shop_info)
				arg0_1:sendNotification(GAME.ISLAND_SHOP_OP_DONE, {
					operation = var0_1.operation
				})

				if var0_1.callback then
					var0_1.callback()
				end
			else
				pg.TipsMgr.GetInstance():ShowTips(ERROR_MESSAGE[arg0_8.result] .. arg0_8.result)
			end
		end)
	end
end

return var0_0
