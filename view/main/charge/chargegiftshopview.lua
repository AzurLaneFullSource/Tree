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
	arg0_4.updateTime = nil
	arg0_4.updateTimer = nil
	arg0_4.player = getProxy(PlayerProxy):getData()

	arg0_4:updateData()
end

function var0_0.initUI(arg0_5)
	arg0_5.lScrollRect = GetComponent(arg0_5._tf, "LScrollRect")
	arg0_5.chargeCardTable = {}

	arg0_5:initScrollRect()
	arg0_5:updateScrollRect()
end

function var0_0.initScrollRect(arg0_6, arg1_6, arg2_6, arg3_6)
	arg0_6.chargeCardTable = {}

	local function var0_6(arg0_7)
		local var0_7 = ChargeCard.New(arg0_7)

		onButton(arg0_6, var0_7.tr, function()
			if var0_7.goods:isChargeType() then
				switch(var0_7.goods:getShowType(), {
					[Goods.SHOW_TYPE_TECH] = function()
						arg0_6:emit(ChargeMediator.OPEN_TEC_SHIP_GIFT_SELL_LAYER, var0_7.goods, arg0_6.chargedList)
					end,
					[Goods.SHOW_TYPE_BATTLE_UI] = function()
						arg0_6:emit(ChargeMediator.OPEN_BATTLE_UI_SELL_LAYER, var0_7.goods, arg0_6.chargedList)
					end
				}, function()
					arg0_6:confirm(var0_7.goods)
				end)
			else
				arg0_6:confirm(var0_7.goods)
			end
		end, SFX_PANEL)
		onButton(arg0_6, var0_7.viewBtn, function()
			if not var0_7.goods:isChargeType() then
				return
			end

			local var0_12 = var0_7.goods:GetSkinProbability()
			local var1_12 = getProxy(ShipSkinProxy):GetProbabilitySkins(var0_12)

			if #var0_12 <= 0 or #var0_12 ~= #var1_12 then
				local var2_12 = var0_7.goods:GetSkinProbabilityItem()

				arg0_6:emit(BaseUI.ON_DROP, var2_12)
			else
				arg0_6:emit(ChargeMediator.VIEW_SKIN_PROBABILITY, var0_7.goods.id)
			end
		end, SFX_PANEL)

		arg0_6.chargeCardTable[arg0_7] = var0_7
	end

	local function var1_6(arg0_13, arg1_13)
		local var0_13 = arg0_6.chargeCardTable[arg1_13]

		if not var0_13 then
			var0_6(arg1_13)

			var0_13 = arg0_6.chargeCardTable[arg1_13]
		end

		local var1_13 = arg0_6.giftGoodsVOListForShow[arg0_13 + 1]

		if var1_13 then
			var0_13:update(var1_13, arg0_6.player, arg0_6.firstChargeIds)
		end
	end

	arg0_6.lScrollRect.onInitItem = var0_6
	arg0_6.lScrollRect.onUpdateItem = var1_6
end

function var0_0.updateScrollRect(arg0_14)
	arg0_14.lScrollRect:SetTotalCount(#arg0_14.giftGoodsVOListForShow, arg0_14.lScrollRect.value)
end

function var0_0.confirm(arg0_15, arg1_15)
	if not arg1_15 then
		return
	end

	arg1_15 = Clone(arg1_15)

	if arg1_15:isChargeType() then
		local var0_15 = not table.contains(arg0_15.firstChargeIds, arg1_15.id) and arg1_15:firstPayDouble()
		local var1_15 = var0_15 and 4 or arg1_15:getConfig("tag")

		if arg1_15:isMonthCard() or arg1_15:isGiftBox() or arg1_15:isItemBox() or arg1_15:isPassItem() then
			local var2_15 = arg1_15:GetExtraServiceItem()
			local var3_15 = arg1_15:GetExtraDrop()
			local var4_15 = arg1_15:GetBonusItem()
			local var5_15
			local var6_15

			if arg1_15:isPassItem() then
				var5_15 = i18n("battlepass_pay_tip")
			elseif arg1_15:isMonthCard() then
				var5_15 = i18n("charge_title_getitem_month")
				var6_15 = i18n("charge_title_getitem_soon")
			else
				var5_15 = i18n("charge_title_getitem")
			end

			local var7_15 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_15:getConfig("picture"),
				name = arg1_15:getConfig("name_display"),
				tipExtra = var5_15,
				extraItems = var2_15,
				price = arg1_15:getConfig("money"),
				isLocalPrice = arg1_15:IsLocalPrice(),
				tagType = var1_15,
				isMonthCard = arg1_15:isMonthCard(),
				tipBonus = var6_15,
				bonusItem = var4_15,
				extraDrop = var3_15,
				descExtra = arg1_15:getConfig("descrip_extra"),
				limitArgs = arg1_15:getConfig("limit_args"),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_15:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_15:emit(ChargeMediator.CHARGE, arg1_15.id)
					end
				end
			}

			arg0_15:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var7_15)
		elseif arg1_15:isGem() then
			local var8_15 = arg1_15:getConfig("money")
			local var9_15 = arg1_15:getConfig("gem")

			if var0_15 then
				var9_15 = var9_15 + arg1_15:getConfig("gem")
			else
				var9_15 = var9_15 + arg1_15:getConfig("extra_gem")
			end

			local var10_15 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_15:getConfig("picture"),
				name = arg1_15:getConfig("name_display"),
				price = arg1_15:getConfig("money"),
				isLocalPrice = arg1_15:IsLocalPrice(),
				tagType = var1_15,
				normalTip = i18n("charge_start_tip", var8_15, var9_15),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_15:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_15:emit(ChargeMediator.CHARGE, arg1_15.id)
					end
				end
			}

			arg0_15:emit(ChargeMediator.OPEN_CHARGE_ITEM_BOX, var10_15)
		end
	else
		local var11_15 = {}
		local var12_15 = arg1_15:getConfig("effect_args")
		local var13_15 = Item.getConfigData(var12_15[1])
		local var14_15 = var13_15.display_icon

		if type(var14_15) == "table" then
			for iter0_15, iter1_15 in ipairs(var14_15) do
				table.insert(var11_15, {
					type = iter1_15[1],
					id = iter1_15[2],
					count = iter1_15[3]
				})
			end
		end

		local var15_15 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var13_15.icon,
			name = var13_15.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var11_15,
			price = arg1_15:getConfig("resource_num"),
			tagType = arg1_15:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_15:getConfig("resource_num"), var13_15.name),
					onYes = function()
						arg0_15:emit(ChargeMediator.BUY_ITEM, arg1_15.id, 1)
					end
				})
			end
		}

		arg0_15:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var15_15)
	end
