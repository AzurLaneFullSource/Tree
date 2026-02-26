local var0_0 = class("MoscowURCoreActivityUI", import("view.activity.CorePage.Helena.HelenaCoreActivityUI"))

function var0_0.getUIName(arg0_1)
	return "MoscowURCoreActivityUI"
end

function var0_0.init(arg0_2, ...)
	var0_0.super.init(arg0_2, ...)

	arg0_2.topPage = arg0_2._tf:Find("adapt/TopPage")

	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text"), i18n("HelenaCoreActivity_title"))
	setText(arg0_2._tf:Find("adapt/TopPage/top/deco/Text/Text_1"), i18n("HelenaCoreActivity_title2"))
end

function var0_0.verifyTabs(arg0_3, arg1_3)
	local var0_3 = arg0_3.activities[arg0_3:getActivityIndex(arg1_3) or arg0_3:getActivityIndex(arg0_3:GetActiveActivity()) or 1]

	if var0_3 == nil then
		return
	end

	local var1_3 = var0_3:getConfig("is_show")
	local var2_3 = arg0_3.tabs:Find(tostring(var1_3))

	triggerToggle(var2_3, true)
end

function var0_0.OnAnimations(arg0_4, arg1_4, arg2_4)
	SetActive(arg0_4._tf:Find("adapt/decorate"), id == 50261 or id == 0)
end

function var0_0.OnToggleName(arg0_5, arg1_5, arg2_5)
	setText(arg1_5:Find("name"), i18n(arg2_5:getConfig("title_res_tag")))
end

function var0_0.willExit(arg0_6)
	var0_0.super.willExit(arg0_6)
end

return var0_0
