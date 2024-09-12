local var0_0 = class("ChargeDiamondShopView", import("...base.BaseSubView"))

var0_0.MonthCardID = 1

function var0_0.getUIName(arg0_1)
	return "ChargeDiamondShopUI"
end

function var0_0.OnInit(arg0_2)
	arg0_2:initData()
	arg0_2:initUI()
	arg0_2:Show()
end

function var0_0.OnDestroy(arg0_3)
	return
end

function var0_0.initData(arg0_4)
	arg0_4.isNeedHideMonthCard = (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and pg.SdkMgr.GetInstance():CheckAudit()
	arg0_4.diamondGoodsVOList = {}
	arg0_4.diamondGoodsVOListForShow = {}
	arg0_4.player = getProxy(PlayerProxy):getData()

	arg0_4:updateData()
end

function var0_0.initUI(arg0_5)
	arg0_5.itemTpl = arg0_5:findTF("ItemTpl")

	local var0_5 = arg0_5:findTF("content")

	arg0_5.monthCardTF = arg0_5:findTF("ItemMonth", var0_5)
	arg0_5.itemContainerTF = arg0_5:findTF("ItemList", var0_5)
	arg0_5.uiItemList = arg0_5:initUIItemList()

	arg0_5:updateView()
end

function var0_0.initUIItemList(arg0_6)
	local var0_6 = UIItemList.New(arg0_6.itemContainerTF, arg0_6.itemTpl)

	var0_6:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			arg1_7 = arg1_7 + 1

			local var0_7 = ChargeDiamondCard.New(go(arg2_7), arg0_6.monthCardTF, arg0_6)
			local var1_7 = arg0_6.diamondGoodsVOListForShow[arg1_7]

			var0_7:update(var1_7, arg0_6.player, arg0_6.firstChargeIds)
			onButton(arg0_6, var0_7.tr, function()
				arg0_6:confirm(var0_7.goods)
			end, SFX_PANEL)
		end
	end)

	arg0_6.uiItemList = var0_6

	return var0_6
end

function var0_0.updateUIItemList(arg0_9)
	arg0_9.uiItemList:align(#arg0_9.diamondGoodsVOListForShow)
end

function var0_0.updateView(arg0_10)
	setActive(arg0_10.monthCardTF, not arg0_10.isNeedHideMonthCard)
	arg0_10:updateUIItemList()
end

function var0_0.confirm(arg0_11, arg1_11)
	if not arg1_11 then
		return
	end

	arg1_11 = Clone(arg1_11)

	if arg1_11:isChargeType() then
		local var0_11 = not table.contains(arg0_11.firstChargeIds, arg1_11.id) and arg1_11:firstPayDouble()
		local var1_11 = var0_11 and 4 or arg1_11:getConfig("tag")

		if arg1_11:isMonthCard() or arg1_11:isGiftBox() or arg1_11:isItemBox() or arg1_11:isPassItem() then
			local var2_11 = arg1_11:GetExtraServiceItem()
			local var3_11 = arg1_11:GetExtraDrop()
			local var4_11 = arg1_11:GetBonusItem()
			local var5_11
			local var6_11

			if arg1_11:isPassItem() then
				var5_11 = i18n("battlepass_pay_tip")
			elseif arg1_11:isMonthCard() then
				var5_11 = i18n("charge_title_getitem_month")
				var6_11 = i18n("charge_title_getitem_soon")
			else
				var5_11 = i18n("charge_title_getitem")
			end

			local var7_11 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_11:getConfig("picture"),
				name = arg1_11:getConfig("name_display"),
				tipExtra = var5_11,
				extraItems = var2_11,
				price = arg1_11:getConfig("money"),
				isLocalPrice = arg1_11:IsLocalPrice(),
				tagType = var1_11,
				isMonthCard = arg1_11:isMonthCard(),
				tipBonus = var6_11,
				bonusItem = var4_11,
				extraDrop = var3_11,
				descExtra = arg1_11:getConfig("descrip_extra"),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_11:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_11:emit(ChargeMediator.CHARGE, arg1_11.id)
					end
				end
			}

			arg0_11:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var7_11)
		elseif arg1_11:isGem() then
			local var8_11 = arg1_11:getConfig("money")
			local var9_11 = arg1_11:getConfig("gem")

			if var0_11 then
				var9_11 = var9_11 + arg1_11:getConfig("gem")
			else
				var9_11 = var9_11 + arg1_11:getConfig("extra_gem")
			end

			local var10_11 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_11:getConfig("picture"),
				name = arg1_11:getConfig("name_display"),
				price = arg1_11:getConfig("money"),
				isLocalPrice = arg1_11:IsLocalPrice(),
				tagType = var1_11,
				normalTip = i18n("charge_start_tip", var8_11, var9_11),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_11:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_11:emit(ChargeMediator.CHARGE, arg1_11.id)
					end
				end
			}

			arg0_11:emit(ChargeMediator.OPEN_CHARGE_ITEM_BOX, var10_11)
		end
	else
		local var11_11 = {}
		local var12_11 = arg1_11:getConfig("effect_args")
		local var13_11 = Item.getConfigData(var12_11[1])
		local var14_11 = var13_11.display_icon

		if type(var14_11) == "table" then
			for iter0_11, iter1_11 in ipairs(var14_11) do
				table.insert(var11_11, {
					type = iter1_11[1],
					id = iter1_11[2],
					count = iter1_11[3]
				})
			end
		end

		local var15_11 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var13_11.icon,
			name = var13_11.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var11_11,
			price = arg1_11:getConfig("resource_num"),
			tagType = arg1_11:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_11:getConfig("resource_num"), var13_11.name),
					onYes = function()
						arg0_11:emit(ChargeMediator.BUY_ITEM, arg1_11.id, 1)
					end
				})
			end
		}

		arg0_11:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var15_11)
	end
