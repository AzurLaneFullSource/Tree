local var0_0 = class("StreetShopPage", import(".BaseShopPage"))

function var0_0.GenTip(arg0_1, arg1_1)
	local var0_1 = ""

	if #arg1_1 == 1 then
		local var1_1 = arg1_1[1]

		var0_1 = i18n("shop_street_activity_tip", var1_1:GetShopTime())
	elseif #arg1_1 > 1 then
		var0_1 = arg0_1:GenTipForMultiAct(arg1_1)
	end

	return var0_1
end

function var0_0.GenTipForMultiAct(arg0_2, arg1_2)
	local var0_2 = arg1_2[1]
	local var1_2 = var0_2:getStartTime()
	local var2_2 = var0_2.stopTime
	local var3_2 = _.all(arg1_2, function(arg0_3)
		return arg0_3:getStartTime() == var1_2
	end)
	local var4_2 = _.all(arg1_2, function(arg0_4)
		return arg0_4.stopTime == var2_2
	end)
	local var5_2 = var0_2

	if not var4_2 then
		table.sort(arg1_2, function(arg0_5, arg1_5)
			return arg0_5.stopTime < arg1_5.stopTime
		end)

		var5_2 = arg1_2[1]
	elseif not var3_2 and var4_2 then
		table.sort(arg1_2, function(arg0_6, arg1_6)
			return arg0_6:getStartTime() < arg1_6:getStartTime()
		end)

		var5_2 = arg1_2[1]
	end

	return i18n("shop_street_activity_tip", var5_2:GetShopTime())
end

function var0_0.GenHelpContent(arg0_7, arg1_7, arg2_7)
	local var0_7 = arg2_7:getConfig("config_data")

	for iter0_7, iter1_7 in ipairs(var0_7) do
		local var1_7 = iter1_7[1]
		local var2_7 = pg.shop_template[var1_7].effect_args[1]
		local var3_7 = Item.getConfigData(var2_7).name
		local var4_7 = arg2_7:GetShopTime()

		table.insert(arg1_7, i18n("shop_street_Equipment_skin_box_help", var3_7, var4_7))
	end
end

function var0_0.OnUpdatePlayer(arg0_8)
	arg0_8:RefreshResItemList()
end

function var0_0.GetResDataList(arg0_9)
	local var0_9 = {}
	local var1_9 = arg0_9.player:getResource(PlayerConst.ResGold)

	table.insert(var0_9, {
		type = DROP_TYPE_RESOURCE,
		resID = PlayerConst.ResGold,
		cnt = var1_9
	})

	return var0_9
end

function var0_0.OnSetUp(arg0_10)
	arg0_10:RemoveTimer()
	arg0_10:AddTimer()
end

function var0_0.Hide(arg0_11)
	var0_0.super.Hide(arg0_11)
	arg0_11:RemoveTimer()
end

function var0_0.OnUpdateAll(arg0_12)
	arg0_12:InitCommodities()
	arg0_12:OnSetUp()
end

function var0_0.OnUpdateCommodity(arg0_13, arg1_13)
	local var0_13

	for iter0_13, iter1_13 in pairs(arg0_13.cards) do
		if iter1_13.goodsVO.id == arg1_13.id then
			var0_13 = iter1_13
		end
	end

	if var0_13 then
		var0_13:update(arg1_13)
	end
end

