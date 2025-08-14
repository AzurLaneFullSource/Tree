local var0_0 = class("NewShopMainScene", import("...base.BaseUI"))

var0_0.CLOSE_ALL_LAYER = "NewShopMainScene.CLOSE_ALL_LAYER"
var0_0.SHOW_OR_HIDE_UI = "NewShopMainScene.SHOW_OR_HIDE_UI"
var0_0.SHOW_OR_HIDE_UI_2 = "NewShopMainScene.SHOW_OR_HIDE_UI_2"
var0_0.CLOSE_VIEW = "NewShopMainScene.CLOSE_VIEW"
var0_0.TYPE_CHARGE = "charge"
var0_0.TYPE_SKIN = "skin"

function var0_0.getUIName(arg0_1)
	return "NewShopUI"
end

function var0_0.preload(arg0_2, arg1_2)
	local var0_2 = getProxy(ShopsProxy)

	local function var1_2()
		local var0_3 = var0_2:getFirstChargeList()
		local var1_3 = var0_2:getChargedList()
		local var2_3 = var0_2:GetNormalList()
		local var3_3 = var0_2:GetNormalGroupList()

		if var0_3 then
			arg0_2:setFirstChargeIds(var0_3)
		end

		if var1_3 then
			arg0_2:setChargedList(var1_3)
		end

		if var2_3 then
			arg0_2:setNormalList(var2_3)
		end

		if var3_3 then
			arg0_2:setNormalGroupList(var3_3)
		end

		arg1_2()
	end

	if var0_2:ShouldRefreshChargeList() then
		pg.m02:sendNotification(GAME.GET_CHARGE_LIST, {
			callback = var1_2
		})
	else
		var1_2()
	end
end

function var0_0.init(arg0_4)
	local var0_4 = arg0_4:findTF("buttonList")

	arg0_4.buttonList = var0_4
	arg0_4.backBtn = arg0_4:findTF("top/closeBtn", var0_4)
	arg0_4.homeBtn = arg0_4:findTF("top/homeBtn", var0_4)
	arg0_4.resourcePanel = arg0_4:findTF("top/resources", var0_4)

	setActive(arg0_4.resourcePanel, false)

	arg0_4.goldBtn = arg0_4:findTF("top/resources/gold", var0_4)
	arg0_4.goldText = arg0_4:findTF("top/resources/gold/Text", var0_4):GetComponent(typeof(Text))
	arg0_4.goldMax = arg0_4:findTF("top/resources/gold/max", var0_4):GetComponent(typeof(Text))
	arg0_4.oilBtn = arg0_4:findTF("top/resources/oil", var0_4)
	arg0_4.oilText = arg0_4:findTF("top/resources/oil/Text", var0_4):GetComponent(typeof(Text))
	arg0_4.oilMax = arg0_4:findTF("top/resources/oil/max", var0_4):GetComponent(typeof(Text))
	arg0_4.diamondBtn = arg0_4:findTF("top/resources/gem", var0_4)
	arg0_4.diamondText = arg0_4:findTF("top/resources/gem/Text", var0_4):GetComponent(typeof(Text))

	setText(arg0_4:findTF("top/title/Text", var0_4), i18n("shop_title"))
	setText(arg0_4:findTF("shop1List/recommendation/shop1Tg/name", var0_4), i18n("shop_recommend"))
	setText(arg0_4:findTF("shop1List/skinShop/shop1Tg/name", var0_4), i18n("shop_skin"))
	setText(arg0_4:findTF("shop1List/diamondShop/shop1Tg/name", var0_4), i18n("shop_diamond_title"))
	setText(arg0_4:findTF("shop1List/specialShop/shop1Tg/name", var0_4), i18n("shop_akashi_pick_title"))
	setText(arg0_4:findTF("shop1List/giftPackShop/shop1Tg/name", var0_4), i18n("shop_gift_title"))
	setText(arg0_4:findTF("shop1List/functionalItemShop/shop1Tg/name", var0_4), i18n("shop_item_title"))
	setText(arg0_4:findTF("shop1List/supplyShop/shop1Tg/name", var0_4), i18n("shop_supply_prop"))
	setText(arg0_4:findTF("shop1List/recommendation/shop1Tg/name/en", var0_4), i18n("shop_recommend_en"))
	setText(arg0_4:findTF("shop1List/skinShop/shop1Tg/name/en", var0_4), i18n("shop_skin_en"))
	setText(arg0_4:findTF("shop1List/diamondShop/shop1Tg/name/en", var0_4), i18n("shop_diamond_title_en"))
	setText(arg0_4:findTF("shop1List/specialShop/shop1Tg/name/en", var0_4), i18n("shop_side_lable_en"))
	setText(arg0_4:findTF("shop1List/giftPackShop/shop1Tg/name/en", var0_4), i18n("shop_gift_title_en"))
	setText(arg0_4:findTF("shop1List/functionalItemShop/shop1Tg/name/en", var0_4), i18n("shop_item_title_en"))
	setText(arg0_4:findTF("shop1List/supplyShop/shop1Tg/name/en", var0_4), i18n("shop_supply_prop_en"))
	setText(arg0_4:findTF("shop1List/skinShop/shop2List/newSkin/name", var0_4), i18n("shop_skin_new"))
	setText(arg0_4:findTF("shop1List/skinShop/shop2List/newSkin/selected/name", var0_4), i18n("shop_skin_new"))
	setText(arg0_4:findTF("shop1List/skinShop/shop2List/permanentSkin/name", var0_4), i18n("shop_skin_permanent"))
	setText(arg0_4:findTF("shop1List/skinShop/shop2List/permanentSkin/selected/name", var0_4), i18n("shop_skin_permanent"))
	setText(arg0_4:findTF("shop1List/supplyShop/shop2List/monthShop/name", var0_4), i18n("shop_month"))
	setText(arg0_4:findTF("shop1List/supplyShop/shop2List/monthShop/selected/name", var0_4), i18n("shop_month"))
	setText(arg0_4:findTF("shop1List/supplyShop/shop2List/supplyShop/name", var0_4), i18n("shop_supply"))
	setText(arg0_4:findTF("shop1List/supplyShop/shop2List/supplyShop/selected/name", var0_4), i18n("shop_supply"))
	setText(arg0_4:findTF("shop1List/supplyShop/shop2List/activityShop/name", var0_4), i18n("shop_activity"))
	setText(arg0_4:findTF("shop1List/supplyShop/shop2List/activityShop/selected/name", var0_4), i18n("shop_activity"))

	arg0_4.frame = arg0_4:findTF("frame")
	arg0_4.viewContainer = arg0_4:findTF("viewContainer")
	arg0_4.painting = arg0_4:findTF("frame/painting")
	arg0_4.chat = arg0_4:findTF("frame/chat")
	arg0_4.chatText = arg0_4:findTF("Text", arg0_4.chat)
	arg0_4.stamp = arg0_4:findTF("frame/stamp")
	arg0_4.giftTip = arg0_4:findTF("shop1List/specialShop/shop1Tg/tip", var0_4)
	arg0_4.toggleList = {
		{
			type = ChargeScene.TYPE_DIAMOND,
			go = arg0_4:findTF("shop1List/diamondShop/shop1Tg", var0_4)
		},
		{
			type = ChargeScene.TYPE_GIFT,
			go = arg0_4:findTF("shop1List/giftPackShop/shop1Tg", var0_4)
		},
		{
			type = ChargeScene.TYPE_ITEM,
			go = arg0_4:findTF("shop1List/functionalItemShop/shop1Tg", var0_4)
		},
		{
			type = ChargeScene.TYPE_PICK,
			go = arg0_4:findTF("shop1List/specialShop/shop1Tg", var0_4)
		}
	}
	arg0_4.chargeTipWindow = ChargeTipWindow.New(arg0_4._tf, arg0_4.event)

	arg0_4:LoadMingshi()
	arg0_4:jpUIInit()
	arg0_4:blurView()
	arg0_4:initSubView()
