local var0_0 = class("WinterFestival2025CoreActivityUI", import("view.activity.CorePage.CoreAdaptActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "WinterFestival2025CoreActivityUI"
end

function var0_0.GetButtonNameText(arg0_2, arg1_2)
	local var0_2 = arg1_2:getConfig("type")

	if var0_2 == ActivityConst.ACTIVITY_TYPE_TASK_POOL or var0_2 == ActivityConst.ACTIVITY_TYPE_SHRINE then
		return i18n(arg1_2:getConfig("title_res_tag"))
	end

	if var0_2 == ActivityConst.ACTIVITY_TYPE_PT_HEI5 then
		return i18n("general_activity_side_bar2")
	end

	return (i18n("general_activity_side_bar" .. arg1_2:getConfig("is_show")))
end

function var0_0.didEnter(arg0_3)
	var0_0.super.didEnter(arg0_3)

	if arg0_3.contextData.actID then
		arg0_3:verifyTabs(arg0_3.contextData.actID)
	end
end

function var0_0.CustomInit(arg0_4)
	setText(arg0_4._tf:Find("adapt/TopPage/top/deco/Text"), i18n("HelenaCoreActivity_title"))
	setText(arg0_4._tf:Find("adapt/TopPage/top/deco/Text/Text_1"), i18n("HelenaCoreActivity_title2"))
end

function var0_0.selectActivity(arg0_5, arg1_5)
	var0_0.super.selectActivity(arg0_5, arg1_5)

	local var0_5 = arg1_5:getConfig("type") == ActivityConst.ACTIVITY_TYPE_SHRINE

	SetActive(arg0_5._tf:Find("adapt/bg"), not var0_5)
	SetActive(arg0_5._tf:Find("adapt/bg_1"), not var0_5)
	SetActive(arg0_5._tf:Find("adapt/bg_shrine"), var0_5)
	SetActive(arg0_5._tf:Find("adapt/bg_shrine_1"), var0_5)
end

return var0_0
