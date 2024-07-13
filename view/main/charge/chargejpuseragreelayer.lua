local var0_0 = class("ChargeJPUserAgreeLayer", import("...base.BaseUI"))

function var0_0.getUIName(arg0_1)
	return "ChargeJPUserAgreeUI"
end

function var0_0.init(arg0_2)
	arg0_2:initData()
	arg0_2:findUI()
	arg0_2:addListener()
	arg0_2:initUIText()
end

function var0_0.didEnter(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
	setText(arg0_3.scrollText, arg0_3.contentStr or "")
	scrollTo(arg0_3.scrollRect, 0, 1)
end

function var0_0.willExit(arg0_4)
	pg.UIMgr.GetInstance():UnblurPanel(arg0_4._tf)
end

function var0_0.initData(arg0_5)
	arg0_5.contentStr = arg0_5.contextData.contentStr
end

function var0_0.initUIText(arg0_6)
	return
end

function var0_0.findUI(arg0_7)
	arg0_7.bg = arg0_7:findTF("bg")
	arg0_7.closeBtn = arg0_7:findTF("window/top/btnBack")
	arg0_7.scrollRect = arg0_7:findTF("container/scrollrect")
	arg0_7.scrollText = arg0_7:findTF("content/Text", arg0_7.scrollRect)
end

function var0_0.addListener(arg0_8)
	onButton(arg0_8, arg0_8.bg, function()
		arg0_8:closeView()
	end, SFX_CANCEL)
	onButton(arg0_8, arg0_8.closeBtn, function()
		arg0_8:closeView()
	end, SFX_CANCEL)
end

return var0_0
