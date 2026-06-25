local var0_0 = class("Dorm3dShopUI", import("view.base.BaseUI"))
local var1_0 = pg.dorm3d_set
local var2_0 = pg.dorm3d_shop_template
local var3_0 = pg.shop_template
local var4_0 = pg.dorm3d_rooms
local var5_0 = pg.dorm3d_gift
local var6_0 = pg.dorm3d_furniture_template

function var0_0.getUIName(arg0_1)
	return "Dorm3dShopUI"
end

function var0_0.init(arg0_2)
	arg0_2.closeBtn = arg0_2.rtAdapt:Find("closeBtn")
	arg0_2.res = arg0_2.rtAdapt:Find("resourceBg/res")
	arg0_2.recommendationTg = arg0_2.rtAdapt:Find("left/recommendation")
	arg0_2.charaList = UIItemList.New(arg0_2.rtAdapt:Find("left/charaScroll/mask/list"), arg0_2.rtAdapt:Find("left/charaScroll/mask/list/tpl"))
	arg0_2.recommendationPage = arg0_2.rtAdapt:Find("pages/recommendationPage")
	arg0_2.charaPage = arg0_2.rtAdapt:Find("pages/charaPage")
	arg0_2.mask = arg0_2._tf:Find("mask")

	setText(arg0_2.rtAdapt:Find("title/Text"), i18n("dorm3d_shop_title"))
	setText(arg0_2.recommendationPage:Find("bannerCard/mask/content/item/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_2.recommendationPage:Find("giftCard/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_2.recommendationPage:Find("card1/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_2.recommendationPage:Find("card2/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_2.recommendationPage:Find("card3/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_2.charaPage:Find("scroll/Viewport/Content/card/soldOut"), i18n("dorm3d_shop_sold_out"))
	setText(arg0_2.charaPage:Find("switch/all/Text"), i18n("dorm3d_shop_all"))
	setText(arg0_2.charaPage:Find("switch/gift/Text"), i18n("dorm3d_shop_gift1"))
	setText(arg0_2.charaPage:Find("switch/furniture/Text"), i18n("dorm3d_shop_furniture"))
	setText(arg0_2.charaPage:Find("switch/others/Text"), i18n("dorm3d_shop_others"))
	setText(arg0_2.charaPage:Find("switch/all/selected/Text"), i18n("dorm3d_shop_all"))
	setText(arg0_2.charaPage:Find("switch/gift/selected/Text"), i18n("dorm3d_shop_gift1"))
	setText(arg0_2.charaPage:Find("switch/furniture/selected/Text"), i18n("dorm3d_shop_furniture"))
	setText(arg0_2.charaPage:Find("switch/others/selected/Text"), i18n("dorm3d_shop_others"))
end

function var0_0.didEnter(arg0_3)
	arg0_3:InitData()
	onButton(arg0_3, arg0_3.closeBtn, function()
		arg0_3:closeView()
	end, SFX_PANEL)
	arg0_3:ShowResUI()
	arg0_3:SetPageBtns()
	triggerToggle(arg0_3.recommendationTg, true)
end

function var0_0.InitData(arg0_5)
	arg0_5.bannerCount = var1_0.drom3d_shop_product_panel_num.key_value_int
	arg0_5.allCommodityCfgs = {}

	for iter0_5, iter1_5 in ipairs(var2_0.all) do
		table.insert(arg0_5.allCommodityCfgs, var2_0[iter1_5])
	end

	table.sort(arg0_5.allCommodityCfgs, function(arg0_6, arg1_6)
		if tonumber(arg0_6.order) ~= tonumber(arg1_6.order) then
			return tonumber(arg0_6.order) < tonumber(arg1_6.order)
		end

		return arg0_6.id > arg1_6.id
	end)

	arg0_5.roomCfgs = {}

	_.each(var4_0.all, function(arg0_7)
		if var4_0[arg0_7].type == 2 then
			table.insert(arg0_5.roomCfgs, var4_0[arg0_7])
		end
	end)
	table.sort(arg0_5.roomCfgs, function(arg0_8, arg1_8)
		return arg0_8.id < arg1_8.id
	end)

	arg0_5.selectedId = 0
end

function var0_0.SetPageBtns(arg0_9)
	SetParent(arg0_9.recommendationTg, arg0_9.rtAdapt:Find("left"), false)
	arg0_9.charaList:make(function(arg0_10, arg1_10, arg2_10)
		if arg0_10 == UIItemList.EventUpdate then
			local var0_10 = arg0_9.roomCfgs[arg1_10 + 1]
			local var1_10 = string.format("dorm3dselect/room_icon_%s", string.lower(var0_10.assets_prefix))

			GetImageSpriteFromAtlasAsync(var1_10, "", arg2_10:Find("mask/icon"), false)

			local var2_10 = arg0_9:GetCommoditiesCfgByChara(var0_10.character[1])

			setActive(arg2_10:Find("tip"), var0_0.ShouldShowSumTip(var2_10))
			onToggle(arg0_9, arg2_10, function(arg0_11)
				if arg0_11 then
					arg0_9.selectedId = var0_10.id

					arg0_9:SetPageBtns()
					arg0_9:RefreshPage()
				end
			end)
		end
	end)
	arg0_9.charaList:align(#arg0_9.roomCfgs)

	arg0_9.showingCommoditiesIndex = {}

	local var0_9 = {}

	table.insertto(var0_9, arg0_9:GetCommoditiesCfgByPanel(1, arg0_9.bannerCount))
	table.insertto(var0_9, arg0_9:GetCommoditiesCfgByPanel(2, 1))
	table.insertto(var0_9, arg0_9:GetCommoditiesCfgByPanel(3, 1))
	table.insertto(var0_9, arg0_9:GetCommoditiesCfgByPanel(4, 1))
	table.insertto(var0_9, arg0_9:GetCommoditiesCfgByPanel(5, 1))
	setActive(arg0_9.recommendationTg:Find("icon/tip"), var0_0.ShouldShowSumTip(var0_9))
	onToggle(arg0_9, arg0_9.recommendationTg, function(arg0_12)
		if arg0_12 then
			arg0_9.selectedId = 0

			arg0_9:SetPageBtns()
			arg0_9:RefreshPage()
		end
	end)
	SetParent(arg0_9.recommendationTg, arg0_9.rtAdapt:Find("left/charaScroll/mask/list"), false)
	arg0_9.recommendationTg:SetSiblingIndex(0)
end

function var0_0.GetCommoditiesCfgByPanel(arg0_13, arg1_13, arg2_13)
	local var0_13 = {}
	local var1_13 = 0

	for iter0_13, iter1_13 in ipairs(arg0_13.allCommodityCfgs) do
		if not table.contains(arg0_13.showingCommoditiesIndex, iter0_13) and table.contains(iter1_13.panel, arg1_13) then
			if not (arg0_13:IsCommodityOutOfDate(iter1_13) or arg0_13:IsCommoditySoldOut(iter1_13)) then
				var1_13 = var1_13 + 1

				table.insert(var0_13, iter1_13)
				table.insert(arg0_13.showingCommoditiesIndex, iter0_13)
			end

			if var1_13 == arg2_13 then
				break
			end
		end
	end

	if var1_13 < arg2_13 then
		for iter2_13, iter3_13 in ipairs(arg0_13.allCommodityCfgs) do
			if not table.contains(arg0_13.showingCommoditiesIndex, iter2_13) and table.contains(iter3_13.panel, arg1_13) then
				if not arg0_13:IsCommodityOutOfDate(iter3_13) then
					var1_13 = var1_13 + 1

					table.insert(var0_13, iter3_13)
					table.insert(arg0_13.showingCommoditiesIndex, iter2_13)
				end

				if var1_13 == arg2_13 then
					break
				end
			end
		end
	end

	return var0_13
end

function var0_0.GetCommoditiesCfgByChara(arg0_14, arg1_14)
	local var0_14 = {}
	local var1_14 = {}

	for iter0_14, iter1_14 in ipairs(arg0_14.allCommodityCfgs) do
		local var2_14 = {}

		if iter1_14.realroom_id ~= 0 then
			table.insertto(var2_14, var4_0[iter1_14.realroom_id].character)
			table.insertto(var2_14, var4_0[iter1_14.realroom_id].character_pay)
		end

		if (iter1_14.room_id == arg1_14 or iter1_14.room_id == 0) and (iter1_14.realroom_id == 0 or iter1_14.realroom_id ~= 0 and table.contains(var2_14, arg1_14)) then
			local var3_14 = arg0_14:IsCommodityOutOfDate(iter1_14)
			local var4_14 = arg0_14:IsCommoditySoldOut(iter1_14)

			if not var3_14 then
				if not var4_14 then
					table.insert(var0_14, iter1_14)
				else
					table.insert(var1_14, iter1_14)
				end
			end
		end
	end

	if #var1_14 > 0 then
		table.insertto(var0_14, var1_14)
	end

	return var0_14
end

function var0_0.IsCommodityOutOfDate(arg0_15, arg1_15)
	local var0_15 = arg1_15.shop_id

	for iter0_15, iter1_15 in ipairs(var0_15) do
		local var1_15 = var3_0[iter1_15]

		if not pg.TimeMgr.GetInstance():inTime(var1_15.time) then
			return true
		end
	end

	return false
end

function var0_0.IsCommoditySoldOut(arg0_16, arg1_16)
	if arg1_16.type == 1 then
		if getProxy(ApartmentProxy):GetFurnitureShopCount(arg1_16.item_id) > 0 then
			return true
		end
	elseif arg1_16.type == 2 then
		return not Dorm3dGift.New({
			configId = arg1_16.item_id
		}):CheckBuyLimit()
	elseif arg1_16.type == 3 then
		local var0_16 = getProxy(ApartmentProxy):getRoom(arg1_16.item_id)

		return var0_16 and var0_16.unlockCharacter[arg1_16.room_id]
	end

	return false
end

function var0_0.ShowResUI(arg0_17)
	local var0_17 = getProxy(PlayerProxy):getRawData()

	arg0_17.goldMax = arg0_17.res:Find("gold/max"):GetComponent(typeof(Text))
	arg0_17.goldValue = arg0_17.res:Find("gold/Text"):GetComponent(typeof(Text))
	arg0_17.oilMax = arg0_17.res:Find("oil/max"):GetComponent(typeof(Text))
	arg0_17.oilValue = arg0_17.res:Find("oil/Text"):GetComponent(typeof(Text))
	arg0_17.gemValue = arg0_17.res:Find("gem/Text"):GetComponent(typeof(Text))

	PlayerResUI.StaticFlush(var0_17, arg0_17.goldMax, arg0_17.goldValue, arg0_17.oilMax, arg0_17.oilValue, arg0_17.gemValue)
	onButton(arg0_17, arg0_17.res:Find("gold"), function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.res:Find("oil"), function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_17, arg0_17.res:Find("gem"), function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
end

function var0_0.RefreshPage(arg0_21)
	arg0_21.showingCommoditiesIndex = {}

	setActive(arg0_21.recommendationPage, arg0_21.selectedId == 0)
	setActive(arg0_21.charaPage, arg0_21.selectedId ~= 0)

	if arg0_21.selectedId == 0 then
		arg0_21:SetBannnerCard()
		arg0_21:SetGiftCard()
		arg0_21:SetNormalCard()
	else
		arg0_21:SetCharaCard()
	end
end

function var0_0.SetBannnerCard(arg0_22)
	local var0_22 = arg0_22.recommendationPage:Find("bannerCard")
	local var1_22 = arg0_22:GetCommoditiesCfgByPanel(1, arg0_22.bannerCount)

	if not arg0_22.scrollSnap then
		arg0_22.scrollSnap = BannerScrollRectDorm3dShop.New(var0_22:Find("mask/content"), var0_22:Find("dots"))
	end

	for iter0_22, iter1_22 in ipairs(var1_22) do
		local var2_22 = arg0_22.scrollSnap:GetItemChild(iter0_22) or arg0_22.scrollSnap:AddChild()
		local var3_22 = arg0_22:IsCommoditySoldOut(iter1_22)
		local var4_22 = false
		local var5_22 = false
		local var6_22 = {}
		local var7_22 = 0
		local var8_22 = ""
		local var9_22 = ""
		local var10_22 = var3_0[iter1_22.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

		if iter1_22.type == 1 then
			local var11_22 = var6_0[iter1_22.item_id]

			var5_22 = var11_22.is_special == 1
			var4_22 = not var5_22 and var11_22.is_exclusive == 1
			var8_22 = Drop.New({
				count = 0,
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var11_22.id
			}):getIcon()
			var9_22 = var10_22 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(iter1_22.item_id) .. "/1"
			var6_22 = var11_22.unlock_tips or {}
			var7_22 = iter1_22.shop_id[1]
		elseif iter1_22.type == 2 then
			local var12_22 = var5_0[iter1_22.item_id]

			var4_22 = iter1_22.room_id ~= 0

			local var13_22 = Dorm3dGift.New({
				configId = iter1_22.item_id
			})

			var8_22 = Drop.New({
				type = DROP_TYPE_DORM3D_GIFT,
				id = iter1_22.item_id,
				count = getProxy(ApartmentProxy):getGiftCount(iter1_22.item_id)
			}):getIcon()

			local var14_22 = 0

			for iter2_22 = 1, #iter1_22.shop_id do
				local var15_22 = iter1_22.shop_id[iter2_22]
				local var16_22 = var3_0[var15_22]
				local var17_22 = var16_22.limit_args[1]

				if not var17_22 and var16_22.group_type == 0 then
					var14_22 = 0
				elseif var17_22 and (var17_22[1] == "dailycount" or var17_22[1] == "count") then
					var14_22 = var17_22[3]
				elseif var16_22.group_type == 2 then
					var14_22 = var16_22.group_limit
				end
			end

			var9_22 = var10_22 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(iter1_22.item_id) .. "/" .. var14_22

			setText(var2_22:Find("favor/number"), "+" .. pg.dorm3d_favor_trigger[var5_0[iter1_22.item_id].favor_trigger_id].num)

			var2_22:Find("favor"):GetComponent(typeof(CanvasGroup)).alpha = var3_22 and 0.5 or 1
			var6_22 = var12_22.unlock_tips or {}
			var7_22 = var13_22:GetShopID()
		elseif iter1_22.type == 3 then
			var4_22 = true

			local var18_22 = var4_0[iter1_22.item_id].invite_icon

			for iter3_22, iter4_22 in ipairs(var18_22) do
				if iter4_22[1] == iter1_22.room_id then
					var8_22 = iter4_22[2]
				end
			end

			local var19_22 = var3_22 and 1 or 0

			var9_22 = var10_22 .. " " .. var19_22 .. "/1"
			var7_22 = iter1_22.shop_id[1]
		end

		setActive(var2_22:Find("bg/normal"), not var4_22 and not var5_22)
		setActive(var2_22:Find("bg/zhuanshu"), var4_22)
		setActive(var2_22:Find("bg/tedian"), var5_22)
		setActive(var2_22:Find("normal"), not var4_22 and not var5_22)
		setActive(var2_22:Find("zhuanshu"), var4_22)
		setActive(var2_22:Find("tedian"), var5_22)
		setActive(var2_22:Find("favor"), iter1_22.type == 2)
		LoadImageSpriteAsync("dorm3dbanner/" .. iter1_22.banners[1] .. "_shopCard1", var2_22:Find("bannerMask/banner"), true)
		setText(var2_22:Find("name"), iter1_22.name)

		local var20_22 = var3_0[iter1_22.shop_id[1]].time

		setActive(var2_22:Find("timeLimit"), var20_22 ~= "always")

		if var20_22 ~= "always" then
			local var21_22 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var20_22[2])

			setText(var2_22:Find("timeLimit/Text"), arg0_22:GetTimeRemain(var21_22))
		end

		local var22_22 = UIItemList.New(var2_22:Find("bubbles/content"), var2_22:Find("bubbles/content/tpl"))

		arg0_22:SetBubbles(var22_22, var6_22)
		setActive(var2_22:Find("consume"), not var3_22)
		setActive(var2_22:Find("soldOut"), var3_22)

		local var23_22 = CommonCommodity.New({
			id = var7_22
		}, Goods.TYPE_SHOPSTREET)
		local var24_22, var25_22, var26_22 = var23_22:GetPrice()
		local var27_22 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var23_22:GetResType(),
			count = var24_22
		})

		setText(var2_22:Find("consume/Text"), "<icon name=" .. var23_22:GetResIcon() .. " w=0.81 h=0.81/>" .. var24_22)
		GetImageSpriteFromAtlasAsync(var8_22, "", var2_22:Find("normal/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var8_22, "", var2_22:Find("zhuanshu/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var8_22, "", var2_22:Find("tedian/Dorm3dIconTpl/icon"))
		setText(var2_22:Find("normal/countLimit"), var9_22)
		setText(var2_22:Find("zhuanshu/countLimit"), var9_22)
		setText(var2_22:Find("tedian/countLimit"), var9_22)

		var2_22:Find("normal/Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_22 and 0.5 or 1
		var2_22:Find("zhuanshu/Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_22 and 0.5 or 1
		var2_22:Find("tedian/Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_22 and 0.5 or 1

		if not var3_22 then
			onButton(arg0_22, var2_22, function()
				arg0_22:ClickCommodity(iter1_22, var2_22:Find("tip"))
			end, SFX_PANEL)
		else
			onButton(arg0_22, var2_22, function()
				var0_0.UpdateCommodtyTip(iter1_22)
				setActive(var2_22:Find("tip"), false)
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
			end, SFX_PANEL)
		end

		local var28_22 = var0_0.ShouldShowCommodtyTip(iter1_22)

		setActive(var2_22:Find("new"), var28_22)
		setActive(var2_22:Find("tip"), var28_22)
	end

	arg0_22.scrollSnap:SetUp()
end

function var0_0.SetGiftCard(arg0_25)
	local var0_25 = arg0_25.recommendationPage:Find("giftCard")
	local var1_25 = arg0_25:GetCommoditiesCfgByPanel(2, 1)[1]
	local var2_25 = 0
	local var3_25 = arg0_25:IsCommoditySoldOut(var1_25)
	local var4_25 = ""
	local var5_25 = false
	local var6_25 = false
	local var7_25 = var3_0[var1_25.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

	if var1_25.type == 1 then
		local var8_25 = var6_0[var1_25.item_id]

		var6_25 = var8_25.is_special == 1
		var5_25 = not var6_25 and var8_25.is_exclusive == 1

		local var9_25 = Drop.New({
			count = 0,
			type = DROP_TYPE_DORM3D_FURNITURE,
			id = var8_25.id
		})

		updateCustomDrop(var0_25:Find("Dorm3dIconTpl"), var9_25)

		var2_25 = var1_25.shop_id[1]
		var4_25 = var7_25 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(var1_25.item_id) .. "/1"
	elseif var1_25.type == 2 then
		local var10_25 = var5_0[var1_25.item_id]

		var5_25 = var1_25.room_id ~= 0

		local var11_25 = Dorm3dGift.New({
			configId = var1_25.item_id
		})
		local var12_25 = Drop.New({
			type = DROP_TYPE_DORM3D_GIFT,
			id = var1_25.item_id,
			count = getProxy(ApartmentProxy):getGiftCount(var1_25.item_id)
		})

		setText(var0_25:Find("favor/number"), "+" .. pg.dorm3d_favor_trigger[var5_0[var1_25.item_id].favor_trigger_id].num)
		updateCustomDrop(var0_25:Find("Dorm3dIconTpl"), var12_25)

		var2_25 = var11_25:GetShopID()

		local var13_25 = 0

		for iter0_25 = 1, #var1_25.shop_id do
			local var14_25 = var1_25.shop_id[iter0_25]
			local var15_25 = var3_0[var14_25]
			local var16_25 = var15_25.limit_args[1]

			if not var16_25 and var15_25.group_type == 0 then
				var13_25 = 0
			elseif var16_25 and (var16_25[1] == "dailycount" or var16_25[1] == "count") then
				var13_25 = var16_25[3]
			elseif var15_25.group_type == 2 then
				var13_25 = var15_25.group_limit
			end
		end

		var4_25 = var7_25 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(var1_25.item_id) .. "/" .. var13_25
	elseif var1_25.type == 3 then
		var5_25 = true

		local var17_25 = var4_0[var1_25.item_id].invite_icon
		local var18_25 = ""

		for iter1_25, iter2_25 in ipairs(var17_25) do
			if iter2_25[1] == var1_25.room_id then
				var18_25 = iter2_25[2]
			end
		end

		GetImageSpriteFromAtlasAsync(var18_25, "", var0_25:Find("Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(var1_25.rarity), var0_25:Find("Dorm3dIconTpl"))

		local var19_25 = var3_25 and 1 or 0

		var4_25 = var7_25 .. " " .. var19_25 .. "/1"
		var2_25 = var1_25.shop_id[1]
	end

	var0_25:Find("Dorm3dIconTpl"):GetComponent(typeof(CanvasGroup)).alpha = var3_25 and 0.5 or 1
	var0_25:Find("favor"):GetComponent(typeof(CanvasGroup)).alpha = var3_25 and 0.5 or 1

	setActive(var0_25:Find("bg/normal"), not var5_25 and not var6_25)
	setActive(var0_25:Find("bg/zhuanshu"), var5_25)
	setActive(var0_25:Find("bg/tedian"), var6_25)
	setActive(var0_25:Find("normal"), not var5_25 and not var6_25)
	setActive(var0_25:Find("zhuanshu"), var5_25)
	setActive(var0_25:Find("tedian"), var6_25)
	setText(var0_25:Find("normal/countLimit"), var4_25)
	setText(var0_25:Find("zhuanshu/countLimit"), var4_25)
	setText(var0_25:Find("tedian/countLimit"), var4_25)
	LoadImageSpriteAsync("dorm3dbanner/" .. var1_25.banners[1] .. "_shopCard2", var0_25:Find("mask/item"), true)
	setScrollText(var0_25:Find("name/text"), var1_25.name)
	setActive(var0_25:Find("favor"), var1_25.type == 2)
	setActive(var0_25:Find("consume"), not var3_25)
	setActive(var0_25:Find("soldOut"), var3_25)

	local var20_25 = var3_0[var1_25.shop_id[1]].time

	setActive(var0_25:Find("timeLimit"), var20_25 ~= "always")

	if var20_25 ~= "always" then
		local var21_25 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var20_25[2])

		setText(var0_25:Find("timeLimit/Text"), arg0_25:GetTimeRemain(var21_25))
	end

	local var22_25 = CommonCommodity.New({
		id = var2_25
	}, Goods.TYPE_SHOPSTREET)
	local var23_25, var24_25, var25_25 = var22_25:GetPrice()
	local var26_25 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var22_25:GetResType(),
		count = var23_25
	})

	setText(var0_25:Find("consume/Text"), "<icon name=" .. var22_25:GetResIcon() .. " w=0.81 h=0.81/>" .. var23_25)

	if not var3_25 then
		onButton(arg0_25, var0_25, function()
			arg0_25:ClickCommodity(var1_25, var0_25:Find("tip"))
		end, SFX_PANEL)
	else
		onButton(arg0_25, var0_25, function()
			var0_0.UpdateCommodtyTip(var1_25)
			setActive(var0_25:Find("tip"), false)
			pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
		end, SFX_PANEL)
	end

	local var27_25 = var0_0.ShouldShowCommodtyTip(var1_25)

	setActive(var0_25:Find("new"), var27_25)
	setActive(var0_25:Find("tip"), var27_25)
end

function var0_0.SetNormalCard(arg0_28)
	for iter0_28 = 1, 3 do
		local var0_28 = arg0_28.recommendationPage:Find("card" .. iter0_28)
		local var1_28 = arg0_28:GetCommoditiesCfgByPanel(iter0_28 + 2, 1)[1]
		local var2_28 = false
		local var3_28 = false
		local var4_28 = arg0_28:IsCommoditySoldOut(var1_28)
		local var5_28 = {}
		local var6_28 = 0
		local var7_28 = ""
		local var8_28 = var3_0[var1_28.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

		if var1_28.type == 1 then
			local var9_28 = var6_0[var1_28.item_id]

			var2_28 = var9_28.is_special == 1
			var3_28 = not var2_28 and var9_28.is_exclusive == 1
			var7_28 = Drop.New({
				count = 0,
				type = DROP_TYPE_DORM3D_FURNITURE,
				id = var9_28.id
			}):getIcon()

			setText(var0_28:Find("countLimit/Text"), var8_28 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(var1_28.item_id) .. "/1")

			var5_28 = var9_28.unlock_tips or {}
			var6_28 = var1_28.shop_id[1]
		elseif var1_28.type == 2 then
			local var10_28 = var5_0[var1_28.item_id]

			var3_28 = var1_28.room_id ~= 0

			local var11_28 = Dorm3dGift.New({
				configId = var1_28.item_id
			})

			var7_28 = Drop.New({
				type = DROP_TYPE_DORM3D_GIFT,
				id = var1_28.item_id,
				count = getProxy(ApartmentProxy):getGiftCount(var1_28.item_id)
			}):getIcon()

			local var12_28 = 0

			for iter1_28 = 1, #var1_28.shop_id do
				local var13_28 = var1_28.shop_id[iter1_28]
				local var14_28 = var3_0[var13_28]
				local var15_28 = var14_28.limit_args[1]

				if not var15_28 and var14_28.group_type == 0 then
					var12_28 = 0
				elseif var15_28 and (var15_28[1] == "dailycount" or var15_28[1] == "count") then
					var12_28 = var15_28[3]
				elseif var14_28.group_type == 2 then
					var12_28 = var14_28.group_limit
				end
			end

			setText(var0_28:Find("countLimit/Text"), var8_28 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(var1_28.item_id) .. "/" .. var12_28)

			local var16_28 = pg.dorm3d_favor_trigger[var5_0[var1_28.item_id].favor_trigger_id].num

			setText(var0_28:Find("normal/favor/number"), "+" .. var16_28)
			setText(var0_28:Find("zhuanshu/favor/number"), "+" .. var16_28)
			setText(var0_28:Find("tedian/favor/number"), "+" .. var16_28)

			var5_28 = var10_28.unlock_tips or {}
			var6_28 = var11_28:GetShopID()
		elseif var1_28.type == 3 then
			var3_28 = true

			local var17_28 = var4_0[var1_28.item_id].invite_icon

			for iter2_28, iter3_28 in ipairs(var17_28) do
				if iter3_28[1] == var1_28.room_id then
					var7_28 = iter3_28[2]
				end
			end

			local var18_28 = var4_28 and 1 or 0

			setText(var0_28:Find("countLimit/Text"), var8_28 .. " " .. var18_28 .. "/1")

			var6_28 = var1_28.shop_id[1]
		end

		setActive(var0_28:Find("bg/normal"), not var3_28 and not var2_28)
		setActive(var0_28:Find("bg/zhuanshu"), var3_28)
		setActive(var0_28:Find("bg/tedian"), var2_28)
		setActive(var0_28:Find("normal"), not var3_28 and not var2_28)
		setActive(var0_28:Find("zhuanshu"), var3_28)
		setActive(var0_28:Find("tedian"), var2_28)
		setActive(var0_28:Find("normal/favor"), var1_28.type == 2)
		setActive(var0_28:Find("zhuanshu/favor"), var1_28.type == 2)
		setActive(var0_28:Find("tedian/favor"), var1_28.type == 2)
		setText(var0_28:Find("name"), var1_28.name)

		local var19_28 = UIItemList.New(var0_28:Find("bubbles/content"), var0_28:Find("bubbles/content/tpl"))

		arg0_28:SetBubbles(var19_28, var5_28)
		setActive(var0_28:Find("consume"), not var4_28)
		setActive(var0_28:Find("soldOut"), var4_28)

		local var20_28 = CommonCommodity.New({
			id = var6_28
		}, Goods.TYPE_SHOPSTREET)
		local var21_28, var22_28, var23_28 = var20_28:GetPrice()
		local var24_28 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var20_28:GetResType(),
			count = var21_28
		})

		setText(var0_28:Find("consume/Text"), "<icon name=" .. var20_28:GetResIcon() .. " w=0.81 h=0.81/>" .. var21_28)
		GetImageSpriteFromAtlasAsync(var7_28, "", var0_28:Find("normal/mask/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var7_28, "", var0_28:Find("zhuanshu/mask/Dorm3dIconTpl/icon"))
		GetImageSpriteFromAtlasAsync(var7_28, "", var0_28:Find("tedian/mask/Dorm3dIconTpl/icon"))

		if not var4_28 then
			onButton(arg0_28, var0_28, function()
				arg0_28:ClickCommodity(var1_28, var0_28:Find("tip"))
			end, SFX_PANEL)
		else
			onButton(arg0_28, var0_28, function()
				pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
				var0_0.UpdateCommodtyTip(var1_28)
				setActive(var0_28:Find("tip"), false)
			end, SFX_PANEL)
		end

		local var25_28 = var0_0.ShouldShowCommodtyTip(var1_28)

		setActive(var0_28:Find("new"), var25_28)
		setActive(var0_28:Find("tip"), var25_28)
	end
end

function var0_0.SetCharaCard(arg0_31)
	local var0_31 = arg0_31:GetCommoditiesCfgByChara(var4_0[arg0_31.selectedId].character[1])
	local var1_31 = UIItemList.New(arg0_31.charaPage:Find("scroll/Viewport/Content"), arg0_31.charaPage:Find("scroll/Viewport/Content/card"))
	local var2_31 = {}

	var1_31:make(function(arg0_32, arg1_32, arg2_32)
		if arg0_32 == UIItemList.EventInit then
			local var0_32 = var0_31[arg1_32 + 1]

			table.insert(var2_31, {
				var0_32.type,
				arg2_32
			})

			local var1_32 = arg0_31:IsCommoditySoldOut(var0_32)
			local var2_32 = false
			local var3_32 = false
			local var4_32 = ""
			local var5_32 = {}
			local var6_32 = 0
			local var7_32 = var3_0[var0_32.shop_id[1]].group_type == 2 and i18n("dorm3d_shop_limit1") or i18n("dorm3d_shop_limit")

			if var0_32.type == 1 then
				local var8_32 = var6_0[var0_32.item_id]

				var3_32 = var8_32.is_special == 1
				var2_32 = not var3_32 and var8_32.is_exclusive == 1
				var4_32 = Drop.New({
					count = 0,
					type = DROP_TYPE_DORM3D_FURNITURE,
					id = var8_32.id
				}):getIcon()

				setText(arg2_32:Find("descScroll/Viewport/Content/desc"), var8_32.desc)
				setText(arg2_32:Find("countLimit"), var7_32 .. " " .. getProxy(ApartmentProxy):GetFurnitureShopCount(var0_32.item_id) .. "/1")

				var5_32 = var8_32.unlock_tips or {}
				var6_32 = var0_32.shop_id[1]
			elseif var0_32.type == 2 then
				local var9_32 = var5_0[var0_32.item_id]

				var2_32 = var0_32.room_id ~= 0

				local var10_32 = Dorm3dGift.New({
					configId = var0_32.item_id
				})

				var4_32 = Drop.New({
					type = DROP_TYPE_DORM3D_GIFT,
					id = var0_32.item_id,
					count = getProxy(ApartmentProxy):getGiftCount(var0_32.item_id)
				}):getIcon()

				setText(arg2_32:Find("descScroll/Viewport/Content/desc"), var9_32.display)

				local var11_32 = 0

				for iter0_32 = 1, #var0_32.shop_id do
					local var12_32 = var0_32.shop_id[iter0_32]
					local var13_32 = var3_0[var12_32]
					local var14_32 = var13_32.limit_args[1]

					if not var14_32 and var13_32.group_type == 0 then
						var11_32 = 0
					elseif var14_32 and (var14_32[1] == "dailycount" or var14_32[1] == "count") then
						var11_32 = var14_32[3]
					elseif var13_32.group_type == 2 then
						var11_32 = var13_32.group_limit
					end
				end

				setText(arg2_32:Find("countLimit"), var7_32 .. " " .. getProxy(ApartmentProxy):GetGiftShopCount(var0_32.item_id) .. "/" .. var11_32)
				setText(arg2_32:Find("favor/number"), "+" .. pg.dorm3d_favor_trigger[var5_0[var0_32.item_id].favor_trigger_id].num)

				var5_32 = var9_32.unlock_tips or {}
				var6_32 = var10_32:GetShopID()
			elseif var0_32.type == 3 then
				var2_32 = true

				local var15_32 = var4_0[var0_32.item_id]
				local var16_32 = var15_32.invite_icon

				for iter1_32, iter2_32 in ipairs(var16_32) do
					if iter2_32[1] == var0_32.room_id then
						var4_32 = iter2_32[2]
					end
				end

				setText(arg2_32:Find("descScroll/Viewport/Content/desc"), var15_32.room_des)

				local var17_32 = var1_32 and 1 or 0

				setText(arg2_32:Find("countLimit"), var7_32 .. " " .. var17_32 .. "/1")

				var6_32 = var0_32.shop_id[1]
			end

			setActive(arg2_32:Find("bg/normal"), not var1_32)
			setActive(arg2_32:Find("bg/soldOut"), var1_32)
			setActive(arg2_32:Find("normal"), not var2_32 and not var3_32)
			setActive(arg2_32:Find("zhuanshu"), var2_32)
			setActive(arg2_32:Find("tedian"), var3_32)
			GetImageSpriteFromAtlasAsync(var4_32, "", arg2_32:Find("mask/Dorm3dIconTpl/icon"))
			setActive(arg2_32:Find("favor"), var0_32.type == 2)
			setScrollText(arg2_32:Find("name/text"), var0_32.name)

			local var18_32 = UIItemList.New(arg2_32:Find("bubbles/content"), arg2_32:Find("bubbles/content/tpl"))

			arg0_31:SetBubbles(var18_32, var5_32)

			local var19_32 = CommonCommodity.New({
				id = var6_32
			}, Goods.TYPE_SHOPSTREET)
			local var20_32, var21_32, var22_32 = var19_32:GetPrice()
			local var23_32 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = var19_32:GetResType(),
				count = var20_32
			})

			setText(arg2_32:Find("consume/Text"), "<icon name=" .. var19_32:GetResIcon() .. " w=0.81 h=0.81/>" .. var20_32)
			setActive(arg2_32:Find("consume"), not var1_32)
			setActive(arg2_32:Find("soldOut"), var1_32)

			local var24_32 = var3_0[var0_32.shop_id[1]].time

			setActive(arg2_32:Find("timeLimit"), var24_32 ~= "always")

			if var24_32 ~= "always" then
				local var25_32 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var24_32[2])

				setText(arg2_32:Find("timeLimit/Text"), arg0_31:GetTimeRemain(var25_32))
			end

			if not var1_32 then
				onButton(arg0_31, arg2_32, function()
					arg0_31:ClickCommodity(var0_32, arg2_32:Find("tip"))
				end, SFX_PANEL)
			else
				onButton(arg0_31, arg2_32, function()
					var0_0.UpdateCommodtyTip(var0_32)
					setActive(arg2_32:Find("tip"), false)
					pg.TipsMgr.GetInstance():ShowTips(i18n("word_sell_out"))
				end, SFX_PANEL)
			end

			local var26_32 = var0_0.ShouldShowCommodtyTip(var0_32)

			setActive(arg2_32:Find("new"), var26_32)
			setActive(arg2_32:Find("tip"), var26_32)
		end
	end)
	var1_31:align(#var0_31)

	arg0_31.filterIndex = 1

	for iter0_31 = 1, 4 do
		local var3_31 = arg0_31.charaPage:Find("switch"):GetChild(iter0_31 - 1)

		onToggle(arg0_31, var3_31, function(arg0_35)
			if arg0_35 then
				arg0_31.filterIndex = iter0_31

				if iter0_31 == 1 then
					for iter0_35, iter1_35 in ipairs(var2_31) do
						setActive(iter1_35[2], true)
					end
				elseif iter0_31 == 2 then
					for iter2_35, iter3_35 in ipairs(var2_31) do
						setActive(iter3_35[2], iter3_35[1] == 2)
					end
				elseif iter0_31 == 3 then
					for iter4_35, iter5_35 in ipairs(var2_31) do
						setActive(iter5_35[2], iter5_35[1] == 1)
					end
				else
					for iter6_35, iter7_35 in ipairs(var2_31) do
						setActive(iter7_35[2], iter7_35[1] == 3)
					end
				end

				for iter8_35 = 1, 4 do
					local var0_35 = arg0_31.charaPage:Find("switch"):GetChild(iter8_35 - 1)

					setActive(var0_35:Find("selected"), iter8_35 == iter0_31)
				end
			end
		end)

		if iter0_31 == 1 then
			triggerToggle(var3_31, true)
		end
	end
end

function var0_0.ClickCommodity(arg0_36, arg1_36, arg2_36)
	arg0_36.showCount = 1

	if arg1_36.room_id ~= 0 then
		local var0_36 = 0

		for iter0_36, iter1_36 in pairs(var4_0) do
			if iter1_36.type == 2 and iter1_36.character[1] == arg1_36.room_id then
				var0_36 = iter1_36.id
			end
		end

		if not getProxy(ApartmentProxy):getRoom(var0_36) then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))

			return
		end
	end

	if arg1_36.realroom_id ~= 0 and not getProxy(ApartmentProxy):getRoom(arg1_36.realroom_id) then
		pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_publicroom_unlock") .. "：" .. pg.dorm3d_rooms[arg1_36.realroom_id].room)

		return
	end

	var0_0.UpdateCommodtyTip(arg1_36)

	if arg2_36 then
		setActive(arg2_36, false)
	end

	if arg1_36.type == 1 then
		local var1_36 = Dorm3dFurniture.New({
			configId = arg1_36.item_id
		})
		local var2_36 = CommonCommodity.New({
			id = arg1_36.shop_id[1]
		}, Goods.TYPE_SHOPSTREET)
		local var3_36, var4_36, var5_36 = var2_36:GetPrice()
		local var6_36 = Drop.New({
			type = DROP_TYPE_RESOURCE,
			id = var2_36:GetResType(),
			count = var3_36
		})

		arg0_36:emit(Dorm3dShopMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
			content = {
				icon = "<icon name=" .. var2_36:GetResIcon() .. " w=1.1 h=1.1/>",
				off = var4_36,
				cost = var6_36.count,
				old = var5_36,
				name = arg1_36.name
			},
			tip = i18n("dorm3d_shop_gift_tip"),
			drop = var1_36,
			endTime = var1_36:GetEndTime(),
			onYes = function()
				if not var1_36:InShopTime() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_purchase_outtime"))

					return
				end

				arg0_36:emit(GAME.SHOPPING, {
					silentTip = true,
					count = 1,
					shopId = arg1_36.shop_id[1]
				})
			end
		})
	elseif arg1_36.type == 2 then
		local var7_36 = 0

		for iter2_36 = 1, #arg1_36.shop_id do
			local var8_36 = arg1_36.shop_id[iter2_36]
			local var9_36 = var3_0[var8_36]
			local var10_36 = var9_36.limit_args[1]

			if not var10_36 and var9_36.group_type == 0 then
				var7_36 = 0
			elseif var10_36 and (var10_36[1] == "dailycount" or var10_36[1] == "count") then
				var7_36 = var10_36[3]
			elseif var9_36.group_type == 2 then
				var7_36 = var9_36.group_limit
			end
		end

		if var7_36 > 1 then
			local var11_36 = 0

			if arg0_36.selectedId ~= 0 then
				var11_36 = var4_0[arg0_36.selectedId].character[1]
			end

			arg0_36:emit(Dorm3dShopMediator.OPEN_DETAIL, arg1_36, var11_36, function(arg0_38)
				arg0_36.showCount = arg0_38
			end)
		else
			local var12_36 = Dorm3dGift.New({
				configId = arg1_36.item_id
			})
			local var13_36 = CommonCommodity.New({
				id = var12_36:GetShopID()
			}, Goods.TYPE_SHOPSTREET)
			local var14_36, var15_36, var16_36 = var13_36:GetPrice()
			local var17_36 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = var13_36:GetResType(),
				count = var14_36
			})
			local var18_36
			local var19_36 = 0

			_.each(var12_36:getConfig("shop_id"), function(arg0_39)
				local var0_39 = var3_0[arg0_39]

				if var0_39.group_type == 2 then
					var19_36 = math.max(var0_39.group_limit, var19_36)
				end
			end)

			if var19_36 > 0 then
				var18_36 = {
					getProxy(ApartmentProxy):GetGiftShopCount(var12_36:GetConfigID()),
					var19_36
				}
			end

			arg0_36:emit(Dorm3dShopMediator.SHOW_SHOPPING_CONFIRM_WINDOW, {
				content = {
					icon = "<icon name=" .. var13_36:GetResIcon() .. " w=1.1 h=1.1/>",
					off = var15_36,
					cost = var17_36.count,
					old = var16_36,
					name = arg1_36.name,
					weekLimit = var18_36
				},
				tip = i18n("dorm3d_shop_gift_tip"),
				drop = var12_36,
				groupId = arg1_36.room_id,
				onYes = function()
					arg0_36:emit(GAME.SHOPPING, {
						silentTip = true,
						count = 1,
						shopId = var12_36:GetShopID()
					})
				end
			})
		end
	elseif arg1_36.type == 3 then
		local var20_36
		local var21_36 = getProxy(ApartmentProxy):getRoom(arg1_36.item_id)

		if not var21_36 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))

			return
		end

		if not var21_36.unlockCharacter[arg1_36.room_id] then
			var20_36 = "lock"
		elseif not getProxy(ApartmentProxy):getApartment(arg1_36.room_id) then
			var20_36 = "room"
		elseif Apartment.New({
			ship_group = arg1_36.room_id
		}):needDownload() then
			var20_36 = "download"
		end

		if var20_36 == "lock" then
			arg0_36:emit(Dorm3dShopMediator.OPEN_ROOM_UNLOCK_WINDOW, arg1_36.item_id, arg1_36.room_id)
		elseif var20_36 == "room" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_role_locked"))
		elseif var20_36 == "download" then
			pg.TipsMgr.GetInstance():ShowTips(i18n("dorm3d_guide_beach_tip"))
		end
	end
