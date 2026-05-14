local var0_0 = class("OutPostScenarioPage", import("view.activity.CorePage.CoreScenarioTemplatePage"))

var0_0.LINE_COLOR = {
	"29374080",
	"293740",
	"ffffff"
}
var0_0.TITLE_COLOR = {
	"586169",
	"2a343c",
	"5f4c36"
}
var0_0.TITLE_ALPHA = {
	1,
	1,
	1
}

function var0_0.getUIName(arg0_1)
	return "OutPostScenarioPage"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	setText(arg0_2.top:Find("top/deco/Text"), i18n("260514_story_title"))
	setText(arg0_2.top:Find("top/deco/Text/Text_1"), i18n("260514_story_title_en"))
end

function var0_0.UpdateStory(arg0_3, arg1_3)
	var0_0.super.UpdateStory(arg0_3, arg1_3)

	local var0_3 = arg0_3.storyReadCount
	local var1_3 = arg0_3.storyReadMax
	local var2_3 = "<color=#ffffff>" .. var0_3 .. "</color><color=#27353e>/" .. var1_3 .. "</color>"

	setText(arg0_3.progressText, var2_3)
end

return var0_0
