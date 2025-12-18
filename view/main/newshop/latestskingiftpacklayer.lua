local var0_0 = class("LatestSkinGiftPackLayer", import(".LatestSkinShopLayer"))

function var0_0.Overlay(arg0_1)
	pg.UIMgr.GetInstance():OverlayPanel(arg0_1.adapt, {
		pbList = {
			arg0_1.charContainer:Find("bg"),
			arg0_1.filterUI:Find("panel")
		}
	})
end

function var0_0.UnOverlay(arg0_2)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_2.adapt, arg0_2._tf)
end

function var0_0.GetAllCommodities(arg0_3)
	if arg0_3.contextData.commodityId then
		arg0_3.giftPackCommodity = arg0_3:GetCommodity(arg0_3.contextData.commodityId)

		local var0_3 = arg0_3.giftPackCommodity:GetSkinProbability()

		arg0_3.commodities = getProxy(ShipSkinProxy):GetProbabilitySkins(var0_3)
		arg0_3.skinProbabilitys = getProxy(ShipSkinProxy):GetSkinProbabilitys(var0_3)
	else
		arg0_3.giftPackCommodity = arg0_3.contextData.giftPackCommodity
		arg0_3.commodities = arg0_3.contextData.skinCommodities
		arg0_3.skinProbabilitys = arg0_3.contextData.skinProbabilitys
	end
end

function var0_0.GetCommodity(arg0_4, arg1_4)
	local var0_4 = Goods.Create({
		shop_id = arg1_4
	}, Goods.TYPE_CHARGE)
	local var1_4 = getProxy(ShopsProxy):getChargedList() or {}
	local var2_4 = ChargeConst.getBuyCount(var1_4, var0_4.id)

	var0_4:updateBuyCount(var2_4)

	return var0_4
end

