local var0_0 = class("AuctionGameMainLeftView", import("view.base.BasePanel"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.storeView = AuctionGameStoreView.New(arg0_2.uiStorePanel, arg0_2._parentClass)
end

function var0_0.didEnter(arg0_3)
	arg0_3.storeView:didEnter()

	if getProxy(AuctionGameProxy):GetAuctionID() == 1 then
		setActive(arg0_3.uiEstimateGo, true)
	else
		setActive(arg0_3.uiEstimateGo, false)
	end

	arg0_3.eventList = {
		arg0_3:bind(AuctionGameMainRightView.EVENT_SELECTED, handler(arg0_3, arg0_3.RefreshEstimate))
	}
end

function var0_0.RefreshRound(arg0_4)
	arg0_4:RefreshEstimate()
end

function var0_0.RefreshEstimate(arg0_5)
	local var0_5 = getProxy(AuctionGameProxy)
	local var1_5 = 0
	local var2_5 = 0

	for iter0_5, iter1_5 in pairs(var0_5:GetStoreItemDataList()) do
		local var3_5, var4_5 = iter1_5:GetEstimateValue()

		var1_5 = var1_5 + var3_5
		var2_5 = var2_5 + var4_5
	end

	setText(arg0_5.uiEstimateText, i18n("auction_store_estimate", StringHelper.ForamtNumber(var1_5), StringHelper.ForamtNumber(var2_5)))
end

function var0_0.willExit(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.eventList) do
		arg0_6:disconnect(iter1_6)
	end

	arg0_6.eventList = nil

	arg0_6.storeView:willExit()

	arg0_6.storeView = nil

	arg0_6:detach()
end

return var0_0
