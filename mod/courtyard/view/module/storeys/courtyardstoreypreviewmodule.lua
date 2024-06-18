local var0_0 = class("CourtYardStoreyPreviewModule", import(".CourtYardStoreyModule"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.bgmAgent:Clear()
end

function var0_0.EnableZoom(arg0_2, arg1_2)
	arg0_2.zoomAgent.enabled = false
end

return var0_0
