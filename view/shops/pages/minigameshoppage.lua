local var0_0 = class("MiniGameShopPage", import(".BaseShopPage"))

function var0_0.CanOpen(arg0_1, arg1_1, arg2_1)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2_1.level, "GameHallMediator")
end

function var0_0.init(arg0_2)
	var0_0.super.init(arg0_2)

	arg0_2.purchaseWindow = MiniGameShopPurchasePanel.New(arg0_2._tf, arg0_2.event)
	arg0_2.multiWindow = MiniGameShopMultiWindow.New(arg0_2._tf, arg0_2.event)
end

function var0_0.OnSetUp(arg0_3)
	arg0_3:RefreshResItemList()
	arg0_3:RemoveTimer()
	arg0_3:AddTimer()
end

function var0_0.Hide(arg0_4)
	var0_0.super.Hide(arg0_4)
	arg0_4:RemoveTimer()
end

function var0_0.GetResDataList(arg0_5)
	local var0_5 = {}
	local var1_5 = arg0_5.shop:GetResList()

	for iter0_5, iter1_5 in ipairs(var1_5) do
		local var2_5 = getProxy(GameRoomProxy):getTicket()

		table.insert(var0_5, {
			type = DROP_TYPE_RESOURCE,
			resID = iter1_5,
			cnt = var2_5
		})
	end

	return var0_5
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

function var0_0.RefreshUI(arg0_8)
	setActive(arg0_8.tipTextGo, true)
	setActive(arg0_8.helpBtn, false)
	setActive(arg0_8.resolveBtn, false)
	setActive(arg0_8.refreshBtn, false)

	local var0_8 = pg.gameset.game_ticket_month.key_value
	local var1_8 = getProxy(GameRoomProxy):getMonthlyTicket()

	setText(arg0_8.tipText, i18n("game_ticket_current_month") .. var1_8 .. "/" .. var0_8)
end

function var0_0.OnInitItem(arg0_9, arg1_9)
	local var0_9 = MiniGameGoodsCard.New(arg1_9)

	onButton(arg0_9, var0_9.go, function()
		if not var0_9.goodsVO:CanPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0_9:OnClickCommodity(var0_9.goodsVO)
	end, SFX_PANEL)

	arg0_9.cards[arg1_9] = var0_9
end

function var0_0.OnUpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.cards[arg2_11]

	if not var0_11 then
		arg0_11:OnInitItem(arg2_11)

		var0_11 = arg0_11.cards[arg2_11]
	end

	local var1_11 = arg0_11.displays[arg1_11 + 1]

	var0_11:update(var1_11)
end

function var0_0.OnClickCommodity(arg0_12, arg1_12)
	local var0_12 = arg1_12

	if var0_12:Selectable() then
		arg0_12.purchaseWindow:ExecuteAction("Show", {
			id = var0_12.id,
			count = var0_12:GetMaxCnt(),
			type = var0_12:getConfig("type"),
			price = var0_12:getConfig("price"),
			displays = var0_12:getConfig("goods"),
			num = var0_12:getConfig("num"),
			confirm = function(arg0_13, arg1_13)
				arg0_12:emit(NewShopMainMediator.ON_MINI_GAME_SHOP_BUY, {
					id = arg0_13,
					list = arg1_13
				})
			end
		})
	elseif var0_12:getConfig("goods_type") == 1 then
		if var0_12:GetLimit() > 1 then
			arg0_12.multiWindow:ExecuteAction("Show", var0_12, function(arg0_14)
				if not var0_12:CanPurchaseCnt(arg0_14) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				local var0_14 = {}
				local var1_14 = var0_12:getConfig("goods")[1]

				table.insert(var0_14, {
					num = arg0_14,
					id = var1_14
				})
				arg0_12:emit(NewShopMainMediator.ON_MINI_GAME_SHOP_BUY, {
					id = var0_12.id,
					list = var0_14
				})
			end)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_exchange",
				content = i18n("guild_shop_exchange_tip"),
				onYes = function()
					if not var0_12:CanPurchase() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

						return
					end

					local var0_15 = {}
					local var1_15 = var0_12:GetFirstDropId()

					for iter0_15 = 1, #var1_15 do
						table.insert(var0_15, {
							num = 1,
							id = var1_15[iter0_15]
						})
					end

					arg0_12:emit(NewShopMainMediator.ON_MINI_GAME_SHOP_BUY, {
						id = var0_12.id,
						list = var0_15
					})
				end
			})
		end
	end
end

function var0_0.AddTimer(arg0_16)
	arg0_16.timer = Timer.New(function()
		local var0_17 = tonumber(os.date("%d", pg.TimeMgr.GetInstance():GetServerTime()))

		if not arg0_16.flush and arg0_16.day and arg0_16.day == var0_17 then
			arg0_16:emit(NewShopMainMediator.ON_MINI_GAME_SHOP_FLUSH)

			arg0_16.flush = true
		end

		arg0_16.day = var0_17
	end, 1, -1)

	arg0_16.timer:Start()
end

function var0_0.RemoveTimer(arg0_18)
	if arg0_18.timer then
		arg0_18.timer:Stop()

		arg0_18.timer = nil
	end
end

function var0_0.OnDestroy(arg0_19)
	if arg0_19.purchaseWindow:isShowing() then
		arg0_19.purchaseWindow:ExecuteAction("Hide")
	end

	if arg0_19.multiWindow:isShowing() then
		arg0_19.multiWindow:ExecuteAction("Hide")
	end

	arg0_19:RemoveTimer()
	var0_0.super.OnDestroy(arg0_19)
end

return var0_0
