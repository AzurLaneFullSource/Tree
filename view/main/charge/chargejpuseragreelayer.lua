local var0 = class("ChargeJPUserAgreeLayer", import("...base.BaseUI"))

function var0.getUIName(arg0)
	return "ChargeJPUserAgreeUI"
end

function var0.init(arg0)
	arg0:initData()
	arg0:findUI()
	arg0:addListener()
	arg0:initUIText()
end

function var0.didEnter(arg0)
	pg.UIMgr.GetInstance():BlurPanel(arg0._tf)
	setText(arg0.scrollText, arg0.contentStr or "")
	scrollTo(arg0.scrollRect, 0, 1)
end

function var0.willExit(arg0)
	pg.UIMgr.GetInstance():UnblurPanel(arg0._tf)
end

function var0.initData(arg0)
	arg0.contentStr = arg0.contextData.contentStr
end

function var0.initUIText(arg0)
	return
end

function var0.findUI(arg0)
	arg0.bg = arg0:findTF("bg")
	arg0.closeBtn = arg0:findTF("window/top/btnBack")
	arg0.scrollRect = arg0:findTF("container/scrollrect")
	arg0.scrollText = arg0:findTF("content/Text", arg0.scrollRect)
end

function var0.addListener(arg0)
	onButton(arg0, arg0.bg, function()
		arg0:closeView()
	end, SFX_CANCEL)
	onButton(arg0, arg0.closeBtn, function()
		arg0:closeView()
	end, SFX_CANCEL)
end

return var0
