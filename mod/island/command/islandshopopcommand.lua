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
		local var3_1 = var1_1:GetShopCommodity(var0_1.shopId, var0_1.commodityId)
		local var4_1 = getProxy(PlayerProxy):getData()

		if not var3_1 then
			return
		end

		if var0_1.count == 0 then
			return
		end

		local var5_1 = var3_1:GetResourceConsume()
		local var6_1 = var5_1[3] * var0_1.count
		local var7_1 = math.ceil((100 - var3_1:GetDiscount()) / 100 * var6_1)

		if var5_1[1] == DROP_TYPE_RESOURCE then
			if var7_1 > var4_1[id2res(var5_1[2])] then
				local var8_1 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = var5_1[2]
				}):getName()

				if var5_1[2] == 1 then
					GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
						{
							59001,
							var7_1 - var4_1[id2res(var5_1[2])],
							var7_1
						}
					})
				elseif var5_1[2] == 4 or var5_1[2] == 14 then
					GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
				elseif not ItemTipPanel.ShowItemTip(DROP_TYPE_RESOURCE, var5_1[2]) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var8_1))
				end

				return
			end
		elseif var5_1[1] == DROP_TYPE_ISLAND_ITEM and var7_1 > var2_1:GetOwnCount(var5_1[2]) then
			pg.TipsMgr.GetInstance():ShowTips("岛屿内道具不足")

			local var9_1 = pg.island_item_data_template[var5_1[2]].jump_page

			return
		end

		local var10_1 = {}
		local var11_1 = var3_1:GetItems()

		for iter0_1, iter1_1 in ipairs(var11_1) do
			if iter1_1[1] ~= DROP_TYPE_ISLAND_ITEM then
				local var12_1 = Drop.New({
					type = iter1_1[1],
					id = iter1_1[2],
					count = iter1_1[3]
				})

				table.insert(var10_1, var12_1)
			end
		end

		local var13_1 = GetItemsOverflowDic(var10_1)
		local var14_1, var15_1 = CheckOverflow(var13_1)

		if not var14_1 then
			switch(var15_1, {
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

		if not CheckShipExpOverflow(var13_1) then
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("player_expResource_mail_fullBag"),
				onYes = next
			})

			return
		end

		if var2_1:ExistAnyOverFlowItem() then
			pg.TipsMgr.GetInstance():ShowTips("岛屿内背包已满")

			return
		end

		if var3_1:GetPayId() == 0 then
			pg.ConnectionMgr.GetInstance():Send(21018, {
				shop_id = var0_1.shopId,
				goods_id = var0_1.commodityId,
				num = var0_1.count
			}, 21019, function(arg0_7)
				if arg0_7.result == 0 then
					arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.New({
						type = var5_1[1],
						id = var5_1[2],
						count = var7_1
					}))
					IslandDropHelper.AddItems(arg0_7.drop_list)
					var1_1:UpdateShopCommodity(var0_1.shopId, var0_1.commodityId, var0_1.count)
					arg0_1:sendNotification(GAME.ISLAND_SHOP_OP_DONE, {
						operation = var0_1.operation
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
		local var16_1 = var0_1.refreshResource
		local var17_1 = getProxy(PlayerProxy):getData()
		local var18_1 = var16_1[3]

		if var18_1 ~= 0 then
			if var16_1[1] == DROP_TYPE_RESOURCE then
				if var18_1 > var17_1[id2res(var16_1[2])] then
					local var19_1 = Drop.New({
						type = DROP_TYPE_RESOURCE,
						id = var16_1[2]
					}):getName()

					if var16_1[2] == 1 then
						GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
							{
								59001,
								var18_1 - var17_1[id2res(var16_1[2])],
								var18_1
							}
						})
					elseif var16_1[2] == 4 or var16_1[2] == 14 then
						GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
					elseif not ItemTipPanel.ShowItemTip(DROP_TYPE_RESOURCE, var16_1[2]) then
						pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var19_1))
					end

					return
				end
			elseif var16_1[1] == DROP_TYPE_ISLAND_ITEM and var18_1 > var2_1:GetOwnCount(var16_1[2]) then
				local var20_1 = pg.island_item_data_template[var16_1[2]].name

				pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var20_1))

				return
			end
		end

		pg.ConnectionMgr.GetInstance():Send(21020, {
			shop_id = var0_1.shopId
		}, 21021, function(arg0_8)
			if arg0_8.result == 0 then
				if var18_1 ~= 0 then
					arg0_1:sendNotification(GAME.CONSUME_ITEM, Drop.New({
						type = var16_1[1],
						id = var16_1[2],
						count = var18_1
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
