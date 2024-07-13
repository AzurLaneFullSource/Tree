local var0_0 = class("MiniGameShopPage", import(".BaseShopPage"))

function var0_0.getUIName(arg0_1)
	return "MiniGameShop"
end

function var0_0.CanOpen(arg0_2, arg1_2, arg2_2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2_2.level, "GameHallMediator")
end

function var0_0.OnLoaded(arg0_3)
	arg0_3.mothMaxTF = arg0_3:findTF("mothMax")

	local var0_3 = pg.gameset.game_ticket_month.key_value
	local var1_3 = getProxy(GameRoomProxy):getMonthlyTicket()

	setText(arg0_3.mothMaxTF, i18n("game_ticket_current_month") .. var1_3 .. "/" .. var0_3)
end

function var0_0.OnInit(arg0_4)
	arg0_4.purchaseWindow = MiniGameShopPurchasePanel.New(arg0_4._tf, arg0_4.event)
	arg0_4.multiWindow = MiniGameShopMultiWindow.New(arg0_4._tf, arg0_4.event)
	arg0_4.ticketTf = findTF(arg0_4._tf, "res/Text")

	local var0_4 = getProxy(GameRoomProxy):getTicket()

	setText(arg0_4.ticketTf, var0_4)
end

function var0_0.OnSetUp(arg0_5)
	arg0_5:RemoveTimer()
	arg0_5:AddTimer()
end

function var0_0.OnUpdateAll(arg0_6)
	arg0_6:InitCommodities()
	arg0_6:OnSetUp()

	if arg0_6.purchaseWindow:isShowing() then
		arg0_6.purchaseWindow:ExecuteAction("Hide")
	end

	if arg0_6.multiWindow:isShowing() then
		arg0_6.multiWindow:ExecuteAction("Hide")
	end

	local var0_6 = getProxy(GameRoomProxy):getTicket()

	setText(arg0_6.ticketTf, var0_6)
end

function var0_0.OnUpdateCommodity(arg0_7, arg1_7)
	local var0_7

	for iter0_7, iter1_7 in pairs(arg0_7.cards) do
		if iter1_7.goodsVO.id == arg1_7.id then
			var0_7 = iter1_7

			break
		end
	end

	if var0_7 then
		var0_7:update(arg1_7)
	end
end

function var0_0.OnInitItem(arg0_8, arg1_8)
	local var0_8 = MiniGameGoodsCard.New(arg1_8)

	onButton(arg0_8, var0_8.go, function()
		if not var0_8.goodsVO:CanPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0_8:OnClickCommodity(var0_8.goodsVO)
	end, SFX_PANEL)

	arg0_8.cards[arg1_8] = var0_8
end

function var0_0.OnUpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.cards[arg2_10]

	if not var0_10 then
		arg0_10:OnInitItem(arg2_10)

		var0_10 = arg0_10.cards[arg2_10]
	end

	local var1_10 = arg0_10.displays[arg1_10 + 1]

	var0_10:update(var1_10)
end

function var0_0.OnClickCommodity(arg0_11, arg1_11)
	local var0_11 = arg1_11

	if var0_11:Selectable() then
		arg0_11.purchaseWindow:ExecuteAction("Show", {
			id = var0_11.id,
			count = var0_11:GetMaxCnt(),
			type = var0_11:getConfig("type"),
			price = var0_11:getConfig("price"),
			displays = var0_11:getConfig("goods"),
			num = var0_11:getConfig("num"),
			confirm = function(arg0_12, arg1_12)
				arg0_11:emit(NewShopsMediator.ON_MINI_GAME_SHOP_BUY, {
					id = arg0_12,
					list = arg1_12
				})
			end
		})
	elseif var0_11:getConfig("goods_type") == 1 then
		if var0_11:GetLimit() > 1 then
			arg0_11.multiWindow:ExecuteAction("Show", var0_11, function(arg0_13)
				if not var0_11:CanPurchaseCnt(arg0_13) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				local var0_13 = {}
				local var1_13 = var0_11:getConfig("goods")[1]

				table.insert(var0_13, {
					num = arg0_13,
					id = var1_13
				})
				arg0_11:emit(NewShopsMediator.ON_MINI_GAME_SHOP_BUY, {
					id = var0_11.id,
					list = var0_13
				})
			end)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_exchange",
				content = i18n("guild_shop_exchange_tip"),
				onYes = function()
					if not var0_11:CanPurchase() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

						return
					end

					local var0_14 = {}
					local var1_14 = var0_11:GetFirstDropId()

					for iter0_14 = 1, #var1_14 do
						table.insert(var0_14, {
							num = 1,
							id = var1_14[iter0_14]
						})
					end

					arg0_11:emit(NewShopsMediator.ON_MINI_GAME_SHOP_BUY, {
						id = var0_11.id,
						list = var0_14
					})
				end
			})
		end
	end
end

function var0_0.AddTimer(arg0_15)
	arg0_15.timer = Timer.New(function()
		local var0_16 = tonumber(os.date("%d", pg.TimeMgr.GetInstance():GetServerTime()))

		if not arg0_15.flush and arg0_15.day and arg0_15.day == var0_16 then
			arg0_15:emit(NewShopsMediator.ON_MINI_GAME_SHOP_FLUSH)

			arg0_15.flush = true
		end

		arg0_15.day = var0_16
	end, 1, -1)

	arg0_15.timer:Start()
end

function var0_0.RemoveTimer(arg0_17)
	if arg0_17.timer then
		arg0_17.timer:Stop()

		arg0_17.timer = nil
	end
end

function var0_0.OnDestroy(arg0_18)
	if arg0_18.purchaseWindow:isShowing() then
		arg0_18.purchaseWindow:ExecuteAction("Hide")
	end

	if arg0_18.multiWindow:isShowing() then
		arg0_18.multiWindow:ExecuteAction("Hide")
	end

	arg0_18:RemoveTimer()
end

return var0_0
