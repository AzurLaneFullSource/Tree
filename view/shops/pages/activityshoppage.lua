local var0_0 = class("ActivityShopPage", import(".BaseShopPage"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
end

function var0_0.getBGM(arg0_2)
	return string.format("ActivityShop%s", arg0_2.shop.activityId)
end

function var0_0.GetPaintingName(arg0_3)
	assert(arg0_3.shop)

	local var0_3 = pg.activity_template[arg0_3.shop.activityId]
	local var1_3 = getProxy(ActivityProxy):checkHxActivity(arg0_3.shop.activityId)

	if var0_3 and var0_3.config_client then
		if var0_3.config_client.use_secretary or var1_3 then
			local var2_3 = getProxy(PlayerProxy):getData()
			local var3_3 = getProxy(SettingsProxy):getCurrentSecretaryIndex()

			arg0_3.tempFlagShip = getProxy(BayProxy):getShipById(var2_3.characters[1])

			return arg0_3.tempFlagShip:getPainting(), true, "build"
		elseif var0_3.config_client.painting then
			return var0_3.config_client.painting, true
		end
	end

	return "aijiang_pt"
end

function var0_0.GetBg(arg0_4, arg1_4)
	return (arg1_4:getBgPath())
end

function var0_0.GetPaintingEnterVoice(arg0_5)
	local var0_5, var1_5, var2_5 = arg0_5.shop:GetEnterVoice()

	return var1_5, var0_5, var2_5
end

function var0_0.GetPaintingCommodityUpdateVoice(arg0_6)
	local var0_6, var1_6, var2_6 = arg0_6.shop:GetPurchaseVoice()

	return var1_6, var0_6, var2_6
end

function var0_0.GetPaintingAllPurchaseVoice(arg0_7)
	local var0_7, var1_7, var2_7 = arg0_7.shop:GetPurchaseAllVoice()

	return var1_7, var0_7, var2_7
end

function var0_0.GetPaintingTouchVoice(arg0_8)
	local var0_8, var1_8, var2_8 = arg0_8.shop:GetTouchVoice()

	return var1_8, var0_8, var2_8
end

function var0_0.init(arg0_9)
	var0_0.super.init(arg0_9)

	arg0_9.scrollRectSpecial = arg0_9:findTF("scrollRectSpecial")
	arg0_9.groupList = UIItemList.New(arg0_9:findTF("viewport/view", arg0_9.scrollRectSpecial), arg0_9:findTF("viewport/view/group", arg0_9.scrollRectSpecial))
end

function var0_0.OnInit(arg0_10)
	return
end

function var0_0.OnUpdatePlayer(arg0_11)
	arg0_11:RefreshResItemList()
end

function var0_0.GetResDataList(arg0_12)
	local var0_12 = {}
	local var1_12 = arg0_12.shop:GetResList()

	for iter0_12, iter1_12 in ipairs(var1_12) do
		local var2_12 = arg0_12.player:getResource(iter1_12)

		table.insert(var0_12, {
			type = DROP_TYPE_RESOURCE,
			resID = iter1_12,
			cnt = var2_12
		})
	end

	return var0_12
end

function var0_0.OnSetUp(arg0_13)
	arg0_13:SetResIcon()
	arg0_13:UpdateTip()
end

function var0_0.OnUpdateAll(arg0_14)
	arg0_14:InitCommodities()
end

function var0_0.OnUpdateCommodity(arg0_15, arg1_15)
	local var0_15

	for iter0_15, iter1_15 in pairs(arg0_15.cards) do
		if iter1_15.goodsVO.id == arg1_15.id then
			var0_15 = iter1_15

			break
		end
	end

	if var0_15 then
		local var1_15, var2_15, var3_15 = arg0_15.shop:getBgPath()

		var0_15:update(arg1_15, nil, var2_15, var3_15)
	end
end

function var0_0.SetResIcon(arg0_16, arg1_16)
	arg0_16:RefreshResItemList()
end

function var0_0.RefreshUI(arg0_17)
	setActive(arg0_17.tipTextGo, true)
	setActive(arg0_17.helpBtn, false)
	setActive(arg0_17.resolveBtn, false)
	setActive(arg0_17.refreshBtn, false)
end

function var0_0.UpdateTip(arg0_18)
	local var0_18 = #arg0_18.shop:GetResList() > 1 and 25 or 27

	arg0_18.tipText.text = "<size=" .. var0_18 .. ">" .. i18n("activity_shop_lable", arg0_18.shop:getOpenTime()) .. "</size>"
end

function var0_0.OnInitItem(arg0_19, arg1_19)
	local var0_19 = ActivityGoodsCard.New(arg1_19)

	onButton(arg0_19, var0_19.tf, function()
		arg0_19:OnClickCommodity(var0_19.goodsVO, function(arg0_21, arg1_21)
			arg0_19:OnPurchase(arg0_21, arg1_21)
		end)
	end, SFX_PANEL)

	arg0_19.cards[arg1_19] = var0_19
end

function var0_0.OnUpdateItem(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg0_22.cards[arg2_22]

	if not var0_22 then
		arg0_22:OnInitItem(arg2_22)

		var0_22 = arg0_22.cards[arg2_22]
	end

	local var1_22 = arg0_22.displays[arg1_22 + 1]
	local var2_22, var3_22, var4_22 = arg0_22.shop:getBgPath()

	var0_22:update(var1_22, nil, var3_22, var4_22)
end

function var0_0.TipPurchase(arg0_23, arg1_23, arg2_23, arg3_23, arg4_23)
	local var0_23, var1_23 = arg1_23:GetTranCntWhenFull(arg2_23)

	if var0_23 > 0 then
		local var2_23 = math.max(arg2_23 - var0_23, 0)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pt_shop_tran_tip", var2_23, arg3_23, var0_23 * var1_23.count, var1_23:getConfig("name")),
			onYes = arg4_23
		})
	else
		arg4_23()
	end
end

function var0_0.OnPurchase(arg0_24, arg1_24, arg2_24)
	local var0_24 = arg1_24:getConfig("commodity_type")
	local var1_24 = arg1_24:getConfig("commodity_id")

	if var0_24 == DROP_TYPE_ITEM then
		local var2_24 = getProxy(BagProxy):RawGetItemById(var1_24)

		if var2_24 and var2_24:IsShipExpType() and var2_24:IsMaxCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("item_is_max_cnt"))

			return
		end
	end

	local var3_24 = arg0_24.shop.activityId

	arg0_24:emit(NewShopMainMediator.ON_ACT_SHOPPING, var3_24, 1, arg1_24.id, arg2_24)
