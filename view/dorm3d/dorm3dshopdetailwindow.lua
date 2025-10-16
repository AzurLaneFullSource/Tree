local var0_0 = class("Dorm3dShopDetailWindow", import("view.base.BaseUI"))

var0_0.SELECTED_WIDTH = 52
var0_0.UNSELECTED_WIDTH = 12
var0_0.LOOP_DURATION = 5

function var0_0.getUIName(arg0_1)
	return "Dorm3dShopDetailWindow"
end

function var0_0.init(arg0_2)
	arg0_2.previewTf = arg0_2._tf:Find("Window/Preview")
	arg0_2.bubbleContent = arg0_2._tf:Find("Window/Bubbles/content")
	arg0_2.bubbleTpl = arg0_2._tf:Find("Window/Bubbles/tpl")
	arg0_2.bubbleList = UIItemList.New(arg0_2.bubbleContent, arg0_2.bubbleTpl)
	arg0_2.scrollSnap = BannerScrollRect4Dorm.New(arg0_2._tf:Find("Window/banner/mask/content"), arg0_2._tf:Find("Window/banner/dots"))

	setActive(arg0_2.bubbleTpl, false)

	arg0_2.minusBtn = arg0_2._tf:Find("Window/countList/minusBtn")
	arg0_2.addBtn = arg0_2._tf:Find("Window/countList/addBtn")
	arg0_2.maxBtn = arg0_2._tf:Find("Window/countList/maxBtn")
	arg0_2.countText = arg0_2._tf:Find("Window/countList/count/Text")
	arg0_2.shopCfg = arg0_2.contextData.shopCfg
	arg0_2.unlockTips = pg.dorm3d_gift[arg0_2.shopCfg.item_id].unlock_tips or {}

	local var0_2 = arg0_2.shopCfg.room_id

	arg0_2.unlockBanners = arg0_2.shopCfg.banners

	if arg0_2.contextData.groupId ~= 0 then
		var0_2 = arg0_2.contextData.groupId

		local var1_2 = pg.dorm3d_gift[arg0_2.shopCfg.item_id].unlock_banners or {}
		local var2_2 = table.Find(var1_2, function(arg0_3, arg1_3)
			if arg1_3[1] == var0_2 then
				return true
			end
		end)

		arg0_2.unlockBanners = var2_2 and var2_2[2]
	end

	arg0_2.isExclusive = pg.dorm3d_gift[arg0_2.shopCfg.item_id].ship_group_id ~= 0
	arg0_2.isSpecial = false
	arg0_2.addFavor = pg.dorm3d_favor_trigger[pg.dorm3d_gift[arg0_2.shopCfg.item_id].favor_trigger_id].num

	setActive(arg0_2._tf:Find("Window/Title/gift"), true)

	arg0_2.curCount = 1
	arg0_2.buyCount = getProxy(ApartmentProxy):GetGiftShopCount(arg0_2.shopCfg.item_id)
end

