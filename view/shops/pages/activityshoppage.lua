local var0_0 = class("ActivityShopPage", import(".BaseShopPage"))

function var0_0.getUIName(arg0_1)
	return "ActivityShop"
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
			return var0_2.config_client.painting
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

function var0_0.OnLoaded(arg0_8)
	local var0_8 = arg0_8:findTF("res_battery"):GetComponent(typeof(Image))
	local var1_8 = arg0_8:findTF("res_battery/icon"):GetComponent(typeof(Image))
	local var2_8 = arg0_8:findTF("res_battery/Text"):GetComponent(typeof(Text))
	local var3_8 = arg0_8:findTF("res_battery/label"):GetComponent(typeof(Text))
	local var4_8 = arg0_8:findTF("res_battery1"):GetComponent(typeof(Image))
	local var5_8 = arg0_8:findTF("res_battery1/icon"):GetComponent(typeof(Image))
	local var6_8 = arg0_8:findTF("res_battery1/Text"):GetComponent(typeof(Text))
	local var7_8 = arg0_8:findTF("res_battery1/label"):GetComponent(typeof(Text))

	arg0_8.resTrList = {
		{
			var0_8,
			var1_8,
			var2_8,
			var3_8
		},
		{
			var4_8,
			var5_8,
			var6_8,
			var7_8
		}
	}
	arg0_8.eventResCnt = arg0_8:findTF("event_res_battery/Text"):GetComponent(typeof(Text))
	arg0_8.time = arg0_8:findTF("Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_9)
	return
end

function var0_0.OnUpdatePlayer(arg0_10)
	if arg0_10.shop:IsEventShop() then
		local var0_10 = arg0_10.shop:getResId()

		arg0_10.eventResCnt.text = arg0_10.player:getResource(var0_10)
	else
		local var1_10 = arg0_10.shop:GetResList()

		for iter0_10, iter1_10 in pairs(arg0_10.resTrList) do
			local var2_10 = iter1_10[1]
			local var3_10 = iter1_10[2]
			local var4_10 = iter1_10[3]
			local var5_10 = var1_10[iter0_10]

			setActive(var2_10, var5_10 ~= nil)

			if var5_10 ~= nil then
				var4_10.text = arg0_10.player:getResource(var5_10)
			end
		end
	end
end

function var0_0.OnSetUp(arg0_11)
	arg0_11:SetResIcon()
	arg0_11:UpdateTip()
end

function var0_0.OnUpdateAll(arg0_12)
	arg0_12:InitCommodities()
end

function var0_0.OnUpdateCommodity(arg0_13, arg1_13)
	local var0_13

	for iter0_13, iter1_13 in pairs(arg0_13.cards) do
		if iter1_13.goodsVO.id == arg1_13.id then
			var0_13 = iter1_13

			break
		end
	end

	if var0_13 then
		local var1_13, var2_13, var3_13 = arg0_13.shop:getBgPath()

		var0_13:update(arg1_13, nil, var2_13, var3_13)
	end
end

function var0_0.SetResIcon(arg0_14, arg1_14)
	local var0_14 = arg0_14.shop:GetResList()

	for iter0_14, iter1_14 in ipairs(arg0_14.resTrList) do
		local var1_14 = iter1_14[1]
		local var2_14 = iter1_14[2]
		local var3_14 = iter1_14[3]
		local var4_14 = iter1_14[4]
		local var5_14 = var0_14[iter0_14]

		if var5_14 ~= nil then
			local var6_14 = Drop.New({
				type = arg1_14 or DROP_TYPE_RESOURCE,
				id = var5_14
			})

			GetSpriteFromAtlasAsync(var6_14:getIcon(), "", function(arg0_15)
				var2_14.sprite = arg0_15
			end)

			var4_14.text = var6_14:getName()
		end
	end

	local var7_14 = arg0_14.shop:IsEventShop()

	setActive(arg0_14:findTF("res_battery"), not var7_14)
	setActive(arg0_14:findTF("res_battery1"), not var7_14 and #var0_14 > 1)
	setActive(arg0_14:findTF("event_res_battery"), var7_14)
end

function var0_0.UpdateTip(arg0_16)
	local var0_16 = #arg0_16.shop:GetResList() > 1 and 25 or 27

	arg0_16.time.text = "<size=" .. var0_16 .. ">" .. i18n("activity_shop_lable", arg0_16.shop:getOpenTime()) .. "</size>"
end

function var0_0.OnInitItem(arg0_17, arg1_17)
	local var0_17 = ActivityGoodsCard.New(arg1_17)

	var0_17.tagImg.raycastTarget = false

	onButton(arg0_17, var0_17.tr, function()
		arg0_17:OnClickCommodity(var0_17.goodsVO, function(arg0_19, arg1_19)
			arg0_17:OnPurchase(arg0_19, arg1_19)
		end)
	end, SFX_PANEL)

	arg0_17.cards[arg1_17] = var0_17
end

function var0_0.OnUpdateItem(arg0_20, arg1_20, arg2_20)
	local var0_20 = arg0_20.cards[arg2_20]

	if not var0_20 then
		arg0_20:OnInitItem(arg2_20)

		var0_20 = arg0_20.cards[arg2_20]
	end

	local var1_20 = arg0_20.displays[arg1_20 + 1]
	local var2_20, var3_20, var4_20 = arg0_20.shop:getBgPath()

	var0_20:update(var1_20, nil, var3_20, var4_20)
end

function var0_0.TipPurchase(arg0_21, arg1_21, arg2_21, arg3_21, arg4_21)
	local var0_21, var1_21 = arg1_21:GetTranCntWhenFull(arg2_21)

	if var0_21 > 0 then
		local var2_21 = math.max(arg2_21 - var0_21, 0)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pt_shop_tran_tip", var2_21, arg3_21, var0_21 * var1_21.count, var1_21:getConfig("name")),
			onYes = arg4_21
		})
	else
		arg4_21()
	end
