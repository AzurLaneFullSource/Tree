local var0 = class("ActivityShopPage", import(".BaseShopPage"))

function var0.getUIName(arg0)
	return "ActivityShop"
end

function var0.GetPaintingName(arg0)
	assert(arg0.shop)

	local var0 = pg.activity_template[arg0.shop.activityId]
	local var1 = getProxy(ActivityProxy):checkHxActivity(arg0.shop.activityId)

	if var0 and var0.config_client then
		if var0.config_client.use_secretary or var1 then
			local var2 = getProxy(PlayerProxy):getData()
			local var3 = getProxy(SettingsProxy):getCurrentSecretaryIndex()

			arg0.tempFlagShip = getProxy(BayProxy):getShipById(var2.characters[1])

			return arg0.tempFlagShip:getPainting(), true, "build"
		elseif var0.config_client.painting then
			return var0.config_client.painting
		end
	end

	return "aijiang_pt"
end

function var0.GetBg(arg0, arg1)
	return (arg1:getBgPath())
end

function var0.GetPaintingEnterVoice(arg0)
	local var0, var1, var2 = arg0.shop:GetEnterVoice()

	return var1, var0, var2
end

function var0.GetPaintingCommodityUpdateVoice(arg0)
	local var0, var1, var2 = arg0.shop:GetPurchaseVoice()

	return var1, var0, var2
end

function var0.GetPaintingAllPurchaseVoice(arg0)
	local var0, var1, var2 = arg0.shop:GetPurchaseAllVoice()

	return var1, var0, var2
end

function var0.GetPaintingTouchVoice(arg0)
	local var0, var1, var2 = arg0.shop:GetTouchVoice()

	return var1, var0, var2
end