end

function var0_0.setPlayer(arg0_5, arg1_5)
	arg0_5.player = arg1_5

	if arg0_5.subViewList[arg0_5.curSubViewNum] and arg0_5.subViewList[arg0_5.curSubViewNum]:IsSupplyShop() then
		arg0_5.subViewList[arg0_5.curSubViewNum]:SetPlayer(arg1_5)
	end

	if arg0_5.goldMax then
		PlayerResUI.StaticFlush(arg0_5.player, arg0_5.goldMax, arg0_5.goldText, arg0_5.oilMax, arg0_5.oilText, arg0_5.diamondText)
	end
end

function var0_0.setFirstChargeIds(arg0_6, arg1_6)
	arg0_6.firstChargeIds = arg1_6
end

function var0_0.setChargedList(arg0_7, arg1_7)
	arg0_7.chargedList = arg1_7
end

function var0_0.setNormalList(arg0_8, arg1_8)
	arg0_8.normalList = arg1_8
end

function var0_0.setNormalGroupList(arg0_9, arg1_9)
	arg0_9.normalGroupList = arg1_9

	arg0_9:addRefreshTimer(GetZeroTime())
end

function var0_0.SetSupplyShopList(arg0_10, arg1_10)
	arg0_10.supplyShopList = arg1_10

	arg0_10:SortActivityShops()
end

function var0_0.SortActivityShops(arg0_11)
	for iter0_11, iter1_11 in pairs(arg0_11.supplyShopList) do
		if #iter1_11 > 1 then
			table.sort(iter1_11, function(arg0_12, arg1_12)
				return arg0_12:getStartTime() > arg1_12:getStartTime()
			end)
		end
	end
end

function var0_0.OnInitItems(arg0_13, arg1_13)
	arg0_13.items = arg1_13

	arg0_13.subViewList[ShopConst.SHOP_ID.MONTH]:OnUpdateItems(arg1_13)
	arg0_13.subViewList[ShopConst.SHOP_ID.SUPPLY]:OnUpdateItems(arg1_13)
	arg0_13.subViewList[ShopConst.SHOP_ID.ACTIVITY]:OnUpdateItems(arg1_13)
