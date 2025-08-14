local var0_0 = class("ActivityShopPage", import(".BaseShopPage"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)

	arg0_1.scrollRectSpecial = scrollRectSpecial
end

function var0_0.GetPaintingName(arg0_2)
	assert(arg0_2.shop)

	local var0_2 = pg.activity_template[arg0_2.shop.activityId]
	local var1_2 = getProxy(ActivityProxy):checkHxActivity(arg0_2.shop.activityId)

	if var0_2 and var0_2.config_client then
		if var0_2.config_client.use_secretary or var1_2 then
			local var2_2 = getProxy(PlayerProxy):getData()
			local var3_2 = getProxy(SettingsProxy):getCurrentSecretaryIndex()

			arg0_2.tempFlagShip = getProxy(BayProxy):getShipById(var2_2.characters[1])

			return arg0_2.tempFlagShip:getPainting(), true, "build"
		elseif var0_2.config_client.painting then
			return var0_2.config_client.painting, true
		end
	end

	return "aijiang_pt"
end

function var0_0.GetBg(arg0_3, arg1_3)
	return (arg1_3:getBgPath())
end

function var0_0.GetPaintingEnterVoice(arg0_4)
	local var0_4, var1_4, var2_4 = arg0_4.shop:GetEnterVoice()

	return var1_4, var0_4, var2_4
end

function var0_0.GetPaintingCommodityUpdateVoice(arg0_5)
	local var0_5, var1_5, var2_5 = arg0_5.shop:GetPurchaseVoice()

	return var1_5, var0_5, var2_5
end

function var0_0.GetPaintingAllPurchaseVoice(arg0_6)
	local var0_6, var1_6, var2_6 = arg0_6.shop:GetPurchaseAllVoice()

	return var1_6, var0_6, var2_6
end

function var0_0.GetPaintingTouchVoice(arg0_7)
	local var0_7, var1_7, var2_7 = arg0_7.shop:GetTouchVoice()

	return var1_7, var0_7, var2_7
end

function var0_0.init(arg0_8)
	var0_0.super.init(arg0_8)

	if arg0_8.scrollRectSpecial then
		arg0_8.groupList = UIItemList.New(arg0_8:findTF("viewport/view", arg0_8.scrollRectSpecial), arg0_8:findTF("viewport/view/group", arg0_8.scrollRectSpecial))
	end
end

function var0_0.OnInit(arg0_9)
	return
end

function var0_0.OnUpdatePlayer(arg0_10)
	arg0_10:RefreshResItemList()
end

function var0_0.GetResDataList(arg0_11)
	local var0_11 = {}
	local var1_11 = arg0_11.shop:GetResList()

	for iter0_11, iter1_11 in ipairs(var1_11) do
		local var2_11 = arg0_11.player:getResource(iter1_11)

		table.insert(var0_11, {
			type = DROP_TYPE_RESOURCE,
			resID = iter1_11,
			cnt = var2_11
		})
	end

	return var0_11
end

function var0_0.OnSetUp(arg0_12)
	arg0_12:SetResIcon()
	arg0_12:UpdateTip()
end

function var0_0.OnUpdateAll(arg0_13)
	arg0_13:InitCommodities()
end

function var0_0.OnUpdateCommodity(arg0_14, arg1_14)
	local var0_14

	for iter0_14, iter1_14 in pairs(arg0_14.cards) do
		if iter1_14.goodsVO.id == arg1_14.id then
			var0_14 = iter1_14

			break
		end
	end

	if var0_14 then
		local var1_14, var2_14, var3_14 = arg0_14.shop:getBgPath()

		var0_14:update(arg1_14, nil, var2_14, var3_14)
	end
end

function var0_0.SetResIcon(arg0_15, arg1_15)
	arg0_15:RefreshResItemList()
end

function var0_0.RefreshUI(arg0_16)
	setActive(arg0_16.tipTextGo, true)
	setActive(arg0_16.helpBtn, false)
	setActive(arg0_16.resolveBtn, false)
	setActive(arg0_16.refreshBtn, false)
end

function var0_0.UpdateTip(arg0_17)
	local var0_17 = #arg0_17.shop:GetResList() > 1 and 25 or 27

	arg0_17.tipText.text = "<size=" .. var0_17 .. ">" .. i18n("activity_shop_lable", arg0_17.shop:getOpenTime()) .. "</size>"
end

function var0_0.OnInitItem(arg0_18, arg1_18)
	local var0_18 = ActivityGoodsCard.New(arg1_18)

	var0_18.tagImg.raycastTarget = false

	onButton(arg0_18, var0_18.tf, function()
		arg0_18:OnClickCommodity(var0_18.goodsVO, function(arg0_20, arg1_20)
			arg0_18:OnPurchase(arg0_20, arg1_20)
		end)
	end, SFX_PANEL)

	arg0_18.cards[arg1_18] = var0_18
end

function var0_0.OnUpdateItem(arg0_21, arg1_21, arg2_21)
	local var0_21 = arg0_21.cards[arg2_21]

	if not var0_21 then
		arg0_21:OnInitItem(arg2_21)

		var0_21 = arg0_21.cards[arg2_21]
	end

	local var1_21 = arg0_21.displays[arg1_21 + 1]
	local var2_21, var3_21, var4_21 = arg0_21.shop:getBgPath()

	var0_21:update(var1_21, nil, var3_21, var4_21)
end

function var0_0.TipPurchase(arg0_22, arg1_22, arg2_22, arg3_22, arg4_22)
	local var0_22, var1_22 = arg1_22:GetTranCntWhenFull(arg2_22)

	if var0_22 > 0 then
		local var2_22 = math.max(arg2_22 - var0_22, 0)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pt_shop_tran_tip", var2_22, arg3_22, var0_22 * var1_22.count, var1_22:getConfig("name")),
			onYes = arg4_22
		})
	else
		arg4_22()
	end
