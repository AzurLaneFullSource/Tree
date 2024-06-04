local var0 = class("ShamShopPage", import(".BaseShopPage"))

function var0.getUIName(arg0)
	return "ShamShop"
end

function var0.GetPaintingCommodityUpdateVoice(arg0)
	return
end

function var0.CanOpen(arg0, arg1, arg2)
	return pg.SystemOpenMgr.GetInstance():isOpenSystem(arg2.level, "ShamShop")
end

function var0.OnLoaded(arg0)
	arg0.dayTxt = arg0:findTF("time/day"):GetComponent(typeof(Text))
	arg0.nanoTxt = arg0:findTF("res_nano/Text"):GetComponent(typeof(Text))
end

function var0.OnInit(arg0)
	setText(arg0._tf:Find("time"), i18n("title_limit_time"))
	setText(arg0._tf:Find("time/text"), i18n("shops_rest_day"))
	setText(arg0._tf:Find("time/text_day"), i18n("word_date"))
end

function var0.OnUpdateItems(arg0)
	local var0 = arg0.items[ChapterConst.ShamMoneyItem]

	if not var0 then
		arg0.nanoTxt.text = 0
	else
		arg0.nanoTxt.text = var0.count
	end
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
		var0:update(arg1)
	end
end

function var0.OnInitItem(arg0, arg1)
	local var0 = ActivityGoodsCard.New(arg1)

	onButton(arg0, var0.tr, function()
		if not var0.goodsVO:canPurchase() then
			pg.TipsMgr.GetInstance():ShowTips(i18n("buy_countLimit"))

			return
		end

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

	var0:update(var1)
end

function var0.OnUpdateAll(arg0)
	arg0:InitCommodities()
	arg0:OnSetUp()
end

function var0.OnSetUp(arg0)
	arg0.dayTxt.text = string.format("%02d", arg0.shop:getRestDays())
end

function var0.OnPurchase(arg0, arg1, arg2)
	arg0:emit(NewShopsMediator.ON_SHAM_SHOPPING, arg1.id, arg2)
end

function var0.OnDestroy(arg0)
	return
end

return var0
