local var0 = class("MedalShopPage", import(".MilitaryShopPage"))

function var0.getUIName(arg0)
	return "MedalShop"
end

function var0.CanOpen(arg0)
	return true
end

function var0.OnLoaded(arg0)
	arg0.exploitTF = arg0._tf:Find("res_exploit/bg/Text"):GetComponent(typeof(Text))
	arg0.timerTF = arg0._tf:Find("time/day"):GetComponent(typeof(Text))

	setText(arg0._tf:Find("time"), i18n("title_limit_time"))
	setText(arg0._tf:Find("time/text"), i18n("shops_rest_day"))
	setText(arg0._tf:Find("time/text_day"), i18n("word_date"))
end

function var0.OnInit(arg0)
	arg0.purchaseWindow = MedalShopPurchasePanel.New(arg0._tf, arg0.event)
	arg0.multiWindow = MedalShopMultiWindow.New(arg0._tf, arg0.event)
end

function var0.UpdateShop(arg0, ...)
	var0.super.UpdateShop(arg0, ...)

	if arg0.purchaseWindow:isShowing() then
		arg0.purchaseWindow:ExecuteAction("Hide")
	end

	if arg0.multiWindow:isShowing() then
		arg0.multiWindow:ExecuteAction("Hide")
	end
end

function var0.OnUpdatePlayer(arg0)
	return
end

function var0.OnUpdateItems(arg0)
	local var0 = arg0.items

	arg0.exploitTF.text = var0[ITEM_ID_SILVER_HOOK] and var0[ITEM_ID_SILVER_HOOK].count or 0
end

function var0.OnInitItem(arg0, arg1)
	local var0 = MedalGoodsCard.New(arg1)

	onButton(arg0, var0._go, function()
		if not var0.goods:CanPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0:OnCardClick(var0)
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnCardClick(arg0, arg1)
	if arg1.goods:Selectable() then
		arg0.purchaseWindow:ExecuteAction("Show", {
			id = arg1.goods.id,
			count = arg1.goods:GetMaxCnt(),
			type = arg1.goods:getConfig("type"),
			price = arg1.goods:getConfig("price"),
			displays = arg1.goods:getConfig("goods"),
			num = arg1.goods:getConfig("num")
		})
	elseif arg1.goods:getConfig("goods_type") == 1 and arg1.goods:GetLimit() > 1 then
		arg0.multiWindow:ExecuteAction("Show", arg1.goods, function(arg0)
			if not arg1.goods:CanPurchaseCnt(arg0) then
				pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

				return
			end

			local var0 = {}
			local var1 = arg1.goods:getConfig("goods")[1]

			for iter0 = 1, arg0 do
				table.insert(var0, var1)
			end

			arg0:emit(NewShopsMediator.ON_MEDAL_SHOPPING, arg1.goods.id, var0)
		end)
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_exchange",
			content = i18n("guild_shop_exchange_tip"),
			onYes = function()
				if not arg1.goods:CanPurchase() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				arg0:emit(NewShopsMediator.ON_MEDAL_SHOPPING, arg1.goods.id, arg1.goods:GetFirstDropId())
			end
		})
	end
end

function var0.AddTimer(arg0)
	local var0 = arg0.shop.nextTime + 1

	arg0.timer = Timer.New(function()
		local var0 = var0 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0 <= 0 then
			arg0:RemoveTimer()
			arg0:OnTimeOut()
		elseif arg0.timerTF.text ~= tostring(1 + math.floor((var0 - 1) / 86400)) then
			arg0.timerTF.text = string.format("%02d", 1 + math.floor((var0 - 1) / 86400))
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.OnTimeOut(arg0)
	arg0:emit(NewShopsMediator.REFRESH_MEDAL_SHOP, false)
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)
	arg0.purchaseWindow:Destroy()
	arg0.multiWindow:Destroy()
end

return var0
