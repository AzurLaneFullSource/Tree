local var0_0 = class("AuctionGameStoreView", import("view.base.BasePanel"))

var0_0.UPDATE_ITEM_LIST = "AuctionGameStoreView::UPDATE_ITEM_LIST"

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._go = arg1_1.gameObject

	var0_0.super.Ctor(arg0_1, arg0_1._go)

	arg0_1._parentClass = arg2_1

	arg0_1:attach(arg2_1)
	arg0_1:Init()
end

function var0_0.Init(arg0_2)
	arg0_2.cellItemViewList = {}
	arg0_2.itemViewList = {}
end

function var0_0.didEnter(arg0_3)
	arg0_3.maxLine = 0

	arg0_3:RefreshStore()

	arg0_3.eventList = {
		arg0_3:bind(var0_0.UPDATE_ITEM_LIST, handler(arg0_3, arg0_3.RefreshStore))
	}
end

function var0_0.RefreshStore(arg0_4)
	local var0_4 = getProxy(AuctionGameProxy):GetCurStoreLine()
	local var1_4 = (var0_4 - arg0_4.maxLine) * AuctionGameConst.CELL_COL_CNT

	arg0_4.maxLine = var0_4

	for iter0_4 = 1, var1_4 do
		arg0_4.cellItemViewList[#arg0_4.cellItemViewList + 1] = AuctionGameCellItem.New(tf(Instantiate(arg0_4.uiCellItemTf, arg0_4.uiCellParentTf)), arg0_4._parentClass)

		arg0_4.cellItemViewList[iter0_4]:Show(true)
	end

	onNextTick(function()
		arg0_4:RefreshItemList()
	end)
end

function var0_0.RefreshItemList(arg0_6)
	local var0_6 = getProxy(AuctionGameProxy):GetStoreItemDataList()

	for iter0_6, iter1_6 in pairs(var0_6) do
		local var1_6 = arg0_6.itemViewList[iter0_6] or AuctionGameStoreItem.New(tf(Instantiate(arg0_6.uiItemTf, arg0_6.uiCellParentTf)), arg0_6._parentClass)
		local var2_6 = AuctionGameConst.CELL_COL_CNT * (iter1_6.position.y - 1) + iter1_6.position.x
		local var3_6 = arg0_6.cellItemViewList[var2_6]:GetPosition()

		var1_6:SetPosition(var3_6)
		var1_6:didEnter(iter1_6)

		arg0_6.itemViewList[iter0_6] = var1_6
	end
end

function var0_0.RefreshEventEffect(arg0_7, arg1_7)
	for iter0_7, iter1_7 in pairs(itemDataList) do
		local var0_7 = arg0_7.itemViewList[iter0_7]

		if var0_7 == nil then
			var0_7 = AuctionGameStoreItem.New(tf(Instantiate(arg0_7.uiItemTf, arg0_7.uiCellParentTf)), arg0_7._parentClass)

			local var1_7 = AuctionGameConst.CELL_COL_CNT * (iter1_7.position.y - 1) + iter1_7.position.x
			local var2_7 = arg0_7.cellItemViewList[var1_7]:GetPosition()

			var0_7:SetPosition(var2_7)

			arg0_7.itemViewList[iter0_7] = var0_7
		end

		var0_7:didEnter(iter0_7, iter1_7)
	end
end

function var0_0.willExit(arg0_8)
	for iter0_8, iter1_8 in ipairs(arg0_8.eventList) do
		arg0_8:disconnect(iter1_8)
	end

	arg0_8.eventList = nil

	for iter2_8, iter3_8 in ipairs(arg0_8.cellItemViewList) do
		iter3_8:willExit()
	end

	arg0_8.cellItemViewList = nil

	for iter4_8, iter5_8 in pairs(arg0_8.itemViewList) do
		iter5_8:willExit()
	end

	arg0_8.itemViewList = nil

	arg0_8:detach()
end

return var0_0
