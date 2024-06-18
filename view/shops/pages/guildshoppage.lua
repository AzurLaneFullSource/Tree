local var0_0 = class("GuildShopPage", import(".MilitaryShopPage"))

function var0_0.getUIName(arg0_1)
	return "GuildShop"
end

function var0_0.CanOpen(arg0_2)
	return true
end

function var0_0.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.refreshBtn, function()
		local var0_4 = arg0_3.shop:GetResetConsume()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_shop_refresh_all_tip", var0_4, i18n("word_guildgold")),
			onYes = function()
				if arg0_3.player:getResource(PlayerConst.ResGuildCoin) < var0_4 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

					return
				else
					arg0_3:emit(NewShopsMediator.REFRESH_GUILD_SHOP, true)
				end
			end
		})
	end, SFX_PANEL)

	arg0_3.purchaseWindow = GuildShopPurchasePanel.New(arg0_3._tf, arg0_3.event)
end

function var0_0.UpdateShop(arg0_6, ...)
	var0_0.super.UpdateShop(arg0_6, ...)

	if arg0_6.purchaseWindow:isShowing() then
		arg0_6.purchaseWindow:ExecuteAction("Hide")
	end
end

function var0_0.OnUpdatePlayer(arg0_7)
	local var0_7 = arg0_7.player

	arg0_7.exploitTF.text = var0_7:getResource(PlayerConst.ResGuildCoin)
end

function var0_0.OnSetUp(arg0_8)
	var0_0.super.OnSetUp(arg0_8)
	arg0_8:UpdateRefreshBtn()
end

function var0_0.UpdateRefreshBtn(arg0_9)
	setButtonEnabled(arg0_9.refreshBtn, arg0_9.shop:CanRefresh())
end

function var0_0.OnInitItem(arg0_10, arg1_10)
	local var0_10 = GuildGoodsCard.New(arg1_10)

	onButton(arg0_10, var0_10._go, function()
		if not var0_10.goods:CanPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0_10:OnCardClick(var0_10)
	end, SFX_PANEL)

	arg0_10.cards[arg1_10] = var0_10
end

function var0_0.OnCardClick(arg0_12, arg1_12)
	if arg1_12.goods:Selectable() then
		arg0_12.purchaseWindow:ExecuteAction("Show", {
			id = arg1_12.goods.id,
			count = arg1_12.goods:GetMaxCnt(),
			type = arg1_12.goods:getConfig("type"),
			price = arg1_12.goods:getConfig("price"),
			displays = arg1_12.goods:getConfig("goods"),
			num = arg1_12.goods:getConfig("num")
		})
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_exchange",
			content = i18n("guild_shop_exchange_tip"),
			onYes = function()
				if not arg1_12.goods:CanPurchase() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				arg0_12:emit(NewShopsMediator.ON_GUILD_SHOPPING, arg1_12.goods.id, arg1_12.goods:GetFirstDropId())
			end
		})
	end
end

function var0_0.OnTimeOut(arg0_14)
	arg0_14:emit(NewShopsMediator.REFRESH_GUILD_SHOP, false)
end

function var0_0.OnDestroy(arg0_15)
	var0_0.super.OnDestroy(arg0_15)
	arg0_15.purchaseWindow:Destroy()
end

return var0_0
