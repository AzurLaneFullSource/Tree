local var0_0 = class("BlackFridaySalesGiftPage", import("...base.BaseSubView"))

function var0_0.getUIName(arg0_1)
	return "BlackFridaySalesGiftPage"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
end

function var0_0.initData(arg0_3)
	arg0_3.player = getProxy(PlayerProxy):getData()
	arg0_3.activity = getProxy(ActivityProxy):getActivityByType(ActivityConst.ACTIVITY_TYPE_GIFT_UP)

	arg0_3:initGiftGoods()

	arg0_3.openIndex = 1

	arg0_3:updateGiftGoodsVOList()
end

function var0_0.initUI(arg0_4)
	arg0_4.content = arg0_4:findTF("scrollrect/content")
	arg0_4.soldOutTF = arg0_4:findTF("sold_out")

	setText(arg0_4:findTF("Text", arg0_4.soldOutTF), i18n("newserver_soldout"))
	setActive(arg0_4.soldOutTF, #arg0_4.giftGoodsVOList == 0)

	arg0_4.pagefooters = {
		arg0_4:findTF("pagefooter/dailyPacks"),
		arg0_4:findTF("pagefooter/specialPacks")
	}
	arg0_4.pagefooterWid = arg0_4.pagefooters[1].rect.width
	arg0_4.pagefooterStartPosX = arg0_4.pagefooters[1].anchoredPosition.x
	arg0_4.giftItemList = UIItemList.New(arg0_4.content, arg0_4:findTF("gift_tpl"))
	arg0_4.chargeCardTable = {}

	arg0_4.giftItemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventInit then
			arg0_4:initGift(go(arg2_5))
		elseif arg0_5 == UIItemList.EventUpdate then
			arg0_4:updateGift(go(arg2_5), arg1_5)
		end
	end)
	arg0_4.giftItemList:align(#arg0_4.giftGoodsVOList)
	arg0_4:UpdatePageFooters()
end

function var0_0.UpdatePageFooters(arg0_6)
	arg0_6.pagefooterTrs = {}

	for iter0_6 = 1, 2 do
		local var0_6 = arg0_6.pagefooters[iter0_6]

		arg0_6:UpdatePageFooter(var0_6, iter0_6)

		arg0_6.pagefooterTrs[iter0_6] = var0_6
	end

	local var1_6 = arg0_6.contextData.index or 1

	triggerButton(arg0_6.pagefooterTrs[var1_6])
end

local var1_0 = 0

function var0_0.UpdatePageFooter(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg0_7.pagefooterStartPosX + (var1_0 + arg0_7.pagefooterWid) * (arg2_7 - 1)

	setAnchoredPosition(arg1_7, {
		x = var0_7
	})
	arg0_7:OnSwitch(arg1_7, function()
		arg0_7:SwitchTab(arg2_7)
	end)
end

function var0_0.OnSwitch(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg1_9:Find("mark")

	local function var1_9()
		if arg0_9.markTr then
			setActive(arg0_9.markTr, false)
		end

		arg0_9.markTr = var0_9

		setActive(var0_9, true)
	end

	onButton(arg0_9, arg1_9, function()
		var1_9()
		arg2_9()
	end, SFX_PANEL)
end

function var0_0.SwitchTab(arg0_12, arg1_12)
	arg0_12.openIndex = arg1_12

	arg0_12:onUpdateGift()
end

function var0_0.initGift(arg0_13, arg1_13)
	local var0_13 = BlackFridayChargeCard.New(arg1_13)

	onButton(arg0_13, var0_13.tr, function()
		if var0_13:inTime() then
			arg0_13:confirm(var0_13.goods)
		end
	end, SFX_PANEL)

	arg0_13.chargeCardTable[arg1_13] = var0_13
end

function var0_0.updateGift(arg0_15, arg1_15, arg2_15)
	local var0_15 = arg0_15.chargeCardTable[arg1_15]

	if not var0_15 then
		arg0_15.initGift(arg1_15)

		var0_15 = arg0_15.chargeCardTable[arg1_15]
	end

	local var1_15 = arg0_15.giftGoodsVOList[arg2_15]

	if var1_15 then
		var0_15:update(var1_15, arg0_15.player, arg0_15.firstChargeIds)
	end
end

function var0_0.confirm(arg0_16, arg1_16)
	if not arg1_16 then
		return
	end

	arg1_16 = Clone(arg1_16)

	if arg1_16:isChargeType() then
		local var0_16 = not table.contains(arg0_16.firstChargeIds, arg1_16.id) and arg1_16:firstPayDouble() and 4 or arg1_16:getConfig("tag")
		local var1_16 = arg1_16:GetExtraServiceItem()
		local var2_16 = arg1_16:GetExtraDrop()
		local var3_16 = arg1_16:GetBonusItem()
		local var4_16
		local var5_16

		if arg1_16:isPassItem() then
			var4_16 = i18n("battlepass_pay_tip")
		elseif arg1_16:isMonthCard() then
			var4_16 = i18n("charge_title_getitem_month")
			var5_16 = i18n("charge_title_getitem_soon")
		else
			var4_16 = i18n("charge_title_getitem")
		end

		local var6_16 = {
			isChargeType = true,
			icon = "chargeicon/" .. arg1_16:getConfig("picture"),
			name = arg1_16:getConfig("name_display"),
			tipExtra = var4_16,
			extraItems = var1_16,
			price = arg1_16:getConfig("money"),
			isLocalPrice = arg1_16:IsLocalPrice(),
			tagType = var0_16,
			isMonthCard = arg1_16:isMonthCard(),
			tipBonus = var5_16,
			bonusItem = var3_16,
			extraDrop = var2_16,
			descExtra = arg1_16:getConfig("descrip_extra"),
			limitArgs = arg1_16:getConfig("limit_args"),
			onYes = function()
				if ChargeConst.isNeedSetBirth() then
					arg0_16:emit(BlackFridaySalesMediator.OPEN_CHARGE_BIRTHDAY)
				else
					arg0_16:emit(BlackFridaySalesMediator.CHARGE, arg1_16.id)
				end
			end
		}

		arg0_16:emit(BlackFridaySalesMediator.GIFT_OPEN_ITEM_PANEL, var6_16)
	else
		local var7_16 = {}
		local var8_16 = arg1_16:getConfig("effect_args")
		local var9_16 = Item.getConfigData(var8_16[1])
		local var10_16 = var9_16.display_icon

		if type(var10_16) == "table" then
			for iter0_16, iter1_16 in ipairs(var10_16) do
				table.insert(var7_16, {
					type = iter1_16[1],
					id = iter1_16[2],
					count = iter1_16[3]
				})
			end
		end

		local var11_16 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var9_16.icon,
			name = var9_16.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var7_16,
			price = arg1_16:getConfig("resource_num"),
			tagType = arg1_16:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_16:getConfig("resource_num"), var9_16.name),
					onYes = function()
						arg0_16:emit(BlackFridaySalesMediator.GIFT_BUY_ITEM, arg1_16.id, 1)
					end
				})
			end
		}

		arg0_16:emit(BlackFridaySalesMediator.GIFT_OPEN_ITEM_PANEL, var11_16)
	end