end

function var0_0.OnPurchase(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23:getConfig("commodity_type")
	local var1_23 = arg1_23:getConfig("commodity_id")

	if var0_23 == DROP_TYPE_ITEM then
		local var2_23 = getProxy(BagProxy):RawGetItemById(var1_23)

		if var2_23 and var2_23:IsShipExpType() and var2_23:IsMaxCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("item_is_max_cnt"))

			return
		end
	end

	local var3_23 = arg0_23.shop.activityId

	arg0_23:emit(NewShopMainMediator.ON_ACT_SHOPPING, var3_23, 1, arg1_23.id, arg2_23)
end

function var0_0.OnClickCommodity(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg1_24:CheckCntLimit()

	if not var0_24 then
		return
	end

	if var0_24 and not arg1_24:CheckArgLimit() then
		local var1_24, var2_24, var3_24, var4_24 = arg1_24:CheckArgLimit()

		if var2_24 == ShopArgs.LIMIT_ARGS_META_SHIP_EXISTENCE then
			local var5_24 = ShipGroup.getDefaultShipConfig(var4_24) or {}

			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_shop_exchange_limit_tip", var5_24.name or ""))
		elseif var2_24 == ShopArgs.LIMIT_ARGS_SALE_START_TIME then
			local var6_24 = {
				year = var4_24[1][1],
				month = var4_24[1][2],
				day = var4_24[1][3],
				hour = var4_24[2][1],
				min = var4_24[2][2],
				sec = var4_24[2][3]
			}

			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_shop_exchange_limit_2_tip", var6_24.year, var6_24.month, var6_24.day, var6_24.hour, var6_24.min, var6_24.sec))
		end

		return
	end

	var0_0.super.OnClickCommodity(arg0_24, arg1_24, arg2_24)
end

function var0_0.Show(arg0_25)
	local var0_25 = pg.activity_template[arg0_25.shop.activityId]

	if var0_25 and var0_25.config_client and var0_25.config_client.category then
		print("TODO:当前的界面不支持这中情况，需要找美术出资源")
		setActive(go(arg0_25.lScrollrect), false)
		setActive(arg0_25.scrollRectSpecial, true)
		arg0_25.groupList:make(function(arg0_26, arg1_26, arg2_26)
			if arg0_26 == UIItemList.EventUpdate then
				local var0_26 = arg0_25.splitCommodities[arg1_26 + 1]

				setText(arg2_26:Find("title/name"), i18n(arg0_25.spiltNameCodes[arg1_26 + 1]))

				local var1_26 = UIItemList.New(arg2_26:Find("items"), arg2_26:Find("items/ActivityShopTpl"))

				var1_26:make(function(arg0_27, arg1_27, arg2_27)
					if arg0_27 == UIItemList.EventUpdate then
						local var0_27 = ActivityGoodsCard.New(arg2_27)

						arg0_25.cards[arg2_27] = var0_27
						var0_27.tagImg.raycastTarget = false

						onButton(arg0_25, var0_27.tf, function()
							arg0_25:OnClickCommodity(var0_27.goodsVO, function(arg0_29, arg1_29)
								arg0_25:OnPurchase(arg0_29, arg1_29)
							end)
						end, SFX_PANEL)

						local var1_27 = var0_26[arg1_27 + 1]
						local var2_27, var3_27, var4_27 = arg0_25.shop:getBgPath()

						var0_27:update(var1_27, nil, var3_27, var4_27)
					end
				end)
				var1_26:align(#var0_26)
			end
		end)
		arg0_25.groupList:align(#arg0_25.splitCommodities)

		arg0_25.canvasGroup.alpha = 1
		arg0_25.canvasGroup.blocksRaycasts = true

		arg0_25:ShowOrHideResUI(true)
	else
		setActive(go(arg0_25.lScrollrect), true)

		if arg0_25.scrollRectSpecial then
			setActive(arg0_25.scrollRectSpecial, false)
		end

		var0_0.super.Show(arg0_25)
	end

	if arg0_25.shop:GetBGM() ~= "" then
		pg.BgmMgr.GetInstance():Push(arg0_25.__cname, arg0_25.shop:GetBGM())
	end
end

function var0_0.Hide(arg0_30)
	local var0_30 = pg.activity_template[arg0_30.shop.activityId]

	if var0_30 and var0_30.config_client and var0_30.config_client.category then
		for iter0_30, iter1_30 in pairs(arg0_30.cards) do
			iter1_30:Dispose()
		end

		arg0_30.splitCommodities = {}
		arg0_30.spiltNameCodes = {}
		arg0_30.cards = {}
		arg0_30.canvasGroup.alpha = 0
		arg0_30.canvasGroup.blocksRaycasts = false

		arg0_30:ShowOrHideResUI(false)
	else
		var0_0.super.Hide(arg0_30)
	end

	setActive(go(arg0_30.lScrollrect), true)

	if arg0_30.scrollRectSpecial then
		setActive(arg0_30.scrollRectSpecial, false)
	end

	if arg0_30.shop:GetBGM() ~= "" then
		pg.BgmMgr.GetInstance():Pop(arg0_30.__cname)
	end
end

function var0_0.SetUp(arg0_31, arg1_31, arg2_31, arg3_31)
	arg0_31:SetShop(arg1_31)
	arg0_31:InitCommodities()

	arg0_31.cards = {}

	arg0_31:Show()
	arg0_31:SetPlayer(arg2_31)
	arg0_31:SetItems(arg3_31)
	arg0_31:InitCommodities()
	arg0_31:OnSetUp()
	arg0_31:SetPainting()
	arg0_31:RefreshUI()
end

function var0_0.InitCommodities(arg0_32)
	local var0_32 = pg.activity_template[arg0_32.shop.activityId]

	if var0_32 and var0_32.config_client and var0_32.config_client.category then
		arg0_32.splitCommodities = arg0_32.shop:GetSplitCommodities()
		arg0_32.spiltNameCodes = arg0_32.shop:GetSplitNameCodes()

		arg0_32.groupList:align(#arg0_32.splitCommodities)
	else
		var0_0.super.InitCommodities(arg0_32)
	end
end

return var0_0
