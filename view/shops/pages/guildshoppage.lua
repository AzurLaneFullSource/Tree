local var0 = class("GuildShopPage", import(".MilitaryShopPage"))

function var0.getUIName(arg0)
	return "GuildShop"
end

function var0.CanOpen(arg0)
	return true
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.refreshBtn, function()
		local var0 = arg0.shop:GetResetConsume()

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("guild_shop_refresh_all_tip", var0, i18n("word_guildgold")),
			onYes = function()
				if arg0.player:getResource(PlayerConst.ResGuildCoin) < var0 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

					return
				else
					arg0:emit(NewShopsMediator.REFRESH_GUILD_SHOP, true)
				end
			end
		})
	end, SFX_PANEL)

	arg0.purchaseWindow = GuildShopPurchasePanel.New(arg0._tf, arg0.event)
end

function var0.UpdateShop(arg0, ...)
	var0.super.UpdateShop(arg0, ...)

	if arg0.purchaseWindow:isShowing() then
		arg0.purchaseWindow:ExecuteAction("Hide")
	end
end

function var0.OnUpdatePlayer(arg0)
	local var0 = arg0.player

	arg0.exploitTF.text = var0:getResource(PlayerConst.ResGuildCoin)
end

function var0.OnSetUp(arg0)
	var0.super.OnSetUp(arg0)
	arg0:UpdateRefreshBtn()
end

function var0.UpdateRefreshBtn(arg0)
	setButtonEnabled(arg0.refreshBtn, arg0.shop:CanRefresh())
end

function var0.OnInitItem(arg0, arg1)
	local var0 = GuildGoodsCard.New(arg1)

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
	else
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_exchange",
			content = i18n("guild_shop_exchange_tip"),
			onYes = function()
				if not arg1.goods:CanPurchase() then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				arg0:emit(NewShopsMediator.ON_GUILD_SHOPPING, arg1.goods.id, arg1.goods:GetFirstDropId())
			end
		})
	end
end

function var0.OnTimeOut(arg0)
	arg0:emit(NewShopsMediator.REFRESH_GUILD_SHOP, false)
end

function var0.OnDestroy(arg0)
	var0.super.OnDestroy(arg0)
	arg0.purchaseWindow:Destroy()
end

return var0
