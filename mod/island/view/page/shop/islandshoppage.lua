local var0_0 = class("IslandShopPage", import("...base.IslandBasePage"))
local var1_0 = pg.island_item_data_template

function var0_0.getUIName(arg0_1)
	return "IslandShopUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.bg = arg0_2:findTF("bg")
	arg0_2.bg2 = arg0_2:findTF("bg2")
	arg0_2.closeBtn = arg0_2:findTF("top/closeBtn")
	arg0_2.title = arg0_2:findTF("top/title")
	arg0_2.resourceList = UIItemList.New(arg0_2:findTF("top/resources"), arg0_2:findTF("top/resources/resourceTpl"))
	arg0_2.shop1List = UIItemList.New(arg0_2:findTF("shop1List"), arg0_2:findTF("shop1List/shop1Tpl"))
	arg0_2.shop3 = arg0_2:findTF("shop3List")
	arg0_2.shop3List = UIItemList.New(arg0_2:findTF("shop3List"), arg0_2:findTF("shop3List/shop3Tpl"))
	arg0_2.recommendationPage = arg0_2:findTF("shopPage/recommendation")
	arg0_2.shop2DPage = arg0_2:findTF("shopPage/shop2D")
	arg0_2.shop3DPage = arg0_2:findTF("shopPage/shop3D")
	arg0_2.shopFurniturePage = arg0_2:findTF("shopPage/shopFurniture")
	arg0_2.shopSkinPage = arg0_2:findTF("shopPage/shopSkin")
	arg0_2.subPageContainer = arg0_2:findTF("subPageContainer")
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	arg0_3:InitData()
end

function var0_0.InitData(arg0_5)
	arg0_5.shopAgency = getProxy(IslandProxy):GetIsland():GetShopAgency()
	arg0_5.inventoryAgency = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	arg0_5.player = getProxy(PlayerProxy):getRawData()
end

function var0_0.DoUpdateShops(arg0_6)
	local var0_6 = arg0_6.shopAgency:GetNewOrOverdueShopIds()

	if #var0_6 > 0 then
		for iter0_6, iter1_6 in ipairs(var0_6) do
			arg0_6:emit(IslandMediator.GET_SHOP_DATA, iter1_6, true)
		end
	end
end

function var0_0.DoUpdateShowingShop(arg0_7)
	arg0_7:emit(IslandMediator.GET_SHOP_DATA, arg0_7.showingShop.id, false)
end

function var0_0.UpdateData(arg0_8)
	arg0_8.firstShopConfigs = arg0_8.shopAgency:GetFirstShopConfigs(arg0_8.showTypes)

	if not arg0_8.showingShop or not arg0_8.shopAgency:IsShowShop(arg0_8.showingShop.id) then
		arg0_8.showingShop = arg0_8.shopAgency:GetInitShowingShop(arg0_8.showTypes)
	end
end

