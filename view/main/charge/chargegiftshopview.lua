local var0_0 = class("ChargeGiftShopView", import("...base.BaseSubView"))

var0_0.ShowPickUp = false

function var0_0.getUIName(arg0_1)
	return "ChargeGiftShopUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:Show()
end

function var0_0.OnDestroy(arg0_3)
	for iter0_3, iter1_3 in pairs(arg0_3.chargeCardTable or {}) do
		iter1_3:Dispose()
	end

	arg0_3:removeUpdateTimer()
end

function var0_0.initData(arg0_4)
	arg0_4.giftGoodsVOListForShow = {}
	arg0_4.packageSortList = {
		0
	}
	arg0_4.prevBtn = nil
	arg0_4.selectedPackageType = nil
	arg0_4.updateTime = nil
	arg0_4.updateTimer = nil
	arg0_4.player = getProxy(PlayerProxy):getData()

	arg0_4:updateData()
end

function var0_0.initUI(arg0_5)
	arg0_5.emptyGo = arg0_5._tf:Find("emptyText")

	setText(arg0_5.emptyGo, i18n("shop_pack_empty"))

	arg0_5.lScrollRect = GetComponent(arg0_5._tf:Find("lScrollRect"), "LScrollRect")
	arg0_5.chargeCardTable = {}

	arg0_5:initScrollRect()
	arg0_5:initToggleList()
	arg0_5:updateToggleList()
	arg0_5:updateScrollRect()
	triggerButton(arg0_5._tf:Find("toggleGroup"):GetChild(0))
end

function var0_0.GetViewSkinWrap(arg0_6)
	return ChargeScene.TYPE_GIFT
end

function var0_0.initScrollRect(arg0_7, arg1_7, arg2_7, arg3_7)
	arg0_7.chargeCardTable = {}

	local function var0_7(arg0_8)
		local var0_8 = ChargeCard.New(arg0_8)

		onButton(arg0_7, var0_8.tr, function()
			if var0_8.goods:isChargeType() then
				switch(var0_8.goods:getShowType(), {
					[Goods.SHOW_TYPE_TECH] = function()
						arg0_7:emit(NewShopMainMediator.OPEN_TEC_SHIP_GIFT_SELL_LAYER, var0_8.goods, arg0_7.chargedList)
					end,
					[Goods.SHOW_TYPE_BATTLE_UI] = function()
						arg0_7:emit(NewShopMainMediator.OPEN_BATTLE_UI_SELL_LAYER, var0_8.goods, arg0_7.chargedList)
					end
				}, function()
					arg0_7:confirm(var0_8.goods)
				end)
			else
				arg0_7:confirm(var0_8.goods)
			end
		end, SFX_PANEL)
		onButton(arg0_7, var0_8.viewBtn, function()
			if not var0_8.goods:isChargeType() then
				return
			end

			local var0_13 = var0_8.goods:GetSkinProbability()
			local var1_13 = getProxy(ShipSkinProxy):GetProbabilitySkins(var0_13)

			if #var0_13 <= 0 or #var0_13 ~= #var1_13 then
				local var2_13 = var0_8.goods:GetSkinProbabilityItem()

				arg0_7:emit(BaseUI.ON_DROP, var2_13)
			else
				arg0_7:emit(NewShopMainMediator.VIEW_SKIN_PROBABILITY, var0_8.goods.id, arg0_7:GetViewSkinWrap())
			end
		end, SFX_PANEL)

		arg0_7.chargeCardTable[arg0_8] = var0_8
	end

	local function var1_7(arg0_14, arg1_14)
		local var0_14 = arg0_7.chargeCardTable[arg1_14]

		if not var0_14 then
			var0_7(arg1_14)

			var0_14 = arg0_7.chargeCardTable[arg1_14]
		end

		local var1_14 = arg0_7.filterList[arg0_14 + 1]

		if var1_14 then
			var0_14:update(var1_14, arg0_7.player, arg0_7.firstChargeIds)
		end
	end

	arg0_7.lScrollRect.onInitItem = var0_7
	arg0_7.lScrollRect.onUpdateItem = var1_7
