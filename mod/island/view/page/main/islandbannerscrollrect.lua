local var0_0 = class("IslandBannerScrollRect", import("view.newMain.page.BannerScrollRect"))

function var0_0.UpdateDotPosition(arg0_1, arg1_1, arg2_1)
	return
end

function var0_0.TriggerDot(arg0_2, arg1_2, arg2_2)
	setActive(arg1_2:Find("unsel"), not arg2_2)
	setActive(arg1_2:Find("sel"), arg2_2)
end

return var0_0
