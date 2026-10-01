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

function var0_0.getResource(arg0_3, arg1_3)
	local var0_3 = {
		"weaponframes",
		"ui/shoptip_atlas"
	}

	local function var1_3(arg0_4)
		if noEmptyStr(arg0_4) and not table.contains(var0_3, arg0_4) then
			table.insert(var0_3, arg0_4)
		end
	end

	local function var2_3(arg0_5, arg1_5)
		if arg1_5 then
			local var0_5 = Drop.New({
				count = 0,
				type = arg0_5,
				id = arg1_5
			})

			var1_3(var0_5:getIcon())
		end
	end

	for iter0_3, iter1_3 in ipairs(var4_0.all or {}) do
		local var3_3 = var4_0[iter1_3]

		if var3_3 and var3_3.type == 2 and noEmptyStr(var3_3.assets_prefix) then
			var1_3("dorm3dselect/room_icon_" .. string.lower(var3_3.assets_prefix))
		end
	end

	for iter2_3, iter3_3 in ipairs(var2_0.all or {}) do
		local var4_3 = var2_0[iter3_3]

		if var4_3 then
			local var5_3 = var4_3.banners and var4_3.banners[1]

			if noEmptyStr(var5_3) then
				var1_3("dorm3dbanner/" .. var5_3 .. "_shopCard1")
				var1_3("dorm3dbanner/" .. var5_3 .. "_shopCard2")
			end

			if var4_3.type == 1 then
				var2_3(DROP_TYPE_DORM3D_FURNITURE, var4_3.item_id)

				local var6_3 = var6_0[var4_3.item_id]

				if var6_3 and #(var6_3.unlock_tips or {}) > 0 then
					var1_3("ui/shoptip_atlas")
				end
			elseif var4_3.type == 2 then
				var2_3(DROP_TYPE_DORM3D_GIFT, var4_3.item_id)

				local var7_3 = var5_0[var4_3.item_id]

				if var7_3 and #(var7_3.unlock_tips or {}) > 0 then
					var1_3("ui/shoptip_atlas")
				end
			elseif var4_3.type == 3 then
				local var8_3 = var4_0[var4_3.item_id]

				for iter4_3, iter5_3 in ipairs(var8_3 and var8_3.invite_icon or {}) do
					var1_3(iter5_3[2])
				end
			end
		end
	end

	return table.insertto(var0_3, var0_0.super.getResource(arg0_3, arg1_3))
end

