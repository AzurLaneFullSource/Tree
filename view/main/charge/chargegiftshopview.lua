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
			if var0_7.goods:isChargeType() and var0_7.goods:isTecShipShowGift() then
				arg0_6:emit(ChargeMediator.OPEN_TEC_SHIP_GIFT_SELL_LAYER, var0_7.goods, arg0_6.chargedList)
			else
				arg0_6:confirm(var0_7.goods)
			end
		end, SFX_PANEL)
		onButton(arg0_6, var0_7.viewBtn, function()
			if not var0_7.goods:isChargeType() then
				return
			end

			local var0_9 = var0_7.goods:GetSkinProbability()
			local var1_9 = getProxy(ShipSkinProxy):GetProbabilitySkins(var0_9)

			if #var0_9 <= 0 or #var0_9 ~= #var1_9 then
				local var2_9 = var0_7.goods:GetSkinProbabilityItem()

				arg0_6:emit(BaseUI.ON_DROP, var2_9)
			else
				arg0_6:emit(ChargeMediator.VIEW_SKIN_PROBABILITY, var0_7.goods.id)
			end
		end, SFX_PANEL)

		arg0_6.chargeCardTable[arg0_7] = var0_7
	end

	local function var1_6(arg0_10, arg1_10)
		local var0_10 = arg0_6.chargeCardTable[arg1_10]

		if not var0_10 then
			var0_6(arg1_10)

			var0_10 = arg0_6.chargeCardTable[arg1_10]
		end

		local var1_10 = arg0_6.giftGoodsVOListForShow[arg0_10 + 1]

		if var1_10 then
			var0_10:update(var1_10, arg0_6.player, arg0_6.firstChargeIds)
		end
	end

	arg0_6.lScrollRect.onInitItem = var0_6
	arg0_6.lScrollRect.onUpdateItem = var1_6
end

function var0_0.updateScrollRect(arg0_11)
	arg0_11.lScrollRect:SetTotalCount(#arg0_11.giftGoodsVOListForShow, arg0_11.lScrollRect.value)
end

function var0_0.confirm(arg0_12, arg1_12)
	if not arg1_12 then
		return
	end

	arg1_12 = Clone(arg1_12)

	if arg1_12:isChargeType() then
		local var0_12 = not table.contains(arg0_12.firstChargeIds, arg1_12.id) and arg1_12:firstPayDouble()
		local var1_12 = var0_12 and 4 or arg1_12:getConfig("tag")

		if arg1_12:isMonthCard() or arg1_12:isGiftBox() or arg1_12:isItemBox() or arg1_12:isPassItem() then
			local var2_12 = underscore.map(arg1_12:getConfig("extra_service_item"), function(arg0_13)
				return Drop.Create(arg0_13)
			end)
			local var3_12

			if arg1_12:isPassItem() then
				local var4_12 = arg1_12:getConfig("sub_display")
				local var5_12 = var4_12[1]
				local var6_12 = pg.battlepass_event_pt[var5_12].pt

				var3_12 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = pg.battlepass_event_pt[var5_12].pt,
					count = var4_12[2]
				})
				var2_12 = PlayerConst.MergePassItemDrop(underscore.map(pg.battlepass_event_pt[var5_12].drop_client_pay, function(arg0_14)
					return Drop.Create(arg0_14)
				end))
			end

			local var7_12 = arg1_12:getConfig("gem") + arg1_12:getConfig("extra_gem")
			local var8_12

			if arg1_12:isMonthCard() then
				var8_12 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResDiamond,
					count = var7_12
				})
			elseif var7_12 > 0 then
				table.insert(var2_12, Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResDiamond,
					count = var7_12
				}))
			end

			local var9_12
			local var10_12

			if arg1_12:isPassItem() then
				var9_12 = i18n("battlepass_pay_tip")
			elseif arg1_12:isMonthCard() then
				var9_12 = i18n("charge_title_getitem_month")
				var10_12 = i18n("charge_title_getitem_soon")
			else
				var9_12 = i18n("charge_title_getitem")
			end

			local var11_12 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_12:getConfig("picture"),
				name = arg1_12:getConfig("name_display"),
				tipExtra = var9_12,
				extraItems = var2_12,
				price = arg1_12:getConfig("money"),
				isLocalPrice = arg1_12:IsLocalPrice(),
				tagType = var1_12,
				isMonthCard = arg1_12:isMonthCard(),
				tipBonus = var10_12,
				bonusItem = var8_12,
				extraDrop = var3_12,
				descExtra = arg1_12:getConfig("descrip_extra"),
				limitArgs = arg1_12:getConfig("limit_args"),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_12:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_12:emit(ChargeMediator.CHARGE, arg1_12.id)
					end
				end
			}

			arg0_12:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var11_12)
		elseif arg1_12:isGem() then
			local var12_12 = arg1_12:getConfig("money")
			local var13_12 = arg1_12:getConfig("gem")

			if var0_12 then
				var13_12 = var13_12 + arg1_12:getConfig("gem")
			else
				var13_12 = var13_12 + arg1_12:getConfig("extra_gem")
			end

			local var14_12 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_12:getConfig("picture"),
				name = arg1_12:getConfig("name_display"),
				price = arg1_12:getConfig("money"),
				isLocalPrice = arg1_12:IsLocalPrice(),
				tagType = var1_12,
				normalTip = i18n("charge_start_tip", var12_12, var13_12),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_12:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_12:emit(ChargeMediator.CHARGE, arg1_12.id)
					end
				end
			}

			arg0_12:emit(ChargeMediator.OPEN_CHARGE_ITEM_BOX, var14_12)
		end
	else
		local var15_12 = {}
		local var16_12 = arg1_12:getConfig("effect_args")
		local var17_12 = Item.getConfigData(var16_12[1])
		local var18_12 = var17_12.display_icon

		if type(var18_12) == "table" then
			for iter0_12, iter1_12 in ipairs(var18_12) do
				table.insert(var15_12, {
					type = iter1_12[1],
					id = iter1_12[2],
					count = iter1_12[3]
				})
			end
		end

		local var19_12 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var17_12.icon,
			name = var17_12.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var15_12,
			price = arg1_12:getConfig("resource_num"),
			tagType = arg1_12:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_12:getConfig("resource_num"), var17_12.name),
					onYes = function()
						arg0_12:emit(ChargeMediator.BUY_ITEM, arg1_12.id, 1)
					end
				})
			end
		}

		arg0_12:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var19_12)
	end
