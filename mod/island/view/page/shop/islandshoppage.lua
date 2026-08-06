local var0_0 = class("IslandShopPage", import("..ship.IslandBaseShipDisplayPage"))
local var1_0 = 20016003
local var2_0 = pg.island_item_data_template

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
	arg0_2.recommendationPage5 = arg0_2._tf:Find("adapt/shopPage/recommendation5")
	arg0_2.recommendationPage1 = arg0_2._tf:Find("adapt/shopPage/recommendation1")
	arg0_2.shop2DPage = arg0_2._tf:Find("adapt/shopPage/shop2D")
	arg0_2.shop3DPage = arg0_2._tf:Find("adapt/shopPage/shop3D")
	arg0_2.shopFurniturePage = arg0_2._tf:Find("adapt/shopPage/shopFurniture")
	arg0_2.shopSkinPage = arg0_2._tf:Find("adapt/shopPage/shopSkin")
	arg0_2.morphBtn = arg0_2.shopSkinPage:Find("morphBtn")
	arg0_2.morphBlocker = arg0_2._tf:Find("morph_blocker")

	setActive(arg0_2.morphBlocker, false)

	arg0_2.changeCharaPanel = arg0_2.shopSkinPage:Find("changeCharaPanel/panel")
	arg0_2.subPageContainer = arg0_2._tf:Find("adapt/subPageContainer")
	arg0_2.drawAwardPage = IslandShopDrawAwardPage.New(arg0_2.subPageContainer, arg0_2)

	setText(arg0_2.shopSkinPage:Find("changeCharaPanel/panel/title"), i18n("island_3Dshop_chara_choose"))
	setText(arg0_2.shopSkinPage:Find("changeCharaPanel/panel/setTxt"), i18n("island_3Dshop_chara_set"))

	arg0_2.exchangSubView = IslandShopExchangePage.New(arg0_2._tf, arg0_2)

	arg0_2.exchangSubView:RegisterView(arg0_2)
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

		setActive(arg0_8.shop3, var0_8 == IslandConst.SHOP_TYPE_RECOMMENDATION_5 or var0_8 == IslandConst.SHOP_TYPE_RECOMMENDATION_1 or var0_8 == IslandConst.SHOP_TYPE_2D)
		setActive(arg0_8.shop32, var0_8 == IslandConst.SHOP_TYPE_3D or var0_8 == IslandConst.SHOP_TYPE_FURNITURE or var0_8 == IslandConst.SHOP_TYPE_SKIN)
	end
end

function var0_0.UpdateData(arg0_9)
	arg0_9.firstShopConfigs = arg0_9.shopAgency:GetFirstShopConfigs(arg0_9.showTypes, arg0_9.firstShopIds)

	if not arg0_9.showingShop or not arg0_9.shopAgency:IsShowShop(arg0_9.showingShop.id) then
		arg0_9.showingShop = arg0_9.shopAgency:GetInitShowingShop(arg0_9.showTypes, arg0_9.firstShopIds)
	end
end

function var0_0.SetShopPageVisible(arg0_10, arg1_10)
	setActive(arg0_10._tf:Find("adapt/shopPage"), arg1_10)

	if not IsNil(arg0_10.roleContainer) then
		setActive(arg0_10.roleContainer, arg1_10)
	end
end

function var0_0.GetShopConfigIds(arg0_11, arg1_11)
	local var0_11 = {}

	for iter0_11, iter1_11 in ipairs(arg1_11) do
		table.insert(var0_11, iter1_11.id)
	end

	return var0_11
end

function var0_0.GetRecommendationTargetShop(arg0_12, arg1_12)
	if not arg1_12 then
		return nil
	end

	if arg1_12.shop_type ~= 0 then
		return arg0_12.shopAgency:GetShopById(arg1_12.id)
	end

	if arg1_12.tag_type == 1 then
		local var0_12 = arg0_12.shopAgency:GetSecondShopConfigs(arg0_12.showTypes, arg1_12.id)

		for iter0_12, iter1_12 in ipairs(var0_12) do
			local var1_12 = arg0_12:GetRecommendationTargetShop(iter1_12)

			if var1_12 then
				return var1_12
			end
		end
	elseif arg1_12.tag_type == 2 then
		local var2_12 = arg0_12.shopAgency:GetThirdShopConfigs(arg0_12.showTypes, arg1_12.id)

		for iter2_12, iter3_12 in ipairs(var2_12) do
			local var3_12 = arg0_12:GetRecommendationTargetShop(iter3_12)

			if var3_12 then
				return var3_12
			end
		end
	end

	return nil
end

function var0_0.JumpToRecommendationShop(arg0_13, arg1_13)
	local var0_13 = arg0_13:GetRecommendationTargetShop(pg.island_shop_template[arg1_13])

	if not var0_13 then
		return
	end

	arg0_13.showingShop = var0_13

	if arg0_13.showingShop:IsInTime() then
		arg0_13:emit(IslandMediator.GET_SHOP_DATA, arg0_13.showingShop.id, true)
	else
		arg0_13:UpdateData()
		arg0_13:SetShopList()
	end
end

function var0_0.SetThirdShopTpl(arg0_14, arg1_14, arg2_14)
	setActive(arg1_14:Find("selected"), arg0_14.showingShop.id == arg2_14.id)
	setText(arg1_14:Find("name"), arg2_14.tag_icon[1])
	setText(arg1_14:Find("selected/name"), arg2_14.tag_icon[1])
	setActive(arg1_14:Find("icon"), arg2_14.tag_icon[3])

	if arg2_14.tag_icon[3] then
		LoadImageSpriteAsync(arg2_14.tag_icon[3], arg1_14:Find("icon"), false)
	end

	local var0_14 = arg0_14.shopAgency:GetShopById(arg2_14.id):IsInTime()

	setActive(arg1_14:Find("lock"), not var0_14)
	setActive(arg1_14:Find("selected/lock"), not var0_14)
end

function var0_0.SelectThirdShop(arg0_15, arg1_15, arg2_15, arg3_15, arg4_15, arg5_15, arg6_15, arg7_15)
	if arg0_15.currentShop1TgIndex == arg4_15 and arg0_15.currentShop2TgIndex == arg5_15 and arg0_15.currentShop3TgIndex == arg6_15 then
		return
	end

	for iter0_15 = 0, arg2_15.childCount - 1 do
		setActive(arg2_15:GetChild(iter0_15):Find("selected"), false)
	end

	setActive(arg1_15:Find("selected"), true)

	if arg7_15 then
		arg1_15:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop3List_Selected")
	end

	arg0_15.showingShop = arg0_15.shopAgency:GetShopById(arg3_15.id)

	arg0_15:DoUpdateShowingShop()

	arg0_15.currentShop3TgIndex = arg6_15
end

