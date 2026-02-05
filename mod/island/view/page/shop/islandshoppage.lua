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
	arg0_2.closeBtn = arg0_2._tf:Find("adapt/top/closeBtn")
	arg0_2.helpBtn = arg0_2._tf:Find("adapt/top/helpBtn")
	arg0_2.title = arg0_2._tf:Find("adapt/top/title")
	arg0_2.resourceList = UIItemList.New(arg0_2._tf:Find("adapt/top/resources"), arg0_2._tf:Find("adapt/top/resources/resourceTpl"))
	arg0_2.shop1List = UIItemList.New(arg0_2._tf:Find("adapt/shop1List"), arg0_2._tf:Find("adapt/shop1List/shop1Tpl"))
	arg0_2.shop3 = arg0_2._tf:Find("adapt/shop3List")
	arg0_2.shop3List = UIItemList.New(arg0_2._tf:Find("adapt/shop3List"), arg0_2._tf:Find("adapt/shop3List/shop3Tpl"))
	arg0_2.shop32 = arg0_2._tf:Find("adapt/shop3List2")
	arg0_2.shop3List2 = UIItemList.New(arg0_2._tf:Find("adapt/shop3List2"), arg0_2._tf:Find("adapt/shop3List2/shop3Tpl"))
	arg0_2.recommendationPage = arg0_2._tf:Find("adapt/shopPage/recommendation")
	arg0_2.shop2DPage = arg0_2._tf:Find("adapt/shopPage/shop2D")
	arg0_2.shop3DPage = arg0_2._tf:Find("adapt/shopPage/shop3D")
	arg0_2.shopFurniturePage = arg0_2._tf:Find("adapt/shopPage/shopFurniture")
	arg0_2.shopSkinPage = arg0_2._tf:Find("adapt/shopPage/shopSkin")
	arg0_2.changeCharaPanel = arg0_2.shopSkinPage:Find("changeCharaPanel/panel")
	arg0_2.subPageContainer = arg0_2._tf:Find("adapt/subPageContainer")
	arg0_2.drawAwardPage = IslandShopDrawAwardPage.New(arg0_2.subPageContainer, arg0_2)

	setText(arg0_2.shopSkinPage:Find("changeCharaPanel/panel/title"), i18n("island_3Dshop_chara_choose"))
	setText(arg0_2.shopSkinPage:Find("changeCharaPanel/panel/setTxt"), i18n("island_3Dshop_chara_set"))
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
	onButton(arg0_3, arg0_3.helpBtn, function()
		arg0_3:ShowMsgBox({
			hideNo = true,
			type = IslandMsgBox.TYPE_COMMON,
			content = i18n("island_draw_help"),
			alignment = TextAnchor.MiddleLeft
		})
	end, SFX_PANEL)
	arg0_3:InitData()
end

function var0_0.InitData(arg0_6)
	arg0_6.shopAgency = getProxy(IslandProxy):GetIsland():GetShopAgency()
	arg0_6.inventoryAgency = getProxy(IslandProxy):GetIsland():GetInventoryAgency()
	arg0_6.characterAgency = getProxy(IslandProxy):GetIsland():GetCharacterAgency()
	arg0_6.player = getProxy(PlayerProxy):getRawData()
	arg0_6.ships = arg0_6.characterAgency:GetShips()
	arg0_6.defaultShipId = PlayerPrefs.GetInt("island_dressShop_defaultShipId_" .. arg0_6.player.id, 10703)
	arg0_6.islandShipDressHelper = IslandShipDressHelperNew.New()
end

function var0_0.DoUpdateShops(arg0_7)
	local var0_7 = arg0_7.shopAgency:GetNewOrOverdueShopIds()

	if #var0_7 > 0 then
		for iter0_7, iter1_7 in ipairs(var0_7) do
			arg0_7:emit(IslandMediator.GET_SHOP_DATA, iter1_7, true)
		end
	end

	arg0_7.showingShop = nil
	arg0_7.selectShipId = arg0_7.defaultShipId
end

function var0_0.DoUpdateShowingShop(arg0_8)
	if arg0_8.showingShop:IsInTime() then
		arg0_8:emit(IslandMediator.GET_SHOP_DATA, arg0_8.showingShop.id, false)
	else
		arg0_8:SetShopPage()
	end

	if isActive(arg0_8.shop3) or isActive(arg0_8.shop32) then
		local var0_8 = arg0_8.showingShop:GetShowType()

		setActive(arg0_8.shop3, var0_8 == IslandConst.SHOP_TYPE_RECOMMENDATION or var0_8 == IslandConst.SHOP_TYPE_2D)
		setActive(arg0_8.shop32, var0_8 == IslandConst.SHOP_TYPE_3D or var0_8 == IslandConst.SHOP_TYPE_FURNITURE or var0_8 == IslandConst.SHOP_TYPE_SKIN)
	end
end

function var0_0.UpdateData(arg0_9)
	arg0_9.firstShopConfigs = arg0_9.shopAgency:GetFirstShopConfigs(arg0_9.showTypes, arg0_9.firstShopIds)

	if not arg0_9.showingShop or not arg0_9.shopAgency:IsShowShop(arg0_9.showingShop.id) then
		arg0_9.showingShop = arg0_9.shopAgency:GetInitShowingShop(arg0_9.showTypes, arg0_9.firstShopIds)
	end
end

