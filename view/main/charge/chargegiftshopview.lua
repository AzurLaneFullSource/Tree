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
						arg0_7:emit(ChargeMediator.OPEN_TEC_SHIP_GIFT_SELL_LAYER, var0_8.goods, arg0_7.chargedList)
					end,
					[Goods.SHOW_TYPE_BATTLE_UI] = function()
						arg0_7:emit(ChargeMediator.OPEN_BATTLE_UI_SELL_LAYER, var0_8.goods, arg0_7.chargedList)
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
				arg0_7:emit(ChargeMediator.VIEW_SKIN_PROBABILITY, var0_8.goods.id, arg0_7:GetViewSkinWrap())
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

		local var1_14 = arg0_7.giftGoodsVOListForShow[arg0_14 + 1]

		if var1_14 then
			var0_14:update(var1_14, arg0_7.player, arg0_7.firstChargeIds)
		end
	end

	arg0_7.lScrollRect.onInitItem = var0_7
	arg0_7.lScrollRect.onUpdateItem = var1_7
end

function var0_0.updateScrollRect(arg0_15)
	arg0_15.lScrollRect:SetTotalCount(#arg0_15.giftGoodsVOListForShow, arg0_15.lScrollRect.value)
end

function var0_0.confirm(arg0_16, arg1_16)
	if not arg1_16 then
		return
	end

	arg1_16 = Clone(arg1_16)

	if arg1_16:isChargeType() then
		local var0_16 = not table.contains(arg0_16.firstChargeIds, arg1_16.id) and arg1_16:firstPayDouble()
		local var1_16 = var0_16 and 4 or arg1_16:getConfig("tag")

		if arg1_16:isMonthCard() or arg1_16:isGiftBox() or arg1_16:isItemBox() or arg1_16:isPassItem() then
			local var2_16 = arg1_16:GetExtraServiceItem()
			local var3_16 = arg1_16:GetExtraDrop()
			local var4_16 = arg1_16:GetBonusItem()
			local var5_16
			local var6_16

			if arg1_16:isPassItem() then
				var5_16 = i18n("battlepass_pay_tip")
			elseif arg1_16:isMonthCard() then
				var5_16 = i18n("charge_title_getitem_month")
				var6_16 = i18n("charge_title_getitem_soon")
			else
				var5_16 = i18n("charge_title_getitem")
			end

			local var7_16 = {
				isChargeType = true,
				infoTip = arg1_16:GetInfoTip(),
				icon = "chargeicon/" .. arg1_16:getConfig("picture"),
				name = arg1_16:getConfig("name_display"),
				tipExtra = var5_16,
				extraItems = var2_16,
				price = arg1_16:getConfig("money"),
				isLocalPrice = arg1_16:IsLocalPrice(),
				tagType = var1_16,
				isMonthCard = arg1_16:isMonthCard(),
				tipBonus = var6_16,
				bonusItem = var4_16,
				extraDrop = var3_16,
				descExtra = arg1_16:getConfig("descrip_extra"),
				limitArgs = arg1_16:getConfig("limit_args"),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_16:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_16:emit(ChargeMediator.CHARGE, arg1_16.id)
					end
				end
			}

			arg0_16:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var7_16)
		elseif arg1_16:isGem() then
			local var8_16 = arg1_16:getConfig("money")
			local var9_16 = arg1_16:getConfig("gem")

			if var0_16 then
				var9_16 = var9_16 + arg1_16:getConfig("gem")
			else
				var9_16 = var9_16 + arg1_16:getConfig("extra_gem")
			end

			local var10_16 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_16:getConfig("picture"),
				name = arg1_16:getConfig("name_display"),
				price = arg1_16:getConfig("money"),
				isLocalPrice = arg1_16:IsLocalPrice(),
				tagType = var1_16,
				normalTip = i18n("charge_start_tip", var8_16, var9_16),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_16:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_16:emit(ChargeMediator.CHARGE, arg1_16.id)
					end
				end
			}

			arg0_16:emit(ChargeMediator.OPEN_CHARGE_ITEM_BOX, var10_16)
		end
	else
		local var11_16 = {}
		local var12_16 = arg1_16:getConfig("effect_args")
		local var13_16 = Item.getConfigData(var12_16[1])
		local var14_16 = var13_16.display_icon

		if type(var14_16) == "table" then
			for iter0_16, iter1_16 in ipairs(var14_16) do
				table.insert(var11_16, Drop.New({
					type = iter1_16[1],
					id = iter1_16[2],
					count = iter1_16[3]
				}))
			end
		end

		local var15_16 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var13_16.icon,
			name = var13_16.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var11_16,
			price = arg1_16:getConfig("resource_num"),
			tagType = arg1_16:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_16:getConfig("resource_num"), var13_16.name),
					onYes = function()
						arg0_16:emit(ChargeMediator.BUY_ITEM, arg1_16.id, 1)
					end
				})
			end
		}

		arg0_16:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var15_16)
	end
