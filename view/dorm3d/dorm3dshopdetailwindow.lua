local var0_0 = class("Dorm3dShopDetailWindow", import("view.base.BaseUI"))

var0_0.SELECTED_WIDTH = 52
var0_0.UNSELECTED_WIDTH = 12
var0_0.LOOP_DURATION = 5

function var0_0.getUIName(arg0_1)
	return "Dorm3dShopDetailWindow"
end

function var0_0.getResource(arg0_2, arg1_2)
	local var0_2 = {
		"weaponframes",
		"ui/shoptip_atlas"
	}
	local var1_2 = (arg1_2 or arg0_2.contextData or {}).shopCfg

	local function var2_2(arg0_3)
		if noEmptyStr(arg0_3) and not table.contains(var0_2, arg0_3) then
			table.insert(var0_2, arg0_3)
		end
	end

	local function var3_2(arg0_4)
		for iter0_4, iter1_4 in ipairs(arg0_4 or {}) do
			var2_2("dorm3dbanner/" .. iter1_4)
		end
	end

	if var1_2 then
		var3_2(var1_2.banners)

		local var4_2 = pg.dorm3d_gift[var1_2.item_id]

		if var4_2 then
			for iter0_2, iter1_2 in ipairs(var4_2.unlock_banners or {}) do
				var3_2(iter1_2[2])
			end
		end

		local var5_2 = Drop.New({
			count = 0,
			type = DROP_TYPE_DORM3D_GIFT,
			id = var1_2.item_id
		})

		var2_2(var5_2:getIcon())
	end

	return table.insertto(var0_2, var0_0.super.getResource(arg0_2, arg1_2))
end

function var0_0.init(arg0_5)
	arg0_5.previewTf = arg0_5._tf:Find("Window/Preview")
	arg0_5.bubbleContent = arg0_5._tf:Find("Window/Bubbles/content")
	arg0_5.bubbleTpl = arg0_5._tf:Find("Window/Bubbles/tpl")
	arg0_5.bubbleList = UIItemList.New(arg0_5.bubbleContent, arg0_5.bubbleTpl)
	arg0_5.scrollSnap = BannerScrollRect4Dorm.New(arg0_5._tf:Find("Window/banner/mask/content"), arg0_5._tf:Find("Window/banner/dots"))

	setActive(arg0_5.bubbleTpl, false)

	arg0_5.minusBtn = arg0_5._tf:Find("Window/countList/minusBtn")
	arg0_5.addBtn = arg0_5._tf:Find("Window/countList/addBtn")
	arg0_5.maxBtn = arg0_5._tf:Find("Window/countList/maxBtn")
	arg0_5.countText = arg0_5._tf:Find("Window/countList/count/Text")
	arg0_5.shopCfg = arg0_5.contextData.shopCfg
	arg0_5.unlockTips = pg.dorm3d_gift[arg0_5.shopCfg.item_id].unlock_tips or {}

	local var0_5 = arg0_5.shopCfg.room_id

	arg0_5.unlockBanners = arg0_5.shopCfg.banners

	if arg0_5.contextData.groupId ~= 0 then
		var0_5 = arg0_5.contextData.groupId

		local var1_5 = pg.dorm3d_gift[arg0_5.shopCfg.item_id].unlock_banners or {}
		local var2_5 = table.Find(var1_5, function(arg0_6, arg1_6)
			if arg1_6[1] == var0_5 then
				return true
			end
		end)

		arg0_5.unlockBanners = var2_5 and var2_5[2]
	end

	arg0_5.isExclusive = pg.dorm3d_gift[arg0_5.shopCfg.item_id].ship_group_id ~= 0
	arg0_5.isSpecial = false
	arg0_5.addFavor = pg.dorm3d_favor_trigger[pg.dorm3d_gift[arg0_5.shopCfg.item_id].favor_trigger_id].num

	setActive(arg0_5._tf:Find("Window/Title/gift"), true)

	arg0_5.curCount = 1
	arg0_5.buyCount = getProxy(ApartmentProxy):GetGiftShopCount(arg0_5.shopCfg.item_id)
end

