local var0_0 = class("HolidayVillaShopLayer", import(".SixthAnniversaryIslandShopLayer"))

function var0_0.getUIName(arg0_1)
	return "HolidayVillaShopUI"
end

function var0_0.setPlayer(arg0_2, arg1_2)
	arg0_2.player = arg1_2

	setText(arg0_2.rtRes:Find("Text"), getProxy(ActivityProxy):getActivityById(ActivityConst.HOLIDAY_ACT_ID):getVitemNumber(66005))
end

function var0_0.refreshAllGoodsCard(arg0_3)
	arg0_3.goodsList = arg0_3.shop:getSortGoods()

	arg0_3.goodsItemList:align(#arg0_3.goodsList)
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
				arg0_4:emit(HolidayVillaShopMediator.OPEN_GOODS_WINDOW, arg0_4.goodsList[arg1_5])
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

return var0_0
