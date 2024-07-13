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
			local var2_11 = underscore.map(arg1_11:getConfig("extra_service_item"), function(arg0_12)
				return Drop.Create(arg0_12)
			end)
			local var3_11

			if arg1_11:isPassItem() then
				local var4_11 = arg1_11:getConfig("sub_display")
				local var5_11 = var4_11[1]
				local var6_11 = pg.battlepass_event_pt[var5_11].pt

				var3_11 = Drop.New({
					type = DROP_TYPE_VITEM,
					id = var6_11,
					count = var4_11[2]
				})
				var2_11 = PlayerConst.MergePassItemDrop(underscore.map(pg.battlepass_event_pt[var5_11].award_pay, function(arg0_13)
					return Drop.Create(pg.battlepass_event_award[arg0_13].drop_client)
				end))
			end

			local var7_11 = arg1_11:getConfig("gem") + arg1_11:getConfig("extra_gem")
			local var8_11

			if arg1_11:isMonthCard() then
				var8_11 = Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResDiamond,
					count = var7_11
				})
			elseif var7_11 > 0 then
				table.insert(var2_11, Drop.New({
					type = DROP_TYPE_RESOURCE,
					id = PlayerConst.ResDiamond,
					count = var7_11
				}))
			end

			local var9_11
			local var10_11

			if arg1_11:isPassItem() then
				var9_11 = i18n("battlepass_pay_tip")
			elseif arg1_11:isMonthCard() then
				var9_11 = i18n("charge_title_getitem_month")
				var10_11 = i18n("charge_title_getitem_soon")
			else
				var9_11 = i18n("charge_title_getitem")
			end

			local var11_11 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_11:getConfig("picture"),
				name = arg1_11:getConfig("name_display"),
				tipExtra = var9_11,
				extraItems = var2_11,
				price = arg1_11:getConfig("money"),
				isLocalPrice = arg1_11:IsLocalPrice(),
				tagType = var1_11,
				isMonthCard = arg1_11:isMonthCard(),
				tipBonus = var10_11,
				bonusItem = var8_11,
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

			arg0_11:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var11_11)
		elseif arg1_11:isGem() then
			local var12_11 = arg1_11:getConfig("money")
			local var13_11 = arg1_11:getConfig("gem")

			if var0_11 then
				var13_11 = var13_11 + arg1_11:getConfig("gem")
			else
				var13_11 = var13_11 + arg1_11:getConfig("extra_gem")
			end

			local var14_11 = {
				isChargeType = true,
				icon = "chargeicon/" .. arg1_11:getConfig("picture"),
				name = arg1_11:getConfig("name_display"),
				price = arg1_11:getConfig("money"),
				isLocalPrice = arg1_11:IsLocalPrice(),
				tagType = var1_11,
				normalTip = i18n("charge_start_tip", var12_11, var13_11),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_11:emit(ChargeMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_11:emit(ChargeMediator.CHARGE, arg1_11.id)
					end
				end
			}

			arg0_11:emit(ChargeMediator.OPEN_CHARGE_ITEM_BOX, var14_11)
		end
	else
		local var15_11 = {}
		local var16_11 = arg1_11:getConfig("effect_args")
		local var17_11 = Item.getConfigData(var16_11[1])
		local var18_11 = var17_11.display_icon

		if type(var18_11) == "table" then
			for iter0_11, iter1_11 in ipairs(var18_11) do
				table.insert(var15_11, {
					type = iter1_11[1],
					id = iter1_11[2],
					count = iter1_11[3]
				})
			end
		end

		local var19_11 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			icon = var17_11.icon,
			name = var17_11.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var15_11,
			price = arg1_11:getConfig("resource_num"),
			tagType = arg1_11:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_11:getConfig("resource_num"), var17_11.name),
					onYes = function()
						arg0_11:emit(ChargeMediator.BUY_ITEM, arg1_11.id, 1)
					end
				})
			end
		}

		arg0_11:emit(ChargeMediator.OPEN_CHARGE_ITEM_PANEL, var19_11)
	end
end