end

function var0_0.updateDiamondGoodsVOList(arg0_16)
	arg0_16.diamondGoodsVOList = {}

	local var0_16 = pg.pay_data_display

	for iter0_16, iter1_16 in pairs(var0_16.all) do
		local var1_16 = var0_16[iter1_16].extra_service

		if arg0_16.isNeedHideMonthCard and iter1_16 == var0_0.MonthCardID then
			-- block empty
		elseif pg.SdkMgr.GetInstance():IgnorePlatform(var0_16[iter1_16].ignorePlatform) then
			-- block empty
		elseif var1_16 == Goods.MONTH_CARD or var1_16 == Goods.GEM or var1_16 == Goods.GIFT_BOX then
			local var2_16 = Goods.Create({
				shop_id = iter1_16
			}, Goods.TYPE_CHARGE)

			table.insert(arg0_16.diamondGoodsVOList, var2_16)
		end
	end
end

function var0_0.sortDiamondGoodsVOList(arg0_17)
	arg0_17.diamondGoodsVOListForShow = {}

	for iter0_17, iter1_17 in ipairs(arg0_17.diamondGoodsVOList) do
		local var0_17 = ChargeConst.getBuyCount(arg0_17.chargedList, iter1_17.id)

		iter1_17:updateBuyCount(var0_17)

		if iter1_17:canPurchase() and iter1_17:inTime() then
			table.insert(arg0_17.diamondGoodsVOListForShow, iter1_17)
		end
	end

	table.sort(arg0_17.diamondGoodsVOListForShow, function(arg0_18, arg1_18)
		local var0_18 = not table.contains(arg0_17.firstChargeIds, arg0_18.id) and arg0_18:firstPayDouble() and 1 or 0
		local var1_18 = not table.contains(arg0_17.firstChargeIds, arg1_18.id) and arg1_18:firstPayDouble() and 1 or 0
		local var2_18 = 0
		local var3_18 = 0

		if arg0_18:isFree() then
			return true
		elseif arg1_18:isFree() then
			return false
		end

		if arg0_18:isChargeType() and arg0_18:isMonthCard() then
			local var4_18 = arg0_17.player:getCardById(VipCard.MONTH)

			if var4_18 then
				local var5_18 = var4_18:getLeftDate()
				local var6_18 = pg.TimeMgr.GetInstance():GetServerTime()

				var2_18 = math.floor((var5_18 - var6_18) / 86400) > (arg0_18:getConfig("limit_arg") or 0) and 1 or 0
			end
		end

		if arg1_18:isChargeType() and arg1_18:isMonthCard() then
			local var7_18 = arg0_17.player:getCardById(VipCard.MONTH)

			if var7_18 then
				local var8_18 = var7_18:getLeftDate()
				local var9_18 = pg.TimeMgr.GetInstance():GetServerTime()

				var3_18 = math.floor((var8_18 - var9_18) / 86400) > (arg1_18:getConfig("limit_arg") or 0) and 1 or 0
			end
		end

		if var2_18 ~= var3_18 then
			return var2_18 < var3_18
		end

		local var10_18 = arg0_18:getConfig("tag") == 2 and 1 or 0
		local var11_18 = arg1_18:getConfig("tag") == 2 and 1 or 0

		if var0_18 == var1_18 and var10_18 == var11_18 then
			return arg0_18.id < arg1_18.id
		else
			return var1_18 < var0_18 or var0_18 == var1_18 and var11_18 < var10_18
		end
	end)
end

function var0_0.updateGoodsData(arg0_19)
	arg0_19.firstChargeIds = arg0_19.contextData.firstChargeIds
	arg0_19.chargedList = arg0_19.contextData.chargedList
	arg0_19.normalList = arg0_19.contextData.normalList
	arg0_19.normalGroupList = arg0_19.contextData.normalGroupList
end

function var0_0.setGoodData(arg0_20, arg1_20, arg2_20, arg3_20, arg4_20)
	arg0_20.firstChargeIds = arg1_20
	arg0_20.chargedList = arg2_20
	arg0_20.normalList = arg3_20
	arg0_20.normalGroupList = arg4_20
end

function var0_0.updateData(arg0_21)
	arg0_21.player = getProxy(PlayerProxy):getData()

	arg0_21:updateDiamondGoodsVOList()
	arg0_21:sortDiamondGoodsVOList()
end

function var0_0.reUpdateAll(arg0_22)
	arg0_22:updateData()
	arg0_22:updateView()
end

return var0_0
