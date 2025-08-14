local var0_0 = class("ChargeGiftShopView", import("...base.BaseSubView"))

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
		iter1_3:destoryTimer()
	end

	arg0_3:removeUpdateTimer()
end

function var0_0.initData(arg0_4)
	arg0_4.giftGoodsVOList = {}
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
	arg0_5.emptyGo = arg0_5:findTF("emptyText")

	setText(arg0_5.emptyGo, i18n("shop_pack_empty"))

	arg0_5.lScrollRect = GetComponent(arg0_5:findTF("lScrollRect"), "LScrollRect")
	arg0_5.chargeCardTable = {}

	arg0_5:initScrollRect()
	arg0_5:initToggleList()
	arg0_5:updateToggleList()
	arg0_5:updateScrollRect()
	triggerButton(arg0_5:findTF("toggleGroup"):GetChild(0))
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
	else
		local var11_17 = {}
		local var12_17 = arg1_17:getConfig("effect_args")
		local var13_17 = Item.getConfigData(var12_17[1])
		local var14_17 = var13_17.display_icon

		if type(var14_17) == "table" then
			for iter0_17, iter1_17 in ipairs(var14_17) do
				table.insert(var11_17, Drop.New({
					type = iter1_17[1],
					id = iter1_17[2],
					count = iter1_17[3]
				}))
			end
		end

		local var15_17 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var13_17.icon,
			name = var13_17.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var11_17,
			price = arg1_17:getConfig("resource_num"),
			tagType = arg1_17:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_17:getConfig("resource_num"), var13_17.name),
					onYes = function()
						arg0_17:emit(NewShopMainMediator.BUY_ITEM, arg1_17.id, 1)
					end
				})
			end
		}

		arg0_17:emit(NewShopMainMediator.OPEN_CHARGE_ITEM_PANEL, var15_17)
	end
end

