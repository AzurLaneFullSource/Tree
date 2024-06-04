local var0 = class("StreetShopPage", import(".BaseShopPage"))

function var0.getUIName(arg0)
	return "StreetShop"
end

function var0.OnLoaded(arg0)
	arg0.timerText = arg0:findTF("timer_bg/Text"):GetComponent(typeof(Text))
	arg0.refreshBtn = arg0:findTF("refresh_btn")
	arg0.actTip = arg0:findTF("tip/tip_activity"):GetComponent(typeof(Text))

	local var0 = getProxy(ActivityProxy):getActivitiesByType(ActivityConst.ACTIVITY_TYPE_SHOP_STREET)
	local var1 = _.select(var0, function(arg0)
		return arg0 and not arg0:isEnd()
	end)

	setActive(arg0.actTip, #var1 > 0)

	arg0.actTip.text = arg0:GenTip(var1)
	arg0.helpBtn = arg0:findTF("tip/help")

	setActive(arg0.helpBtn, #var1 > 1)

	arg0.activitys = var1
end

function var0.GenTip(arg0, arg1)
	local var0 = ""

	if #arg1 == 1 then
		local var1 = arg1[1]

		var0 = i18n("shop_street_activity_tip", var1:GetShopTime())
	elseif #arg1 > 1 then
		var0 = arg0:GenTipForMultiAct(arg1)
	end

	return var0
end

function var0.GenTipForMultiAct(arg0, arg1)
	local var0 = arg1[1]
	local var1 = var0:getStartTime()
	local var2 = var0.stopTime
	local var3 = _.all(arg1, function(arg0)
		return arg0:getStartTime() == var1
	end)
	local var4 = _.all(arg1, function(arg0)
		return arg0.stopTime == var2
	end)
	local var5 = var0

	if not var4 then
		table.sort(arg1, function(arg0, arg1)
			return arg0.stopTime < arg1.stopTime
		end)

		var5 = arg1[1]
	elseif not var3 and var4 then
		table.sort(arg1, function(arg0, arg1)
			return arg0:getStartTime() < arg1:getStartTime()
		end)

		var5 = arg1[1]
	end

	return i18n("shop_street_activity_tip", var5:GetShopTime())
end

function var0.GenHelpContent(arg0, arg1, arg2)
	local var0 = arg2:getConfig("config_data")

	for iter0, iter1 in ipairs(var0) do
		local var1 = iter1[1]
		local var2 = pg.shop_template[var1].effect_args[1]
		local var3 = Item.getConfigData(var2).name
		local var4 = arg2:GetShopTime()

		table.insert(arg1, i18n("shop_street_Equipment_skin_box_help", var3, var4))
	end
end

function var0.OnInit(arg0)
	onButton(arg0, arg0.helpBtn, function()
		local var0 = {}

		table.sort(arg0.activitys, function(arg0, arg1)
			return arg0:getStartTime() < arg1:getStartTime()
		end)
		_.each(arg0.activitys, function(arg0)
			arg0:GenHelpContent(var0, arg0)
		end)

		local var1 = table.concat(var0, "\n\n")

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = var1
		})
	end, SFX_PANEL)
	onButton(arg0, arg0.refreshBtn, function()
		local var0 = ShoppingStreet.getRiseShopId(ShopArgs.ShoppingStreetUpgrade, arg0.shop.flashCount)

		if not var0 then
			pg.TipsMgr.GetInstance():ShowTips(i18n("shopStreet_refresh_max_count"))

			return
		end

		local var1 = pg.shop_template[var0]

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			noText = "text_cancel",
			hideNo = false,
			yesText = "text_confirm",
			content = i18n("refresh_shopStreet_question", i18n("word_" .. id2res(var1.resource_type) .. "_icon"), var1.resource_num, arg0.shop.flashCount),
			onYes = function()
				arg0:emit(NewShopsMediator.REFRESH_STREET_SHOP, var0)
			end
		})
	end, SFX_PANEL)
end

function var0.ResUISettings(arg0)
	return {
		showType = PlayerResUI.TYPE_ALL
	}
end

function var0.OnUpdatePlayer(arg0)
	local var0 = arg0.player
end

function var0.OnSetUp(arg0)
	arg0:RemoveTimer()
	arg0:AddTimer()
end

function var0.OnUpdateAll(arg0)
	arg0:InitCommodities()
	arg0:OnSetUp()
end

function var0.OnUpdateCommodity(arg0, arg1)
	local var0

	for iter0, iter1 in pairs(arg0.cards) do
		if iter1.goodsVO.id == arg1.id then
			var0 = iter1
		end
	end

	if var0 then
		var0:update(arg1)
	end
end

function var0.OnInitItem(arg0, arg1)
	local var0 = GoodsCard.New(arg1)

	onButton(arg0, var0.go, function()
		local var0 = var0.goodsVO

		if not var0:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			yesText = "text_exchange",
			type = MSGBOX_TYPE_SINGLE_ITEM,
			drop = {
				id = var0:getConfig("effect_args")[1],
				type = var0:getConfig("type"),
				count = var0:getConfig("num")
			},
			onYes = function()
				arg0:Purchase(var0)
			end
		})
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

function var0.Purchase(arg0, arg1)
	local var0 = arg1:getConfig("resource_type")

	if var0 == 4 or var0 == 14 then
		local var1 = arg0.player:getResById(var0)
		local var2 = Item.New({
			id = arg1:getConfig("effect_args")[1]
		})
		local var3 = arg1:getConfig("resource_num") * (arg1.discount / 100)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("charge_scene_buy_confirm", var3, var2:getConfig("name")),
			onYes = function()
				arg0:emit(NewShopsMediator.ON_SHOPPING, arg1.id, 1)
			end
		})
	else
		arg0:emit(NewShopsMediator.ON_SHOPPING, arg1.id, 1)
	end
end

function var0.RemoveTimer(arg0)
	if arg0.timer then
		arg0.timer:Stop()

		arg0.timer = nil
	end
end

function var0.AddTimer(arg0)
	local var0 = arg0.shop

	arg0.timer = Timer.New(function()
		if var0:isUpdateGoods() then
			arg0:RemoveTimer()
			arg0:emit(NewShopsMediator.REFRESH_STREET_SHOP)
		else
			local var0 = pg.TimeMgr.GetInstance():GetServerTime()
			local var1 = var0.nextFlashTime - var0

			arg0.timerText.text = pg.TimeMgr.GetInstance():DescCDTime(var1)
		end
	end, 1, -1)

	arg0.timer:Start()
	arg0.timer.func()
end

function var0.OnDestroy(arg0)
	arg0:RemoveTimer()

	if arg0:isShowing() then
		arg0:Hide()
	end
end

return var0
