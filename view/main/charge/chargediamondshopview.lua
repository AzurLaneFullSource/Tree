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
	arg0_5.itemTpl = arg0_5._tf:Find("ItemTpl")

	local var0_5 = arg0_5._tf:Find("content")

	arg0_5.monthCardTF = var0_5:Find("ItemMonth")
	arg0_5.itemContainerTF = var0_5:Find("ItemList")
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
				commodity = arg1_11,
				infoTip = arg1_11:GetInfoTip(),
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
						arg0_11:emit(NewShopMainMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_11:emit(NewShopMainMediator.CHARGE, arg1_11.id)
					end
				end
			}

			arg0_11:emit(NewShopMainMediator.OPEN_CHARGE_ITEM_PANEL, var7_11)
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
				commodity = arg1_11,
				icon = "chargeicon/" .. arg1_11:getConfig("picture"),
				name = arg1_11:getConfig("name_display"),
				price = arg1_11:getConfig("money"),
				isLocalPrice = arg1_11:IsLocalPrice(),
				tagType = var1_11,
				normalTip = i18n("charge_start_tip", var8_11, var9_11),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_11:emit(NewShopMainMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_11:emit(NewShopMainMediator.CHARGE, arg1_11.id)
					end
				end
			}

			arg0_11:emit(NewShopMainMediator.OPEN_CHARGE_ITEM_BOX, var10_11)
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
			commodity = arg1_11,
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
						arg0_11:emit(NewShopMainMediator.BUY_ITEM, arg1_11.id, 1)
					end
				})
			end
		}

		arg0_11:emit(NewShopMainMediator.OPEN_CHARGE_ITEM_PANEL, var15_11)
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

	table.sort(arg0_17.diamondGoodsVOListForShow, CompareFuncs({
		function(arg0_18)
			return arg0_18:isFree() and 0 or 1
		end,
		function(arg0_19)
			if arg0_19:isChargeType() and arg0_19:isMonthCard() then
				local var0_19 = arg0_17.player:getCardById(VipCard.MONTH)

				if var0_19 then
					local var1_19 = var0_19:getLeftDate()
					local var2_19 = pg.TimeMgr.GetInstance():GetServerTime()

					if math.floor((var1_19 - var2_19) / 86400) > (arg0_19:getConfig("limit_arg") or 0) then
						return 1
					end
				end
			end

			return 0
		end,
		function(arg0_20)
			return not table.contains(arg0_17.firstChargeIds, arg0_20.id) and arg0_20:firstPayDouble() and 0 or 1
		end,
		function(arg0_21)
			return arg0_21:getConfig("tag") == 2 and 0 or 1
		end,
		function(arg0_22)
			return arg0_22.id
		end
	}))
end

function var0_0.updateGoodsData(arg0_23)
	arg0_23.firstChargeIds = arg0_23.contextData.firstChargeIds
	arg0_23.chargedList = arg0_23.contextData.chargedList
	arg0_23.normalList = arg0_23.contextData.normalList
	arg0_23.normalGroupList = arg0_23.contextData.normalGroupList
end

function var0_0.setGoodData(arg0_24, arg1_24, arg2_24, arg3_24, arg4_24)
	arg0_24.firstChargeIds = arg1_24
	arg0_24.chargedList = arg2_24
	arg0_24.normalList = arg3_24
	arg0_24.normalGroupList = arg4_24
end

function var0_0.updateData(arg0_25)
	arg0_25.player = getProxy(PlayerProxy):getData()

	arg0_25:updateDiamondGoodsVOList()
	arg0_25:sortDiamondGoodsVOList()
end

function var0_0.IsSupplyShop(arg0_26)
	return false
end

function var0_0.reUpdateAll(arg0_27)
	arg0_27:updateData()
	arg0_27:updateView()
end

function var0_0.ShowPanel(arg0_28, arg1_28)
	setActive(arg0_28._go, arg1_28)
end

return var0_0