end

function var0_0.updateGiftGoodsVOList(arg0_19)
	arg0_19.giftGoodsVOList = {}

	local var0_19 = RefluxShopView.getAllRefluxPackID()
	local var1_19 = pg.pay_data_display

	for iter0_19, iter1_19 in pairs(var1_19.all) do
		if not table.contains(var0_19, iter1_19) then
			local var2_19 = var1_19[iter1_19].extra_service

			if var2_19 == Goods.ITEM_BOX or var2_19 == Goods.PASS_ITEM then
				local var3_19 = Goods.Create({
					shop_id = iter1_19
				}, Goods.TYPE_CHARGE)

				if var3_19:isTecShipGift() then
					if var3_19:isTecShipShowGift() and arg0_19:fliteTecShipGift(var3_19) then
						table.insert(arg0_19.giftGoodsVOList, var3_19)
					end
				else
					table.insert(arg0_19.giftGoodsVOList, var3_19)
				end
			end
		end
	end

	for iter2_19, iter3_19 in pairs(pg.shop_template.get_id_list_by_genre.gift_package) do
		if not table.contains(var0_19, iter3_19) then
			local var4_19 = Goods.Create({
				shop_id = iter3_19
			}, Goods.TYPE_GIFT_PACKAGE)

			table.insert(arg0_19.giftGoodsVOList, var4_19)
		end
	end
end

