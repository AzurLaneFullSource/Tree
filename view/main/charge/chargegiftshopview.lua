local var0 = class("ChargeGiftShopView", import("...base.BaseSubView"))

function var0.getUIName(arg0)
	return "ChargeGiftShopUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:Show()
end

function var0.OnDestroy(arg0)
	for iter0, iter1 in pairs(arg0.chargeCardTable or {}) do
		iter1:destoryTimer()
	end

	arg0:removeUpdateTimer()
end

function var0.initData(arg0)
	arg0.giftGoodsVOList = {}
	arg0.giftGoodsVOListForShow = {}
	arg0.updateTime = nil
	arg0.updateTimer = nil
	arg0.player = getProxy(PlayerProxy):getData()

	arg0:updateData()
end

function var0.initUI(arg0)
	arg0.lScrollRect = GetComponent(arg0._tf, "LScrollRect")
	arg0.chargeCardTable = {}

	arg0:initScrollRect()
	arg0:updateScrollRect()
end

function var0.initScrollRect(arg0, arg1, arg2, arg3)
	arg0.chargeCardTable = {}

	local function var0(arg0)
		local var0 = ChargeCard.New(arg0)

		onButton(arg0, var0.tr, function()
			if var0.goods:isChargeType() and var0.goods:isTecShipShowGift() then
				arg0:emit(ChargeMediator.OPEN_TEC_SHIP_GIFT_SELL_LAYER, var0.goods, arg0.chargedList)
			else
				arg0:confirm(var0.goods)
			end
		end, SFX_PANEL)
		onButton(arg0, var0.viewBtn, function()
			if not var0.goods:isChargeType() then
				return
			end

			local var0 = var0.goods:GetSkinProbability()
			local var1 = getProxy(ShipSkinProxy):GetProbabilitySkins(var0)

			if #var0 <= 0 or #var0 ~= #var1 then
				local var2 = var0.goods:GetSkinProbabilityItem()

				arg0:emit(BaseUI.ON_DROP, var2)
			else
				arg0:emit(ChargeMediator.VIEW_SKIN_PROBABILITY, var0.goods.id)
			end
		end, SFX_PANEL)

		arg0.chargeCardTable[arg0] = var0
	end

	local function var1(arg0, arg1)
		local var0 = arg0.chargeCardTable[arg1]

		if not var0 then
			var0(arg1)

			var0 = arg0.chargeCardTable[arg1]
		end

		local var1 = arg0.giftGoodsVOListForShow[arg0 + 1]

		if var1 then
			var0:update(var1, arg0.player, arg0.firstChargeIds)
		end
	end

	arg0.lScrollRect.onInitItem = var0
	arg0.lScrollRect.onUpdateItem = var1
end

