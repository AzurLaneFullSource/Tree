local var0_0 = class("BannerScrollRectDorm3dShop", import("view.newMain.page.BannerScrollRect"))

function var0_0.UpdateDotPosition(arg0_1, arg1_1, arg2_1)
	return
end

function var0_0.TriggerDot(arg0_2, arg1_2, arg2_2)
	setActive(arg1_2:Find("short"), not arg2_2)
	setActive(arg1_2:Find("long"), arg2_2)
end

function var0_0.GetItemChild(arg0_3, arg1_3)
	if arg0_3.items[arg1_3] then
		if arg1_3 > arg0_3.total then
			arg0_3.total = arg1_3
		end

		return arg0_3.items[arg1_3]
	else
		return nil
	end
end

return var0_0