function var0_0.RefreshUI(arg0_14)
	local var0_14 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP_STREET)
	local var1_14 = _.select(var0_14, function(arg0_15)
		return arg0_15 and not arg0_15:isEnd()
	end)

	setActive(arg0_14.tipTextGo, #var1_14 > 0)

	arg0_14.tipText.text = arg0_14:GenTip(var1_14)

	setActive(arg0_14.helpBtn, #var1_14 > 1)

	arg0_14.activitys = var1_14

	setActive(arg0_14.helpBtn, false)
	setActive(arg0_14.resolveBtn, false)
	setActive(arg0_14.refreshBtn, true)
	onButton(arg0_14, arg0_14.helpBtn, function()
		local var0_16 = {}

		table.sort(arg0_14.activitys, function(arg0_17, arg1_17)
			return arg0_17:getStartTime() < arg1_17:getStartTime()
		end)
		_.each(arg0_14.activitys, function(arg0_18)
			arg0_14:GenHelpContent(var0_16, arg0_18)
		end)

		local var1_16 = table.concat(var0_16, "\n\n")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = var1_16
		})
	end, SFX_PANEL)
	onButton(arg0_14, arg0_14.refreshBtn, function()
		local var0_19 = ShoppingStreet.getRiseShopId(ShopArgs.ShoppingStreetUpgrade, arg0_14.shop.flashCount)

		if not var0_19 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("shopStreet_refresh_max_count"))

			return
		end

		local var1_19 = pg.shop_template[var0_19]

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			noText = "text_cancel",
			hideNo = false,
			yesText = "text_confirm",
			content = i18n("refresh_shopStreet_question", i18n("word_" .. id2res(var1_19.resource_type) .. "_icon"), var1_19.resource_num, arg0_14.shop.flashCount),
			onYes = function()
				arg0_14:emit(NewShopMainMediator.REFRESH_STREET_SHOP, var0_19)
			end
		})
	end, SFX_PANEL)
	setButtonEnabled(arg0_14.refreshBtn, true)
end

function var0_0.OnInitItem(arg0_21, arg1_21)
	local var0_21 = GoodsCard.New(arg1_21)

	onButton(arg0_21, var0_21.go, function()
		local var0_22 = var0_21.goodsVO

		if not var0_22:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_exchange",
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				id = var0_22:getConfig("effect_args")[1],
				type = var0_22:getConfig("type"),
				count = var0_22:getConfig("num")
			},
			onYes = function()
				arg0_21:Purchase(var0_22)
			end
		})
	end, SFX_PANEL)

	arg0_21.cards[arg1_21] = var0_21
end

function var0_0.OnUpdateItem(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg0_24.cards[arg2_24]

	if not var0_24 then
		arg0_24:OnInitItem(arg2_24)

		var0_24 = arg0_24.cards[arg2_24]
	end

	local var1_24 = arg0_24.displays[arg1_24 + 1]

	var0_24:update(var1_24)
end

function var0_0.Purchase(arg0_25, arg1_25)
	local var0_25 = arg1_25:getConfig("resource_type")

	if var0_25 == 4 or var0_25 == 14 then
		local var1_25 = arg0_25.player:getResById(var0_25)
		local var2_25 = Item.New({
			id = arg1_25:getConfig("effect_args")[1]
		})
		local var3_25 = arg1_25:getConfig("resource_num") * (arg1_25.discount / 100)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("charge_scene_buy_confirm", var3_25, var2_25:getConfig("name")),
			onYes = function()
				arg0_25:emit(NewShopMainMediator.BUY_ITEM, arg1_25.id, 1)
			end
		})
	else
		arg0_25:emit(NewShopMainMediator.BUY_ITEM, arg1_25.id, 1)
	end
end

function var0_0.RemoveTimer(arg0_27)
	if arg0_27.timer then
		arg0_27.timer:Stop()

		arg0_27.timer = nil
	end
end

function var0_0.AddTimer(arg0_28)
	local var0_28 = arg0_28.shop

	arg0_28.timer = Timer.New(function()
		if var0_28:isUpdateGoods() then
			arg0_28:RemoveTimer()
			arg0_28:emit(NewShopMainMediator.REFRESH_STREET_SHOP)
		else
			local var0_29 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_29 = var0_28.nextFlashTime - var0_29

			arg0_28.timerText.text = i18n("shop_refresh_time", pg.TimeMgr.GetInstance():DescCDTime(var1_29))
		end
	end, 1, -1)

	arg0_28.timer:Start()
	arg0_28.timer.func()
end

function var0_0.OnDestroy(arg0_30)
	arg0_30:RemoveTimer()
	var0_0.super.OnDestroy(arg0_30)
end

return var0_0
