local var0_0 = class("AuctionGameMainNoticeBoardLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameMainNoticeBoardUI"
end

function var0_0.init(arg0_2)
	onButton(arg0_2, arg0_2.uiCloseBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)
	onButton(arg0_2, arg0_2.uiBgBtn, function()
		arg0_2:closeView()
	end, SOUND_BACK)

	arg0_2.boardItemList = {}
end

function var0_0.didEnter(arg0_5)
	arg0_5:OverlayPanel(arg0_5._tf, {
		pbList = {
			arg0_5.uiBg
		}
	})

	local var0_5 = getProxy(AuctionGameProxy):GetPlayerList()

	for iter0_5, iter1_5 in ipairs(var0_5) do
		arg0_5.boardItemList[iter0_5] = AuctionGameMainNoticeBoardPlayer.New(arg0_5[string.format("uiPlayerTf%s", iter0_5)], arg0_5)

		arg0_5.boardItemList[iter0_5]:didEnter(iter0_5)
	end

	for iter2_5 = #var0_5 + 1, 4 do
		setActive(arg0_5[string.format("uiPlayerTf%s", iter2_5)], false)
	end
end

function var0_0.willExit(arg0_6)
	for iter0_6, iter1_6 in ipairs(arg0_6.boardItemList) do
		iter1_6:willExit()
	end

	arg0_6.boardItemList = nil

	arg0_6:UnOverlayPanel(arg0_6._tf)
end

return var0_0