end

function var0_0.OnClickCommodity(arg0_25, arg1_25, arg2_25)
	local var0_25 = arg1_25:CheckCntLimit()

	if not var0_25 then
		return
	end

	if var0_25 and not arg1_25:CheckArgLimit() then
		local var1_25, var2_25, var3_25, var4_25 = arg1_25:CheckArgLimit()

		if var2_25 == ShopArgs.LIMIT_ARGS_META_SHIP_EXISTENCE then
			local var5_25 = ShipGroup.getDefaultShipConfig(var4_25) or {}

			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_shop_exchange_limit_tip", var5_25.name or ""))
		elseif var2_25 == ShopArgs.LIMIT_ARGS_SALE_START_TIME then
			local var6_25 = {
				year = var4_25[1][1],
				month = var4_25[1][2],
				day = var4_25[1][3],
				hour = var4_25[2][1],
				min = var4_25[2][2],
				sec = var4_25[2][3]
			}

			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_shop_exchange_limit_2_tip", var6_25.year, var6_25.month, var6_25.day, var6_25.hour, var6_25.min, var6_25.sec))
		end

		return
	end

	var0_0.super.OnClickCommodity(arg0_25, arg1_25, arg2_25)
end

function var0_0.Show(arg0_26)
	local var0_26 = pg.activity_template[arg0_26.shop.activityId]

	if var0_26 and var0_26.config_client and var0_26.config_client.category then
		setActive(go(arg0_26.lScrollrect), false)
		setActive(arg0_26.scrollRectSpecial, true)
		arg0_26.groupList:make(function(arg0_27, arg1_27, arg2_27)
			if arg0_27 == UIItemList.EventUpdate then
				local var0_27 = arg0_26.splitCommodities[arg1_27 + 1]

				setText(arg2_27:Find("title/name"), i18n(arg0_26.spiltNameCodes[arg1_27 + 1]))

				local var1_27 = UIItemList.New(arg2_27:Find("items"), arg2_27:Find("items/ActivityShopNewTpl"))

				var1_27:make(function(arg0_28, arg1_28, arg2_28)
					if arg0_28 == UIItemList.EventUpdate then
						local var0_28 = ActivityGoodsCard.New(arg2_28)

						arg0_26.cards[arg2_28] = var0_28

						onButton(arg0_26, var0_28.tf, function()
							arg0_26:OnClickCommodity(var0_28.goodsVO, function(arg0_30, arg1_30)
								arg0_26:OnPurchase(arg0_30, arg1_30)
							end)
						end, SFX_PANEL)

						local var1_28 = var0_27[arg1_28 + 1]
						local var2_28, var3_28, var4_28 = arg0_26.shop:getBgPath()

						var0_28:update(var1_28, nil, var3_28, var4_28)
					end
				end)
				var1_27:align(#var0_27)
			end
		end)
		arg0_26.groupList:align(#arg0_26.splitCommodities)

		arg0_26.canvasGroup.alpha = 1
		arg0_26.canvasGroup.blocksRaycasts = true
	else
		setActive(go(arg0_26.lScrollrect), true)

		if arg0_26.scrollRectSpecial then
			setActive(arg0_26.scrollRectSpecial, false)
		end

		var0_0.super.Show(arg0_26)
	end

	if arg0_26.shop:GetBGM() ~= "" then
		pg.BgmMgr.GetInstance():Push(arg0_26.__cname, arg0_26.shop:GetBGM())
	end
end

function var0_0.Hide(arg0_31)
	local var0_31 = pg.activity_template[arg0_31.shop.activityId]

	if var0_31 and var0_31.config_client and var0_31.config_client.category then
		for iter0_31, iter1_31 in pairs(arg0_31.cards) do
			iter1_31:Dispose()
		end

		arg0_31.splitCommodities = {}
		arg0_31.spiltNameCodes = {}
		arg0_31.cards = {}
		arg0_31.canvasGroup.alpha = 0
		arg0_31.canvasGroup.blocksRaycasts = false
	else
		var0_0.super.Hide(arg0_31)
	end

	setActive(go(arg0_31.lScrollrect), true)

	if arg0_31.scrollRectSpecial then
		setActive(arg0_31.scrollRectSpecial, false)
	end

	if arg0_31.shop:GetBGM() ~= "" then
		pg.BgmMgr.GetInstance():Pop(arg0_31.__cname)
	end
end

function var0_0.SetUp(arg0_32, arg1_32, arg2_32, arg3_32)
	arg0_32:SetShop(arg1_32)
	arg0_32:InitCommodities()

	arg0_32.cards = {}

	arg0_32:Show()
	arg0_32:SetPlayer(arg2_32)
	arg0_32:SetItems(arg3_32)
	arg0_32:InitCommodities()
	arg0_32:OnSetUp()
	arg0_32:SetPainting()
	arg0_32:RefreshUI()
end

function var0_0.InitCommodities(arg0_33)
	local var0_33 = pg.activity_template[arg0_33.shop.activityId]

	if var0_33 and var0_33.config_client and var0_33.config_client.category then
		arg0_33.splitCommodities = arg0_33.shop:GetSplitCommodities()
		arg0_33.spiltNameCodes = arg0_33.shop:GetSplitNameCodes()

		arg0_33.groupList:align(#arg0_33.splitCommodities)
	else
		var0_0.super.InitCommodities(arg0_33)
	end
end

return var0_0
