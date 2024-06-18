local var0_0 = class("MedalShopPage", import(".MilitaryShopPage"))

function var0_0.getUIName(arg0_1)
	return "MedalShop"
end

function var0_0.CanOpen(arg0_2)
	return true
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.exploitTF = arg0_3._tf:Find("res_exploit/bg/Text"):GetComponent(typeof(Text))
	arg0_3.timerTF = arg0_3._tf:Find("time/day"):GetComponent(typeof(Text))

	setText(arg0_3._tf:Find("time"), i18n("title_limit_time"))
	setText(arg0_3._tf:Find("time/text"), i18n("shops_rest_day"))
	setText(arg0_3._tf:Find("time/text_day"), i18n("word_date"))
end

function var0_0.OnInit(arg0_4)
	arg0_4.purchaseWindow = MedalShopPurchasePanel.New(arg0_4._tf, arg0_4.event)
	arg0_4.multiWindow = MedalShopMultiWindow.New(arg0_4._tf, arg0_4.event)
end

function var0_0.UpdateShop(arg0_5, ...)
	var0_0.super.UpdateShop(arg0_5, ...)

	if arg0_5.purchaseWindow:isShowing() then
		arg0_5.purchaseWindow:ExecuteAction("Hide")
	end

	if arg0_5.multiWindow:isShowing() then
		arg0_5.multiWindow:ExecuteAction("Hide")
	end
end

function var0_0.OnUpdatePlayer(arg0_6)
	return
end

function var0_0.OnUpdateItems(arg0_7)
	local var0_7 = arg0_7.items

	arg0_7.exploitTF.text = var0_7[ITEM_ID_SILVER_HOOK] and var0_7[ITEM_ID_SILVER_HOOK].count or 0
end

function var0_0.OnInitItem(arg0_8, arg1_8)
	local var0_8 = MedalGoodsCard.New(arg1_8)

	onButton(arg0_8, var0_8._go, function()
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

			arg0_10:emit(NewShopsMediator.ON_MEDAL_SHOPPING, arg1_10.goods.id, var0_11)
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

				arg0_10:emit(NewShopsMediator.ON_MEDAL_SHOPPING, arg1_10.goods.id, arg1_10.goods:GetFirstDropId())
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
		elseif arg0_13.timerTF.text ~= tostring(1 + math.floor((var0_14 - 1) / 86400)) then
			arg0_13.timerTF.text = string.format("%02d", 1 + math.floor((var0_14 - 1) / 86400))
		end
	end, 1, -1)

	arg0_13.timer:Start()
	arg0_13.timer.func()
end

function var0_0.OnTimeOut(arg0_15)
	arg0_15:emit(NewShopsMediator.REFRESH_MEDAL_SHOP, false)
end

function var0_0.OnDestroy(arg0_16)
	var0_0.super.OnDestroy(arg0_16)
	arg0_16.purchaseWindow:Destroy()
	arg0_16.multiWindow:Destroy()
end

return var0_0