function var0_0.SetShopList(arg0_9)
	arg0_9.shop1List:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_9.firstShopConfigs[arg1_10 + 1]

			setActive(arg2_10:Find("shop2List"), false)
			LoadImageSpriteAsync("herohrzicon/" .. var0_10.tag_icon, arg2_10:Find("shop1Tg/name"), false)
			onToggle(arg0_9, arg2_10:Find("shop1Tg"), function(arg0_11)
				setActive(arg0_9.shop3, false)

				if arg0_11 then
					setActive(arg2_10:Find("shop2List"), var0_10.shop_type == 0)

					if var0_10.shop_type == 0 then
						local var0_11 = arg0_9.shopAgency:GetSecondShopConfigs(arg0_9.showTypes, var0_10.id)
						local var1_11 = UIItemList.New(arg2_10:Find("shop2List"), arg2_10:Find("shop2List/shop2Tpl"))

						var1_11:make(function(arg0_12, arg1_12, arg2_12)
							if arg0_12 == UIItemList.EventUpdate then
								local var0_12 = var0_11[arg1_12 + 1]

								LoadImageSpriteAsync("herohrzicon/" .. var0_12.tag_icon, arg2_12:Find("name"), false)
								onToggle(arg0_9, arg2_12, function(arg0_13)
									if arg0_13 then
										setActive(arg0_9.shop3, var0_12.shop_type == 0)

										if var0_12.shop_type == 0 then
											local var0_13 = arg0_9.shopAgency:GetThirdShopConfigs(arg0_9.showTypes, var0_12.id)

											arg0_9.shop3List:make(function(arg0_14, arg1_14, arg2_14)
												if arg0_14 == UIItemList.EventUpdate then
													local var0_14 = var0_13[arg1_14 + 1]

													LoadImageSpriteAsync("herohrzicon/" .. var0_14.tag_icon, arg2_14:Find("name"), false)
													onToggle(arg0_9, arg2_14, function(arg0_15)
														if arg0_15 then
															arg0_9.showingShop = arg0_9.shopAgency:GetShopById(var0_14.id)

															arg0_9:DoUpdateShowingShop()
														end
													end, SFX_PANEL)

													if arg0_9.showingShop.id == var0_14.id then
														triggerToggle(arg2_14, true)
													end
												end
											end, SFX_PANEL)
											arg0_9.shop3List:align(#var0_13)
										else
											arg0_9.showingShop = arg0_9.shopAgency:GetShopById(var0_12.id)

											arg0_9:DoUpdateShowingShop()
										end
									end
								end, SFX_PANEL)

								if arg0_9.showingShop.id == var0_12.id or arg0_9.showingShop:GetSecondShopId() == var0_12.id then
									triggerToggle(arg2_12, true)
								end
							end
						end)
						var1_11:align(#var0_11)
					else
						arg0_9.showingShop = arg0_9.shopAgency:GetShopById(var0_10.id)

						arg0_9:DoUpdateShowingShop()
					end
				else
					setActive(arg2_10:Find("shop2List"), false)
				end
			end, SFX_PANEL)

			if arg0_9.showingShop.id == var0_10.id or arg0_9.showingShop:GetFirstShopId() == var0_10.id then
				triggerToggle(arg2_10:Find("shop1Tg"), true)
			end
		end
	end)
	arg0_9.shop1List:align(#arg0_9.firstShopConfigs)
end

function var0_0.SetShopPage(arg0_16)
	local var0_16 = arg0_16.showingShop:GetShowType()

	setActive(arg0_16.bg, var0_16 ~= IslandConst.SHOP_TYPE_3D)
	setActive(arg0_16.bg2, var0_16 == IslandConst.SHOP_TYPE_3D)
	LoadImageSpriteAsync("herohrzicon/" .. arg0_16.showingShop:GetShopIcon(), arg0_16.title, false)
	arg0_16:SetResources()
	setActive(arg0_16.recommendationPage, var0_16 == IslandConst.SHOP_TYPE_RECOMMENDATION)
	setActive(arg0_16.shop2DPage, var0_16 == IslandConst.SHOP_TYPE_2D)
	setActive(arg0_16.shop3DPage, var0_16 == IslandConst.SHOP_TYPE_3D)
	setActive(arg0_16.shopFurniturePage, var0_16 == IslandConst.SHOP_TYPE_FURNITURE)
	setActive(arg0_16.shopSkinPage, var0_16 == IslandConst.SHOP_TYPE_SKIN)
	switch(var0_16, {
		[IslandConst.SHOP_TYPE_RECOMMENDATION] = function()
			arg0_16:ShowRecommendation()
		end,
		[IslandConst.SHOP_TYPE_2D] = function()
			arg0_16:ShowShop2D()
		end,
		[IslandConst.SHOP_TYPE_3D] = function()
			arg0_16:ShowShop3D()
		end,
		[IslandConst.SHOP_TYPE_FURNITURE] = function()
			arg0_16:ShowShopFurniture()
		end,
		[IslandConst.SHOP_TYPE_SKIN] = function()
			arg0_16:ShowShopSkin()
		end
	})
end

function var0_0.SetResources(arg0_22)
	local var0_22 = arg0_22.showingShop:GetTopResources()

	arg0_22.resourceList:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventUpdate then
			local var0_23 = var0_22[arg1_23 + 1]
			local var1_23 = var0_23[1]
			local var2_23 = var0_23[2]

			if var1_23 == DROP_TYPE_RESOURCE then
				if var2_23 == 1 then
					setText(arg2_23:Find("count"), arg0_22.player.gold)

					if not pg.goldExchangeMgr then
						pg.goldExchangeMgr = GoldExchangeView.New()
					end
				elseif var2_23 == 4 or var2_23 == 14 then
					setText(arg2_23:Find("count"), arg0_22.player:getTotalGem())

					local function var3_23()
						if not pg.m02:hasMediator(NewShopMainMediator.__cname) then
							pg.m02:sendNotification(GAME.GO_SCENE, SCENE.CHARGE, {
								wrap = ChargeScene.TYPE_DIAMOND
							})
						else
							pg.m02:sendNotification(var0_0.GO_MALL)
						end
					end

					if PLATFORM_CODE == PLATFORM_JP then
						pg.MsgboxMgr.GetInstance():ShowMsgBox({
							fontSize = 23,
							yesText = "text_buy",
							content = i18n("word_diamond_tip", arg0_22.player:getFreeGem(), arg0_22.player:getChargeGem(), arg0_22.player:getTotalGem()),
							onYes = var3_23,
							alignment = TextAnchor.UpperLeft,
							weight = LayerWeightConst.TOP_LAYER
						})
					else
						var3_23()
					end
				end
			elseif var1_23 == DROP_TYPE_ISLAND_ITEM then
				setText(arg2_23:Find("count"), arg0_22.inventoryAgency:GetOwnCount(var2_23))

				local var4_23 = var1_0[var2_23].jump_page
			end
		end
	end)
	arg0_22.resourceList:align(#var0_22)
end

function var0_0.SetCloseAndRefresh(arg0_25, arg1_25)
	local var0_25 = arg0_25.showingShop:GetExistTime()
	local var1_25 = arg0_25.showingShop.existTime
	local var2_25 = arg0_25.showingShop.refreshTime
	local var3_25 = arg0_25.showingShop:GetPlayerRefreshResource()

	setActive(arg0_25:findTF("remainTimer", arg1_25), var1_25 ~= 0 or var0_25 and type(var0_25) == "table")
	setActive(arg0_25:findTF("refreshTimer", arg1_25), var2_25 ~= 0)
	setActive(arg0_25:findTF("refreshBtn", arg1_25), var3_25)

	local var4_25 = pg.TimeMgr.GetInstance():GetTimeToNextTime()

	if arg0_25.timer then
		arg0_25.timer:Stop()

		arg0_25.timer = nil
	end

	arg0_25.timer = Timer.New(function()
		local var0_26 = pg.TimeMgr.GetInstance():GetServerTime()

		if var1_25 ~= 0 then
			local var1_26 = pg.TimeMgr.GetInstance():DescCDTime(var1_25 - var0_26)

			setText(arg0_25:findTF("remainTimer/Text", arg1_25), "商店剩余" .. var1_26 .. "关闭")
		elseif var0_25 and type(var0_25) == "table" then
			-- block empty
		end

		if var2_25 ~= 0 then
			local var2_26 = pg.TimeMgr.GetInstance():DescCDTime(var2_25 - var0_26)

			setText(arg0_25:findTF("refreshTimer/Text", arg1_25), var2_26)

			if var0_26 > var2_25 then
				arg0_25:DoUpdateShowingShop()
			end
		end

		if var2_25 == 0 and var3_25 and var0_26 > var4_25 then
			arg0_25:DoUpdateShowingShop()
		end
	end, 1, -1)

	arg0_25.timer:Start()

	if var3_25 then
		onButton(arg0_25, arg0_25:findTF("refreshBtn", arg1_25), function()
			local var0_27 = arg0_25.showingShop.refreshCount

			if var0_27 < arg0_25.showingShop:GetMaxRefreshCount() then
				local var1_27 = arg0_25.showingShop:GetFirstRefreshFree()
				local var2_27 = var3_25[3]

				if var1_27 and var0_27 == 0 then
					var3_25[3] = 0
					var2_27 = 0
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					noText = "text_cancel",
					hideNo = false,
					yesText = "text_confirm",
					content = i18n("refresh_shopStreet_question", i18n("word_" .. id2res(var3_25[2]) .. "_icon"), var2_27, var0_27),
					onYes = function()
						arg0_25:emit(IslandMediator.REFRESH_SHOP_BY_PLAYER, arg0_25.showingShop.id, var3_25)
					end
				})
			else
				pg.TipsMgr.GetInstance():ShowTips("刷新次数到上限啦哥们")
			end
		end, SFX_PANEL)
	end
