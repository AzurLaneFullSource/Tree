local var0_0 = class("SupplyShopView", import("view.base.BaseSubView"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1, arg4_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)

	arg0_1.supplyShopType = arg4_1
end

function var0_0.getUIName(arg0_2)
	return "ShopSupplyShopUI"
end

function var0_0.OnInit(arg0_3)
	arg0_3:initData()
	arg0_3:initUI()

	arg0_3.prevBtn = nil
	arg0_3.pages = {
		[ShopConst.TYPE_ACTIVITY] = ActivityShopPage.New(arg0_3, arg0_3._go),
		[ShopConst.TYPE_SHOP_STREET] = StreetShopPage.New(arg0_3, arg0_3._go),
		[ShopConst.TYPE_MILITARY_SHOP] = MilitaryShopPage.New(arg0_3, arg0_3._go),
		[ShopConst.TYPE_GUILD] = GuildShopPage.New(arg0_3, arg0_3._go),
		[ShopConst.TYPE_SHAM_SHOP] = ShamShopPage.New(arg0_3, arg0_3._go),
		[ShopConst.TYPE_FRAGMENT] = FragmentShopPage.New(arg0_3, arg0_3._go),
		[ShopConst.TYPE_META] = MetaShopPage.New(arg0_3, arg0_3._go),
		[ShopConst.TYPE_MEDAL] = MedalShopPage.New(arg0_3, arg0_3._go),
		[ShopConst.TYPE_QUOTA] = QuotaShopPage.New(arg0_3, arg0_3._go),
		[ShopConst.TYPE_MINI_GAME] = MiniGameShopPage.New(arg0_3, arg0_3._go)
	}
	arg0_3.shopResItemList = {}
	arg0_3.shopResParent = arg0_3:findTF("bg/resList")
	arg0_3.shopResItem = arg0_3:findTF("bg/resList/res")

	arg0_3:blurView()
end

function var0_0.OnDestroy(arg0_4)
	arg0_4:unBlurView()

	arg0_4.prevBtn = nil
	arg0_4.page = nil

	arg0_4:DestroyResItemList()

	for iter0_4, iter1_4 in pairs(arg0_4.pages) do
		iter1_4:OnDestroy()
	end

	arg0_4.pages = nil
end

function var0_0.initUI(arg0_5)
	arg0_5.lScrollRect = GetComponent(arg0_5:findTF("scroll"), "LScrollRect")
end

function var0_0.initData(arg0_6)
	arg0_6.player = getProxy(PlayerProxy):getData()
end

function var0_0.SetAllShopData(arg0_7, arg1_7)
	arg0_7.allShopList = arg1_7
	arg0_7.packageSortList = {}

	local var0_7 = 0

	for iter0_7, iter1_7 in ipairs(ShopConst.SUPPLY_SHOP_LIST[arg0_7.supplyShopType]) do
		for iter2_7, iter3_7 in ipairs(arg0_7.allShopList[iter1_7] or {}) do
			var0_7 = var0_7 + 1

			table.insert(arg0_7.packageSortList, {
				type = iter1_7,
				index = var0_7,
				shopData = iter3_7
			})
		end
	end

	arg0_7.selectedPackageType = nil

	arg0_7:updateData()
	arg0_7:initToggleList()
	arg0_7:updateToggleList()

	local var1_7 = arg0_7:GetDefaultShopIndex()

	triggerButton(arg0_7:findTF("toggleGroup"):GetChild(arg0_7.packageSortList[var1_7].index - 1))
	arg0_7:UpdateShop()
end

function var0_0.GetDefaultShopIndex(arg0_8)
	if arg0_8.supplyShopType == ShopConst.CATEGORY_ACTIVITY then
		local var0_8 = arg0_8.contextData.actId

		for iter0_8, iter1_8 in ipairs(arg0_8.packageSortList) do
			if iter1_8.shopData.activityId == var0_8 then
				return iter1_8.index
			end
		end
	else
		for iter2_8, iter3_8 in ipairs(arg0_8.packageSortList) do
			if iter3_8.type == arg0_8.contextData.shopID then
				local var1_8 = arg0_8.packageSortList[arg0_8.supplyShopType].index
				local var2_8 = arg0_8.packageSortList[arg0_8.supplyShopType].type
				local var3_8 = arg0_8.allShopList[var2_8][var1_8]
				local var4_8, var5_8 = arg0_8.pages[iter3_8.type]:CanOpen(var3_8, arg0_8.player)

				if var4_8 then
					return iter3_8.index
				end
			end
		end
	end

	for iter4_8, iter5_8 in pairs(arg0_8.packageSortList) do
		local var6_8 = iter5_8.index
		local var7_8 = arg0_8.allShopList[iter5_8.type][var6_8]
		local var8_8, var9_8 = arg0_8.pages[iter5_8.type]:CanOpen(var7_8, arg0_8.player)

		if var8_8 then
			return iter5_8.index
		end
	end

	return 1
end

function var0_0.updateToggleList(arg0_9)
	arg0_9.uiToggleList:align(#arg0_9.packageSortList)
end

function var0_0.initToggleList(arg0_10)
	local var0_10 = arg0_10:findTF("toggleGroup")
	local var1_10 = arg0_10:findTF("toggleGroup/Toggle")

	arg0_10.uiToggleList = UIItemList.New(var0_10, var1_10)

	arg0_10.uiToggleList:make(function(arg0_11, arg1_11, arg2_11)
		if arg0_11 == UIItemList.EventInit then
			local var0_11 = arg0_10.packageSortList[arg1_11 + 1].type

			setText(arg0_10:findTF("selected/Label", arg2_11), i18n(ShopConst.TYPE2NAME[var0_11]))
			setText(arg0_10:findTF("selected/enText", arg2_11), i18n(ShopConst.TYPE2NAME[var0_11] .. "en"))
			setText(arg0_10:findTF("unselected/Label", arg2_11), i18n(ShopConst.TYPE2NAME[var0_11]))

			local var1_11 = arg0_10.packageSortList[arg1_11 + 1].index
			local var2_11 = arg0_10.allShopList[var0_11][var1_11]
			local var3_11, var4_11 = arg0_10.pages[var0_11]:CanOpen(var2_11, arg0_10.player)

			if var3_11 == false then
				setActive(arg0_10:findTF("unselected/Label/lock", arg2_11), true)
			else
				setActive(arg0_10:findTF("unselected/Label/lock", arg2_11), false)
			end

			setActive(arg2_11:Find("unselected"), true)
			setActive(arg2_11:Find("selected"), false)
		elseif arg0_11 == UIItemList.EventUpdate then
			onButton(arg0_10, arg2_11, function()
				local var0_12 = arg0_10.packageSortList[arg1_11 + 1].index

				if arg0_10.selectedPackageType == var0_12 then
					return
				end

				local var1_12 = arg0_10.packageSortList[arg1_11 + 1].type
				local var2_12 = arg0_10.allShopList[var1_12][var0_12]
				local var3_12, var4_12 = arg0_10.pages[var1_12]:CanOpen(var2_12, arg0_10.player)

				if var3_12 == false then
					pg.TipsMgr.GetInstance():ShowTips(var4_12)

					return
				end

				setActive(arg2_11:Find("unselected"), false)
				setActive(arg2_11:Find("selected"), true)

				if arg0_10.prevBtn then
					setActive(arg0_10.prevBtn:Find("unselected"), true)
					setActive(arg0_10.prevBtn:Find("selected"), false)
				end

				arg0_10.prevBtn = arg2_11
				arg0_10.selectedPackageType = var0_12

				arg0_10:UpdateShop()
			end, SFX_PANEL)
		end
	end)
end

function var0_0.updateGoodsData(arg0_13)
	arg0_13.firstChargeIds = arg0_13.contextData.firstChargeIds
	arg0_13.chargedList = arg0_13.contextData.chargedList
	arg0_13.normalList = arg0_13.contextData.normalList
	arg0_13.normalGroupList = arg0_13.contextData.normalGroupList
end

function var0_0.setGoodData(arg0_14, arg1_14, arg2_14, arg3_14, arg4_14)
	arg0_14.firstChargeIds = arg1_14
	arg0_14.chargedList = arg2_14
	arg0_14.normalList = arg3_14
	arg0_14.normalGroupList = arg4_14
end

function var0_0.updateData(arg0_15)
	arg0_15.player = getProxy(PlayerProxy):getData()
end

function var0_0.RefreshResItemList(arg0_16, arg1_16)
	for iter0_16, iter1_16 in ipairs(arg1_16) do
		arg0_16.shopResItemList[iter0_16] = arg0_16.shopResItemList[iter0_16] or ShopResItem.New(go(arg0_16.shopResItem), arg0_16.shopResParent)

		arg0_16.shopResItemList[iter0_16]:SetData(iter1_16.type, iter1_16.resID, iter1_16.cnt)
	end

	for iter2_16 = #arg1_16 + 1, #arg0_16.shopResItemList do
		arg0_16.shopResItemList[iter2_16]:Show(false)
	end
end

function var0_0.DestroyResItemList(arg0_17)
	for iter0_17, iter1_17 in ipairs(arg0_17.shopResItemList or {}) do
		iter1_17:Dispose()
	end

	arg0_17.shopResItemList = nil
end

function var0_0.IsSupplyShop(arg0_18)
	return true
end

function var0_0.SetPlayer(arg0_19, arg1_19)
	arg0_19.page:SetPlayer(arg1_19)
end

function var0_0.reUpdateAll(arg0_20)
	arg0_20:updateData()
end

function var0_0.OnUpdateItems(arg0_21, arg1_21)
	arg0_21.items = arg1_21

	if arg0_21.packageSortList then
		local var0_21 = arg0_21.packageSortList[arg0_21.selectedPackageType]

		arg0_21.pages[var0_21.type]:SetItems(arg1_21)
	end
end

function var0_0.OnUpdateShop(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.pages[arg1_22]

	if arg0_22.page == var0_22 then
		arg0_22.page:UpdateShop(arg2_22)
	end
end

function var0_0.OnUpdateCommodity(arg0_23, arg1_23, arg2_23, arg3_23)
	local var0_23 = arg0_23.pages[arg1_23]

	if arg0_23.page == var0_23 then
		arg0_23.page:UpdateCommodity(arg2_23, arg3_23)
	end
end

function var0_0.OnFragmentSellUpdate(arg0_24)
	if arg0_24.page == arg0_24.pages[ShopConst.TYPE_FRAGMENT] then
		arg0_24.page:OnFragmentSellUpdate()
	end
end

function var0_0.UpdateShop(arg0_25)
	local var0_25 = arg0_25.packageSortList[arg0_25.selectedPackageType]
	local var1_25 = var0_25.shopData
	local var2_25 = arg0_25.pages[var0_25.type]
	local var3_25, var4_25 = var2_25:CanOpen(var1_25, arg0_25.player)

	if var3_25 then
		if arg0_25.page then
			arg0_25.page:Hide()
		end

		var2_25:SetUp(var1_25, arg0_25.player, arg0_25.items)

		arg0_25.page = var2_25
	else
		pg.TipsMgr.GetInstance():ShowTips(var4_25)
	end
end

function var0_0.ShowPanel(arg0_26, arg1_26)
	if arg0_26._go then
		setActive(arg0_26._go, arg1_26)
	end
end

function var0_0.blurView(arg0_27)
	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_OVERLAY_FOREVER, arg0_27._tf, {
		pbList = {
			arg0_27:findTF("bg")
		}
	})
end

function var0_0.unBlurView(arg0_28)
	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg0_28._tf, arg0_28._parentTf)
end

return var0_0