function var0.updateScrollRect(arg0)
	arg0.lScrollRect:SetTotalCount(#arg0.giftGoodsVOListForShow, arg0.lScrollRect.value)
end

function var0.confirm(arg0, arg1)
	if not arg1 then
		return
	end

	arg1 = Clone(arg1)

	if arg1:isChargeType() then
		local var0 = not table.contains(arg0.firstChargeIds, arg1.id) and arg1:firstPayDouble()
		local var1 = var0 and 4 or arg1:getConfig("tag")

		if arg1:isMonthCard() or arg1:isGiftBox() or arg1:isItemBox() or arg1:isPassItem() then
			local var2 = underscore.map(arg1:getConfig("extra_service_item"), function(arg0)
				return Drop.Create(arg0)
			end)
			local var3

			if arg1:isPassItem() then
				local var4 = arg1:getConfig("sub_display")
				local var5 = var4[1]
				local var6 = pg.battlepass_event_pt[var5].pt

				var3 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = pg.battlepass_event_pt[var5].pt,
					count = var4[2]
				})
				var2 = PlayerConst.MergePassItemDrop(underscore.map(pg.battlepass_event_pt[var5].drop_client_pay, function(arg0)
					return Drop.Create(arg0)
				end))
			end

			local var7 = arg1:getConfig("gem") + arg1:getConfig("extra_gem")
			local var8

			if arg1:isMonthCard() then
				var8 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResDiamond,
					count = var7
				})
			elseif var7 > 0 then
				table.insert(var2, Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResDiamond,
					count = var7
				}))
			end

			local var9
			local var10

			if arg1:isPassItem() then
				var9 = i18n("battlepass_pay_tip")
			elseif arg1:isMonthCard() then
				var9 = i18n("charge_title_getitem_month")
				var10 = i18n("charge_title_getitem_soon")
			else
				var9 = i18n("charge_title_getitem")
			end

			local var11 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1:getConfig("picture"),
				name = arg1:getConfig("name_display"),
				tipExtra = var9,
				extraItems = var2,
				price = arg1:getConfig("money"),
				isLocalPrice = arg1:IsLocalPrice(),
				tagType = var1,
				isMonthCard = arg1:isMonthCard(),
				tipBonus = var10,
				bonusItem = var8,
				extraDrop = var3,
				descExtra = arg1:getConfig("descrip_extra"),
				limitArgs = arg1:getConfig("limit_args"),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0:emit(ChargeMediator.CHARGE, arg1.id)
					end
				end
			}

			arg0:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var11)
		elseif arg1:isGem() then
			local var12 = arg1:getConfig("money")
			local var13 = arg1:getConfig("gem")

			if var0 then
				var13 = var13 + arg1:getConfig("gem")
			else
				var13 = var13 + arg1:getConfig("extra_gem")
			end

			local var14 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1:getConfig("picture"),
				name = arg1:getConfig("name_display"),
				price = arg1:getConfig("money"),
				isLocalPrice = arg1:IsLocalPrice(),
				tagType = var1,
				normalTip = i18n("charge_start_tip", var12, var13),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0:emit(ChargeMediator.CHARGE, arg1.id)
					end
				end
			}

			arg0:emit(ChargeMediator.OPEN_CHARGE_ITEM_BOX, var14)
		end
	else
		local var15 = {}
		local var16 = arg1:getConfig("effect_args")
		local var17 = Item.getConfigData(var16[1])
		local var18 = var17.display_icon

		if type(var18) == "table" then
			for iter0, iter1 in ipairs(var18) do
				table.insert(var15, {
					type = iter1[1],
					id = iter1[2],
					count = iter1[3]
				})
			end
		end

		local var19 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var17.icon,
			name = var17.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var15,
			price = arg1:getConfig("resource_num"),
			tagType = arg1:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1:getConfig("resource_num"), var17.name),
					onYes = function()
						arg0:emit(ChargeMediator.BUY_ITEM, arg1.id, 1)
					end
				})
			end
		}

		arg0:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var19)
	end
end

function var0.updateGiftGoodsVOList(arg0)
	arg0.giftGoodsVOList = {}

	local var0 = RefluxShopView.getAllRefluxPackID()
	local var1 = pg.pay_data_display

	for iter0, iter1 in pairs(var1.all) do
		if not table.contains(var0, iter1) then
			local var2 = var1[iter1].extra_service

			if var2 == Goods.ITEM_BOX or var2 == Goods.PASS_ITEM then
				local var3 = Goods.Create({
					shop_id = iter1
				}, Goods.TYPE_CHARGE)

				if var3:isTecShipGift() then
					if var3:isTecShipShowGift() and arg0:fliteTecShipGift(var3) then
						table.insert(arg0.giftGoodsVOList, var3)
					end
				else
					table.insert(arg0.giftGoodsVOList, var3)
				end
			end
		end
	end

	for iter2, iter3 in pairs(pg.shop_template.get_id_list_by_genre.gift_package) do
		if not table.contains(var0, iter3) then
			local var4 = Goods.Create({
				shop_id = iter3
			}, Goods.TYPE_GIFT_PACKAGE)

			table.insert(arg0.giftGoodsVOList, var4)
		end
	end
end

