local var0_0 = class("ShamShopPage", import(".BaseShopPage"))

function var0_0.getUIName(arg0_1)
	return "ShamShop"
end

function var0_0.GetPaintingCommodityUpdateVoice(arg0_2)
	return
end

function var0_0.CanOpen(arg0_3, arg1_3, arg2_3)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2_3.level, "ShamShop")
end

function var0_0.OnLoaded(arg0_4)
	arg0_4.dayTxt = arg0_4:findTF("time/day"):GetComponent(typeof(Text))
	arg0_4.nanoTxt = arg0_4:findTF("res_nano/Text"):GetComponent(typeof(Text))
end

function var0_0.OnInit(arg0_5)
	setText(arg0_5._tf:Find("time"), i18n("title_limit_time"))
	setText(arg0_5._tf:Find("time/text"), i18n("shops_rest_day"))
	setText(arg0_5._tf:Find("time/text_day"), i18n("word_date"))
end

function var0_0.OnUpdateItems(arg0_6)
	local var0_6 = arg0_6.items[ChapterConst.ShamMoneyItem]

	if not var0_6 then
		arg0_6.nanoTxt.text = 0
	else
		arg0_6.nanoTxt.text = var0_6.count
	end
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
	local var0_8 = ActivityGoodsCard.New(arg1_8)

	onButton(arg0_8, var0_8.tr, function()
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
	arg0_12:OnSetUp()
end

function var0_0.OnSetUp(arg0_13)
	arg0_13.dayTxt.text = string.format("%02d", arg0_13.shop:getRestDays())
end

function var0_0.OnPurchase(arg0_14, arg1_14, arg2_14)
	arg0_14:emit(NewShopsMediator.ON_SHAM_SHOPPING, arg1_14.id, arg2_14)
end

function var0_0.OnDestroy(arg0_15)
	return
end

return var0_0
