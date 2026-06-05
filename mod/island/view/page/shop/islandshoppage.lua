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

	arg0_30.shop1List:make(function(arg0_31, arg1_31, arg2_31)
		arg1_31 = arg1_31 + 1

		if arg0_31 == UIItemList.EventUpdate then
			local var0_31 = arg0_30.firstShopConfigs[arg1_31]

			if var0_31 then
				arg0_30:BindFirstShopTab(arg2_31, var0_31, arg1_31)
			else
				arg0_30:BindDrawAwardTab(arg2_31, arg1_31)
			end
		end
	end)
	arg0_30.shop1List:align(#arg0_30.firstShopConfigs + (arg0_30.showDrawAward and arg0_30.drawAwardActivity and 1 or 0))
end

function var0_0.SetShopPage(arg0_32)
	local var0_32 = arg0_32.showingShop:GetShowType()

	setText(arg0_32.title:Find("Text"), arg0_32.showingShop:GetShopIcon()[1])
	setText(arg0_32.title:Find("Text/en"), arg0_32.showingShop:GetShopIcon()[2])
	arg0_32:SetResources()
	setActive(arg0_32.recommendationPage1, var0_32 == IslandConst.SHOP_TYPE_RECOMMENDATION_1)
	setActive(arg0_32.recommendationPage5, var0_32 == IslandConst.SHOP_TYPE_RECOMMENDATION_5)
	setActive(arg0_32.shop2DPage, var0_32 == IslandConst.SHOP_TYPE_2D)
	setActive(arg0_32.shop3DPage, var0_32 == IslandConst.SHOP_TYPE_3D)
	setActive(arg0_32.shopFurniturePage, var0_32 == IslandConst.SHOP_TYPE_FURNITURE)
	setActive(arg0_32.shopSkinPage, var0_32 == IslandConst.SHOP_TYPE_SKIN)
	switch(var0_32, {
		[IslandConst.SHOP_TYPE_RECOMMENDATION_1] = function()
			arg0_32:ShowRecommendation1()
		end,
		[IslandConst.SHOP_TYPE_RECOMMENDATION_5] = function()
			arg0_32:ShowRecommendation5()
		end,
		[IslandConst.SHOP_TYPE_2D] = function()
			arg0_32:ShowShop2D()
		end,
		[IslandConst.SHOP_TYPE_3D] = function()
			arg0_32:ShowShop3D()
		end,
		[IslandConst.SHOP_TYPE_FURNITURE] = function()
			arg0_32:ShowShopFurniture()
		end,
		[IslandConst.SHOP_TYPE_SKIN] = function()
			arg0_32:ShowShopSkin()
		end
	})
end

function var0_0.SetResources(arg0_39)
	arg0_39.player = getProxy(PlayerProxy):getRawData()

	local var0_39 = not arg0_39.firstShopConfigs[arg0_39.currentShop1TgIndex]

	setActive(arg0_39.helpBtn, var0_39)

	if var0_39 then
		local var1_39 = {}

		table.insert(var1_39, Drop.New({
			type = DROP_TYPE_VITEM,
			id = arg0_39.drawAwardActivity:GetDrawConfig("cost_free")
		}))
		table.insert(var1_39, Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = PlayerConst.ResDiamond
		}))
		arg0_39.resourceList:make(function(arg0_40, arg1_40, arg2_40)
			arg1_40 = arg1_40 + 1

			if arg0_40 == UIItemList.EventUpdate then
				local var0_40 = var1_39[arg1_40]
				local var1_40

				eachChild(arg2_40, function(arg0_41, arg1_41)
					setActive(arg0_41, arg0_41.name == "islandItem")

					if arg0_41.name == "islandItem" then
						var1_40 = arg0_41
					end
				end)
				GetImageSpriteFromAtlasAsync(var0_40:getIcon(), "", var1_40:Find("icon"))
				setText(var1_40:Find("Text"), var0_40:getOwnedCount())
				setActive(var1_40:Find("add"), false)
				setActive(var1_40:Find("add"), false)
				setActive(var1_40:Find("descBtn"), false)
				setActive(var1_40:Find("resourceDesc"), false)
			end
		end)
		arg0_39.resourceList:align(#var1_39)

		return
	end

	local var2_39 = arg0_39.showingShop:GetTopResources()

	arg0_39.resourceList:make(function(arg0_42, arg1_42, arg2_42)
		if arg0_42 == UIItemList.EventUpdate then
			local var0_42 = var2_39[arg1_42 + 1]
			local var1_42 = var0_42[1]
			local var2_42 = var0_42[2]
			local var3_42 = var0_42[3]

			setActive(arg2_42:Find("gold"), false)
			setActive(arg2_42:Find("oil"), false)
			setActive(arg2_42:Find("gem"), false)
			setActive(arg2_42:Find("islandItem"), false)

			if var2_42 == DROP_TYPE_RESOURCE then
				if var3_42 == 1 then
					setActive(arg2_42:Find("gold"), true)

					local var4_42 = arg0_39.player:getLevelMaxGold()

					setText(arg2_42:Find("gold/max"), "MAX: " .. var4_42)
					setText(arg2_42:Find("gold/Text"), arg0_39.player.gold)
				elseif var3_42 == 4 or var3_42 == 14 then
					setActive(arg2_42:Find("gem"), true)
					setText(arg2_42:Find("gem/Text"), arg0_39.player:getTotalGem())
				end
			elseif var2_42 == DROP_TYPE_ISLAND_ITEM then
				setActive(arg2_42:Find("islandItem"), true)

				local var5_42 = arg0_39.inventoryAgency:GetOwnCount(var3_42)

				setText(arg2_42:Find("islandItem/Text"), var5_42)
				GetImageSpriteFromAtlasAsync(Drop.New({
					type = DROP_TYPE_ISLAND_ITEM,
					id = var3_42
				}):getIcon(), "", arg2_42:Find("islandItem/icon"))
				setActive(arg2_42:Find("islandItem/descBtn"), var1_42 == 1)
				setActive(arg2_42:Find("islandItem/resourceDesc"), false)

				if var1_42 == 1 then
					local var6_42 = pg.island_item_data_template[var3_42].have_max

					setText(arg2_42:Find("islandItem/Text"), var5_42 .. "/" .. var6_42)
					onButton(arg0_39, arg2_42:Find("islandItem"), function()
						setActive(arg2_42:Find("islandItem/resourceDesc"), not isActive(arg2_42:Find("islandItem/resourceDesc")))
						setText(arg2_42:Find("islandItem/resourceDesc"), i18n("island_3Dshop_res_have") .. var6_42)
					end, SFX_PANEL)
				end
			end
		end
	end)
	arg0_39.resourceList:align(#var2_39)
end

function var0_0.SetCloseAndRefresh(arg0_44, arg1_44)
	local var0_44 = 0

	if arg0_44.showingShop:IsNormalShop() then
		local var1_44 = arg0_44.showingShop:GetExistTime()

		if type(var1_44) == "table" then
			local var2_44 = var1_44[2]

			var0_44 = pg.TimeMgr.GetInstance():Table2ServerTime({
				year = var2_44[1][1],
				month = var2_44[1][2],
				day = var2_44[1][3],
				hour = var2_44[2][1],
				min = var2_44[2][2],
				sec = var2_44[2][3]
			})
		end
	elseif arg0_44.showingShop:IsTemporaryShop() then
		var0_44 = arg0_44.showingShop.existTime
	end

	local var3_44 = arg0_44.showingShop.refreshTime
	local var4_44 = arg0_44.showingShop:GetPlayerRefreshResource()

	setActive(arg1_44:Find("remainAndRefresh/remainTimer"), var0_44 ~= 0)
	setActive(arg1_44:Find("remainAndRefresh/refresh"), var3_44 ~= 0)
	setActive(arg1_44:Find("remainAndRefresh/refresh/refreshBtn"), var4_44)
	setActive(arg1_44:Find("remainAndRefresh"), isActive(arg1_44:Find("remainAndRefresh/remainTimer")) or isActive(arg1_44:Find("remainAndRefresh/refresh")))

	local var5_44 = pg.TimeMgr.GetInstance():GetTimeToNextTime()

	if arg0_44.timer then
		arg0_44.timer:Stop()

		arg0_44.timer = nil
	end

	arg0_44.timer = Timer.New(function()
		local var0_45 = pg.TimeMgr.GetInstance():GetServerTime()

		if var0_44 ~= 0 then
			local var1_45 = pg.TimeMgr.GetInstance():DescCDTime(var0_44 - var0_45)

			setText(arg1_44:Find("remainAndRefresh/remainTimer"), i18n("island_3Dshop_time_close", var1_45))
		elseif normalShopExistTime and type(normalShopExistTime) == "table" then
			-- block empty
		end

		if var3_44 ~= 0 then
			local var2_45 = pg.TimeMgr.GetInstance():DescCDTime(var3_44 - var0_45)

			setText(arg1_44:Find("remainAndRefresh/refresh/refreshTimer"), i18n("island_3Dshop_time_refresh", var2_45))

			if var0_45 > var3_44 then
				arg0_44:DoUpdateShowingShop()
			end
		end

		if var3_44 == 0 and var4_44 and var0_45 > var5_44 then
			arg0_44:DoUpdateShowingShop()
		end
	end, 1, -1)

	arg0_44.timer:Start()

	if var4_44 then
		onButton(arg0_44, arg1_44:Find("remainAndRefresh/refresh/refreshBtn/button"), function()
			local var0_46 = arg0_44.showingShop.refreshCount

			if var0_46 < arg0_44.showingShop:GetMaxRefreshCount() then
				local var1_46 = arg0_44.showingShop:GetFirstRefreshFree()
				local var2_46 = var4_44[3]

				if var1_46 and var0_46 == 0 then
					var4_44[3] = 0
					var2_46 = 0
				end

				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					noText = "text_cancel",
					hideNo = false,
					yesText = "text_confirm",
					content = i18n("refresh_shopStreet_question", i18n("word_" .. id2res(var4_44[2]) .. "_icon"), var2_46, var0_46),
					onYes = function()
						arg0_44:emit(IslandMediator.REFRESH_SHOP_BY_PLAYER, arg0_44.showingShop.id, var4_44)
					end
				})
			else
				pg.TipsMgr.GetInstance():ShowTips(i18n("island_3Dshop_refresh_limit"))
			end
		end, SFX_PANEL)
	end