function var0_0.didEnter(arg0_4)
	onButton(arg0_4, arg0_4._tf:Find("Window/Cancel"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4._tf:Find("Mask"), function()
		arg0_4:closeView()
	end)
	arg0_4:InitUIList()
	arg0_4:InitDropIcon()
	arg0_4:InitBanner()

	local var0_4 = Dorm3dGift.New({
		configId = arg0_4.shopCfg.item_id
	})
	local var1_4 = CommonCommodity.New({
		id = var0_4:GetShopID()
	}, Goods.TYPE_SHOPSTREET)
	local var2_4, var3_4, var4_4 = var1_4:GetPrice()
	local var5_4 = Drop.New({
		type = DROP_TYPE_RESOURCE,
		id = var1_4:GetResType(),
		count = var2_4
	})
	local var6_4 = i18n("dorm3d_shop_buy_tips", "<icon name=" .. var1_4:GetResIcon() .. " w=1.1 h=1.1/>", "x" .. var5_4.count, "x" .. var5_4.count, arg0_4.shopCfg.name)
	local var7_4
	local var8_4 = 0

	_.each(var0_4:getConfig("shop_id"), function(arg0_7)
		local var0_7 = pg.shop_template[arg0_7]

		if var0_7.group_type == 2 then
			var8_4 = math.max(var0_7.group_limit, var8_4)
		end
	end)

	if var8_4 > 0 then
		var7_4 = {
			arg0_4.buyCount,
			var8_4
		}
	end

	if var7_4 then
		var6_4 = var6_4 .. i18n("dorm3d_purchase_weekly_limit", var7_4[1], var7_4[2])
	end

	setText(arg0_4._tf:Find("Window/Content"), var6_4)
	setText(arg0_4._tf:Find("Window/Confirm/Text"), i18n("msgbox_text_confirm"))
	setText(arg0_4._tf:Find("Window/Cancel/Text"), i18n("msgbox_text_cancel"))
	pg.UIMgr.GetInstance():OverlayPanel(arg0_4._tf)

	local var9_4 = var0_4:GetShopID()

	arg0_4.itemList = {
		var9_4
	}
	arg0_4.sumPrice = arg0_4:GetGoodPrice(var9_4)

	setText(arg0_4.countText, arg0_4.curCount)

	local var10_4 = 1

	if var7_4 then
		var10_4 = var7_4[2] - var7_4[1]
	end

	local function var11_4(arg0_8)
		arg0_8 = math.max(arg0_8, 1)
		arg0_8 = math.min(arg0_8, var10_4)
		arg0_4.curCount = arg0_8

		setText(arg0_4.countText, arg0_8)

		local var0_8 = arg0_4:GetShopId(arg0_4.buyCount + arg0_4.curCount - 1)
		local var1_8 = arg0_4:GetGoodPrice(var0_8)

		arg0_4.sumPrice = 0

		for iter0_8 = arg0_4.buyCount, arg0_4.buyCount + arg0_4.curCount - 1 do
			arg0_4.sumPrice = arg0_4.sumPrice + arg0_4:GetGoodPrice(arg0_4:GetShopId(iter0_8))
		end

		local var2_8 = i18n("dorm3d_shop_buy_tips", "<icon name=" .. var1_4:GetResIcon() .. " w=1.1 h=1.1/>", "x" .. var1_8, "x" .. arg0_4.sumPrice, arg0_4.shopCfg.name)

		if var7_4 then
			var2_8 = var2_8 .. i18n("dorm3d_purchase_weekly_limit", var7_4[1], var7_4[2])
		end

		setText(arg0_4._tf:Find("Window/Content"), var2_8)
		arg0_4.contextData.changeCount(arg0_8)
	end

	onButton(arg0_4, arg0_4.minusBtn, function()
		if arg0_4.curCount - 1 > 0 then
			table.remove(arg0_4.itemList, #arg0_4.itemList)
		end

		var11_4(arg0_4.curCount - 1)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.addBtn, function()
		if arg0_4.buyCount + arg0_4.curCount + 1 <= var8_4 then
			table.insert(arg0_4.itemList, arg0_4:GetShopId(arg0_4.buyCount + arg0_4.curCount))
		end

		var11_4(arg0_4.curCount + 1)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4.maxBtn, function()
		arg0_4.itemList = {}

		for iter0_11 = arg0_4.buyCount, var8_4 - 1 do
			table.insert(arg0_4.itemList, arg0_4:GetShopId(iter0_11))
		end

		var11_4(var10_4)
	end, SFX_PANEL)
	onButton(arg0_4, arg0_4._tf:Find("Window/Confirm"), function()
		local var0_12 = getProxy(PlayerProxy):getData()
		local var1_12 = pg.shop_template[arg0_4.itemList[1]]

		if var0_12[id2res(var1_12.resource_type)] < arg0_4.sumPrice then
			local var2_12 = Drop.New({
				type = DROP_TYPE_RESOURCE,
				id = var1_12.resource_type
			}):getName()

			if var1_12.resource_type == 1 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_2", i18n("word_gold")), ChargeScene.TYPE_ITEM, {
					{
						59001,
						arg0_4.sumPrice - var0_12[id2res(var1_12.resource_type)],
						arg0_4.sumPrice
					}
				})
			elseif var1_12.resource_type == 4 or var1_12.resource_type == 14 then
				GoShoppingMsgBox(i18n("switch_to_shop_tip_3", i18n("word_gem")), ChargeScene.TYPE_DIAMOND)
			elseif not ItemTipPanel.ShowItemTip(DROP_TYPE_RESOURCE, var1_12.resource_type) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buyProp_noResource_error", var2_12))
			end

			arg0_4:closeView()

			return
		end

		for iter0_12, iter1_12 in ipairs(arg0_4.itemList) do
			arg0_4:emit(Dorm3dShopDetailMediator.SHOPPING, {
				silentTip = true,
				count = 1,
				shopId = iter1_12
			})
		end

		arg0_4:closeView()
	end, SFX_PANEL)
