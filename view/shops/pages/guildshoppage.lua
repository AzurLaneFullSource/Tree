local var0_0 = class("GuildShopPage", import(".MilitaryShopPage"))

function var0_0.CanOpen(arg0_1)
	return true
end

function var0_0.CustomInit(arg0_2)
	arg0_2.purchaseWindow = GuildShopPurchasePanel.New(arg0_2._tf, arg0_2.parent.event)
end

function var0_0.UpdateShop(arg0_3, ...)
	var0_0.super.UpdateShop(arg0_3, ...)

	if arg0_3.purchaseWindow:isShowing() then
		arg0_3.purchaseWindow:ExecuteAction("Hide")
	end
end

function var0_0.OnUpdatePlayer(arg0_4)
	arg0_4:RefreshResItemList()
end

function var0_0.GetResDataList(arg0_5)
	local var0_5 = {}
	local var1_5 = arg0_5.shop:GetResList()

	for iter0_5, iter1_5 in ipairs(var1_5) do
		local var2_5 = arg0_5.player:getResource(PlayerConst.ResGuildCoin)

		table.insert(var0_5, {
			type = DROP_TYPE_RESOURCE,
			resID = iter1_5,
			cnt = var2_5
		})
	end

	return var0_5
end

function var0_0.OnSetUp(arg0_6)
	var0_0.super.OnSetUp(arg0_6)
	arg0_6:UpdateRefreshBtn()
end

function var0_0.UpdateRefreshBtn(arg0_7)
	setButtonEnabled(arg0_7.refreshBtn, arg0_7.shop:CanRefresh())
end

function var0_0.RefreshUI(arg0_8)
	setActive(arg0_8.tipTextGo, false)
	setActive(arg0_8.helpBtn, false)
	setActive(arg0_8.resolveBtn, false)
	setActive(arg0_8.refreshBtn, true)
	onButton(arg0_8, arg0_8.refreshBtn, function()
		local var0_9 = arg0_8.shop:GetResetConsume()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_shop_refresh_all_tip", var0_9, i18n("word_guildgold")),
			onYes = function()
				if arg0_8.player:getResource(PlayerConst.ResGuildCoin) < var0_9 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

					return
				else
					arg0_8:emit(NewShopMainMediator.REFRESH_GUILD_SHOP, true)
				end
			end
		})
	end, SFX_PANEL)
	setButtonEnabled(arg0_8.refreshBtn, arg0_8.shop:CanRefresh())
end

function var0_0.OnInitItem(arg0_11, arg1_11)
	local var0_11 = GuildGoodsCard.New(arg1_11)

	onButton(arg0_11, var0_11.go, function()
		if not var0_11.goodsVO:CanPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0_11:OnCardClick(var0_11)
	end, SFX_PANEL)

	arg0_11.cards[arg1_11] = var0_11
end

function var0_0.OnCardClick(arg0_13, arg1_13)
	if arg1_13.goodsVO:Selectable() then
		arg0_13.purchaseWindow:ExecuteAction("Show", {
			id = arg1_13.goodsVO.id,
			count = arg1_13.goodsVO:GetMaxCnt(),
			type = arg1_13.goodsVO:getConfig("type"),
			price = arg1_13.goodsVO:getConfig("price"),
			displays = arg1_13.goodsVO:getConfig("goods"),
			num = arg1_13.goodsVO:getConfig("num")
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_exchange",
			content = i18n("guild_shop_exchange_tip"),
			onYes = function()
				if not arg1_13.goodsVO:CanPurchase() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				arg0_13:emit(NewShopMainMediator.ON_GUILD_SHOPPING, arg1_13.goodsVO.id, arg1_13.goodsVO:GetFirstDropId())
			end
		})
	end
end

function var0_0.OnTimeOut(arg0_15)
	arg0_15:emit(NewShopMainMediator.REFRESH_GUILD_SHOP, false)
end

function var0_0.OnDestroy(arg0_16)
	var0_0.super.OnDestroy(arg0_16)

	if arg0_16.purchaseWindow then
		arg0_16.purchaseWindow:Destroy()

		arg0_16.purchaseWindow = nil
	end
end

return var0_0