end

function var0_0.SetCommodity(arg0_29, arg1_29, arg2_29)
	local var0_29 = arg2_29:GetMaxNum() - arg2_29.purchasedNum

	setText(arg1_29:Find("name"), arg2_29:GetName())
	GetImageSpriteFromAtlasAsync("herohrzicon/" .. arg2_29:GetIcon(), "", arg1_29:Find("icon"))

	local var1_29 = arg2_29:GetResourceConsume()

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = var1_29[1],
		id = var1_29[2]
	}):getIcon(), "", arg1_29:Find("cost/icon"))
	setText(arg1_29:Find("cost/num"), math.ceil((100 - arg2_29:GetDiscount()) / 100 * var1_29[3]))
	setActive(arg1_29:Find("remain"), arg2_29:IsShowPurchaseLimit())
	setText(arg1_29:Find("remain"), var0_29 .. "/" .. arg2_29:GetMaxNum())
	setActive(arg1_29:Find("sellOut"), arg2_29:GetMaxNum() ~= 0 and var0_29 == 0)
	setActive(arg1_29:Find("timeLimit"), arg2_29:IsTimeLimitCommodity())
	setActive(arg1_29:Find("discount"), arg2_29:GetDiscount() ~= 0)
	setText(arg1_29:Find("discount/Text"), arg2_29:GetDiscount() .. "%OFF")
	onButton(arg0_29, arg1_29, function()
		switch(arg2_29:GetCommodityShowType(), {
			[IslandConst.COMMODITY_SHOW_ITEM_FULL] = function()
				IslandShopItemLayer.New(arg0_29.subPageContainer, arg0_29.event, arg0_29.contextData, IslandConst.COMMODITY_SHOW_ITEM_FULL):ExecuteAction("Open", arg0_29.showingShop.id, arg2_29)
			end,
			[IslandConst.COMMODITY_SHOW_ITEM_HALF] = function()
				IslandShopItemLayer.New(arg0_29.subPageContainer, arg0_29.event, arg0_29.contextData, IslandConst.COMMODITY_SHOW_ITEM_HALF):ExecuteAction("Open", arg0_29.showingShop.id, arg2_29)
			end,
			[IslandConst.COMMODITY_SHOW_SKIN] = function()
				return
			end,
			[IslandConst.COMMODITY_SHOW_FURNITURE] = function()
				return
			end,
			[IslandConst.COMMODITY_SHOW_SKIN_PACK] = function()
				return
			end,
			[IslandConst.COMMODITY_SHOW_FURNITURE_PACK] = function()
				return
			end
		})
	end, SFX_PANEL)
