local var0 = class("SixthAnniversaryIslandShopLayer", import("..base.BaseUI"))

function var0.getUIName(arg0)
	return "SixthAnniversaryIslandShopUI"
end

function var0.setShop(arg0, arg1)
	arg0.shop = arg1
	arg0.goodsList = arg1:getSortGoods()
	arg0.activity = getProxy(ActivityProxy):getActivityById(arg1.activityId)
end

function var0.setPlayer(arg0, arg1)
	arg0.player = arg1

	setText(arg0.rtRes:Find("Text"), arg0.player:getResById(350) or 0)
end

function var0.init(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)

	local var0 = arg0._tf:Find("main")

	setText(var0:Find("time/Text"), i18n("islandshop_tips1"))

	arg0.rtTime = var0:Find("time/Text_2")
	arg0.rtRes = var0:Find("tpl")

	local var1 = arg0._tf:Find("main/view/content")

	arg0.goodsItemList = UIItemList.New(var1, var1:Find("goods"))

	arg0.goodsItemList:make(function(arg0, arg1, arg2)
		arg1 = arg1 + 1

		if arg0 == UIItemList.EventUpdate then
			arg0.goodsCardDic[arg0.goodsList[arg1].id] = arg2

			onButton(arg0, arg2, function()
				arg0:emit(SixthAnniversaryIslandShopMediator.OPEN_GOODS_WINDOW, arg0.goodsList[arg1])
			end, SFX_PANEL)
			arg0:updateGoodsCard(arg2, arg0.goodsList[arg1])
		end
	end)
	onButton(arg0, arg0._tf:Find("bg"), function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0._tf:Find("main/btn_back"), function()
		arg0:closeView()
	end, SFX_CANCEL)
end

function var0.updateGoodsCard(arg0, arg1, arg2)
	local var0 = arg2:CheckCntLimit()

	setActive(arg1:Find("mask"), not var0)

	local var1 = var0 and not arg2:CheckArgLimit()

	setGray(arg1, var1)
	setActive(arg1:Find("btn_pay"), var0)
	setActive(arg1:Find("btn_unable"), not var0)
	setButtonEnabled(arg1, var0)

	local var2 = {
		type = arg2:getConfig("commodity_type"),
		id = arg2:getConfig("commodity_id"),
		count = arg2:getConfig("num")
	}

	updateDrop(arg1:Find("icon/IconTpl"), var2)
	onNextTick(function()
		changeToScrollText(arg1:Find("Text"), var2:getConfig("name"))
	end)
	GetImageSpriteFromAtlasAsync(Drop.New({
		type = arg2:getConfig("resource_category"),
		id = arg2:getConfig("resource_type")
	}):getIcon(), "", arg1:Find("res_icon"))
	setText(arg1:Find("btn_pay/cost"), arg2:getConfig("resource_num"))
	setText(arg1:Find("btn_unable/cost"), arg2:getConfig("resource_num"))

	local var3 = arg2:getConfig("num_limit")

	if var3 == 0 then
		setText(arg1:Find("limit"), i18n("common_no_limit"))
	else
		setText(arg1:Find("limit"), i18n("islandshop_tips2") .. math.max(arg2:GetPurchasableCnt(), 0) .. "/" .. var3)
	end
end

function var0.refreshGoodsCard(arg0, arg1)
	arg0:updateGoodsCard(arg0.goodsCardDic[arg1], arg0.shop:getGoodsById(arg1))
end

function var0.didEnter(arg0)
	local var0 = pg.TimeMgr.GetInstance()

	arg0.timer = Timer.New(function()
		arg0.delta = arg0.delta and arg0.delta - 1 or arg0.activity.stopTime - var0:GetServerTime()

		local var0 = string.format("%d" .. i18n("word_date") .. "%d" .. i18n("word_hour"), var0:parseTimeFrom(arg0.delta))

		if arg0.strTime ~= var0 then
			setText(arg0.rtTime, var0)
		end
	end, 1)

	arg0.timer.func()
	arg0.timer:Start()

	arg0.goodsCardDic = {}

	arg0.goodsItemList:align(#arg0.goodsList)
end

function var0.willExit(arg0)
	arg0.timer:Stop()
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

return var0