function var0.sortGiftGoodsVOList(arg0)
	arg0.giftGoodsVOListForShow = {}

	for iter0, iter1 in ipairs(arg0.giftGoodsVOList) do
		if iter1:isChargeType() then
			local var0 = ChargeConst.getBuyCount(arg0.chargedList, iter1.id)

			iter1:updateBuyCount(var0)

			if iter1:canPurchase() and iter1:inTime() then
				table.insert(arg0.giftGoodsVOListForShow, iter1)
			end
		elseif not iter1:isLevelLimit(arg0.player.level, true) then
			local var1 = ChargeConst.getBuyCount(arg0.normalList, iter1.id)

			iter1:updateBuyCount(var1)

			local var2 = iter1:getConfig("group") or 0
			local var3 = false

			if var2 > 0 then
				local var4 = iter1:getConfig("group_limit")
				local var5 = ChargeConst.getGroupLimit(arg0.normalGroupList, var2)

				iter1:updateGroupCount(var5)

				var3 = var4 > 0 and var4 <= var5
			end

			local var6, var7 = pg.TimeMgr.GetInstance():inTime(iter1:getConfig("time"))

			if var7 then
				arg0:addUpdateTimer(var7)
			end

			if var6 and iter1:canPurchase() and not var3 then
				table.insert(arg0.giftGoodsVOListForShow, iter1)
			end
		end
	end

	local function var8(arg0)
		local var0 = arg0:getConfig("time")
		local var1 = 0

		if type(var0) == "string" then
			var1 = var1 + 999999999999
		elseif type(var0) == "table" then
			var1 = pg.TimeMgr.GetInstance():parseTimeFromConfig(var0[2]) - pg.TimeMgr.GetInstance():GetServerTime()
			var1 = var1 > 0 and var1 or 999999999999
		else
			var1 = var1 + 999999999999
		end

		return var1
	end

	local var9 = {}
	local var10 = getProxy(ActivityProxy)

	for iter2, iter3 in ipairs(var10:getActivitiesByType(ActivityConst.ACTIVITY_TYPE_GIFT_UP)) do
		if var10:IsActivityNotEnd(iter3.id) then
			underscore(iter3:getConfig("config_client").gifts):chain():flatten():map(function(arg0)
				var9[arg0] = true
			end)
		end
	end

	table.sort(arg0.giftGoodsVOListForShow, CompareFuncs({
		function(arg0)
			return var9[arg0.id] and 0 or 1
		end,
		function(arg0)
			return (arg0:getConfig("type_order") - 1) % 1000
		end,
		function(arg0)
			return var8(arg0)
		end,
		function(arg0)
			return -arg0:getConfig("tag")
		end,
		function(arg0)
			return arg0:getConfig("order") or 999
		end,
		function(arg0)
			return arg0.id
		end
	}))
end

function var0.updateGoodsData(arg0)
	arg0.firstChargeIds = arg0.contextData.firstChargeIds
	arg0.chargedList = arg0.contextData.chargedList
	arg0.normalList = arg0.contextData.normalList
	arg0.normalGroupList = arg0.contextData.normalGroupList
end

function var0.setGoodData(arg0, arg1, arg2, arg3, arg4)
	arg0.firstChargeIds = arg1
	arg0.chargedList = arg2
	arg0.normalList = arg3
	arg0.normalGroupList = arg4
end

function var0.updateData(arg0)
	arg0.player = getProxy(PlayerProxy):getData()

	arg0:updateGiftGoodsVOList()
	arg0:sortGiftGoodsVOList()
end

function var0.addUpdateTimer(arg0, arg1)
	local var0 = pg.TimeMgr.GetInstance()
	local var1 = var0:Table2ServerTime(arg1)

	if arg0.updateTime and var1 > var0:Table2ServerTime(arg0.updateTime) then
		return
	end

	arg0.updateTime = arg1

	arg0:removeUpdateTimer()

	arg0.updateTimer = Timer.New(function()
		if var0:GetServerTime() > var1 then
			arg0:removeUpdateTimer()
			arg0:reUpdateAll()
		end
	end, 1, -1)

	arg0.updateTimer:Start()
	arg0.updateTimer.func()
end

function var0.removeUpdateTimer(arg0)
	if arg0.updateTimer then
		arg0.updateTimer:Stop()

		arg0.updateTimer = nil
	end
end

function var0.reUpdateAll(arg0)
	arg0:updateData()
	arg0:updateScrollRect()
end

function var0.fliteTecShipGift(arg0, arg1)
	if arg1:isChargeType() and arg1:isTecShipShowGift() then
		if arg1:isLevelLimit(arg0.player.level, true) then
			return false
		end

		local var0 = arg1:getSameGroupTecShipGift()
		local var1
		local var2
		local var3

		for iter0, iter1 in ipairs(var0) do
			if iter1:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Normal then
				var1 = iter1
			elseif iter1:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.High then
				var2 = iter1
			elseif iter1:getConfig("limit_arg") == Goods.Tec_Ship_Gift_Arg.Up then
				var3 = iter1
			end
		end

		local var4 = ChargeConst.getBuyCount(arg0.chargedList, var1.id)
		local var5 = ChargeConst.getBuyCount(arg0.chargedList, var2.id)
		local var6 = ChargeConst.getBuyCount(arg0.chargedList, var3.id)

		if var5 > 0 then
			return false
		elseif var4 > 0 and var6 > 0 then
			return false
		else
			return true
		end
	else
		return true
	end
end

return var0
