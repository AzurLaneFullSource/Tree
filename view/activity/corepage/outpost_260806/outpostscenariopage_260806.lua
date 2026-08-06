local var0_0 = class("OutPostScenarioPage_260806", import("view.activity.CorePage.CoreScenarioTemplatePage"))

var0_0.LINE_COLOR = {
	"939393",
	"31233f",
	"7a57f1"
}
var0_0.TITLE_COLOR = {
	"ffffff",
	"ffffffff",
	"ffffffff"
}
var0_0.TITLE_ALPHA = {
	0.5,
	1,
	1
}

function var0_0.getUIName(arg0_1)
	return "OutPostScenarioPage_260806"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	setText(arg0_2.top:Find("top/deco/Text"), i18n("260806_story_title"))
	setText(arg0_2.top:Find("top/deco/Text/Text_1"), i18n("260806_story_title_en"))
end

function var0_0.UpdateStory(arg0_3, arg1_3)
	var0_0.super.UpdateStory(arg0_3, arg1_3)

	local var0_3 = arg0_3.storyReadCount
	local var1_3 = arg0_3.storyReadMax
	local var2_3 = "<color=#27c5ff>" .. var0_3 .. "</color><color=#c7c7c7>/" .. var1_3 .. "</color>"

	setText(arg0_3.progressText, var2_3)
end

function var0_0.RefreshNodeTitle(arg0_4, arg1_4, arg2_4)
	setScrollText(arg1_4:Find("info/bk/title_form/title"), arg2_4)
	setActive(arg1_4:Find("conditionBg"), false)
end

function var0_0.RefreshUnlockDesc(arg0_5, arg1_5, arg2_5, arg3_5)
	setScrollText(arg1_5:Find("info/bk/title_form/title"), arg2_5)
	setActive(arg1_5:Find("conditionBg"), true)
	setScrollText(arg1_5:Find("conditionBg/Text"), arg3_5)
end

return var0_0
