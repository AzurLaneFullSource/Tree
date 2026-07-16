local var0_0 = class("AuctionGameMainRightInfoView", import("view.base.BasePanel"))

var0_0.EVENT_INFO_UPDATE = "AuctionGameMainRightInfoView:EVENT_INFO_UPDATE"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.itemList = {}
end

function var0_0.didEnter(arg0_3)
	arg0_3.eventList = {
		arg0_3:bind(var0_0.EVENT_INFO_UPDATE, handler(arg0_3, arg0_3.OnUpdateEventInfo))
	}
end

function var0_0.OnUpdateEventInfo(arg0_4)
	arg0_4:RefreshUI(arg0_4.filterPersonalFlag, arg0_4.filterCommonFlag)
end

function var0_0.RefreshUI(arg0_5, arg1_5, arg2_5)
	arg0_5.filterPersonalFlag = arg1_5
	arg0_5.filterCommonFlag = arg2_5

	local var0_5 = getProxy(AuctionGameProxy)
	local var1_5 = {}

	for iter0_5, iter1_5 in ipairs(var0_5:GetEventSummary()) do
		if iter1_5.commonEventData then
			table.insert(var1_5, 1, {
				type = AuctionGameConst.EVENT_TYPE_GROUP.COMMON,
				round = iter0_5,
				eventData = iter1_5.commonEventData
			})
		end

		if iter1_5.personalEventData then
			table.insert(var1_5, 1, {
				type = AuctionGameConst.EVENT_TYPE_GROUP.PERSONAL,
				round = iter0_5,
				eventData = iter1_5.personalEventData
			})
		end
	end

	for iter2_5, iter3_5 in ipairs(var1_5) do
		arg0_5.itemList[iter2_5] = arg0_5.itemList[iter2_5] or AuctionGameMainRightInfoItem.New(Instantiate(arg0_5.uiItemTf, arg0_5.uiContentTf), arg0_5._parentClass)

		arg0_5.itemList[iter2_5]:didEnter(iter3_5, arg1_5, arg2_5)
	end
end

function var0_0.willExit(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.itemList) do
		iter1_6:willExit()
	end

	arg0_6.itemList = nil

	for iter2_6, iter3_6 in ipairs(arg0_6.eventList) do
		arg0_6:disconnect(iter3_6)
	end

	arg0_6.eventList = nil

	arg0_6:detach()
end

return var0_0
