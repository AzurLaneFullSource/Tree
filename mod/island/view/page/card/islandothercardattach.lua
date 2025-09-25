local var0_0 = class("IslandOtherCardAttach", import(".external.IslandOtherCardLayer"))

function var0_0.didEnter(arg0_1)
	var0_0.super.didEnter(arg0_1)
	onNextTick(function()
		arg0_1:ExtraHandle()
	end)
end

function var0_0.ExtraHandle(arg0_3)
	pg.UIMgr.GetInstance():BlurPanel(arg0_3._tf)
end

function var0_0.closeView(arg0_4)
	pg.UIMgr.GetInstance():UnOverlayPanel(arg0_4._tf, arg0_4.contextData.container)
	arg0_4.contextData.onClose()
end

return var0_0