function var0_0.SetGiftPackLayer(arg0_5)
	setActive(arg0_5.mainTitle, true)
	setActive(arg0_5.backBtn, true)
	setActive(arg0_5.homeBtn, true)
	setActive(arg0_5.giftPack, true)
	setActive(arg0_5.showOwnBtn, false)
	setActive(arg0_5.filterBtn, false)
	setActive(arg0_5.search, false)
	setActive(arg0_5.giftPackBtn, false)
	setActive(arg0_5.price, false)

	arg0_5.top:Find("title").anchoredPosition = Vector2(544.6, -208.3)
	arg0_5.top:Find("change_skin").anchoredPosition = Vector2(431.1, -337.8)
	arg0_5.bottom:Find("scroll").offsetMin = Vector2(378, 0)
	arg0_5.bottom:Find("scroll").offsetMax = Vector2(-19.6, 227.9)

	setText(arg0_5.giftPack:Find("panel/name"), arg0_5.giftPackCommodity:getConfig("name_display"))

	local var0_5 = arg0_5.giftPackCommodity:getConfig("time")

	setActive(arg0_5.giftPack:Find("panel/leftTimeText"), type(var0_5) == "table")

	if type(var0_5) == "table" then
		local var1_5 = var0_5[2]
		local var2_5 = pg.TimeMgr.GetInstance():Table2ServerTime({
			year = var1_5[1][1],
			month = var1_5[1][2],
			day = var1_5[1][3],
			hour = var1_5[2][1],
			min = var1_5[2][2],
			sec = var1_5[2][3]
		})

		arg0_5:StartTimer(function()
			local var0_6 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_6 = var2_5 - var0_6
			local var2_6 = math.floor(var1_6 / 86400)
			local var3_6 = math.floor(var1_6 % 86400 / 3600)
			local var4_6 = math.floor(var1_6 % 86400 % 3600 / 60)

			if var2_6 > 0 then
				setText(arg0_5.giftPack:Find("panel/leftTimeText"), i18n("shop_new_during_day", var2_6))
			elseif var3_6 > 0 then
				setText(arg0_5.giftPack:Find("panel/leftTimeText"), i18n("shop_new_during_hour", var3_6))
			else
				setText(arg0_5.giftPack:Find("panel/leftTimeText"), i18n("shop_new_during_minite", var4_6))
			end
		end)
	end

	GetImageSpriteFromAtlasAsync("chargeicon/" .. arg0_5.giftPackCommodity:getConfig("picture"), "", arg0_5.giftPack:Find("panel/icon"))
	setText(arg0_5.giftPack:Find("panel/tip1/Text"), arg0_5.giftPackCommodity:getConfig("first_text"))
	setText(arg0_5.giftPack:Find("panel/tip2/Text"), arg0_5.giftPackCommodity:getConfig("second_text"))

	local var3_5 = arg0_5.giftPackCommodity:getConfig("first_icon")
	local var4_5 = {}

	for iter0_5, iter1_5 in ipairs(var3_5) do
		table.insert(var4_5, Drop.Create(iter1_5))
	end

	while #var4_5 > 3 do
		table.remove(var4_5, #var4_5)
	end

	local var5_5 = UIItemList.New(arg0_5.giftPack:Find("panel/firstItems"), arg0_5.giftPack:Find("panel/firstItems/item"))

	var5_5:make(function(arg0_7, arg1_7, arg2_7)
		if arg0_7 == UIItemList.EventUpdate then
			local var0_7 = var4_5[arg1_7 + 1]

			updateDrop(arg2_7:Find("mask/item"), var0_7)
		end
	end)
	var5_5:align(#var4_5)

	local var6_5 = arg0_5.giftPackCommodity:GetDropList()

	while #var6_5 > 3 do
		table.remove(var6_5, #var6_5)
	end

	local var7_5 = UIItemList.New(arg0_5.giftPack:Find("panel/items"), arg0_5.giftPack:Find("panel/items/item"))

	var7_5:make(function(arg0_8, arg1_8, arg2_8)
		if arg0_8 == UIItemList.EventUpdate then
			local var0_8 = var6_5[arg1_8 + 1]

			updateDrop(arg2_8:Find("mask/item"), var0_8)
		end
	end)
	var7_5:align(#var6_5)
	setText(arg0_5.giftPack:Find("price/consume/Text"), arg0_5.giftPackCommodity:GetLimitDesc())
	setText(arg0_5.giftPack:Find("price/btns/goumai_button/Text"), GetMoneySymbol() .. arg0_5.giftPackCommodity:getConfig("money"))

	if PLATFORM_CODE == PLATFORM_CHT and arg0_5.giftPackCommodity:IsLocalPrice() then
		setText(arg0_5.giftPack:Find("price/btns/goumai_button/Text"), arg0_5.giftPackCommodity:getConfig("money"))
	end

	setGray(arg0_5.giftPack:Find("price/btns/yigoumai_button"), true, true)

	local var8_5 = arg0_5.giftPackCommodity:getLimitCount()
	local var9_5 = arg0_5.giftPackCommodity.buyCount or 0

	setActive(arg0_5.giftPack:Find("price/btns/goumai_button"), var9_5 < var8_5)
	setActive(arg0_5.giftPack:Find("price/btns/yigoumai_button"), var8_5 <= var9_5)
	onButton(arg0_5, arg0_5.giftPack:Find("price/btns/goumai_button"), function()
		arg0_5:confirm(arg0_5.giftPackCommodity)
	end, SFX_PANEL)
end

function var0_0.FlushGifgPackBtn(arg0_10, arg1_10)
	setActive(arg0_10.giftPackBtn, false)
end

function var0_0.OnUpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.cards[arg2_11]

	if not var0_11 then
		arg0_11:OnInitItem(arg2_11)

		var0_11 = arg0_11.cards[arg2_11]
	end

	local var1_11 = arg0_11.displays[arg1_11 + 1]

	if not var1_11 then
		return
	end

	local var2_11 = arg0_11.selectedId == var1_11.id
	local var3_11 = table.contains(arg0_11.returnSkins, var1_11.id)

	var0_11:Update(var1_11, var2_11, var3_11, arg0_11.skinProbabilitys[var1_11:getSkinId()])

	if arg0_11.triggerFirstCard and arg1_11 == 0 then
		arg0_11.triggerFirstCard = false

		triggerButton(var0_11._go)
	end
end

function var0_0.confirm(arg0_12, arg1_12)
	if not arg1_12 then
		return
	end

	arg1_12 = Clone(arg1_12)

	if arg1_12:isChargeType() then
		local var0_12 = false
		local var1_12 = var0_12 and arg1_12:firstPayDouble()
		local var2_12 = var1_12 and 4 or arg1_12:getConfig("tag")

		if arg1_12:isMonthCard() or arg1_12:isGiftBox() or arg1_12:isItemBox() or arg1_12:isPassItem() then
			local var3_12 = arg1_12:GetExtraServiceItem()
			local var4_12 = arg1_12:GetExtraDrop()
			local var5_12 = arg1_12:GetBonusItem()
			local var6_12
			local var7_12

			if arg1_12:isPassItem() then
				var6_12 = i18n("battlepass_pay_tip")
			elseif arg1_12:isMonthCard() then
				var6_12 = i18n("charge_title_getitem_month")
				var7_12 = i18n("charge_title_getitem_soon")
			else
				var6_12 = i18n("charge_title_getitem")
			end

			local var8_12 = {
				isChargeType = true,
				commodity = arg1_12,
				infoTip = arg1_12:GetInfoTip(),
				icon = "chargeicon/" .. arg1_12:getConfig("picture"),
				name = arg1_12:getConfig("name_display"),
				tipExtra = var6_12,
				extraItems = var3_12,
				price = arg1_12:getConfig("money"),
				isLocalPrice = arg1_12:IsLocalPrice(),
				tagType = var2_12,
				isMonthCard = arg1_12:isMonthCard(),
				tipBonus = var7_12,
				bonusItem = var5_12,
				extraDrop = var4_12,
				descExtra = arg1_12:getConfig("descrip_extra"),
				limitArgs = arg1_12:getConfig("limit_args"),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_12:emit(LatestSkinGiftPackMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_12:emit(LatestSkinGiftPackMediator.CHARGE, arg1_12.id)
					end
				end
			}

			arg0_12:emit(LatestSkinGiftPackMediator.OPEN_CHARGE_ITEM_PANEL, var8_12)
		elseif arg1_12:isGem() then
			local var9_12 = arg1_12:getConfig("money")
			local var10_12 = arg1_12:getConfig("gem")

			if var1_12 then
				var10_12 = var10_12 + arg1_12:getConfig("gem")
			else
				var10_12 = var10_12 + arg1_12:getConfig("extra_gem")
			end

			local var11_12 = {
				isChargeType = true,
				commodity = arg1_12,
				icon = "chargeicon/" .. arg1_12:getConfig("picture"),
				name = arg1_12:getConfig("name_display"),
				price = arg1_12:getConfig("money"),
				isLocalPrice = arg1_12:IsLocalPrice(),
				tagType = var2_12,
				normalTip = i18n("charge_start_tip", var9_12, var10_12),
				onYes = function()
					if ChargeConst.isNeedSetBirth() then
						arg0_12:emit(LatestSkinGiftPackMediator.OPEN_CHARGE_BIRTHDAY)
					else
						arg0_12:emit(LatestSkinGiftPackMediator.CHARGE, arg1_12.id)
					end
				end
			}

			arg0_12:emit(LatestSkinGiftPackMediator.OPEN_CHARGE_ITEM_BOX, var11_12)
		end
	else
		local var12_12 = {}
		local var13_12 = arg1_12:getConfig("effect_args")
		local var14_12 = Item.getConfigData(var13_12[1])
		local var15_12 = var14_12.display_icon

		if type(var15_12) == "table" then
			for iter0_12, iter1_12 in ipairs(var15_12) do
				table.insert(var12_12, Drop.New({
					type = iter1_12[1],
					id = iter1_12[2],
					count = iter1_12[3]
				}))
			end
		end

		local var16_12 = {
			isMonthCard = false,
			isChargeType = false,
			isLocalPrice = false,
			commodity = arg1_12,
			icon = var14_12.icon,
			name = var14_12.name,
			tipExtra = i18n("charge_title_getitem"),
			extraItems = var12_12,
			price = arg1_12:getConfig("resource_num"),
			tagType = arg1_12:getConfig("tag"),
			onYes = function()
				pg.MsgboxMgr.GetInstance():ShowMsgBox({
					content = i18n("charge_scene_buy_confirm", arg1_12:getConfig("resource_num"), var14_12.name),
					onYes = function()
						arg0_12:emit(LatestSkinGiftPackMediator.BUY_ITEM, arg1_12.id, 1)
					end
				})
			end
		}

		arg0_12:emit(LatestSkinGiftPackMediator.OPEN_CHARGE_ITEM_PANEL, var16_12)
	end
end

function var0_0.StartTimer(arg0_17, arg1_17)
	arg0_17.cardTimer = Timer.New(function()
		arg1_17()
	end, 1, -1)

	arg1_17()
	arg0_17.cardTimer:Start()
end

function var0_0.RemoveAllTimer(arg0_19)
	if arg0_19.cardTimer then
		arg0_19.cardTimer:Stop()

		arg0_19.cardTimer = nil
	end
end

function var0_0.willExit(arg0_20)
	var0_0.super.willExit(arg0_20)
	arg0_20:RemoveAllTimer()
end

return var0_0