end

function var0_0.SetBubbles(arg0_41, arg1_41, arg2_41)
	arg1_41:make(function(arg0_42, arg1_42, arg2_42)
		if arg0_42 == UIItemList.EventInit then
			local var0_42 = arg1_42 + 1
			local var1_42 = arg2_41[var0_42]

			LoadImageSpriteAtlasAsync("ui/shoptip_atlas", "icon_" .. var1_42, arg2_42:Find("icon/icon"), true)
			setText(arg2_42:Find("bubble/Text"), i18n("dorm3d_shop_tag" .. var1_42))
			setActive(arg2_42:Find("bubble"), false)
			onToggle(arg0_41, arg2_42, function(arg0_43)
				setActive(arg2_42:Find("icon/select"), arg0_43)
				setActive(arg2_42:Find("icon/unselect"), not arg0_43)
				setActive(arg2_42:Find("bubble"), arg0_43)
				setActive(arg0_41.mask, arg0_43)
				onButton(arg0_41, arg0_41.mask, function()
					triggerToggle(arg2_42, false)
				end, SFX_PANEL)
			end)
		end
	end)
	arg1_41:align(#arg2_41)
end

function var0_0.GetTimeRemain(arg0_45, arg1_45)
	local var0_45 = pg.TimeMgr.GetInstance():GetServerTime()
	local var1_45 = math.max(arg1_45 - var0_45, 0)
	local var2_45 = math.floor(var1_45 / 86400)

	if var2_45 > 0 then
		return var2_45 .. i18n("word_date")
	else
		local var3_45 = math.floor(var1_45 / 3600)

		if var3_45 > 0 then
			return var3_45 .. i18n("word_hour")
		else
			local var4_45 = math.floor(var1_45 / 60)

			if var4_45 > 0 then
				return var4_45 .. i18n("word_minute")
			else
				return var1_45 .. i18n("word_second")
			end
		end
	end
end

function var0_0.ShouldShowCommodtyTip(arg0_46)
	if arg0_46.room_id ~= 0 then
		local var0_46 = 0

		for iter0_46, iter1_46 in ipairs(var4_0.all) do
			local var1_46 = var4_0[iter1_46]

			if var1_46.type == 2 and var1_46.character[1] == arg0_46.room_id then
				var0_46 = iter1_46
			end
		end

		if not getProxy(ApartmentProxy):getRoom(var0_46) then
			return false
		end
	end

	if arg0_46.realroom_id ~= 0 and not getProxy(ApartmentProxy):getRoom(arg0_46.realroom_id) then
		return false
	end

	if arg0_46.type == 1 then
		return Dorm3dFurniture.NeedViewTipByFurnitureId(arg0_46.item_id)
	elseif arg0_46.type == 2 then
		local var2_46 = getProxy(PlayerProxy):getRawData().id
		local var3_46 = Dorm3dGift.NeedViewTipByGiftId(arg0_46.item_id)
		local var4_46 = var3_0[arg0_46.shop_id[1]].group ~= 0 and PlayerPrefs.GetInt(var2_46 .. "_dorm3dGiftWeekViewed_" .. arg0_46.item_id, 0) == 0

		return var3_46 or var4_46
	end

	return false
end

function var0_0.ShouldShowSumTip(arg0_47)
	for iter0_47, iter1_47 in ipairs(arg0_47) do
		if var0_0.ShouldShowCommodtyTip(iter1_47) then
			return true
		end
	end

	return false
end

function var0_0.ShouldShowAllTip()
	local var0_48 = {}

	for iter0_48, iter1_48 in ipairs(var2_0.all) do
		local var1_48 = var2_0[iter1_48]
		local var2_48 = false
		local var3_48 = var1_48.shop_id

		for iter2_48, iter3_48 in ipairs(var3_48) do
			local var4_48 = var3_0[iter3_48]

			if not pg.TimeMgr.GetInstance():inTime(var4_48.time) then
				var2_48 = true

				break
			end
		end

		if not var2_48 then
			table.insert(var0_48, var1_48)
		end
	end

	return var0_0.ShouldShowSumTip(var0_48)
end

function var0_0.UpdateCommodtyTip(arg0_49)
	if arg0_49.type == 1 then
		Dorm3dFurniture.SetViewedFlag(arg0_49.item_id)
	elseif arg0_49.type == 2 then
		Dorm3dGift.SetViewedFlag(arg0_49.item_id)

		if var3_0[arg0_49.shop_id[1]].group ~= 0 then
			local var0_49 = getProxy(PlayerProxy):getRawData().id

			PlayerPrefs.SetInt(var0_49 .. "_dorm3dGiftWeekViewed_" .. arg0_49.item_id, 1)
		end
	end
end

function var0_0.UpdateSumTip(arg0_50)
	for iter0_50, iter1_50 in ipairs(arg0_50) do
		var0_0.UpdateCommodtyTip(iter1_50)
	end
end

function var0_0.willExit(arg0_51)
	arg0_51.scrollSnap:Dispose()

	arg0_51.scrollSnap = nil
end

function var0_0.onBackPressed(arg0_52)
	arg0_52:closeView()
end

return var0_0
