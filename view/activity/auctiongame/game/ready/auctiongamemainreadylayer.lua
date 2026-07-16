local var0_0 = class("AuctionGameMainReadyLayer", import("view.base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "AuctionGameMainReadyUI"
end

function var0_0.init(arg0_2)
	setText(arg0_2.uiContentText, i18n("auction_ready"))
end

function var0_0.didEnter(arg0_3)
	return
end

function var0_0.willExit(arg0_4)
	return
end

function var0_0.onBackPressed(arg0_5)
	return
end

return var0_0
