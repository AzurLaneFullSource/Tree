local var0_0 = class("AuctionGameMainRoundOverLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameMainRoundOverUI"
end

function var0_0.init(arg0_2)
	arg0_2.boardItemList = {}
end

function var0_0.didEnter(arg0_3)
	arg0_3:OverlayPanel(arg0_3._tf, {
		pbList = {
			arg0_3.uiBg
		}
	})

	local var0_3 = getProxy(AuctionGameProxy)
	local var1_3 = AuctionGameTools.GetPlayerNoSortList(var0_3:GetRound())

	for iter0_3, iter1_3 in ipairs(var1_3) do
		arg0_3.boardItemList[iter0_3] = AuctionGameMainRoundOverPlayer.New(arg0_3[string.format("uiPlayerTf%s", iter0_3)], arg0_3)

		arg0_3.boardItemList[iter0_3]:didEnter(iter1_3.data)
	end

	for iter2_3 = #var1_3 + 1, 4 do
		setActive(arg0_3[string.format("uiPlayerTf%s", iter2_3)], false)
	end
end

function var0_0.willExit(arg0_4)
	for iter0_4, iter1_4 in ipairs(arg0_4.boardItemList) do
		iter1_4:willExit()
	end

	arg0_4.boardItemList = nil

	arg0_4:UnOverlayPanel(arg0_4._tf)
end

function var0_0.onBackPressed(arg0_5)
	return
end

return var0_0