end

function var0_0.SetCommodityList(arg0_37, arg1_37)
	local var0_37 = arg0_37.showingShop:GetCommodities()

	arg1_37:make(function(arg0_38, arg1_38, arg2_38)
		if arg0_38 == UIItemList.EventUpdate then
			local var0_38 = var0_37[arg1_38 + 1]

			arg0_37:SetCommodity(arg2_38, var0_38)
		end
	end, SFX_PANEL)
	arg1_37:align(#var0_37)
end

function var0_0.ShowRecommendation(arg0_39)
	local var0_39 = arg0_39.showingShop:GetBanners()
	local var1_39 = arg0_39:findTF("banners", arg0_39.recommendationPage)

	for iter0_39 = 1, #var0_39 do
		local var2_39 = var0_39[iter0_39]
		local var3_39 = var1_39:GetChild(iter0_39 - 1)

		GetImageSpriteFromAtlasAsync("activitybanner/" .. var2_39.pic, "", var3_39)
		onButton(arg0_39, var3_39, function()
			local var0_40 = arg0_39.shopAgency:GetShopById(var2_39.param)

			if var0_40 then
				arg0_39.showingShop = var0_40

				arg0_39:emit(IslandMediator.GET_SHOP_DATA, arg0_39.showingShop.id, true)
			end
		end, SFX_PANEL)
	end
end

function var0_0.ShowShop2D(arg0_41)
	arg0_41:SetCloseAndRefresh(arg0_41.shop2DPage)

	local var0_41 = UIItemList.New(arg0_41:findTF("shopView/Viewport/Content", arg0_41.shop2DPage), arg0_41:findTF("shopView/Viewport/Content/commodityTpl", arg0_41.shop2DPage))

	arg0_41:SetCommodityList(var0_41)
end

function var0_0.ShowShop3D(arg0_42)
	arg0_42:SetCloseAndRefresh(arg0_42.shop3DPage)

	local var0_42 = UIItemList.New(arg0_42:findTF("shopView/Viewport/Content", arg0_42.shop3DPage), arg0_42:findTF("shopView/Viewport/Content/commodityTpl", arg0_42.shop3DPage))

	arg0_42:SetCommodityList(var0_42)
end

function var0_0.ShowShopFurniture(arg0_43)
	arg0_43:SetCloseAndRefresh(arg0_43.shopFurniturePage)

	local var0_43 = UIItemList.New(arg0_43:findTF("shopView/Viewport/Content", arg0_43.shopFurniturePage), arg0_43:findTF("shopView/Viewport/Content/commodityTpl", arg0_43.shopFurniturePage))

	arg0_43:SetCommodityList(var0_43)
end

function var0_0.ShowShopSkin(arg0_44)
	arg0_44:SetCloseAndRefresh(arg0_44.shopSkinPage)

	local var0_44 = UIItemList.New(arg0_44:findTF("shopView/Viewport/Content", arg0_44.shopSkinPage), arg0_44:findTF("shopView/Viewport/Content/commodityTpl", arg0_44.shopSkinPage))

	arg0_44:SetCommodityList(var0_44)
end

function var0_0.AddListeners(arg0_45)
	arg0_45:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_45.UpdateView)