end

function var0_0.updateToggleList(arg0_15)
	arg0_15.uiToggleList:align(#arg0_15.packageSortList)
end

function var0_0.updateScrollRect(arg0_16)
	arg0_16.filterList = arg0_16:getFilterList()
	arg0_16.lScrollRect.enabled = true

	arg0_16.lScrollRect:SetTotalCount(#arg0_16.filterList, arg0_16.lScrollRect.value)
	setActive(arg0_16.emptyGo, #arg0_16.filterList <= 0)
end

function var0_0.confirm(arg0_17, arg1_17)
	if not arg1_17 then
		return
	end

	arg1_17 = Clone(arg1_17)

	if arg1_17:isChargeType() then
		local var0_17 = not table.contains(arg0_17.firstChargeIds, arg1_17.id) and arg1_17:firstPayDouble()
		local var1_17 = var0_17 and 4 or arg1_17:getConfig("tag")

		if arg1_17:isMonthCard() or arg1_17:isGiftBox() or arg1_17:isItemBox() or arg1_17:isPassItem() then
			local var2_17 = arg1_17:GetExtraServiceItem()
			local var3_17 = arg1_17:GetExtraDrop()
			local var4_17 = arg1_17:GetBonusItem()
			local var5_17
			local var6_17

			if arg1_17:isPassItem() then
				var5_17 = i18n("battlepass_pay_tip")
			elseif arg1_17:isMonthCard() then
				var5_17 = i18n("charge_title_getitem_month")
				var6_17 = i18n("charge_title_getitem_soon")
			else
				var5_17 = i18n("charge_title_getitem")
			end

			local var7_17 = {
				isChargeType = true,
				commodity = arg1_17,
				infoTip = arg1_17:GetInfoTip(),
				icon = "chargeicon/" .. arg1_17:getConfig("picture"),
				name = arg1_17:getConfig("name_display"),
				tipExtra = var5_17,
				extraItems = var2_17,
				price = arg1_17:getConfig("money"),
				isLocalPrice = arg1_17:IsLocalPrice(),
				tagType = var1_17,
				isMonthCard = arg1_17:isMonthCard(),
				tipBonus = var6_17,
				bonusItem = var4_17,
				extraDrop = var3_17,
				descExtra = arg1_17:getConfig("descrip_extra"),
				limitArgs = arg1_17:getConfig("limit_args"),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_17:emit(NewShopMainMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_17:emit(NewShopMainMediator.CHARGE, arg1_17.id)
					end
				end
			}

			arg0_17:emit(NewShopMainMediator.OPEN_CHARGE_ITEM_PANEL, var7_17)
		elseif arg1_17:isGem() then
			local var8_17 = arg1_17:getConfig("money")
			local var9_17 = arg1_17:getConfig("gem")

			if var0_17 then
				var9_17 = var9_17 + arg1_17:getConfig("gem")
			else
				var9_17 = var9_17 + arg1_17:getConfig("extra_gem")
			end

			local var10_17 = {
				isChargeType = true,
				commodity = arg1_17,
				icon = "chargeicon/" .. arg1_17:getConfig("picture"),
				name = arg1_17:getConfig("name_display"),
				price = arg1_17:getConfig("money"),
				isLocalPrice = arg1_17:IsLocalPrice(),
				tagType = var1_17,
				normalTip = i18n("charge_start_tip", var8_17, var9_17),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_17:emit(NewShopMainMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_17:emit(NewShopMainMediator.CHARGE, arg1_17.id)
					end
				end
			}

			arg0_17:emit(NewShopMainMediator.OPEN_CHARGE_ITEM_BOX, var10_17)
		end
	elseif arg1_17:isActGiftPackage() then
		local var11_17 = arg1_17:getBindActivity()

		arg0_17:emit(NewShopMainMediator.OPEN_GIFT_ACT_LAYER, var11_17.id)
	else
		local var12_17 = {}
		local var13_17 = arg1_17:getConfig("effect_args")
		local var14_17 = Item.getConfigData(var13_17[1])
		local var15_17 = var14_17.display_icon

		if type(var15_17) == "table" then
			for iter0_17, iter1_17 in ipairs(var15_17) do
				table.insert(var12_17, Drop.New({
					type = iter1_17[1],
					id = iter1_17[2],
					count = iter1_17[3]
				}))
			end
		end

		local var16_17 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			commodity = arg1_17,
			icon = var14_17.icon,
			name = var14_17.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var12_17,
			price = arg1_17:getConfig("resource_num"),
			tagType = arg1_17:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_17:getConfig("resource_num"), var14_17.name),
					onYes = function()
						arg0_17:emit(NewShopMainMediator.BUY_ITEM, arg1_17.id, 1)
					end
				})
			end
		}

		arg0_17:emit(NewShopMainMediator.OPEN_CHARGE_ITEM_PANEL, var16_17)
	end
end

function var0_0.initToggleList(arg0_22)
	arg0_22.uiToggleList = UIItemList.New(arg0_22._tf:Find("toggleGroup"), arg0_22._tf:Find("toggleGroup/Toggle"))

	arg0_22.uiToggleList:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventInit then
			local var0_23 = arg0_22.packageSortList[arg1_23 + 1]

			setText(arg2_23:Find("selected/Label"), i18n(string.format("shop_package_sort_%s", var0_23)))
			setText(arg2_23:Find("selected/enText"), i18n(string.format("shop_package_sort_en_%s", var0_23)))
			setText(arg2_23:Find("unselected/Label"), i18n(string.format("shop_package_sort_%s", var0_23)))
			setActive(arg2_23:Find("unselected"), true)
			setActive(arg2_23:Find("selected"), false)
		elseif arg0_23 == UIItemList.EventUpdate then
			onButton(arg0_22, arg2_23, function()
				local var0_24 = arg0_22.packageSortList[arg1_23 + 1]

				if arg0_22.selectedPackageType == var0_24 then
					return
				end

				setActive(arg2_23:Find("unselected"), false)
				setActive(arg2_23:Find("selected"), true)

				if arg0_22.prevBtn then
					setActive(arg0_22.prevBtn:Find("unselected"), true)
					setActive(arg0_22.prevBtn:Find("selected"), false)
				end

				arg0_22.prevBtn = arg2_23
				arg0_22.selectedPackageType = var0_24

				arg0_22:updateScrollRect()
			end, SFX_PANEL)
		end
	end)