end

function var0_0.OnUpdateItems(arg0_14, arg1_14)
	arg0_14.items = arg1_14

	if arg0_14.subViewList[arg0_14.curSubViewNum] and arg0_14.subViewList[arg0_14.curSubViewNum]:IsSupplyShop() then
		arg0_14.subViewList[arg0_14.curSubViewNum]:OnUpdateItems(arg1_14)
	end
end

function var0_0.OnUpdateShop(arg0_15, arg1_15, arg2_15)
	arg0_15:SetShop(arg1_15, arg2_15)

	if arg0_15.subViewList[arg0_15.curSubViewNum] and arg0_15.subViewList[arg0_15.curSubViewNum]:IsSupplyShop() then
		arg0_15.subViewList[arg0_15.curSubViewNum]:OnUpdateShop(arg1_15, arg2_15)
	end
end

function var0_0.OnUpdateCommodity(arg0_16, arg1_16, arg2_16, arg3_16)
	arg0_16:SetShop(arg1_16, arg2_16)

	if arg0_16.subViewList[arg0_16.curSubViewNum] and arg0_16.subViewList[arg0_16.curSubViewNum]:IsSupplyShop() then
		arg0_16.subViewList[arg0_16.curSubViewNum]:OnUpdateCommodity(arg1_16, arg2_16, arg3_16)
	end
end

function var0_0.OnFragmentSellUpdate(arg0_17)
	if arg0_17.subViewList[arg0_17.curSubViewNum] and arg0_17.subViewList[arg0_17.curSubViewNum]:IsSupplyShop() then
		arg0_17.subViewList[arg0_17.curSubViewNum]:OnFragmentSellUpdate()
	end
end

function var0_0.SetShop(arg0_18, arg1_18, arg2_18)
	if not arg0_18.supplyShopList then
		return
	end

	local var0_18 = arg0_18.supplyShopList[arg1_18]

	if var0_18 then
		for iter0_18, iter1_18 in ipairs(var0_18) do
			if iter1_18:IsSameKind(arg2_18) then
				arg0_18.supplyShopList[arg1_18][iter0_18] = arg2_18

				break
			end
		end
	end
end