end

function var0_0.updateGiftGoodsVOList(arg0_20)
	arg0_20.giftGoodsVOList = {}

	local var0_20 = RefluxShopView.getAllRefluxPackID()
	local var1_20 = pg.pay_data_display

	for iter0_20, iter1_20 in pairs(var1_20.all) do
		if not table.contains(var0_20, iter1_20) then
			local var2_20 = var1_20[iter1_20].extra_service

			if var2_20 == Goods.ITEM_BOX or var2_20 == Goods.PASS_ITEM then
				local var3_20 = Goods.Create({
					shop_id = iter1_20
				}, Goods.TYPE_CHARGE)

				if arg0_20:filterLimitTypeGoods(var3_20) then
					table.insert(arg0_20.giftGoodsVOList, var3_20)
				end
			end
		end
	end

	for iter2_20, iter3_20 in pairs(pg.shop_template.get_id_list_by_genre.gift_package) do
		if not table.contains(var0_20, iter3_20) then
			local var4_20 = Goods.Create({
				shop_id = iter3_20
			}, Goods.TYPE_GIFT_PACKAGE)

			table.insert(arg0_20.giftGoodsVOList, var4_20)
		end
	end
end

function var0_0.sortGiftGoodsVOList(arg0_21)
	arg0_21.giftGoodsVOListForShow = {}

	for iter0_21, iter1_21 in ipairs(arg0_21.giftGoodsVOList) do
		if iter1_21:isChargeType() then
			local var0_21 = ChargeConst.getBuyCount(arg0_21.chargedList, iter1_21.id)

			iter1_21:updateBuyCount(var0_21)

			if iter1_21:canPurchase() and iter1_21:inTime() then
				table.insert(arg0_21.giftGoodsVOListForShow, iter1_21)
			end
		elseif not iter1_21:isLevelLimit(arg0_21.player.level, true) then
			local var1_21 = ChargeConst.getBuyCount(arg0_21.normalList, iter1_21.id)

			iter1_21:updateBuyCount(var1_21)

			local var2_21 = iter1_21:getConfig("group") or 0
			local var3_21 = false

			if var2_21 > 0 then
				local var4_21 = iter1_21:getConfig("group_limit")
				local var5_21 = ChargeConst.getGroupLimit(arg0_21.normalGroupList, var2_21)

				iter1_21:updateGroupCount(var5_21)

				var3_21 = var4_21 > 0 and var4_21 <= var5_21
			end

			local var6_21, var7_21 = pg.TimeMgr.GetInstance():inTime(iter1_21:getConfig("time"))

			if var7_21 then
				arg0_21:addUpdateTimer(var7_21)
			end

			if var6_21 and iter1_21:canPurchase() and not var3_21 then
				table.insert(arg0_21.giftGoodsVOListForShow, iter1_21)
			end
		end
	end

	local function var8_21(arg0_22)
		local var0_22 = arg0_22:getConfig("time")
		local var1_22 = 0

		if type(var0_22) == "string" then
			var1_22 = var1_22 + 999999999999
		elseif type(var0_22) == "table" then
			var1_22 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_22[2]) - pg.TimeMgr.GetInstance():GetServerTime()
			var1_22 = var1_22 > 0 and var1_22 or 999999999999
		else
			var1_22 = var1_22 + 999999999999
		end

		return var1_22
	end

	local var9_21 = {}
	local var10_21 = getProxy(ActivityProxy)

	for iter2_21, iter3_21 in ipairs(var10_21:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_GIFT_UP)) do
		if var10_21:IsActivityNotEnd(iter3_21.id) then
			underscore(iter3_21:getConfig("config_client").gifts):chain():flatten():map(function(arg0_23)
				var9_21[arg0_23] = true
			end)
		end
	end

	table.sort(arg0_21.giftGoodsVOListForShow, CompareFuncs({
		function(arg0_24)
			return var9_21[arg0_24.id] and 0 or 1
		end,
		function(arg0_25)
			return (arg0_25:getConfig("type_order") - 1) % 1000
		end,
		function(arg0_26)
			return var8_21(arg0_26)
		end,
		function(arg0_27)
			return -arg0_27:getConfig("tag")
		end,
		function(arg0_28)
			return arg0_28:getConfig("order") or 999
		end,
		function(arg0_29)
			return arg0_29.id
		end
	}))
