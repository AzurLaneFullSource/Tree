local var0_0 = class("Dorm3dShopUI", import("view.base.BaseUI"))
local var1_0 = pg.dorm3d_set
local var2_0 = pg.dorm3d_shop_template
local var3_0 = setmetatable({}, {
	__index = function(arg0_1, arg1_1)
		arg0_1[arg1_1] = ShopConst.GetShopConfig(arg1_1)

		return arg0_1[arg1_1]
	end
})
local var4_0 = pg.dorm3d_rooms
local var5_0 = pg.dorm3d_gift
local var6_0 = pg.dorm3d_furniture_template

function var0_0.getUIName(arg0_2)
	return "Dorm3dShopUI"
end

function var0_0.init(arg0_3)
	arg0_3.closeBtn = arg0_3.rtAdapt:Find("closeBtn")
	arg0_3.res = arg0_3.rtAdapt:Find("resourceBg/res")
	arg0_3.recommendationTg = arg0_3.rtAdapt:Find("left/recommendation")
	arg0_3.charaList = UIItemList.New(arg0_3.rtAdapt:Find("left/charaScroll/mask/list"), arg0_3.rtAdapt:Find("left/charaScroll/mask/list/tpl"))
	arg0_3.recommendationPage = arg0_3.rtAdapt:Find("pages/recommendationPage")
	arg0_3.charaPage = arg0_3.rtAdapt:Find("pages/charaPage")
	arg0_3.mask = arg0_3._tf:Find("mask")

	setText(arg0_3.rtAdapt:Find("title/Text"), i18n("dorm3d_shop_title"))
	setText(arg0_3.recommendationPage:Find("bannerCard/mask/content/item/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_3.recommendationPage:Find("giftCard/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_3.recommendationPage:Find("card1/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_3.recommendationPage:Find("card2/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_3.recommendationPage:Find("card3/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_3.charaPage:Find("scroll/Viewport/Content/card/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_3.charaPage:Find("switch/all/Text"), i18n("dorm3d_shop_all"))
	setText(arg0_3.charaPage:Find("switch/gift/Text"), i18n("dorm3d_shop_gift1"))
	setText(arg0_3.charaPage:Find("switch/furniture/Text"), i18n("dorm3d_shop_furniture"))
	setText(arg0_3.charaPage:Find("switch/others/Text"), i18n("dorm3d_shop_others"))
	setText(arg0_3.charaPage:Find("switch/all/selected/Text"), i18n("dorm3d_shop_all"))
	setText(arg0_3.charaPage:Find("switch/gift/selected/Text"), i18n("dorm3d_shop_gift1"))
	setText(arg0_3.charaPage:Find("switch/furniture/selected/Text"), i18n("dorm3d_shop_furniture"))
	setText(arg0_3.charaPage:Find("switch/others/selected/Text"), i18n("dorm3d_shop_others"))
end

function var0_0.didEnter(arg0_4)
	arg0_4:InitData()
	onButton(arg0_4, arg0_4.closeBtn, function()
		arg0_4:closeView()
	end, SFX_PANEL)
	arg0_4:ShowResUI()
	arg0_4:SetPageBtns()
	triggerToggle(arg0_4.recommendationTg, true)
end

function var0_0.InitData(arg0_6)
	arg0_6.bannerCount = var1_0.drom3d_shop_product_panel_num.key_value_int
	arg0_6.allCommodityCfgs = {}

	for iter0_6, iter1_6 in ipairs(var2_0.all) do
		table.insert(arg0_6.allCommodityCfgs, var2_0[iter1_6])
	end

	table.sort(arg0_6.allCommodityCfgs, function(arg0_7, arg1_7)
		if tonumber(arg0_7.order) ~= tonumber(arg1_7.order) then
			return tonumber(arg0_7.order) < tonumber(arg1_7.order)
		end

		return arg0_7.id > arg1_7.id
	end)

	arg0_6.roomCfgs = {}

	_.each(var4_0.all, function(arg0_8)
		if var4_0[arg0_8].type == 2 then
			table.insert(arg0_6.roomCfgs, var4_0[arg0_8])
		end
	end)
	table.sort(arg0_6.roomCfgs, function(arg0_9, arg1_9)
		return arg0_9.id < arg1_9.id
	end)

	arg0_6.selectedId = 0
end

function var0_0.SetPageBtns(arg0_10)
	SetParent(arg0_10.recommendationTg, arg0_10.rtAdapt:Find("left"), false)
	arg0_10.charaList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventUpdate then
			local var0_11 = arg0_10.roomCfgs[arg1_11 + 1]
			local var1_11 = string.format("dorm3dselect/room_icon_%s", string.lower(var0_11.assets_prefix))

			GetImageSpriteFromAtlasAsync(var1_11, "", arg2_11:Find("mask/icon"), false)

			local var2_11 = arg0_10:GetCommoditiesCfgByChara(var0_11.character[1])

			setActive(arg2_11:Find("tip"), var0_0.ShouldShowSumTip(var2_11))
			onToggle(arg0_10, arg2_11, function(arg0_12)
				if arg0_12 then
					arg0_10.selectedId = var0_11.id

					arg0_10:SetPageBtns()
					arg0_10:RefreshPage()
				end
			end)
		end
	end)
	arg0_10.charaList:align(#arg0_10.roomCfgs)

	arg0_10.showingCommoditiesIndex = {}

	local var0_10 = {}

	table.insertto(var0_10, arg0_10:GetCommoditiesCfgByPanel(1, arg0_10.bannerCount))
	table.insertto(var0_10, arg0_10:GetCommoditiesCfgByPanel(2, 1))
	table.insertto(var0_10, arg0_10:GetCommoditiesCfgByPanel(3, 1))
	table.insertto(var0_10, arg0_10:GetCommoditiesCfgByPanel(4, 1))
	table.insertto(var0_10, arg0_10:GetCommoditiesCfgByPanel(5, 1))
	setActive(arg0_10.recommendationTg:Find("icon/tip"), var0_0.ShouldShowSumTip(var0_10))
	onToggle(arg0_10, arg0_10.recommendationTg, function(arg0_13)
		if arg0_13 then
			arg0_10.selectedId = 0

			arg0_10:SetPageBtns()
			arg0_10:RefreshPage()
		end
	end)
	SetParent(arg0_10.recommendationTg, arg0_10.rtAdapt:Find("left/charaScroll/mask/list"), false)
	arg0_10.recommendationTg:SetSiblingIndex(0)
end

function var0_0.GetCommoditiesCfgByPanel(arg0_14, arg1_14, arg2_14)
	local var0_14 = {}
	local var1_14 = 0

	for iter0_14, iter1_14 in ipairs(arg0_14.allCommodityCfgs) do
		if not table.contains(arg0_14.showingCommoditiesIndex, iter0_14) and table.contains(iter1_14.panel, arg1_14) then
			if not (arg0_14:IsCommodityOutOfDate(iter1_14) or arg0_14:IsCommoditySoldOut(iter1_14)) then
				var1_14 = var1_14 + 1

				table.insert(var0_14, iter1_14)
				table.insert(arg0_14.showingCommoditiesIndex, iter0_14)
			end

			if var1_14 == arg2_14 then
				break
			end
		end
	end

	if var1_14 < arg2_14 then
		for iter2_14, iter3_14 in ipairs(arg0_14.allCommodityCfgs) do
			if not table.contains(arg0_14.showingCommoditiesIndex, iter2_14) and table.contains(iter3_14.panel, arg1_14) then
				if not arg0_14:IsCommodityOutOfDate(iter3_14) then
					var1_14 = var1_14 + 1

					table.insert(var0_14, iter3_14)
					table.insert(arg0_14.showingCommoditiesIndex, iter2_14)
				end

				if var1_14 == arg2_14 then
					break
				end
			end
		end
	end

	return var0_14
end

function var0_0.GetCommoditiesCfgByChara(arg0_15, arg1_15)
	local var0_15 = {}
	local var1_15 = {}

	for iter0_15, iter1_15 in ipairs(arg0_15.allCommodityCfgs) do
		local var2_15 = {}

		if iter1_15.realroom_id ~= 0 then
			table.insertto(var2_15, var4_0[iter1_15.realroom_id].character)
			table.insertto(var2_15, var4_0[iter1_15.realroom_id].character_pay)
		end

		if (iter1_15.room_id == arg1_15 or iter1_15.room_id == 0) and (iter1_15.realroom_id == 0 or iter1_15.realroom_id ~= 0 and table.contains(var2_15, arg1_15)) then
			local var3_15 = arg0_15:IsCommodityOutOfDate(iter1_15)
			local var4_15 = arg0_15:IsCommoditySoldOut(iter1_15)

			if not var3_15 then
				if not var4_15 then
					table.insert(var0_15, iter1_15)
				else
					table.insert(var1_15, iter1_15)
				end
			end
		end
	end

	if #var1_15 > 0 then
		table.insertto(var0_15, var1_15)
	end

	return var0_15
end

function var0_0.IsCommodityOutOfDate(arg0_16, arg1_16)
	local var0_16 = arg1_16.shop_id

	for iter0_16, iter1_16 in ipairs(var0_16) do
		local var1_16 = var3_0[iter1_16]

		if not pg.TimeMgr.GetInstance():inTime(var1_16.time) then
			return true
		end
	end

	return false
end

function var0_0.IsCommoditySoldOut(arg0_17, arg1_17)
	if arg1_17.type == 1 then
		if getProxy(ApartmentProxy):GetFurnitureShopCount(arg1_17.item_id) > 0 then
			return true
		end
	elseif arg1_17.type == 2 then
		return not Dorm3dGift.New({
			configId = arg1_17.item_id
		}):CheckBuyLimit()
	elseif arg1_17.type == 3 then
		local var0_17 = getProxy(ApartmentProxy):getRoom(arg1_17.item_id)

		return var0_17 and var0_17.unlockCharacter[arg1_17.room_id]
	end

	return false
end

function var0_0.ShowResUI(arg0_18)
	local var0_18 = getProxy(PlayerProxy):getRawData()

	arg0_18.goldMax = arg0_18.res:Find("gold/max"):GetComponent(typeof(Text))
	arg0_18.goldValue = arg0_18.res:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_18.oilMax = arg0_18.res:Find("oil/max"):GetComponent(typeof(Text))
	arg0_18.oilValue = arg0_18.res:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_18.gemValue = arg0_18.res:Find("gem/Text"):GetComponent(typeof(Text))

	PlayerResUI.StaticFlush(var0_18, arg0_18.goldMax, arg0_18.goldValue, arg0_18.oilMax, arg0_18.oilValue, arg0_18.gemValue)
	onButton(arg0_18, arg0_18.res:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.res:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_18, arg0_18.res:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.RefreshPage(arg0_22)
	arg0_22.showingCommoditiesIndex = {}

	setActive(arg0_22.recommendationPage, arg0_22.selectedId == 0)
	setActive(arg0_22.charaPage, arg0_22.selectedId ~= 0)

	if arg0_22.selectedId == 0 then
		arg0_22:SetBannnerCard()
		arg0_22:SetGiftCard()
		arg0_22:SetNormalCard()
	else
		arg0_22:SetCharaCard()
	end
end

function var0_0.SetBannnerCard(arg0_23)
	local var0_23 = arg0_23.recommendationPage:Find("bannerCard")
	local var1_23 = arg0_23:GetCommoditiesCfgByPanel(1, arg0_23.bannerCount)

	if not arg0_23.scrollSnap then
		arg0_23.scrollSnap = BannerScrollRectDorm3dShop.New(var0_23:Find("mask/content"), var0_23:Find("dots"))
	end

	for iter0_23, iter1_23 in ipairs(var1_23) do
		local var2_23 = arg0_23.scrollSnap:GetItemChild(iter0_23) or arg0_23.scrollSnap:AddChild()
		local var3_23 = arg0_23:IsCommoditySoldOut(iter1_23)
		local var4_23 = false
		local var5_23 = false
		local var6_23 = {}
		local var7_23 = 0
		local var8_23 = ""
		local var9_23 = ""
		local var10_23 = var3_0[iter1_23.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

		if iter1_23.type == 1 then
			local var11_23 = var6_0[iter1_23.item_id]

			var5_23 = var11_23.is_special == 1
			var4_23 = not var5_23 and var11_23.is_exclusive == 1
			var8_23 = Drop.New({
				count = 0,
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var11_23.id
			}):getIcon()
			var9_23 = var10_23 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(iter1_23.item_id) .. "/1"
			var6_23 = var11_23.unlock_tips or {}
			var7_23 = iter1_23.shop_id[1]
		elseif iter1_23.type == 2 then
			local var12_23 = var5_0[iter1_23.item_id]

			var4_23 = iter1_23.room_id ~= 0

			local var13_23 = Dorm3dGift.New({
				configId = iter1_23.item_id
			})

			var8_23 = Drop.New({
				type = DROP_TYPE_DORM3D_GIFT,
				id = iter1_23.item_id,
				count = getProxy(ApartmentProxy):getGiftCount(iter1_23.item_id)
			}):getIcon()

			local var14_23 = 0

			for iter2_23 = 1, #iter1_23.shop_id do
				local var15_23 = iter1_23.shop_id[iter2_23]
				local var16_23 = var3_0[var15_23]
				local var17_23 = var16_23.limit_args[1]

				if not var17_23 and var16_23.group_type == 0 then
					var14_23 = 0
				elseif var17_23 and (var17_23[1] == "dailycount" or var17_23[1] == "count") then
					var14_23 = var17_23[3]
				elseif var16_23.group_type == 2 then
					var14_23 = var16_23.group_limit
				end
			end

			var9_23 = var10_23 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(iter1_23.item_id) .. "/" .. var14_23

			setText(var2_23:Find("favor/number"), "+" .. pg.dorm3d_favor_trigger[var5_0[iter1_23.item_id].favor_trigger_id].num)

			var2_23:Find("favor"):GetComponent(typeof(CanvasGroup)).alpha = var3_23 and 0.5 or 1
			var6_23 = var12_23.unlock_tips or {}
			var7_23 = var13_23:GetShopID()
		elseif iter1_23.type == 3 then
			var4_23 = true

			local var18_23 = var4_0[iter1_23.item_id].invite_icon

			for iter3_23, iter4_23 in ipairs(var18_23) do
				if iter4_23[1] == iter1_23.room_id then
					var8_23 = iter4_23[2]
				end
			end

			local var19_23 = var3_23 and 1 or 0

			var9_23 = var10_23 .. " " .. var19_23 .. "/1"
			var7_23 = iter1_23.shop_id[1]
		end

		setActive(var2_23:Find("bg/normal"), not var4_23 and not var5_23)
		setActive(var2_23:Find("bg/zhuanshu"), var4_23)
		setActive(var2_23:Find("bg/tedian"), var5_23)
		setActive(var2_23:Find("normal"), not var4_23 and not var5_23)
		setActive(var2_23:Find("zhuanshu"), var4_23)
		setActive(var2_23:Find("tedian"), var5_23)
		setActive(var2_23:Find("favor"), iter1_23.type == 2)
		LoadImageSpriteAsync("dorm3dbanner/" .. iter1_23.banners[1] .. "_shopCard1", var2_23:Find("bannerMask/banner"), true)
		setText(var2_23:Find("name"), iter1_23.name)

		local var20_23 = var3_0[iter1_23.shop_id[1]].time

		setActive(var2_23:Find("timeLimit"), var20_23 ~= "always")

		if var20_23 ~= "always" then
			local var21_23 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var20_23[2])

			setText(var2_23:Find("timeLimit/Text"), arg0_23:GetTimeRemain(var21_23))
		end

		local var22_23 = UIItemList.New(var2_23:Find("bubbles/content"), var2_23:Find("bubbles/content/tpl"))

		arg0_23:SetBubbles(var22_23, var6_23)
		setActive(var2_23:Find("consume"), not var3_23)
		setActive(var2_23:Find("soldOut"), var3_23)

		local var23_23 = CommonCommodity.New({
			id = var7_23
		}, Goods.TYPE_SHOPSTREET)
		local var24_23, var25_23, var26_23 = var23_23:GetPrice()
		local var27_23 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var23_23:GetResType(),
			count = var24_23
		})

		setText(var2_23:Find("consume/Text"), "<icon name=" .. var23_23:GetResIcon() .. " w=0.81 h=0.81/>" .. var24_23)
		GetImageSpriteFromAtlasAsync(var8_23, "", var2_23:Find("normal/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var8_23, "", var2_23:Find("zhuanshu/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var8_23, "", var2_23:Find("tedian/Dorm3dIconTpl/icon"))
		setText(var2_23:Find("normal/countLimit"), var9_23)
		setText(var2_23:Find("zhuanshu/countLimit"), var9_23)
		setText(var2_23:Find("tedian/countLimit"), var9_23)

		var2_23:Find("normal/Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_23 and 0.5 or 1
		var2_23:Find("zhuanshu/Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_23 and 0.5 or 1
		var2_23:Find("tedian/Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_23 and 0.5 or 1

		if not var3_23 then
			onButton(arg0_23, var2_23, function()
				arg0_23:ClickCommodity(iter1_23, var2_23:Find("tip"))
			end, SFX_PANEL)
		else
			onButton(arg0_23, var2_23, function()
				var0_0.UpdateCommodtyTip(iter1_23)
				setActive(var2_23:Find("tip"), false)
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
			end, SFX_PANEL)
		end

		local var28_23 = var0_0.ShouldShowCommodtyTip(iter1_23)

		setActive(var2_23:Find("new"), var28_23)
		setActive(var2_23:Find("tip"), var28_23)
	end

	arg0_23.scrollSnap:SetUp()
end

function var0_0.SetGiftCard(arg0_26)
	local var0_26 = arg0_26.recommendationPage:Find("giftCard")
	local var1_26 = arg0_26:GetCommoditiesCfgByPanel(2, 1)[1]
	local var2_26 = 0
	local var3_26 = arg0_26:IsCommoditySoldOut(var1_26)
	local var4_26 = ""
	local var5_26 = false
	local var6_26 = false
	local var7_26 = var3_0[var1_26.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

	if var1_26.type == 1 then
		local var8_26 = var6_0[var1_26.item_id]

		var6_26 = var8_26.is_special == 1
		var5_26 = not var6_26 and var8_26.is_exclusive == 1

		local var9_26 = Drop.New({
			count = 0,
			type = DROP_TYPE_DORM3D_FURNITURE,
			id = var8_26.id
		})

		updateCustomDrop(var0_26:Find("Dorm3dIconTpl"), var9_26)

		var2_26 = var1_26.shop_id[1]
		var4_26 = var7_26 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(var1_26.item_id) .. "/1"
	elseif var1_26.type == 2 then
		local var10_26 = var5_0[var1_26.item_id]

		var5_26 = var1_26.room_id ~= 0

		local var11_26 = Dorm3dGift.New({
			configId = var1_26.item_id
		})
		local var12_26 = Drop.New({
			type = DROP_TYPE_DORM3D_GIFT,
			id = var1_26.item_id,
			count = getProxy(ApartmentProxy):getGiftCount(var1_26.item_id)
		})

		setText(var0_26:Find("favor/number"), "+" .. pg.dorm3d_favor_trigger[var5_0[var1_26.item_id].favor_trigger_id].num)
		updateCustomDrop(var0_26:Find("Dorm3dIconTpl"), var12_26)

		var2_26 = var11_26:GetShopID()

		local var13_26 = 0

		for iter0_26 = 1, #var1_26.shop_id do
			local var14_26 = var1_26.shop_id[iter0_26]
			local var15_26 = var3_0[var14_26]
			local var16_26 = var15_26.limit_args[1]

			if not var16_26 and var15_26.group_type == 0 then
				var13_26 = 0
			elseif var16_26 and (var16_26[1] == "dailycount" or var16_26[1] == "count") then
				var13_26 = var16_26[3]
			elseif var15_26.group_type == 2 then
				var13_26 = var15_26.group_limit
			end
		end

		var4_26 = var7_26 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(var1_26.item_id) .. "/" .. var13_26
	elseif var1_26.type == 3 then
		var5_26 = true

		local var17_26 = var4_0[var1_26.item_id].invite_icon
		local var18_26 = ""

		for iter1_26, iter2_26 in ipairs(var17_26) do
			if iter2_26[1] == var1_26.room_id then
				var18_26 = iter2_26[2]
			end
		end

		GetImageSpriteFromAtlasAsync(var18_26, "", var0_26:Find("Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var1_26.rarity), var0_26:Find("Dorm3dIconTpl"))

		local var19_26 = var3_26 and 1 or 0

		var4_26 = var7_26 .. " " .. var19_26 .. "/1"
		var2_26 = var1_26.shop_id[1]
	end

	var0_26:Find("Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_26 and 0.5 or 1
	var0_26:Find("favor"):GetComponent(typeof(CanvasGroup)).alpha = var3_26 and 0.5 or 1

	setActive(var0_26:Find("bg/normal"), not var5_26 and not var6_26)
	setActive(var0_26:Find("bg/zhuanshu"), var5_26)
	setActive(var0_26:Find("bg/tedian"), var6_26)
	setActive(var0_26:Find("normal"), not var5_26 and not var6_26)
	setActive(var0_26:Find("zhuanshu"), var5_26)
	setActive(var0_26:Find("tedian"), var6_26)
	setText(var0_26:Find("normal/countLimit"), var4_26)
	setText(var0_26:Find("zhuanshu/countLimit"), var4_26)
	setText(var0_26:Find("tedian/countLimit"), var4_26)
	LoadImageSpriteAsync("dorm3dbanner/" .. var1_26.banners[1] .. "_shopCard2", var0_26:Find("mask/item"), true)
	setScrollText(var0_26:Find("name/text"), var1_26.name)
	setActive(var0_26:Find("favor"), var1_26.type == 2)
	setActive(var0_26:Find("consume"), not var3_26)
	setActive(var0_26:Find("soldOut"), var3_26)

	local var20_26 = var3_0[var1_26.shop_id[1]].time

	setActive(var0_26:Find("timeLimit"), var20_26 ~= "always")

	if var20_26 ~= "always" then
		local var21_26 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var20_26[2])

		setText(var0_26:Find("timeLimit/Text"), arg0_26:GetTimeRemain(var21_26))
	end

	local var22_26 = CommonCommodity.New({
		id = var2_26
	}, Goods.TYPE_SHOPSTREET)
	local var23_26, var24_26, var25_26 = var22_26:GetPrice()
	local var26_26 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var22_26:GetResType(),
		count = var23_26
	})

	setText(var0_26:Find("consume/Text"), "<icon name=" .. var22_26:GetResIcon() .. " w=0.81 h=0.81/>" .. var23_26)

	if not var3_26 then
		onButton(arg0_26, var0_26, function()
			arg0_26:ClickCommodity(var1_26, var0_26:Find("tip"))
		end, SFX_PANEL)
	else
		onButton(arg0_26, var0_26, function()
			var0_0.UpdateCommodtyTip(var1_26)
			setActive(var0_26:Find("tip"), false)
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
		end, SFX_PANEL)
	end

	local var27_26 = var0_0.ShouldShowCommodtyTip(var1_26)

	setActive(var0_26:Find("new"), var27_26)
	setActive(var0_26:Find("tip"), var27_26)
end

function var0_0.SetNormalCard(arg0_29)
	for iter0_29 = 1, 3 do
		local var0_29 = arg0_29.recommendationPage:Find("card" .. iter0_29)
		local var1_29 = arg0_29:GetCommoditiesCfgByPanel(iter0_29 + 2, 1)[1]
		local var2_29 = false
		local var3_29 = false
		local var4_29 = arg0_29:IsCommoditySoldOut(var1_29)
		local var5_29 = {}
		local var6_29 = 0
		local var7_29 = ""
		local var8_29 = var3_0[var1_29.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

		if var1_29.type == 1 then
			local var9_29 = var6_0[var1_29.item_id]

			var2_29 = var9_29.is_special == 1
			var3_29 = not var2_29 and var9_29.is_exclusive == 1
			var7_29 = Drop.New({
				count = 0,
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var9_29.id
			}):getIcon()

			setText(var0_29:Find("countLimit/Text"), var8_29 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(var1_29.item_id) .. "/1")

			var5_29 = var9_29.unlock_tips or {}
			var6_29 = var1_29.shop_id[1]
		elseif var1_29.type == 2 then
			local var10_29 = var5_0[var1_29.item_id]

			var3_29 = var1_29.room_id ~= 0

			local var11_29 = Dorm3dGift.New({
				configId = var1_29.item_id
			})

			var7_29 = Drop.New({
				type = DROP_TYPE_DORM3D_GIFT,
				id = var1_29.item_id,
				count = getProxy(ApartmentProxy):getGiftCount(var1_29.item_id)
			}):getIcon()

			local var12_29 = 0

			for iter1_29 = 1, #var1_29.shop_id do
				local var13_29 = var1_29.shop_id[iter1_29]
				local var14_29 = var3_0[var13_29]
				local var15_29 = var14_29.limit_args[1]

				if not var15_29 and var14_29.group_type == 0 then
					var12_29 = 0
				elseif var15_29 and (var15_29[1] == "dailycount" or var15_29[1] == "count") then
					var12_29 = var15_29[3]
				elseif var14_29.group_type == 2 then
					var12_29 = var14_29.group_limit
				end
			end

			setText(var0_29:Find("countLimit/Text"), var8_29 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(var1_29.item_id) .. "/" .. var12_29)

			local var16_29 = pg.dorm3d_favor_trigger[var5_0[var1_29.item_id].favor_trigger_id].num

			setText(var0_29:Find("normal/favor/number"), "+" .. var16_29)
			setText(var0_29:Find("zhuanshu/favor/number"), "+" .. var16_29)
			setText(var0_29:Find("tedian/favor/number"), "+" .. var16_29)

			var5_29 = var10_29.unlock_tips or {}
			var6_29 = var11_29:GetShopID()
		elseif var1_29.type == 3 then
			var3_29 = true

			local var17_29 = var4_0[var1_29.item_id].invite_icon

			for iter2_29, iter3_29 in ipairs(var17_29) do
				if iter3_29[1] == var1_29.room_id then
					var7_29 = iter3_29[2]
				end
			end

			local var18_29 = var4_29 and 1 or 0

			setText(var0_29:Find("countLimit/Text"), var8_29 .. " " .. var18_29 .. "/1")

			var6_29 = var1_29.shop_id[1]
		end

		setActive(var0_29:Find("bg/normal"), not var3_29 and not var2_29)
		setActive(var0_29:Find("bg/zhuanshu"), var3_29)
		setActive(var0_29:Find("bg/tedian"), var2_29)
		setActive(var0_29:Find("normal"), not var3_29 and not var2_29)
		setActive(var0_29:Find("zhuanshu"), var3_29)
		setActive(var0_29:Find("tedian"), var2_29)
		setActive(var0_29:Find("normal/favor"), var1_29.type == 2)
		setActive(var0_29:Find("zhuanshu/favor"), var1_29.type == 2)
		setActive(var0_29:Find("tedian/favor"), var1_29.type == 2)
		setText(var0_29:Find("name"), var1_29.name)

		local var19_29 = UIItemList.New(var0_29:Find("bubbles/content"), var0_29:Find("bubbles/content/tpl"))

		arg0_29:SetBubbles(var19_29, var5_29)
		setActive(var0_29:Find("consume"), not var4_29)
		setActive(var0_29:Find("soldOut"), var4_29)

		local var20_29 = CommonCommodity.New({
			id = var6_29
		}, Goods.TYPE_SHOPSTREET)
		local var21_29, var22_29, var23_29 = var20_29:GetPrice()
		local var24_29 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var20_29:GetResType(),
			count = var21_29
		})

		setText(var0_29:Find("consume/Text"), "<icon name=" .. var20_29:GetResIcon() .. " w=0.81 h=0.81/>" .. var21_29)
		GetImageSpriteFromAtlasAsync(var7_29, "", var0_29:Find("normal/mask/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var7_29, "", var0_29:Find("zhuanshu/mask/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var7_29, "", var0_29:Find("tedian/mask/Dorm3dIconTpl/icon"))

		if not var4_29 then
			onButton(arg0_29, var0_29, function()
				arg0_29:ClickCommodity(var1_29, var0_29:Find("tip"))
			end, SFX_PANEL)
		else
			onButton(arg0_29, var0_29, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
				var0_0.UpdateCommodtyTip(var1_29)
				setActive(var0_29:Find("tip"), false)
			end, SFX_PANEL)
		end

		local var25_29 = var0_0.ShouldShowCommodtyTip(var1_29)

		setActive(var0_29:Find("new"), var25_29)
		setActive(var0_29:Find("tip"), var25_29)
	end
end

function var0_0.SetCharaCard(arg0_32)
	local var0_32 = arg0_32:GetCommoditiesCfgByChara(var4_0[arg0_32.selectedId].character[1])
	local var1_32 = UIItemList.New(arg0_32.charaPage:Find("scroll/Viewport/Content"), arg0_32.charaPage:Find("scroll/Viewport/Content/card"))
	local var2_32 = {}

	var1_32:make(function(arg0_33, arg1_33, arg2_33)
		if arg0_33 == UIItemList.EventInit then
			local var0_33 = var0_32[arg1_33 + 1]

			table.insert(var2_32, {
				var0_33.type,
				arg2_33
			})

			local var1_33 = arg0_32:IsCommoditySoldOut(var0_33)
			local var2_33 = false
			local var3_33 = false
			local var4_33 = ""
			local var5_33 = {}
			local var6_33 = 0
			local var7_33 = var3_0[var0_33.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

			if var0_33.type == 1 then
				local var8_33 = var6_0[var0_33.item_id]

				var3_33 = var8_33.is_special == 1
				var2_33 = not var3_33 and var8_33.is_exclusive == 1
				var4_33 = Drop.New({
					count = 0,
					type = DROP_TYPE_DORM3D_FURNITURE,
					id = var8_33.id
				}):getIcon()

				setText(arg2_33:Find("descScroll/Viewport/Content/desc"), var8_33.desc)
				setText(arg2_33:Find("countLimit"), var7_33 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(var0_33.item_id) .. "/1")

				var5_33 = var8_33.unlock_tips or {}
				var6_33 = var0_33.shop_id[1]
			elseif var0_33.type == 2 then
				local var9_33 = var5_0[var0_33.item_id]

				var2_33 = var0_33.room_id ~= 0

				local var10_33 = Dorm3dGift.New({
					configId = var0_33.item_id
				})

				var4_33 = Drop.New({
					type = DROP_TYPE_DORM3D_GIFT,
					id = var0_33.item_id,
					count = getProxy(ApartmentProxy):getGiftCount(var0_33.item_id)
				}):getIcon()

				setText(arg2_33:Find("descScroll/Viewport/Content/desc"), var9_33.display)

				local var11_33 = 0

				for iter0_33 = 1, #var0_33.shop_id do
					local var12_33 = var0_33.shop_id[iter0_33]
					local var13_33 = var3_0[var12_33]
					local var14_33 = var13_33.limit_args[1]

					if not var14_33 and var13_33.group_type == 0 then
						var11_33 = 0
					elseif var14_33 and (var14_33[1] == "dailycount" or var14_33[1] == "count") then
						var11_33 = var14_33[3]
					elseif var13_33.group_type == 2 then
						var11_33 = var13_33.group_limit
					end
				end

				setText(arg2_33:Find("countLimit"), var7_33 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(var0_33.item_id) .. "/" .. var11_33)
				setText(arg2_33:Find("favor/number"), "+" .. pg.dorm3d_favor_trigger[var5_0[var0_33.item_id].favor_trigger_id].num)

				var5_33 = var9_33.unlock_tips or {}
				var6_33 = var10_33:GetShopID()
			elseif var0_33.type == 3 then
				var2_33 = true

				local var15_33 = var4_0[var0_33.item_id]
				local var16_33 = var15_33.invite_icon

				for iter1_33, iter2_33 in ipairs(var16_33) do
					if iter2_33[1] == var0_33.room_id then
						var4_33 = iter2_33[2]
					end
				end

				setText(arg2_33:Find("descScroll/Viewport/Content/desc"), var15_33.room_des)

				local var17_33 = var1_33 and 1 or 0

				setText(arg2_33:Find("countLimit"), var7_33 .. " " .. var17_33 .. "/1")

				var6_33 = var0_33.shop_id[1]
			end

			setActive(arg2_33:Find("bg/normal"), not var1_33)
			setActive(arg2_33:Find("bg/soldOut"), var1_33)
			setActive(arg2_33:Find("normal"), not var2_33 and not var3_33)
			setActive(arg2_33:Find("zhuanshu"), var2_33)
			setActive(arg2_33:Find("tedian"), var3_33)
			GetImageSpriteFromAtlasAsync(var4_33, "", arg2_33:Find("mask/Dorm3dIconTpl/icon"))
			setActive(arg2_33:Find("favor"), var0_33.type == 2)
			setScrollText(arg2_33:Find("name/text"), var0_33.name)

			local var18_33 = UIItemList.New(arg2_33:Find("bubbles/content"), arg2_33:Find("bubbles/content/tpl"))

			arg0_32:SetBubbles(var18_33, var5_33)

			local var19_33 = CommonCommodity.New({
				id = var6_33
			}, Goods.TYPE_SHOPSTREET)
			local var20_33, var21_33, var22_33 = var19_33:GetPrice()
			local var23_33 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = var19_33:GetResType(),
				count = var20_33
			})

			setText(arg2_33:Find("consume/Text"), "<icon name=" .. var19_33:GetResIcon() .. " w=0.81 h=0.81/>" .. var20_33)
			setActive(arg2_33:Find("consume"), not var1_33)
			setActive(arg2_33:Find("soldOut"), var1_33)

			local var24_33 = var3_0[var0_33.shop_id[1]].time

			setActive(arg2_33:Find("timeLimit"), var24_33 ~= "always")

			if var24_33 ~= "always" then
				local var25_33 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var24_33[2])

				setText(arg2_33:Find("timeLimit/Text"), arg0_32:GetTimeRemain(var25_33))
			end

			if not var1_33 then
				onButton(arg0_32, arg2_33, function()
					arg0_32:ClickCommodity(var0_33, arg2_33:Find("tip"))
				end, SFX_PANEL)
			else
				onButton(arg0_32, arg2_33, function()
					var0_0.UpdateCommodtyTip(var0_33)
					setActive(arg2_33:Find("tip"), false)
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
				end, SFX_PANEL)
			end

			local var26_33 = var0_0.ShouldShowCommodtyTip(var0_33)

			setActive(arg2_33:Find("new"), var26_33)
			setActive(arg2_33:Find("tip"), var26_33)
		end
	end)
	var1_32:align(#var0_32)

	arg0_32.filterIndex = 1

	for iter0_32 = 1, 4 do
		local var3_32 = arg0_32.charaPage:Find("switch"):GetChild(iter0_32 - 1)

		onToggle(arg0_32, var3_32, function(arg0_36)
			if arg0_36 then
				arg0_32.filterIndex = iter0_32

				if iter0_32 == 1 then
					for iter0_36, iter1_36 in ipairs(var2_32) do
						setActive(iter1_36[2], true)
					end
				elseif iter0_32 == 2 then
					for iter2_36, iter3_36 in ipairs(var2_32) do
						setActive(iter3_36[2], iter3_36[1] == 2)
					end
				elseif iter0_32 == 3 then
					for iter4_36, iter5_36 in ipairs(var2_32) do
						setActive(iter5_36[2], iter5_36[1] == 1)
					end
				else
					for iter6_36, iter7_36 in ipairs(var2_32) do
						setActive(iter7_36[2], iter7_36[1] == 3)
					end
				end

				for iter8_36 = 1, 4 do
					local var0_36 = arg0_32.charaPage:Find("switch"):GetChild(iter8_36 - 1)

					setActive(var0_36:Find("selected"), iter8_36 == iter0_32)
				end
			end
		end)

		if iter0_32 == 1 then
			triggerToggle(var3_32, true)
		end
	end
end

function var0_0.ClickCommodity(arg0_37, arg1_37, arg2_37)
	arg0_37.showCount = 1

	if arg1_37.room_id ~= 0 then
		local var0_37 = 0

		for iter0_37, iter1_37 in pairs(var4_0) do
			if iter1_37.type == 2 and iter1_37.character[1] == arg1_37.room_id then
				var0_37 = iter1_37.id
			end
		end

		if not getProxy(ApartmentProxy):getRoom(var0_37) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))

			return
		end
	end

	if arg1_37.realroom_id ~= 0 and not getProxy(ApartmentProxy):getRoom(arg1_37.realroom_id) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_publicroom_unlock") .. "：" .. pg.dorm3d_rooms[arg1_37.realroom_id].room)

		return
	end

	var0_0.UpdateCommodtyTip(arg1_37)

	if arg2_37 then
		setActive(arg2_37, false)
	end

	if arg1_37.type == 1 then
		local var1_37 = Dorm3dFurniture.New({
			configId = arg1_37.item_id
		})
		local var2_37 = CommonCommodity.New({
			id = arg1_37.shop_id[1]
		}, Goods.TYPE_SHOPSTREET)
		local var3_37, var4_37, var5_37 = var2_37:GetPrice()
		local var6_37 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var2_37:GetResType(),
			count = var3_37
		})

		arg0_37:emit(Dorm3dShopMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
			content = {
				icon = "<icon name=" .. var2_37:GetResIcon() .. " w=1.1 h=1.1/>",
				off = var4_37,
				cost = var6_37.count,
				old = var5_37,
				name = arg1_37.name
			},
			tip = i18n("dorm3d_shop_gift_tip"),
			drop = var1_37,
			endTime = var1_37:GetEndTime(),
			onYes = function()
				if not var1_37:InShopTime() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_purchase_outtime"))

					return
				end

				arg0_37:emit(GAME.SHOPPING, {
					silentTip = true,
					count = 1,
					shopId = arg1_37.shop_id[1]
				})
			end
		})
	elseif arg1_37.type == 2 then
		local var7_37 = 0

		for iter2_37 = 1, #arg1_37.shop_id do
			local var8_37 = arg1_37.shop_id[iter2_37]
			local var9_37 = var3_0[var8_37]
			local var10_37 = var9_37.limit_args[1]

			if not var10_37 and var9_37.group_type == 0 then
				var7_37 = 0
			elseif var10_37 and (var10_37[1] == "dailycount" or var10_37[1] == "count") then
				var7_37 = var10_37[3]
			elseif var9_37.group_type == 2 then
				var7_37 = var9_37.group_limit
			end
		end

		if var7_37 > 1 then
			local var11_37 = 0

			if arg0_37.selectedId ~= 0 then
				var11_37 = var4_0[arg0_37.selectedId].character[1]
			end

			arg0_37:emit(Dorm3dShopMediator.OPEN_DETAIL, arg1_37, var11_37, function(arg0_39)
				arg0_37.showCount = arg0_39
			end)
		else
			local var12_37 = Dorm3dGift.New({
				configId = arg1_37.item_id
			})
			local var13_37 = CommonCommodity.New({
				id = var12_37:GetShopID()
			}, Goods.TYPE_SHOPSTREET)
			local var14_37, var15_37, var16_37 = var13_37:GetPrice()
			local var17_37 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = var13_37:GetResType(),
				count = var14_37
			})
			local var18_37
			local var19_37 = 0

			_.each(var12_37:getConfig("shop_id"), function(arg0_40)
				local var0_40 = var3_0[arg0_40]

				if var0_40.group_type == 2 then
					var19_37 = math.max(var0_40.group_limit, var19_37)
				end
			end)

			if var19_37 > 0 then
				var18_37 = {
					getProxy(ApartmentProxy):GetGiftShopCount(var12_37:GetConfigID()),
					var19_37
				}
			end

			arg0_37:emit(Dorm3dShopMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
				content = {
					icon = "<icon name=" .. var13_37:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var15_37,
					cost = var17_37.count,
					old = var16_37,
					name = arg1_37.name,
					weekLimit = var18_37
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var12_37,
				groupId = arg1_37.room_id,
				onYes = function()
					arg0_37:emit(GAME.SHOPPING, {
						silentTip = true,
						count = 1,
						shopId = var12_37:GetShopID()
					})
				end
			})
		end
	elseif arg1_37.type == 3 then
		local var20_37
		local var21_37 = getProxy(ApartmentProxy):getRoom(arg1_37.item_id)

		if not var21_37 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))

			return
		end

		if not var21_37.unlockCharacter[arg1_37.room_id] then
			var20_37 = "lock"
		elseif not getProxy(ApartmentProxy):getApartment(arg1_37.room_id) then
			var20_37 = "room"
		elseif Apartment.New({
			ship_group = arg1_37.room_id
		}):needDownload() then
			var20_37 = "download"
		end

		if var20_37 == "lock" then
			arg0_37:emit(Dorm3dShopMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_37.item_id, arg1_37.room_id)
		elseif var20_37 == "room" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))
		elseif var20_37 == "download" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_beach_tip"))
		end
	end
