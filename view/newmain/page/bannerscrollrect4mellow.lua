local var0_0 = class("BannerScrollRect4Mellow", import(".BannerScrollRect"))

function var0_0.UpdateDotPosition(arg0_1, arg1_1, arg2_1)
	return
end

function var0_0.TriggerDot(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg2_2 and 45 or 10

	arg1_2:GetComponent(typeof(LayoutElement)).minWidth = var0_2
end

return var0_0