end

function var0_0.IsCommodityInShoppingCart(arg0_48, arg1_48)
	for iter0_48, iter1_48 in ipairs(arg0_48.shoppingCartCommodities) do
		if iter1_48.id == arg1_48.id then
			return true
		end
	end

	return false
end

function var0_0.IsCommodityDisabled(arg0_49, arg1_49)
	return isActive(arg1_49:Find("sellOut")) or isActive(arg1_49:Find("hold")) or isActive(arg1_49:Find("notInTime"))
end

function var0_0.OpenShoppingCart(arg0_50)
	arg0_50.myIslandShoppingCartLayer = arg0_50:OpenPage(IslandShoppingCartLayer, arg0_50.shoppingCartCommodities)
end

function var0_0.RefreshShopSkinCartButtons(arg0_51)
	setActive(arg0_51.shopSkinPage:Find("cancelBtn"), #arg0_51.shoppingCartCommodities > 0)
	setActive(arg0_51.shopSkinPage:Find("shoppingCartBtn"), #arg0_51.shoppingCartCommodities > 0)
	setActive(arg0_51.shopSkinPage:Find("shoppingCartBtn/count"), arg0_51.showingShop:GetCommanderOrCharaType() == 1)
end

function var0_0.ResetShopSkinCartPreview(arg0_52)
	local var0_52 = arg0_52.shoppingCartCommodities and arg0_52.shoppingCartCommodities[1]

	arg0_52.shoppingCartCommodities = {}
	arg0_52.showingCommodity = nil

	if var0_52 and arg0_52:IsCommanderDressCommodity(var0_52) then
		arg0_52:ResetCommanderDressPreview(true)
	else
		arg0_52:ResetCommanderDressPreview(false)
		arg0_52.islandShipDressHelper:ResetDressUp()
	end
end

function var0_0.BindShopSkinCartButtons(arg0_53, arg1_53)
	if #arg0_53.shoppingCartCommodities <= 0 then
		return
	end

	onButton(arg0_53, arg0_53.shopSkinPage:Find("cancelBtn"), function()
		if arg1_53 then
			arg1_53()
		else
			arg0_53:ResetShopSkinCartPreview()
		end

		setActive(arg0_53.shopSkinPage:Find("cancelBtn"), false)
		setActive(arg0_53.shopSkinPage:Find("shoppingCartBtn"), false)
		setText(arg0_53.shopSkinPage:Find("shoppingCartBtn/count"), "0/3")
		arg0_53:SetCommodityList()
	end, SFX_PANEL)
	onButton(arg0_53, arg0_53.shopSkinPage:Find("shoppingCartBtn"), function()
		arg0_53:OpenShoppingCart()
	end, SFX_PANEL)
end

function var0_0.IsDressCommodityExclusive(arg0_56, arg1_56)
	local var0_56 = arg0_56.characterAgency:GetShipById(arg0_56.showingShipId)
	local var1_56 = var0_56:GetCurrentSkinId()
	local var2_56 = pg.island_dress_template[arg1_56:GetItems()[1][2]]

	if var1_56 ~= 0 then
		local var3_56 = var2_56.exclusive_skin

		if var3_56 ~= "" then
			for iter0_56, iter1_56 in ipairs(var3_56) do
				if iter1_56 == var1_56 then
					return true, var2_56
				end
			end
		end
	else
		local var4_56 = var2_56.exclusive_default_skin

		if var4_56 ~= "" then
			for iter2_56, iter3_56 in ipairs(var4_56) do
				if iter3_56 == var0_56.id then
					return true, var2_56
				end
			end
		end
	end

	return false, var2_56
end

function var0_0.IsCommanderDressCommodity(arg0_57, arg1_57)
	local var0_57 = arg1_57:GetItems()

	if #var0_57 == 0 or var0_57[1][1] ~= DROP_TYPE_ISLAND_DRESS then
		return false
	end

	local var1_57 = pg.island_dress_template[var0_57[1][2]]

	return var1_57 and var1_57.belongto == 1
end

function var0_0.CacheCommanderDressPreviewData(arg0_58)
	if arg0_58.commanderDressPreviewData then
		return
	end

	local var0_58 = getProxy(IslandProxy):GetIsland():GetDressUpAgency()

	arg0_58.commanderDressPreviewData = {}

	for iter0_58, iter1_58 in pairs(IslandShipDressHelperNew.CommanderCustom) do
		local var1_58 = var0_58:GetDressByType(iter1_58) or 0

		arg0_58.commanderDressPreviewData[iter1_58] = {
			id = var1_58,
			colorId = var0_58:GetCurrentColorByDressId(var1_58)
		}
	end
end

function var0_0.RestoreCommanderDressPreview(arg0_59)
	if not arg0_59.commanderDressPreviewData then
		return
	end

	local var0_59 = arg0_59.commanderDressPreviewData

	for iter0_59, iter1_59 in ipairs(IslandShipDressHelperNew.CommanderCustom) do
		local var1_59 = var0_59[iter1_59]

		if var1_59 then
			arg0_59.islandShipDressHelper:ChangeDressByType(iter1_59, var1_59)
		end
	end

	arg0_59.commanderDressPreviewData = nil
end

function var0_0.ResetCommanderDressPreview(arg0_60, arg1_60, arg2_60)
	if arg1_60 then
		arg0_60:RestoreCommanderDressPreview()
	else
		arg0_60.commanderDressPreviewData = nil

		if arg2_60 then
			arg0_60.islandShipDressHelper:InvalidateRole()
		end
	end

	arg0_60:SetMorphBlock(false)
	setActive(arg0_60.morphBtn, false)
end

function var0_0.ChangeDressByCommodityItems(arg0_61, arg1_61)
	for iter0_61, iter1_61 in ipairs(arg1_61:GetItems()) do
		local var0_61

		if iter1_61[1] == DROP_TYPE_ISLAND_DRESS then
			local var1_61 = pg.island_dress_template[iter1_61[2]]

			if var1_61 then
				var0_61 = var1_61.type
			end
		end

		arg0_61.islandShipDressHelper:ChangeDressByType(var0_61, {
			colorId = 0,
			id = iter1_61[2]
		})
	end
end

function var0_0.ToggleDressSuitCommodity(arg0_62, arg1_62)
	arg0_62:ResetCommanderDressPreview(false)

	arg0_62.showingCommodity = nil

	if #arg0_62.shoppingCartCommodities == 1 and arg0_62.shoppingCartCommodities[1].id == arg1_62.id then
		arg0_62.shoppingCartCommodities = {}

		arg0_62.islandShipDressHelper:ResetDressUp()
	else
		arg0_62.shoppingCartCommodities = {
			arg1_62
		}

		arg0_62:ChangeDressByCommodityItems(arg1_62)
	end

	setText(arg0_62.shopSkinPage:Find("shoppingCartBtn/count"), (#arg0_62.shoppingCartCommodities > 0 and #arg1_62:GetDisplayItems() or 0) .. "/3")
end

function var0_0.ChangeCommanderDressByCommodity(arg0_63, arg1_63)
	arg0_63:CacheCommanderDressPreviewData()

	for iter0_63, iter1_63 in ipairs(arg1_63:GetDisplayItems()) do
		if iter1_63[1] == DROP_TYPE_ISLAND_DRESS then
			local var0_63 = pg.island_dress_template[iter1_63[2]]

			if var0_63 then
				local var1_63 = iter1_63[2]

				if var0_63.type == IslandShipDressHelperNew.DressType.Body then
					local var2_63 = getProxy(IslandProxy):GetIsland():GetDressUpAgency():GetTwinCurId(var1_63)

					if var2_63 and var2_63 ~= 0 then
						var1_63 = var2_63
					end
				end

				arg0_63.islandShipDressHelper:ChangeDressByType(var0_63.type, {
					colorId = 0,
					id = var1_63
				})
				arg0_63:CheckCommanderHatState(var0_63.type, var1_63)
				arg0_63:CheckCommanderMorphBtn(var0_63.type, var1_63)
			end
		end
	end
end

function var0_0.CheckCommanderHatState(arg0_64, arg1_64, arg2_64)
	if arg1_64 ~= IslandShipDressHelperNew.DressType.Body then
		return
	end

	local var0_64 = (pg.island_dress_template.get_id_list_by_related_dress[arg2_64] or {})[1]

	if not var0_64 or var0_64 == 0 then
		arg0_64.islandShipDressHelper:ChangeDressByType(IslandShipDressHelperNew.DressType.Hat, {
			id = 0,
			colorId = 0
		})
	elseif var0_64 and var0_64 ~= 0 then
		arg0_64.islandShipDressHelper:ChangeDressByType(IslandShipDressHelperNew.DressType.Hat, {
			colorId = 0,
			id = var0_64
		})
	end
end

function var0_0.CheckCommanderMorphBtn(arg0_65, arg1_65, arg2_65)
	if arg1_65 ~= IslandShipDressHelperNew.DressType.Body then
		return
	end

	local var0_65 = arg2_65
	local var1_65 = 0
	local var2_65 = pg.island_dress_template[var0_65].cloth_related

	if var2_65 and var2_65 ~= 0 then
		var1_65 = var2_65
	end

	if var1_65 == 0 then
		setActive(arg0_65.morphBtn, false)

		return
	end

	setActive(arg0_65.morphBtn, true)
	onButton(arg0_65, arg0_65.morphBtn, function()
		arg0_65:DoMorphSwitch(var0_65, var1_65)
	end)
end

function var0_0.DoMorphSwitch(arg0_67, arg1_67, arg2_67)
	if arg0_67.morphing then
		return
	end

	arg0_67:SetMorphBlock(true)

	if not arg0_67.islandShipDressHelper then
		arg0_67:DoSwitch(arg2_67, function()
			arg0_67:SetMorphBlock(false)
		end)

		return
	end

	arg0_67.islandShipDressHelper:DoMorphSwitch(arg1_67, arg2_67, function()
		arg0_67:DoSwitch(arg2_67, function()
			arg0_67:SetMorphBlock(false)
		end)
	end)
end

function var0_0.DoSwitch(arg0_71, arg1_71, arg2_71)
	local var0_71 = IslandShipDressHelperNew.DressType.Body

	arg0_71.islandShipDressHelper:ChangeDressByType(var0_71, {
		colorId = 0,
		id = arg1_71
	}, arg2_71)
	arg0_71:CheckCommanderHatState(IslandShipDressHelperNew.DressType.Body, arg1_71)
	arg0_71:CheckCommanderMorphBtn(var0_71, arg1_71)
end

function var0_0.SetMorphBlock(arg0_72, arg1_72)
	arg0_72.morphing = arg1_72

	setActive(arg0_72.morphBlocker, arg1_72)
end

function var0_0.ToggleCommanderDressCommodity(arg0_73, arg1_73)
	if #arg0_73.shoppingCartCommodities == 1 and arg0_73.shoppingCartCommodities[1].id == arg1_73.id then
		arg0_73.shoppingCartCommodities = {}

		arg0_73:ResetCommanderDressPreview(true)
	else
		arg0_73.shoppingCartCommodities = {
			arg1_73
		}

		arg0_73:ChangeCommanderDressByCommodity(arg1_73)
	end

	setText(arg0_73.shopSkinPage:Find("shoppingCartBtn/count"), (#arg0_73.shoppingCartCommodities > 0 and #arg1_73:GetDisplayItems() or 0) .. "/3")
end

function var0_0.RemoveSameDressTypeCommodity(arg0_74, arg1_74)
	local var0_74 = 0

	for iter0_74, iter1_74 in ipairs(arg0_74.shoppingCartCommodities) do
		if iter1_74:GetDressType() == arg1_74:GetDressType() then
			var0_74 = iter1_74.id

			table.remove(arg0_74.shoppingCartCommodities, iter0_74)

			break
		end
	end

	return var0_74
end

function var0_0.ToggleSingleDressCommodity(arg0_75, arg1_75)
	local var0_75, var1_75 = arg0_75:IsDressCommodityExclusive(arg1_75)

	if var0_75 then
		pg.TipsMgr.GetInstance():ShowTips(i18n("island_dress_mutually_exclusive1", var1_75.name))

		return false
	end

	arg0_75:ResetCommanderDressPreview(false)

	arg0_75.showingCommodity = nil

	if #arg0_75.shoppingCartCommodities > 0 and #arg0_75.shoppingCartCommodities[1]:GetItems() > 1 then
		arg0_75.shoppingCartCommodities = {}

		arg0_75.islandShipDressHelper:ResetDressUp()
	end

	local var2_75 = arg0_75:RemoveSameDressTypeCommodity(arg1_75)

	if arg1_75.id == var2_75 then
		arg0_75.islandShipDressHelper:ChangeDressByType(arg1_75:GetDressType(), {
			id = 0,
			colorId = 0
		})
	else
		table.insert(arg0_75.shoppingCartCommodities, arg1_75)
		arg0_75.islandShipDressHelper:ChangeDressByType(arg1_75:GetDressType(), {
			colorId = 0,
			id = arg1_75:GetItems()[1][2]
		})
	end

	setText(arg0_75.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_75.shoppingCartCommodities .. "/3")

	return true
end

function var0_0.HandleDressCommodity(arg0_76, arg1_76)
	if arg0_76:IsCommanderDressCommodity(arg1_76) then
		arg0_76:ToggleCommanderDressCommodity(arg1_76)
	elseif #arg1_76:GetItems() > 1 then
		arg0_76:ToggleDressSuitCommodity(arg1_76)
	elseif not arg0_76:ToggleSingleDressCommodity(arg1_76) then
		return
	end

	arg0_76:RefreshShopSkinCartButtons()
	arg0_76:BindShopSkinCartButtons()
	arg0_76:SetCommodityList()
end

function var0_0.HandleFurnitureCommodity(arg0_77, arg1_77)
	arg0_77:ResetCommanderDressPreview(false, true)

	if arg0_77.showingCommodity ~= arg1_77 then
		arg0_77.showingCommodity = arg1_77
		arg0_77.shoppingCartCommodities = {
			arg1_77
		}

		arg0_77:LoadFurniture(arg1_77:GetModel(), arg1_77:GetModelParam())
		setActive(arg0_77.shopFurniturePage:Find("scenePreviewBtn"), false)
		setActive(arg0_77.shopFurniturePage:Find("shoppingCartBtn"), true)

		if #arg1_77:GetItems() == 1 then
			onButton(arg0_77, arg0_77.shopFurniturePage:Find("scenePreviewBtn"), function()
				setActive(arg0_77._tf, false)
				arg0_77:ClearCharacterScene()
				arg0_77:emit(IslandMediator.PREVIEW_FURNITURE, arg1_77:GetItems()[1][2])
			end, SFX_PANEL)
		end

		onButton(arg0_77, arg0_77.shopFurniturePage:Find("shoppingCartBtn"), function()
			arg0_77:OpenShoppingCart()
		end, SFX_PANEL)
	else
		arg0_77.showingCommodity = nil
		arg0_77.shoppingCartCommodities = {}

		arg0_77:UnloadCharacter()
		setActive(arg0_77.shopFurniturePage:Find("scenePreviewBtn"), false)
		setActive(arg0_77.shopFurniturePage:Find("shoppingCartBtn"), false)
	end

	arg0_77:SetCommodityList()
end

function var0_0.HandleSkinCommodity(arg0_80, arg1_80)
	arg0_80:ResetCommanderDressPreview(false, true)

	if arg0_80.showingCommodity ~= arg1_80 then
		arg0_80.showingCommodity = arg1_80
		arg0_80.shoppingCartCommodities = {
			arg1_80
		}

		local var0_80 = pg.island_skin_template[arg1_80:GetItems()[1][2]].model
		local var1_80 = pg.island_unit_character[var0_80]

		arg0_80:LoadCharacter(var1_80, false)
	else
		arg0_80.showingCommodity = nil
		arg0_80.shoppingCartCommodities = {}

		arg0_80:UnloadCharacter()
	end

	setActive(arg0_80.shopSkinPage:Find("cancelBtn"), false)
	setActive(arg0_80.shopSkinPage:Find("shoppingCartBtn"), #arg0_80.shoppingCartCommodities > 0)
	setActive(arg0_80.shopSkinPage:Find("shoppingCartBtn/count"), false)
	setText(arg0_80.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_80.shoppingCartCommodities .. "/3")
	arg0_80:BindShopSkinCartButtons(function()
		arg0_80.shoppingCartCommodities = {}

		local var0_81 = arg0_80.characterAgency:GetShipById(arg0_80.showingShipId):GetModel()

		arg0_80:LoadCharacter(var0_81, false)
	end)
	arg0_80:SetCommodityList()
end

function var0_0.SetCommodity(arg0_82, arg1_82, arg2_82)
	var0_0.StaticUpdateCommodityTpl(arg1_82, arg2_82)
	setActive(arg1_82:Find("notInTime"), not arg0_82.showingShop:IsInTime())
	setActive(arg1_82:Find("select"), arg0_82:IsCommodityInShoppingCart(arg2_82))

	if arg0_82:IsCommodityDisabled(arg1_82) then
		removeOnButton(arg1_82)
	else
		onButton(arg0_82, arg1_82, function()
			switch(arg2_82:GetCommodityShowType(), {
				[IslandConst.COMMODITY_SHOW_ITEM] = function()
					arg0_82.myIslandShopItemLayer = arg0_82:OpenPage(IslandShopItemLayer, arg0_82.showingShop.id, arg2_82)
				end,
				[IslandConst.COMMODITY_SHOW_DRESS] = function()
					arg0_82:HandleDressCommodity(arg2_82)
				end,
				[IslandConst.COMMODITY_SHOW_FURNITURE] = function()
					arg0_82:HandleFurnitureCommodity(arg2_82)
				end,
				[IslandConst.COMMODITY_SHOW_SKIN] = function()
					arg0_82:HandleSkinCommodity(arg2_82)
				end,
				[IslandConst.COMMODITY_SHOW_INVITE] = function()
					local var0_88 = arg2_82:GetItems()[1][2]

					arg0_82.myIslandShopItemLayer = arg0_82:OpenPage(IslandShopItemLayer, arg0_82.showingShop.id, arg2_82, var0_88)
				end
			})
		end, SFX_PANEL)
	end
end

function var0_0.SetCommodityList(arg0_89)
	local var0_89 = arg0_89.showingShop:GetShowType()
	local var1_89 = switch(var0_89, {
		[IslandConst.SHOP_TYPE_2D] = function()
			return UIItemList.New(arg0_89.shop2DPage:Find("shopView/Viewport/Content"), arg0_89.shop2DPage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end,
		[IslandConst.SHOP_TYPE_3D] = function()
			return UIItemList.New(arg0_89.shop3DPage:Find("shopView/Viewport/Content"), arg0_89.shop3DPage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end,
		[IslandConst.SHOP_TYPE_FURNITURE] = function()
			return UIItemList.New(arg0_89.shopFurniturePage:Find("shopView/Viewport/Content"), arg0_89.shopFurniturePage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end,
		[IslandConst.SHOP_TYPE_SKIN] = function()
			return UIItemList.New(arg0_89.shopSkinPage:Find("shopView/Viewport/Content"), arg0_89.shopSkinPage:Find("shopView/Viewport/Content/IslandCommodityTpl"))
		end
	})
	local var2_89 = arg0_89.showingShop:GetCommodities()

	var0_0.SortShopCommodities(var2_89)
	var1_89:make(function(arg0_94, arg1_94, arg2_94)
		if arg0_94 == UIItemList.EventUpdate then
			local var0_94 = var2_89[arg1_94 + 1]

			arg0_89:SetCommodity(arg2_94, var0_94)
		end
	end, SFX_PANEL)
	var1_89:align(#var2_89)
end

function var0_0.ShowRecommendation5(arg0_95)
	arg0_95:ClearCharacterScene()
	arg0_95:OverlayPanel(arg0_95._tf, {
		pbList = {
			arg0_95.bg
		}
	})
	setActive(arg0_95.bgColor, true)

	arg0_95.shoppingCartCommodities = {}
	arg0_95.showingCommodity = nil

	arg0_95:ResetCommanderDressPreview(false)

	local var0_95 = arg0_95.showingShop:GetBanners()
	local var1_95 = arg0_95.recommendationPage5:Find("banners")

	for iter0_95 = 1, #var0_95 do
		local var2_95 = var0_95[iter0_95]
		local var3_95 = var1_95:Find("banner" .. var2_95.id)

		if var3_95 then
			GetImageSpriteFromAtlasAsync("activitybanner/" .. var2_95.pic, "", var3_95)
			onButton(arg0_95, var3_95, function()
				arg0_95:JumpToRecommendationShop(var2_95.param)
			end, SFX_PANEL)
		end
	end
end

function var0_0.ShowRecommendation1(arg0_97)
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
	local var1_97 = arg0_97.recommendationPage1:Find("banners")

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

function var0_0.ShowShop2D(arg0_99)
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

	local var0_99 = arg0_99.showingShop:IsInTime()

	setActive(arg0_99.shop2DPage:Find("lock"), not var0_99)

	if var0_99 then
		arg0_99:SetCloseAndRefresh(arg0_99.shop2DPage)
	else
		setActive(arg0_99.shop2DPage:Find("remainAndRefresh"), false)

		if arg0_99.timer then
			arg0_99.timer:Stop()

			arg0_99.timer = nil
		end

		arg0_99.timer = Timer.New(function()
			local var0_100 = arg0_99.showingShop:GetExistTime()[1]
			local var1_100 = pg.TimeMgr.GetInstance():Table2ServerTime({
				year = var0_100[1][1],
				month = var0_100[1][2],
				day = var0_100[1][3],
				hour = var0_100[2][1],
				min = var0_100[2][2],
				sec = var0_100[2][3]
			})
			local var2_100 = pg.TimeMgr.GetInstance():GetServerTime()
			local var3_100 = pg.TimeMgr.GetInstance():DescCDTime(var1_100 - var2_100)

			setText(arg0_99.shop2DPage:Find("lock/openTimer"), i18n("island_3Dshop_time_unlock", var3_100))
		end, 1, -1)

		arg0_99.timer:Start()
	end

	arg0_99:SetCommodityList()
end

function var0_0.ShowShop3D(arg0_101)
	arg0_101:ClearCharacterScene()
	arg0_101:OverlayPanel(arg0_101._tf, {
		pbList = {
			arg0_101.shop3DPage:Find("bg")
		}
	})
	setActive(arg0_101.bgColor, false)

	arg0_101.shoppingCartCommodities = {}
	arg0_101.showingCommodity = nil

	arg0_101:ResetCommanderDressPreview(false)
	arg0_101:SetCloseAndRefresh(arg0_101.shop3DPage)
	arg0_101:SetCommodityList()
end

function var0_0.ShowShopFurniture(arg0_102)
	if not arg0_102.isLoadCharacterScene then
		arg0_102:PrepareCharacterScene()
	end

	arg0_102:OverlayPanel(arg0_102._tf, {
		pbList = {
			arg0_102.shopFurniturePage:Find("bg")
		}
	})
	setActive(arg0_102.bgColor, false)
	arg0_102:UnloadCharacter()

	arg0_102.shoppingCartCommodities = {}
	arg0_102.showingCommodity = nil

	arg0_102:ResetCommanderDressPreview(false)
	arg0_102:SetCloseAndRefresh(arg0_102.shopFurniturePage)
	arg0_102:SetCommodityList()
	setActive(arg0_102.shopFurniturePage:Find("scenePreviewBtn"), false)
	setActive(arg0_102.shopFurniturePage:Find("shoppingCartBtn"), false)
end

function var0_0.ShowShopSkin(arg0_103)
	if not arg0_103.isLoadCharacterScene then
		arg0_103:PrepareCharacterScene()
	end

	arg0_103:OverlayPanel(arg0_103._tf, {
		pbList = {
			arg0_103.shopSkinPage:Find("bg"),
			arg0_103.changeCharaPanel
		}
	})
	setActive(arg0_103.bgColor, false)

	if not arg0_103.shoppingCartCommodities then
		arg0_103.shoppingCartCommodities = {}
	end

	if #arg0_103.shoppingCartCommodities > 0 then
		local var0_103 = arg0_103.shoppingCartCommodities[1]:GetCommodityShowType()

		if var0_103 == IslandConst.COMMODITY_SHOW_FURNITURE or var0_103 == IslandConst.COMMODITY_SHOW_SKIN then
			arg0_103.shoppingCartCommodities = {}
			arg0_103.showingCommodity = nil

			arg0_103:ResetCommanderDressPreview(false, true)
		end
	end

	local var1_103 = arg0_103.showingShop:GetCommanderOrCharaType()

	if var1_103 == 0 and (arg0_103.showingShipId ~= 0 or #arg0_103.shoppingCartCommodities == 0) then
		arg0_103.showingShipId = 0

		local var2_103 = pg.island_unit_character[0]

		arg0_103:LoadCharacter({
			model = var2_103.model,
			animator = var2_103.animator
		}, true)

		arg0_103.shoppingCartCommodities = {}
		arg0_103.showingCommodity = nil

		arg0_103:ResetCommanderDressPreview(false)
	elseif var1_103 == 1 and (arg0_103.showingShipId ~= arg0_103.selectShipId or #arg0_103.shoppingCartCommodities == 0) then
		arg0_103:ResetCommanderDressPreview(false, true)

		arg0_103.showingShipId = arg0_103.selectShipId

		local var3_103 = arg0_103.characterAgency:GetShipById(arg0_103.showingShipId):GetModel()

		arg0_103:LoadCharacter(var3_103, false)

		arg0_103.shoppingCartCommodities = {}
		arg0_103.showingCommodity = nil

		arg0_103:ResetCommanderDressPreview(false)
	elseif var1_103 == 2 then
		arg0_103:ResetCommanderDressPreview(false, true)

		arg0_103.showingShipId = arg0_103.selectShipId

		arg0_103:UnloadCharacter()

		arg0_103.shoppingCartCommodities = {}
		arg0_103.showingCommodity = nil

		arg0_103:ResetCommanderDressPreview(false)
	end

	arg0_103:SetCloseAndRefresh(arg0_103.shopSkinPage)
	arg0_103:SetCommodityList()
	setActive(arg0_103.shopSkinPage:Find("cancelBtn"), #arg0_103.shoppingCartCommodities > 0)
	setActive(arg0_103.shopSkinPage:Find("changeCharaBtn"), var1_103 == 1)
	setActive(arg0_103.shopSkinPage:Find("shoppingCartBtn"), #arg0_103.shoppingCartCommodities > 0)
	setActive(arg0_103.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_103.shoppingCartCommodities > 0 and var1_103 == 1)
	setText(arg0_103.shopSkinPage:Find("shoppingCartBtn/count"), #arg0_103.shoppingCartCommodities .. "/3")
	setActive(arg0_103.shopSkinPage:Find("changeCharaPanel"), false)
	arg0_103:SetChangeCharaPanel()
	onButton(arg0_103, arg0_103.shopSkinPage:Find("changeCharaBtn"), function()
		setActive(arg0_103.shopSkinPage:Find("changeCharaPanel"), true)
	end, SFX_PANEL)
end

function var0_0.SetChangeCharaPanel(arg0_105)
	onButton(arg0_105, arg0_105.shopSkinPage:Find("changeCharaPanel/bg"), function()
		setActive(arg0_105.shopSkinPage:Find("changeCharaPanel"), false)
	end, SFX_PANEL)
	onButton(arg0_105, arg0_105.changeCharaPanel:Find("closeBtn"), function()
		setActive(arg0_105.shopSkinPage:Find("changeCharaPanel"), false)
	end, SFX_PANEL)

	local var0_105 = UIItemList.New(arg0_105.changeCharaPanel:Find("charaScroll/Viewport/Content"), arg0_105.changeCharaPanel:Find("charaScroll/Viewport/Content/IslandShipTpl"))

	var0_105:make(function(arg0_108, arg1_108, arg2_108)
		if arg0_108 == UIItemList.EventUpdate then
			local var0_108 = arg0_105.ships[arg1_108 + 1]
			local var1_108 = IslandShip.StaticGetPrefab(var0_108.id)

			GetImageSpriteFromAtlasAsync("ShipYardIcon/" .. var1_108, "", arg2_108:Find("mask/icon"))
			setText(arg2_108:Find("Text"), "Lv." .. var0_108:GetLevel())
			setActive(arg2_108:Find("add"), false)
			setActive(arg2_108:Find("select"), var0_108.id == arg0_105.selectShipId)
			onButton(arg0_105, arg2_108, function()
				if arg0_105.charaSetModel == var0_0.CharaSetModel.current then
					arg0_105:ResetCommanderDressPreview(false, true)

					arg0_105.selectShipId = var0_108.id
					arg0_105.showingShipId = var0_108.id

					arg0_105:LoadCharacter(var0_108:GetModel(), false)

					arg0_105.shoppingCartCommodities = {}
					arg0_105.showingCommodity = nil

					setActive(arg0_105.shopSkinPage:Find("cancelBtn"), false)
					setActive(arg0_105.shopSkinPage:Find("shoppingCartBtn"), false)
					setText(arg0_105.shopSkinPage:Find("shoppingCartBtn/count"), "0/3")
					arg0_105:SetCommodityList()
				elseif arg0_105.charaSetModel == var0_0.CharaSetModel.default then
					arg0_105.defaultShipId = var0_108.id

					PlayerPrefs.SetInt("island_dressShop_defaultShipId_" .. arg0_105.player.id, var0_108.id)
				end

				for iter0_109 = 0, arg0_105.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
					setActive(arg0_105.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter0_109):Find("select"), iter0_109 == arg1_108)
				end
			end, SFX_PANEL)
		end
	end)
	var0_105:align(#arg0_105.ships)

	arg0_105.charaSetModel = var0_0.CharaSetModel.current

	onButton(arg0_105, arg0_105.changeCharaPanel:Find("defaultSet"), function()
		if arg0_105.charaSetModel == var0_0.CharaSetModel.current then
			arg0_105.charaSetModel = var0_0.CharaSetModel.default

			for iter0_110 = 0, arg0_105.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
				setActive(arg0_105.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter0_110):Find("select"), arg0_105.ships[iter0_110 + 1].id == arg0_105.defaultShipId)
			end
		elseif arg0_105.charaSetModel == var0_0.CharaSetModel.default then
			arg0_105.charaSetModel = var0_0.CharaSetModel.current

			for iter1_110 = 0, arg0_105.changeCharaPanel:Find("charaScroll/Viewport/Content").childCount - 1 do
				setActive(arg0_105.changeCharaPanel:Find("charaScroll/Viewport/Content"):GetChild(iter1_110):Find("select"), arg0_105.ships[iter1_110 + 1].id == arg0_105.selectShipId)
			end
		end

		setActive(arg0_105.changeCharaPanel:Find("defaultSet/off"), arg0_105.charaSetModel == var0_0.CharaSetModel.current)
		setActive(arg0_105.changeCharaPanel:Find("defaultSet/on"), arg0_105.charaSetModel == var0_0.CharaSetModel.default)
	end, SFX_PANEL)
end

function var0_0.AddListeners(arg0_111)
	arg0_111:AddListener(GAME.ISLAND_SHOP_OP_DONE, arg0_111.UpdateView)
	arg0_111:AddListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_111.OnSwitchMapByPoint)
	arg0_111:AddListener(ActivityProxy.ACTIVITY_UPDATED, arg0_111.UpdateActivity)
	arg0_111:AddListener(GAME.ACTIVITY_DRAW_AWARD_OPERATION_DONE, arg0_111.DrawOperation)
end

function var0_0.RemoveListeners(arg0_112)
	arg0_112:RemoveListener(GAME.ISLAND_SHOP_OP_DONE, arg0_112.UpdateView)
	arg0_112:RemoveListener(ISLAND_EX_EVT.SWITCH_MAP_BY_POINT, arg0_112.OnSwitchMapByPoint)
	arg0_112:RemoveListener(ActivityProxy.ACTIVITY_UPDATED, arg0_112.UpdateActivity)
	arg0_112:RemoveListener(GAME.ACTIVITY_DRAW_AWARD_OPERATION_DONE, arg0_112.DrawOperation)
end

function var0_0.UpdateView(arg0_113, arg1_113)
	if arg1_113.operation == IslandConst.SHOP_GET_DATA then
		if arg1_113.refreshAll then
			arg0_113:UpdateData()
			arg0_113:SetShopList()
		else
			arg0_113:SetShopPage()
		end
	elseif arg1_113.operation == IslandConst.SHOP_BUY_COMMODITY then
		arg0_113.shoppingCartCommodities = {}

		arg0_113:SetShopPage()

		if arg0_113.myIslandShoppingCartLayer then
			arg0_113.myIslandShoppingCartLayer:Hide()
		end

		arg0_113:OpenPage(IslandShopBuySuccessLayer, arg1_113.awards, function()
			if arg0_113.showingShop:GetShowType() == IslandConst.SHOP_TYPE_SKIN then
				arg0_113:ShowMsgBox({
					type = IslandMsgBox.TYPE_COMMON,
					content = i18n("island_3Dshop_clothes_jump"),
					onYes = function()
						arg0_113:ClearCharacterScene(function()
							arg0_113:Hide()

							local var0_116 = arg0_113.showingShop:GetCommanderOrCharaType()

							if var0_116 == 0 then
								arg0_113:OpenScenePage(IslandShipIslandCommanderMainPage)
							elseif var0_116 == 1 or var0_116 == 2 then
								arg0_113:OpenScenePage(IslandShipMainPage, 3)
							end
						end)
					end
				})
			end
		end)

		if arg0_113.myIslandShopItemLayer then
			arg0_113.myIslandShopItemLayer:Refresh()
		end
	elseif arg1_113.operation == IslandConst.REFRESH_SHOP_BY_PLAYER then
		arg0_113:SetShopPage()
	end
end

function var0_0.OnSwitchMapByPoint(arg0_117)
	setActive(arg0_117._tf, true)
	arg0_117:PrepareCharacterScene()
end

function var0_0.UpdateActivity(arg0_118, arg1_118)
	if arg1_118:getConfig("type") == ActivityConst.ACTIVITY_TYPE_ISLAND_DRAW_AWARD then
		arg0_118.drawAwardActivity = arg1_118

		arg0_118.drawAwardPage:ActionInvoke("UpdateActivity", arg0_118.drawAwardActivity)
		arg0_118:SetResources()
	end
end

function var0_0.DrawOperation(arg0_119, arg1_119)
	arg0_119.drawAwardPage:ActionInvoke("DrawOperation", arg1_119)
end

function var0_0.Preload(arg0_120, arg1_120)
	arg1_120()
end

function var0_0.GetSmoothRotateObject(arg0_121)
	return arg0_121._tf:Find("adapt/model")
end

function var0_0.LoadFurniture(arg0_122, arg1_122, arg2_122)
	arg0_122:UnloadCharacter()

	if arg0_122.isLoadingModel then
		return
	end

	arg0_122.isLoadingModel = true

	local var0_122 = IslandAssetLoadDispatcher.Instance:Enqueue(arg1_122, "", typeof(GameObject), UnityEngine.Events.UnityAction_UnityEngine_Object(function(arg0_123)
		arg0_122.role = Object.Instantiate(arg0_123)

		local var0_123 = arg0_122.role.name
		local var1_123 = GameObject.New(var0_123)

		setParent(arg0_122.role, var1_123.transform, false)

		arg0_122.role = var1_123
		arg0_122.isLoadingModel = false

		pg.ViewUtils.SetLayer(arg0_122.role.transform, Layer.Character3D)
		setParent(arg0_122.role, arg0_122.roleContainer)

		arg0_122.role.transform.localPosition = Vector3(arg2_122[1][1], arg2_122[1][2], 0)
		arg0_122.role.transform.localEulerAngles = Vector3(0, arg2_122[2], 0)
		arg0_122.role.transform.localScale = Vector3(arg2_122[3], arg2_122[3], arg2_122[3])

		local var2_123 = arg0_122:GetSmoothRotateObject()
		local var3_123 = GetOrAddComponent(var2_123, typeof(SmoothRotateObject))

		var3_123:SetUp(arg0_122.role.transform)

		var3_123.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int
	end), true, true)

	table.insert(arg0_122.loadingIdList or {}, var0_122)
end

function var0_0.LoadCharacter(arg0_124, arg1_124, arg2_124)
	arg0_124:UnloadCharacter()

	if arg0_124.isLoadingModel then
		return
	end

	arg0_124.isLoadingModel = true

	arg0_124.islandShipDressHelper:SetShipId(arg0_124.showingShipId)

	arg0_124.isCommander = arg2_124
	arg0_124.modelData = arg1_124

	local function var0_124(arg0_125)
		arg0_124.role = arg0_125
		arg0_124.isLoadingModel = false

		pg.ViewUtils.SetLayer(arg0_124.role.transform, Layer.Character3D)
		setParent(arg0_124.role, arg0_124.roleContainer)

		local var0_125 = 2.7
		local var1_125 = arg0_124._tf.rect.width / arg0_124._tf.rect.height

		if var1_125 < 1.77777777777778 then
			var0_125 = 2.7 - 0.5 * (1.77777777777778 - var1_125) / 0.444444444444444
		end

		arg0_124.role.transform.localPosition = Vector3(var0_125, 0, 0)
		arg0_124.role.transform.localEulerAngles = Vector3(0, -155, 0)

		local var2_125 = arg0_124:GetSmoothRotateObject()
		local var3_125 = GetOrAddComponent(var2_125, typeof(SmoothRotateObject))

		var3_125:SetUp(arg0_124.role.transform)

		var3_125.rotationSpeed = pg.island_set.character_detail_camera_speed.key_value_int

		arg0_124.displayUnit:OnAttach(arg0_125, arg0_124.toolContainer)

		local var4_125 = arg0_124.modelData and arg0_124.modelData.personal_ani

		if var4_125 and var4_125 ~= "" then
			local var5_125 = GetOrAddComponent(arg0_124.role.transform:GetChild(0), typeof(Animator))

			for iter0_125 = 1, var5_125.layerCount do
				var5_125:CrossFadeInFixedTime(var4_125, 0, iter0_125 - 1)
			end
		end

		arg0_124.islandShipDressHelper:OnRoleLoaded(arg0_124.role.transform, arg0_124.modelData)
	end

	if arg0_124.isCommander then
		arg0_124:GetPoolMgr():GetCommanderModel(arg1_124, function(arg0_126)
			var0_124(arg0_126)
		end)
	else
		arg0_124:GetPoolMgr():GetCharacter(arg1_124.model, arg1_124.animator, function(arg0_127)
			var0_124(arg0_127)
		end)
	end
end

function var0_0.UnloadCharacter(arg0_128)
	arg0_128.islandShipDressHelper:InvalidateRole()
	arg0_128.islandShipDressHelper:Destroy()

	if arg0_128.role then
		arg0_128.displayUnit:OnDetach()
		pg.ViewUtils.SetLayer(arg0_128.role.transform, Layer.Default)

		if arg0_128.isCommander then
			arg0_128:GetPoolMgr():ReturnCommanderModel(arg0_128.role)
		elseif arg0_128.modelData then
			arg0_128:GetPoolMgr():ReturnCharacter(arg0_128.modelData.model, arg0_128.modelData.animator, arg0_128.role)

			arg0_128.modelData = nil
		end

		arg0_128.role = nil
	end

	arg0_128.modelData = nil
end

function var0_0.OnShow(arg0_129, arg1_129, arg2_129, arg3_129)
	arg0_129:OverlayPanel(arg0_129._tf)

	arg0_129.showTypes = arg1_129
	arg0_129.firstShopIds = arg2_129
	arg0_129.showDrawAward = arg3_129 == 1
	arg0_129.drawAwardActivity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_ISLAND_DRAW_AWARD)

	arg0_129:DoUpdateShops()
	arg0_129:UpdateData()
	arg0_129:SetShopList()
end

function var0_0.OnHide(arg0_130)
	arg0_130:UnOverlayPanel(arg0_130._tf)

	if arg0_130.timer then
		arg0_130.timer:Stop()

		arg0_130.timer = nil
	end

	arg0_130:ResetCommanderDressPreview(false)

	arg0_130.shoppingCartCommodities = {}
	arg0_130.showingCommodity = nil

	arg0_130.islandShipDressHelper:Destroy()
	arg0_130:UnloadCharacter()
	arg0_130.drawAwardPage:Destroy()
	arg0_130.drawAwardPage:Reset()

	for iter0_130, iter1_130 in ipairs(arg0_130.loadingIdList or {}) do
		IslandAssetLoadDispatcher.Instance:Cancel(iter1_130)
	end

	arg0_130.loadingIdList = {}
end

function var0_0.OnDisable(arg0_131)
	arg0_131:OnHide()
	var0_0.super.OnDisable(arg0_131)
end

function var0_0.OnDestroy(arg0_132)
	arg0_132:OnHide()
	var0_0.super.OnDestroy(arg0_132)
end

function var0_0.CanEsc(arg0_133)
	if arg0_133.morphing then
		return false
	end

	return true
end

function var0_0.StaticUpdateCommodityTpl(arg0_134, arg1_134)
	local var0_134 = arg1_134:GetMaxNum() - arg1_134.purchasedNum

	setText(arg0_134:Find("name"), arg1_134:GetName())

	if #arg1_134:GetItems() == 1 and arg1_134:GetItems()[1][1] ~= DROP_TYPE_ISLAND_FURNITURE and arg1_134:GetItems()[1][1] ~= DROP_TYPE_ISLAND_DRESS and arg1_134:GetItems()[1][1] ~= DROP_TYPE_ISLAND_SKIN then
		local var1_134 = arg1_134:GetItems()[1]
		local var2_134 = {
			type = var1_134[1],
			id = var1_134[2],
			count = var1_134[3]
		}

		updateCustomDrop(arg0_134:Find("IslandItemTpl"), var2_134, {
			style = "island"
		})
	else
		GetImageSpriteFromAtlasAsync(arg1_134:GetIcon(), "", arg0_134:Find("IslandItemTpl/icon_bg/icon"))
	end

	setActive(arg0_134:Find("IslandItemTpl/icon_bg/count_bg"), arg1_134:IsShowPurchaseLimit())
	setText(arg0_134:Find("IslandItemTpl/icon_bg/count_bg/count"), var0_134 .. "/" .. arg1_134:GetMaxNum())

	local var3_134 = arg1_134:GetResourceConsume()

	GetImageSpriteFromAtlasAsync(Drop.New({
		type = var3_134[1],
		id = var3_134[2]
	}):getIcon(), "", arg0_134:Find("cost/icon"))
	setText(arg0_134:Find("cost/num"), math.ceil((100 - arg1_134:GetDiscount()) / 100 * var3_134[3]))

	local var4_134 = arg1_134:GetTag()

	setActive(arg0_134:Find("tags/timeLimit"), var4_134 == IslandCommodity.TAG.TIME)
	setActive(arg0_134:Find("tags/new"), var4_134 == IslandCommodity.TAG.NEW)
	setActive(arg0_134:Find("tags/hot"), var4_134 == IslandCommodity.TAG.HOT)
	setActive(arg0_134:Find("discount"), arg1_134:GetDiscount() ~= 0)
	setText(arg0_134:Find("discount/Text"), "-" .. arg1_134:GetDiscount() .. "%")

	local var5_134 = arg1_134:GetItems()[1][1]
	local var6_134 = arg1_134:GetItems()[1][2]
	local var7_134 = Drop.New({
		count = 1,
		type = var5_134,
		id = var6_134
	}):getOwnedCount()

	setActive(arg0_134:Find("have"), arg1_134:IsShowHave())
	setText(arg0_134:Find("have"), i18n("island_3Dshop_have") .. var7_134)

	local var8_134 = underscore.all(arg1_134:GetItems(), function(arg0_135)
		return Drop.New({
			count = 1,
			type = arg0_135[1],
			id = arg0_135[2]
		}):getOwnedCount() > 0
	end)

	setActive(arg0_134:Find("hold"), arg1_134:IsShowHold() and (arg1_134:IsCharacterInviteItemHold() or var8_134))
	setActive(arg0_134:Find("sellOut"), arg1_134:GetMaxNum() ~= 0 and var0_134 == 0 and not isActive(arg0_134:Find("hold")))
	setActive(arg0_134:Find("cost"), not isActive(arg0_134:Find("sellOut")) and not isActive(arg0_134:Find("hold")))
	setActive(arg0_134:Find("select"), false)
	setText(arg0_134:Find("sellOut/Text"), i18n("common_sale_out"))
	setText(arg0_134:Find("hold/Text"), i18n("common_already owned"))
end

function var0_0.SortShopCommodities(arg0_136)
	table.sort(arg0_136, CompareFuncs({
		function(arg0_137)
			local var0_137 = arg0_137:GetMaxNum() - arg0_137.purchasedNum

			if arg0_137:GetMaxNum() ~= 0 and var0_137 == 0 then
				return 3
			end

			if arg0_137:IsShowHold() then
				if arg0_137:IsCharacterInviteItemHold() then
					return 2
				else
					return underscore.all(arg0_137:GetItems(), function(arg0_138)
						return Drop.New({
							count = 1,
							type = arg0_138[1],
							id = arg0_138[2]
						}):getOwnedCount() > 0
					end) and 2 or 1
				end
			else
				return 1
			end
		end,
		function(arg0_139)
			return arg0_139:GetCfgSortIdx()
		end,
		function(arg0_140)
			return arg0_140.id
		end
	}))
end

return var0_0