end

function var0_0.updateGoodsData(arg0_30)
	arg0_30.firstChargeIds = arg0_30.contextData.firstChargeIds
	arg0_30.chargedList = arg0_30.contextData.chargedList
	arg0_30.normalList = arg0_30.contextData.normalList
	arg0_30.normalGroupList = arg0_30.contextData.normalGroupList
end

function var0_0.setGoodData(arg0_31, arg1_31, arg2_31, arg3_31, arg4_31)
	arg0_31.firstChargeIds = arg1_31
	arg0_31.chargedList = arg2_31
	arg0_31.normalList = arg3_31
	arg0_31.normalGroupList = arg4_31
end

function var0_0.updateData(arg0_32)
	arg0_32.player = getProxy(PlayerProxy):getData()

	arg0_32:updateGiftGoodsVOList()
	arg0_32:sortGiftGoodsVOList()
end

function var0_0.addUpdateTimer(arg0_33, arg1_33)
	local var0_33 = pg.TimeMgr.GetInstance()
	local var1_33 = var0_33:Table2ServerTime(arg1_33)

	if arg0_33.updateTime and var1_33 > var0_33:Table2ServerTime(arg0_33.updateTime) then
		return
	end

	arg0_33.updateTime = arg1_33

	arg0_33:removeUpdateTimer()

	arg0_33.updateTimer = Timer.New(function()
		if var0_33:GetServerTime() > var1_33 then
			arg0_33:removeUpdateTimer()
			arg0_33:reUpdateAll()
		end
	end, 1, -1)

	arg0_33.updateTimer:Start()
	arg0_33.updateTimer.func()
end

function var0_0.removeUpdateTimer(arg0_35)
	if arg0_35.updateTimer then
		arg0_35.updateTimer:Stop()

		arg0_35.updateTimer = nil
	end
end

function var0_0.reUpdateAll(arg0_36)
	arg0_36:updateData()
	arg0_36:updateScrollRect()
end

function var0_0.filterLimitTypeGoods(arg0_37, arg1_37)
	local var0_37 = arg1_37:getConfig("limit_type")

	return switch(var0_37, {
		[3] = function()
			if arg1_37:getConfig("limit_arg") ~= 0 or arg1_37:isLevelLimit(arg0_37.player.level, true) then
				return false
			end

			local var0_38
			local var1_38
			local var2_38

			for iter0_38, iter1_38 in ipairs(arg1_37:getSameLimitGroupTecGoods()) do
				if iter1_38:getConfig("limit_arg") == 1 then
					var1_38 = iter1_38
				elseif iter1_38:getConfig("limit_arg") == 2 then
					var0_38 = iter1_38
				elseif iter1_38:getConfig("limit_arg") == 3 then
					var2_38 = iter1_38
				end
			end

			local var3_38 = ChargeConst.getBuyCount(arg0_37.chargedList, var0_38.id)
			local var4_38 = ChargeConst.getBuyCount(arg0_37.chargedList, var1_38.id)
			local var5_38 = ChargeConst.getBuyCount(arg0_37.chargedList, var2_38.id)

			if var4_38 > 0 then
				return false
			elseif var3_38 > 0 and var5_38 > 0 then
				return false
			else
				return true
			end
		end,
		[5] = function()
			if arg1_37:getConfig("limit_arg") ~= 0 or arg1_37:isLevelLimit(arg0_37.player.level, true) then
				return false
			end

			for iter0_39, iter1_39 in ipairs(arg1_37:getSameLimitGroupTecGoods()) do
				if iter1_39:getConfig("limit_arg") ~= 0 and ChargeConst.getBuyCount(arg0_37.chargedList, iter1_39.id) > 0 then
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
