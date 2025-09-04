local var0_0 = class("IslandShopPage", import("..ship.IslandBaseShipDisplayPage"))
local var1_0 = pg.island_item_data_template

var0_0.CharaSetModel = {
	current = 1,
	default = 2
}

function var0_0.getUIName(arg0_1)
	return "IslandShopUI"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.bg = arg0_2._tf:Find("bg")
	arg0_2.bgColor = arg0_2.bg:Find("color")
	arg0_2.closeBtn = arg0_2:findTF("top/closeBtn")
	arg0_2.title = arg0_2:findTF("top/title")
	arg0_2.resourceList = UIItemList.New(arg0_2:findTF("top/resources"), arg0_2:findTF("top/resources/resourceTpl"))
	arg0_2.shop1List = UIItemList.New(arg0_2:findTF("shop1List"), arg0_2:findTF("shop1List/shop1Tpl"))
	arg0_2.shop3 = arg0_2:findTF("shop3List")
	arg0_2.shop3List = UIItemList.New(arg0_2:findTF("shop3List"), arg0_2:findTF("shop3List/shop3Tpl"))
	arg0_2.shop32 = arg0_2:findTF("shop3List2")
	arg0_2.shop3List2 = UIItemList.New(arg0_2:findTF("shop3List2"), arg0_2:findTF("shop3List2/shop3Tpl"))
	arg0_2.recommendationPage = arg0_2:findTF("shopPage/recommendation")
	arg0_2.shop2DPage = arg0_2:findTF("shopPage/shop2D")
	arg0_2.shop3DPage = arg0_2:findTF("shopPage/shop3D")
	arg0_2.shopFurniturePage = arg0_2:findTF("shopPage/shopFurniture")
	arg0_2.shopSkinPage = arg0_2:findTF("shopPage/shopSkin")
	arg0_2.changeCharaPanel = arg0_2.shopSkinPage:Find("changeCharaPanel/panel")
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
	arg0_5.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	arg0_5.player = getProxy(PlayerProxy):getRawData()
	arg0_5.ships = arg0_5.characterAgency:GetShips()
	arg0_5.defaultShipId = PlayerPrefs.GetInt("island_dressShop_defaultShipId_" .. arg0_5.player.id, 10703)
	arg0_5.islandShipDressHelper = IslandShipDressHelper.New()
end

function var0_0.DoUpdateShops(arg0_6)
	local var0_6 = arg0_6.shopAgency:GetNewOrOverdueShopIds()

	if #var0_6 > 0 then
		for iter0_6, iter1_6 in ipairs(var0_6) do
			arg0_6:emit(IslandMediator.GET_SHOP_DATA, iter1_6, true)
		end
	end

	arg0_6.showingShop = nil
	arg0_6.selectShipId = arg0_6.defaultShipId
end

function var0_0.DoUpdateShowingShop(arg0_7)
	if arg0_7.showingShop:IsInTime() then
		arg0_7:emit(IslandMediator.GET_SHOP_DATA, arg0_7.showingShop.id, false)
	else
		arg0_7:SetShopPage()
	end

	if isActive(arg0_7.shop3) or isActive(arg0_7.shop32) then
		local var0_7 = arg0_7.showingShop:GetShowType()

		setActive(arg0_7.shop3, var0_7 == IslandConst.SHOP_TYPE_RECOMMENDATION or var0_7 == IslandConst.SHOP_TYPE_2D)
		setActive(arg0_7.shop32, var0_7 == IslandConst.SHOP_TYPE_3D or var0_7 == IslandConst.SHOP_TYPE_FURNITURE or var0_7 == IslandConst.SHOP_TYPE_SKIN)
	end
end

function var0_0.UpdateData(arg0_8)
	arg0_8.firstShopConfigs = arg0_8.shopAgency:GetFirstShopConfigs(arg0_8.showTypes, arg0_8.firstShopIds)

	if not arg0_8.showingShop or not arg0_8.shopAgency:IsShowShop(arg0_8.showingShop.id) then
		arg0_8.showingShop = arg0_8.shopAgency:GetInitShowingShop(arg0_8.showTypes, arg0_8.firstShopIds)
	end
end

