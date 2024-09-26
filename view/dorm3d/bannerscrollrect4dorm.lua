local var0_0 = class("BannerScrollRect4Dorm", import("view.newMain.page.BannerScrollRect"))

function var0_0.UpdateDotPosition(arg0_1, arg1_1, arg2_1)
	return
end

function var0_0.TriggerDot(arg0_2, arg1_2, arg2_2)
	local var0_2 = arg2_2 and 52 or 12

	arg1_2:GetComponent(typeof(LayoutElement)).minWidth = var0_2
end

return var0_0
