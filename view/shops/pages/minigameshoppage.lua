local var0 = class("MiniGameShopPage", import(".BaseShopPage"))

function var0.getUIName(arg0)
	return "MiniGameShop"
end

function var0.CanOpen(arg0, arg1, arg2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2.level, "GameHallMediator")
end

function var0.OnLoaded(arg0)
	arg0.mothMaxTF = arg0:findTF("mothMax")

	local var0 = pg.gameset.game_ticket_month.key_value
	local var1 = getProxy(GameRoomProxy):getMonthlyTicket()

	setText(arg0.mothMaxTF, i18n("game_ticket_current_month") .. var1 .. "/" .. var0)
end

function var0.OnInit(arg0)
	arg0.purchaseWindow = MiniGameShopPurchasePanel.New(arg0._tf, arg0.event)
	arg0.multiWindow = MiniGameShopMultiWindow.New(arg0._tf, arg0.event)
	arg0.ticketTf = findTF(arg0._tf, "res/Text")

	local var0 = getProxy(GameRoomProxy):getTicket()

	setText(arg0.ticketTf, var0)
end

function var0.OnSetUp(arg0)
	arg0:RemoveTimer()
	arg0:AddTimer()
end

function var0.OnUpdateAll(arg0)
	arg0:InitCommodities()
	arg0:OnSetUp()

	if arg0.purchaseWindow:isShowing() then
		arg0.purchaseWindow:ExecuteAction("Hide")
	end

	if arg0.multiWindow:isShowing() then
		arg0.multiWindow:ExecuteAction("Hide")
	end

	local var0 = getProxy(GameRoomProxy):getTicket()

	setText(arg0.ticketTf, var0)
end

function var0.OnUpdateCommodity(arg0, arg1)
	local var0

	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.goodsVO.id == arg1.id then
			var0 = iter1

			break
		end
	end

	if var0 then
		var0:update(arg1)
	end
end

function var0.OnInitItem(arg0, arg1)
	local var0 = MiniGameGoodsCard.New(arg1)

	onButton(arg0, var0.go, function()
		if not var0.goodsVO:CanPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0:OnClickCommodity(var0.goodsVO)
	end, SFX_PANEL)

	arg0.cards[arg1] = var0
end

function var0.OnUpdateItem(arg0, arg1, arg2)
	local var0 = arg0.cards[arg2]

	if not var0 then
		arg0:OnInitItem(arg2)

		var0 = arg0.cards[arg2]
	end

	local var1 = arg0.displays[arg1 + 1]

	var0:update(var1)
end

function var0.OnClickCommodity(arg0, arg1)
	local var0 = arg1

	if var0:Selectable() then
		arg0.purchaseWindow:ExecuteAction("Show", {
			id = var0.id,
			count = var0:GetMaxCnt(),
			type = var0:getConfig("type"),
			price = var0:getConfig("price"),
			displays = var0:getConfig("goods"),
			num = var0:getConfig("num"),
			confirm = function(arg0, arg1)
				arg0:emit(NewShopsMediator.ON_MINI_GAME_SHOP_BUY, {
					id = arg0,
					list = arg1
				})
			end
		})
	elseif var0:getConfig("goods_type") == 1 then
		if var0:GetLimit() > 1 then
			arg0.multiWindow:ExecuteAction("Show", var0, function(arg0)
				if not var0:CanPurchaseCnt(arg0) then
					pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

					return
				end

				local var0 = {}
				local var1 = var0:getConfig("goods")[1]

				table.insert(var0, {
					num = arg0,
					id = var1
				})
				arg0:emit(NewShopsMediator.ON_MINI_GAME_SHOP_BUY, {
					id = var0.id,
					list = var0
				})
			end)
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				yesText = "text_exchange",
				content = i18n("guild_shop_exchange_tip"),
				onYes = function()
					if not var0:CanPurchase() then
						pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

						return
					end

					local var0 = {}
					local var1 = var0:GetFirstDropId()

					for iter0 = 1, #var1 do
						table.insert(var0, {
							num = 1,
							id = var1[iter0]
						})
					end

					arg0:emit(NewShopsMediator.ON_MINI_GAME_SHOP_BUY, {
						id = var0.id,
						list = var0
					})
				end
			})
		end
	end
end

function var0.AddTimer(arg0)
	arg0.timer = Timer.New(function()
		local var0 = tonumber(os.date("%d", pg.TimeMgr.GetInstance():GetServerTime()))

		if not arg0.flush and arg0.day and arg0.day == var0 then
			arg0:emit(NewShopsMediator.ON_MINI_GAME_SHOP_FLUSH)

			arg0.flush = true
		end

		arg0.day = var0
	end, 1, -1)

	arg0.timer:Start()
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.OnDestroy(arg0)
	if arg0.purchaseWindow:isShowing() then
		arg0.purchaseWindow:ExecuteAction("Hide")
	end

	if arg0.multiWindow:isShowing() then
		arg0.multiWindow:ExecuteAction("Hide")
	end

	arg0:RemoveTimer()
end

return var0
