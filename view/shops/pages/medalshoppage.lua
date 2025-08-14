local var0_0 = class("MedalShopPage", import(".MilitaryShopPage"))

function var0_0.CanOpen(arg0_1)
	return true
end

function var0_0.CustomInit(arg0_2)
	arg0_2.purchaseWindow = MedalShopPurchasePanel.New(arg0_2._tf, arg0_2.parent.event)
	arg0_2.multiWindow = MedalShopMultiWindow.New(arg0_2._tf, arg0_2.parent.event)
end

function var0_0.UpdateShop(arg0_3, ...)
	var0_0.super.UpdateShop(arg0_3, ...)

	if arg0_3.purchaseWindow:isShowing() then
		arg0_3.purchaseWindow:ExecuteAction("Hide")
	end

	if arg0_3.multiWindow:isShowing() then
		arg0_3.multiWindow:ExecuteAction("Hide")
	end
end

function var0_0.OnUpdatePlayer(arg0_4)
	return
end

function var0_0.OnUpdateItems(arg0_5)
	arg0_5:RefreshResItemList()
end

function var0_0.GetResDataList(arg0_6)
	local var0_6 = {}
	local var1_6 = arg0_6.shop:GetResList()

	for iter0_6, iter1_6 in ipairs(var1_6) do
		local var2_6
		local var3_6 = arg0_6.items[ITEM_ID_SILVER_HOOK]
		local var4_6 = not var3_6 and 0 or var3_6.count

		table.insert(var0_6, {
			type = DROP_TYPE_ITEM,
			resID = iter1_6,
			cnt = var4_6
		})
	end

	return var0_6
end

function var0_0.RefreshUI(arg0_7)
	setActive(arg0_7.tipTextGo, true)
	setActive(arg0_7.helpBtn, false)
	setActive(arg0_7.resolveBtn, false)
	setActive(arg0_7.refreshBtn, false)
end

function var0_0.OnInitItem(arg0_8, arg1_8)
	local var0_8 = MedalGoodsCard.New(arg1_8)

	onButton(arg0_8, var0_8.go, function()
		if not var0_8.goods:CanPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0_8:OnCardClick(var0_8)
	end, SFX_PANEL)

	arg0_8.cards[arg1_8] = var0_8
end

function var0_0.OnCardClick(arg0_10, arg1_10)
	if arg1_10.goods:Selectable() then
		arg0_10.purchaseWindow:ExecuteAction("Show", {
			id = arg1_10.goods.id,
			count = arg1_10.goods:GetMaxCnt(),
			type = arg1_10.goods:getConfig("type"),
			price = arg1_10.goods:getConfig("price"),
			displays = arg1_10.goods:getConfig("goods"),
			num = arg1_10.goods:getConfig("num")
		})
	elseif arg1_10.goods:getConfig("goods_type") == 1 and arg1_10.goods:GetLimit() > 1 then
		arg0_10.multiWindow:ExecuteAction("Show", arg1_10.goods, function(arg0_11)
			if not arg1_10.goods:CanPurchaseCnt(arg0_11) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

				return
			end

			local var0_11 = {}
			local var1_11 = arg1_10.goods:getConfig("goods")[1]

			for iter0_11 = 1, arg0_11 do
				table.insert(var0_11, var1_11)
			end

			arg0_10:emit(NewShopMainMediator.ON_MEDAL_SHOPPING, arg1_10.goods.id, var0_11)
		end)
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_exchange",
			content = i18n("guild_shop_exchange_tip"),
			onYes = function()
				if not arg1_10.goods:CanPurchase() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				arg0_10:emit(NewShopMainMediator.ON_MEDAL_SHOPPING, arg1_10.goods.id, arg1_10.goods:GetFirstDropId())
			end
		})
	end
end

function var0_0.AddTimer(arg0_13)
	local var0_13 = arg0_13.shop.nextTime + 1

	arg0_13.timer = Timer.New(function()
		local var0_14 = var0_13 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_14 <= 0 then
			arg0_13:RemoveTimer()
			arg0_13:OnTimeOut()
		else
			local var1_14 = string.format("%02d", 1 + math.floor((var0_14 - 1) / 86400))

			setText(arg0_13.tipText, i18n("title_limit_time") .. i18n("shops_rest_day") .. var1_14 .. i18n("word_date"))
		end
	end, 1, -1)

	arg0_13.timer:Start()
	arg0_13.timer.func()
end

function var0_0.OnTimeOut(arg0_15)
	arg0_15:emit(NewShopMainMediator.REFRESH_MEDAL_SHOP, false)
end

function var0_0.OnDestroy(arg0_16)
	var0_0.super.OnDestroy(arg0_16)
	arg0_16.purchaseWindow:Destroy()
	arg0_16.multiWindow:Destroy()
end

return var0_0