function var0_0.didEnter(arg0_7)
	onButton(arg0_7, arg0_7._tf:Find("Window/Cancel"), function()
		arg0_7:closeView()
	end, SFX_CANCEL)
	onButton(arg0_7, arg0_7._tf:Find("Mask"), function()
		arg0_7:closeView()
	end)
	arg0_7:InitUIList()
	arg0_7:InitDropIcon()
	arg0_7:InitBanner()

	local var0_7 = Dorm3dGift.New({
		configId = arg0_7.shopCfg.item_id
	})
	local var1_7 = CommonCommodity.New({
		id = var0_7:GetShopID()
	}, Goods.TYPE_SHOPSTREET)
	local var2_7, var3_7, var4_7 = var1_7:GetPrice()
	local var5_7 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var1_7:GetResType(),
		count = var2_7
	})
	local var6_7 = i18n("dorm3d_shop_buy_tips", "<icon name=" .. var1_7:GetResIcon() .. " w=1.1 h=1.1/>", "x" .. var5_7.count, "x" .. var5_7.count, arg0_7.shopCfg.name)
	local var7_7
	local var8_7 = 0

	_.each(var0_7:getConfig("shop_id"), function(arg0_10)
		local var0_10 = ShopConst.GetShopConfig(arg0_10)

		if var0_10.group_type == 2 then
			var8_7 = math.max(var0_10.group_limit, var8_7)
		end
	end)

	if var8_7 > 0 then
		var7_7 = {
			arg0_7.buyCount,
			var8_7
		}
	end

	if var7_7 then
		var6_7 = var6_7 .. i18n("dorm3d_purchase_weekly_limit", var7_7[1], var7_7[2])
	end

	setText(arg0_7._tf:Find("Window/Content"), var6_7)
	setText(arg0_7._tf:Find("Window/Confirm/Text"), i18n("msgbox_text_confirm"))
	setText(arg0_7._tf:Find("Window/Cancel/Text"), i18n("msgbox_text_cancel"))
	pg.UIMgr.GetInstance():OverlayPanel(arg0_7._tf)

	local var9_7 = var0_7:GetShopID()

	arg0_7.itemList = {
		var9_7
	}
	arg0_7.sumPrice = arg0_7:GetGoodPrice(var9_7)

	setText(arg0_7.countText, arg0_7.curCount)

	local var10_7 = 1

	if var7_7 then
		var10_7 = var7_7[2] - var7_7[1]
	end

	local function var11_7(arg0_11)
		arg0_11 = math.max(arg0_11, 1)
		arg0_11 = math.min(arg0_11, var10_7)
		arg0_7.curCount = arg0_11

		setText(arg0_7.countText, arg0_11)

		local var0_11 = arg0_7:GetShopId(arg0_7.buyCount + arg0_7.curCount - 1)
		local var1_11 = arg0_7:GetGoodPrice(var0_11)

		arg0_7.sumPrice = 0

		for iter0_11 = arg0_7.buyCount, arg0_7.buyCount + arg0_7.curCount - 1 do
			arg0_7.sumPrice = arg0_7.sumPrice + arg0_7:GetGoodPrice(arg0_7:GetShopId(iter0_11))
		end

		local var2_11 = i18n("dorm3d_shop_buy_tips", "<icon name=" .. var1_7:GetResIcon() .. " w=1.1 h=1.1/>", "x" .. var1_11, "x" .. arg0_7.sumPrice, arg0_7.shopCfg.name)

		if var7_7 then
			var2_11 = var2_11 .. i18n("dorm3d_purchase_weekly_limit", var7_7[1], var7_7[2])
		end

		setText(arg0_7._tf:Find("Window/Content"), var2_11)
		arg0_7.contextData.changeCount(arg0_11)
	end

	onButton(arg0_7, arg0_7.minusBtn, function()
		if arg0_7.curCount - 1 > 0 then
			table.remove(arg0_7.itemList, #arg0_7.itemList)
		end

		var11_7(arg0_7.curCount - 1)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.addBtn, function()
		if arg0_7.buyCount + arg0_7.curCount + 1 <= var8_7 then
			table.insert(arg0_7.itemList, arg0_7:GetShopId(arg0_7.buyCount + arg0_7.curCount))
		end

		var11_7(arg0_7.curCount + 1)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7.maxBtn, function()
		arg0_7.itemList = {}

		for iter0_14 = arg0_7.buyCount, var8_7 - 1 do
			table.insert(arg0_7.itemList, arg0_7:GetShopId(iter0_14))
		end

		var11_7(var10_7)
	end, SFX_PANEL)
	onButton(arg0_7, arg0_7._tf:Find("Window/Confirm"), function()
		local var0_15 = getProxy(PlayerProxy):getData()
		local var1_15 = ShopConst.GetShopConfig(arg0_7.itemList[1])

		if var0_15[id2res(var1_15.resource_type)] < arg0_7.sumPrice then
			local var2_15 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = var1_15.resource_type
			}):getName()

			if var1_15.resource_type == 1 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						arg0_7.sumPrice - var0_15[id2res(var1_15.resource_type)],
						arg0_7.sumPrice
					}
				})
			elseif var1_15.resource_type == 4 or var1_15.resource_type == 14 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
			elseif not ItemTipPanel.ShowItemTip(DROP_TYPE_RESOURCE, var1_15.resource_type) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var2_15))
			end

			arg0_7:closeView()

			return
		end

		for iter0_15, iter1_15 in ipairs(arg0_7.itemList) do
			arg0_7:emit(Dorm3dShopDetailMediator.SHOPPING, {
				silentTip = true,
				count = 1,
				shopId = iter1_15
			})
		end

		arg0_7:closeView()
	end, SFX_PANEL)
