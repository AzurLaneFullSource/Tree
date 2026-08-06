local var0_0 = class("IslandShipStatusBox", import(".IslandShipStatusPage"))

function var0_0.getUIName(arg0_1)
	return "IslandShipStatusBox"
end

function var0_0.OnLoaded(arg0_2)
	var0_0.super.OnLoaded(arg0_2)

	arg0_2.hideBtn = arg0_2._tf:Find("close")
end

function var0_0.OnInit(arg0_3)
	var0_0.super.OnInit(arg0_3)
	onButton(arg0_3, arg0_3.hideBtn, function()
		arg0_3:Hide()
	end, SFX_PANEL)
end

function var0_0.OnShow(arg0_5, ...)
	var0_0.super.OnShow(arg0_5, ...)
	arg0_5:OverlayPanel(arg0_5._tf, {
		groupDelta = 1
	})
end

function var0_0.OnHide(arg0_6)
	var0_0.super.OnHide(arg0_6)
	arg0_6:UnOverlayPanel(arg0_6._tf, arg0_6._parentTf)
end

function var0_0.OnDisable(arg0_7)
	arg0_7:OnHide()
end

return var0_0
