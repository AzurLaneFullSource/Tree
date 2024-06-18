local var0_0 = class("SixthAnniversaryIslandShopLayer", import("..base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "SixthAnniversaryIslandShopUI"
end

function var0_0.setShop(arg0_2, arg1_2)
	arg0_2.shop = arg1_2
	arg0_2.goodsList = arg1_2:getSortGoods()
	arg0_2.activity = getProxy(ActivityProxy):getActivityById(arg1_2.activityId)
end

function var0_0.setPlayer(arg0_3, arg1_3)
	arg0_3.player = arg1_3

	setText(arg0_3.rtRes:Find("Text"), arg0_3.player:getResById(350) or 0)
end

function var0_0.init(arg0_4)
	pg.UIMgr.GetInstance():BlurPanel(arg0_4._tf)

	local var0_4 = arg0_4._tf:Find("main")

	setText(var0_4:Find("time/Text"), i18n("islandshop_tips1"))

	arg0_4.rtTime = var0_4:Find("time/Text_2")
	arg0_4.rtRes = var0_4:Find("tpl")

	local var1_4 = arg0_4._tf:Find("main/view/content")

	arg0_4.goodsItemList = UIItemList.New(var1_4, var1_4:Find("goods"))

	arg0_4.goodsItemList:make(function(arg0_5, arg1_5, arg2_5)
		arg1_5 = arg1_5 + 1

		if arg0_5 == UIItemList.EventUpdate then
			arg0_4.goodsCardDic[arg0_4.goodsList[arg1_5].id] = arg2_5

			onButton(arg0_4, arg2_5, function()
				arg0_4:emit(SixthAnniversaryIslandShopMediator.OPEN_GOODS_WINDOW, arg0_4.goodsList[arg1_5])
			end, SFX_PANEL)
			arg0_4:updateGoodsCard(arg2_5, arg0_4.goodsList[arg1_5])
		end
	end)
	onButton(arg0_4, arg0_4._tf:Find("bg"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)
	onButton(arg0_4, arg0_4._tf:Find("main/btn_back"), function()
		arg0_4:closeView()
	end, SFX_CANCEL)
end

function var0_0.updateGoodsCard(arg0_9, arg1_9, arg2_9)
	local var0_9 = arg2_9:CheckCntLimit()

	setActive(arg1_9:Find("mask"), not var0_9)

	local var1_9 = var0_9 and not arg2_9:CheckArgLimit()

	setGray(arg1_9, var1_9)
	setActive(arg1_9:Find("btn_pay"), var0_9)
	setActive(arg1_9:Find("btn_unable"), not var0_9)
	setButtonEnabled(arg1_9, var0_9)

	local var2_9 = {
		type = arg2_9:getConfig("commodity_type"),
		id = arg2_9:getConfig("commodity_id"),
		count = arg2_9:getConfig("num")
	}

	updateDrop(arg1_9:Find("icon/IconTpl"), var2_9)
	onNextTick(function()
		changeToScrollText(arg1_9:Find("Text"), var2_9:getConfig("name"))
	end)
	GetImageSpriteFromAtlasAsync(Drop.New({
		type = arg2_9:getConfig("resource_category"),
		id = arg2_9:getConfig("resource_type")
	}):getIcon(), "", arg1_9:Find("res_icon"))
	setText(arg1_9:Find("btn_pay/cost"), arg2_9:getConfig("resource_num"))
	setText(arg1_9:Find("btn_unable/cost"), arg2_9:getConfig("resource_num"))

	local var3_9 = arg2_9:getConfig("num_limit")

	if var3_9 == 0 then
		setText(arg1_9:Find("limit"), i18n("common_no_limit"))
	else
		setText(arg1_9:Find("limit"), i18n("islandshop_tips2") .. math.max(arg2_9:GetPurchasableCnt(), 0) .. "/" .. var3_9)
	end
end

function var0_0.refreshGoodsCard(arg0_11, arg1_11)
	arg0_11:updateGoodsCard(arg0_11.goodsCardDic[arg1_11], arg0_11.shop:getGoodsById(arg1_11))
end

function var0_0.didEnter(arg0_12)
	local var0_12 = pg.TimeMgr.GetInstance()

	arg0_12.timer = Timer.New(function()
		arg0_12.delta = arg0_12.delta and arg0_12.delta - 1 or arg0_12.activity.stopTime - var0_12:GetServerTime()

		local var0_13 = string.format("%d" .. i18n("word_date") .. "%d" .. i18n("word_hour"), var0_12:parseTimeFrom(arg0_12.delta))

		if arg0_12.strTime ~= var0_13 then
			setText(arg0_12.rtTime, var0_13)
		end
	end, 1)

	arg0_12.timer.func()
	arg0_12.timer:Start()

	arg0_12.goodsCardDic = {}

	arg0_12.goodsItemList:align(#arg0_12.goodsList)
end

function var0_0.willExit(arg0_14)
	arg0_14.timer:Stop()
	pg.UIMgr.GetInstance():UnblurPanel(arg0_14._tf)
end

return var0_0