function var0_0.SetShopList(arg0_9)
	arg0_9.shop1List:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_9.firstShopConfigs[arg1_10 + 1]

			setActive(arg2_10:Find("shop2List"), false)
			setActive(arg2_10:Find("shop1Tg/selected"), arg0_9.showingShop.id == var0_10.id or arg0_9.showingShop:GetFirstShopId() == var0_10.id)
			LoadImageSpriteAsync(var0_10.tag_icon[3], arg2_10:Find("shop1Tg/selected/icon"), false)
			setText(arg2_10:Find("shop1Tg/name"), var0_10.tag_icon[1])
			setText(arg2_10:Find("shop1Tg/name/en"), var0_10.tag_icon[2])
			onToggle(arg0_9, arg2_10:Find("shop1Tg"), function(arg0_11)
				setActive(arg0_9.shop3, false)
				setActive(arg0_9.shop32, false)

				if arg0_11 then
					for iter0_11 = 0, arg0_9:findTF("shop1List").childCount - 1 do
						setActive(arg0_9:findTF("shop1List"):GetChild(iter0_11):Find("shop1Tg/selected"), false)
					end

					setActive(arg2_10:Find("shop1Tg/selected"), true)
					arg2_10:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop1List_Selected")
					setActive(arg2_10:Find("shop2List"), var0_10.shop_type == 0)

					if var0_10.shop_type == 0 then
						local var0_11 = arg0_9.shopAgency:GetSecondShopConfigs(arg0_9.showTypes, var0_10.id)
						local var1_11 = UIItemList.New(arg2_10:Find("shop2List"), arg2_10:Find("shop2List/shop2Tpl"))

						var1_11:make(function(arg0_12, arg1_12, arg2_12)
							if arg0_12 == UIItemList.EventUpdate then
								local var0_12 = var0_11[arg1_12 + 1]

								setActive(arg2_12:Find("selected"), arg0_9.showingShop.id == var0_12.id or arg0_9.showingShop:GetSecondShopId() == var0_12.id)
								setText(arg2_12:Find("name"), var0_12.tag_icon[1])
								setText(arg2_12:Find("selected/name"), var0_12.tag_icon[1])
								onToggle(arg0_9, arg2_12, function(arg0_13)
									if arg0_13 then
										for iter0_13 = 0, arg2_10:Find("shop2List").childCount - 1 do
											setActive(arg2_10:Find("shop2List"):GetChild(iter0_13):Find("selected"), false)
										end

										setActive(arg2_12:Find("selected"), true)
										arg2_12:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop2List_Selected")
										setActive(arg0_9.shop3, var0_12.shop_type == 0)
										setActive(arg0_9.shop32, var0_12.shop_type == 0)

										if var0_12.shop_type == 0 then
											local var0_13 = arg0_9.shopAgency:GetThirdShopConfigs(arg0_9.showTypes, var0_12.id)

											arg0_9.shop3List:make(function(arg0_14, arg1_14, arg2_14)
												if arg0_14 == UIItemList.EventUpdate then
													local var0_14 = var0_13[arg1_14 + 1]

													setActive(arg2_14:Find("selected"), arg0_9.showingShop.id == var0_14.id)
													setText(arg2_14:Find("name"), var0_14.tag_icon[1])
													setText(arg2_14:Find("selected/name"), var0_14.tag_icon[1])
													setActive(arg2_14:Find("icon"), var0_14.tag_icon[3])

													if var0_14.tag_icon[3] then
														LoadImageSpriteAsync(var0_14.tag_icon[3], arg2_14:Find("icon"), false)
													end

													local var1_14 = arg0_9.shopAgency:GetShopById(var0_14.id):IsInTime()

													setActive(arg2_14:Find("lock"), not var1_14)
													setActive(arg2_14:Find("selected/lock"), not var1_14)
													onToggle(arg0_9, arg2_14, function(arg0_15)
														if arg0_15 then
															for iter0_15 = 0, arg0_9.shop3.childCount - 1 do
																setActive(arg0_9.shop3:GetChild(iter0_15):Find("selected"), false)
															end

															setActive(arg2_14:Find("selected"), true)
															arg2_14:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop3List_Selected")

															arg0_9.showingShop = arg0_9.shopAgency:GetShopById(var0_14.id)

															arg0_9:DoUpdateShowingShop()
														end
													end, SFX_PANEL)

													if arg0_9.showingShop.id == var0_14.id then
														triggerToggle(arg2_14, true)
													end

													if arg1_14 == 0 then
														local var2_14 = {}

														for iter0_14, iter1_14 in ipairs(var0_13) do
															table.insert(var2_14, iter1_14.id)
														end

														if not table.contains(var2_14, arg0_9.showingShop.id) then
															triggerToggle(arg2_14, true)
														end
													end
												end
											end, SFX_PANEL)
											arg0_9.shop3List:align(#var0_13)
											arg0_9.shop3List2:make(function(arg0_16, arg1_16, arg2_16)
												if arg0_16 == UIItemList.EventUpdate then
													local var0_16 = var0_13[arg1_16 + 1]

													setActive(arg2_16:Find("selected"), arg0_9.showingShop.id == var0_16.id)
													setText(arg2_16:Find("name"), var0_16.tag_icon[1])
													setText(arg2_16:Find("selected/name"), var0_16.tag_icon[1])
													setActive(arg2_16:Find("icon"), var0_16.tag_icon[3])

													if var0_16.tag_icon[3] then
														LoadImageSpriteAsync(var0_16.tag_icon[3], arg2_16:Find("icon"), false)
													end

													local var1_16 = arg0_9.shopAgency:GetShopById(var0_16.id):IsInTime()

													setActive(arg2_16:Find("lock"), not var1_16)
													setActive(arg2_16:Find("selected/lock"), not var1_16)
													onToggle(arg0_9, arg2_16, function(arg0_17)
														if arg0_17 then
															for iter0_17 = 0, arg0_9.shop32.childCount - 1 do
																setActive(arg0_9.shop32:GetChild(iter0_17):Find("selected"), false)
															end

															setActive(arg2_16:Find("selected"), true)

															arg0_9.showingShop = arg0_9.shopAgency:GetShopById(var0_16.id)

															arg0_9:DoUpdateShowingShop()
														end
													end, SFX_PANEL)

													if arg0_9.showingShop.id == var0_16.id then
														triggerToggle(arg2_16, true)
													end

													if arg1_16 == 0 then
														local var2_16 = {}

														for iter0_16, iter1_16 in ipairs(var0_13) do
															table.insert(var2_16, iter1_16.id)
														end

														if not table.contains(var2_16, arg0_9.showingShop.id) then
															triggerToggle(arg2_16, true)
														end
													end
												end
											end, SFX_PANEL)
											arg0_9.shop3List2:align(#var0_13)
										else
											arg0_9.showingShop = arg0_9.shopAgency:GetShopById(var0_12.id)

											arg0_9:DoUpdateShowingShop()
										end
									end
								end, SFX_PANEL)

								if arg0_9.showingShop.id == var0_12.id or arg0_9.showingShop:GetSecondShopId() == var0_12.id then
									triggerToggle(arg2_12, true)
								end

								if arg1_12 == 0 then
									local var1_12 = {}

									for iter0_12, iter1_12 in ipairs(var0_11) do
										table.insert(var1_12, iter1_12.id)
									end

									if arg0_9.showingShop:GetTagType() == 2 and not table.contains(var1_12, arg0_9.showingShop.id) or arg0_9.showingShop:GetTagType() == 3 and not table.contains(var1_12, arg0_9.showingShop:GetSecondShopId()) then
										triggerToggle(arg2_12, true)
									end
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

function var0_0.SetShopPage(arg0_18)
	local var0_18 = arg0_18.showingShop:GetShowType()

	setText(arg0_18:findTF("Text", arg0_18.title), arg0_18.showingShop:GetShopIcon()[1])
	setText(arg0_18:findTF("Text/en", arg0_18.title), arg0_18.showingShop:GetShopIcon()[2])
	arg0_18:SetResources()
	setActive(arg0_18.recommendationPage, var0_18 == IslandConst.SHOP_TYPE_RECOMMENDATION)
	setActive(arg0_18.shop2DPage, var0_18 == IslandConst.SHOP_TYPE_2D)
	setActive(arg0_18.shop3DPage, var0_18 == IslandConst.SHOP_TYPE_3D)
	setActive(arg0_18.shopFurniturePage, var0_18 == IslandConst.SHOP_TYPE_FURNITURE)
	setActive(arg0_18.shopSkinPage, var0_18 == IslandConst.SHOP_TYPE_SKIN)
	switch(var0_18, {
		[IslandConst.SHOP_TYPE_RECOMMENDATION] = function()
			arg0_18:ShowRecommendation()
		end,
		[IslandConst.SHOP_TYPE_2D] = function()
			arg0_18:ShowShop2D()
		end,
		[IslandConst.SHOP_TYPE_3D] = function()
			arg0_18:ShowShop3D()
		end,
		[IslandConst.SHOP_TYPE_FURNITURE] = function()
			arg0_18:ShowShopFurniture()
		end,
		[IslandConst.SHOP_TYPE_SKIN] = function()
			arg0_18:ShowShopSkin()
		end
	})
end

function var0_0.SetResources(arg0_24)
	arg0_24.player = getProxy(PlayerProxy):getRawData()

	local var0_24 = arg0_24.showingShop:GetTopResources()

	arg0_24.resourceList:make(function(arg0_25, arg1_25, arg2_25)
		if arg0_25 == UIItemList.EventUpdate then
			local var0_25 = var0_24[arg1_25 + 1]
			local var1_25 = var0_25[1]
			local var2_25 = var0_25[2]

			setActive(arg2_25:Find("gold"), false)
			setActive(arg2_25:Find("oil"), false)
			setActive(arg2_25:Find("gem"), false)
			setActive(arg2_25:Find("islandItem"), false)

			if var1_25 == DROP_TYPE_RESOURCE then
				if var2_25 == 1 then
					setActive(arg2_25:Find("gold"), true)

					local var3_25 = arg0_24.player:getLevelMaxGold()

					setText(arg2_25:Find("gold/max"), "MAX: " .. var3_25)
					setText(arg2_25:Find("gold/Text"), arg0_24.player.gold)
				elseif var2_25 == 4 or var2_25 == 14 then
					setActive(arg2_25:Find("gem"), true)
					setText(arg2_25:Find("gem/Text"), arg0_24.player:getTotalGem())
				end
			elseif var1_25 == DROP_TYPE_ISLAND_ITEM then
				setActive(arg2_25:Find("islandItem"), true)
				setText(arg2_25:Find("islandItem/Text"), arg0_24.inventoryAgency:GetOwnCount(var2_25))
				GetImageSpriteFromAtlasAsync(Drop.New({
					type = DROP_TYPE_ISLAND_ITEM,
					id = var2_25
				}):getIcon(), "", arg2_25:Find("islandItem/icon"))
			end
		end
	end)
	arg0_24.resourceList:align(#var0_24)
end

function var0_0.SetCloseAndRefresh(arg0_26, arg1_26)
	local var0_26 = 0

	if arg0_26.showingShop:IsNormalShop() then
		local var1_26 = arg0_26.showingShop:GetExistTime()

		if type(var1_26) == "table" then
			local var2_26 = var1_26[2]

			var0_26 = pg.TimeMgr.GetInstance():Table2ServerTime({
				year = var2_26[1][1],
				month = var2_26[1][2],
				day = var2_26[1][3],
				hour = var2_26[2][1],
				min = var2_26[2][2],
				sec = var2_26[2][3]
			})
		end
	elseif arg0_26.showingShop:IsTemporaryShop() then
		var0_26 = arg0_26.showingShop.existTime
	end

	local var3_26 = arg0_26.showingShop.refreshTime
	local var4_26 = arg0_26.showingShop:GetPlayerRefreshResource()

	setActive(arg0_26:findTF("remainAndRefresh/remainTimer", arg1_26), var0_26 ~= 0)
	setActive(arg0_26:findTF("remainAndRefresh/refresh", arg1_26), var3_26 ~= 0)
	setActive(arg0_26:findTF("remainAndRefresh/refresh/refreshBtn", arg1_26), var4_26)
	setActive(arg0_26:findTF("remainAndRefresh", arg1_26), isActive(arg0_26:findTF("remainAndRefresh/remainTimer", arg1_26)) or isActive(arg0_26:findTF("remainAndRefresh/refresh", arg1_26)))

	local var5_26 = pg.TimeMgr.GetInstance():GetTimeToNextTime()

	if arg0_26.timer then
		arg0_26.timer:Stop()

		arg0_26.timer = nil
	end

	arg0_26.timer = Timer.New(function()
		local var0_27 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_26 ~= 0 then
			local var1_27 = pg.TimeMgr.GetInstance():DescCDTime(var0_26 - var0_27)

			setText(arg0_26:findTF("remainAndRefresh/remainTimer", arg1_26), "商店剩余" .. var1_27 .. "关闭")
		elseif normalShopExistTime and type(normalShopExistTime) == "table" then
			-- block empty
		end

		if var3_26 ~= 0 then
			local var2_27 = pg.TimeMgr.GetInstance():DescCDTime(var3_26 - var0_27)

			setText(arg0_26:findTF("remainAndRefresh/refresh/refreshTimer", arg1_26), var2_27 .. "后刷新")

			if var0_27 > var3_26 then
				arg0_26:DoUpdateShowingShop()
			end
		end

		if var3_26 == 0 and var4_26 and var0_27 > var5_26 then
			arg0_26:DoUpdateShowingShop()
		end
	end, 1, -1)

	arg0_26.timer:Start()

	if var4_26 then
		onButton(arg0_26, arg0_26:findTF("remainAndRefresh/refresh/refreshBtn/button", arg1_26), function()
			local var0_28 = arg0_26.showingShop.refreshCount

			if var0_28 < arg0_26.showingShop:GetMaxRefreshCount() then
				local var1_28 = arg0_26.showingShop:GetFirstRefreshFree()
				local var2_28 = var4_26[3]

				if var1_28 and var0_28 == 0 then
					var4_26[3] = 0
					var2_28 = 0
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					noText = "text_cancel",
					hideNo = false,
					yesText = "text_confirm",
					content = i18n("refresh_shopStreet_question", i18n("word_" .. id2res(var4_26[2]) .. "_icon"), var2_28, var0_28),
					onYes = function()
						arg0_26:emit(IslandMediator.REFRESH_SHOP_BY_PLAYER, arg0_26.showingShop.id, var4_26)
					end
				})
			else
				pg.TipsMgr.GetInstance():ShowTips("刷新次数到上限啦哥们")
			end
		end, SFX_PANEL)
	end
end

function var0_0.SetCommodity(arg0_30, arg1_30, arg2_30)
	local var0_30 = arg2_30:GetMaxNum() - arg2_30.purchasedNum

	setText(arg1_30:Find("name"), arg2_30:GetName())

	if #arg2_30:GetItems() == 1 and arg2_30:GetItems()[1][1] ~= DROP_TYPE_ISLAND_FURNITURE and arg2_30:GetItems()[1][1] ~= DROP_TYPE_ISLAND_DRESS and arg2_30:GetItems()[1][1] ~= DROP_TYPE_ISLAND_SKIN then
		local var1_30 = arg2_30:GetItems()[1]
		local var2_30 = {
			type = var1_30[1],
			id = var1_30[2],
			count = var1_30[3]
		}

		updateCustomDrop(arg1_30:Find("IslandItemTpl"), var2_30)
	else
		GetImageSpriteFromAtlasAsync(arg2_30:GetIcon(), "", arg1_30:Find("IslandItemTpl/icon_bg/icon"))
	end

	setActive(arg1_30:Find("IslandItemTpl/icon_bg/count_bg"), arg2_30:IsShowPurchaseLimit())
	setText(arg1_30:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_30 .. "/" .. arg2_30:GetMaxNum())

	local var3_30 = arg2_30:GetResourceConsume()

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = var3_30[1],
		id = var3_30[2]
	}):getIcon(), "", arg1_30:Find("cost/icon"))
	setText(arg1_30:Find("cost/num"), math.ceil((100 - arg2_30:GetDiscount()) / 100 * var3_30[3]))
	setActive(arg1_30:Find("sellOut"), arg2_30:GetMaxNum() ~= 0 and var0_30 == 0)
	setActive(arg1_30:Find("timeLimit"), arg2_30:IsTimeLimitCommodity())
	setActive(arg1_30:Find("discount"), arg2_30:GetDiscount() ~= 0)
	setText(arg1_30:Find("discount/Text"), "-" .. arg2_30:GetDiscount() .. "%")

	local var4_30 = false

	for iter0_30, iter1_30 in ipairs(arg0_30.shoppingCartCommodities) do
		if iter1_30.id == arg2_30.id then
			var4_30 = true

			break
		end
	end

	setActive(arg1_30:Find("select"), var4_30)

	local var5_30 = arg2_30:GetItems()[1][1]
	local var6_30 = arg2_30:GetItems()[1][2]
	local var7_30 = 0

	if var5_30 == DROP_TYPE_ISLAND_ITEM then
		var7_30 = arg0_30.inventoryAgency:GetOwnCount(var6_30)
	elseif var5_30 == DROP_TYPE_ISLAND_FURNITURE then
		local var8_30 = getProxy(IslandProxy):GetIsland():GetAgoraAgency():GetFurnitures()

		for iter2_30, iter3_30 in ipairs(var8_30) do
			if iter3_30.id == var6_30 then
				var7_30 = iter3_30.count

				break
			end
		end
	elseif var5_30 == DROP_TYPE_ISLAND_DRESS then
		if pg.island_dress_template[var6_30].belongto == 1 then
			var7_30 = getProxy(IslandProxy):GetIsland():GetDressUpAgency():CheckOwnDress(var6_30) and 1 or 0
		elseif pg.island_dress_template[var6_30].belongto == 2 then
			var7_30 = arg0_30.characterAgency:GetOwnDressCountByDressId(var6_30)
		end
	elseif var5_30 == DROP_TYPE_ISLAND_SKIN then
		var7_30 = arg0_30.characterAgency:CheckSkinIsOwned(var6_30) and 1 or 0
	end

	setActive(arg1_30:Find("have"), arg2_30:IsShowHave())
	setText(arg1_30:Find("have"), "持有：" .. var7_30)
	setActive(arg1_30:Find("hold"), arg2_30:IsShowHold() and (var7_30 > 0 or arg2_30:IsCharacterInviteItemHold()))
	setActive(arg1_30:Find("cost"), not isActive(arg1_30:Find("sellOut")) and not isActive(arg1_30:Find("hold")))
	setActive(arg1_30:Find("notInTime"), not arg0_30.showingShop:IsInTime())

	if isActive(arg1_30:Find("sellOut")) or isActive(arg1_30:Find("hold")) or isActive(arg1_30:Find("notInTime")) then
		removeOnButton(arg1_30)
	else
		onButton(arg0_30, arg1_30, function()
			switch(arg2_30:GetCommodityShowType(), {
				[IslandConst.COMMODITY_SHOW_ITEM] = function()
					arg0_30.myIslandShopItemLayer = arg0_30:OpenPage(IslandShopItemLayer, arg0_30.showingShop.id, arg2_30)
				end,
				[IslandConst.COMMODITY_SHOW_DRESS] = function()
					if #arg2_30:GetItems() > 1 then
						arg0_30.shoppingCartCommodities = {
							arg2_30
						}

						arg0_30.islandShipDressHelper:ResetDressUp()
					else
						if #arg0_30.shoppingCartCommodities > 0 and #arg0_30.shoppingCartCommodities[1]:GetItems() > 1 then
							arg0_30.shoppingCartCommodities = {}
						end

						local var0_33 = 0

						for iter0_33, iter1_33 in ipairs(arg0_30.shoppingCartCommodities) do
							if iter1_33:GetDressType() == arg2_30:GetDressType() then
								var0_33 = iter1_33.id

								table.remove(arg0_30.shoppingCartCommodities, iter0_33)

								break
							end
						end

						if arg2_30.id == var0_33 then
							arg0_30.islandShipDressHelper:ChangeDressByType(arg2_30:GetDressType(), 0)
						else
							table.insert(arg0_30.shoppingCartCommodities, arg2_30)
							arg0_30.islandShipDressHelper:ChangeDressByType(arg2_30:GetDressType(), arg2_30:GetItems()[1][2])
						end
					end

					setActive(arg0_30.shopSkinPage:Find("cancelBtn"), #arg0_30.shoppingCartCommodities > 0)
					setActive(arg0_30.shopSkinPage:Find("shoppingCartBtn"), #arg0_30.shoppingCartCommodities > 0)
					setActive(arg0_30.shopSkinPage:Find("shoppingCartBtn/count"), true)
					setText(arg0_30.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_30.shoppingCartCommodities .. "/3")

					if #arg0_30.shoppingCartCommodities > 0 then
						onButton(arg0_30, arg0_30.shopSkinPage:Find("cancelBtn"), function()
							arg0_30.shoppingCartCommodities = {}

							arg0_30.islandShipDressHelper:ResetDressUp()
							setActive(arg0_30.shopSkinPage:Find("cancelBtn"), false)
							setActive(arg0_30.shopSkinPage:Find("shoppingCartBtn"), false)
							setText(arg0_30.shopSkinPage:Find("shoppingCartBtn/count"), "0/3")
							arg0_30:SetCommodityList()
						end, SFX_PANEL)
						onButton(arg0_30, arg0_30.shopSkinPage:Find("shoppingCartBtn"), function()
							arg0_30.myIslandShoppingCartLayer = arg0_30:OpenPage(IslandShoppingCartLayer, arg0_30.shoppingCartCommodities)
						end, SFX_PANEL)
					end

					arg0_30:SetCommodityList()
				end,
				[IslandConst.COMMODITY_SHOW_FURNITURE] = function()
					if arg0_30.showingCommodity ~= arg2_30 then
						arg0_30.showingCommodity = arg2_30
						arg0_30.shoppingCartCommodities = {
							arg2_30
						}

						arg0_30:LoadFurniture(arg2_30:GetModel(), arg2_30:GetModelParam())
						setActive(arg0_30.shopFurniturePage:Find("scenePreviewBtn"), false)
						setActive(arg0_30.shopFurniturePage:Find("shoppingCartBtn"), true)

						if #arg2_30:GetItems() == 1 then
							onButton(arg0_30, arg0_30.shopFurniturePage:Find("scenePreviewBtn"), function()
								setActive(arg0_30._tf, false)
								arg0_30:ClearCharacterScene()
								arg0_30:emit(IslandMediator.PREVIEW_FURNITURE, arg2_30:GetItems()[1][2])
							end, SFX_PANEL)
						end

						onButton(arg0_30, arg0_30.shopFurniturePage:Find("shoppingCartBtn"), function()
							arg0_30.myIslandShoppingCartLayer = arg0_30:OpenPage(IslandShoppingCartLayer, arg0_30.shoppingCartCommodities)
						end, SFX_PANEL)
					else
						arg0_30.showingCommodity = nil
						arg0_30.shoppingCartCommodities = {}

						arg0_30:UnloadCharacter()
						setActive(arg0_30.shopFurniturePage:Find("scenePreviewBtn"), false)
						setActive(arg0_30.shopFurniturePage:Find("shoppingCartBtn"), false)
					end

					arg0_30:SetCommodityList()
				end,
				[IslandConst.COMMODITY_SHOW_SKIN] = function()
					if arg0_30.showingCommodity ~= arg2_30 then
						arg0_30.showingCommodity = arg2_30
						arg0_30.shoppingCartCommodities = {
							arg2_30
						}

						local var0_39 = pg.island_skin_template[arg2_30:GetItems()[1][2]].model
						local var1_39 = pg.island_unit_character[var0_39]

						arg0_30:LoadCharacter(var1_39)
					else
						arg0_30.showingCommodity = nil
						arg0_30.shoppingCartCommodities = {}

						local var2_39 = arg0_30.characterAgency:GetShipById(arg0_30.showingShipId):GetModel()

						arg0_30:LoadCharacter(var2_39)
					end

					setActive(arg0_30.shopSkinPage:Find("cancelBtn"), #arg0_30.shoppingCartCommodities > 0)
					setActive(arg0_30.shopSkinPage:Find("shoppingCartBtn"), #arg0_30.shoppingCartCommodities > 0)
					setActive(arg0_30.shopSkinPage:Find("shoppingCartBtn/count"), false)
					setText(arg0_30.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_30.shoppingCartCommodities .. "/3")

					if #arg0_30.shoppingCartCommodities > 0 then
						onButton(arg0_30, arg0_30.shopSkinPage:Find("cancelBtn"), function()
							arg0_30.shoppingCartCommodities = {}

							local var0_40 = arg0_30.characterAgency:GetShipById(arg0_30.showingShipId):GetModel()

							arg0_30:LoadCharacter(var0_40)
							setActive(arg0_30.shopSkinPage:Find("cancelBtn"), false)
							setActive(arg0_30.shopSkinPage:Find("shoppingCartBtn"), false)
							setText(arg0_30.shopSkinPage:Find("shoppingCartBtn/count"), "0/3")
							arg0_30:SetCommodityList()
						end, SFX_PANEL)
						onButton(arg0_30, arg0_30.shopSkinPage:Find("shoppingCartBtn"), function()
							arg0_30.myIslandShoppingCartLayer = arg0_30:OpenPage(IslandShoppingCartLayer, arg0_30.shoppingCartCommodities)
						end, SFX_PANEL)
					end

					arg0_30:SetCommodityList()
				end
			})
		end, SFX_PANEL)
	end
end

function var0_0.SetCommodityList(arg0_42)
	local var0_42 = arg0_42.showingShop:GetShowType()
	local var1_42 = switch(var0_42, {
		[IslandConst.SHOP_TYPE_2D] = function()
			return UIItemList.New(arg0_42:findTF("shopView/Viewport/Content", arg0_42.shop2DPage), arg0_42:findTF("shopView/Viewport/Content/IslandCommodityTpl", arg0_42.shop2DPage))
		end,
		[IslandConst.SHOP_TYPE_3D] = function()
			return UIItemList.New(arg0_42:findTF("shopView/Viewport/Content", arg0_42.shop3DPage), arg0_42:findTF("shopView/Viewport/Content/IslandCommodityTpl", arg0_42.shop3DPage))
		end,
		[IslandConst.SHOP_TYPE_FURNITURE] = function()
			return UIItemList.New(arg0_42:findTF("shopView/Viewport/Content", arg0_42.shopFurniturePage), arg0_42:findTF("shopView/Viewport/Content/IslandCommodityTpl", arg0_42.shopFurniturePage))
		end,
		[IslandConst.SHOP_TYPE_SKIN] = function()
			return UIItemList.New(arg0_42:findTF("shopView/Viewport/Content", arg0_42.shopSkinPage), arg0_42:findTF("shopView/Viewport/Content/IslandCommodityTpl", arg0_42.shopSkinPage))
		end
	})
	local var2_42 = arg0_42.showingShop:GetCommodities()

	var1_42:make(function(arg0_47, arg1_47, arg2_47)
		if arg0_47 == UIItemList.EventUpdate then
			local var0_47 = var2_42[arg1_47 + 1]

			arg0_42:SetCommodity(arg2_47, var0_47)
		end
	end, SFX_PANEL)
	var1_42:align(#var2_42)
end

function var0_0.ShowRecommendation(arg0_48)
	arg0_48:ClearCharacterScene()
	pg.UIMgr.GetInstance():ShutdownPartialBlur({
		arg0_48.bg,
		arg0_48.shop3DPage:Find("bg"),
		arg0_48.shopFurniturePage:Find("bg"),
		arg0_48.shopSkinPage:Find("bg"),
		arg0_48.changeCharaPanel
	})
	pg.UIMgr.GetInstance():PartialBlurTfs({
		arg0_48.bg
	})
	setActive(arg0_48.bgColor, true)

	arg0_48.shoppingCartCommodities = {}

	local var0_48 = arg0_48.showingShop:GetBanners()
	local var1_48 = arg0_48:findTF("banners", arg0_48.recommendationPage)

	for iter0_48 = 1, #var0_48 do
		local var2_48 = var0_48[iter0_48]
		local var3_48 = var1_48:GetChild(iter0_48 - 1)

		GetImageSpriteFromAtlasAsync("activitybanner/" .. var2_48.pic, "", var3_48)
		onButton(arg0_48, var3_48, function()
			local var0_49 = arg0_48.shopAgency:GetShopById(var2_48.param)

			if var0_49 then
				arg0_48.showingShop = var0_49

				if arg0_48.showingShop:IsInTime() then
					arg0_48:emit(IslandMediator.GET_SHOP_DATA, arg0_48.showingShop.id, true)
				else
					arg0_48:UpdateData()
					arg0_48:SetShopList()
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.ShowShop2D(arg0_50)
	arg0_50:ClearCharacterScene()
	pg.UIMgr.GetInstance():ShutdownPartialBlur({
		arg0_50.bg,
		arg0_50.shop3DPage:Find("bg"),
		arg0_50.shopFurniturePage:Find("bg"),
		arg0_50.shopSkinPage:Find("bg"),
		arg0_50.changeCharaPanel
	})
	pg.UIMgr.GetInstance():PartialBlurTfs({
		arg0_50.bg
	})
	setActive(arg0_50.bgColor, true)

	arg0_50.shoppingCartCommodities = {}

	local var0_50 = arg0_50.showingShop:IsInTime()

	setActive(arg0_50:findTF("lock", arg0_50.shop2DPage), not var0_50)

	if var0_50 then
		arg0_50:SetCloseAndRefresh(arg0_50.shop2DPage)
	else
		setActive(arg0_50:findTF("remainAndRefresh", arg0_50.shop2DPage), false)

		if arg0_50.timer then
			arg0_50.timer:Stop()

			arg0_50.timer = nil
		end

		arg0_50.timer = Timer.New(function()
			local var0_51 = arg0_50.showingShop:GetExistTime()[1]
			local var1_51 = pg.TimeMgr.GetInstance():Table2ServerTime({
				year = var0_51[1][1],
				month = var0_51[1][2],
				day = var0_51[1][3],
				hour = var0_51[2][1],
				min = var0_51[2][2],
				sec = var0_51[2][3]
			})
			local var2_51 = pg.TimeMgr.GetInstance():GetServerTime()
			local var3_51 = pg.TimeMgr.GetInstance():DescCDTime(var1_51 - var2_51)

			setText(arg0_50.shop2DPage:Find("lock/openTimer"), "剩余" .. var3_51 .. "解锁")
		end, 1, -1)

		arg0_50.timer:Start()
	end

	arg0_50:SetCommodityList()
end

function var0_0.ShowShop3D(arg0_52)
	arg0_52:ClearCharacterScene()
	pg.UIMgr.GetInstance():ShutdownPartialBlur({
		arg0_52.bg,
		arg0_52.shop3DPage:Find("bg"),
		arg0_52.shopFurniturePage:Find("bg"),
		arg0_52.shopSkinPage:Find("bg"),
		arg0_52.changeCharaPanel
	})
	pg.UIMgr.GetInstance():PartialBlurTfs({
		arg0_52.shop3DPage:Find("bg")
	})
	setActive(arg0_52.bgColor, false)

	arg0_52.shoppingCartCommodities = {}

	arg0_52:SetCloseAndRefresh(arg0_52.shop3DPage)
	arg0_52:SetCommodityList()
end

function var0_0.ShowShopFurniture(arg0_53)
	if not arg0_53.isLoadCharacterScene then
		arg0_53:PrepareCharacterScene()
	end

	pg.UIMgr.GetInstance():ShutdownPartialBlur({
		arg0_53.bg,
		arg0_53.shop3DPage:Find("bg"),
		arg0_53.shopFurniturePage:Find("bg"),
		arg0_53.shopSkinPage:Find("bg"),
		arg0_53.changeCharaPanel
	})
	pg.UIMgr.GetInstance():PartialBlurTfs({
		arg0_53.shopFurniturePage:Find("bg")
	})
	setActive(arg0_53.bgColor, false)
	arg0_53:UnloadCharacter()

	arg0_53.shoppingCartCommodities = {}

	arg0_53:SetCloseAndRefresh(arg0_53.shopFurniturePage)
	arg0_53:SetCommodityList()
	setActive(arg0_53.shopFurniturePage:Find("scenePreviewBtn"), false)
	setActive(arg0_53.shopFurniturePage:Find("shoppingCartBtn"), false)
end

function var0_0.ShowShopSkin(arg0_54)
	if not arg0_54.isLoadCharacterScene then
		arg0_54:PrepareCharacterScene()
	end

	pg.UIMgr.GetInstance():ShutdownPartialBlur({
		arg0_54.bg,
		arg0_54.shop3DPage:Find("bg"),
		arg0_54.shopFurniturePage:Find("bg"),
		arg0_54.shopSkinPage:Find("bg"),
		arg0_54.changeCharaPanel
	})
	pg.UIMgr.GetInstance():PartialBlurTfs({
		arg0_54.shopSkinPage:Find("bg"),
		arg0_54.changeCharaPanel
	})
	setActive(arg0_54.bgColor, false)

	if not arg0_54.shoppingCartCommodities then
		arg0_54.shoppingCartCommodities = {}
	end

	if #arg0_54.shoppingCartCommodities > 0 then
		local var0_54 = arg0_54.shoppingCartCommodities[1]:GetCommodityShowType()

		if var0_54 == IslandConst.COMMODITY_SHOW_FURNITURE or var0_54 == IslandConst.COMMODITY_SHOW_SKIN then
			arg0_54.shoppingCartCommodities = {}
		end
	end

	local var1_54 = arg0_54.showingShop:GetCommanderOrCharaType()

	if var1_54 == 0 and (arg0_54.showingShipId ~= 0 or #arg0_54.shoppingCartCommodities == 0) then
		arg0_54.showingShipId = 0

		local var2_54 = getProxy(IslandProxy):GetIsland():GetDressUpAgency():GetCurCommderId()
		local var3_54 = pg.island_dress_commander[var2_54].model
		local var4_54 = pg.island_unit_character[var3_54]

		arg0_54:LoadCharacter(var4_54)

		arg0_54.shoppingCartCommodities = {}
	elseif var1_54 == 1 and (arg0_54.showingShipId ~= arg0_54.selectShipId or #arg0_54.shoppingCartCommodities == 0) then
		arg0_54.showingShipId = arg0_54.selectShipId

		local var5_54 = arg0_54.characterAgency:GetShipById(arg0_54.showingShipId):GetModel()

		arg0_54:LoadCharacter(var5_54)

		arg0_54.shoppingCartCommodities = {}
	end

	arg0_54:SetCloseAndRefresh(arg0_54.shopSkinPage)
	arg0_54:SetCommodityList()
	setActive(arg0_54.shopSkinPage:Find("cancelBtn"), #arg0_54.shoppingCartCommodities > 0)
	setActive(arg0_54.shopSkinPage:Find("changeCharaBtn"), var1_54 == 1)
	setActive(arg0_54.shopSkinPage:Find("shoppingCartBtn"), #arg0_54.shoppingCartCommodities > 0)
	setActive(arg0_54.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_54.shoppingCartCommodities > 0 and arg0_54.shoppingCartCommodities[1]:GetItems()[1][1] ~= DROP_TYPE_ISLAND_SKIN)
	setText(arg0_54.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_54.shoppingCartCommodities .. "/3")
	setActive(arg0_54.shopSkinPage:Find("changeCharaPanel"), false)
	arg0_54:SetChangeCharaPanel()
	onButton(arg0_54, arg0_54.shopSkinPage:Find("changeCharaBtn"), function()
		setActive(arg0_54.shopSkinPage:Find("changeCharaPanel"), true)
	end, SFX_PANEL)
end

function var0_0.SetChangeCharaPanel(arg0_56)
	onButton(arg0_56, arg0_56.shopSkinPage:Find("changeCharaPanel/bg"), function()
		setActive(arg0_56.shopSkinPage:Find("changeCharaPanel"), false)
	end, SFX_PANEL)
	onButton(arg0_56, arg0_56.changeCharaPanel:Find("closeBtn"), function()
		setActive(arg0_56.shopSkinPage:Find("changeCharaPanel"), false)
	end, SFX_PANEL)

	local var0_56 = UIItemList.New(arg0_56.changeCharaPanel:Find("charaScroll/Viewport/Content"), arg0_56.changeCharaPanel:Find("charaScroll/Viewport/Content/IslandShipTpl"))

	var0_56:make(function(arg0_59, arg1_59, arg2_59)
		if arg0_59 == UIItemList.EventUpdate then
			local var0_59 = arg0_56.ships[arg1_59 + 1]
			local var1_59 = IslandShip.StaticGetPrefab(var0_59.id)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_59, "", arg2_59:Find("mask/icon"))
			setText(arg2_59:Find("Text"), "Lv." .. var0_59:GetLevel())
			setActive(arg2_59:Find("add"), false)
			setActive(arg2_59:Find("select"), var0_59.id == arg0_56.selectShipId)
			onButton(arg0_56, arg2_59, function()
				if arg0_56.charaSetModel == var0_0.CharaSetModel.current then
					arg0_56.selectShipId = var0_59.id
					arg0_56.showingShipId = var0_59.id

					arg0_56:LoadCharacter(var0_59:GetModel())

					arg0_56.shoppingCartCommodities = {}

					setActive(arg0_56.shopSkinPage:Find("cancelBtn"), false)
					setActive(arg0_56.shopSkinPage:Find("shoppingCartBtn"), false)
					setText(arg0_56.shopSkinPage:Find("shoppingCartBtn/count"), "0/3")
					arg0_56:SetCommodityList()
				elseif arg0_56.charaSetModel == var0_0.CharaSetModel.default then
					arg0_56.defaultShipId = var0_59.id

					PlayerPrefs.SetInt("island_dressShop_defaultShipId_" .. arg0_56.player.id, var0_59.id)
				end

				for iter0_60 = 0, arg0_56.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
					setActive(arg0_56.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter0_60):Find("select"), iter0_60 == arg1_59)
				end
			end, SFX_PANEL)
		end
	end)
	var0_56:align(#arg0_56.ships)

	arg0_56.charaSetModel = var0_0.CharaSetModel.current

	onButton(arg0_56, arg0_56.changeCharaPanel:Find("defaultSet"), function()
		if arg0_56.charaSetModel == var0_0.CharaSetModel.current then
			arg0_56.charaSetModel = var0_0.CharaSetModel.default

			for iter0_61 = 0, arg0_56.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
				setActive(arg0_56.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter0_61):Find("select"), arg0_56.ships[iter0_61 + 1].id == arg0_56.defaultShipId)
			end
		elseif arg0_56.charaSetModel == var0_0.CharaSetModel.default then
			arg0_56.charaSetModel = var0_0.CharaSetModel.current

			for iter1_61 = 0, arg0_56.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
				setActive(arg0_56.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter1_61):Find("select"), arg0_56.ships[iter1_61 + 1].id == arg0_56.selectShipId)
			end
		end

		setActive(arg0_56.changeCharaPanel:Find("defaultSet/off"), arg0_56.charaSetModel == var0_0.CharaSetModel.current)
		setActive(arg0_56.changeCharaPanel:Find("defaultSet/on"), arg0_56.charaSetModel == var0_0.CharaSetModel.default)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_62)
	arg0_62:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_62.UpdateView)
	arg0_62:AddListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_62.OnSwitchMapByPoint)
end

function var0_0.RemoveListeners(arg0_63)
	arg0_63:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_63.UpdateView)
	arg0_63:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_63.OnSwitchMapByPoint)
end

function var0_0.UpdateView(arg0_64, arg1_64)
	if arg1_64.operation == IslandConst.SHOP_GET_DATA then
		if arg1_64.refreshAll then
			arg0_64:UpdateData()
			arg0_64:SetShopList()
		else
			arg0_64:SetShopPage()
		end
	elseif arg1_64.operation == IslandConst.SHOP_BUY_COMMODITY then
		arg0_64.shoppingCartCommodities = {}

		arg0_64:SetShopPage()

		if arg0_64.myIslandShoppingCartLayer then
			arg0_64.myIslandShoppingCartLayer:Hide()
		end

		arg0_64:OpenPage(IslandShopBuySuccessLayer, arg1_64.awards, arg1_64.ptAward, function()
			if arg0_64.showingShop:GetShowType() == IslandConst.SHOP_TYPE_SKIN then
				arg0_64:ShowMsgBox({
					content = "是否跳转装扮界面",
					type = IslandMsgBox.TYPE_COMMON,
					onYes = function()
						if arg0_64.showingShop:GetCommanderOrCharaType() == 0 then
							arg0_64:OpenScenePage(IslandShipIslandCommanderMainPage)
						elseif arg0_64.showingShop:GetCommanderOrCharaType() == 1 then
							arg0_64:OpenScenePage(IslandShipMainPage, 3)
						end

						arg0_64:Hide()
					end
				})
			end
		end)

		if arg0_64.myIslandShopItemLayer then
			arg0_64.myIslandShopItemLayer:Refresh()
		end
	elseif arg1_64.operation == IslandConst.REFRESH_SHOP_BY_PLAYER then
		arg0_64:SetShopPage()
	end
end

function var0_0.OnSwitchMapByPoint(arg0_67)
	setActive(arg0_67._tf, true)
	arg0_67:PrepareCharacterScene()
end

function var0_0.Preload(arg0_68, arg1_68)
	arg1_68()
end

function var0_0.GetSmoothRotateObject(arg0_69)
	return GetOrAddComponent(arg0_69._tf:Find("model"), typeof(SmoothRotateObject))
end

function var0_0.LoadFurniture(arg0_70, arg1_70, arg2_70)
	arg0_70:UnloadCharacter()

	if arg0_70.isLoadingModel then
		return
	end

	arg0_70.isLoadingModel = true

	ResourceMgr.Inst:getAssetAsync(arg1_70, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_71)
		arg0_70.role = Object.Instantiate(arg0_71)

		local var0_71 = arg0_70.role.name
		local var1_71 = GameObject.New(var0_71)

		setParent(arg0_70.role, var1_71.transform, false)

		arg0_70.role = var1_71
		arg0_70.isLoadingModel = false

		pg.ViewUtils.SetLayer(arg0_70.role.transform, Layer.Character3D)
		setParent(arg0_70.role, arg0_70.roleContainer)

		arg0_70.role.transform.localPosition = Vector3(arg2_70[1][1], arg2_70[1][2], 0)
		arg0_70.role.transform.localEulerAngles = Vector3(0, arg2_70[2], 0)
		arg0_70.role.transform.localScale = Vector3(arg2_70[3], arg2_70[3], arg2_70[3])

		local var2_71 = arg0_70:GetSmoothRotateObject()

		var2_71:SetUp(arg0_70.role.transform)

		var2_71.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int
	end), true, true)
end

function var0_0.LoadCharacter(arg0_72, arg1_72)
	arg0_72:UnloadCharacter()

	if arg0_72.isLoadingModel then
		return
	end

	arg0_72.isLoadingModel = true

	arg0_72.islandShipDressHelper:Reset()
	arg0_72.islandShipDressHelper:SetShipId(arg0_72.showingShipId)
	ResourceMgr.Inst:getAssetAsync(arg1_72.model, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_73)
		arg0_72.role = Object.Instantiate(arg0_73)

		local var0_73 = arg0_72.role.name
		local var1_73 = GameObject.New(var0_73)

		setParent(arg0_72.role, var1_73.transform, false)

		arg0_72.role = var1_73
		arg0_72.isLoadingModel = false

		pg.ViewUtils.SetLayer(arg0_72.role.transform, Layer.Character3D)
		setParent(arg0_72.role, arg0_72.roleContainer)

		arg0_72.role.transform.localPosition = Vector3(2.7, 0, 0)
		arg0_72.role.transform.localEulerAngles = Vector3(0, -155, 0)

		local var2_73 = LoadAny(arg1_72.animator, nil, typeof(RuntimeAnimatorController))

		GetOrAddComponent(arg0_72.role.transform:GetChild(0), typeof(Animator)).runtimeAnimatorController = var2_73

		local var3_73 = arg0_72:GetSmoothRotateObject()

		var3_73:SetUp(arg0_72.role.transform)

		var3_73.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int

		arg0_72.islandShipDressHelper:OnRoleLoaded(arg0_72.role.transform)
	end), true, true)
end

function var0_0.OnShow(arg0_74, arg1_74, arg2_74)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_74._tf, {
		groupName = "IslandShop"
	})

	arg0_74.showTypes = arg1_74
	arg0_74.firstShopIds = arg2_74

	arg0_74:DoUpdateShops()
	arg0_74:UpdateData()
	arg0_74:SetShopList()
end

function var0_0.OnHide(arg0_75)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_75._tf)

	if arg0_75.timer then
		arg0_75.timer:Stop()

		arg0_75.timer = nil
	end

	arg0_75.shoppingCartCommodities = {}

	arg0_75.islandShipDressHelper:Destory()
	arg0_75:UnloadCharacter()
end

return var0_0