end

function var0_0.InitBanner(arg0_13)
	for iter0_13 = 1, #arg0_13.unlockBanners do
		local var0_13 = arg0_13.scrollSnap:AddChild()

		LoadImageSpriteAsync("dorm3dbanner/" .. arg0_13.unlockBanners[iter0_13], var0_13)
	end

	arg0_13.scrollSnap:SetUp()
end

function var0_0.InitUIList(arg0_14)
	arg0_14.bubbleList:make(function(arg0_15, arg1_15, arg2_15)
		if arg0_15 == UIItemList.EventInit then
			local var0_15 = arg1_15 + 1
			local var1_15 = arg0_14.unlockTips[var0_15]

			LoadImageSpriteAtlasAsync("ui/shoptip_atlas", "icon_" .. var1_15, arg2_15:Find("icon/icon"), true)
			setText(arg2_15:Find("bubble/Text"), i18n("dorm3d_shop_tag" .. var1_15))
			setActive(arg2_15:Find("bubble"), false)
			onToggle(arg0_14, arg2_15, function(arg0_16)
				setActive(arg2_15:Find("icon/select"), arg0_16)
				setActive(arg2_15:Find("icon/unselect"), not arg0_16)
				setActive(arg2_15:Find("bubble"), arg0_16)
			end)
		end
	end)
	arg0_14.bubbleList:align(#arg0_14.unlockTips)
end

function var0_0.InitDropIcon(arg0_17)
	local var0_17 = Drop.New({
		type = DROP_TYPE_DORM3D_GIFT,
		id = arg0_17.shopCfg.item_id,
		count = getProxy(ApartmentProxy):getGiftCount(arg0_17.shopCfg.item_id)
	})

	LoadImageSpriteAtlasAsync(var0_17:getIcon(), "", arg0_17._tf:Find("Window/Item/Dorm3dIconTpl/icon"), true)
	GetImageSpriteFromAtlasAsync("weaponframes", "dorm3d_" .. ItemRarity.Rarity2Print(arg0_17.shopCfg.rarity), arg0_17._tf:Find("Window/Item/Dorm3dIconTpl"))
	setActive(arg0_17._tf:Find("Window/Item/sp"), arg0_17.isExclusive or arg0_17.isSpecial)

	if arg0_17.isSpecial then
		setText(arg0_17._tf:Find("Window/Item/sp/Text"), i18n("dorm3d_purchase_label_special"))
	elseif arg0_17.isExclusive then
		setText(arg0_17._tf:Find("Window/Item/sp/Text"), i18n("dorm3d_purchase_confirm_tip"))
	end

	if arg0_17.addFavor then
		setActive(arg0_17._tf:Find("Window/Item/gift"), true)
		setText(arg0_17._tf:Find("Window/Item/gift/Text"), "+" .. arg0_17.addFavor)
	end
end

function var0_0.GetShopId(arg0_18, arg1_18)
	local var0_18 = arg0_18.shopCfg.shop_id

	for iter0_18 = 1, #var0_18 - 1 do
		local var1_18 = var0_18[iter0_18]
		local var2_18 = pg.shop_template[var1_18]
		local var3_18 = var2_18.limit_args[1]

		if not var3_18 and var2_18.group_type == 0 then
			return var1_18
		elseif var3_18 and (var3_18[1] == "dailycount" or var3_18[1] == "count") then
			if arg1_18 < var3_18[3] then
				return var1_18
			end
		elseif var2_18.group_type == 2 then
			if arg1_18 < var2_18.group_limit then
				return var1_18
			end
		else
			return var1_18
		end
	end

	return var0_18[#var0_18] or 0
end

function var0_0.GetGoodPrice(arg0_19, arg1_19)
	return (CommonCommodity.New({
		id = arg1_19
	}, Goods.TYPE_SHOPSTREET):GetPrice())
end

function var0_0.willExit(arg0_20)
	if arg0_20.timerRefreshTime then
		arg0_20.timerRefreshTime:Stop()

		arg0_20.timerRefreshTime = nil
	end

	arg0_20.scrollSnap:Dispose()

	arg0_20.scrollSnap = nil

	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_20._tf)
end

return var0_0
