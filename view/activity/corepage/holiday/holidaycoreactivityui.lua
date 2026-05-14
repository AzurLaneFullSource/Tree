local var0_0 = class("HolidayCoreActivityUI", import("view.activity.CorePage.OutPost.OutPostCoreActivityUI"))

function var0_0.getUIName(arg0_1)
	return "HolidayCoreActivityUI"
end

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	local var0_2 = arg0_2:getActsInterested()
	local var1_2 = #var0_2

	for iter0_2, iter1_2 in ipairs(var0_2) do
		local var2_2 = getProxy(ActivityProxy):getActivityById(iter1_2)

		var1_2 = var2_2 and not var2_2:isEnd() and var1_2 or var1_2 - 1
	end

	setActive(arg0_2.tabs, var1_2 >= 1)
end

function var0_0.getActsInterested(arg0_3)
	return {
		50602
	}
end

return var0_0