function var0_0.initToggleList(arg0_22)
	arg0_22.uiToggleList = UIItemList.New(arg0_22:findTF("toggleGroup"), arg0_22:findTF("toggleGroup/Toggle"))

	arg0_22.uiToggleList:make(function(arg0_23, arg1_23, arg2_23)
		if arg0_23 == UIItemList.EventInit then
			local var0_23 = arg0_22.packageSortList[arg1_23 + 1]

			setText(arg0_22:findTF("selected/Label", arg2_23), i18n(string.format("shop_package_sort_%s", var0_23)))
			setText(arg0_22:findTF("selected/enText", arg2_23), i18n(string.format("shop_package_sort_en_%s", var0_23)))
			setText(arg0_22:findTF("unselected/Label", arg2_23), i18n(string.format("shop_package_sort_%s", var0_23)))
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

function var0_0.updateGiftGoodsVOList(arg0_25)
	arg0_25.giftGoodsVOList = {}
	arg0_25.packageSortList = {
		0
	}

	local var0_25 = RefluxShopView.getAllRefluxPackID()
	local var1_25 = pg.pay_data_display

	for iter0_25, iter1_25 in pairs(var1_25.all) do
		if not table.contains(var0_25, iter1_25) then
			local var2_25 = var1_25[iter1_25]
			local var3_25 = var2_25.extra_service

			if not (var2_25.akashi_pick == 1) and (var3_25 == Goods.ITEM_BOX or var3_25 == Goods.PASS_ITEM) then
				local var4_25 = Goods.Create({
					shop_id = iter1_25
				}, Goods.TYPE_CHARGE)

				if arg0_25:filterLimitTypeGoods(var4_25) then
					local var5_25 = var2_25.package_sort_id

					if not table.contains(arg0_25.packageSortList, var5_25) then
						table.insert(arg0_25.packageSortList, var5_25)
					end

					table.insert(arg0_25.giftGoodsVOList, var4_25)
				end
			end
		end
	end

	for iter2_25, iter3_25 in pairs(pg.shop_template.get_id_list_by_genre.gift_package) do
		local var6_25 = pg.shop_template[iter3_25]

		if not (var6_25.akashi_pick == 1) and not table.contains(var0_25, iter3_25) then
			local var7_25 = Goods.Create({
				shop_id = iter3_25
			}, Goods.TYPE_GIFT_PACKAGE)
			local var8_25 = var6_25.package_sort_id

			if not table.contains(arg0_25.packageSortList, var8_25) then
				table.insert(arg0_25.packageSortList, var8_25)
			end

			table.insert(arg0_25.giftGoodsVOList, var7_25)
		end
	end

	table.sort(arg0_25.packageSortList, function(arg0_26, arg1_26)
		return arg0_26 < arg1_26
	end)
end

function var0_0.sortGiftGoodsVOList(arg0_27)
	arg0_27.giftGoodsVOListForShow = {}

	for iter0_27, iter1_27 in ipairs(arg0_27.giftGoodsVOList) do
		if iter1_27:isChargeType() then
			local var0_27 = ChargeConst.getBuyCount(arg0_27.chargedList, iter1_27.id)

			iter1_27:updateBuyCount(var0_27)

			if iter1_27:canPurchase() and iter1_27:inTime() then
				table.insert(arg0_27.giftGoodsVOListForShow, iter1_27)
			end
		elseif not iter1_27:isLevelLimit(arg0_27.player.level, true) then
			local var1_27 = ChargeConst.getBuyCount(arg0_27.normalList, iter1_27.id)

			iter1_27:updateBuyCount(var1_27)

			local var2_27 = iter1_27:getConfig("group") or 0
			local var3_27 = false

			if var2_27 > 0 then
				local var4_27 = iter1_27:getConfig("group_limit")
				local var5_27 = ChargeConst.getGroupLimit(arg0_27.normalGroupList, var2_27)

				iter1_27:updateGroupCount(var5_27)

				var3_27 = var4_27 > 0 and var4_27 <= var5_27
			end

			local var6_27, var7_27 = pg.TimeMgr.GetInstance():inTime(iter1_27:getConfig("time"))

			if var7_27 then
				arg0_27:addUpdateTimer(var7_27)
			end

			if var6_27 and iter1_27:canPurchase() and not var3_27 then
				table.insert(arg0_27.giftGoodsVOListForShow, iter1_27)
			end
		end
	end

	local function var8_27(arg0_28)
		local var0_28 = arg0_28:getConfig("time")
		local var1_28 = 0

		if type(var0_28) == "string" then
			var1_28 = var1_28 + 999999999999
		elseif type(var0_28) == "table" then
			var1_28 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_28[2]) - pg.TimeMgr.GetInstance():GetServerTime()
			var1_28 = var1_28 > 0 and var1_28 or 999999999999
		else
			var1_28 = var1_28 + 999999999999
		end

		return var1_28
	end

	local var9_27 = {}
	local var10_27 = getProxy(ActivityProxy)

	for iter2_27, iter3_27 in ipairs(var10_27:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_GIFT_UP)) do
		if var10_27:IsActivityNotEnd(iter3_27.id) then
			underscore(iter3_27:getConfig("config_client").gifts):chain():flatten():map(function(arg0_29)
				var9_27[arg0_29] = true
			end)
		end
	end

	table.sort(arg0_27.giftGoodsVOListForShow, CompareFuncs({
		function(arg0_30)
			return var9_27[arg0_30.id] and 0 or 1
		end,
		function(arg0_31)
			return (arg0_31:getConfig("type_order") - 1) % 1000
		end,
		function(arg0_32)
			return var8_27(arg0_32)
		end,
		function(arg0_33)
			return -arg0_33:getConfig("tag")
		end,
		function(arg0_34)
			return arg0_34:getConfig("order") or 999
		end,
		function(arg0_35)
			return arg0_35.id
		end
	}))
end

function var0_0.getFilterList(arg0_36)
	if arg0_36.selectedPackageType == nil or arg0_36.selectedPackageType == 0 then
		return arg0_36.giftGoodsVOListForShow
	end

	return arg0_36:getFilterListByType(arg0_36.selectedPackageType)
end

function var0_0.getFilterListByType(arg0_37, arg1_37)
	local var0_37 = {}

	for iter0_37, iter1_37 in ipairs(arg0_37.giftGoodsVOListForShow) do
		if iter1_37:getConfig("package_sort_id") == arg1_37 then
			table.insert(var0_37, iter1_37)
		end
	end

	return var0_37