end

function var0_0.onUpdatePlayer(arg0_20, arg1_20)
	arg0_20.player = arg1_20
end

function var0_0.onUpdateGift(arg0_21)
	arg0_21:updateGiftGoodsVOList()
	arg0_21.giftItemList:align(#arg0_21.giftGoodsVOList)
	setActive(arg0_21.soldOutTF, #arg0_21.giftGoodsVOList == 0)
end

function var0_0.initGiftGoods(arg0_22)
	arg0_22.giftList = {
		{},
		{}
	}

	local var0_22 = arg0_22.activity:getConfig("config_client")
	local var1_22 = getProxy(ShopsProxy):getChargedList() or {}

	for iter0_22, iter1_22 in pairs(var0_22.gifts[1]) do
		local var2_22 = Goods.Create({
			shop_id = iter1_22
		}, Goods.TYPE_CHARGE)

		table.insert(arg0_22.giftList[1], var2_22)
	end

	for iter2_22, iter3_22 in pairs(var0_22.gifts[2]) do
		local var3_22 = Goods.Create({
			shop_id = iter3_22
		}, Goods.TYPE_NEW_SERVER)

		table.insert(arg0_22.giftList[1], var3_22)
	end

	for iter4_22, iter5_22 in pairs(var0_22.gifts_2) do
		local var4_22 = Goods.Create({
			shop_id = iter5_22
		}, Goods.TYPE_CHARGE)
		local var5_22 = ChargeConst.getBuyCount(var1_22, iter5_22)

		var4_22:updateBuyCount(var5_22)
		table.insert(arg0_22.giftList[2], var4_22)
	end
end

function var0_0.updateGiftGoodsVOList(arg0_23, arg1_23)
	arg1_23 = arg1_23 or arg0_23.openIndex
	arg0_23.giftGoodsVOList = Clone(arg0_23.giftList[arg1_23])
	arg0_23.normalList = getProxy(ShopsProxy):GetNormalList()
	arg0_23.chargedList = getProxy(ShopsProxy):getChargedList()

	local var0_23 = {}

	for iter0_23, iter1_23 in ipairs(arg0_23.giftGoodsVOList) do
		local var1_23

		if iter1_23:isChargeType() then
			var1_23 = ChargeConst.getBuyCount(arg0_23.chargedList, iter1_23.id)
		else
			var1_23 = ChargeConst.getBuyCount(arg0_23.normalList, iter1_23.id)
		end

		iter1_23:updateBuyCount(var1_23)

		if iter1_23:canPurchase() then
			table.insert(var0_23, iter1_23)
		end
	end

	local var2_23 = pg.TimeMgr.GetInstance()

	table.sort(var0_23, function(arg0_24, arg1_24)
		local var0_24 = var2_23:inTime(arg0_24:getConfig("time")) and 1 or 0
		local var1_24 = var2_23:inTime(arg1_24:getConfig("time")) and 1 or 0
		local var2_24 = arg0_24:isChargeType() and 1 or 0
		local var3_24 = arg1_24:isChargeType() and 1 or 0

		if var0_24 == var1_24 then
			if var2_24 == var3_24 then
				return arg0_24.id < arg1_24.id
			else
				return var2_24 < var3_24
			end
		else
			return var1_24 < var0_24
		end
	end)

	arg0_23.giftGoodsVOList = var0_23
end

function var0_0.isTip(arg0_25)
	local var0_25 = false
	local var1_25 = Clone(arg0_25.giftList[1])

	arg0_25.normalList = getProxy(ShopsProxy):GetNormalList()

	for iter0_25, iter1_25 in ipairs(var1_25) do
		if not iter1_25:isChargeType() then
			local var2_25 = ChargeConst.getBuyCount(arg0_25.chargedList, iter1_25.id)

			iter1_25:updateBuyCount(var2_25)

			if iter1_25:canPurchase() then
				var0_25 = true
			end
		end
	end

	return var0_25
end

function var0_0.OnDestroy(arg0_26)
	return
end

return var0_0