function var0_0.BindThirdShopList(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16, arg5_16, arg6_16)
	local var0_16 = arg0_16:GetShopConfigIds(arg3_16)

	arg1_16:make(function(arg0_17, arg1_17, arg2_17)
		if arg0_17 ~= UIItemList.EventUpdate then
			return
		end

		local var0_17 = arg1_17 + 1
		local var1_17 = arg3_16[var0_17]

		arg0_16:SetThirdShopTpl(arg2_17, var1_17)
		onToggle(arg0_16, arg2_17, function(arg0_18)
			if arg0_18 then
				arg0_16:SelectThirdShop(arg2_17, arg2_16, var1_17, arg4_16, arg5_16, var0_17, arg6_16)
			end
		end, SFX_PANEL)

		if arg0_16.showingShop.id == var1_17.id then
			triggerToggle(arg2_17, true)
		end

		if arg1_17 == 0 and not table.contains(var0_16, arg0_16.showingShop.id) then
			triggerToggle(arg2_17, true)
		end
	end, SFX_PANEL)
	arg1_16:align(#arg3_16)
end

function var0_0.BindThirdShopLists(arg0_19, arg1_19, arg2_19, arg3_19)
	arg0_19:BindThirdShopList(arg0_19.shop3List, arg0_19.shop3, arg1_19, arg2_19, arg3_19, true)
	arg0_19:BindThirdShopList(arg0_19.shop3List2, arg0_19.shop32, arg1_19, arg2_19, arg3_19, false)
end

function var0_0.SetSecondShopTpl(arg0_20, arg1_20, arg2_20)
	setActive(arg1_20:Find("selected"), arg0_20.showingShop.id == arg2_20.id or arg0_20.showingShop:GetSecondShopId() == arg2_20.id)
	setText(arg1_20:Find("name"), arg2_20.tag_icon[1])
	setText(arg1_20:Find("selected/name"), arg2_20.tag_icon[1])
end

function var0_0.SelectSecondShop(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21)
	if arg0_21.currentShop1TgIndex == arg3_21 and arg0_21.currentShop2TgIndex == arg4_21 then
		return
	end

	arg1_21:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop2List_Selected")
	setActive(arg0_21.shop3, arg2_21.shop_type == 0)
	setActive(arg0_21.shop32, arg2_21.shop_type == 0)

	if arg2_21.shop_type == 0 then
		local var0_21 = arg0_21.shopAgency:GetThirdShopConfigs(arg0_21.showTypes, arg2_21.id)

		arg0_21:BindThirdShopLists(var0_21, arg3_21, arg4_21)
	else
		arg0_21.showingShop = arg0_21.shopAgency:GetShopById(arg2_21.id)

		arg0_21:DoUpdateShowingShop()
	end

	arg0_21.currentShop2TgIndex = arg4_21
end

function var0_0.BindSecondShopList(arg0_22, arg1_22, arg2_22, arg3_22)
	local var0_22 = arg0_22.shopAgency:GetSecondShopConfigs(arg0_22.showTypes, arg2_22.id)
	local var1_22 = arg0_22:GetShopConfigIds(var0_22)
	local var2_22 = UIItemList.New(arg1_22:Find("shop2List"), arg1_22:Find("shop2List/shop2Tpl"))

	var2_22:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 ~= UIItemList.EventUpdate then
			return
		end

		local var0_23 = arg1_23 + 1
		local var1_23 = var0_22[var0_23]

		arg0_22:SetSecondShopTpl(arg2_23, var1_23)
		onToggle(arg0_22, arg2_23, function(arg0_24)
			if arg0_24 then
				arg0_22:SelectSecondShop(arg2_23, var1_23, arg3_22, var0_23)
			end
		end, SFX_PANEL)

		if arg0_22.showingShop.id == var1_23.id or arg0_22.showingShop:GetSecondShopId() == var1_23.id then
			triggerToggle(arg2_23, true)
		end

		if arg1_23 == 0 and not table.contains(var1_22, arg0_22.showingShop.id) and not table.contains(var1_22, arg0_22.showingShop:GetSecondShopId()) then
			triggerToggle(arg2_23, true)
		end
	end)
	var2_22:align(#var0_22)
end

function var0_0.SelectFirstShop(arg0_25, arg1_25, arg2_25, arg3_25)
	if arg0_25.currentShop1TgIndex == arg3_25 then
		return
	end

	arg0_25:SetShopPageVisible(true)
	setActive(arg0_25.shop3, false)
	setActive(arg0_25.shop32, false)
	arg1_25:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop1List_Selected")
	setActive(arg1_25:Find("shop2List"), arg2_25.shop_type == 0)

	if arg2_25.shop_type == 0 then
		arg0_25:BindSecondShopList(arg1_25, arg2_25, arg3_25)
	else
		arg0_25.showingShop = arg0_25.shopAgency:GetShopById(arg2_25.id)

		arg0_25:DoUpdateShowingShop()
	end

	arg0_25.currentShop1TgIndex = arg3_25
end

function var0_0.BindFirstShopTab(arg0_26, arg1_26, arg2_26, arg3_26)
	setActive(arg1_26:Find("shop2List"), false)
	GetImageSpriteFromAtlasAsync("island/islandshopicon", arg2_26.tag_icon[3], arg1_26:Find("shop1Tg/selected/icon"), false)
	setText(arg1_26:Find("shop1Tg/name"), arg2_26.tag_icon[1])
	setText(arg1_26:Find("shop1Tg/name/en"), arg2_26.tag_icon[2])
	onToggle(arg0_26, arg1_26:Find("shop1Tg"), function(arg0_27)
		if arg0_27 then
			arg0_26:SelectFirstShop(arg1_26, arg2_26, arg3_26)
		else
			setActive(arg1_26:Find("shop2List"), false)
		end
	end, SFX_PANEL)

	if arg0_26.showingShop.id == arg2_26.id or arg0_26.showingShop:GetFirstShopId() == arg2_26.id then
		triggerToggle(arg1_26:Find("shop1Tg"), true)
	end
end

function var0_0.BindDrawAwardTab(arg0_28, arg1_28, arg2_28)
	setActive(arg1_28:Find("shop2List"), false)
	setText(arg1_28:Find("shop1Tg/name"), i18n("island_draw_tab"))
	setText(arg1_28:Find("shop1Tg/name/en"), i18n("island_draw_tab_en"))
	setActive(arg1_28:Find("shop1Tg/selected/icon"), false)
	onToggle(arg0_28, arg1_28:Find("shop1Tg"), function(arg0_29)
		if arg0_29 then
			if arg0_28.currentShop1TgIndex == arg2_28 then
				return
			end

			arg0_28.currentShop1TgIndex = arg2_28

			arg1_28:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop1List_Selected")
			setText(arg0_28.title:Find("Text"), i18n("island_draw_tab"))
			arg0_28:SetResources()
			arg0_28:SetShopPageVisible(false)
			setActive(arg0_28.shop3, false)
			setActive(arg0_28.shop32, false)
			arg0_28.drawAwardPage:ActionInvoke("UpdateActivity", arg0_28.drawAwardActivity)
			arg0_28.drawAwardPage:ExecuteAction("Show")
		else
			arg0_28.drawAwardPage:ExecuteAction("Hide")
		end
	end, SFX_PANEL)
end

function var0_0.SetShopList(arg0_30)
	arg0_30.currentShop1TgIndex = nil
	arg0_30.currentShop2TgIndex = nil
	arg0_30.currentShop3TgIndex = nil
	arg0_30.drawTabCnt = arg0_30.showDrawAward and arg0_30.drawAwardActivity and 1 or 0
	arg0_30.drawTabIdx = arg0_30.drawTabCnt > 0 and #arg0_30.firstShopConfigs + 1 or nil
	arg0_30.exchangeShowIds = (function()
		if not getProxy(IslandProxy):GetIsland():GetTaskAgency():IsFinishTask(var1_0) then
			return {}
		end

		return pg.island_exchange_group.all
	end)()
	arg0_30.exchangeTabStartIdx = arg0_30.drawTabIdx and arg0_30.drawTabIdx + 1 or #arg0_30.firstShopConfigs + 1

	arg0_30.shop1List:make(function(arg0_32, arg1_32, arg2_32)
		arg1_32 = arg1_32 + 1

		if arg0_32 == UIItemList.EventUpdate then
			local var0_32 = arg0_30.firstShopConfigs[arg1_32]

			if var0_32 then
				arg0_30:BindFirstShopTab(arg2_32, var0_32, arg1_32)
			elseif arg0_30.drawTabIdx and arg1_32 == arg0_30.drawTabIdx then
				arg0_30:BindDrawAwardTab(arg2_32, arg1_32)
			elseif #arg0_30.exchangeShowIds > 0 and arg1_32 >= arg0_30.exchangeTabStartIdx then
				arg0_30:BindExchangeTab(arg2_32, arg1_32)
			end
		end
	end)
	arg0_30.shop1List:align(#arg0_30.firstShopConfigs + arg0_30.drawTabCnt + #arg0_30.exchangeShowIds)
end

function var0_0.SetShopPage(arg0_33)
	local var0_33 = arg0_33.showingShop:GetShowType()

	setText(arg0_33.title:Find("Text"), arg0_33.showingShop:GetShopIcon()[1])
	setText(arg0_33.title:Find("Text/en"), arg0_33.showingShop:GetShopIcon()[2])
	arg0_33:SetResources()
	setActive(arg0_33.recommendationPage1, var0_33 == IslandConst.SHOP_TYPE_RECOMMENDATION_1)
	setActive(arg0_33.recommendationPage5, var0_33 == IslandConst.SHOP_TYPE_RECOMMENDATION_5)
	setActive(arg0_33.shop2DPage, var0_33 == IslandConst.SHOP_TYPE_2D)
	setActive(arg0_33.shop3DPage, var0_33 == IslandConst.SHOP_TYPE_3D)
	setActive(arg0_33.shopFurniturePage, var0_33 == IslandConst.SHOP_TYPE_FURNITURE)
	setActive(arg0_33.shopSkinPage, var0_33 == IslandConst.SHOP_TYPE_SKIN)
	switch(var0_33, {
		[IslandConst.SHOP_TYPE_RECOMMENDATION_1] = function()
			arg0_33:ShowRecommendation1()
		end,
		[IslandConst.SHOP_TYPE_RECOMMENDATION_5] = function()
			arg0_33:ShowRecommendation5()
		end,
		[IslandConst.SHOP_TYPE_2D] = function()
			arg0_33:ShowShop2D()
		end,
		[IslandConst.SHOP_TYPE_3D] = function()
			arg0_33:ShowShop3D()
		end,
		[IslandConst.SHOP_TYPE_FURNITURE] = function()
			arg0_33:ShowShopFurniture()
		end,
		[IslandConst.SHOP_TYPE_SKIN] = function()
			arg0_33:ShowShopSkin()
		end
	})
end

function var0_0.SetResources(arg0_40)
	arg0_40.player = getProxy(PlayerProxy):getRawData()

	local var0_40 = not arg0_40.firstShopConfigs[arg0_40.currentShop1TgIndex]

	setActive(arg0_40.helpBtn, var0_40)

	if var0_40 then
		local var1_40 = {}

		table.insert(var1_40, Drop.New({
			type = DROP_TYPE_VITEM,
			id = arg0_40.drawAwardActivity:GetDrawConfig("cost_free")
		}))
		table.insert(var1_40, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond
		}))
		arg0_40.resourceList:make(function(arg0_41, arg1_41, arg2_41)
			arg1_41 = arg1_41 + 1

			if arg0_41 == UIItemList.EventUpdate then
				local var0_41 = var1_40[arg1_41]
				local var1_41

				eachChild(arg2_41, function(arg0_42, arg1_42)
					setActive(arg0_42, arg0_42.name == "islandItem")

					if arg0_42.name == "islandItem" then
						var1_41 = arg0_42
					end
				end)
				GetImageSpriteFromAtlasAsync(var0_41:getIcon(), "", var1_41:Find("icon"))
				setText(var1_41:Find("Text"), var0_41:getOwnedCount())
				setActive(var1_41:Find("add"), false)
				setActive(var1_41:Find("add"), false)
				setActive(var1_41:Find("descBtn"), false)
				setActive(var1_41:Find("resourceDesc"), false)
			end
		end)
		arg0_40.resourceList:align(#var1_40)

		return
	end

	local var2_40 = arg0_40.showingShop:GetTopResources()

	arg0_40.resourceList:make(function(arg0_43, arg1_43, arg2_43)
		if arg0_43 == UIItemList.EventUpdate then
			local var0_43 = var2_40[arg1_43 + 1]
			local var1_43 = var0_43[1]
			local var2_43 = var0_43[2]
			local var3_43 = var0_43[3]

			setActive(arg2_43:Find("gold"), false)
			setActive(arg2_43:Find("oil"), false)
			setActive(arg2_43:Find("gem"), false)
			setActive(arg2_43:Find("islandItem"), false)

			if var2_43 == DROP_TYPE_RESOURCE then
				if var3_43 == 1 then
					setActive(arg2_43:Find("gold"), true)

					local var4_43 = arg0_40.player:getLevelMaxGold()

					setText(arg2_43:Find("gold/max"), "MAX: " .. var4_43)
					setText(arg2_43:Find("gold/Text"), arg0_40.player.gold)
				elseif var3_43 == 4 or var3_43 == 14 then
					setActive(arg2_43:Find("gem"), true)
					setText(arg2_43:Find("gem/Text"), arg0_40.player:getTotalGem())
				end
			elseif var2_43 == DROP_TYPE_ISLAND_ITEM then
				setActive(arg2_43:Find("islandItem"), true)

				local var5_43 = arg0_40.inventoryAgency:GetOwnCount(var3_43)

				setText(arg2_43:Find("islandItem/Text"), var5_43)
				GetImageSpriteFromAtlasAsync(Drop.New({
					type = DROP_TYPE_ISLAND_ITEM,
					id = var3_43
				}):getIcon(), "", arg2_43:Find("islandItem/icon"))
				setActive(arg2_43:Find("islandItem/descBtn"), var1_43 == 1)
				setActive(arg2_43:Find("islandItem/resourceDesc"), false)

				if var1_43 == 1 then
					local var6_43 = pg.island_item_data_template[var3_43].have_max

					setText(arg2_43:Find("islandItem/Text"), var5_43 .. "/" .. var6_43)
					onButton(arg0_40, arg2_43:Find("islandItem"), function()
						setActive(arg2_43:Find("islandItem/resourceDesc"), not isActive(arg2_43:Find("islandItem/resourceDesc")))
						setText(arg2_43:Find("islandItem/resourceDesc"), i18n("island_3Dshop_res_have") .. var6_43)
					end, SFX_PANEL)
				end
			end
		end
	end)
	arg0_40.resourceList:align(#var2_40)
end

function var0_0.SetResourcesVisible(arg0_45, arg1_45)
	setActive(arg0_45._tf:Find("adapt/top/resources"), arg1_45)
end

function var0_0.SetCloseAndRefresh(arg0_46, arg1_46)
	local var0_46 = 0

	if arg0_46.showingShop:IsNormalShop() then
		local var1_46 = arg0_46.showingShop:GetExistTime()

		if type(var1_46) == "table" then
			local var2_46 = var1_46[2]

			var0_46 = pg.TimeMgr.GetInstance():Table2ServerTime({
				year = var2_46[1][1],
				month = var2_46[1][2],
				day = var2_46[1][3],
				hour = var2_46[2][1],
				min = var2_46[2][2],
				sec = var2_46[2][3]
			})
		end
	elseif arg0_46.showingShop:IsTemporaryShop() then
		var0_46 = arg0_46.showingShop.existTime
	end

	local var3_46 = arg0_46.showingShop.refreshTime
	local var4_46 = arg0_46.showingShop:GetPlayerRefreshResource()

	setActive(arg1_46:Find("remainAndRefresh/remainTimer"), var0_46 ~= 0)
	setActive(arg1_46:Find("remainAndRefresh/refresh"), var3_46 ~= 0)
	setActive(arg1_46:Find("remainAndRefresh/refresh/refreshBtn"), var4_46)
	setActive(arg1_46:Find("remainAndRefresh"), isActive(arg1_46:Find("remainAndRefresh/remainTimer")) or isActive(arg1_46:Find("remainAndRefresh/refresh")))

	local var5_46 = pg.TimeMgr.GetInstance():GetTimeToNextTime()

	if arg0_46.timer then
		arg0_46.timer:Stop()

		arg0_46.timer = nil
	end

	arg0_46.timer = Timer.New(function()
		local var0_47 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_46 ~= 0 then
			local var1_47 = pg.TimeMgr.GetInstance():DescCDTime(var0_46 - var0_47)

			setText(arg1_46:Find("remainAndRefresh/remainTimer"), i18n("island_3Dshop_time_close", var1_47))
		elseif normalShopExistTime and type(normalShopExistTime) == "table" then
			-- block empty
		end

		if var3_46 ~= 0 then
			local var2_47 = pg.TimeMgr.GetInstance():DescCDTime(var3_46 - var0_47)

			setText(arg1_46:Find("remainAndRefresh/refresh/refreshTimer"), i18n("island_3Dshop_time_refresh", var2_47))

			if var0_47 > var3_46 then
				arg0_46:DoUpdateShowingShop()
			end
		end

		if var3_46 == 0 and var4_46 and var0_47 > var5_46 then
			arg0_46:DoUpdateShowingShop()
		end
	end, 1, -1)

	arg0_46.timer:Start()

	if var4_46 then
		onButton(arg0_46, arg1_46:Find("remainAndRefresh/refresh/refreshBtn/button"), function()
			local var0_48 = arg0_46.showingShop.refreshCount

			if var0_48 < arg0_46.showingShop:GetMaxRefreshCount() then
				local var1_48 = arg0_46.showingShop:GetFirstRefreshFree()
				local var2_48 = var4_46[3]

				if var1_48 and var0_48 == 0 then
					var4_46[3] = 0
					var2_48 = 0
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					noText = "text_cancel",
					hideNo = false,
					yesText = "text_confirm",
					content = i18n("refresh_shopStreet_question", i18n("word_" .. id2res(var4_46[2]) .. "_icon"), var2_48, var0_48),
					onYes = function()
						arg0_46:emit(IslandMediator.REFRESH_SHOP_BY_PLAYER, arg0_46.showingShop.id, var4_46)
					end
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_3Dshop_refresh_limit"))
			end
		end, SFX_PANEL)
	end
end

function var0_0.IsCommodityInShoppingCart(arg0_50, arg1_50)
	for iter0_50, iter1_50 in ipairs(arg0_50.shoppingCartCommodities) do
		if iter1_50.id == arg1_50.id then
			return true
		end
	end

	return false
end

function var0_0.IsCommodityDisabled(arg0_51, arg1_51)
	return isActive(arg1_51:Find("sellOut")) or isActive(arg1_51:Find("hold")) or isActive(arg1_51:Find("notInTime"))
end

function var0_0.OpenShoppingCart(arg0_52)
	arg0_52.myIslandShoppingCartLayer = arg0_52:OpenPage(IslandShoppingCartLayer, arg0_52.shoppingCartCommodities)
end

function var0_0.RefreshShopSkinCartButtons(arg0_53)
	setActive(arg0_53.shopSkinPage:Find("cancelBtn"), #arg0_53.shoppingCartCommodities > 0)
	setActive(arg0_53.shopSkinPage:Find("shoppingCartBtn"), #arg0_53.shoppingCartCommodities > 0)
	setActive(arg0_53.shopSkinPage:Find("shoppingCartBtn/count"), arg0_53.showingShop:GetCommanderOrCharaType() == 1)
end

function var0_0.ResetShopSkinCartPreview(arg0_54)
	local var0_54 = arg0_54.shoppingCartCommodities and arg0_54.shoppingCartCommodities[1]

	arg0_54.shoppingCartCommodities = {}
	arg0_54.showingCommodity = nil

	if var0_54 and arg0_54:IsCommanderDressCommodity(var0_54) then
		arg0_54:ResetCommanderDressPreview(true)
	else
		arg0_54:ResetCommanderDressPreview(false)
		arg0_54.islandShipDressHelper:ResetDressUp()
	end
end

function var0_0.BindShopSkinCartButtons(arg0_55, arg1_55)
	if #arg0_55.shoppingCartCommodities <= 0 then
		return
	end

	onButton(arg0_55, arg0_55.shopSkinPage:Find("cancelBtn"), function()
		if arg1_55 then
			arg1_55()
		else
			arg0_55:ResetShopSkinCartPreview()
		end

		setActive(arg0_55.shopSkinPage:Find("cancelBtn"), false)
		setActive(arg0_55.shopSkinPage:Find("shoppingCartBtn"), false)
		setText(arg0_55.shopSkinPage:Find("shoppingCartBtn/count"), "0/3")
		arg0_55:SetCommodityList()
	end, SFX_PANEL)
	onButton(arg0_55, arg0_55.shopSkinPage:Find("shoppingCartBtn"), function()
		arg0_55:OpenShoppingCart()
	end, SFX_PANEL)
end

function var0_0.IsDressCommodityExclusive(arg0_58, arg1_58)
	local var0_58 = arg0_58.characterAgency:GetShipById(arg0_58.showingShipId)
	local var1_58 = var0_58:GetCurrentSkinId()
	local var2_58 = pg.island_dress_template[arg1_58:GetItems()[1][2]]

	if var1_58 ~= 0 then
		local var3_58 = var2_58.exclusive_skin

		if var3_58 ~= "" then
			for iter0_58, iter1_58 in ipairs(var3_58) do
				if iter1_58 == var1_58 then
					return true, var2_58
				end
			end
		end
	else
		local var4_58 = var2_58.exclusive_default_skin

		if var4_58 ~= "" then
			for iter2_58, iter3_58 in ipairs(var4_58) do
				if iter3_58 == var0_58.id then
					return true, var2_58
				end
			end
		end
	end

	return false, var2_58
end

function var0_0.IsCommanderDressCommodity(arg0_59, arg1_59)
	local var0_59 = arg1_59:GetItems()

	if #var0_59 == 0 or var0_59[1][1] ~= DROP_TYPE_ISLAND_DRESS then
		return false
	end

	local var1_59 = pg.island_dress_template[var0_59[1][2]]

	return var1_59 and var1_59.belongto == 1
end

function var0_0.CacheCommanderDressPreviewData(arg0_60)
	if arg0_60.commanderDressPreviewData then
		return
	end

	local var0_60 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()

	arg0_60.commanderDressPreviewData = {}

	for iter0_60, iter1_60 in pairs(IslandShipDressHelperNew.CommanderCustom) do
		local var1_60 = var0_60:GetDressByType(iter1_60) or 0

		arg0_60.commanderDressPreviewData[iter1_60] = {
			id = var1_60,
			colorId = var0_60:GetCurrentColorByDressId(var1_60)
		}
	end
end

function var0_0.RestoreCommanderDressPreview(arg0_61)
	if not arg0_61.commanderDressPreviewData then
		return
	end

	local var0_61 = arg0_61.commanderDressPreviewData

	for iter0_61, iter1_61 in ipairs(IslandShipDressHelperNew.CommanderCustom) do
		local var1_61 = var0_61[iter1_61]

		if var1_61 then
			arg0_61.islandShipDressHelper:ChangeDressByType(iter1_61, var1_61)
		end
	end

	arg0_61.commanderDressPreviewData = nil
end

function var0_0.ResetCommanderDressPreview(arg0_62, arg1_62, arg2_62)
	if arg1_62 then
		arg0_62:RestoreCommanderDressPreview()
	else
		arg0_62.commanderDressPreviewData = nil

		if arg2_62 then
			arg0_62.islandShipDressHelper:InvalidateRole()
		end
	end

	arg0_62:SetMorphBlock(false)
	setActive(arg0_62.morphBtn, false)
end

function var0_0.ChangeDressByCommodityItems(arg0_63, arg1_63)
	for iter0_63, iter1_63 in ipairs(arg1_63:GetItems()) do
		local var0_63

		if iter1_63[1] == DROP_TYPE_ISLAND_DRESS then
			local var1_63 = pg.island_dress_template[iter1_63[2]]

			if var1_63 then
				var0_63 = var1_63.type
			end
		end

		arg0_63.islandShipDressHelper:ChangeDressByType(var0_63, {
			colorId = 0,
			id = iter1_63[2]
		})
	end
end

function var0_0.ToggleDressSuitCommodity(arg0_64, arg1_64)
	arg0_64:ResetCommanderDressPreview(false)

	arg0_64.showingCommodity = nil

	if #arg0_64.shoppingCartCommodities == 1 and arg0_64.shoppingCartCommodities[1].id == arg1_64.id then
		arg0_64.shoppingCartCommodities = {}

		arg0_64.islandShipDressHelper:ResetDressUp()
	else
		arg0_64.shoppingCartCommodities = {
			arg1_64
		}

		arg0_64:ChangeDressByCommodityItems(arg1_64)
	end

	setText(arg0_64.shopSkinPage:Find("shoppingCartBtn/count"), (#arg0_64.shoppingCartCommodities > 0 and #arg1_64:GetDisplayItems() or 0) .. "/3")
end

function var0_0.ChangeCommanderDressByCommodity(arg0_65, arg1_65)
	arg0_65:CacheCommanderDressPreviewData()

	for iter0_65, iter1_65 in ipairs(arg1_65:GetDisplayItems()) do
		if iter1_65[1] == DROP_TYPE_ISLAND_DRESS then
			local var0_65 = pg.island_dress_template[iter1_65[2]]

			if var0_65 then
				local var1_65 = iter1_65[2]

				if var0_65.type == IslandShipDressHelperNew.DressType.Body then
					local var2_65 = getProxy(IslandProxy):GetIsland():GetDressUpAgency():GetTwinCurId(var1_65)

					if var2_65 and var2_65 ~= 0 then
						var1_65 = var2_65
					end
				end

				arg0_65.islandShipDressHelper:ChangeDressByType(var0_65.type, {
					colorId = 0,
					id = var1_65
				})
				arg0_65:CheckCommanderHatState(var0_65.type, var1_65)
				arg0_65:CheckCommanderMorphBtn(var0_65.type, var1_65)
			end
		end
	end
end

function var0_0.CheckCommanderHatState(arg0_66, arg1_66, arg2_66)
	if arg1_66 ~= IslandShipDressHelperNew.DressType.Body then
		return
	end

	local var0_66 = (pg.island_dress_template.get_id_list_by_related_dress[arg2_66] or {})[1]

	if not var0_66 or var0_66 == 0 then
		arg0_66.islandShipDressHelper:ChangeDressByType(IslandShipDressHelperNew.DressType.Hat, {
			id = 0,
			colorId = 0
		})
	elseif var0_66 and var0_66 ~= 0 then
		arg0_66.islandShipDressHelper:ChangeDressByType(IslandShipDressHelperNew.DressType.Hat, {
			colorId = 0,
			id = var0_66
		})
	end
end

function var0_0.CheckCommanderMorphBtn(arg0_67, arg1_67, arg2_67)
	if arg1_67 ~= IslandShipDressHelperNew.DressType.Body then
		return
	end

	local var0_67 = arg2_67
	local var1_67 = 0
	local var2_67 = pg.island_dress_template[var0_67].cloth_related

	if var2_67 and var2_67 ~= 0 then
		var1_67 = var2_67
	end

	if var1_67 == 0 then
		setActive(arg0_67.morphBtn, false)

		return
	end

	setActive(arg0_67.morphBtn, true)
	onButton(arg0_67, arg0_67.morphBtn, function()
		arg0_67:DoMorphSwitch(var0_67, var1_67)
	end)
end

function var0_0.DoMorphSwitch(arg0_69, arg1_69, arg2_69)
	if arg0_69.morphing then
		return
	end

	arg0_69:SetMorphBlock(true)

	if not arg0_69.islandShipDressHelper then
		arg0_69:DoSwitch(arg2_69, function()
			arg0_69:SetMorphBlock(false)
		end)

		return
	end

	arg0_69.islandShipDressHelper:DoMorphSwitch(arg1_69, arg2_69, function()
		arg0_69:DoSwitch(arg2_69, function()
			arg0_69:SetMorphBlock(false)
		end)
	end)
end

function var0_0.DoSwitch(arg0_73, arg1_73, arg2_73)
	local var0_73 = IslandShipDressHelperNew.DressType.Body

	arg0_73.islandShipDressHelper:ChangeDressByType(var0_73, {
		colorId = 0,
		id = arg1_73
	}, arg2_73)
	arg0_73:CheckCommanderHatState(IslandShipDressHelperNew.DressType.Body, arg1_73)
	arg0_73:CheckCommanderMorphBtn(var0_73, arg1_73)
end

function var0_0.SetMorphBlock(arg0_74, arg1_74)
	arg0_74.morphing = arg1_74

	setActive(arg0_74.morphBlocker, arg1_74)
end

function var0_0.ToggleCommanderDressCommodity(arg0_75, arg1_75)
	if #arg0_75.shoppingCartCommodities == 1 and arg0_75.shoppingCartCommodities[1].id == arg1_75.id then
		arg0_75.shoppingCartCommodities = {}

		arg0_75:ResetCommanderDressPreview(true)
	else
		arg0_75.shoppingCartCommodities = {
			arg1_75
		}

		arg0_75:ChangeCommanderDressByCommodity(arg1_75)
	end

	setText(arg0_75.shopSkinPage:Find("shoppingCartBtn/count"), (#arg0_75.shoppingCartCommodities > 0 and #arg1_75:GetDisplayItems() or 0) .. "/3")
end

function var0_0.RemoveSameDressTypeCommodity(arg0_76, arg1_76)
	local var0_76 = 0

	for iter0_76, iter1_76 in ipairs(arg0_76.shoppingCartCommodities) do
		if iter1_76:GetDressType() == arg1_76:GetDressType() then
			var0_76 = iter1_76.id

			table.remove(arg0_76.shoppingCartCommodities, iter0_76)

			break
		end
	end

	return var0_76
end

function var0_0.ToggleSingleDressCommodity(arg0_77, arg1_77)
	local var0_77, var1_77 = arg0_77:IsDressCommodityExclusive(arg1_77)

	if var0_77 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_mutually_exclusive1", var1_77.name))

		return false
	end

	arg0_77:ResetCommanderDressPreview(false)

	arg0_77.showingCommodity = nil

	if #arg0_77.shoppingCartCommodities > 0 and #arg0_77.shoppingCartCommodities[1]:GetItems() > 1 then
		arg0_77.shoppingCartCommodities = {}

		arg0_77.islandShipDressHelper:ResetDressUp()
	end

	local var2_77 = arg0_77:RemoveSameDressTypeCommodity(arg1_77)

	if arg1_77.id == var2_77 then
		arg0_77.islandShipDressHelper:ChangeDressByType(arg1_77:GetDressType(), {
			id = 0,
			colorId = 0
		})
	else
		table.insert(arg0_77.shoppingCartCommodities, arg1_77)
		arg0_77.islandShipDressHelper:ChangeDressByType(arg1_77:GetDressType(), {
			colorId = 0,
			id = arg1_77:GetItems()[1][2]
		})
	end

	setText(arg0_77.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_77.shoppingCartCommodities .. "/3")

	return true
end

function var0_0.HandleDressCommodity(arg0_78, arg1_78)
	if arg0_78:IsCommanderDressCommodity(arg1_78) then
		arg0_78:ToggleCommanderDressCommodity(arg1_78)
	elseif #arg1_78:GetItems() > 1 then
		arg0_78:ToggleDressSuitCommodity(arg1_78)
	elseif not arg0_78:ToggleSingleDressCommodity(arg1_78) then
		return
	end

	arg0_78:RefreshShopSkinCartButtons()
	arg0_78:BindShopSkinCartButtons()
	arg0_78:SetCommodityList()
end

function var0_0.HandleFurnitureCommodity(arg0_79, arg1_79)
	arg0_79:ResetCommanderDressPreview(false, true)

	if arg0_79.showingCommodity ~= arg1_79 then
		arg0_79.showingCommodity = arg1_79
		arg0_79.shoppingCartCommodities = {
			arg1_79
		}

		arg0_79:LoadFurniture(arg1_79:GetModel(), arg1_79:GetModelParam())
		setActive(arg0_79.shopFurniturePage:Find("scenePreviewBtn"), false)
		setActive(arg0_79.shopFurniturePage:Find("shoppingCartBtn"), true)

		if #arg1_79:GetItems() == 1 then
			onButton(arg0_79, arg0_79.shopFurniturePage:Find("scenePreviewBtn"), function()
				setActive(arg0_79._tf, false)
				arg0_79:ClearCharacterScene()
				arg0_79:emit(IslandMediator.PREVIEW_FURNITURE, arg1_79:GetItems()[1][2])
			end, SFX_PANEL)
		end

		onButton(arg0_79, arg0_79.shopFurniturePage:Find("shoppingCartBtn"), function()
			arg0_79:OpenShoppingCart()
		end, SFX_PANEL)
	else
		arg0_79.showingCommodity = nil
		arg0_79.shoppingCartCommodities = {}

		arg0_79:UnloadCharacter()
		setActive(arg0_79.shopFurniturePage:Find("scenePreviewBtn"), false)
		setActive(arg0_79.shopFurniturePage:Find("shoppingCartBtn"), false)
	end

	arg0_79:SetCommodityList()
end

function var0_0.HandleSkinCommodity(arg0_82, arg1_82)
	arg0_82:ResetCommanderDressPreview(false, true)

	if arg0_82.showingCommodity ~= arg1_82 then
		arg0_82.showingCommodity = arg1_82
		arg0_82.shoppingCartCommodities = {
			arg1_82
		}

		local var0_82 = pg.island_skin_template[arg1_82:GetItems()[1][2]].model
		local var1_82 = pg.island_unit_character[var0_82]

		arg0_82:LoadCharacter(var1_82, false)
	else
		arg0_82.showingCommodity = nil
		arg0_82.shoppingCartCommodities = {}

		arg0_82:UnloadCharacter()
	end

	setActive(arg0_82.shopSkinPage:Find("cancelBtn"), false)
	setActive(arg0_82.shopSkinPage:Find("shoppingCartBtn"), #arg0_82.shoppingCartCommodities > 0)
	setActive(arg0_82.shopSkinPage:Find("shoppingCartBtn/count"), false)
	setText(arg0_82.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_82.shoppingCartCommodities .. "/3")
	arg0_82:BindShopSkinCartButtons(function()
		arg0_82.shoppingCartCommodities = {}

		local var0_83 = arg0_82.characterAgency:GetShipById(arg0_82.showingShipId):GetModel()

		arg0_82:LoadCharacter(var0_83, false)
	end)
	arg0_82:SetCommodityList()
end

function var0_0.SetCommodity(arg0_84, arg1_84, arg2_84)
	var0_0.StaticUpdateCommodityTpl(arg1_84, arg2_84)
	setActive(arg1_84:Find("notInTime"), not arg0_84.showingShop:IsInTime())
	setActive(arg1_84:Find("select"), arg0_84:IsCommodityInShoppingCart(arg2_84))

	if arg0_84:IsCommodityDisabled(arg1_84) then
		removeOnButton(arg1_84)
	else
		onButton(arg0_84, arg1_84, function()
			switch(arg2_84:GetCommodityShowType(), {
				[IslandConst.COMMODITY_SHOW_ITEM] = function()
					arg0_84.myIslandShopItemLayer = arg0_84:OpenPage(IslandShopItemLayer, arg0_84.showingShop.id, arg2_84)
				end,
				[IslandConst.COMMODITY_SHOW_DRESS] = function()
					arg0_84:HandleDressCommodity(arg2_84)
				end,
				[IslandConst.COMMODITY_SHOW_FURNITURE] = function()
					arg0_84:HandleFurnitureCommodity(arg2_84)
				end,
				[IslandConst.COMMODITY_SHOW_SKIN] = function()
					arg0_84:HandleSkinCommodity(arg2_84)
				end,
				[IslandConst.COMMODITY_SHOW_INVITE] = function()
					local var0_90 = arg2_84:GetItems()[1][2]

					arg0_84.myIslandShopItemLayer = arg0_84:OpenPage(IslandShopItemLayer, arg0_84.showingShop.id, arg2_84, var0_90)
				end
			})
		end, SFX_PANEL)
	end
end

function var0_0.SetCommodityList(arg0_91)
	local var0_91 = arg0_91.showingShop:GetShowType()
	local var1_91 = switch(var0_91, {
		[IslandConst.SHOP_TYPE_2D] = function()
			return UIItemList.New(arg0_91.shop2DPage:Find("shopView/Viewport/Content"), arg0_91.shop2DPage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end,
		[IslandConst.SHOP_TYPE_3D] = function()
			return UIItemList.New(arg0_91.shop3DPage:Find("shopView/Viewport/Content"), arg0_91.shop3DPage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end,
		[IslandConst.SHOP_TYPE_FURNITURE] = function()
			return UIItemList.New(arg0_91.shopFurniturePage:Find("shopView/Viewport/Content"), arg0_91.shopFurniturePage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end,
		[IslandConst.SHOP_TYPE_SKIN] = function()
			return UIItemList.New(arg0_91.shopSkinPage:Find("shopView/Viewport/Content"), arg0_91.shopSkinPage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end
	})
	local var2_91 = arg0_91.showingShop:GetCommodities()

	var0_0.SortShopCommodities(var2_91)
	var1_91:make(function(arg0_96, arg1_96, arg2_96)
		if arg0_96 == UIItemList.EventUpdate then
			local var0_96 = var2_91[arg1_96 + 1]

			arg0_91:SetCommodity(arg2_96, var0_96)
		end
	end, SFX_PANEL)
	var1_91:align(#var2_91)
end

function var0_0.ShowRecommendation5(arg0_97)
	arg0_97:ClearCharacterScene()
	arg0_97:OverlayPanel(arg0_97._tf, {
		pbList = {
			arg0_97.bg
		}
	})
	setActive(arg0_97.bgColor, true)

	arg0_97.shoppingCartCommodities = {}
	arg0_97.showingCommodity = nil

	arg0_97:ResetCommanderDressPreview(false)

	local var0_97 = arg0_97.showingShop:GetBanners()
	local var1_97 = arg0_97.recommendationPage5:Find("banners")

	for iter0_97 = 1, #var0_97 do
		local var2_97 = var0_97[iter0_97]
		local var3_97 = var1_97:Find("banner" .. var2_97.id)

		if var3_97 then
			GetImageSpriteFromAtlasAsync("activitybanner/" .. var2_97.pic, "", var3_97)
			onButton(arg0_97, var3_97, function()
				arg0_97:JumpToRecommendationShop(var2_97.param)
			end, SFX_PANEL)
		end
	end
end

function var0_0.ShowRecommendation1(arg0_99)
	arg0_99:ClearCharacterScene()
	arg0_99:OverlayPanel(arg0_99._tf, {
		pbList = {
			arg0_99.bg
		}
	})
	setActive(arg0_99.bgColor, true)

	arg0_99.shoppingCartCommodities = {}
	arg0_99.showingCommodity = nil

	arg0_99:ResetCommanderDressPreview(false)

	local var0_99 = arg0_99.showingShop:GetBanners()
	local var1_99 = arg0_99.recommendationPage1:Find("banners")

	for iter0_99 = 1, #var0_99 do
		local var2_99 = var0_99[iter0_99]
		local var3_99 = var1_99:Find("banner" .. var2_99.id)

		if var3_99 then
			GetImageSpriteFromAtlasAsync("activitybanner/" .. var2_99.pic, "", var3_99)
			onButton(arg0_99, var3_99, function()
				arg0_99:JumpToRecommendationShop(var2_99.param)
			end, SFX_PANEL)
		end
	end
end

function var0_0.ShowShop2D(arg0_101)
	arg0_101:ClearCharacterScene()
	arg0_101:OverlayPanel(arg0_101._tf, {
		pbList = {
			arg0_101.bg
		}
	})
	setActive(arg0_101.bgColor, true)

	arg0_101.shoppingCartCommodities = {}
	arg0_101.showingCommodity = nil

	arg0_101:ResetCommanderDressPreview(false)

	local var0_101 = arg0_101.showingShop:IsInTime()

	setActive(arg0_101.shop2DPage:Find("lock"), not var0_101)

	if var0_101 then
		arg0_101:SetCloseAndRefresh(arg0_101.shop2DPage)
	else
		setActive(arg0_101.shop2DPage:Find("remainAndRefresh"), false)

		if arg0_101.timer then
			arg0_101.timer:Stop()

			arg0_101.timer = nil
		end

		arg0_101.timer = Timer.New(function()
			local var0_102 = arg0_101.showingShop:GetExistTime()[1]
			local var1_102 = pg.TimeMgr.GetInstance():Table2ServerTime({
				year = var0_102[1][1],
				month = var0_102[1][2],
				day = var0_102[1][3],
				hour = var0_102[2][1],
				min = var0_102[2][2],
				sec = var0_102[2][3]
			})
			local var2_102 = pg.TimeMgr.GetInstance():GetServerTime()
			local var3_102 = pg.TimeMgr.GetInstance():DescCDTime(var1_102 - var2_102)

			setText(arg0_101.shop2DPage:Find("lock/openTimer"), i18n("island_3Dshop_time_unlock", var3_102))
		end, 1, -1)

		arg0_101.timer:Start()
	end

	arg0_101:SetCommodityList()
end

function var0_0.ShowShop3D(arg0_103)
	arg0_103:ClearCharacterScene()
	arg0_103:OverlayPanel(arg0_103._tf, {
		pbList = {
			arg0_103.shop3DPage:Find("bg")
		}
	})
	setActive(arg0_103.bgColor, false)

	arg0_103.shoppingCartCommodities = {}
	arg0_103.showingCommodity = nil

	arg0_103:ResetCommanderDressPreview(false)
	arg0_103:SetCloseAndRefresh(arg0_103.shop3DPage)
	arg0_103:SetCommodityList()
end

function var0_0.ShowShopFurniture(arg0_104)
	if not arg0_104.isLoadCharacterScene then
		arg0_104:PrepareCharacterScene()
	end

	arg0_104:OverlayPanel(arg0_104._tf, {
		pbList = {
			arg0_104.shopFurniturePage:Find("bg")
		}
	})
	setActive(arg0_104.bgColor, false)
	arg0_104:UnloadCharacter()

	arg0_104.shoppingCartCommodities = {}
	arg0_104.showingCommodity = nil

	arg0_104:ResetCommanderDressPreview(false)
	arg0_104:SetCloseAndRefresh(arg0_104.shopFurniturePage)
	arg0_104:SetCommodityList()
	setActive(arg0_104.shopFurniturePage:Find("scenePreviewBtn"), false)
	setActive(arg0_104.shopFurniturePage:Find("shoppingCartBtn"), false)
end

function var0_0.ShowShopSkin(arg0_105)
	if not arg0_105.isLoadCharacterScene then
		arg0_105:PrepareCharacterScene()
	end

	arg0_105:OverlayPanel(arg0_105._tf, {
		pbList = {
			arg0_105.shopSkinPage:Find("bg"),
			arg0_105.changeCharaPanel
		}
	})
	setActive(arg0_105.bgColor, false)

	if not arg0_105.shoppingCartCommodities then
		arg0_105.shoppingCartCommodities = {}
	end

	if #arg0_105.shoppingCartCommodities > 0 then
		local var0_105 = arg0_105.shoppingCartCommodities[1]:GetCommodityShowType()

		if var0_105 == IslandConst.COMMODITY_SHOW_FURNITURE or var0_105 == IslandConst.COMMODITY_SHOW_SKIN then
			arg0_105.shoppingCartCommodities = {}
			arg0_105.showingCommodity = nil

			arg0_105:ResetCommanderDressPreview(false, true)
		end
	end

	local var1_105 = arg0_105.showingShop:GetCommanderOrCharaType()

	if var1_105 == 0 and (arg0_105.showingShipId ~= 0 or #arg0_105.shoppingCartCommodities == 0) then
		arg0_105.showingShipId = 0

		local var2_105 = pg.island_unit_character[0]

		arg0_105:LoadCharacter({
			model = var2_105.model,
			animator = var2_105.animator
		}, true)

		arg0_105.shoppingCartCommodities = {}
		arg0_105.showingCommodity = nil

		arg0_105:ResetCommanderDressPreview(false)
	elseif var1_105 == 1 and (arg0_105.showingShipId ~= arg0_105.selectShipId or #arg0_105.shoppingCartCommodities == 0) then
		arg0_105:ResetCommanderDressPreview(false, true)

		arg0_105.showingShipId = arg0_105.selectShipId

		local var3_105 = arg0_105.characterAgency:GetShipById(arg0_105.showingShipId):GetModel()

		arg0_105:LoadCharacter(var3_105, false)

		arg0_105.shoppingCartCommodities = {}
		arg0_105.showingCommodity = nil

		arg0_105:ResetCommanderDressPreview(false)
	elseif var1_105 == 2 then
		arg0_105:ResetCommanderDressPreview(false, true)

		arg0_105.showingShipId = arg0_105.selectShipId

		arg0_105:UnloadCharacter()

		arg0_105.shoppingCartCommodities = {}
		arg0_105.showingCommodity = nil

		arg0_105:ResetCommanderDressPreview(false)
	end

	arg0_105:SetCloseAndRefresh(arg0_105.shopSkinPage)
	arg0_105:SetCommodityList()
	setActive(arg0_105.shopSkinPage:Find("cancelBtn"), #arg0_105.shoppingCartCommodities > 0)
	setActive(arg0_105.shopSkinPage:Find("changeCharaBtn"), var1_105 == 1)
	setActive(arg0_105.shopSkinPage:Find("shoppingCartBtn"), #arg0_105.shoppingCartCommodities > 0)
	setActive(arg0_105.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_105.shoppingCartCommodities > 0 and var1_105 == 1)
	setText(arg0_105.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_105.shoppingCartCommodities .. "/3")
	setActive(arg0_105.shopSkinPage:Find("changeCharaPanel"), false)
	arg0_105:SetChangeCharaPanel()
	onButton(arg0_105, arg0_105.shopSkinPage:Find("changeCharaBtn"), function()
		setActive(arg0_105.shopSkinPage:Find("changeCharaPanel"), true)
	end, SFX_PANEL)
end

function var0_0.SetChangeCharaPanel(arg0_107)
	onButton(arg0_107, arg0_107.shopSkinPage:Find("changeCharaPanel/bg"), function()
		setActive(arg0_107.shopSkinPage:Find("changeCharaPanel"), false)
	end, SFX_PANEL)
	onButton(arg0_107, arg0_107.changeCharaPanel:Find("closeBtn"), function()
		setActive(arg0_107.shopSkinPage:Find("changeCharaPanel"), false)
	end, SFX_PANEL)

	local var0_107 = UIItemList.New(arg0_107.changeCharaPanel:Find("charaScroll/Viewport/Content"), arg0_107.changeCharaPanel:Find("charaScroll/Viewport/Content/IslandShipTpl"))

	var0_107:make(function(arg0_110, arg1_110, arg2_110)
		if arg0_110 == UIItemList.EventUpdate then
			local var0_110 = arg0_107.ships[arg1_110 + 1]
			local var1_110 = IslandShip.StaticGetPrefab(var0_110.id)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_110, "", arg2_110:Find("mask/icon"))
			setText(arg2_110:Find("Text"), "Lv." .. var0_110:GetLevel())
			setActive(arg2_110:Find("add"), false)
			setActive(arg2_110:Find("select"), var0_110.id == arg0_107.selectShipId)
			onButton(arg0_107, arg2_110, function()
				if arg0_107.charaSetModel == var0_0.CharaSetModel.current then
					arg0_107:ResetCommanderDressPreview(false, true)

					arg0_107.selectShipId = var0_110.id
					arg0_107.showingShipId = var0_110.id

					arg0_107:LoadCharacter(var0_110:GetModel(), false)

					arg0_107.shoppingCartCommodities = {}
					arg0_107.showingCommodity = nil

					setActive(arg0_107.shopSkinPage:Find("cancelBtn"), false)
					setActive(arg0_107.shopSkinPage:Find("shoppingCartBtn"), false)
					setText(arg0_107.shopSkinPage:Find("shoppingCartBtn/count"), "0/3")
					arg0_107:SetCommodityList()
				elseif arg0_107.charaSetModel == var0_0.CharaSetModel.default then
					arg0_107.defaultShipId = var0_110.id

					PlayerPrefs.SetInt("island_dressShop_defaultShipId_" .. arg0_107.player.id, var0_110.id)
				end

				for iter0_111 = 0, arg0_107.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
					setActive(arg0_107.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter0_111):Find("select"), iter0_111 == arg1_110)
				end
			end, SFX_PANEL)
		end
	end)
	var0_107:align(#arg0_107.ships)

	arg0_107.charaSetModel = var0_0.CharaSetModel.current

	onButton(arg0_107, arg0_107.changeCharaPanel:Find("defaultSet"), function()
		if arg0_107.charaSetModel == var0_0.CharaSetModel.current then
			arg0_107.charaSetModel = var0_0.CharaSetModel.default

			for iter0_112 = 0, arg0_107.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
				setActive(arg0_107.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter0_112):Find("select"), arg0_107.ships[iter0_112 + 1].id == arg0_107.defaultShipId)
			end
		elseif arg0_107.charaSetModel == var0_0.CharaSetModel.default then
			arg0_107.charaSetModel = var0_0.CharaSetModel.current

			for iter1_112 = 0, arg0_107.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
				setActive(arg0_107.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter1_112):Find("select"), arg0_107.ships[iter1_112 + 1].id == arg0_107.selectShipId)
			end
		end

		setActive(arg0_107.changeCharaPanel:Find("defaultSet/off"), arg0_107.charaSetModel == var0_0.CharaSetModel.current)
		setActive(arg0_107.changeCharaPanel:Find("defaultSet/on"), arg0_107.charaSetModel == var0_0.CharaSetModel.default)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_113)
	arg0_113:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_113.UpdateView)
	arg0_113:AddListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_113.OnSwitchMapByPoint)
	arg0_113:AddListener(ActivityProxy.ACTIVITY_UPDATED, arg0_113.UpdateActivity)
	arg0_113:AddListener(GAME.ACTIVITY_DRAW_AWARD_OPERATION_DONE, arg0_113.DrawOperation)
	arg0_113:AddListener(GAME.ISLAND_EXCHANGE_ITEM_DONE, arg0_113.OnExchangeDone)
end

function var0_0.RemoveListeners(arg0_114)
	arg0_114:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_114.UpdateView)
	arg0_114:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_114.OnSwitchMapByPoint)
	arg0_114:RemoveListener(ActivityProxy.ACTIVITY_UPDATED, arg0_114.UpdateActivity)
	arg0_114:RemoveListener(GAME.ACTIVITY_DRAW_AWARD_OPERATION_DONE, arg0_114.DrawOperation)
	arg0_114:RemoveListener(GAME.ISLAND_EXCHANGE_ITEM_DONE, arg0_114.OnExchangeDone)
end

function var0_0.UpdateView(arg0_115, arg1_115)
	if arg1_115.operation == IslandConst.SHOP_GET_DATA then
		if arg1_115.refreshAll then
			arg0_115:UpdateData()
			arg0_115:SetShopList()
		else
			arg0_115:SetShopPage()
		end
	elseif arg1_115.operation == IslandConst.SHOP_BUY_COMMODITY then
		arg0_115.shoppingCartCommodities = {}

		arg0_115:SetShopPage()

		if arg0_115.myIslandShoppingCartLayer then
			arg0_115.myIslandShoppingCartLayer:Hide()
		end

		arg0_115:OpenPage(IslandShopBuySuccessLayer, arg1_115.awards, function()
			if arg0_115.showingShop:GetShowType() == IslandConst.SHOP_TYPE_SKIN then
				arg0_115:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_3Dshop_clothes_jump"),
					onYes = function()
						arg0_115:ClearCharacterScene(function()
							arg0_115:Hide()

							local var0_118 = arg0_115.showingShop:GetCommanderOrCharaType()

							if var0_118 == 0 then
								arg0_115:OpenScenePage(IslandShipIslandCommanderMainPage)
							elseif var0_118 == 1 or var0_118 == 2 then
								arg0_115:OpenScenePage(IslandShipMainPage, 3)
							end
						end)
					end
				})
			end
		end)

		if arg0_115.myIslandShopItemLayer then
			arg0_115.myIslandShopItemLayer:Refresh()
		end
	elseif arg1_115.operation == IslandConst.REFRESH_SHOP_BY_PLAYER then
		arg0_115:SetShopPage()
	end
end

function var0_0.OnSwitchMapByPoint(arg0_119)
	setActive(arg0_119._tf, true)
	arg0_119:PrepareCharacterScene()
end

function var0_0.UpdateActivity(arg0_120, arg1_120)
	if arg1_120:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ISLAND_DRAW_AWARD then
		arg0_120.drawAwardActivity = arg1_120

		arg0_120.drawAwardPage:ActionInvoke("UpdateActivity", arg0_120.drawAwardActivity)
		arg0_120:SetResources()
	end
end

function var0_0.DrawOperation(arg0_121, arg1_121)
	arg0_121.drawAwardPage:ActionInvoke("DrawOperation", arg1_121)
end

function var0_0.Preload(arg0_122, arg1_122)
	arg1_122()
end

function var0_0.GetSmoothRotateObject(arg0_123)
	return arg0_123._tf:Find("adapt/model")
end

function var0_0.LoadFurniture(arg0_124, arg1_124, arg2_124)
	arg0_124:UnloadCharacter()

	if arg0_124.isLoadingModel then
		return
	end

	arg0_124.isLoadingModel = true

	local var0_124 = IslandAssetLoadDispatcher.Instance:Enqueue(arg1_124, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_125)
		arg0_124.role = Object.Instantiate(arg0_125)

		local var0_125 = arg0_124.role.name
		local var1_125 = GameObject.New(var0_125)

		setParent(arg0_124.role, var1_125.transform, false)

		arg0_124.role = var1_125
		arg0_124.isLoadingModel = false

		pg.ViewUtils.SetLayer(arg0_124.role.transform, Layer.Character3D)
		setParent(arg0_124.role, arg0_124.roleContainer)

		arg0_124.role.transform.localPosition = Vector3(arg2_124[1][1], arg2_124[1][2], 0)
		arg0_124.role.transform.localEulerAngles = Vector3(0, arg2_124[2], 0)
		arg0_124.role.transform.localScale = Vector3(arg2_124[3], arg2_124[3], arg2_124[3])

		local var2_125 = arg0_124:GetSmoothRotateObject()
		local var3_125 = GetOrAddComponent(var2_125, typeof(SmoothRotateObject))

		var3_125:SetUp(arg0_124.role.transform)

		var3_125.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int
	end), true, true)

	table.insert(arg0_124.loadingIdList or {}, var0_124)
end

function var0_0.LoadCharacter(arg0_126, arg1_126, arg2_126)
	arg0_126:UnloadCharacter()

	if arg0_126.isLoadingModel then
		return
	end

	arg0_126.isLoadingModel = true

	arg0_126.islandShipDressHelper:SetShipId(arg0_126.showingShipId)

	arg0_126.isCommander = arg2_126
	arg0_126.modelData = arg1_126

	local function var0_126(arg0_127)
		arg0_126.role = arg0_127
		arg0_126.isLoadingModel = false

		pg.ViewUtils.SetLayer(arg0_126.role.transform, Layer.Character3D)
		setParent(arg0_126.role, arg0_126.roleContainer)

		local var0_127 = 2.7
		local var1_127 = arg0_126._tf.rect.width / arg0_126._tf.rect.height

		if var1_127 < 1.77777777777778 then
			var0_127 = 2.7 - 0.5 * (1.77777777777778 - var1_127) / 0.444444444444444
		end

		arg0_126.role.transform.localPosition = Vector3(var0_127, 0, 0)
		arg0_126.role.transform.localEulerAngles = Vector3(0, -155, 0)

		local var2_127 = arg0_126:GetSmoothRotateObject()
		local var3_127 = GetOrAddComponent(var2_127, typeof(SmoothRotateObject))

		var3_127:SetUp(arg0_126.role.transform)

		var3_127.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int

		arg0_126.displayUnit:OnAttach(arg0_127, arg0_126.toolContainer)

		local var4_127 = arg0_126.modelData and arg0_126.modelData.personal_ani

		if var4_127 and var4_127 ~= "" then
			local var5_127 = GetOrAddComponent(arg0_126.role.transform:GetChild(0), typeof(Animator))

			for iter0_127 = 1, var5_127.layerCount do
				var5_127:CrossFadeInFixedTime(var4_127, 0, iter0_127 - 1)
			end
		end

		arg0_126.islandShipDressHelper:OnRoleLoaded(arg0_126.role.transform, arg0_126.modelData)
	end

	if arg0_126.isCommander then
		arg0_126:GetPoolMgr():GetCommanderModel(arg1_126, function(arg0_128)
			var0_126(arg0_128)
		end)
	else
		arg0_126:GetPoolMgr():GetCharacter(arg1_126.model, arg1_126.animator, function(arg0_129)
			var0_126(arg0_129)
		end)
	end
end

function var0_0.UnloadCharacter(arg0_130)
	arg0_130.islandShipDressHelper:InvalidateRole()
	arg0_130.islandShipDressHelper:Destroy()

	if arg0_130.role then
		arg0_130.displayUnit:OnDetach()
		pg.ViewUtils.SetLayer(arg0_130.role.transform, Layer.Default)

		if arg0_130.isCommander then
			arg0_130:GetPoolMgr():ReturnCommanderModel(arg0_130.role)
		elseif arg0_130.modelData then
			arg0_130:GetPoolMgr():ReturnCharacter(arg0_130.modelData.model, arg0_130.modelData.animator, arg0_130.role)

			arg0_130.modelData = nil
		end

		arg0_130.role = nil
	end

	arg0_130.modelData = nil
end

function var0_0.BindExchangeTab(arg0_131, arg1_131, arg2_131)
	local var0_131 = arg2_131 - arg0_131.exchangeTabStartIdx + 1
	local var1_131 = arg0_131.exchangeShowIds[var0_131]
	local var2_131 = pg.island_exchange_group[var1_131]

	setText(arg1_131:Find("shop1Tg/name"), var2_131.text[1])
	setText(arg1_131:Find("shop1Tg/name/en"), var2_131.text[2])
	GetImageSpriteFromAtlasAsync("island/islandshopicon", var2_131.text[3], arg1_131:Find("shop1Tg/selected/icon"))
	setActive(arg1_131:Find("shop2List"), false)
	onToggle(arg0_131, arg1_131:Find("shop1Tg"), function(arg0_132)
		setActive(arg0_131.bg, not arg0_132)
		setActive(arg1_131:Find("shop2List"), arg0_132)
		arg0_131:SetResourcesVisible(not arg0_132)

		if arg0_132 then
			if arg0_131.currentShop1TgIndex == arg2_131 then
				return
			end

			arg0_131.currentShop1TgIndex = arg2_131

			arg1_131:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop1List_Selected")
			triggerToggle(arg1_131:Find("shop2List"):GetChild(0), true)
			setText(arg0_131.title:Find("Text"), i18n("island_exchange_title"))
			setText(arg0_131.title:Find("Text/en"), i18n("island_exchange_title_en"))
			arg0_131:SetShopPageVisible(false)
			setActive(arg0_131.shop3, false)
			setActive(arg0_131.shop32, false)
			arg0_131.exchangSubView:ExecuteAction("Show")
		else
			arg0_131.exchangSubView:ExecuteAction("Hide")
		end
	end, SFX_PANEL)

	local var3_131 = var2_131.exchange_group

	UIItemList.StaticAlign(arg1_131:Find("shop2List"), arg1_131:Find("shop2List/shop2Tpl"), #var3_131, function(arg0_133, arg1_133, arg2_133)
		if arg0_133 == UIItemList.EventUpdate then
			local var0_133 = arg1_133 + 1
			local var1_133 = var3_131[var0_133][1]
			local var2_133 = var3_131[var0_133][2]

			setText(arg2_133:Find("name"), var1_133)
			setText(arg2_133:Find("selected/name"), var1_133)
			onToggle(arg0_131, arg2_133, function(arg0_134)
				if arg0_134 then
					arg2_133:GetComponent(typeof(Animation)):Play("anim_IslandShopUI_Shop2List_Selected")
					arg0_131.exchangSubView:ExecuteAction("FlushGroup", var2_133)
				end
			end, SFX_PANEL)
		end
	end)
end

function var0_0.OnExchangeDone(arg0_135)
	arg0_135.exchangSubView:ExecuteAction("FlushGroup")
end

function var0_0.OnShow(arg0_136, arg1_136, arg2_136, arg3_136)
	arg0_136:OverlayPanel(arg0_136._tf)

	arg0_136.showTypes = arg1_136
	arg0_136.firstShopIds = arg2_136
	arg0_136.showDrawAward = arg3_136 == 1
	arg0_136.drawAwardActivity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND_DRAW_AWARD)

	arg0_136:DoUpdateShops()
	arg0_136:UpdateData()
	arg0_136:SetShopList()
end

function var0_0.OnHide(arg0_137)
	arg0_137:UnOverlayPanel(arg0_137._tf)

	if arg0_137.timer then
		arg0_137.timer:Stop()

		arg0_137.timer = nil
	end

	arg0_137:ResetCommanderDressPreview(false)

	arg0_137.shoppingCartCommodities = {}
	arg0_137.showingCommodity = nil

	arg0_137.islandShipDressHelper:Destroy()
	arg0_137:UnloadCharacter()
	arg0_137.drawAwardPage:Destroy()
	arg0_137.drawAwardPage:Reset()
	arg0_137.exchangSubView:ExecuteAction("Hide")

	for iter0_137, iter1_137 in ipairs(arg0_137.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter1_137)
	end

	arg0_137.loadingIdList = {}
end

function var0_0.OnDisable(arg0_138)
	arg0_138:OnHide()
	var0_0.super.OnDisable(arg0_138)
end

function var0_0.OnDestroy(arg0_139)
	arg0_139:OnHide()

	if arg0_139.exchangSubView then
		arg0_139.exchangSubView:Destroy()

		arg0_139.exchangSubView = nil
	end

	var0_0.super.OnDestroy(arg0_139)
end

function var0_0.CanEsc(arg0_140)
	if arg0_140.morphing then
		return false
	end

	return true
end

function var0_0.StaticUpdateCommodityTpl(arg0_141, arg1_141)
	local var0_141 = arg1_141:GetMaxNum() - arg1_141.purchasedNum

	setText(arg0_141:Find("name"), arg1_141:GetName())

	if #arg1_141:GetItems() == 1 and arg1_141:GetItems()[1][1] ~= DROP_TYPE_ISLAND_FURNITURE and arg1_141:GetItems()[1][1] ~= DROP_TYPE_ISLAND_DRESS and arg1_141:GetItems()[1][1] ~= DROP_TYPE_ISLAND_SKIN then
		local var1_141 = arg1_141:GetItems()[1]
		local var2_141 = {
			type = var1_141[1],
			id = var1_141[2],
			count = var1_141[3]
		}

		updateCustomDrop(arg0_141:Find("IslandItemTpl"), var2_141, {
			style = "island"
		})
	else
		GetImageSpriteFromAtlasAsync(arg1_141:GetIcon(), "", arg0_141:Find("IslandItemTpl/icon_bg/icon"))
	end

	setActive(arg0_141:Find("IslandItemTpl/icon_bg/count_bg"), arg1_141:IsShowPurchaseLimit())
	setText(arg0_141:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_141 .. "/" .. arg1_141:GetMaxNum())

	local var3_141 = arg1_141:GetResourceConsume()

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = var3_141[1],
		id = var3_141[2]
	}):getIcon(), "", arg0_141:Find("cost/icon"))
	setText(arg0_141:Find("cost/num"), math.ceil((100 - arg1_141:GetDiscount()) / 100 * var3_141[3]))

	local var4_141 = arg1_141:GetTag()

	setActive(arg0_141:Find("tags/timeLimit"), var4_141 == IslandCommodity.TAG.TIME)
	setActive(arg0_141:Find("tags/new"), var4_141 == IslandCommodity.TAG.NEW)
	setActive(arg0_141:Find("tags/hot"), var4_141 == IslandCommodity.TAG.HOT)
	setActive(arg0_141:Find("discount"), arg1_141:GetDiscount() ~= 0)
	setText(arg0_141:Find("discount/Text"), "-" .. arg1_141:GetDiscount() .. "%")

	local var5_141 = arg1_141:GetItems()[1][1]
	local var6_141 = arg1_141:GetItems()[1][2]
	local var7_141 = Drop.New({
		count = 1,
		type = var5_141,
		id = var6_141
	}):getOwnedCount()

	setActive(arg0_141:Find("have"), arg1_141:IsShowHave())
	setText(arg0_141:Find("have"), i18n("island_3Dshop_have") .. var7_141)

	local var8_141 = underscore.all(arg1_141:GetItems(), function(arg0_142)
		return Drop.New({
			count = 1,
			type = arg0_142[1],
			id = arg0_142[2]
		}):getOwnedCount() > 0
	end)

	setActive(arg0_141:Find("hold"), arg1_141:IsShowHold() and (arg1_141:IsCharacterInviteItemHold() or var8_141))
	setActive(arg0_141:Find("sellOut"), arg1_141:GetMaxNum() ~= 0 and var0_141 == 0 and not isActive(arg0_141:Find("hold")))
	setActive(arg0_141:Find("cost"), not isActive(arg0_141:Find("sellOut")) and not isActive(arg0_141:Find("hold")))
	setActive(arg0_141:Find("select"), false)
	setText(arg0_141:Find("sellOut/Text"), i18n("common_sale_out"))
	setText(arg0_141:Find("hold/Text"), i18n("common_already owned"))
end

function var0_0.SortShopCommodities(arg0_143)
	table.sort(arg0_143, CompareFuncs({
		function(arg0_144)
			local var0_144 = arg0_144:GetMaxNum() - arg0_144.purchasedNum

			if arg0_144:GetMaxNum() ~= 0 and var0_144 == 0 then
				return 3
			end

			if arg0_144:IsShowHold() then
				if arg0_144:IsCharacterInviteItemHold() then
					return 2
				else
					return underscore.all(arg0_144:GetItems(), function(arg0_145)
						return Drop.New({
							count = 1,
							type = arg0_145[1],
							id = arg0_145[2]
						}):getOwnedCount() > 0
					end) and 2 or 1
				end
			else
				return 1
			end
		end,
		function(arg0_146)
			return arg0_146:GetCfgSortIdx()
		end,
		function(arg0_147)
			return arg0_147.id
		end
	}))
end

return var0_0