end

function var0_0.RemoveListener(arg0_46)
	arg0_46:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_46.UpdateView)
end

function var0_0.UpdateView(arg0_47, arg1_47)
	if arg1_47.operation == IslandConst.SHOP_GET_DATA then
		if arg1_47.refreshAll then
			arg0_47:UpdateData()
			arg0_47:SetShopList()
		else
			arg0_47:SetShopPage()
		end
	elseif arg1_47.operation == IslandConst.SHOP_BUY_COMMODITY or arg1_47.operation == IslandConst.REFRESH_SHOP_BY_PLAYER then
		arg0_47:SetShopPage()
	end
end

function var0_0.OnShow(arg0_48, arg1_48)
	arg0_48.showTypes = arg1_48

	arg0_48:DoUpdateShops()
	arg0_48:UpdateData()
	arg0_48:SetShopList()
	pg.UIMgr.GetInstance():BlurPanel(arg0_48._tf)
end

function var0_0.OnHide(arg0_49)
	if arg0_49.timer then
		arg0_49.timer:Stop()

		arg0_49.timer = nil
	end

	if pg.goldExchangeMgr then
		pg.goldExchangeMgr:exit()

		pg.goldExchangeMgr = nil
	end

	pg.UIMgr.GetInstance():UnblurPanel(arg0_49._tf)
end

return var0_0