end

function var0_0.updateGiftGoodsVOList(arg0_21)
	arg0_21.giftGoodsVOList = {}

	local var0_21 = RefluxShopView.getAllRefluxPackID()
	local var1_21 = pg.pay_data_display

	for iter0_21, iter1_21 in pairs(var1_21.all) do
		if not table.contains(var0_21, iter1_21) then
			local var2_21 = var1_21[iter1_21]
			local var3_21 = var2_21.extra_service

			if not (var2_21.akashi_pick == 1) and (var3_21 == Goods.ITEM_BOX or var3_21 == Goods.PASS_ITEM) then
				local var4_21 = Goods.Create({
					shop_id = iter1_21
				}, Goods.TYPE_CHARGE)

				if arg0_21:filterLimitTypeGoods(var4_21) then
					table.insert(arg0_21.giftGoodsVOList, var4_21)
				end
			end
		end
	end

	for iter2_21, iter3_21 in pairs(pg.shop_template.get_id_list_by_genre.gift_package) do
		if not (pg.shop_template[iter3_21].akashi_pick == 1) and not table.contains(var0_21, iter3_21) then
			local var5_21 = Goods.Create({
				shop_id = iter3_21
			}, Goods.TYPE_GIFT_PACKAGE)

			table.insert(arg0_21.giftGoodsVOList, var5_21)
		end
	end
end

function var0_0.sortGiftGoodsVOList(arg0_22)
	arg0_22.giftGoodsVOListForShow = {}

	for iter0_22, iter1_22 in ipairs(arg0_22.giftGoodsVOList) do
		if iter1_22:isChargeType() then
			local var0_22 = ChargeConst.getBuyCount(arg0_22.chargedList, iter1_22.id)

			iter1_22:updateBuyCount(var0_22)

			if iter1_22:canPurchase() and iter1_22:inTime() then
				table.insert(arg0_22.giftGoodsVOListForShow, iter1_22)
			end
		elseif not iter1_22:isLevelLimit(arg0_22.player.level, true) then
			local var1_22 = ChargeConst.getBuyCount(arg0_22.normalList, iter1_22.id)

			iter1_22:updateBuyCount(var1_22)

			local var2_22 = iter1_22:getConfig("group") or 0
			local var3_22 = false

			if var2_22 > 0 then
				local var4_22 = iter1_22:getConfig("group_limit")
				local var5_22 = ChargeConst.getGroupLimit(arg0_22.normalGroupList, var2_22)

				iter1_22:updateGroupCount(var5_22)

				var3_22 = var4_22 > 0 and var4_22 <= var5_22
			end

			local var6_22, var7_22 = pg.TimeMgr.GetInstance():inTime(iter1_22:getConfig("time"))

			if var7_22 then
				arg0_22:addUpdateTimer(var7_22)
			end

			if var6_22 and iter1_22:canPurchase() and not var3_22 then
				table.insert(arg0_22.giftGoodsVOListForShow, iter1_22)
			end
		end
	end

	local function var8_22(arg0_23)
		local var0_23 = arg0_23:getConfig("time")
		local var1_23 = 0

		if type(var0_23) == "string" then
			var1_23 = var1_23 + 999999999999
		elseif type(var0_23) == "table" then
			var1_23 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_23[2]) - pg.TimeMgr.GetInstance():GetServerTime()
			var1_23 = var1_23 > 0 and var1_23 or 999999999999
		else
			var1_23 = var1_23 + 999999999999
		end

		return var1_23
	end

	local var9_22 = {}
	local var10_22 = getProxy(ActivityProxy)

	for iter2_22, iter3_22 in ipairs(var10_22:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_GIFT_UP)) do
		if var10_22:IsActivityNotEnd(iter3_22.id) then
			underscore(iter3_22:getConfig("config_client").gifts):chain():flatten():map(function(arg0_24)
				var9_22[arg0_24] = true
			end)
		end
	end

	table.sort(arg0_22.giftGoodsVOListForShow, CompareFuncs({
		function(arg0_25)
			return var9_22[arg0_25.id] and 0 or 1
		end,
		function(arg0_26)
			return (arg0_26:getConfig("type_order") - 1) % 1000
		end,
		function(arg0_27)
			return var8_22(arg0_27)
		end,
		function(arg0_28)
			return -arg0_28:getConfig("tag")
		end,
		function(arg0_29)
			return arg0_29:getConfig("order") or 999
		end,
		function(arg0_30)
			return arg0_30.id
		end
	}))
