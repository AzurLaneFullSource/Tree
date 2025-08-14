local var0_0 = class("QuotaShopPage", import(".BaseShopPage"))

function var0_0.GetPaintingCommodityUpdateVoice(arg0_1)
	return
end

function var0_0.CanOpen(arg0_2, arg1_2, arg2_2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2_2.level, "QuotaShop")
end

function var0_0.RefreshUI(arg0_3)
	arg0_3:UpdateTip()
	setActive(arg0_3.tipTextGo, true)
	setActive(arg0_3.helpBtn, false)
	setActive(arg0_3.resolveBtn, false)
	setActive(arg0_3.refreshBtn, false)
end

function var0_0.UpdateTip(arg0_4)
	setText(arg0_4.tipText, i18n("quota_shop_description"))
end

function var0_0.OnUpdateItems(arg0_5)
	arg0_5:RefreshResItemList()
end

function var0_0.GetResDataList(arg0_6)
	local var0_6 = {}
	local var1_6 = arg0_6.shop:GetResList()

	for iter0_6, iter1_6 in ipairs(var1_6) do
		local var2_6
		local var3_6 = arg0_6.items[ChapterConst.ShamMoneyItem]
		local var4_6 = not var3_6 and 0 or var3_6.count

		table.insert(var0_6, {
			type = DROP_TYPE_ITEM,
			resID = iter1_6,
			cnt = var4_6
		})
	end

	return var0_6
end

function var0_0.OnUpdateCommodity(arg0_7, arg1_7)
	local var0_7

	for iter0_7, iter1_7 in pairs(arg0_7.cards) do
		if iter1_7.goodsVO.id == arg1_7.id then
			var0_7 = iter1_7

			break
		end
	end

	if var0_7 then
		var0_7:update(arg1_7)
	end
end

function var0_0.OnInitItem(arg0_8, arg1_8)
	local var0_8 = QuotaGoodsCard.New(arg1_8)

	onButton(arg0_8, var0_8.tf, function()
		if not var0_8.goodsVO:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

		arg0_8:OnClickCommodity(var0_8.goodsVO, function(arg0_10, arg1_10)
			arg0_8:OnPurchase(arg0_10, arg1_10)
		end)
	end, SFX_PANEL)

	arg0_8.cards[arg1_8] = var0_8
end

function var0_0.OnUpdateItem(arg0_11, arg1_11, arg2_11)
	local var0_11 = arg0_11.cards[arg2_11]

	if not var0_11 then
		arg0_11:OnInitItem(arg2_11)

		var0_11 = arg0_11.cards[arg2_11]
	end

	local var1_11 = arg0_11.displays[arg1_11 + 1]

	var0_11:update(var1_11)
end

function var0_0.OnUpdateAll(arg0_12)
	arg0_12:InitCommodities()
end

function var0_0.OnPurchase(arg0_13, arg1_13, arg2_13)
	arg0_13:emit(NewShopMainMediator.ON_QUOTA_SHOPPING, arg1_13.id, arg2_13)
end

function var0_0.OnDestroy(arg0_14)
	var0_0.super.OnDestroy(arg0_14)
end

return var0_0
