local var0 = class("ChargeDiamondShopView", import("...base.BaseSubView"))

var0.MonthCardID = 1

function var0.getUIName(arg0)
	return "ChargeDiamondShopUI"
end

function var0.OnInit(arg0)
	arg0:initData()
	arg0:initUI()
	arg0:Show()
end

function var0.OnDestroy(arg0)
	return
end

function var0.initData(arg0)
	arg0.isNeedHideMonthCard = (PLATFORM_CODE == PLATFORM_JP or PLATFORM_CODE == PLATFORM_US) and pg.SdkMgr.GetInstance():CheckAudit()
	arg0.diamondGoodsVOList = {}
	arg0.diamondGoodsVOListForShow = {}
	arg0.player = getProxy(PlayerProxy):getData()

	arg0:updateData()
end

function var0.initUI(arg0)
	arg0.itemTpl = arg0:findTF("ItemTpl")

	local var0 = arg0:findTF("content")

	arg0.monthCardTF = arg0:findTF("ItemMonth", var0)
	arg0.itemContainerTF = arg0:findTF("ItemList", var0)
	arg0.uiItemList = arg0:initUIItemList()

	arg0:updateView()
end

function var0.initUIItemList(arg0)
	local var0 = UIItemList.New(arg0.itemContainerTF, arg0.itemTpl)

	var0:make(function(arg0, arg1, arg2)
		if arg0 == UIItemList.EventUpdate then
			arg1 = arg1 + 1

			local var0 = ChargeDiamondCard.New(go(arg2), arg0.monthCardTF, arg0)
			local var1 = arg0.diamondGoodsVOListForShow[arg1]

			var0:update(var1, arg0.player, arg0.firstChargeIds)
			onButton(arg0, var0.tr, function()
				arg0:confirm(var0.goods)
			end, SFX_PANEL)
		end
	end)

	arg0.uiItemList = var0

	return var0
end

function var0.updateUIItemList(arg0)
	arg0.uiItemList:align(#arg0.diamondGoodsVOListForShow)
end

function var0.updateView(arg0)
	setActive(arg0.monthCardTF, not arg0.isNeedHideMonthCard)
	arg0:updateUIItemList()
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

function var0.updateDiamondGoodsVOList(arg0)
	arg0.diamondGoodsVOList = {}

	local var0 = pg.pay_data_display

	for iter0, iter1 in pairs(var0.all) do
		local var1 = var0[iter1].extra_service

		if arg0.isNeedHideMonthCard and iter1 == var0.MonthCardID then
			-- block empty
		elseif pg.SdkMgr.GetInstance():IgnorePlatform(var0[iter1].ignorePlatform) then
			-- block empty
		elseif var1 == Goods.MONTH_CARD or var1 == Goods.GEM or var1 == Goods.GIFT_BOX then
			local var2 = Goods.Create({
				shop_id = iter1
			}, Goods.TYPE_CHARGE)

			table.insert(arg0.diamondGoodsVOList, var2)
		end
	end
end

function var0.sortDiamondGoodsVOList(arg0)
	arg0.diamondGoodsVOListForShow = {}

	for iter0, iter1 in ipairs(arg0.diamondGoodsVOList) do
		local var0 = ChargeConst.getBuyCount(arg0.chargedList, iter1.id)

		iter1:updateBuyCount(var0)

		if iter1:canPurchase() and iter1:inTime() then
			table.insert(arg0.diamondGoodsVOListForShow, iter1)
		end
	end

	table.sort(arg0.diamondGoodsVOListForShow, function(arg0, arg1)
		local var0 = not table.contains(arg0.firstChargeIds, arg0.id) and arg0:firstPayDouble() and 1 or 0
		local var1 = not table.contains(arg0.firstChargeIds, arg1.id) and arg1:firstPayDouble() and 1 or 0
		local var2 = 0
		local var3 = 0

		if arg0:isFree() then
			return true
		elseif arg1:isFree() then
			return false
		end

		if arg0:isChargeType() and arg0:isMonthCard() then
			local var4 = arg0.player:getCardById(VipCard.MONTH)

			if var4 then
				local var5 = var4:getLeftDate()
				local var6 = pg.TimeMgr.GetInstance():GetServerTime()

				var2 = math.floor((var5 - var6) / 86400) > (arg0:getConfig("limit_arg") or 0) and 1 or 0
			end
		end

		if arg1:isChargeType() and arg1:isMonthCard() then
			local var7 = arg0.player:getCardById(VipCard.MONTH)

			if var7 then
				local var8 = var7:getLeftDate()
				local var9 = pg.TimeMgr.GetInstance():GetServerTime()

				var3 = math.floor((var8 - var9) / 86400) > (arg1:getConfig("limit_arg") or 0) and 1 or 0
			end
		end

		if var2 ~= var3 then
			return var2 < var3
		end

		local var10 = arg0:getConfig("tag") == 2 and 1 or 0
		local var11 = arg1:getConfig("tag") == 2 and 1 or 0

		if var0 == var1 and var10 == var11 then
			return arg0.id < arg1.id
		else
			return var1 < var0 or var0 == var1 and var11 < var10
		end
	end)
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

	arg0:updateDiamondGoodsVOList()
	arg0:sortDiamondGoodsVOList()
end

function var0.reUpdateAll(arg0)
	arg0:updateData()
	arg0:updateView()
end

return var0
