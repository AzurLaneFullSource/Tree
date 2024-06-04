local var0 = class("CourtYardStoreyPreviewModule", import(".CourtYardStoreyModule"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)
	arg0.bgmAgent:Clear()
end

function var0.EnableZoom(arg0, arg1)
	arg0.zoomAgent.enabled = false
end

return var0
