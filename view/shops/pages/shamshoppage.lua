local var0_0 = class("ShamShopPage", import(".BaseShopPage"))

function var0_0.GetPaintingCommodityUpdateVoice(arg0_1)
	return
end

function var0_0.CanOpen(arg0_2, arg1_2, arg2_2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2_2.level, "ShamShop")
end

function var0_0.OnUpdateItems(arg0_3)
	arg0_3:RefreshResItemList()
end

function var0_0.GetResDataList(arg0_4)
	local var0_4 = {}
	local var1_4 = arg0_4.shop:GetResList()

	for iter0_4, iter1_4 in ipairs(var1_4) do
		local var2_4
		local var3_4 = arg0_4.items[ChapterConst.ShamMoneyItem]
		local var4_4 = not var3_4 and 0 or var3_4.count

		table.insert(var0_4, {
			type = DROP_TYPE_ITEM,
			resID = iter1_4,
			cnt = var4_4
		})
	end

	return var0_4
end

function var0_0.OnUpdateCommodity(arg0_5, arg1_5)
	local var0_5

	for iter0_5, iter1_5 in pairs(arg0_5.cards) do
		if iter1_5.goodsVO.id == arg1_5.id then
			var0_5 = iter1_5

			break
		end
	end

	if var0_5 then
		var0_5:update(arg1_5)
	end
end

function var0_0.RefreshUI(arg0_6)
	arg0_6:UpdateTip()
	setActive(arg0_6.tipTextGo, true)
	setActive(arg0_6.helpBtn, false)
	setActive(arg0_6.resolveBtn, false)
	setActive(arg0_6.refreshBtn, false)
end

function var0_0.OnInitItem(arg0_7, arg1_7)
	local var0_7 = ActivityGoodsCard.New(arg1_7)

	onButton(arg0_7, var0_7.tf, function()
		if not var0_7.goodsVO:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0_7:OnClickCommodity(var0_7.goodsVO, function(arg0_9, arg1_9)
			arg0_7:OnPurchase(arg0_9, arg1_9)
		end)
	end, SFX_PANEL)

	arg0_7.cards[arg1_7] = var0_7
end

function var0_0.OnUpdateItem(arg0_10, arg1_10, arg2_10)
	local var0_10 = arg0_10.cards[arg2_10]

	if not var0_10 then
		arg0_10:OnInitItem(arg2_10)

		var0_10 = arg0_10.cards[arg2_10]
	end

	local var1_10 = arg0_10.displays[arg1_10 + 1]

	var0_10:update(var1_10)
end

function var0_0.OnUpdateAll(arg0_11)
	arg0_11:InitCommodities()
	arg0_11:OnSetUp()
end

function var0_0.OnSetUp(arg0_12)
	arg0_12:UpdateTip()
end

function var0_0.UpdateTip(arg0_13)
	setText(arg0_13.tipText, i18n("title_limit_time") .. i18n("shops_rest_day") .. string.format("%02d", arg0_13.shop:getRestDays()) .. i18n("word_date"))
end

function var0_0.OnPurchase(arg0_14, arg1_14, arg2_14)
	arg0_14:emit(NewShopMainMediator.ON_SHAM_SHOPPING, arg1_14.id, arg2_14)
end

function var0_0.OnDestroy(arg0_15)
	var0_0.super.OnDestroy(arg0_15)
end

return var0_0