function var0_0.didEnter(arg0_19)
	setActive(arg0_19.chat, false)
	onButton(arg0_19, arg0_19.backBtn, function()
		arg0_19:closeView()
	end, SFX_CANCEL)
	onButton(arg0_19, arg0_19.homeBtn, function()
		arg0_19:emit(var0_0.ON_HOME)
	end, SFX_CANCEL)
	onButton(arg0_19, arg0_19.goldBtn, function()
		pg.playerResUI:ClickGold()
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.oilBtn, function()
		pg.playerResUI:ClickOil()
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.diamondBtn, function()
		pg.playerResUI:ClickGem()
	end, SFX_PANEL)
	onToggle(arg0_19, arg0_19:findTF("shop1List/recommendation/shop1Tg", arg0_19.buttonList), function(arg0_25)
		if arg0_25 then
			arg0_19.contextData.shop1 = nil
			arg0_19.contextData.shop2 = nil

			arg0_19:ShowChargeWarp(false)
			pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
			arg0_19:emit(NewShopMainMediator.OPEN_LAYER, NewRecommendationShopLayer, NewRecommendationShopMediator)
		end
	end, SFX_PANEL)

	local var0_19 = getProxy(ShipSkinProxy):GetInTimeSkins()

	setActive(arg0_19:findTF("shop1List/skinShop/shop1Tg/timeLimit", arg0_19.buttonList), #var0_19 > 0)
	setActive(arg0_19:findTF("shop1List/skinShop/shop2List/newSkin", arg0_19.buttonList), #var0_19 > 0)
	onToggle(arg0_19, arg0_19:findTF("shop1List/skinShop/shop2List/newSkin", arg0_19.buttonList), function(arg0_26)
		if arg0_26 then
			arg0_19.contextData.shop2 = "newSkin"

			arg0_19:ShowChargeWarp(false)
			pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
			arg0_19:emit(NewShopMainMediator.OPEN_LAYER, LatestSkinShopLayer, LatestSkinShopMediator, {
				type = "newSkin",
				mode = arg0_19.contextData.mode
			})
		end
	end, SFX_PANEL)
	onToggle(arg0_19, arg0_19:findTF("shop1List/skinShop/shop2List/permanentSkin", arg0_19.buttonList), function(arg0_27)
		if arg0_27 then
			arg0_19.contextData.shop2 = "permanentSkin"

			arg0_19:ShowChargeWarp(false)
			pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)
			arg0_19:emit(NewShopMainMediator.OPEN_LAYER, LatestSkinShopLayer, LatestSkinShopMediator, {
				type = "permanentSkin",
				mode = arg0_19.contextData.mode
			})
		end
	end, SFX_PANEL)
	onToggle(arg0_19, arg0_19:findTF("shop1List/skinShop/shop1Tg", arg0_19.buttonList), function(arg0_28)
		setActive(arg0_19:findTF("shop1List/skinShop/shop2List", arg0_19.buttonList), arg0_28)

		if arg0_28 then
			if arg0_19.contextData.shop1 and arg0_19.contextData.shop2 then
				triggerToggle(arg0_19.buttonList:Find("shop1List/skinShop/shop2List/" .. arg0_19.contextData.shop2), true)
			else
				arg0_19.contextData.shop1 = "skinShop"

				triggerToggle(arg0_19.buttonList:Find("shop1List/skinShop/shop2List/" .. (#var0_19 > 0 and "newSkin" or "permanentSkin")), true)
			end
		end
	end, SFX_PANEL)

	for iter0_19 = 1, #arg0_19.toggleList do
		local var1_19 = arg0_19.toggleList[iter0_19].go

		onToggle(arg0_19, var1_19, function(arg0_29)
			if arg0_29 then
				arg0_19.contextData.type = ShopConst.SHOP_TYPE.CHARGE
				arg0_19.contextData.warp = arg0_19.toggleList[iter0_19].type

				arg0_19:ShowChargeWarp(true)
				pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)

				arg0_19.contextData.shop1 = nil
				arg0_19.contextData.shop2 = nil

				local var0_29 = arg0_19:GetShopID(arg0_19.contextData.type, arg0_19.contextData.warp)

				arg0_19:switchSubView(var0_29)
			end
		end, SFX_PANEL)
	end

	onToggle(arg0_19, arg0_19:findTF("shop1List/supplyShop/shop1Tg", arg0_19.buttonList), function(arg0_30)
		setActive(arg0_19:findTF("shop1List/supplyShop/shop2List", arg0_19.buttonList), arg0_30)

		if arg0_30 then
			triggerToggle(arg0_19:findTF("shop1List/supplyShop/shop2List/" .. arg0_19:GetDefaultSupplyShopName(), arg0_19.buttonList), true)
		end
	end, SFX_PANEL)

	local var2_19 = {
		{
			type = ShopConst.CATEGORY_MONTH,
			go = arg0_19:findTF("shop1List/supplyShop/shop2List/monthShop", arg0_19.buttonList)
		},
		{
			type = ShopConst.CATEGORY_SUPPLY,
			go = arg0_19:findTF("shop1List/supplyShop/shop2List/supplyShop", arg0_19.buttonList)
		},
		{
			type = ShopConst.CATEGORY_ACTIVITY,
			go = arg0_19:findTF("shop1List/supplyShop/shop2List/activityShop", arg0_19.buttonList)
		}
	}

	for iter1_19, iter2_19 in ipairs(var2_19) do
		onToggle(arg0_19, iter2_19.go, function(arg0_31)
			if arg0_31 then
				arg0_19.contextData.type = ShopConst.SHOP_TYPE.SUPPLY
				arg0_19.contextData.warp = iter2_19.type

				arg0_19:ShowChargeWarp(true)
				pg.m02:sendNotification(var0_0.CLOSE_ALL_LAYER)

				arg0_19.contextData.shop1 = nil
				arg0_19.contextData.shop2 = nil

				local var0_31 = arg0_19:GetShopID(arg0_19.contextData.type, arg0_19.contextData.warp)

				arg0_19:switchSubView(var0_31)
			end
		end, SFX_PANEL)
	end

	local var3_19 = "recommendation"

	if arg0_19.contextData.type == ShopConst.SHOP_TYPE.CHARGE then
		if arg0_19.contextData.warp == ChargeScene.TYPE_DIAMOND then
			var3_19 = "diamondShop"
		elseif arg0_19.contextData.warp == ChargeScene.TYPE_GIFT then
			var3_19 = "giftPackShop"
		elseif arg0_19.contextData.warp == ChargeScene.TYPE_ITEM then
			var3_19 = "functionalItemShop"
		elseif arg0_19.contextData.warp == ChargeScene.TYPE_PICK then
			var3_19 = "specialShop"
		else
			var3_19 = "diamondShop"
		end
	elseif arg0_19.contextData.type == ShopConst.SHOP_TYPE.SKIN then
		var3_19 = "skinShop"
	elseif arg0_19.contextData.type == ShopConst.SHOP_TYPE.SUPPLY then
		var3_19 = "supplyShop"
	end

	if arg0_19.contextData.shop1 then
		var3_19 = arg0_19.contextData.shop1
	end

	triggerToggle(arg0_19:findTF("shop1List/" .. var3_19 .. "/shop1Tg", arg0_19.buttonList), true)

	if var3_19 == "skinShop" then
		-- block empty
	elseif var3_19 == "supplyShop" then
		triggerToggle(arg0_19:findTF("shop1List/supplyShop/shop2List/" .. arg0_19:GetDefaultSupplyShopName(), arg0_19.buttonList), true)
	end

	onButton(arg0_19, arg0_19.painting, function()
		arg0_19:displayShipWord()
		arg0_19:emit(NewShopMainMediator.CLICK_MING_SHI)
	end, SFX_PANEL)
	onButton(arg0_19, arg0_19.stamp, function()
		getProxy(TaskProxy):dealMingshiTouchFlag(4)
	end, SFX_CONFIRM)
	arg0_19:RefreshActivityShop()
	arg0_19:updateNoRes()
	arg0_19:jpUIEnter()
end

function var0_0.GetDefaultSupplyShopName(arg0_34)
	if arg0_34.contextData.type ~= ShopConst.SHOP_TYPE.SUPPLY then
		return "supplyShop"
	end

	local var0_34 = arg0_34.contextData.warp

	if type(var0_34) == "string" then
		local var1_34 = ShopConst.SHOP_NAME_LIST[var0_34]

		arg0_34.contextData.warp = var1_34[1]
		arg0_34.contextData.shopID = var1_34[2]
	elseif type(var0_34) == "number" and arg0_34.contextData.shopID == nil then
		for iter0_34, iter1_34 in pairs(ShopConst.SUPPLY_SHOP_LIST) do
			for iter2_34, iter3_34 in pairs(iter1_34) do
				if iter3_34 == var0_34 then
					arg0_34.contextData.warp = iter0_34
					arg0_34.contextData.shopID = iter3_34

					break
				end
			end
		end
	end

	local var2_34 = ""

	return arg0_34.contextData.warp == ShopConst.CATEGORY_MONTH and "monthShop" or arg0_34.contextData.warp == ShopConst.CATEGORY_SUPPLY and "supplyShop" or arg0_34.contextData.warp == ShopConst.CATEGORY_ACTIVITY and "activityShop" or "supplyShop"
end

function var0_0.RefreshActivityShop(arg0_35)
	local var0_35 = arg0_35.supplyShopList[ShopConst.TYPE_ACTIVITY] or {}

	setActive(arg0_35:findTF("shop1List/supplyShop/shop2List/activityShop", arg0_35.buttonList), #var0_35 > 0)
end

function var0_0.ShowOrHideUI(arg0_36, arg1_36)
	arg0_36:setVisible(arg1_36)
	setActive(arg0_36.buttonList, arg1_36)
end

function var0_0.ShowOrHideUI2(arg0_37, arg1_37)
	for iter0_37 = 0, arg0_37._tf.childCount - 1 do
		setActive(arg0_37._tf:GetChild(iter0_37), arg1_37)
	end

	setActive(arg0_37.buttonList:Find("leftBg"), arg1_37)
	setActive(arg0_37.buttonList:Find("shop1List"), arg1_37)
	setActive(arg0_37.buttonList:Find("top"), true)
end

function var0_0.OnChargeSuccess(arg0_38, arg1_38)
	arg0_38.chargeTipWindow:ExecuteAction("Show", arg1_38)
end

function var0_0.LoadMingshi(arg0_39)
	if Live2dConst.GetLive2DArm32MatchAble() then
		local var0_39 = Ship.New({
			configId = 312011
		}):getPainting()

		LoadPaintingPrefabAsync(arg0_39.painting, var0_39, var0_39, "mainNormal", function()
			arg0_39.loading = false
		end)
	else
		arg0_39:createLive2D()
	end

	arg0_39:AddLive2dTimer()
end

function var0_0.AddLive2dTimer(arg0_41)
	arg0_41:StopLive2dTimer()

	arg0_41.live2dTimer = Timer.New(function()
		local var0_42 = pg.ChargeShipTalkInfo.Actions
		local var1_42 = var0_42[math.random(#var0_42)]

		if arg0_41:checkBuyDone(var1_42.action) then
			arg0_41:displayShipWord(nil, false, var1_42.dialog_index)
		end
	end, 20, -1)

	arg0_41.live2dTimer:Start()
end

function var0_0.StopLive2dTimer(arg0_43)
	if arg0_43.live2dTimer then
		arg0_43.live2dTimer:Stop()

		arg0_43.live2dTimer = nil
	end
end

function var0_0.ShowChargeWarp(arg0_44, arg1_44)
	setActive(arg0_44.frame, arg1_44)
	setActive(arg0_44.viewContainer, arg1_44)
	arg0_44:ShowResourceBar(arg1_44)

	local var0_44 = arg0_44.subViewList[arg0_44.curSubViewNum]

	if var0_44 then
		var0_44:ShowPanel(arg1_44)
	end
end

function var0_0.ShowResourceBar(arg0_45, arg1_45)
	if arg0_45.resourceBarFlag == arg1_45 then
		return
	end

	arg0_45.resourceBarFlag = arg1_45

	setActive(arg0_45.resourcePanel, arg1_45)
end

function var0_0.willExit(arg0_46)
	arg0_46:ShowResourceBar()
	arg0_46:unBlurView()

	if arg0_46.chargeTipWindow then
		arg0_46.chargeTipWindow:Destroy()

		arg0_46.chargeTipWindow = nil
	end

	arg0_46.contextData.singleWindow:Destroy()
	arg0_46.contextData.multiWindow:Destroy()
	arg0_46.contextData.singleWindowForESkin:Destroy()
	arg0_46.contextData.paintingView:Dispose()

	arg0_46.contextData.singleWindow = nil
	arg0_46.contextData.multiWindow = nil
	arg0_46.contextData.singleWindowForESkin = nil
	arg0_46.contextData.paintingView = nil

	for iter0_46, iter1_46 in pairs(arg0_46.subViewList) do
		iter1_46:Destroy()
	end

	arg0_46.subViewList = nil

	if arg0_46.heartsTimer then
		arg0_46.heartsTimer:Stop()

		arg0_46.heartsTimer = nil
	end

	if arg0_46.live2dChar then
		arg0_46.live2dChar:Dispose()
	end

	arg0_46:StopLive2dTimer()
	arg0_46:stopCV()

	if arg0_46.giftShopView then
		arg0_46.giftShopView:OnDestroy()
	end
end

function var0_0.onBackPressed(arg0_47)
	if arg0_47.contextData.singleWindow:GetLoaded() and arg0_47.contextData.singleWindow:isShowing() then
		arg0_47.contextData.singleWindow:Close()

		return
	end

	if arg0_47.contextData.multiWindow:GetLoaded() and arg0_47.contextData.multiWindow:isShowing() then
		arg0_47.contextData.multiWindow:Close()

		return
	end

	if arg0_47.contextData.singleWindowForESkin:GetLoaded() and arg0_47.contextData.singleWindowForESkin:isShowing() then
		arg0_47.contextData.singleWindowForESkin:Hide()

		return
	end

	var0_0.super.onBackPressed(arg0_47)
end

function var0_0.initSubView(arg0_48)
	local var0_48 = ChargeDiamondShopView.New(arg0_48.viewContainer, arg0_48.event, arg0_48.contextData)
	local var1_48 = ChargeGiftShopView.New(arg0_48.viewContainer, arg0_48.event, arg0_48.contextData)
	local var2_48 = ChargeItemShopView.New(arg0_48.viewContainer, arg0_48.event, arg0_48.contextData)
	local var3_48 = ChargePickShopView.New(arg0_48.viewContainer, arg0_48.event, arg0_48.contextData)
	local var4_48 = SupplyShopView.New(arg0_48.viewContainer, arg0_48.event, arg0_48.contextData, ShopConst.CATEGORY_MONTH)
	local var5_48 = SupplyShopView.New(arg0_48.viewContainer, arg0_48.event, arg0_48.contextData, ShopConst.CATEGORY_SUPPLY)
	local var6_48 = SupplyShopView.New(arg0_48.viewContainer, arg0_48.event, arg0_48.contextData, ShopConst.CATEGORY_ACTIVITY)

	arg0_48.curSubViewNum = 0
	arg0_48.subViewList = {
		[ShopConst.SHOP_ID.DIAMOND] = var0_48,
		[ShopConst.SHOP_ID.GIFT] = var1_48,
		[ShopConst.SHOP_ID.ITEM] = var2_48,
		[ShopConst.SHOP_ID.PICK] = var3_48,
		[ShopConst.SHOP_ID.MONTH] = var4_48,
		[ShopConst.SHOP_ID.SUPPLY] = var5_48,
		[ShopConst.SHOP_ID.ACTIVITY] = var6_48
	}
	arg0_48.contextData.singleWindow = ShopSingleWindow.New(arg0_48._tf, arg0_48.event)
	arg0_48.contextData.multiWindow = ShopMultiWindow.New(arg0_48._tf, arg0_48.event)
	arg0_48.contextData.singleWindowForESkin = EquipmentSkinInfoUIForShopWindow.New(arg0_48._tf, arg0_48.event)
	arg0_48.contextData.paintingView = ShopPaintingView.New(arg0_48:findTF("frame/supplyPaint"), arg0_48:findTF("frame/chat"))

	arg0_48.contextData.paintingView:setSecretaryPos(arg0_48:findTF("frame/secretaryPos"))
end

function var0_0.GetShopID(arg0_49)
	local var0_49 = arg0_49.contextData.type
	local var1_49 = arg0_49.contextData.warp

	return ShopConst.SHOP_LIST[var0_49][var1_49]
end

function var0_0.switchSubView(arg0_50, arg1_50)
	if arg1_50 == arg0_50.curSubViewNum then
		return
	end

	arg0_50.subViewList[arg1_50]:setGoodData(arg0_50.firstChargeIds, arg0_50.chargedList, arg0_50.normalList, arg0_50.normalGroupList)
	arg0_50.subViewList[arg1_50]:Reset()
	arg0_50.subViewList[arg1_50]:Load()

	if arg0_50.subViewList[arg1_50].SetAllShopData then
		arg0_50.subViewList[arg1_50]:ActionInvoke("SetAllShopData", arg0_50.supplyShopList)
	end

	local var0_50 = arg0_50.subViewList[arg0_50.curSubViewNum]

	if var0_50 then
		var0_50:Destroy()
	end

	arg0_50.curSubViewNum = arg1_50

	arg0_50:SwitchPainting(arg0_50.subViewList[arg1_50]:IsSupplyShop())

	if PLATFORM_CODE == PLATFORM_JP then
		setActive(arg0_50.userAgreeBtn3, arg1_50 == ChargeScene.TYPE_DIAMOND)
		setActive(arg0_50.userAgreeBtn4, arg1_50 == ChargeScene.TYPE_DIAMOND)
	end
end

function var0_0.SwitchPainting(arg0_51, arg1_51)
	arg0_51.contextData.paintingView:Show(arg1_51)
	setActive(arg0_51.painting, not arg1_51)

	if arg1_51 then
		arg0_51:StopLive2dTimer()
		arg0_51:stopCV()
		setActive(arg0_51.stamp, getProxy(TaskProxy):mingshiTouchFlagEnabled())

		if LOCK_CLICK_MINGSHI then
			setActive(arg0_51.stamp, false)
		end
	else
		setActive(arg0_51.stamp, false)
		arg0_51:AddLive2dTimer()
	end
end

function var0_0.switchSubViewByTogger(arg0_52, arg1_52)
	local var0_52 = arg0_52.toggleList[arg1_52]

	triggerToggle(var0_52.go, true)
end

function var0_0.updateCurSubView(arg0_53)
	local var0_53 = arg0_53.subViewList[arg0_53.curSubViewNum]

	var0_53:setGoodData(arg0_53.firstChargeIds, arg0_53.chargedList, arg0_53.normalList, arg0_53.normalGroupList)
	var0_53:reUpdateAll()
end

function var0_0.updateNoRes(arg0_54, arg1_54)
	if not arg1_54 then
		arg1_54 = arg0_54.contextData.noRes
	else
		arg0_54.contextData.noRes = arg1_54
	end

	if not arg1_54 or #arg1_54 <= 0 then
		return
	end

	arg0_54.contextData.noRes = {}

	local var0_54 = getProxy(BagProxy):getData()
	local var1_54 = ""

	for iter0_54, iter1_54 in ipairs(arg1_54) do
		if iter1_54[2] > 0 then
			if iter1_54[1] == 59001 then
				arg1_54[iter0_54][2] = iter1_54[3] - arg0_54.player.gold
			else
				arg1_54[iter0_54][2] = iter1_54[3] - (var0_54[iter1_54[1]] and var0_54[iter1_54[1]].count or 0)
			end
		end

		if arg1_54[iter0_54][2] > 0 then
			table.insert(arg0_54.contextData.noRes, arg1_54[iter0_54])
		end
	end

	for iter2_54, iter3_54 in ipairs(arg0_54.contextData.noRes) do
		local var2_54 = Item.getConfigData(iter3_54[1]).name

		var1_54 = var1_54 .. i18n(iter3_54[1] == 59001 and "text_noRes_info_tip" or "text_noRes_info_tip2", var2_54, iter3_54[2])

		if iter2_54 < #arg0_54.contextData.noRes then
			var1_54 = var1_54 .. i18n("text_noRes_info_tip_link")
		end
	end

	if var1_54 == "" then
		arg0_54:displayShipWord(i18n("text_shop_enoughRes_tip"), false)
	else
		arg0_54:displayShipWord(i18n("text_shop_noRes_tip", var1_54), true)
	end
end

function var0_0.displayShipWord(arg0_55, arg1_55, arg2_55, arg3_55)
	if not arg0_55.chatFlag then
		if not arg1_55 and arg0_55.contextData.noRes and #arg0_55.contextData.noRes > 0 then
			setActive(arg0_55.chat, false)

			arg0_55.chat.transform.localScale = Vector3(0, 0, 1)
		end

		arg0_55.chatFlag = true

		if not arg0_55.isInitChatPosition then
			arg0_55.isInitChatPosition = true

			arg0_55:InitChatPosition()
		end

		setActive(arg0_55.chat, true)

		local var0_55 = arg0_55.player:getChargeLevel()
		local var1_55 = arg3_55 or math.random(1, var0_55)
		local var2_55

		if arg3_55 then
			var2_55 = pg.pay_level_award[var1_55].dialog
		else
			var2_55 = arg1_55 or pg.pay_level_award[var1_55].dialog
		end

		if not arg1_55 then
			arg0_55:playCV(var1_55)
		end

		setText(arg0_55.chatText, var2_55)

		local var3_55 = arg0_55.chatText:GetComponent(typeof(Text))

		;(function()
			local var0_56 = 3
			local var1_56 = 0.3

			LeanTween.scale(rtf(arg0_55.chat.gameObject), Vector3.New(1, 1, 1), var1_56):setFrom(Vector3.New(0, 0, 0)):setEase(LeanTweenType.easeOutBack):setOnComplete(System.Action(function()
				if not arg2_55 then
					LeanTween.scale(rtf(arg0_55.chat.gameObject), Vector3.New(0, 0, 1), var1_56):setEase(LeanTweenType.easeInBack):setDelay(var1_56 + var0_56):setOnComplete(System.Action(function()
						arg0_55.chatFlag = nil

						setActive(arg0_55.chat, false)

						if arg0_55.contextData.noRes and #arg0_55.contextData.noRes > 0 then
							arg0_55:updateNoRes()
						end
					end))
				else
					arg0_55.chatFlag = nil
				end
			end))
		end)()
	end
end

function var0_0.InitChatPosition(arg0_59)
	return
end

function var0_0.playHeartEffect(arg0_60)
	if arg0_60.heartsTimer then
		arg0_60.heartsTimer:Stop()
	end

	local var0_60 = arg0_60.painting:Find("heartsfly")

	setActive(var0_60, true)

	arg0_60.heartsTimer = Timer.New(function()
		setActive(var0_60, false)
	end, 1, 1)

	arg0_60.heartsTimer:Start()
end

function var0_0.createLive2D(arg0_62)
	local var0_62 = Live2D.GenerateData({
		ship = Ship.New({
			configId = 312011
		}),
		offset = {
			0,
			0,
			0,
			75
		},
		position = Vector3(0, 0, 0),
		parent = arg0_62:findTF("frame/painting/live2d")
	})

	arg0_62.live2dChar = Live2D.New(var0_62, function(arg0_63)
		arg0_63:setSortingLayer(LayerWeightConst.L2D_DEFAULT_LAYER)
	end)
end

function var0_0.checkBuyDone(arg0_64, arg1_64)
	if not arg0_64.live2dChar or not arg0_64.live2dChar:IsLoaded() then
		return
	end

	local var0_64

	if type(arg1_64) == "string" then
		if arg1_64 == "damonds" then
			var0_64 = "diamond"
		else
			var0_64 = arg1_64
		end
	else
		local var1_64 = pg.shop_template[arg1_64]

		if var1_64 and var1_64.effect_args and type(var1_64.effect_args) == "table" then
			for iter0_64, iter1_64 in ipairs(var1_64.effect_args) do
				if iter1_64 == 1 then
					var0_64 = "gold"
				end
			end
		end
	end

	local var2_64 = arg0_64.preAniName == "gold" or arg0_64.preAniName == "diamond"
	local var3_64 = var0_64 == "gold" or var0_64 == "diamond"
	local var4_64 = var2_64 and var3_64 or not var2_64

	var4_64 = var0_64 and arg0_64.preAniName ~= var0_64 and var4_64

	if var4_64 then
		arg0_64.preAniName = var0_64

		arg0_64.live2dChar:TriggerAction(var0_64, nil, true)
	end

	return var4_64
end

function var0_0.playCV(arg0_65, arg1_65)
	local var0_65 = pg.pay_level_award[arg1_65]
	local var1_65

	if var0_65 and var0_65.cv_key ~= "" then
		var1_65 = "event:/cv/chargeShop/" .. var0_65.cv_key
	end

	if var1_65 then
		arg0_65:stopCV()

		arg0_65._currentVoice = var1_65

		pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1_65)
	end
end

function var0_0.stopCV(arg0_66)
	if arg0_66._currentVoice then
		pg.CriMgr.GetInstance():UnloadSoundEffect_V3(arg0_66._currentVoice)
	end

	arg0_66._currentVoice = nil
end

function var0_0.blurView(arg0_67)
	pg.LayerWeightMgr.GetInstance():Add2Overlay(LayerWeightConst.UI_TYPE_SUB, arg0_67.buttonList, {
		groupName = "shop",
		pbList = {
			arg0_67:findTF("leftBg", arg0_67.buttonList)
		}
	})
end

function var0_0.unBlurView(arg0_68)
	pg.LayerWeightMgr.GetInstance():DelFromOverlay(arg0_68.buttonList, arg0_68._tf)
end

function var0_0.jpUIInit(arg0_69)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	arg0_69.userAgreeBtn3 = arg0_69:findTF("frame/raw1Btn")
	arg0_69.userAgreeBtn4 = arg0_69:findTF("frame/raw2Btn")
end

function var0_0.jpUIEnter(arg0_70)
	if PLATFORM_CODE ~= PLATFORM_JP then
		return
	end

	onButton(arg0_70, arg0_70.userAgreeBtn3, function()
		local var0_71 = require("ShareCfg.UserAgreement3")

		arg0_70:emit(NewShopMainMediator.OPEN_USER_AGREE, var0_71 or "")
	end, SFX_PANEL)
	onButton(arg0_70, arg0_70.userAgreeBtn4, function()
		local var0_72 = require("ShareCfg.UserAgreement4")

		arg0_70:emit(NewShopMainMediator.OPEN_USER_AGREE, var0_72 or "")
	end, SFX_PANEL)
end

function var0_0.addRefreshTimer(arg0_73, arg1_73)
	local function var0_73()
		if arg0_73.refreshTimer then
			arg0_73.refreshTimer:Stop()

			arg0_73.refreshTimer = nil
		end
	end

	var0_73()

	arg0_73.refreshTimer = Timer.New(function()
		if arg1_73 + 1 - pg.TimeMgr.GetInstance():GetServerTime() <= 0 then
			var0_73()
			arg0_73:emit(NewShopMainMediator.GET_CHARGE_LIST)
		end
	end, 1, -1)

	arg0_73.refreshTimer:Start()
	arg0_73.refreshTimer.func()
end

function var0_0.checkFreeGiftTag(arg0_76)
	TagTipHelper.FreeGiftTag({
		arg0_76.giftTip
	})
end

return var0_0