end

function var0_0.SetBubbles(arg0_42, arg1_42, arg2_42)
	arg1_42:make(function(arg0_43, arg1_43, arg2_43)
		if arg0_43 == UIItemList.EventInit then
			local var0_43 = arg1_43 + 1
			local var1_43 = arg2_42[var0_43]

			LoadImageSpriteAtlasAsync("ui/shoptip_atlas", "icon_" .. var1_43, arg2_43:Find("icon/icon"), true)
			setText(arg2_43:Find("bubble/Text"), i18n("dorm3d_shop_tag" .. var1_43))
			setActive(arg2_43:Find("bubble"), false)
			onToggle(arg0_42, arg2_43, function(arg0_44)
				setActive(arg2_43:Find("icon/select"), arg0_44)
				setActive(arg2_43:Find("icon/unselect"), not arg0_44)
				setActive(arg2_43:Find("bubble"), arg0_44)
				setActive(arg0_42.mask, arg0_44)
				onButton(arg0_42, arg0_42.mask, function()
					triggerToggle(arg2_43, false)
				end, SFX_PANEL)
			end)
		end
	end)
	arg1_42:align(#arg2_42)
end

function var0_0.GetTimeRemain(arg0_46, arg1_46)
	local var0_46 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_46 = math.max(arg1_46 - var0_46, 0)
	local var2_46 = math.floor(var1_46 / 86400)

	if var2_46 > 0 then
		return var2_46 .. i18n("word_date")
	else
		local var3_46 = math.floor(var1_46 / 3600)

		if var3_46 > 0 then
			return var3_46 .. i18n("word_hour")
		else
			local var4_46 = math.floor(var1_46 / 60)

			if var4_46 > 0 then
				return var4_46 .. i18n("word_minute")
			else
				return var1_46 .. i18n("word_second")
			end
		end
	end
end

function var0_0.ShouldShowCommodtyTip(arg0_47)
	if arg0_47.room_id ~= 0 then
		local var0_47 = 0

		for iter0_47, iter1_47 in ipairs(var4_0.all) do
			local var1_47 = var4_0[iter1_47]

			if var1_47.type == 2 and var1_47.character[1] == arg0_47.room_id then
				var0_47 = iter1_47
			end
		end

		if not getProxy(ApartmentProxy):getRoom(var0_47) then
			return false
		end
	end

	if arg0_47.realroom_id ~= 0 and not getProxy(ApartmentProxy):getRoom(arg0_47.realroom_id) then
		return false
	end

	if arg0_47.type == 1 then
		return Dorm3dFurniture.NeedViewTipByFurnitureId(arg0_47.item_id)
	elseif arg0_47.type == 2 then
		local var2_47 = getProxy(PlayerProxy):getRawData().id
		local var3_47 = Dorm3dGift.NeedViewTipByGiftId(arg0_47.item_id)
		local var4_47 = var3_0[arg0_47.shop_id[1]].group ~= 0 and PlayerPrefs.GetInt(var2_47 .. "_dorm3dGiftWeekViewed_" .. arg0_47.item_id, 0) == 0

		return var3_47 or var4_47
	end

	return false
end

function var0_0.ShouldShowSumTip(arg0_48)
	for iter0_48, iter1_48 in ipairs(arg0_48) do
		if var0_0.ShouldShowCommodtyTip(iter1_48) then
			return true
		end
	end

	return false
end

function var0_0.ShouldShowAllTip()
	local var0_49 = {}

	for iter0_49, iter1_49 in ipairs(var2_0.all) do
		local var1_49 = var2_0[iter1_49]
		local var2_49 = false
		local var3_49 = var1_49.shop_id

		for iter2_49, iter3_49 in ipairs(var3_49) do
			local var4_49 = var3_0[iter3_49]

			if not pg.TimeMgr.GetInstance():inTime(var4_49.time) then
				var2_49 = true

				break
			end
		end

		if not var2_49 then
			table.insert(var0_49, var1_49)
		end
	end

	return var0_0.ShouldShowSumTip(var0_49)
end

function var0_0.UpdateCommodtyTip(arg0_50)
	if arg0_50.type == 1 then
		Dorm3dFurniture.SetViewedFlag(arg0_50.item_id)
	elseif arg0_50.type == 2 then
		Dorm3dGift.SetViewedFlag(arg0_50.item_id)

		if var3_0[arg0_50.shop_id[1]].group ~= 0 then
			local var0_50 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt(var0_50 .. "_dorm3dGiftWeekViewed_" .. arg0_50.item_id, 1)
		end
	end
end

function var0_0.UpdateSumTip(arg0_51)
	for iter0_51, iter1_51 in ipairs(arg0_51) do
		var0_0.UpdateCommodtyTip(iter1_51)
	end
end

function var0_0.willExit(arg0_52)
	arg0_52.scrollSnap:Dispose()

	arg0_52.scrollSnap = nil
end

function var0_0.onBackPressed(arg0_53)
	arg0_53:closeView()
end

return var0_0