end

function var0_0.InitBanner(arg0_16)
	for iter0_16 = 1, #arg0_16.unlockBanners do
		local var0_16 = arg0_16.scrollSnap:AddChild()

		LoadImageSpriteAsync("dorm3dbanner/" .. arg0_16.unlockBanners[iter0_16], var0_16)
	end

	arg0_16.scrollSnap:SetUp()
end

function var0_0.InitUIList(arg0_17)
	arg0_17.bubbleList:make(function(arg0_18, arg1_18, arg2_18)
		if arg0_18 == UIItemList.EventInit then
			local var0_18 = arg1_18 + 1
			local var1_18 = arg0_17.unlockTips[var0_18]

			LoadImageSpriteAtlasAsync("ui/shoptip_atlas", "icon_" .. var1_18, arg2_18:Find("icon/icon"), true)
			setText(arg2_18:Find("bubble/Text"), i18n("dorm3d_shop_tag" .. var1_18))
			setActive(arg2_18:Find("bubble"), false)
			onToggle(arg0_17, arg2_18, function(arg0_19)
				setActive(arg2_18:Find("icon/select"), arg0_19)
				setActive(arg2_18:Find("icon/unselect"), not arg0_19)
				setActive(arg2_18:Find("bubble"), arg0_19)
			end)
		end
	end)
	arg0_17.bubbleList:align(#arg0_17.unlockTips)
end

function var0_0.InitDropIcon(arg0_20)
	local var0_20 = Drop.New({
		type = DROP_TYPE_DORM3D_GIFT,
		id = arg0_20.shopCfg.item_id,
		count = getProxy(ApartmentProxy):getGiftCount(arg0_20.shopCfg.item_id)
	})

	LoadImageSpriteAtlasAsync(var0_20:getIcon(), "", arg0_20._tf:Find("Window/Item/Dorm3dIconTpl/icon"), true)
	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(arg0_20.shopCfg.rarity), arg0_20._tf:Find("Window/Item/Dorm3dIconTpl"))
	setActive(arg0_20._tf:Find("Window/Item/sp"), arg0_20.isExclusive or arg0_20.isSpecial)

	if arg0_20.isSpecial then
		setText(arg0_20._tf:Find("Window/Item/sp/Text"), i18n("dorm3d_purchase_label_special"))
	elseif arg0_20.isExclusive then
		setText(arg0_20._tf:Find("Window/Item/sp/Text"), i18n("dorm3d_purchase_confirm_tip"))
	end

	if arg0_20.addFavor then
		setActive(arg0_20._tf:Find("Window/Item/gift"), true)
		setText(arg0_20._tf:Find("Window/Item/gift/Text"), "+" .. arg0_20.addFavor)
	end
end

function var0_0.GetShopId(arg0_21, arg1_21)
	local var0_21 = arg0_21.shopCfg.shop_id

	for iter0_21 = 1, #var0_21 - 1 do
		local var1_21 = var0_21[iter0_21]
		local var2_21 = ShopConst.GetShopConfig(var1_21)
		local var3_21 = var2_21.limit_args[1]

		if not var3_21 and var2_21.group_type == 0 then
			return var1_21
		elseif var3_21 and (var3_21[1] == "dailycount" or var3_21[1] == "count") then
			if arg1_21 < var3_21[3] then
				return var1_21
			end
		elseif var2_21.group_type == 2 then
			if arg1_21 < var2_21.group_limit then
				return var1_21
			end
		else
			return var1_21
		end
	end

	return var0_21[#var0_21] or 0
end

function var0_0.GetGoodPrice(arg0_22, arg1_22)
	return (CommonCommodity.New({
		id = arg1_22
	}, Goods.TYPE_SHOPSTREET):GetPrice())
end

function var0_0.willExit(arg0_23)
	if arg0_23.timerRefreshTime then
		arg0_23.timerRefreshTime:Stop()

		arg0_23.timerRefreshTime = nil
	end

	arg0_23.scrollSnap:Dispose()

	arg0_23.scrollSnap = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_23._tf)
end

return var0_0