end

function var0_0.OnPurchase(arg0_22, arg1_22, arg2_22)
	local var0_22 = arg1_22:getConfig("commodity_type")
	local var1_22 = arg1_22:getConfig("commodity_id")

	if var0_22 == DROP_TYPE_ITEM then
		local var2_22 = getProxy(BagProxy):RawGetItemById(var1_22)

		if var2_22 and var2_22:IsShipExpType() and var2_22:IsMaxCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("item_is_max_cnt"))

			return
		end
	end

	local var3_22 = arg0_22.shop.activityId

	arg0_22:emit(NewShopsMediator.ON_ACT_SHOPPING, var3_22, 1, arg1_22.id, arg2_22)
	arg0_22:emit(NewShopsMediator.UR_EXCHANGE_TRACKING, var1_22)
end

function var0_0.OnClickCommodity(arg0_23, arg1_23, arg2_23)
	local var0_23 = arg1_23:CheckCntLimit()

	if not var0_23 then
		return
	end

	if var0_23 and not arg1_23:CheckArgLimit() then
		local var1_23, var2_23, var3_23, var4_23 = arg1_23:CheckArgLimit()

		if var2_23 == ShopArgs.LIMIT_ARGS_META_SHIP_EXISTENCE then
			local var5_23 = ShipGroup.getDefaultShipConfig(var4_23) or {}

			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_shop_exchange_limit_tip", var5_23.name or ""))
		elseif var2_23 == ShopArgs.LIMIT_ARGS_SALE_START_TIME then
			local var6_23 = {
				year = var4_23[1][1],
				month = var4_23[1][2],
				day = var4_23[1][3],
				hour = var4_23[2][1],
				min = var4_23[2][2],
				sec = var4_23[2][3]
			}

			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_shop_exchange_limit_2_tip", var6_23.year, var6_23.month, var6_23.day, var6_23.hour, var6_23.min, var6_23.sec))
		end

		return
	end

	var0_0.super.OnClickCommodity(arg0_23, arg1_23, arg2_23)
end

function var0_0.Show(arg0_24)
	var0_0.super.Show(arg0_24)

	if arg0_24.shop:GetBGM() ~= "" then
		pg.BgmMgr.GetInstance():Push(arg0_24.__cname, arg0_24.shop:GetBGM())
	end
end

function var0_0.Hide(arg0_25)
	var0_0.super.Hide(arg0_25)

	if arg0_25.shop:GetBGM() ~= "" then
		pg.BgmMgr.GetInstance():Pop(arg0_25.__cname)
	end
end

return var0_0
