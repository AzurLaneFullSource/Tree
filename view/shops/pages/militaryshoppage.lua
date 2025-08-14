local var0_0 = class("MilitaryShopPage", import(".BaseShopPage"))

function var0_0.GetPaintingCommodityUpdateVoice(arg0_1)
	return
end

function var0_0.CanOpen(arg0_2, arg1_2, arg2_2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2_2.level, "MilitaryExerciseMediator")
end

function var0_0.OnUpdatePlayer(arg0_3)
	arg0_3:RefreshResItemList()
end

function var0_0.GetResDataList(arg0_4)
	local var0_4 = {}
	local var1_4 = arg0_4.shop:GetResList()

	for iter0_4, iter1_4 in ipairs(var1_4) do
		local var2_4 = arg0_4.player.exploit

		table.insert(var0_4, {
			type = DROP_TYPE_RESOURCE,
			resID = iter1_4,
			cnt = var2_4
		})
	end

	return var0_4
end

function var0_0.OnSetUp(arg0_5)
	arg0_5:RemoveTimer()
	arg0_5:AddTimer()
end

function var0_0.Hide(arg0_6)
	var0_0.super.Hide(arg0_6)
	arg0_6:RemoveTimer()
end

function var0_0.OnUpdateAll(arg0_7)
	arg0_7:InitCommodities()
	arg0_7:OnSetUp()
end

function var0_0.OnUpdateCommodity(arg0_8, arg1_8)
	local var0_8

	for iter0_8, iter1_8 in pairs(arg0_8.cards) do
		if iter1_8.goodsVO.id == arg1_8.id then
			var0_8 = iter1_8

			break
		end
	end

	if var0_8 then
		var0_8:update(arg1_8)
	end
end

function var0_0.RefreshUI(arg0_9)
	setActive(arg0_9.tipTextGo, false)
	setActive(arg0_9.helpBtn, false)
	setActive(arg0_9.resolveBtn, false)
	setActive(arg0_9.refreshBtn, true)

	local var0_9 = pg.arena_data_shop[1]

	onButton(arg0_9, arg0_9.refreshBtn, function()
		if arg0_9.shop.refreshCount - 1 >= #var0_9.refresh_price then
			pg.TipsMgr.GetInstance():ShowTips(i18n("shopStreet_refresh_max_count"))

			return
		end

		local var0_10 = var0_9.refresh_price[arg0_9.shop.refreshCount] or var0_9.refresh_price[#var0_9.refresh_price]

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("refresh_shopStreet_question", i18n("word_gem_icon"), var0_10, arg0_9.shop.refreshCount - 1),
			onYes = function()
				if arg0_9.player:getTotalGem() < var0_10 then
					pg.TipsMgr.GetInstance():ShowTips(i18n("common_no_resource"))

					return
				else
					arg0_9:emit(NewShopMainMediator.REFRESH_MILITARY_SHOP, true)
				end
			end
		})
	end, SFX_PANEL)
	setButtonEnabled(arg0_9.refreshBtn, true)
end

function var0_0.OnInitItem(arg0_12, arg1_12)
	local var0_12 = GoodsCard.New(arg1_12)

	onButton(arg0_12, var0_12.go, function()
		if not var0_12.goodsVO:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0_12:OnClickCommodity(var0_12.goodsVO)
	end, SFX_PANEL)

	arg0_12.cards[arg1_12] = var0_12
end

function var0_0.OnUpdateItem(arg0_14, arg1_14, arg2_14)
	local var0_14 = arg0_14.cards[arg2_14]

	if not var0_14 then
		arg0_14:OnInitItem(arg2_14)

		var0_14 = arg0_14.cards[arg2_14]
	end

	local var1_14 = arg0_14.displays[arg1_14 + 1]

	var0_14:update(var1_14)
end

function var0_0.OnClickCommodity(arg0_15, arg1_15)
	local var0_15 = arg1_15

	pg.MsgboxMgr.GetInstance():ShowMsgBox({
		yesText = "text_exchange",
		type = MSGBOX_TYPE_SINGLE_ITEM,
		drop = {
			id = var0_15:getConfig("effect_args")[1],
			type = var0_15:getConfig("type")
		},
		onYes = function()
			arg0_15:emit(NewShopMainMediator.BUY_ITEM, var0_15.id, 1)
		end
	})
end

function var0_0.AddTimer(arg0_17)
	local var0_17 = arg0_17.shop.nextTime + 1

	arg0_17.timer = Timer.New(function()
		local var0_18 = var0_17 - pg.TimeMgr.GetInstance():GetServerTime()

		if var0_18 <= 0 then
			arg0_17:RemoveTimer()
			arg0_17:OnTimeOut()
		else
			local var1_18 = pg.TimeMgr.GetInstance():DescCDTime(var0_18)

			arg0_17.timerText.text = i18n("shop_refresh_time", var1_18)
		end
	end, 1, -1)

	arg0_17.timer:Start()
	arg0_17.timer.func()
end

function var0_0.OnTimeOut(arg0_19)
	arg0_19:emit(NewShopMainMediator.REFRESH_MILITARY_SHOP)
end

function var0_0.RemoveTimer(arg0_20)
	if arg0_20.timer then
		arg0_20.timer:Stop()

		arg0_20.timer = nil
	end
end

function var0_0.OnDestroy(arg0_21)
	var0_0.super.OnDestroy(arg0_21)
	arg0_21:RemoveTimer()
end

return var0_0
