local var0_0 = import("view.activity.AuctionGame.game.settlement.store.AuctionGameMainSettlementStoreView")
local var1_0 = class("AuctionGamePreorderBoxSettlementStoreView", var0_0)

function var1_0.Init(arg0_1)
	arg0_1.cellItemViewList = {}
	arg0_1.itemViewList = {}

	local var0_1 = getProxy(AuctionGameBaseProxy):GetMaxLineCnt() * AuctionGameConst.CELL_COL_CNT

	for iter0_1 = 1, var0_1 do
		arg0_1.cellItemViewList[iter0_1] = AuctionGameCellItem.New(tf(Instantiate(arg0_1.uiCellItemTf, arg0_1.uiCellParentTf)), arg0_1._parentClass)

		arg0_1.cellItemViewList[iter0_1]:Show(true)
	end
end

function var1_0.didEnter(arg0_2)
	arg0_2.itemDataList = getProxy(AuctionGameBaseProxy):GetItemList()
	arg0_2.showIndex = 1

	onNextTick(function()
		arg0_2:ShowAllContour()
		arg0_2:RefreshNextItem()
	end)

	arg0_2.eventList = {}
end

return var1_0