function var0.OnLoaded(arg0)
	local var0 = arg0:findTF("res_battery"):GetComponent(typeof(Image))
	local var1 = arg0:findTF("res_battery/icon"):GetComponent(typeof(Image))
	local var2 = arg0:findTF("res_battery/Text"):GetComponent(typeof(Text))
	local var3 = arg0:findTF("res_battery/label"):GetComponent(typeof(Text))
	local var4 = arg0:findTF("res_battery1"):GetComponent(typeof(Image))
	local var5 = arg0:findTF("res_battery1/icon"):GetComponent(typeof(Image))
	local var6 = arg0:findTF("res_battery1/Text"):GetComponent(typeof(Text))
	local var7 = arg0:findTF("res_battery1/label"):GetComponent(typeof(Text))

	arg0.resTrList = {
		{
			var0,
			var1,
			var2,
			var3
		},
		{
			var4,
			var5,
			var6,
			var7
		}
	}
	arg0.eventResCnt = arg0:findTF("event_res_battery/Text"):GetComponent(typeof(Text))
	arg0.time = arg0:findTF("Text"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	return
end

function var0.OnUpdatePlayer(arg0)
	if arg0.shop:IsEventShop() then
		local var0 = arg0.shop:getResId()

		arg0.eventResCnt.text = arg0.player:getResource(var0)
	else
		local var1 = arg0.shop:GetResList()

		for iter0, iter1 in pairs(arg0.resTrList) do
			local var2 = iter1[1]
			local var3 = iter1[2]
			local var4 = iter1[3]
			local var5 = var1[iter0]

			setActive(var2, var5 ~= nil)

			if var5 ~= nil then
				var4.text = arg0.player:getResource(var5)
			end
		end
	end
end

function var0.OnSetUp(arg0)
	arg0:SetResIcon()
	arg0:UpdateTip()
end

function var0.OnUpdateAll(arg0)
	arg0:InitCommodities()
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
		local var1, var2, var3 = arg0.shop:getBgPath()

		var0:update(arg1, nil, var2, var3)
	end
end

function var0.SetResIcon(arg0, arg1)
	local var0 = arg0.shop:GetResList()

	for iter0, iter1 in ipairs(arg0.resTrList) do
		local var1 = iter1[1]
		local var2 = iter1[2]
		local var3 = iter1[3]
		local var4 = iter1[4]
		local var5 = var0[iter0]

		if var5 ~= nil then
			local var6 = Drop.New({
				type = arg1 or DROP_TYPE_RESOURCE,
				id = var5
			})

			GetSpriteFromAtlasAsync(var6:getIcon(), "", function(arg0)
				var2.sprite = arg0
			end)

			var4.text = var6:getName()
		end
	end

	local var7 = arg0.shop:IsEventShop()

	setActive(arg0:findTF("res_battery"), not var7)
	setActive(arg0:findTF("res_battery1"), not var7 and #var0 > 1)
	setActive(arg0:findTF("event_res_battery"), var7)
end

function var0.UpdateTip(arg0)
	local var0 = #arg0.shop:GetResList() > 1 and 25 or 27

	arg0.time.text = "<size=" .. var0 .. ">" .. i18n("activity_shop_lable", arg0.shop:getOpenTime()) .. "</size>"
end

function var0.OnInitItem(arg0, arg1)
	local var0 = ActivityGoodsCard.New(arg1)

	var0.tagImg.raycastTarget = false

	onButton(arg0, var0.tr, function()
		arg0:OnClickCommodity(var0.goodsVO, function(arg0, arg1)
			arg0:OnPurchase(arg0, arg1)
		end)
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
	local var2, var3, var4 = arg0.shop:getBgPath()

	var0:update(var1, nil, var3, var4)
end

function var0.TipPurchase(arg0, arg1, arg2, arg3, arg4)
	local var0, var1 = arg1:GetTranCntWhenFull(arg2)

	if var0 > 0 then
		local var2 = math.max(arg2 - var0, 0)

		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			content = i18n("pt_shop_tran_tip", var2, arg3, var0 * var1.count, var1:getConfig("name")),
			onYes = arg4
		})
	else
		arg4()
	end
end

function var0.OnPurchase(arg0, arg1, arg2)
	local var0 = arg1:getConfig("commodity_type")
	local var1 = arg1:getConfig("commodity_id")

	if var0 == DROP_TYPE_ITEM then
		local var2 = getProxy(BagProxy):RawGetItemById(var1)

		if var2 and var2:IsShipExpType() and var2:IsMaxCnt() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("item_is_max_cnt"))

			return
		end
	end

	local var3 = arg0.shop.activityId

	arg0:emit(NewShopsMediator.ON_ACT_SHOPPING, var3, 1, arg1.id, arg2)
	arg0:emit(NewShopsMediator.UR_EXCHANGE_TRACKING, var1)
end

function var0.OnClickCommodity(arg0, arg1, arg2)
	local var0 = arg1:CheckCntLimit()

	if not var0 then
		return
	end

	if var0 and not arg1:CheckArgLimit() then
		local var1, var2, var3, var4 = arg1:CheckArgLimit()

		if var2 == ShopArgs.LIMIT_ARGS_META_SHIP_EXISTENCE then
			local var5 = ShipGroup.getDefaultShipConfig(var4) or {}

			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_shop_exchange_limit_tip", var5.name or ""))
		elseif var2 == ShopArgs.LIMIT_ARGS_SALE_START_TIME then
			local var6 = {
				year = var4[1][1],
				month = var4[1][2],
				day = var4[1][3],
				hour = var4[2][1],
				min = var4[2][2],
				sec = var4[2][3]
			}

			pg.TipsMgr.GetInstance():ShowTips(i18n("meta_shop_exchange_limit_2_tip", var6.year, var6.month, var6.day, var6.hour, var6.min, var6.sec))
		end

		return
	end

	var0.super.OnClickCommodity(arg0, arg1, arg2)
end

function var0.Show(arg0)
	var0.super.Show(arg0)

	if arg0.shop:GetBGM() ~= "" then
		pg.BgmMgr.GetInstance():Push(arg0.__cname, arg0.shop:GetBGM())
	end
end

function var0.Hide(arg0)
	var0.super.Hide(arg0)

	if arg0.shop:GetBGM() ~= "" then
		pg.BgmMgr.GetInstance():Pop(arg0.__cname)
	end
end

return var0
