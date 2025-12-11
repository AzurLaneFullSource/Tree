local var0_0 = class("WinterFestival2025CoreActivityUI", import("view.activity.CorePage.CoreAdaptActivityMainScene"))

function var0_0.getUIName(arg0_1)
	return "WinterFestival2025CoreActivityUI"
end

function var0_0.GetButtonNameText(arg0_2, arg1_2)
	return (i18n("general_activity_side_bar" .. arg1_2:getConfig("is_show")))
end

function var0_0.didEnter(arg0_3)
	var0_0.super.didEnter(arg0_3)

	if arg0_3.contextData.actID then
		arg0_3:verifyTabs(arg0_3.contextData.actID)
	end
end

return var0_0