end

function var0_0.sortGiftGoodsVOList(arg0_25)
	local var0_25
	local var1_25

	arg0_25.giftGoodsVOListForShow, var1_25 = getProxy(ShopsProxy):GetAllShowGiftPackages(arg0_25.ShowPickUp)
	arg0_25.packageSortList = {
		0
	}

	local var2_25 = {
		[0] = true
	}

	for iter0_25, iter1_25 in ipairs(var1_25) do
		local var3_25, var4_25 = pg.TimeMgr.GetInstance():inTime(iter1_25:getConfig("time"))

		if var4_25 then
			arg0_25:addUpdateTimer(var4_25)
		end
	end

	for iter2_25, iter3_25 in ipairs(arg0_25.giftGoodsVOListForShow) do
		if not iter3_25:isChargeType() then
			local var5_25, var6_25 = pg.TimeMgr.GetInstance():inTime(iter3_25:getConfig("time"))

			if var6_25 then
				arg0_25:addUpdateTimer(var6_25)
			end
		end

		local var7_25 = iter3_25:getConfig("package_sort_id")

		if not var2_25[var7_25] then
			var2_25[var7_25] = true

			table.insert(arg0_25.packageSortList, var7_25)
		end
	end

	table.sort(arg0_25.packageSortList)

	local function var8_25(arg0_26)
		local var0_26 = arg0_26:getConfig("time")
		local var1_26 = 0

		if type(var0_26) == "string" then
			var1_26 = var1_26 + 999999999999
		elseif type(var0_26) == "table" then
			var1_26 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_26[2]) - pg.TimeMgr.GetInstance():GetServerTime()
			var1_26 = var1_26 > 0 and var1_26 or 999999999999
		else
			var1_26 = var1_26 + 999999999999
		end

		return var1_26
	end

	local var9_25 = {}
	local var10_25 = getProxy(ActivityProxy)

	for iter4_25, iter5_25 in ipairs(var10_25:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_GIFT_UP)) do
		if var10_25:IsActivityNotEnd(iter5_25.id) then
			underscore(iter5_25:getConfig("config_client").gifts):chain():flatten():map(function(arg0_27)
				var9_25[arg0_27] = true
			end)
		end
	end

	table.sort(arg0_25.giftGoodsVOListForShow, CompareFuncs({
		function(arg0_28)
			return var9_25[arg0_28.id] and 0 or 1
		end,
		function(arg0_29)
			return (arg0_29:getConfig("type_order") - 1) % 1000
		end,
		function(arg0_30)
			return var8_25(arg0_30)
		end,
		function(arg0_31)
			return -arg0_31:getConfig("tag")
		end,
		function(arg0_32)
			return arg0_32:getConfig("order") or 999
		end,
		function(arg0_33)
			return arg0_33.id
		end
	}))