function var0_0.SetShopList(arg0_10)
	arg0_10.currentShop1TgIndex = nil
	arg0_10.currentShop2TgIndex = nil
	arg0_10.currentShop3TgIndex = nil

	arg0_10.shop1List:make(function(arg0_11, arg1_11, arg2_11)
		arg1_11 = arg1_11 + 1

		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg0_10.firstShopConfigs[arg1_11]

			if var0_11 then
				setActive(arg2_11:Find("shop2List"), false)
				GetImageSpriteFromAtlasAsync("island/islandshopicon", var0_11.tag_icon[3], arg2_11:Find("shop1Tg/selected/icon"), false)
				setText(arg2_11:Find("shop1Tg/name"), var0_11.tag_icon[1])
				setText(arg2_11:Find("shop1Tg/name/en"), var0_11.tag_icon[2])
				onToggle(arg0_10, arg2_11:Find("shop1Tg"), function(arg0_12)
					if arg0_12 then
						if arg0_10.currentShop1TgIndex == arg1_11 then
							return
						end

						setActive(arg0_10._tf:Find("adapt/shopPage"), true)

						if not IsNil(arg0_10.roleContainer) then
							setActive(arg0_10.roleContainer, true)
						end

						setActive(arg0_10.shop3, false)
						setActive(arg0_10.shop32, false)
						arg2_11:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop1List_Selected")
						setActive(arg2_11:Find("shop2List"), var0_11.shop_type == 0)

						if var0_11.shop_type == 0 then
							local var0_12 = arg0_10.shopAgency:GetSecondShopConfigs(arg0_10.showTypes, var0_11.id)
							local var1_12 = UIItemList.New(arg2_11:Find("shop2List"), arg2_11:Find("shop2List/shop2Tpl"))

							var1_12:make(function(arg0_13, arg1_13, arg2_13)
								if arg0_13 == UIItemList.EventUpdate then
									local var0_13 = var0_12[arg1_13 + 1]

									setActive(arg2_13:Find("selected"), arg0_10.showingShop.id == var0_13.id or arg0_10.showingShop:GetSecondShopId() == var0_13.id)
									setText(arg2_13:Find("name"), var0_13.tag_icon[1])
									setText(arg2_13:Find("selected/name"), var0_13.tag_icon[1])
									onToggle(arg0_10, arg2_13, function(arg0_14)
										if arg0_14 then
											if arg0_10.currentShop1TgIndex == arg1_11 and arg0_10.currentShop2TgIndex == arg1_13 + 1 then
												return
											end

											arg2_13:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop2List_Selected")
											setActive(arg0_10.shop3, var0_13.shop_type == 0)
											setActive(arg0_10.shop32, var0_13.shop_type == 0)

											if var0_13.shop_type == 0 then
												local var0_14 = arg0_10.shopAgency:GetThirdShopConfigs(arg0_10.showTypes, var0_13.id)

												arg0_10.shop3List:make(function(arg0_15, arg1_15, arg2_15)
													if arg0_15 == UIItemList.EventUpdate then
														local var0_15 = var0_14[arg1_15 + 1]

														setActive(arg2_15:Find("selected"), arg0_10.showingShop.id == var0_15.id)
														setText(arg2_15:Find("name"), var0_15.tag_icon[1])
														setText(arg2_15:Find("selected/name"), var0_15.tag_icon[1])
														setActive(arg2_15:Find("icon"), var0_15.tag_icon[3])

														if var0_15.tag_icon[3] then
															LoadImageSpriteAsync(var0_15.tag_icon[3], arg2_15:Find("icon"), false)
														end

														local var1_15 = arg0_10.shopAgency:GetShopById(var0_15.id):IsInTime()

														setActive(arg2_15:Find("lock"), not var1_15)
														setActive(arg2_15:Find("selected/lock"), not var1_15)
														onToggle(arg0_10, arg2_15, function(arg0_16)
															if arg0_16 then
																if arg0_10.currentShop1TgIndex == arg1_11 and arg0_10.currentShop2TgIndex == arg1_13 + 1 and arg0_10.currentShop3TgIndex == arg1_15 + 1 then
																	return
																end

																for iter0_16 = 0, arg0_10.shop3.childCount - 1 do
																	setActive(arg0_10.shop3:GetChild(iter0_16):Find("selected"), false)
																end

																setActive(arg2_15:Find("selected"), true)
																arg2_15:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop3List_Selected")

																arg0_10.showingShop = arg0_10.shopAgency:GetShopById(var0_15.id)

																arg0_10:DoUpdateShowingShop()

																arg0_10.currentShop3TgIndex = arg1_15 + 1
															end
														end, SFX_PANEL)

														if arg0_10.showingShop.id == var0_15.id then
															triggerToggle(arg2_15, true)
														end

														if arg1_15 == 0 then
															local var2_15 = {}

															for iter0_15, iter1_15 in ipairs(var0_14) do
																table.insert(var2_15, iter1_15.id)
															end

															if not table.contains(var2_15, arg0_10.showingShop.id) then
																triggerToggle(arg2_15, true)
															end
														end
													end
												end, SFX_PANEL)
												arg0_10.shop3List:align(#var0_14)
												arg0_10.shop3List2:make(function(arg0_17, arg1_17, arg2_17)
													if arg0_17 == UIItemList.EventUpdate then
														local var0_17 = var0_14[arg1_17 + 1]

														setActive(arg2_17:Find("selected"), arg0_10.showingShop.id == var0_17.id)
														setText(arg2_17:Find("name"), var0_17.tag_icon[1])
														setText(arg2_17:Find("selected/name"), var0_17.tag_icon[1])
														setActive(arg2_17:Find("icon"), var0_17.tag_icon[3])

														if var0_17.tag_icon[3] then
															LoadImageSpriteAsync(var0_17.tag_icon[3], arg2_17:Find("icon"), false)
														end

														local var1_17 = arg0_10.shopAgency:GetShopById(var0_17.id):IsInTime()

														setActive(arg2_17:Find("lock"), not var1_17)
														setActive(arg2_17:Find("selected/lock"), not var1_17)
														onToggle(arg0_10, arg2_17, function(arg0_18)
															if arg0_18 then
																if arg0_10.currentShop1TgIndex == arg1_11 and arg0_10.currentShop2TgIndex == arg1_13 + 1 and arg0_10.currentShop3TgIndex == arg1_17 + 1 then
																	return
																end

																for iter0_18 = 0, arg0_10.shop32.childCount - 1 do
																	setActive(arg0_10.shop32:GetChild(iter0_18):Find("selected"), false)
																end

																setActive(arg2_17:Find("selected"), true)

																arg0_10.showingShop = arg0_10.shopAgency:GetShopById(var0_17.id)

																arg0_10:DoUpdateShowingShop()

																arg0_10.currentShop3TgIndex = arg1_17 + 1
															end
														end, SFX_PANEL)

														if arg0_10.showingShop.id == var0_17.id then
															triggerToggle(arg2_17, true)
														end

														if arg1_17 == 0 then
															local var2_17 = {}

															for iter0_17, iter1_17 in ipairs(var0_14) do
																table.insert(var2_17, iter1_17.id)
															end

															if not table.contains(var2_17, arg0_10.showingShop.id) then
																triggerToggle(arg2_17, true)
															end
														end
													end
												end, SFX_PANEL)
												arg0_10.shop3List2:align(#var0_14)
											else
												arg0_10.showingShop = arg0_10.shopAgency:GetShopById(var0_13.id)

												arg0_10:DoUpdateShowingShop()
											end

											arg0_10.currentShop2TgIndex = arg1_13 + 1
										end
									end, SFX_PANEL)

									if arg0_10.showingShop.id == var0_13.id or arg0_10.showingShop:GetSecondShopId() == var0_13.id then
										triggerToggle(arg2_13, true)
									end

									if arg1_13 == 0 then
										local var1_13 = {}

										for iter0_13, iter1_13 in ipairs(var0_12) do
											table.insert(var1_13, iter1_13.id)
										end

										if not table.contains(var1_13, arg0_10.showingShop.id) and not table.contains(var1_13, arg0_10.showingShop:GetSecondShopId()) then
											triggerToggle(arg2_13, true)
										end
									end
								end
							end)
							var1_12:align(#var0_12)
						else
							arg0_10.showingShop = arg0_10.shopAgency:GetShopById(var0_11.id)

							arg0_10:DoUpdateShowingShop()
						end

						arg0_10.currentShop1TgIndex = arg1_11
					else
						setActive(arg2_11:Find("shop2List"), false)
					end
				end, SFX_PANEL)

				if arg0_10.showingShop.id == var0_11.id or arg0_10.showingShop:GetFirstShopId() == var0_11.id then
					triggerToggle(arg2_11:Find("shop1Tg"), true)
				end
			else
				setActive(arg2_11:Find("shop2List"), false)
				setText(arg2_11:Find("shop1Tg/name"), i18n("island_draw_tab"))
				setText(arg2_11:Find("shop1Tg/name/en"), i18n("island_draw_tab_en"))
				setActive(arg2_11:Find("shop1Tg/selected/icon"), false)
				onToggle(arg0_10, arg2_11:Find("shop1Tg"), function(arg0_19)
					if arg0_19 then
						if arg0_10.currentShop1TgIndex == arg1_11 then
							return
						end

						arg0_10.currentShop1TgIndex = arg1_11

						arg2_11:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop1List_Selected")
						setText(arg0_10.title:Find("Text"), i18n("island_draw_tab"))
						arg0_10:SetResources()
						setActive(arg0_10._tf:Find("adapt/shopPage"), false)

						if not IsNil(arg0_10.roleContainer) then
							setActive(arg0_10.roleContainer, false)
						end

						setActive(arg0_10.shop3, false)
						setActive(arg0_10.shop32, false)
						arg0_10.drawAwardPage:ActionInvoke("UpdateActivity", arg0_10.drawAwardActivity)
						arg0_10.drawAwardPage:ExecuteAction("Show")
					else
						arg0_10.drawAwardPage:ExecuteAction("Hide")
					end
				end, SFX_PANEL)
			end
		end
	end)
	arg0_10.shop1List:align(#arg0_10.firstShopConfigs + (arg0_10.showDrawAward and arg0_10.drawAwardActivity and 1 or 0))
end

function var0_0.SetShopPage(arg0_20)
	local var0_20 = arg0_20.showingShop:GetShowType()

	setText(arg0_20.title:Find("Text"), arg0_20.showingShop:GetShopIcon()[1])
	setText(arg0_20.title:Find("Text/en"), arg0_20.showingShop:GetShopIcon()[2])
	arg0_20:SetResources()
	setActive(arg0_20.recommendationPage, var0_20 == IslandConst.SHOP_TYPE_RECOMMENDATION)
	setActive(arg0_20.shop2DPage, var0_20 == IslandConst.SHOP_TYPE_2D)
	setActive(arg0_20.shop3DPage, var0_20 == IslandConst.SHOP_TYPE_3D)
	setActive(arg0_20.shopFurniturePage, var0_20 == IslandConst.SHOP_TYPE_FURNITURE)
	setActive(arg0_20.shopSkinPage, var0_20 == IslandConst.SHOP_TYPE_SKIN)
	switch(var0_20, {
		[IslandConst.SHOP_TYPE_RECOMMENDATION] = function()
			arg0_20:ShowRecommendation()
		end,
		[IslandConst.SHOP_TYPE_2D] = function()
			arg0_20:ShowShop2D()
		end,
		[IslandConst.SHOP_TYPE_3D] = function()
			arg0_20:ShowShop3D()
		end,
		[IslandConst.SHOP_TYPE_FURNITURE] = function()
			arg0_20:ShowShopFurniture()
		end,
		[IslandConst.SHOP_TYPE_SKIN] = function()
			arg0_20:ShowShopSkin()
		end
	})
end

function var0_0.SetResources(arg0_26)
	arg0_26.player = getProxy(PlayerProxy):getRawData()

	local var0_26 = not arg0_26.firstShopConfigs[arg0_26.currentShop1TgIndex]

	setActive(arg0_26.helpBtn, var0_26)

	if var0_26 then
		local var1_26 = {}

		table.insert(var1_26, Drop.New({
			type = DROP_TYPE_VITEM,
			id = arg0_26.drawAwardActivity:GetDrawConfig("cost_free")
		}))
		table.insert(var1_26, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond
		}))
		arg0_26.resourceList:make(function(arg0_27, arg1_27, arg2_27)
			arg1_27 = arg1_27 + 1

			if arg0_27 == UIItemList.EventUpdate then
				local var0_27 = var1_26[arg1_27]
				local var1_27

				eachChild(arg2_27, function(arg0_28, arg1_28)
					setActive(arg0_28, arg0_28.name == "islandItem")

					if arg0_28.name == "islandItem" then
						var1_27 = arg0_28
					end
				end)
				GetImageSpriteFromAtlasAsync(var0_27:getIcon(), "", var1_27:Find("icon"))
				setText(var1_27:Find("Text"), var0_27:getOwnedCount())
				setActive(var1_27:Find("add"), false)
				setActive(var1_27:Find("add"), false)
				setActive(var1_27:Find("descBtn"), false)
				setActive(var1_27:Find("resourceDesc"), false)
			end
		end)
		arg0_26.resourceList:align(#var1_26)

		return
	end

	local var2_26 = arg0_26.showingShop:GetTopResources()

	arg0_26.resourceList:make(function(arg0_29, arg1_29, arg2_29)
		if arg0_29 == UIItemList.EventUpdate then
			local var0_29 = var2_26[arg1_29 + 1]
			local var1_29 = var0_29[1]
			local var2_29 = var0_29[2]
			local var3_29 = var0_29[3]

			setActive(arg2_29:Find("gold"), false)
			setActive(arg2_29:Find("oil"), false)
			setActive(arg2_29:Find("gem"), false)
			setActive(arg2_29:Find("islandItem"), false)

			if var2_29 == DROP_TYPE_RESOURCE then
				if var3_29 == 1 then
					setActive(arg2_29:Find("gold"), true)

					local var4_29 = arg0_26.player:getLevelMaxGold()

					setText(arg2_29:Find("gold/max"), "MAX: " .. var4_29)
					setText(arg2_29:Find("gold/Text"), arg0_26.player.gold)
				elseif var3_29 == 4 or var3_29 == 14 then
					setActive(arg2_29:Find("gem"), true)
					setText(arg2_29:Find("gem/Text"), arg0_26.player:getTotalGem())
				end
			elseif var2_29 == DROP_TYPE_ISLAND_ITEM then
				setActive(arg2_29:Find("islandItem"), true)

				local var5_29 = arg0_26.inventoryAgency:GetOwnCount(var3_29)

				setText(arg2_29:Find("islandItem/Text"), var5_29)
				GetImageSpriteFromAtlasAsync(Drop.New({
					type = DROP_TYPE_ISLAND_ITEM,
					id = var3_29
				}):getIcon(), "", arg2_29:Find("islandItem/icon"))
				setActive(arg2_29:Find("islandItem/descBtn"), var1_29 == 1)
				setActive(arg2_29:Find("islandItem/resourceDesc"), false)

				if var1_29 == 1 then
					local var6_29 = pg.island_item_data_template[var3_29].have_max

					setText(arg2_29:Find("islandItem/Text"), var5_29 .. "/" .. var6_29)
					onButton(arg0_26, arg2_29:Find("islandItem"), function()
						setActive(arg2_29:Find("islandItem/resourceDesc"), not isActive(arg2_29:Find("islandItem/resourceDesc")))
						setText(arg2_29:Find("islandItem/resourceDesc"), i18n("island_3Dshop_res_have") .. var6_29)
					end, SFX_PANEL)
				end
			end
		end
	end)
	arg0_26.resourceList:align(#var2_26)
end

function var0_0.SetCloseAndRefresh(arg0_31, arg1_31)
	local var0_31 = 0

	if arg0_31.showingShop:IsNormalShop() then
		local var1_31 = arg0_31.showingShop:GetExistTime()

		if type(var1_31) == "table" then
			local var2_31 = var1_31[2]

			var0_31 = pg.TimeMgr.GetInstance():Table2ServerTime({
				year = var2_31[1][1],
				month = var2_31[1][2],
				day = var2_31[1][3],
				hour = var2_31[2][1],
				min = var2_31[2][2],
				sec = var2_31[2][3]
			})
		end
	elseif arg0_31.showingShop:IsTemporaryShop() then
		var0_31 = arg0_31.showingShop.existTime
	end

	local var3_31 = arg0_31.showingShop.refreshTime
	local var4_31 = arg0_31.showingShop:GetPlayerRefreshResource()

	setActive(arg1_31:Find("remainAndRefresh/remainTimer"), var0_31 ~= 0)
	setActive(arg1_31:Find("remainAndRefresh/refresh"), var3_31 ~= 0)
	setActive(arg1_31:Find("remainAndRefresh/refresh/refreshBtn"), var4_31)
	setActive(arg1_31:Find("remainAndRefresh"), isActive(arg1_31:Find("remainAndRefresh/remainTimer")) or isActive(arg1_31:Find("remainAndRefresh/refresh")))

	local var5_31 = pg.TimeMgr.GetInstance():GetTimeToNextTime()

	if arg0_31.timer then
		arg0_31.timer:Stop()

		arg0_31.timer = nil
	end

	arg0_31.timer = Timer.New(function()
		local var0_32 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_31 ~= 0 then
			local var1_32 = pg.TimeMgr.GetInstance():DescCDTime(var0_31 - var0_32)

			setText(arg1_31:Find("remainAndRefresh/remainTimer"), i18n("island_3Dshop_time_close", var1_32))
		elseif normalShopExistTime and type(normalShopExistTime) == "table" then
			-- block empty
		end

		if var3_31 ~= 0 then
			local var2_32 = pg.TimeMgr.GetInstance():DescCDTime(var3_31 - var0_32)

			setText(arg1_31:Find("remainAndRefresh/refresh/refreshTimer"), i18n("island_3Dshop_time_refresh", var2_32))

			if var0_32 > var3_31 then
				arg0_31:DoUpdateShowingShop()
			end
		end

		if var3_31 == 0 and var4_31 and var0_32 > var5_31 then
			arg0_31:DoUpdateShowingShop()
		end
	end, 1, -1)

	arg0_31.timer:Start()

	if var4_31 then
		onButton(arg0_31, arg1_31:Find("remainAndRefresh/refresh/refreshBtn/button"), function()
			local var0_33 = arg0_31.showingShop.refreshCount

			if var0_33 < arg0_31.showingShop:GetMaxRefreshCount() then
				local var1_33 = arg0_31.showingShop:GetFirstRefreshFree()
				local var2_33 = var4_31[3]

				if var1_33 and var0_33 == 0 then
					var4_31[3] = 0
					var2_33 = 0
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					noText = "text_cancel",
					hideNo = false,
					yesText = "text_confirm",
					content = i18n("refresh_shopStreet_question", i18n("word_" .. id2res(var4_31[2]) .. "_icon"), var2_33, var0_33),
					onYes = function()
						arg0_31:emit(IslandMediator.REFRESH_SHOP_BY_PLAYER, arg0_31.showingShop.id, var4_31)
					end
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_3Dshop_refresh_limit"))
			end
		end, SFX_PANEL)
	end
end

function var0_0.SetCommodity(arg0_35, arg1_35, arg2_35)
	var0_0.StaticUpdateCommodityTpl(arg1_35, arg2_35)
	setActive(arg1_35:Find("notInTime"), not arg0_35.showingShop:IsInTime())

	local var0_35 = false

	for iter0_35, iter1_35 in ipairs(arg0_35.shoppingCartCommodities) do
		if iter1_35.id == arg2_35.id then
			var0_35 = true

			break
		end
	end

	setActive(arg1_35:Find("select"), var0_35)

	if isActive(arg1_35:Find("sellOut")) or isActive(arg1_35:Find("hold")) or isActive(arg1_35:Find("notInTime")) then
		removeOnButton(arg1_35)
	else
		onButton(arg0_35, arg1_35, function()
			switch(arg2_35:GetCommodityShowType(), {
				[IslandConst.COMMODITY_SHOW_ITEM] = function()
					arg0_35.myIslandShopItemLayer = arg0_35:OpenPage(IslandShopItemLayer, arg0_35.showingShop.id, arg2_35)
				end,
				[IslandConst.COMMODITY_SHOW_DRESS] = function()
					if #arg2_35:GetItems() > 1 then
						if #arg0_35.shoppingCartCommodities == 1 and arg0_35.shoppingCartCommodities[1].id == arg2_35.id then
							arg0_35.shoppingCartCommodities = {}

							arg0_35.islandShipDressHelper:ResetDressUp()
						else
							arg0_35.shoppingCartCommodities = {
								arg2_35
							}

							for iter0_38, iter1_38 in ipairs(arg2_35:GetItems()) do
								local var0_38

								if iter1_38[1] == DROP_TYPE_ISLAND_DRESS then
									local var1_38 = pg.island_dress_template[iter1_38[2]]

									if var1_38 then
										var0_38 = var1_38.type
									end
								end

								arg0_35.islandShipDressHelper:ChangeDressByType(var0_38, {
									colorId = 0,
									id = iter1_38[2]
								})
							end
						end

						setText(arg0_35.shopSkinPage:Find("shoppingCartBtn/count"), (#arg0_35.shoppingCartCommodities > 0 and #arg2_35:GetItems() or 0) .. "/3")
					else
						local var2_38 = arg0_35.characterAgency:GetShipById(arg0_35.showingShipId)
						local var3_38 = var2_38:GetCurrentSkinId()
						local var4_38 = false
						local var5_38 = false
						local var6_38 = pg.island_dress_template[arg2_35:GetItems()[1][2]]

						if var3_38 ~= 0 then
							local var7_38 = var6_38.exclusive_skin

							if var7_38 ~= "" then
								for iter2_38, iter3_38 in ipairs(var7_38) do
									if iter3_38 == var3_38 then
										var5_38 = true
									end
								end
							end
						else
							local var8_38 = var6_38.exclusive_default_skin

							if var8_38 ~= "" then
								for iter4_38, iter5_38 in ipairs(var8_38) do
									if iter5_38 == var2_38.id then
										var4_38 = true
									end
								end
							end
						end

						if var4_38 or var5_38 then
							pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_mutually_exclusive1", var6_38.name))

							return
						end

						if #arg0_35.shoppingCartCommodities > 0 and #arg0_35.shoppingCartCommodities[1]:GetItems() > 1 then
							arg0_35.shoppingCartCommodities = {}

							arg0_35.islandShipDressHelper:ResetDressUp()
						end

						local var9_38 = 0

						for iter6_38, iter7_38 in ipairs(arg0_35.shoppingCartCommodities) do
							if iter7_38:GetDressType() == arg2_35:GetDressType() then
								var9_38 = iter7_38.id

								table.remove(arg0_35.shoppingCartCommodities, iter6_38)

								break
							end
						end

						if arg2_35.id == var9_38 then
							arg0_35.islandShipDressHelper:ChangeDressByType(arg2_35:GetDressType(), {
								id = 0,
								colorId = 0
							})
						else
							table.insert(arg0_35.shoppingCartCommodities, arg2_35)
							arg0_35.islandShipDressHelper:ChangeDressByType(arg2_35:GetDressType(), {
								colorId = 0,
								id = arg2_35:GetItems()[1][2]
							})
						end

						setText(arg0_35.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_35.shoppingCartCommodities .. "/3")
					end

					setActive(arg0_35.shopSkinPage:Find("cancelBtn"), #arg0_35.shoppingCartCommodities > 0)
					setActive(arg0_35.shopSkinPage:Find("shoppingCartBtn"), #arg0_35.shoppingCartCommodities > 0)
					setActive(arg0_35.shopSkinPage:Find("shoppingCartBtn/count"), true)

					if #arg0_35.shoppingCartCommodities > 0 then
						onButton(arg0_35, arg0_35.shopSkinPage:Find("cancelBtn"), function()
							arg0_35.shoppingCartCommodities = {}

							arg0_35.islandShipDressHelper:ResetDressUp()
							setActive(arg0_35.shopSkinPage:Find("cancelBtn"), false)
							setActive(arg0_35.shopSkinPage:Find("shoppingCartBtn"), false)
							setText(arg0_35.shopSkinPage:Find("shoppingCartBtn/count"), "0/3")
							arg0_35:SetCommodityList()
						end, SFX_PANEL)
						onButton(arg0_35, arg0_35.shopSkinPage:Find("shoppingCartBtn"), function()
							arg0_35.myIslandShoppingCartLayer = arg0_35:OpenPage(IslandShoppingCartLayer, arg0_35.shoppingCartCommodities)
						end, SFX_PANEL)
					end

					arg0_35:SetCommodityList()
				end,
				[IslandConst.COMMODITY_SHOW_FURNITURE] = function()
					if arg0_35.showingCommodity ~= arg2_35 then
						arg0_35.showingCommodity = arg2_35
						arg0_35.shoppingCartCommodities = {
							arg2_35
						}

						arg0_35:LoadFurniture(arg2_35:GetModel(), arg2_35:GetModelParam())
						setActive(arg0_35.shopFurniturePage:Find("scenePreviewBtn"), false)
						setActive(arg0_35.shopFurniturePage:Find("shoppingCartBtn"), true)

						if #arg2_35:GetItems() == 1 then
							onButton(arg0_35, arg0_35.shopFurniturePage:Find("scenePreviewBtn"), function()
								setActive(arg0_35._tf, false)
								arg0_35:ClearCharacterScene()
								arg0_35:emit(IslandMediator.PREVIEW_FURNITURE, arg2_35:GetItems()[1][2])
							end, SFX_PANEL)
						end

						onButton(arg0_35, arg0_35.shopFurniturePage:Find("shoppingCartBtn"), function()
							arg0_35.myIslandShoppingCartLayer = arg0_35:OpenPage(IslandShoppingCartLayer, arg0_35.shoppingCartCommodities)
						end, SFX_PANEL)
					else
						arg0_35.showingCommodity = nil
						arg0_35.shoppingCartCommodities = {}

						arg0_35:UnloadCharacter()
						setActive(arg0_35.shopFurniturePage:Find("scenePreviewBtn"), false)
						setActive(arg0_35.shopFurniturePage:Find("shoppingCartBtn"), false)
					end

					arg0_35:SetCommodityList()
				end,
				[IslandConst.COMMODITY_SHOW_SKIN] = function()
					if arg0_35.showingCommodity ~= arg2_35 then
						arg0_35.showingCommodity = arg2_35
						arg0_35.shoppingCartCommodities = {
							arg2_35
						}

						local var0_44 = pg.island_skin_template[arg2_35:GetItems()[1][2]].model
						local var1_44 = pg.island_unit_character[var0_44]

						arg0_35:LoadCharacter(var1_44, false)
					else
						arg0_35.showingCommodity = nil
						arg0_35.shoppingCartCommodities = {}

						arg0_35:UnloadCharacter()
					end

					setActive(arg0_35.shopSkinPage:Find("cancelBtn"), false)
					setActive(arg0_35.shopSkinPage:Find("shoppingCartBtn"), #arg0_35.shoppingCartCommodities > 0)
					setActive(arg0_35.shopSkinPage:Find("shoppingCartBtn/count"), false)
					setText(arg0_35.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_35.shoppingCartCommodities .. "/3")

					if #arg0_35.shoppingCartCommodities > 0 then
						onButton(arg0_35, arg0_35.shopSkinPage:Find("cancelBtn"), function()
							arg0_35.shoppingCartCommodities = {}

							local var0_45 = arg0_35.characterAgency:GetShipById(arg0_35.showingShipId):GetModel()

							arg0_35:LoadCharacter(var0_45, false)
							setActive(arg0_35.shopSkinPage:Find("cancelBtn"), false)
							setActive(arg0_35.shopSkinPage:Find("shoppingCartBtn"), false)
							setText(arg0_35.shopSkinPage:Find("shoppingCartBtn/count"), "0/3")
							arg0_35:SetCommodityList()
						end, SFX_PANEL)
						onButton(arg0_35, arg0_35.shopSkinPage:Find("shoppingCartBtn"), function()
							arg0_35.myIslandShoppingCartLayer = arg0_35:OpenPage(IslandShoppingCartLayer, arg0_35.shoppingCartCommodities)
						end, SFX_PANEL)
					end

					arg0_35:SetCommodityList()
				end,
				[IslandConst.COMMODITY_SHOW_INVITE] = function()
					local var0_47 = arg2_35:GetItems()[1][2]

					arg0_35.myIslandShopItemLayer = arg0_35:OpenPage(IslandShopItemLayer, arg0_35.showingShop.id, arg2_35, var0_47)
				end
			})
		end, SFX_PANEL)
	end
end

function var0_0.SetCommodityList(arg0_48)
	local var0_48 = arg0_48.showingShop:GetShowType()
	local var1_48 = switch(var0_48, {
		[IslandConst.SHOP_TYPE_2D] = function()
			return UIItemList.New(arg0_48.shop2DPage:Find("shopView/Viewport/Content"), arg0_48.shop2DPage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end,
		[IslandConst.SHOP_TYPE_3D] = function()
			return UIItemList.New(arg0_48.shop3DPage:Find("shopView/Viewport/Content"), arg0_48.shop3DPage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end,
		[IslandConst.SHOP_TYPE_FURNITURE] = function()
			return UIItemList.New(arg0_48.shopFurniturePage:Find("shopView/Viewport/Content"), arg0_48.shopFurniturePage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end,
		[IslandConst.SHOP_TYPE_SKIN] = function()
			return UIItemList.New(arg0_48.shopSkinPage:Find("shopView/Viewport/Content"), arg0_48.shopSkinPage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end
	})
	local var2_48 = arg0_48.showingShop:GetCommodities()

	var0_0.SortShopCommodities(var2_48)
	var1_48:make(function(arg0_53, arg1_53, arg2_53)
		if arg0_53 == UIItemList.EventUpdate then
			local var0_53 = var2_48[arg1_53 + 1]

			arg0_48:SetCommodity(arg2_53, var0_53)
		end
	end, SFX_PANEL)
	var1_48:align(#var2_48)
end

function var0_0.ShowRecommendation(arg0_54)
	arg0_54:ClearCharacterScene()
	arg0_54:OverlayPanel(arg0_54._tf, {
		pbList = {
			arg0_54.bg
		}
	})
	setActive(arg0_54.bgColor, true)

	arg0_54.shoppingCartCommodities = {}

	local var0_54 = arg0_54.showingShop:GetBanners()
	local var1_54 = arg0_54.recommendationPage:Find("banners")

	for iter0_54 = 1, #var0_54 do
		local var2_54 = var0_54[iter0_54]
		local var3_54 = var1_54:GetChild(iter0_54 - 1)

		GetImageSpriteFromAtlasAsync("activitybanner/" .. var2_54.pic, "", var3_54)
		onButton(arg0_54, var3_54, function()
			local var0_55 = arg0_54.shopAgency:GetShopById(var2_54.param)

			if var0_55 then
				arg0_54.showingShop = var0_55

				if arg0_54.showingShop:IsInTime() then
					arg0_54:emit(IslandMediator.GET_SHOP_DATA, arg0_54.showingShop.id, true)
				else
					arg0_54:UpdateData()
					arg0_54:SetShopList()
				end
			end
		end, SFX_PANEL)
	end
end

function var0_0.ShowShop2D(arg0_56)
	arg0_56:ClearCharacterScene()
	arg0_56:OverlayPanel(arg0_56._tf, {
		pbList = {
			arg0_56.bg
		}
	})
	setActive(arg0_56.bgColor, true)

	arg0_56.shoppingCartCommodities = {}

	local var0_56 = arg0_56.showingShop:IsInTime()

	setActive(arg0_56.shop2DPage:Find("lock"), not var0_56)

	if var0_56 then
		arg0_56:SetCloseAndRefresh(arg0_56.shop2DPage)
	else
		setActive(arg0_56.shop2DPage:Find("remainAndRefresh"), false)

		if arg0_56.timer then
			arg0_56.timer:Stop()

			arg0_56.timer = nil
		end

		arg0_56.timer = Timer.New(function()
			local var0_57 = arg0_56.showingShop:GetExistTime()[1]
			local var1_57 = pg.TimeMgr.GetInstance():Table2ServerTime({
				year = var0_57[1][1],
				month = var0_57[1][2],
				day = var0_57[1][3],
				hour = var0_57[2][1],
				min = var0_57[2][2],
				sec = var0_57[2][3]
			})
			local var2_57 = pg.TimeMgr.GetInstance():GetServerTime()
			local var3_57 = pg.TimeMgr.GetInstance():DescCDTime(var1_57 - var2_57)

			setText(arg0_56.shop2DPage:Find("lock/openTimer"), i18n("island_3Dshop_time_unlock", var3_57))
		end, 1, -1)

		arg0_56.timer:Start()
	end

	arg0_56:SetCommodityList()
end

function var0_0.ShowShop3D(arg0_58)
	arg0_58:ClearCharacterScene()
	arg0_58:OverlayPanel(arg0_58._tf, {
		pbList = {
			arg0_58.shop3DPage:Find("bg")
		}
	})
	setActive(arg0_58.bgColor, false)

	arg0_58.shoppingCartCommodities = {}

	arg0_58:SetCloseAndRefresh(arg0_58.shop3DPage)
	arg0_58:SetCommodityList()
end

function var0_0.ShowShopFurniture(arg0_59)
	if not arg0_59.isLoadCharacterScene then
		arg0_59:PrepareCharacterScene()
	end

	arg0_59:OverlayPanel(arg0_59._tf, {
		pbList = {
			arg0_59.shopFurniturePage:Find("bg")
		}
	})
	setActive(arg0_59.bgColor, false)
	arg0_59:UnloadCharacter()

	arg0_59.shoppingCartCommodities = {}

	arg0_59:SetCloseAndRefresh(arg0_59.shopFurniturePage)
	arg0_59:SetCommodityList()
	setActive(arg0_59.shopFurniturePage:Find("scenePreviewBtn"), false)
	setActive(arg0_59.shopFurniturePage:Find("shoppingCartBtn"), false)
end

function var0_0.ShowShopSkin(arg0_60)
	if not arg0_60.isLoadCharacterScene then
		arg0_60:PrepareCharacterScene()
	end

	arg0_60:OverlayPanel(arg0_60._tf, {
		pbList = {
			arg0_60.shopSkinPage:Find("bg"),
			arg0_60.changeCharaPanel
		}
	})
	setActive(arg0_60.bgColor, false)

	if not arg0_60.shoppingCartCommodities then
		arg0_60.shoppingCartCommodities = {}
	end

	if #arg0_60.shoppingCartCommodities > 0 then
		local var0_60 = arg0_60.shoppingCartCommodities[1]:GetCommodityShowType()

		if var0_60 == IslandConst.COMMODITY_SHOW_FURNITURE or var0_60 == IslandConst.COMMODITY_SHOW_SKIN then
			arg0_60.shoppingCartCommodities = {}
		end
	end

	local var1_60 = arg0_60.showingShop:GetCommanderOrCharaType()

	if var1_60 == 0 and (arg0_60.showingShipId ~= 0 or #arg0_60.shoppingCartCommodities == 0) then
		arg0_60.showingShipId = 0

		local var2_60 = pg.island_unit_character[0]

		arg0_60:LoadCharacter({
			model = var2_60.model,
			animator = var2_60.animator
		}, true)

		arg0_60.shoppingCartCommodities = {}
	elseif var1_60 == 1 and (arg0_60.showingShipId ~= arg0_60.selectShipId or #arg0_60.shoppingCartCommodities == 0) then
		arg0_60.showingShipId = arg0_60.selectShipId

		local var3_60 = arg0_60.characterAgency:GetShipById(arg0_60.showingShipId):GetModel()

		arg0_60:LoadCharacter(var3_60, false)

		arg0_60.shoppingCartCommodities = {}
	elseif var1_60 == 2 then
		arg0_60.showingShipId = arg0_60.selectShipId

		arg0_60:UnloadCharacter()

		arg0_60.shoppingCartCommodities = {}
	end

	arg0_60:SetCloseAndRefresh(arg0_60.shopSkinPage)
	arg0_60:SetCommodityList()
	setActive(arg0_60.shopSkinPage:Find("cancelBtn"), #arg0_60.shoppingCartCommodities > 0)
	setActive(arg0_60.shopSkinPage:Find("changeCharaBtn"), var1_60 == 1)
	setActive(arg0_60.shopSkinPage:Find("shoppingCartBtn"), #arg0_60.shoppingCartCommodities > 0)
	setActive(arg0_60.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_60.shoppingCartCommodities > 0 and arg0_60.shoppingCartCommodities[1]:GetItems()[1][1] ~= DROP_TYPE_ISLAND_SKIN)
	setText(arg0_60.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_60.shoppingCartCommodities .. "/3")
	setActive(arg0_60.shopSkinPage:Find("changeCharaPanel"), false)
	arg0_60:SetChangeCharaPanel()
	onButton(arg0_60, arg0_60.shopSkinPage:Find("changeCharaBtn"), function()
		setActive(arg0_60.shopSkinPage:Find("changeCharaPanel"), true)
	end, SFX_PANEL)
end

function var0_0.SetChangeCharaPanel(arg0_62)
	onButton(arg0_62, arg0_62.shopSkinPage:Find("changeCharaPanel/bg"), function()
		setActive(arg0_62.shopSkinPage:Find("changeCharaPanel"), false)
	end, SFX_PANEL)
	onButton(arg0_62, arg0_62.changeCharaPanel:Find("closeBtn"), function()
		setActive(arg0_62.shopSkinPage:Find("changeCharaPanel"), false)
	end, SFX_PANEL)

	local var0_62 = UIItemList.New(arg0_62.changeCharaPanel:Find("charaScroll/Viewport/Content"), arg0_62.changeCharaPanel:Find("charaScroll/Viewport/Content/IslandShipTpl"))

	var0_62:make(function(arg0_65, arg1_65, arg2_65)
		if arg0_65 == UIItemList.EventUpdate then
			local var0_65 = arg0_62.ships[arg1_65 + 1]
			local var1_65 = IslandShip.StaticGetPrefab(var0_65.id)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_65, "", arg2_65:Find("mask/icon"))
			setText(arg2_65:Find("Text"), "Lv." .. var0_65:GetLevel())
			setActive(arg2_65:Find("add"), false)
			setActive(arg2_65:Find("select"), var0_65.id == arg0_62.selectShipId)
			onButton(arg0_62, arg2_65, function()
				if arg0_62.charaSetModel == var0_0.CharaSetModel.current then
					arg0_62.selectShipId = var0_65.id
					arg0_62.showingShipId = var0_65.id

					arg0_62:LoadCharacter(var0_65:GetModel(), false)

					arg0_62.shoppingCartCommodities = {}

					setActive(arg0_62.shopSkinPage:Find("cancelBtn"), false)
					setActive(arg0_62.shopSkinPage:Find("shoppingCartBtn"), false)
					setText(arg0_62.shopSkinPage:Find("shoppingCartBtn/count"), "0/3")
					arg0_62:SetCommodityList()
				elseif arg0_62.charaSetModel == var0_0.CharaSetModel.default then
					arg0_62.defaultShipId = var0_65.id

					PlayerPrefs.SetInt("island_dressShop_defaultShipId_" .. arg0_62.player.id, var0_65.id)
				end

				for iter0_66 = 0, arg0_62.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
					setActive(arg0_62.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter0_66):Find("select"), iter0_66 == arg1_65)
				end
			end, SFX_PANEL)
		end
	end)
	var0_62:align(#arg0_62.ships)

	arg0_62.charaSetModel = var0_0.CharaSetModel.current

	onButton(arg0_62, arg0_62.changeCharaPanel:Find("defaultSet"), function()
		if arg0_62.charaSetModel == var0_0.CharaSetModel.current then
			arg0_62.charaSetModel = var0_0.CharaSetModel.default

			for iter0_67 = 0, arg0_62.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
				setActive(arg0_62.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter0_67):Find("select"), arg0_62.ships[iter0_67 + 1].id == arg0_62.defaultShipId)
			end
		elseif arg0_62.charaSetModel == var0_0.CharaSetModel.default then
			arg0_62.charaSetModel = var0_0.CharaSetModel.current

			for iter1_67 = 0, arg0_62.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
				setActive(arg0_62.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter1_67):Find("select"), arg0_62.ships[iter1_67 + 1].id == arg0_62.selectShipId)
			end
		end

		setActive(arg0_62.changeCharaPanel:Find("defaultSet/off"), arg0_62.charaSetModel == var0_0.CharaSetModel.current)
		setActive(arg0_62.changeCharaPanel:Find("defaultSet/on"), arg0_62.charaSetModel == var0_0.CharaSetModel.default)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_68)
	arg0_68:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_68.UpdateView)
	arg0_68:AddListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_68.OnSwitchMapByPoint)
	arg0_68:AddListener(ActivityProxy.ACTIVITY_UPDATED, arg0_68.UpdateActivity)
	arg0_68:AddListener(GAME.ACTIVITY_DRAW_AWARD_OPERATION_DONE, arg0_68.DrawOperation)
end

function var0_0.RemoveListeners(arg0_69)
	arg0_69:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_69.UpdateView)
	arg0_69:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_69.OnSwitchMapByPoint)
	arg0_69:RemoveListener(ActivityProxy.ACTIVITY_UPDATED, arg0_69.UpdateActivity)
	arg0_69:RemoveListener(GAME.ACTIVITY_DRAW_AWARD_OPERATION_DONE, arg0_69.DrawOperation)
end

function var0_0.UpdateView(arg0_70, arg1_70)
	if arg1_70.operation == IslandConst.SHOP_GET_DATA then
		if arg1_70.refreshAll then
			arg0_70:UpdateData()
			arg0_70:SetShopList()
		else
			arg0_70:SetShopPage()
		end
	elseif arg1_70.operation == IslandConst.SHOP_BUY_COMMODITY then
		arg0_70.shoppingCartCommodities = {}

		arg0_70:SetShopPage()

		if arg0_70.myIslandShoppingCartLayer then
			arg0_70.myIslandShoppingCartLayer:Hide()
		end

		arg0_70:OpenPage(IslandShopBuySuccessLayer, arg1_70.awards, function()
			if arg0_70.showingShop:GetShowType() == IslandConst.SHOP_TYPE_SKIN then
				arg0_70:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_3Dshop_clothes_jump"),
					onYes = function()
						arg0_70:ClearCharacterScene(function()
							arg0_70:Hide()

							local var0_73 = arg0_70.showingShop:GetCommanderOrCharaType()

							if var0_73 == 0 then
								arg0_70:OpenScenePage(IslandShipIslandCommanderMainPage)
							elseif var0_73 == 1 or var0_73 == 2 then
								arg0_70:OpenScenePage(IslandShipMainPage, 3)
							end
						end)
					end
				})
			end
		end)

		if arg0_70.myIslandShopItemLayer then
			arg0_70.myIslandShopItemLayer:Refresh()
		end
	elseif arg1_70.operation == IslandConst.REFRESH_SHOP_BY_PLAYER then
		arg0_70:SetShopPage()
	end
end

function var0_0.OnSwitchMapByPoint(arg0_74)
	setActive(arg0_74._tf, true)
	arg0_74:PrepareCharacterScene()
end

function var0_0.UpdateActivity(arg0_75, arg1_75)
	if arg1_75:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ISLAND_DRAW_AWARD then
		arg0_75.drawAwardActivity = arg1_75

		arg0_75.drawAwardPage:ActionInvoke("UpdateActivity", arg0_75.drawAwardActivity)
		arg0_75:SetResources()
	end
end

function var0_0.DrawOperation(arg0_76, arg1_76)
	arg0_76.drawAwardPage:ActionInvoke("DrawOperation", arg1_76)
end

function var0_0.Preload(arg0_77, arg1_77)
	arg1_77()
end

function var0_0.GetSmoothRotateObject(arg0_78)
	return arg0_78._tf:Find("adapt/model")
end

function var0_0.LoadFurniture(arg0_79, arg1_79, arg2_79)
	arg0_79:UnloadCharacter()

	if arg0_79.isLoadingModel then
		return
	end

	arg0_79.isLoadingModel = true

	local var0_79 = IslandAssetLoadDispatcher.Instance:Enqueue(arg1_79, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_80)
		arg0_79.role = Object.Instantiate(arg0_80)

		local var0_80 = arg0_79.role.name
		local var1_80 = GameObject.New(var0_80)

		setParent(arg0_79.role, var1_80.transform, false)

		arg0_79.role = var1_80
		arg0_79.isLoadingModel = false

		pg.ViewUtils.SetLayer(arg0_79.role.transform, Layer.Character3D)
		setParent(arg0_79.role, arg0_79.roleContainer)

		arg0_79.role.transform.localPosition = Vector3(arg2_79[1][1], arg2_79[1][2], 0)
		arg0_79.role.transform.localEulerAngles = Vector3(0, arg2_79[2], 0)
		arg0_79.role.transform.localScale = Vector3(arg2_79[3], arg2_79[3], arg2_79[3])

		local var2_80 = arg0_79:GetSmoothRotateObject()
		local var3_80 = GetOrAddComponent(var2_80, typeof(SmoothRotateObject))

		var3_80:SetUp(arg0_79.role.transform)

		var3_80.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int
	end), true, true)

	table.insert(arg0_79.loadingIdList or {}, var0_79)
end

function var0_0.LoadCharacter(arg0_81, arg1_81, arg2_81)
	arg0_81:UnloadCharacter()

	if arg0_81.isLoadingModel then
		return
	end

	arg0_81.isLoadingModel = true

	arg0_81.islandShipDressHelper:SetShipId(arg0_81.showingShipId)

	arg0_81.isCommander = arg2_81
	arg0_81.modelData = arg1_81

	local function var0_81(arg0_82)
		arg0_81.role = arg0_82
		arg0_81.isLoadingModel = false

		pg.ViewUtils.SetLayer(arg0_81.role.transform, Layer.Character3D)
		setParent(arg0_81.role, arg0_81.roleContainer)

		local var0_82 = 2.7
		local var1_82 = arg0_81._tf.rect.width / arg0_81._tf.rect.height

		if var1_82 < 1.77777777777778 then
			var0_82 = 2.7 - 0.5 * (1.77777777777778 - var1_82) / 0.444444444444444
		end

		arg0_81.role.transform.localPosition = Vector3(var0_82, 0, 0)
		arg0_81.role.transform.localEulerAngles = Vector3(0, -155, 0)

		local var2_82 = arg0_81:GetSmoothRotateObject()
		local var3_82 = GetOrAddComponent(var2_82, typeof(SmoothRotateObject))

		var3_82:SetUp(arg0_81.role.transform)

		var3_82.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int

		arg0_81.displayUnit:OnAttach(arg0_82, arg0_81.toolContainer)

		local var4_82 = arg0_81.modelData and arg0_81.modelData.personal_ani

		if var4_82 and var4_82 ~= "" then
			local var5_82 = GetOrAddComponent(arg0_81.role.transform:GetChild(0), typeof(Animator))

			for iter0_82 = 1, var5_82.layerCount do
				var5_82:CrossFadeInFixedTime(var4_82, 0, iter0_82 - 1)
			end
		end

		arg0_81.islandShipDressHelper:OnRoleLoaded(arg0_81.role.transform)
	end

	if arg0_81.isCommander then
		arg0_81:GetPoolMgr():GetCommanderModel(arg1_81, function(arg0_83)
			var0_81(arg0_83)
		end)
	else
		arg0_81:GetPoolMgr():GetCharacter(arg1_81.model, arg1_81.animator, function(arg0_84)
			var0_81(arg0_84)
		end)
	end
end

function var0_0.UnloadCharacter(arg0_85)
	arg0_85.islandShipDressHelper:Destroy()

	if arg0_85.role then
		arg0_85.displayUnit:OnDetach()
		pg.ViewUtils.SetLayer(arg0_85.role.transform, Layer.Default)

		if arg0_85.isCommander then
			arg0_85:GetPoolMgr():ReturnCommanderModel(arg0_85.role)
		elseif arg0_85.modelData then
			arg0_85:GetPoolMgr():ReturnCharacter(arg0_85.modelData.model, arg0_85.modelData.animator, arg0_85.role)

			arg0_85.modelData = nil
		end

		arg0_85.role = nil
	end

	arg0_85.modelData = nil
end

function var0_0.OnShow(arg0_86, arg1_86, arg2_86, arg3_86)
	arg0_86:OverlayPanel(arg0_86._tf)

	arg0_86.showTypes = arg1_86
	arg0_86.firstShopIds = arg2_86
	arg0_86.showDrawAward = arg3_86 == 1
	arg0_86.drawAwardActivity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND_DRAW_AWARD)

	arg0_86:DoUpdateShops()
	arg0_86:UpdateData()
	arg0_86:SetShopList()
end

function var0_0.OnHide(arg0_87)
	arg0_87:UnOverlayPanel(arg0_87._tf)

	if arg0_87.timer then
		arg0_87.timer:Stop()

		arg0_87.timer = nil
	end

	arg0_87.shoppingCartCommodities = {}

	arg0_87.islandShipDressHelper:Destroy()
	arg0_87:UnloadCharacter()
	arg0_87.drawAwardPage:Destroy()
	arg0_87.drawAwardPage:Reset()

	for iter0_87, iter1_87 in ipairs(arg0_87.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter1_87)
	end

	arg0_87.loadingIdList = {}
end

function var0_0.OnDisable(arg0_88)
	arg0_88:OnHide()
	var0_0.super.OnDisable(arg0_88)
end

function var0_0.OnDestroy(arg0_89)
	arg0_89:OnHide()
	var0_0.super.OnDestroy(arg0_89)
end

function var0_0.StaticUpdateCommodityTpl(arg0_90, arg1_90)
	local var0_90 = arg1_90:GetMaxNum() - arg1_90.purchasedNum

	setText(arg0_90:Find("name"), arg1_90:GetName())

	if #arg1_90:GetItems() == 1 and arg1_90:GetItems()[1][1] ~= DROP_TYPE_ISLAND_FURNITURE and arg1_90:GetItems()[1][1] ~= DROP_TYPE_ISLAND_DRESS and arg1_90:GetItems()[1][1] ~= DROP_TYPE_ISLAND_SKIN then
		local var1_90 = arg1_90:GetItems()[1]
		local var2_90 = {
			type = var1_90[1],
			id = var1_90[2],
			count = var1_90[3]
		}

		updateCustomDrop(arg0_90:Find("IslandItemTpl"), var2_90, {
			style = "island"
		})
	else
		GetImageSpriteFromAtlasAsync(arg1_90:GetIcon(), "", arg0_90:Find("IslandItemTpl/icon_bg/icon"))
	end

	setActive(arg0_90:Find("IslandItemTpl/icon_bg/count_bg"), arg1_90:IsShowPurchaseLimit())
	setText(arg0_90:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_90 .. "/" .. arg1_90:GetMaxNum())

	local var3_90 = arg1_90:GetResourceConsume()

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = var3_90[1],
		id = var3_90[2]
	}):getIcon(), "", arg0_90:Find("cost/icon"))
	setText(arg0_90:Find("cost/num"), math.ceil((100 - arg1_90:GetDiscount()) / 100 * var3_90[3]))
	setActive(arg0_90:Find("timeLimit"), arg1_90:IsTimeLimitCommodity())
	setActive(arg0_90:Find("discount"), arg1_90:GetDiscount() ~= 0)
	setText(arg0_90:Find("discount/Text"), "-" .. arg1_90:GetDiscount() .. "%")

	local var4_90 = arg1_90:GetItems()[1][1]
	local var5_90 = arg1_90:GetItems()[1][2]
	local var6_90 = Drop.New({
		count = 1,
		type = var4_90,
		id = var5_90
	}):getOwnedCount()

	setActive(arg0_90:Find("have"), arg1_90:IsShowHave())
	setText(arg0_90:Find("have"), i18n("island_3Dshop_have") .. var6_90)
	setActive(arg0_90:Find("hold"), arg1_90:IsShowHold() and (var6_90 > 0 or arg1_90:IsCharacterInviteItemHold()))
	setActive(arg0_90:Find("sellOut"), arg1_90:GetMaxNum() ~= 0 and var0_90 == 0 and not isActive(arg0_90:Find("hold")))
	setActive(arg0_90:Find("cost"), not isActive(arg0_90:Find("sellOut")) and not isActive(arg0_90:Find("hold")))
	setActive(arg0_90:Find("select"), false)
	setText(arg0_90:Find("sellOut/Text"), i18n("common_sale_out"))
	setText(arg0_90:Find("hold/Text"), i18n("common_already owned"))
end

function var0_0.SortShopCommodities(arg0_91)
	table.sort(arg0_91, CompareFuncs({
		function(arg0_92)
			local var0_92 = arg0_92:GetMaxNum() - arg0_92.purchasedNum

			if arg0_92:GetMaxNum() ~= 0 and var0_92 == 0 then
				return 3
			end

			if arg0_92:IsShowHold() then
				if arg0_92:IsCharacterInviteItemHold() then
					return 2
				else
					local var1_92 = arg0_92:GetItems()[1][1]
					local var2_92 = arg0_92:GetItems()[1][2]

					return Drop.New({
						count = 1,
						type = var1_92,
						id = var2_92
					}):getOwnedCount() > 0 and 2 or 1
				end
			else
				return 1
			end
		end,
		function(arg0_93)
			return arg0_93.id
		end
	}))
end

return var0_0