function var0_0.init(arg0_6)
	arg0_6.closeBtn = arg0_6.rtAdapt:Find("closeBtn")
	arg0_6.res = arg0_6.rtAdapt:Find("resourceBg/res")
	arg0_6.recommendationTg = arg0_6.rtAdapt:Find("left/recommendation")
	arg0_6.charaList = UIItemList.New(arg0_6.rtAdapt:Find("left/charaScroll/mask/list"), arg0_6.rtAdapt:Find("left/charaScroll/mask/list/tpl"))
	arg0_6.recommendationPage = arg0_6.rtAdapt:Find("pages/recommendationPage")
	arg0_6.charaPage = arg0_6.rtAdapt:Find("pages/charaPage")
	arg0_6.mask = arg0_6._tf:Find("mask")

	setText(arg0_6.rtAdapt:Find("title/Text"), i18n("dorm3d_shop_title"))
	setText(arg0_6.recommendationPage:Find("bannerCard/mask/content/item/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_6.recommendationPage:Find("giftCard/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_6.recommendationPage:Find("card1/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_6.recommendationPage:Find("card2/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_6.recommendationPage:Find("card3/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_6.charaPage:Find("scroll/Viewport/Content/card/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_6.charaPage:Find("switch/all/Text"), i18n("dorm3d_shop_all"))
	setText(arg0_6.charaPage:Find("switch/gift/Text"), i18n("dorm3d_shop_gift1"))
	setText(arg0_6.charaPage:Find("switch/furniture/Text"), i18n("dorm3d_shop_furniture"))
	setText(arg0_6.charaPage:Find("switch/others/Text"), i18n("dorm3d_shop_others"))
	setText(arg0_6.charaPage:Find("switch/all/selected/Text"), i18n("dorm3d_shop_all"))
	setText(arg0_6.charaPage:Find("switch/gift/selected/Text"), i18n("dorm3d_shop_gift1"))
	setText(arg0_6.charaPage:Find("switch/furniture/selected/Text"), i18n("dorm3d_shop_furniture"))
	setText(arg0_6.charaPage:Find("switch/others/selected/Text"), i18n("dorm3d_shop_others"))
end

function var0_0.didEnter(arg0_7)
	arg0_7:InitData()
	onButton(arg0_7, arg0_7.closeBtn, function()
		arg0_7:closeView()
	end, SFX_PANEL)
	arg0_7:ShowResUI()
	arg0_7:SetPageBtns()
	triggerToggle(arg0_7.recommendationTg, true)
end

function var0_0.InitData(arg0_9)
	arg0_9.bannerCount = var1_0.drom3d_shop_product_panel_num.key_value_int
	arg0_9.allCommodityCfgs = {}

	for iter0_9, iter1_9 in ipairs(var2_0.all) do
		table.insert(arg0_9.allCommodityCfgs, var2_0[iter1_9])
	end

	table.sort(arg0_9.allCommodityCfgs, function(arg0_10, arg1_10)
		if tonumber(arg0_10.order) ~= tonumber(arg1_10.order) then
			return tonumber(arg0_10.order) < tonumber(arg1_10.order)
		end

		return arg0_10.id > arg1_10.id
	end)

	arg0_9.roomCfgs = {}

	_.each(var4_0.all, function(arg0_11)
		if var4_0[arg0_11].type == 2 then
			table.insert(arg0_9.roomCfgs, var4_0[arg0_11])
		end
	end)
	table.sort(arg0_9.roomCfgs, function(arg0_12, arg1_12)
		return arg0_12.id < arg1_12.id
	end)

	arg0_9.selectedId = 0
end

function var0_0.SetPageBtns(arg0_13)
	SetParent(arg0_13.recommendationTg, arg0_13.rtAdapt:Find("left"), false)
	arg0_13.charaList:make(function(arg0_14, arg1_14, arg2_14)
		if arg0_14 == UIItemList.EventUpdate then
			local var0_14 = arg0_13.roomCfgs[arg1_14 + 1]
			local var1_14 = string.format("dorm3dselect/room_icon_%s", string.lower(var0_14.assets_prefix))

			GetImageSpriteFromAtlasAsync(var1_14, "", arg2_14:Find("mask/icon"), false)

			local var2_14 = arg0_13:GetCommoditiesCfgByChara(var0_14.character[1])

			setActive(arg2_14:Find("tip"), var0_0.ShouldShowSumTip(var2_14))
			onToggle(arg0_13, arg2_14, function(arg0_15)
				if arg0_15 then
					arg0_13.selectedId = var0_14.id

					arg0_13:SetPageBtns()
					arg0_13:RefreshPage()
				end
			end)
		end
	end)
	arg0_13.charaList:align(#arg0_13.roomCfgs)

	arg0_13.showingCommoditiesIndex = {}

	local var0_13 = {}

	table.insertto(var0_13, arg0_13:GetCommoditiesCfgByPanel(1, arg0_13.bannerCount))
	table.insertto(var0_13, arg0_13:GetCommoditiesCfgByPanel(2, 1))
	table.insertto(var0_13, arg0_13:GetCommoditiesCfgByPanel(3, 1))
	table.insertto(var0_13, arg0_13:GetCommoditiesCfgByPanel(4, 1))
	table.insertto(var0_13, arg0_13:GetCommoditiesCfgByPanel(5, 1))
	setActive(arg0_13.recommendationTg:Find("icon/tip"), var0_0.ShouldShowSumTip(var0_13))
	onToggle(arg0_13, arg0_13.recommendationTg, function(arg0_16)
		if arg0_16 then
			arg0_13.selectedId = 0

			arg0_13:SetPageBtns()
			arg0_13:RefreshPage()
		end
	end)
	SetParent(arg0_13.recommendationTg, arg0_13.rtAdapt:Find("left/charaScroll/mask/list"), false)
	arg0_13.recommendationTg:SetSiblingIndex(0)
end

function var0_0.GetCommoditiesCfgByPanel(arg0_17, arg1_17, arg2_17)
	local var0_17 = {}
	local var1_17 = 0

	for iter0_17, iter1_17 in ipairs(arg0_17.allCommodityCfgs) do
		if not table.contains(arg0_17.showingCommoditiesIndex, iter0_17) and table.contains(iter1_17.panel, arg1_17) then
			if not (arg0_17:IsCommodityOutOfDate(iter1_17) or arg0_17:IsCommoditySoldOut(iter1_17)) then
				var1_17 = var1_17 + 1

				table.insert(var0_17, iter1_17)
				table.insert(arg0_17.showingCommoditiesIndex, iter0_17)
			end

			if var1_17 == arg2_17 then
				break
			end
		end
	end

	if var1_17 < arg2_17 then
		for iter2_17, iter3_17 in ipairs(arg0_17.allCommodityCfgs) do
			if not table.contains(arg0_17.showingCommoditiesIndex, iter2_17) and table.contains(iter3_17.panel, arg1_17) then
				if not arg0_17:IsCommodityOutOfDate(iter3_17) then
					var1_17 = var1_17 + 1

					table.insert(var0_17, iter3_17)
					table.insert(arg0_17.showingCommoditiesIndex, iter2_17)
				end

				if var1_17 == arg2_17 then
					break
				end
			end
		end
	end

	return var0_17
end

function var0_0.GetCommoditiesCfgByChara(arg0_18, arg1_18)
	local var0_18 = {}
	local var1_18 = {}

	for iter0_18, iter1_18 in ipairs(arg0_18.allCommodityCfgs) do
		local var2_18 = {}

		if iter1_18.realroom_id ~= 0 then
			table.insertto(var2_18, var4_0[iter1_18.realroom_id].character)
			table.insertto(var2_18, var4_0[iter1_18.realroom_id].character_pay)
		end

		if (iter1_18.room_id == arg1_18 or iter1_18.room_id == 0) and (iter1_18.realroom_id == 0 or iter1_18.realroom_id ~= 0 and table.contains(var2_18, arg1_18)) then
			local var3_18 = arg0_18:IsCommodityOutOfDate(iter1_18)
			local var4_18 = arg0_18:IsCommoditySoldOut(iter1_18)

			if not var3_18 then
				if not var4_18 then
					table.insert(var0_18, iter1_18)
				else
					table.insert(var1_18, iter1_18)
				end
			end
		end
	end

	if #var1_18 > 0 then
		table.insertto(var0_18, var1_18)
	end

	return var0_18
end

function var0_0.IsCommodityOutOfDate(arg0_19, arg1_19)
	local var0_19 = arg1_19.shop_id

	for iter0_19, iter1_19 in ipairs(var0_19) do
		local var1_19 = var3_0[iter1_19]

		if not pg.TimeMgr.GetInstance():inTime(var1_19.time) then
			return true
		end
	end

	return false
end

function var0_0.IsCommoditySoldOut(arg0_20, arg1_20)
	if arg1_20.type == 1 then
		if getProxy(ApartmentProxy):GetFurnitureShopCount(arg1_20.item_id) > 0 then
			return true
		end
	elseif arg1_20.type == 2 then
		return not Dorm3dGift.New({
			configId = arg1_20.item_id
		}):CheckBuyLimit()
	elseif arg1_20.type == 3 then
		local var0_20 = getProxy(ApartmentProxy):getRoom(arg1_20.item_id)

		return var0_20 and var0_20.unlockCharacter[arg1_20.room_id]
	end

	return false
end

function var0_0.ShowResUI(arg0_21)
	local var0_21 = getProxy(PlayerProxy):getRawData()

	arg0_21.goldMax = arg0_21.res:Find("gold/max"):GetComponent(typeof(Text))
	arg0_21.goldValue = arg0_21.res:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_21.oilMax = arg0_21.res:Find("oil/max"):GetComponent(typeof(Text))
	arg0_21.oilValue = arg0_21.res:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_21.gemValue = arg0_21.res:Find("gem/Text"):GetComponent(typeof(Text))

	PlayerResUI.StaticFlush(var0_21, arg0_21.goldMax, arg0_21.goldValue, arg0_21.oilMax, arg0_21.oilValue, arg0_21.gemValue)
	onButton(arg0_21, arg0_21.res:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.res:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_21, arg0_21.res:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.RefreshPage(arg0_25)
	arg0_25.showingCommoditiesIndex = {}

	setActive(arg0_25.recommendationPage, arg0_25.selectedId == 0)
	setActive(arg0_25.charaPage, arg0_25.selectedId ~= 0)

	if arg0_25.selectedId == 0 then
		arg0_25:SetBannnerCard()
		arg0_25:SetGiftCard()
		arg0_25:SetNormalCard()
	else
		arg0_25:SetCharaCard()
	end
end

function var0_0.SetBannnerCard(arg0_26)
	local var0_26 = arg0_26.recommendationPage:Find("bannerCard")
	local var1_26 = arg0_26:GetCommoditiesCfgByPanel(1, arg0_26.bannerCount)

	if not arg0_26.scrollSnap then
		arg0_26.scrollSnap = BannerScrollRectDorm3dShop.New(var0_26:Find("mask/content"), var0_26:Find("dots"))
	end

	for iter0_26, iter1_26 in ipairs(var1_26) do
		local var2_26 = arg0_26.scrollSnap:GetItemChild(iter0_26) or arg0_26.scrollSnap:AddChild()
		local var3_26 = arg0_26:IsCommoditySoldOut(iter1_26)
		local var4_26 = false
		local var5_26 = false
		local var6_26 = {}
		local var7_26 = 0
		local var8_26 = ""
		local var9_26 = ""
		local var10_26 = var3_0[iter1_26.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

		if iter1_26.type == 1 then
			local var11_26 = var6_0[iter1_26.item_id]

			var5_26 = var11_26.is_special == 1
			var4_26 = not var5_26 and var11_26.is_exclusive == 1
			var8_26 = Drop.New({
				count = 0,
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var11_26.id
			}):getIcon()
			var9_26 = var10_26 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(iter1_26.item_id) .. "/1"
			var6_26 = var11_26.unlock_tips or {}
			var7_26 = iter1_26.shop_id[1]
		elseif iter1_26.type == 2 then
			local var12_26 = var5_0[iter1_26.item_id]

			var4_26 = iter1_26.room_id ~= 0

			local var13_26 = Dorm3dGift.New({
				configId = iter1_26.item_id
			})

			var8_26 = Drop.New({
				type = DROP_TYPE_DORM3D_GIFT,
				id = iter1_26.item_id,
				count = getProxy(ApartmentProxy):getGiftCount(iter1_26.item_id)
			}):getIcon()

			local var14_26 = 0

			for iter2_26 = 1, #iter1_26.shop_id do
				local var15_26 = iter1_26.shop_id[iter2_26]
				local var16_26 = var3_0[var15_26]
				local var17_26 = var16_26.limit_args[1]

				if not var17_26 and var16_26.group_type == 0 then
					var14_26 = 0
				elseif var17_26 and (var17_26[1] == "dailycount" or var17_26[1] == "count") then
					var14_26 = var17_26[3]
				elseif var16_26.group_type == 2 then
					var14_26 = var16_26.group_limit
				end
			end

			var9_26 = var10_26 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(iter1_26.item_id) .. "/" .. var14_26

			setText(var2_26:Find("favor/number"), "+" .. pg.dorm3d_favor_trigger[var5_0[iter1_26.item_id].favor_trigger_id].num)

			var2_26:Find("favor"):GetComponent(typeof(CanvasGroup)).alpha = var3_26 and 0.5 or 1
			var6_26 = var12_26.unlock_tips or {}
			var7_26 = var13_26:GetShopID()
		elseif iter1_26.type == 3 then
			var4_26 = true

			local var18_26 = var4_0[iter1_26.item_id].invite_icon

			for iter3_26, iter4_26 in ipairs(var18_26) do
				if iter4_26[1] == iter1_26.room_id then
					var8_26 = iter4_26[2]
				end
			end

			local var19_26 = var3_26 and 1 or 0

			var9_26 = var10_26 .. " " .. var19_26 .. "/1"
			var7_26 = iter1_26.shop_id[1]
		end

		setActive(var2_26:Find("bg/normal"), not var4_26 and not var5_26)
		setActive(var2_26:Find("bg/zhuanshu"), var4_26)
		setActive(var2_26:Find("bg/tedian"), var5_26)
		setActive(var2_26:Find("normal"), not var4_26 and not var5_26)
		setActive(var2_26:Find("zhuanshu"), var4_26)
		setActive(var2_26:Find("tedian"), var5_26)
		setActive(var2_26:Find("favor"), iter1_26.type == 2)
		LoadImageSpriteAsync("dorm3dbanner/" .. iter1_26.banners[1] .. "_shopCard1", var2_26:Find("bannerMask/banner"), true)
		setText(var2_26:Find("name"), iter1_26.name)

		local var20_26 = var3_0[iter1_26.shop_id[1]].time

		setActive(var2_26:Find("timeLimit"), var20_26 ~= "always")

		if var20_26 ~= "always" then
			local var21_26 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var20_26[2])

			setText(var2_26:Find("timeLimit/Text"), arg0_26:GetTimeRemain(var21_26))
		end

		local var22_26 = UIItemList.New(var2_26:Find("bubbles/content"), var2_26:Find("bubbles/content/tpl"))

		arg0_26:SetBubbles(var22_26, var6_26)
		setActive(var2_26:Find("consume"), not var3_26)
		setActive(var2_26:Find("soldOut"), var3_26)

		local var23_26 = CommonCommodity.New({
			id = var7_26
		}, Goods.TYPE_SHOPSTREET)
		local var24_26, var25_26, var26_26 = var23_26:GetPrice()
		local var27_26 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var23_26:GetResType(),
			count = var24_26
		})

		setText(var2_26:Find("consume/Text"), "<icon name=" .. var23_26:GetResIcon() .. " w=0.81 h=0.81/>" .. var24_26)
		GetImageSpriteFromAtlasAsync(var8_26, "", var2_26:Find("normal/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var8_26, "", var2_26:Find("zhuanshu/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var8_26, "", var2_26:Find("tedian/Dorm3dIconTpl/icon"))
		setText(var2_26:Find("normal/countLimit"), var9_26)
		setText(var2_26:Find("zhuanshu/countLimit"), var9_26)
		setText(var2_26:Find("tedian/countLimit"), var9_26)

		var2_26:Find("normal/Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_26 and 0.5 or 1
		var2_26:Find("zhuanshu/Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_26 and 0.5 or 1
		var2_26:Find("tedian/Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_26 and 0.5 or 1

		if not var3_26 then
			onButton(arg0_26, var2_26, function()
				arg0_26:ClickCommodity(iter1_26, var2_26:Find("tip"))
			end, SFX_PANEL)
		else
			onButton(arg0_26, var2_26, function()
				var0_0.UpdateCommodtyTip(iter1_26)
				setActive(var2_26:Find("tip"), false)
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
			end, SFX_PANEL)
		end

		local var28_26 = var0_0.ShouldShowCommodtyTip(iter1_26)

		setActive(var2_26:Find("new"), var28_26)
		setActive(var2_26:Find("tip"), var28_26)
	end

	arg0_26.scrollSnap:SetUp()
end

function var0_0.SetGiftCard(arg0_29)
	local var0_29 = arg0_29.recommendationPage:Find("giftCard")
	local var1_29 = arg0_29:GetCommoditiesCfgByPanel(2, 1)[1]
	local var2_29 = 0
	local var3_29 = arg0_29:IsCommoditySoldOut(var1_29)
	local var4_29 = ""
	local var5_29 = false
	local var6_29 = false
	local var7_29 = var3_0[var1_29.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

	if var1_29.type == 1 then
		local var8_29 = var6_0[var1_29.item_id]

		var6_29 = var8_29.is_special == 1
		var5_29 = not var6_29 and var8_29.is_exclusive == 1

		local var9_29 = Drop.New({
			count = 0,
			type = DROP_TYPE_DORM3D_FURNITURE,
			id = var8_29.id
		})

		updateCustomDrop(var0_29:Find("Dorm3dIconTpl"), var9_29)

		var2_29 = var1_29.shop_id[1]
		var4_29 = var7_29 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(var1_29.item_id) .. "/1"
	elseif var1_29.type == 2 then
		local var10_29 = var5_0[var1_29.item_id]

		var5_29 = var1_29.room_id ~= 0

		local var11_29 = Dorm3dGift.New({
			configId = var1_29.item_id
		})
		local var12_29 = Drop.New({
			type = DROP_TYPE_DORM3D_GIFT,
			id = var1_29.item_id,
			count = getProxy(ApartmentProxy):getGiftCount(var1_29.item_id)
		})

		setText(var0_29:Find("favor/number"), "+" .. pg.dorm3d_favor_trigger[var5_0[var1_29.item_id].favor_trigger_id].num)
		updateCustomDrop(var0_29:Find("Dorm3dIconTpl"), var12_29)

		var2_29 = var11_29:GetShopID()

		local var13_29 = 0

		for iter0_29 = 1, #var1_29.shop_id do
			local var14_29 = var1_29.shop_id[iter0_29]
			local var15_29 = var3_0[var14_29]
			local var16_29 = var15_29.limit_args[1]

			if not var16_29 and var15_29.group_type == 0 then
				var13_29 = 0
			elseif var16_29 and (var16_29[1] == "dailycount" or var16_29[1] == "count") then
				var13_29 = var16_29[3]
			elseif var15_29.group_type == 2 then
				var13_29 = var15_29.group_limit
			end
		end

		var4_29 = var7_29 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(var1_29.item_id) .. "/" .. var13_29
	elseif var1_29.type == 3 then
		var5_29 = true

		local var17_29 = var4_0[var1_29.item_id].invite_icon
		local var18_29 = ""

		for iter1_29, iter2_29 in ipairs(var17_29) do
			if iter2_29[1] == var1_29.room_id then
				var18_29 = iter2_29[2]
			end
		end

		GetImageSpriteFromAtlasAsync(var18_29, "", var0_29:Find("Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var1_29.rarity), var0_29:Find("Dorm3dIconTpl"))

		local var19_29 = var3_29 and 1 or 0

		var4_29 = var7_29 .. " " .. var19_29 .. "/1"
		var2_29 = var1_29.shop_id[1]
	end

	var0_29:Find("Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_29 and 0.5 or 1
	var0_29:Find("favor"):GetComponent(typeof(CanvasGroup)).alpha = var3_29 and 0.5 or 1

	setActive(var0_29:Find("bg/normal"), not var5_29 and not var6_29)
	setActive(var0_29:Find("bg/zhuanshu"), var5_29)
	setActive(var0_29:Find("bg/tedian"), var6_29)
	setActive(var0_29:Find("normal"), not var5_29 and not var6_29)
	setActive(var0_29:Find("zhuanshu"), var5_29)
	setActive(var0_29:Find("tedian"), var6_29)
	setText(var0_29:Find("normal/countLimit"), var4_29)
	setText(var0_29:Find("zhuanshu/countLimit"), var4_29)
	setText(var0_29:Find("tedian/countLimit"), var4_29)
	LoadImageSpriteAsync("dorm3dbanner/" .. var1_29.banners[1] .. "_shopCard2", var0_29:Find("mask/item"), true)
	setScrollText(var0_29:Find("name/text"), var1_29.name)
	setActive(var0_29:Find("favor"), var1_29.type == 2)
	setActive(var0_29:Find("consume"), not var3_29)
	setActive(var0_29:Find("soldOut"), var3_29)

	local var20_29 = var3_0[var1_29.shop_id[1]].time

	setActive(var0_29:Find("timeLimit"), var20_29 ~= "always")

	if var20_29 ~= "always" then
		local var21_29 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var20_29[2])

		setText(var0_29:Find("timeLimit/Text"), arg0_29:GetTimeRemain(var21_29))
	end

	local var22_29 = CommonCommodity.New({
		id = var2_29
	}, Goods.TYPE_SHOPSTREET)
	local var23_29, var24_29, var25_29 = var22_29:GetPrice()
	local var26_29 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var22_29:GetResType(),
		count = var23_29
	})

	setText(var0_29:Find("consume/Text"), "<icon name=" .. var22_29:GetResIcon() .. " w=0.81 h=0.81/>" .. var23_29)

	if not var3_29 then
		onButton(arg0_29, var0_29, function()
			arg0_29:ClickCommodity(var1_29, var0_29:Find("tip"))
		end, SFX_PANEL)
	else
		onButton(arg0_29, var0_29, function()
			var0_0.UpdateCommodtyTip(var1_29)
			setActive(var0_29:Find("tip"), false)
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
		end, SFX_PANEL)
	end

	local var27_29 = var0_0.ShouldShowCommodtyTip(var1_29)

	setActive(var0_29:Find("new"), var27_29)
	setActive(var0_29:Find("tip"), var27_29)
end

function var0_0.SetNormalCard(arg0_32)
	for iter0_32 = 1, 3 do
		local var0_32 = arg0_32.recommendationPage:Find("card" .. iter0_32)
		local var1_32 = arg0_32:GetCommoditiesCfgByPanel(iter0_32 + 2, 1)[1]
		local var2_32 = false
		local var3_32 = false
		local var4_32 = arg0_32:IsCommoditySoldOut(var1_32)
		local var5_32 = {}
		local var6_32 = 0
		local var7_32 = ""
		local var8_32 = var3_0[var1_32.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

		if var1_32.type == 1 then
			local var9_32 = var6_0[var1_32.item_id]

			var2_32 = var9_32.is_special == 1
			var3_32 = not var2_32 and var9_32.is_exclusive == 1
			var7_32 = Drop.New({
				count = 0,
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var9_32.id
			}):getIcon()

			setText(var0_32:Find("countLimit/Text"), var8_32 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(var1_32.item_id) .. "/1")

			var5_32 = var9_32.unlock_tips or {}
			var6_32 = var1_32.shop_id[1]
		elseif var1_32.type == 2 then
			local var10_32 = var5_0[var1_32.item_id]

			var3_32 = var1_32.room_id ~= 0

			local var11_32 = Dorm3dGift.New({
				configId = var1_32.item_id
			})

			var7_32 = Drop.New({
				type = DROP_TYPE_DORM3D_GIFT,
				id = var1_32.item_id,
				count = getProxy(ApartmentProxy):getGiftCount(var1_32.item_id)
			}):getIcon()

			local var12_32 = 0

			for iter1_32 = 1, #var1_32.shop_id do
				local var13_32 = var1_32.shop_id[iter1_32]
				local var14_32 = var3_0[var13_32]
				local var15_32 = var14_32.limit_args[1]

				if not var15_32 and var14_32.group_type == 0 then
					var12_32 = 0
				elseif var15_32 and (var15_32[1] == "dailycount" or var15_32[1] == "count") then
					var12_32 = var15_32[3]
				elseif var14_32.group_type == 2 then
					var12_32 = var14_32.group_limit
				end
			end

			setText(var0_32:Find("countLimit/Text"), var8_32 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(var1_32.item_id) .. "/" .. var12_32)

			local var16_32 = pg.dorm3d_favor_trigger[var5_0[var1_32.item_id].favor_trigger_id].num

			setText(var0_32:Find("normal/favor/number"), "+" .. var16_32)
			setText(var0_32:Find("zhuanshu/favor/number"), "+" .. var16_32)
			setText(var0_32:Find("tedian/favor/number"), "+" .. var16_32)

			var5_32 = var10_32.unlock_tips or {}
			var6_32 = var11_32:GetShopID()
		elseif var1_32.type == 3 then
			var3_32 = true

			local var17_32 = var4_0[var1_32.item_id].invite_icon

			for iter2_32, iter3_32 in ipairs(var17_32) do
				if iter3_32[1] == var1_32.room_id then
					var7_32 = iter3_32[2]
				end
			end

			local var18_32 = var4_32 and 1 or 0

			setText(var0_32:Find("countLimit/Text"), var8_32 .. " " .. var18_32 .. "/1")

			var6_32 = var1_32.shop_id[1]
		end

		setActive(var0_32:Find("bg/normal"), not var3_32 and not var2_32)
		setActive(var0_32:Find("bg/zhuanshu"), var3_32)
		setActive(var0_32:Find("bg/tedian"), var2_32)
		setActive(var0_32:Find("normal"), not var3_32 and not var2_32)
		setActive(var0_32:Find("zhuanshu"), var3_32)
		setActive(var0_32:Find("tedian"), var2_32)
		setActive(var0_32:Find("normal/favor"), var1_32.type == 2)
		setActive(var0_32:Find("zhuanshu/favor"), var1_32.type == 2)
		setActive(var0_32:Find("tedian/favor"), var1_32.type == 2)
		setText(var0_32:Find("name"), var1_32.name)

		local var19_32 = UIItemList.New(var0_32:Find("bubbles/content"), var0_32:Find("bubbles/content/tpl"))

		arg0_32:SetBubbles(var19_32, var5_32)
		setActive(var0_32:Find("consume"), not var4_32)
		setActive(var0_32:Find("soldOut"), var4_32)

		local var20_32 = CommonCommodity.New({
			id = var6_32
		}, Goods.TYPE_SHOPSTREET)
		local var21_32, var22_32, var23_32 = var20_32:GetPrice()
		local var24_32 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var20_32:GetResType(),
			count = var21_32
		})

		setText(var0_32:Find("consume/Text"), "<icon name=" .. var20_32:GetResIcon() .. " w=0.81 h=0.81/>" .. var21_32)
		GetImageSpriteFromAtlasAsync(var7_32, "", var0_32:Find("normal/mask/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var7_32, "", var0_32:Find("zhuanshu/mask/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var7_32, "", var0_32:Find("tedian/mask/Dorm3dIconTpl/icon"))

		if not var4_32 then
			onButton(arg0_32, var0_32, function()
				arg0_32:ClickCommodity(var1_32, var0_32:Find("tip"))
			end, SFX_PANEL)
		else
			onButton(arg0_32, var0_32, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
				var0_0.UpdateCommodtyTip(var1_32)
				setActive(var0_32:Find("tip"), false)
			end, SFX_PANEL)
		end

		local var25_32 = var0_0.ShouldShowCommodtyTip(var1_32)

		setActive(var0_32:Find("new"), var25_32)
		setActive(var0_32:Find("tip"), var25_32)
	end
end

function var0_0.SetCharaCard(arg0_35)
	local var0_35 = arg0_35:GetCommoditiesCfgByChara(var4_0[arg0_35.selectedId].character[1])
	local var1_35 = UIItemList.New(arg0_35.charaPage:Find("scroll/Viewport/Content"), arg0_35.charaPage:Find("scroll/Viewport/Content/card"))
	local var2_35 = {}

	var1_35:make(function(arg0_36, arg1_36, arg2_36)
		if arg0_36 == UIItemList.EventInit then
			local var0_36 = var0_35[arg1_36 + 1]

			table.insert(var2_35, {
				var0_36.type,
				arg2_36
			})

			local var1_36 = arg0_35:IsCommoditySoldOut(var0_36)
			local var2_36 = false
			local var3_36 = false
			local var4_36 = ""
			local var5_36 = {}
			local var6_36 = 0
			local var7_36 = var3_0[var0_36.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

			if var0_36.type == 1 then
				local var8_36 = var6_0[var0_36.item_id]

				var3_36 = var8_36.is_special == 1
				var2_36 = not var3_36 and var8_36.is_exclusive == 1
				var4_36 = Drop.New({
					count = 0,
					type = DROP_TYPE_DORM3D_FURNITURE,
					id = var8_36.id
				}):getIcon()

				setText(arg2_36:Find("descScroll/Viewport/Content/desc"), var8_36.desc)
				setText(arg2_36:Find("countLimit"), var7_36 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(var0_36.item_id) .. "/1")

				var5_36 = var8_36.unlock_tips or {}
				var6_36 = var0_36.shop_id[1]
			elseif var0_36.type == 2 then
				local var9_36 = var5_0[var0_36.item_id]

				var2_36 = var0_36.room_id ~= 0

				local var10_36 = Dorm3dGift.New({
					configId = var0_36.item_id
				})

				var4_36 = Drop.New({
					type = DROP_TYPE_DORM3D_GIFT,
					id = var0_36.item_id,
					count = getProxy(ApartmentProxy):getGiftCount(var0_36.item_id)
				}):getIcon()

				setText(arg2_36:Find("descScroll/Viewport/Content/desc"), var9_36.display)

				local var11_36 = 0

				for iter0_36 = 1, #var0_36.shop_id do
					local var12_36 = var0_36.shop_id[iter0_36]
					local var13_36 = var3_0[var12_36]
					local var14_36 = var13_36.limit_args[1]

					if not var14_36 and var13_36.group_type == 0 then
						var11_36 = 0
					elseif var14_36 and (var14_36[1] == "dailycount" or var14_36[1] == "count") then
						var11_36 = var14_36[3]
					elseif var13_36.group_type == 2 then
						var11_36 = var13_36.group_limit
					end
				end

				setText(arg2_36:Find("countLimit"), var7_36 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(var0_36.item_id) .. "/" .. var11_36)
				setText(arg2_36:Find("favor/number"), "+" .. pg.dorm3d_favor_trigger[var5_0[var0_36.item_id].favor_trigger_id].num)

				var5_36 = var9_36.unlock_tips or {}
				var6_36 = var10_36:GetShopID()
			elseif var0_36.type == 3 then
				var2_36 = true

				local var15_36 = var4_0[var0_36.item_id]
				local var16_36 = var15_36.invite_icon

				for iter1_36, iter2_36 in ipairs(var16_36) do
					if iter2_36[1] == var0_36.room_id then
						var4_36 = iter2_36[2]
					end
				end

				setText(arg2_36:Find("descScroll/Viewport/Content/desc"), var15_36.room_des)

				local var17_36 = var1_36 and 1 or 0

				setText(arg2_36:Find("countLimit"), var7_36 .. " " .. var17_36 .. "/1")

				var6_36 = var0_36.shop_id[1]
			end

			setActive(arg2_36:Find("bg/normal"), not var1_36)
			setActive(arg2_36:Find("bg/soldOut"), var1_36)
			setActive(arg2_36:Find("normal"), not var2_36 and not var3_36)
			setActive(arg2_36:Find("zhuanshu"), var2_36)
			setActive(arg2_36:Find("tedian"), var3_36)
			GetImageSpriteFromAtlasAsync(var4_36, "", arg2_36:Find("mask/Dorm3dIconTpl/icon"))
			setActive(arg2_36:Find("favor"), var0_36.type == 2)
			setScrollText(arg2_36:Find("name/text"), var0_36.name)

			local var18_36 = UIItemList.New(arg2_36:Find("bubbles/content"), arg2_36:Find("bubbles/content/tpl"))

			arg0_35:SetBubbles(var18_36, var5_36)

			local var19_36 = CommonCommodity.New({
				id = var6_36
			}, Goods.TYPE_SHOPSTREET)
			local var20_36, var21_36, var22_36 = var19_36:GetPrice()
			local var23_36 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = var19_36:GetResType(),
				count = var20_36
			})

			setText(arg2_36:Find("consume/Text"), "<icon name=" .. var19_36:GetResIcon() .. " w=0.81 h=0.81/>" .. var20_36)
			setActive(arg2_36:Find("consume"), not var1_36)
			setActive(arg2_36:Find("soldOut"), var1_36)

			local var24_36 = var3_0[var0_36.shop_id[1]].time

			setActive(arg2_36:Find("timeLimit"), var24_36 ~= "always")

			if var24_36 ~= "always" then
				local var25_36 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var24_36[2])

				setText(arg2_36:Find("timeLimit/Text"), arg0_35:GetTimeRemain(var25_36))
			end

			if not var1_36 then
				onButton(arg0_35, arg2_36, function()
					arg0_35:ClickCommodity(var0_36, arg2_36:Find("tip"))
				end, SFX_PANEL)
			else
				onButton(arg0_35, arg2_36, function()
					var0_0.UpdateCommodtyTip(var0_36)
					setActive(arg2_36:Find("tip"), false)
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
				end, SFX_PANEL)
			end

			local var26_36 = var0_0.ShouldShowCommodtyTip(var0_36)

			setActive(arg2_36:Find("new"), var26_36)
			setActive(arg2_36:Find("tip"), var26_36)
		end
	end)
	var1_35:align(#var0_35)

	arg0_35.filterIndex = 1

	for iter0_35 = 1, 4 do
		local var3_35 = arg0_35.charaPage:Find("switch"):GetChild(iter0_35 - 1)

		onToggle(arg0_35, var3_35, function(arg0_39)
			if arg0_39 then
				arg0_35.filterIndex = iter0_35

				if iter0_35 == 1 then
					for iter0_39, iter1_39 in ipairs(var2_35) do
						setActive(iter1_39[2], true)
					end
				elseif iter0_35 == 2 then
					for iter2_39, iter3_39 in ipairs(var2_35) do
						setActive(iter3_39[2], iter3_39[1] == 2)
					end
				elseif iter0_35 == 3 then
					for iter4_39, iter5_39 in ipairs(var2_35) do
						setActive(iter5_39[2], iter5_39[1] == 1)
					end
				else
					for iter6_39, iter7_39 in ipairs(var2_35) do
						setActive(iter7_39[2], iter7_39[1] == 3)
					end
				end

				for iter8_39 = 1, 4 do
					local var0_39 = arg0_35.charaPage:Find("switch"):GetChild(iter8_39 - 1)

					setActive(var0_39:Find("selected"), iter8_39 == iter0_35)
				end
			end
		end)

		if iter0_35 == 1 then
			triggerToggle(var3_35, true)
		end
	end
end

function var0_0.ClickCommodity(arg0_40, arg1_40, arg2_40)
	arg0_40.showCount = 1

	if arg1_40.room_id ~= 0 then
		local var0_40 = 0

		for iter0_40, iter1_40 in pairs(var4_0) do
			if iter1_40.type == 2 and iter1_40.character[1] == arg1_40.room_id then
				var0_40 = iter1_40.id
			end
		end

		if not getProxy(ApartmentProxy):getRoom(var0_40) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))

			return
		end
	end

	if arg1_40.realroom_id ~= 0 and not getProxy(ApartmentProxy):getRoom(arg1_40.realroom_id) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_publicroom_unlock") .. "：" .. pg.dorm3d_rooms[arg1_40.realroom_id].room)

		return
	end

	var0_0.UpdateCommodtyTip(arg1_40)

	if arg2_40 then
		setActive(arg2_40, false)
	end

	if arg1_40.type == 1 then
		local var1_40 = Dorm3dFurniture.New({
			configId = arg1_40.item_id
		})
		local var2_40 = CommonCommodity.New({
			id = arg1_40.shop_id[1]
		}, Goods.TYPE_SHOPSTREET)
		local var3_40, var4_40, var5_40 = var2_40:GetPrice()
		local var6_40 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var2_40:GetResType(),
			count = var3_40
		})

		arg0_40:emit(Dorm3dShopMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
			content = {
				icon = "<icon name=" .. var2_40:GetResIcon() .. " w=1.1 h=1.1/>",
				off = var4_40,
				cost = var6_40.count,
				old = var5_40,
				name = arg1_40.name
			},
			tip = i18n("dorm3d_shop_gift_tip"),
			drop = var1_40,
			endTime = var1_40:GetEndTime(),
			onYes = function()
				if not var1_40:InShopTime() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_purchase_outtime"))

					return
				end

				arg0_40:emit(GAME.SHOPPING, {
					silentTip = true,
					count = 1,
					shopId = arg1_40.shop_id[1]
				})
			end
		})
	elseif arg1_40.type == 2 then
		local var7_40 = 0

		for iter2_40 = 1, #arg1_40.shop_id do
			local var8_40 = arg1_40.shop_id[iter2_40]
			local var9_40 = var3_0[var8_40]
			local var10_40 = var9_40.limit_args[1]

			if not var10_40 and var9_40.group_type == 0 then
				var7_40 = 0
			elseif var10_40 and (var10_40[1] == "dailycount" or var10_40[1] == "count") then
				var7_40 = var10_40[3]
			elseif var9_40.group_type == 2 then
				var7_40 = var9_40.group_limit
			end
		end

		if var7_40 > 1 then
			local var11_40 = 0

			if arg0_40.selectedId ~= 0 then
				var11_40 = var4_0[arg0_40.selectedId].character[1]
			end

			arg0_40:emit(Dorm3dShopMediator.OPEN_DETAIL, arg1_40, var11_40, function(arg0_42)
				arg0_40.showCount = arg0_42
			end)
		else
			local var12_40 = Dorm3dGift.New({
				configId = arg1_40.item_id
			})
			local var13_40 = CommonCommodity.New({
				id = var12_40:GetShopID()
			}, Goods.TYPE_SHOPSTREET)
			local var14_40, var15_40, var16_40 = var13_40:GetPrice()
			local var17_40 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = var13_40:GetResType(),
				count = var14_40
			})
			local var18_40
			local var19_40 = 0

			_.each(var12_40:getConfig("shop_id"), function(arg0_43)
				local var0_43 = var3_0[arg0_43]

				if var0_43.group_type == 2 then
					var19_40 = math.max(var0_43.group_limit, var19_40)
				end
			end)

			if var19_40 > 0 then
				var18_40 = {
					getProxy(ApartmentProxy):GetGiftShopCount(var12_40:GetConfigID()),
					var19_40
				}
			end

			arg0_40:emit(Dorm3dShopMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
				content = {
					icon = "<icon name=" .. var13_40:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var15_40,
					cost = var17_40.count,
					old = var16_40,
					name = arg1_40.name,
					weekLimit = var18_40
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var12_40,
				groupId = arg1_40.room_id,
				onYes = function()
					arg0_40:emit(GAME.SHOPPING, {
						silentTip = true,
						count = 1,
						shopId = var12_40:GetShopID()
					})
				end
			})
		end
	elseif arg1_40.type == 3 then
		local var20_40
		local var21_40 = getProxy(ApartmentProxy):getRoom(arg1_40.item_id)

		if not var21_40 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))

			return
		end

		if not var21_40.unlockCharacter[arg1_40.room_id] then
			var20_40 = "lock"
		elseif not getProxy(ApartmentProxy):getApartment(arg1_40.room_id) then
			var20_40 = "room"
		elseif Apartment.New({
			ship_group = arg1_40.room_id
		}):needDownload() then
			var20_40 = "download"
		end

		if var20_40 == "lock" then
			arg0_40:emit(Dorm3dShopMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_40.item_id, arg1_40.room_id)
		elseif var20_40 == "room" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))
		elseif var20_40 == "download" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_beach_tip"))
		end
	end