end

function var0_0.getFilterList(arg0_34)
	if arg0_34.selectedPackageType == nil or arg0_34.selectedPackageType == 0 then
		return arg0_34.giftGoodsVOListForShow
	end

	return arg0_34:getFilterListByType(arg0_34.selectedPackageType)
end

function var0_0.getFilterListByType(arg0_35, arg1_35)
	local var0_35 = {}

	for iter0_35, iter1_35 in ipairs(arg0_35.giftGoodsVOListForShow) do
		if iter1_35:getConfig("package_sort_id") == arg1_35 then
			table.insert(var0_35, iter1_35)
		end
	end

	return var0_35
end

function var0_0.updateGoodsData(arg0_36)
	arg0_36.firstChargeIds = arg0_36.contextData.firstChargeIds
	arg0_36.chargedList = arg0_36.contextData.chargedList
end

function var0_0.setGoodData(arg0_37, arg1_37, arg2_37, arg3_37, arg4_37)
	arg0_37.firstChargeIds = arg1_37
	arg0_37.chargedList = arg2_37
end

function var0_0.updateData(arg0_38)
	arg0_38.player = getProxy(PlayerProxy):getData()

	arg0_38:sortGiftGoodsVOList()
end

function var0_0.addUpdateTimer(arg0_39, arg1_39)
	local var0_39 = pg.TimeMgr.GetInstance()
	local var1_39 = var0_39:Table2ServerTime(arg1_39)

	if arg0_39.updateTime and var1_39 > var0_39:Table2ServerTime(arg0_39.updateTime) then
		return
	end

	arg0_39.updateTime = arg1_39

	arg0_39:removeUpdateTimer()

	arg0_39.updateTimer = Timer.New(function()
		if var0_39:GetServerTime() > var1_39 then
			arg0_39:removeUpdateTimer()
			arg0_39:reUpdateAll()
		end
	end, 1, -1)

	arg0_39.updateTimer:Start()
	arg0_39.updateTimer.func()
end

function var0_0.removeUpdateTimer(arg0_41)
	if arg0_41.updateTimer then
		arg0_41.updateTimer:Stop()

		arg0_41.updateTimer = nil
	end
end

function var0_0.IsSupplyShop(arg0_42)
	return false
end

function var0_0.reUpdateAll(arg0_43)
	arg0_43:updateData()
	arg0_43:updateToggleList()
	arg0_43:updateScrollRect()

	if not table.contains(arg0_43.packageSortList, arg0_43.selectedPackageType) then
		triggerButton(arg0_43._tf:Find("toggleGroup"):GetChild(0))
	end
end

function var0_0.ShowPanel(arg0_44, arg1_44)
	setActive(arg0_44._go, arg1_44)
end

return var0_0
