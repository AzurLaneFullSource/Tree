local var0 = class("BannerScrollRect4Mellow", import(".BannerScrollRect"))

function var0.UpdateDotPosition(arg0, arg1, arg2)
	return
end

function var0.TriggerDot(arg0, arg1, arg2)
	local var0 = arg2 and 45 or 10

	arg1:GetComponent(typeof(LayoutElement)).minWidth = var0
end

return var0