end

function var0_0.SetBubbles(arg0_45, arg1_45, arg2_45)
	arg1_45:make(function(arg0_46, arg1_46, arg2_46)
		if arg0_46 == UIItemList.EventInit then
			local var0_46 = arg1_46 + 1
			local var1_46 = arg2_45[var0_46]

			LoadImageSpriteAtlasAsync("ui/shoptip_atlas", "icon_" .. var1_46, arg2_46:Find("icon/icon"), true)
			setText(arg2_46:Find("bubble/Text"), i18n("dorm3d_shop_tag" .. var1_46))
			setActive(arg2_46:Find("bubble"), false)
			onToggle(arg0_45, arg2_46, function(arg0_47)
				setActive(arg2_46:Find("icon/select"), arg0_47)
				setActive(arg2_46:Find("icon/unselect"), not arg0_47)
				setActive(arg2_46:Find("bubble"), arg0_47)
				setActive(arg0_45.mask, arg0_47)
				onButton(arg0_45, arg0_45.mask, function()
					triggerToggle(arg2_46, false)
				end, SFX_PANEL)
			end)
		end
	end)
	arg1_45:align(#arg2_45)
end

function var0_0.GetTimeRemain(arg0_49, arg1_49)
	local var0_49 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_49 = math.max(arg1_49 - var0_49, 0)
	local var2_49 = math.floor(var1_49 / 86400)

	if var2_49 > 0 then
		return var2_49 .. i18n("word_date")
	else
		local var3_49 = math.floor(var1_49 / 3600)

		if var3_49 > 0 then
			return var3_49 .. i18n("word_hour")
		else
			local var4_49 = math.floor(var1_49 / 60)

			if var4_49 > 0 then
				return var4_49 .. i18n("word_minute")
			else
				return var1_49 .. i18n("word_second")
			end
		end
	end
end

function var0_0.ShouldShowCommodtyTip(arg0_50)
	if arg0_50.room_id ~= 0 then
		local var0_50 = 0

		for iter0_50, iter1_50 in ipairs(var4_0.all) do
			local var1_50 = var4_0[iter1_50]

			if var1_50.type == 2 and var1_50.character[1] == arg0_50.room_id then
				var0_50 = iter1_50
			end
		end

		if not getProxy(ApartmentProxy):getRoom(var0_50) then
			return false
		end
	end

	if arg0_50.realroom_id ~= 0 and not getProxy(ApartmentProxy):getRoom(arg0_50.realroom_id) then
		return false
	end

	if arg0_50.type == 1 then
		return Dorm3dFurniture.NeedViewTipByFurnitureId(arg0_50.item_id)
	elseif arg0_50.type == 2 then
		local var2_50 = getProxy(PlayerProxy):getRawData().id
		local var3_50 = Dorm3dGift.NeedViewTipByGiftId(arg0_50.item_id)
		local var4_50 = var3_0[arg0_50.shop_id[1]].group ~= 0 and PlayerPrefs.GetInt(var2_50 .. "_dorm3dGiftWeekViewed_" .. arg0_50.item_id, 0) == 0

		return var3_50 or var4_50
	end

	return false
end

function var0_0.ShouldShowSumTip(arg0_51)
	for iter0_51, iter1_51 in ipairs(arg0_51) do
		if var0_0.ShouldShowCommodtyTip(iter1_51) then
			return true
		end
	end

	return false
end

function var0_0.ShouldShowAllTip()
	local var0_52 = {}

	for iter0_52, iter1_52 in ipairs(var2_0.all) do
		local var1_52 = var2_0[iter1_52]
		local var2_52 = false
		local var3_52 = var1_52.shop_id

		for iter2_52, iter3_52 in ipairs(var3_52) do
			local var4_52 = var3_0[iter3_52]

			if not pg.TimeMgr.GetInstance():inTime(var4_52.time) then
				var2_52 = true

				break
			end
		end

		if not var2_52 then
			table.insert(var0_52, var1_52)
		end
	end

	return var0_0.ShouldShowSumTip(var0_52)
end

function var0_0.UpdateCommodtyTip(arg0_53)
	if arg0_53.type == 1 then
		Dorm3dFurniture.SetViewedFlag(arg0_53.item_id)
	elseif arg0_53.type == 2 then
		Dorm3dGift.SetViewedFlag(arg0_53.item_id)

		if var3_0[arg0_53.shop_id[1]].group ~= 0 then
			local var0_53 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt(var0_53 .. "_dorm3dGiftWeekViewed_" .. arg0_53.item_id, 1)
		end
	end
end

function var0_0.UpdateSumTip(arg0_54)
	for iter0_54, iter1_54 in ipairs(arg0_54) do
		var0_0.UpdateCommodtyTip(iter1_54)
	end
end

function var0_0.willExit(arg0_55)
	arg0_55.scrollSnap:Dispose()

	arg0_55.scrollSnap = nil
end

function var0_0.onBackPressed(arg0_56)
	arg0_56:closeView()
end

return var0_0