function var0_0.sortGiftGoodsVOList(arg0_20)
	arg0_20.giftGoodsVOListForShow = {}

	for iter0_20, iter1_20 in ipairs(arg0_20.giftGoodsVOList) do
		if iter1_20:isChargeType() then
			local var0_20 = ChargeConst.getBuyCount(arg0_20.chargedList, iter1_20.id)

			iter1_20:updateBuyCount(var0_20)

			if iter1_20:canPurchase() and iter1_20:inTime() then
				table.insert(arg0_20.giftGoodsVOListForShow, iter1_20)
			end
		elseif not iter1_20:isLevelLimit(arg0_20.player.level, true) then
			local var1_20 = ChargeConst.getBuyCount(arg0_20.normalList, iter1_20.id)

			iter1_20:updateBuyCount(var1_20)

			local var2_20 = iter1_20:getConfig("group") or 0
			local var3_20 = false

			if var2_20 > 0 then
				local var4_20 = iter1_20:getConfig("group_limit")
				local var5_20 = ChargeConst.getGroupLimit(arg0_20.normalGroupList, var2_20)

				iter1_20:updateGroupCount(var5_20)

				var3_20 = var4_20 > 0 and var4_20 <= var5_20
			end

			local var6_20, var7_20 = pg.TimeMgr.GetInstance():inTime(iter1_20:getConfig("time"))

			if var7_20 then
				arg0_20:addUpdateTimer(var7_20)
			end

			if var6_20 and iter1_20:canPurchase() and not var3_20 then
				table.insert(arg0_20.giftGoodsVOListForShow, iter1_20)
			end
		end
	end

	local function var8_20(arg0_21)
		local var0_21 = arg0_21:getConfig("time")
		local var1_21 = 0

		if type(var0_21) == "string" then
			var1_21 = var1_21 + 999999999999
		elseif type(var0_21) == "table" then
			var1_21 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0_21[2]) - pg.TimeMgr.GetInstance():GetServerTime()
			var1_21 = var1_21 > 0 and var1_21 or 999999999999
		else
			var1_21 = var1_21 + 999999999999
		end

		return var1_21
	end

	local var9_20 = {}
	local var10_20 = getProxy(ActivityProxy)

	for iter2_20, iter3_20 in ipairs(var10_20:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_GIFT_UP)) do
		if var10_20:IsActivityNotEnd(iter3_20.id) then
			underscore(iter3_20:getConfig("config_client").gifts):chain():flatten():map(function(arg0_22)
				var9_20[arg0_22] = true
			end)
		end
	end

	table.sort(arg0_20.giftGoodsVOListForShow, CompareFuncs({
		function(arg0_23)
			return var9_20[arg0_23.id] and 0 or 1
		end,
		function(arg0_24)
			return (arg0_24:getConfig("type_order") - 1) % 1000
		end,
		function(arg0_25)
			return var8_20(arg0_25)
		end,
		function(arg0_26)
			return -arg0_26:getConfig("tag")
		end,
		function(arg0_27)
			return arg0_27:getConfig("order") or 999
		end,
		function(arg0_28)
			return arg0_28.id
		end
	}))
end

function var0_0.updateGoodsData(arg0_29)
	arg0_29.firstChargeIds = arg0_29.contextData.firstChargeIds
	arg0_29.chargedList = arg0_29.contextData.chargedList
	arg0_29.normalList = arg0_29.contextData.normalList
	arg0_29.normalGroupList = arg0_29.contextData.normalGroupList
end

function var0_0.setGoodData(arg0_30, arg1_30, arg2_30, arg3_30, arg4_30)
	arg0_30.firstChargeIds = arg1_30
	arg0_30.chargedList = arg2_30
	arg0_30.normalList = arg3_30
	arg0_30.normalGroupList = arg4_30
end

function var0_0.updateData(arg0_31)
	arg0_31.player = getProxy(PlayerProxy):getData()

	arg0_31:updateGiftGoodsVOList()
	arg0_31:sortGiftGoodsVOList()
end

function var0_0.addUpdateTimer(arg0_32, arg1_32)
	local var0_32 = pg.TimeMgr.GetInstance()
	local var1_32 = var0_32:Table2ServerTime(arg1_32)

	if arg0_32.updateTime and var1_32 > var0_32:Table2ServerTime(arg0_32.updateTime) then
		return
	end

	arg0_32.updateTime = arg1_32

	arg0_32:removeUpdateTimer()

	arg0_32.updateTimer = Timer.New(function()
		if var0_32:GetServerTime() > var1_32 then
			arg0_32:removeUpdateTimer()
			arg0_32:reUpdateAll()
		end
	end, 1, -1)

	arg0_32.updateTimer:Start()
	arg0_32.updateTimer.func()
end

function var0_0.removeUpdateTimer(arg0_34)
	if arg0_34.updateTimer then
		arg0_34.updateTimer:Stop()

		arg0_34.updateTimer = nil
	end
end

function var0_0.reUpdateAll(arg0_35)
	arg0_35:updateData()
	arg0_35:updateScrollRect()
end

function var0_0.fliteTecShipGift(arg0_36, arg1_36)
	if arg1_36:isChargeType() and arg1_36:isTecShipShowGift() then
		if arg1_36:isLevelLimit(arg0_36.player.level, true) then
			return false
		end

		local var0_36 = arg1_36:getSameGroupTecShipGift()
		local var1_36
		local var2_36
		local var3_36

		for iter0_36, iter1_36 in ipairs(var0_36) do
			if iter1_36:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Normal then
				var1_36 = iter1_36
			elseif iter1_36:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.High then
				var2_36 = iter1_36
			elseif iter1_36:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Up then
				var3_36 = iter1_36
			end
		end

		local var4_36 = ChargeConst.getBuyCount(arg0_36.chargedList, var1_36.id)
		local var5_36 = ChargeConst.getBuyCount(arg0_36.chargedList, var2_36.id)
		local var6_36 = ChargeConst.getBuyCount(arg0_36.chargedList, var3_36.id)

		if var5_36 > 0 then
			return false
		elseif var4_36 > 0 and var6_36 > 0 then
			return false
		else
			return true
		end
	else
		return true
	end
end

return var0_0
