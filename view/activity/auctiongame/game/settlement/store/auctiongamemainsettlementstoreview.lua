local var0_0 = class("AuctionGameMainSettlementStoreView", import("view.base.BasePanel"))

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

	local var0_2 = getProxy(AuctionGameProxy):GetMaxLineCnt() * AuctionGameConst.CELL_COL_CNT

	for iter0_2 = 1, var0_2 do
		arg0_2.cellItemViewList[iter0_2] = AuctionGameCellItem.New(tf(Instantiate(arg0_2.uiCellItemTf, arg0_2.uiCellParentTf)), arg0_2._parentClass)

		arg0_2.cellItemViewList[iter0_2]:Show(true)
	end
end

function var0_0.didEnter(arg0_3)
	arg0_3.itemDataList = getProxy(AuctionGameProxy):GetSettlementData():GetSortItemList()
	arg0_3.showIndex = 1

	onNextTick(function()
		arg0_3:ShowAllContour()
		arg0_3:RefreshNextItem()
	end)

	arg0_3.eventList = {}
end

function var0_0.ShowAllContour(arg0_5)
	for iter0_5, iter1_5 in ipairs(arg0_5.itemDataList) do
		local var0_5 = arg0_5.itemViewList[uid] or AuctionGameStoreItem.New(tf(Instantiate(arg0_5.uiItemTf, arg0_5.uiCellParentTf)), arg0_5._parentClass)
		local var1_5 = AuctionGameConst.CELL_COL_CNT * (iter1_5.position.y - 1) + iter1_5.position.x
		local var2_5 = arg0_5.cellItemViewList[var1_5]:GetPosition()

		var0_5:SetPosition(var2_5)
		var0_5:ShowSize(iter1_5)
		var0_5:ShowContour({
			contour = iter1_5.contour
		})

		arg0_5.itemViewList[iter1_5.uid] = var0_5
	end
end

function var0_0.RevealItem(arg0_6, arg1_6)
	local var0_6 = arg0_6.itemDataList[arg1_6]
	local var1_6 = var0_6.id
	local var2_6 = var0_6.uid
	local var3_6 = arg0_6.itemViewList[var2_6] or AuctionGameStoreItem.New(tf(Instantiate(arg0_6.uiItemTf, arg0_6.uiCellParentTf)), arg0_6._parentClass)

	var3_6:didEnter(var0_6)

	arg0_6.itemViewList[var2_6] = var3_6
	arg0_6.showIndex = arg0_6.showIndex + 1

	arg0_6:emit(AuctionGameMainSettlementScene.REVEAL_ITEM, var0_6)
end

function var0_0.RefreshNextItem(arg0_7)
	arg0_7:RevealItem(arg0_7.showIndex)
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(AuctionGameConst.SOUND_EFFECT.REVEAL)

	arg0_7.timer = Timer.New(function()
		arg0_7:StopTimer()

		if arg0_7.showIndex > #arg0_7.itemDataList then
			arg0_7:emit(AuctionGameMainSettlementScene.REVEAL_OVER)
		else
			arg0_7:RefreshNextItem()
		end
	end, AuctionGameConst.REVEAL_ITEM_TIME, 1)

	arg0_7.timer:Start()
end

function var0_0.RevealAllItem(arg0_9)
	if arg0_9.showIndex > #arg0_9.itemDataList then
		return
	end

	arg0_9:StopTimer()

	for iter0_9 = arg0_9.showIndex, #arg0_9.itemDataList do
		arg0_9:RevealItem(iter0_9)
	end

	arg0_9.showIndex = #arg0_9.itemDataList + 1

	arg0_9:emit(AuctionGameMainSettlementScene.REVEAL_OVER)
end

function var0_0.StopTimer(arg0_10)
	if arg0_10.timer then
		arg0_10.timer:Stop()

		arg0_10.timer = nil
	end
end

function var0_0.willExit(arg0_11)
	arg0_11:StopTimer()

	for iter0_11, iter1_11 in ipairs(arg0_11.eventList) do
		arg0_11:disconnect(iter1_11)
	end

	arg0_11.eventList = nil

	for iter2_11, iter3_11 in ipairs(arg0_11.cellItemViewList) do
		iter3_11:willExit()
	end

	arg0_11.cellItemViewList = nil

	for iter4_11, iter5_11 in pairs(arg0_11.itemViewList) do
		iter5_11:willExit()
	end

	arg0_11.itemViewList = nil

	arg0_11:detach()
end

return var0_0
