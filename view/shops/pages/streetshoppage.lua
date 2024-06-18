local var0_0 = class("StreetShopPage", import(".BaseShopPage"))

function var0_0.getUIName(arg0_1)
	return "StreetShop"
end

function var0_0.OnLoaded(arg0_2)
	arg0_2.timerText = arg0_2:findTF("timer_bg/Text"):GetComponent(typeof(Text))
	arg0_2.refreshBtn = arg0_2:findTF("refresh_btn")
	arg0_2.actTip = arg0_2:findTF("tip/tip_activity"):GetComponent(typeof(Text))

	local var0_2 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP_STREET)
	local var1_2 = _.select(var0_2, function(arg0_3)
		return arg0_3 and not arg0_3:isEnd()
	end)

	setActive(arg0_2.actTip, #var1_2 > 0)

	arg0_2.actTip.text = arg0_2:GenTip(var1_2)
	arg0_2.helpBtn = arg0_2:findTF("tip/help")

	setActive(arg0_2.helpBtn, #var1_2 > 1)

	arg0_2.activitys = var1_2
end

function var0_0.GenTip(arg0_4, arg1_4)
	local var0_4 = ""

	if #arg1_4 == 1 then
		local var1_4 = arg1_4[1]

		var0_4 = i18n("shop_street_activity_tip", var1_4:GetShopTime())
	elseif #arg1_4 > 1 then
		var0_4 = arg0_4:GenTipForMultiAct(arg1_4)
	end

	return var0_4
end

function var0_0.GenTipForMultiAct(arg0_5, arg1_5)
	local var0_5 = arg1_5[1]
	local var1_5 = var0_5:getStartTime()
	local var2_5 = var0_5.stopTime
	local var3_5 = _.all(arg1_5, function(arg0_6)
		return arg0_6:getStartTime() == var1_5
	end)
	local var4_5 = _.all(arg1_5, function(arg0_7)
		return arg0_7.stopTime == var2_5
	end)
	local var5_5 = var0_5

	if not var4_5 then
		table.sort(arg1_5, function(arg0_8, arg1_8)
			return arg0_8.stopTime < arg1_8.stopTime
		end)

		var5_5 = arg1_5[1]
	elseif not var3_5 and var4_5 then
		table.sort(arg1_5, function(arg0_9, arg1_9)
			return arg0_9:getStartTime() < arg1_9:getStartTime()
		end)

		var5_5 = arg1_5[1]
	end

	return i18n("shop_street_activity_tip", var5_5:GetShopTime())
end

function var0_0.GenHelpContent(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg2_10:getConfig("config_data")

	for iter0_10, iter1_10 in ipairs(var0_10) do
		local var1_10 = iter1_10[1]
		local var2_10 = pg.shop_template[var1_10].effect_args[1]
		local var3_10 = Item.getConfigData(var2_10).name
		local var4_10 = arg2_10:GetShopTime()

		table.insert(arg1_10, i18n("shop_street_Equipment_skin_box_help", var3_10, var4_10))
	end
end

function var0_0.OnInit(arg0_11)
	onButton(arg0_11, arg0_11.helpBtn, function()
		local var0_12 = {}

		table.sort(arg0_11.activitys, function(arg0_13, arg1_13)
			return arg0_13:getStartTime() < arg1_13:getStartTime()
		end)
		_.each(arg0_11.activitys, function(arg0_14)
			arg0_11:GenHelpContent(var0_12, arg0_14)
		end)

		local var1_12 = table.concat(var0_12, "\n\n")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = var1_12
		})
	end, SFX_PANEL)
	onButton(arg0_11, arg0_11.refreshBtn, function()
		local var0_15 = ShoppingStreet.getRiseShopId(ShopArgs.ShoppingStreetUpgrade, arg0_11.shop.flashCount)

		if not var0_15 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("shopStreet_refresh_max_count"))

			return
		end

		local var1_15 = pg.shop_template[var0_15]

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			noText = "text_cancel",
			hideNo = false,
			yesText = "text_confirm",
			content = i18n("refresh_shopStreet_question", i18n("word_" .. id2res(var1_15.resource_type) .. "_icon"), var1_15.resource_num, arg0_11.shop.flashCount),
			onYes = function()
				arg0_11:emit(NewShopsMediator.REFRESH_STREET_SHOP, var0_15)
			end
		})
	end, SFX_PANEL)