end

function var0_0.updateGoodsData(arg0_31)
	arg0_31.firstChargeIds = arg0_31.contextData.firstChargeIds
	arg0_31.chargedList = arg0_31.contextData.chargedList
	arg0_31.normalList = arg0_31.contextData.normalList
	arg0_31.normalGroupList = arg0_31.contextData.normalGroupList
end

function var0_0.setGoodData(arg0_32, arg1_32, arg2_32, arg3_32, arg4_32)
	arg0_32.firstChargeIds = arg1_32
	arg0_32.chargedList = arg2_32
	arg0_32.normalList = arg3_32
	arg0_32.normalGroupList = arg4_32
end

function var0_0.updateData(arg0_33)
	arg0_33.player = getProxy(PlayerProxy):getData()

	arg0_33:updateGiftGoodsVOList()
	arg0_33:sortGiftGoodsVOList()
end

function var0_0.addUpdateTimer(arg0_34, arg1_34)
	local var0_34 = pg.TimeMgr.GetInstance()
	local var1_34 = var0_34:Table2ServerTime(arg1_34)

	if arg0_34.updateTime and var1_34 > var0_34:Table2ServerTime(arg0_34.updateTime) then
		return
	end

	arg0_34.updateTime = arg1_34

	arg0_34:removeUpdateTimer()

	arg0_34.updateTimer = Timer.New(function()
		if var0_34:GetServerTime() > var1_34 then
			arg0_34:removeUpdateTimer()
			arg0_34:reUpdateAll()
		end
	end, 1, -1)

	arg0_34.updateTimer:Start()
	arg0_34.updateTimer.func()
end

function var0_0.removeUpdateTimer(arg0_36)
	if arg0_36.updateTimer then
		arg0_36.updateTimer:Stop()

		arg0_36.updateTimer = nil
	end
end

function var0_0.reUpdateAll(arg0_37)
	arg0_37:updateData()
	arg0_37:updateScrollRect()
end

function var0_0.filterLimitTypeGoods(arg0_38, arg1_38)
	local var0_38 = arg1_38:getConfig("limit_type")

	return switch(var0_38, {
		[3] = function()
			if arg1_38:getConfig("limit_arg") ~= 0 or arg1_38:isLevelLimit(arg0_38.player.level, true) then
				return false
			end

			local var0_39
			local var1_39
			local var2_39

			for iter0_39, iter1_39 in ipairs(arg1_38:getSameLimitGroupTecGoods()) do
				if iter1_39:getConfig("limit_arg") == 1 then
					var1_39 = iter1_39
				elseif iter1_39:getConfig("limit_arg") == 2 then
					var0_39 = iter1_39
				elseif iter1_39:getConfig("limit_arg") == 3 then
					var2_39 = iter1_39
				end
			end

			local var3_39 = ChargeConst.getBuyCount(arg0_38.chargedList, var0_39.id)
			local var4_39 = ChargeConst.getBuyCount(arg0_38.chargedList, var1_39.id)
			local var5_39 = ChargeConst.getBuyCount(arg0_38.chargedList, var2_39.id)

			if var4_39 > 0 then
				return false
			elseif var3_39 > 0 and var5_39 > 0 then
				return false
			else
				return true
			end
		end,
		[5] = function()
			if arg1_38:getConfig("limit_arg") ~= 0 or arg1_38:isLevelLimit(arg0_38.player.level, true) then
				return false
			end

			for iter0_40, iter1_40 in ipairs(arg1_38:getSameLimitGroupTecGoods()) do
				if iter1_40:getConfig("limit_arg") ~= 0 and ChargeConst.getBuyCount(arg0_38.chargedList, iter1_40.id) > 0 then
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