end

function var0_0.updateGoodsData(arg0_38)
	arg0_38.firstChargeIds = arg0_38.contextData.firstChargeIds
	arg0_38.chargedList = arg0_38.contextData.chargedList
	arg0_38.normalList = arg0_38.contextData.normalList
	arg0_38.normalGroupList = arg0_38.contextData.normalGroupList
end

function var0_0.setGoodData(arg0_39, arg1_39, arg2_39, arg3_39, arg4_39)
	arg0_39.firstChargeIds = arg1_39
	arg0_39.chargedList = arg2_39
	arg0_39.normalList = arg3_39
	arg0_39.normalGroupList = arg4_39
end

function var0_0.updateData(arg0_40)
	arg0_40.player = getProxy(PlayerProxy):getData()

	arg0_40:updateGiftGoodsVOList()
	arg0_40:sortGiftGoodsVOList()
end

function var0_0.addUpdateTimer(arg0_41, arg1_41)
	local var0_41 = pg.TimeMgr.GetInstance()
	local var1_41 = var0_41:Table2ServerTime(arg1_41)

	if arg0_41.updateTime and var1_41 > var0_41:Table2ServerTime(arg0_41.updateTime) then
		return
	end

	arg0_41.updateTime = arg1_41

	arg0_41:removeUpdateTimer()

	arg0_41.updateTimer = Timer.New(function()
		if var0_41:GetServerTime() > var1_41 then
			arg0_41:removeUpdateTimer()
			arg0_41:reUpdateAll()
		end
	end, 1, -1)

	arg0_41.updateTimer:Start()
	arg0_41.updateTimer.func()
end

function var0_0.removeUpdateTimer(arg0_43)
	if arg0_43.updateTimer then
		arg0_43.updateTimer:Stop()

		arg0_43.updateTimer = nil
	end
end

function var0_0.IsSupplyShop(arg0_44)
	return false
end

function var0_0.reUpdateAll(arg0_45)
	arg0_45:updateData()
	arg0_45:updateToggleList()
	arg0_45:updateScrollRect()

	if not table.contains(arg0_45.packageSortList, arg0_45.selectedPackageType) then
		triggerButton(arg0_45:findTF("toggleGroup"):GetChild(0))
	end
end

function var0_0.ShowPanel(arg0_46, arg1_46)
	setActive(arg0_46._go, arg1_46)
end

function var0_0.filterLimitTypeGoods(arg0_47, arg1_47)
	local var0_47 = arg1_47:getConfig("limit_type")

	return switch(var0_47, {
		[3] = function()
			if arg1_47:getConfig("limit_arg") ~= 0 or arg1_47:isLevelLimit(arg0_47.player.level, true) then
				return false
			end

			local var0_48
			local var1_48
			local var2_48

			for iter0_48, iter1_48 in ipairs(arg1_47:getSameLimitGroupTecGoods()) do
				if iter1_48:getConfig("limit_arg") == 1 then
					var1_48 = iter1_48
				elseif iter1_48:getConfig("limit_arg") == 2 then
					var0_48 = iter1_48
				elseif iter1_48:getConfig("limit_arg") == 3 then
					var2_48 = iter1_48
				end
			end

			local var3_48 = ChargeConst.getBuyCount(arg0_47.chargedList, var0_48.id)
			local var4_48 = ChargeConst.getBuyCount(arg0_47.chargedList, var1_48.id)
			local var5_48 = ChargeConst.getBuyCount(arg0_47.chargedList, var2_48.id)

			if var4_48 > 0 then
				return false
			elseif var3_48 > 0 and var5_48 > 0 then
				return false
			else
				return true
			end
		end,
		[5] = function()
			if arg1_47:getConfig("limit_arg") ~= 0 or arg1_47:isLevelLimit(arg0_47.player.level, true) then
				return false
			end

			for iter0_49, iter1_49 in ipairs(arg1_47:getSameLimitGroupTecGoods()) do
				if iter1_49:getConfig("limit_arg") ~= 0 and ChargeConst.getBuyCount(arg0_47.chargedList, iter1_49.id) > 0 then
					return false
				end
			end

			return true
		end
	}, function()
		return true
	end)
end

return var0_0