function var0_0.updateDiamondGoodsVOList(arg0_18)
	arg0_18.diamondGoodsVOList = {}

	local var0_18 = pg.pay_data_display

	for iter0_18, iter1_18 in pairs(var0_18.all) do
		local var1_18 = var0_18[iter1_18].extra_service

		if arg0_18.isNeedHideMonthCard and iter1_18 == var0_0.MonthCardID then
			-- block empty
		elseif pg.SdkMgr.GetInstance():IgnorePlatform(var0_18[iter1_18].ignorePlatform) then
			-- block empty
		elseif var1_18 == Goods.MONTH_CARD or var1_18 == Goods.GEM or var1_18 == Goods.GIFT_BOX then
			local var2_18 = Goods.Create({
				shop_id = iter1_18
			}, Goods.TYPE_CHARGE)

			table.insert(arg0_18.diamondGoodsVOList, var2_18)
		end
	end
end

function var0_0.sortDiamondGoodsVOList(arg0_19)
	arg0_19.diamondGoodsVOListForShow = {}

	for iter0_19, iter1_19 in ipairs(arg0_19.diamondGoodsVOList) do
		local var0_19 = ChargeConst.getBuyCount(arg0_19.chargedList, iter1_19.id)

		iter1_19:updateBuyCount(var0_19)

		if iter1_19:canPurchase() and iter1_19:inTime() then
			table.insert(arg0_19.diamondGoodsVOListForShow, iter1_19)
		end
	end

	table.sort(arg0_19.diamondGoodsVOListForShow, function(arg0_20, arg1_20)
		local var0_20 = not table.contains(arg0_19.firstChargeIds, arg0_20.id) and arg0_20:firstPayDouble() and 1 or 0
		local var1_20 = not table.contains(arg0_19.firstChargeIds, arg1_20.id) and arg1_20:firstPayDouble() and 1 or 0
		local var2_20 = 0
		local var3_20 = 0

		if arg0_20:isFree() then
			return true
		elseif arg1_20:isFree() then
			return false
		end

		if arg0_20:isChargeType() and arg0_20:isMonthCard() then
			local var4_20 = arg0_19.player:getCardById(VipCard.MONTH)

			if var4_20 then
				local var5_20 = var4_20:getLeftDate()
				local var6_20 = pg.TimeMgr.GetInstance():GetServerTime()

				var2_20 = math.floor((var5_20 - var6_20) / 86400) > (arg0_20:getConfig("limit_arg") or 0) and 1 or 0
			end
		end

		if arg1_20:isChargeType() and arg1_20:isMonthCard() then
			local var7_20 = arg0_19.player:getCardById(VipCard.MONTH)

			if var7_20 then
				local var8_20 = var7_20:getLeftDate()
				local var9_20 = pg.TimeMgr.GetInstance():GetServerTime()

				var3_20 = math.floor((var8_20 - var9_20) / 86400) > (arg1_20:getConfig("limit_arg") or 0) and 1 or 0
			end
		end

		if var2_20 ~= var3_20 then
			return var2_20 < var3_20
		end

		local var10_20 = arg0_20:getConfig("tag") == 2 and 1 or 0
		local var11_20 = arg1_20:getConfig("tag") == 2 and 1 or 0

		if var0_20 == var1_20 and var10_20 == var11_20 then
			return arg0_20.id < arg1_20.id
		else
			return var1_20 < var0_20 or var0_20 == var1_20 and var11_20 < var10_20
		end
	end)
end

function var0_0.updateGoodsData(arg0_21)
	arg0_21.firstChargeIds = arg0_21.contextData.firstChargeIds
	arg0_21.chargedList = arg0_21.contextData.chargedList
	arg0_21.normalList = arg0_21.contextData.normalList
	arg0_21.normalGroupList = arg0_21.contextData.normalGroupList
end

function var0_0.setGoodData(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
	arg0_22.firstChargeIds = arg1_22
	arg0_22.chargedList = arg2_22
	arg0_22.normalList = arg3_22
	arg0_22.normalGroupList = arg4_22
end

function var0_0.updateData(arg0_23)
	arg0_23.player = getProxy(PlayerProxy):getData()

	arg0_23:updateDiamondGoodsVOList()
	arg0_23:sortDiamondGoodsVOList()
end

function var0_0.reUpdateAll(arg0_24)
	arg0_24:updateData()
	arg0_24:updateView()
end

return var0_0