end

function var0_0.ResUISettings(arg0_17)
	return {
		showType = PlayerResUI.TYPE_ALL
	}
end

function var0_0.OnUpdatePlayer(arg0_18)
	local var0_18 = arg0_18.player
end

function var0_0.OnSetUp(arg0_19)
	arg0_19:RemoveTimer()
	arg0_19:AddTimer()
end

function var0_0.OnUpdateAll(arg0_20)
	arg0_20:InitCommodities()
	arg0_20:OnSetUp()
end

function var0_0.OnUpdateCommodity(arg0_21, arg1_21)
	local var0_21

	for iter0_21, iter1_21 in pairs(arg0_21.cards) do
		if iter1_21.goodsVO.id == arg1_21.id then
			var0_21 = iter1_21
		end
	end

	if var0_21 then
		var0_21:update(arg1_21)
	end
end

function var0_0.OnInitItem(arg0_22, arg1_22)
	local var0_22 = GoodsCard.New(arg1_22)

	onButton(arg0_22, var0_22.go, function()
		local var0_23 = var0_22.goodsVO

		if not var0_23:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_exchange",
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				id = var0_23:getConfig("effect_args")[1],
				type = var0_23:getConfig("type"),
				count = var0_23:getConfig("num")
			},
			onYes = function()
				arg0_22:Purchase(var0_23)
			end
		})
	end, SFX_PANEL)

	arg0_22.cards[arg1_22] = var0_22
end

function var0_0.OnUpdateItem(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg0_25.cards[arg2_25]

	if not var0_25 then
		arg0_25:OnInitItem(arg2_25)

		var0_25 = arg0_25.cards[arg2_25]
	end

	local var1_25 = arg0_25.displays[arg1_25 + 1]

	var0_25:update(var1_25)
end

function var0_0.Purchase(arg0_26, arg1_26)
	local var0_26 = arg1_26:getConfig("resource_type")

	if var0_26 == 4 or var0_26 == 14 then
		local var1_26 = arg0_26.player:getResById(var0_26)
		local var2_26 = Item.New({
			id = arg1_26:getConfig("effect_args")[1]
		})
		local var3_26 = arg1_26:getConfig("resource_num") * (arg1_26.discount / 100)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("charge_scene_buy_confirm", var3_26, var2_26:getConfig("name")),
			onYes = function()
				arg0_26:emit(NewShopsMediator.ON_SHOPPING, arg1_26.id, 1)
			end
		})
	else
		arg0_26:emit(NewShopsMediator.ON_SHOPPING, arg1_26.id, 1)
	end
end

function var0_0.RemoveTimer(arg0_28)
	if arg0_28.timer then
		arg0_28.timer:Stop()

		arg0_28.timer = nil
	end
end

function var0_0.AddTimer(arg0_29)
	local var0_29 = arg0_29.shop

	arg0_29.timer = Timer.New(function()
		if var0_29:isUpdateGoods() then
			arg0_29:RemoveTimer()
			arg0_29:emit(NewShopsMediator.REFRESH_STREET_SHOP)
		else
			local var0_30 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1_30 = var0_29.nextFlashTime - var0_30

			arg0_29.timerText.text = pg.TimeMgr.GetInstance():DescCDTime(var1_30)
		end
	end, 1, -1)

	arg0_29.timer:Start()
	arg0_29.timer.func()
end

function var0_0.OnDestroy(arg0_31)
	arg0_31:RemoveTimer()

	if arg0_31:isShowing() then
		arg0_31:Hide()
	end
end

return var0_0
