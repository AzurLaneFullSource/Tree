local var0_0 = class("ANTTFFScenarioPage", import("view.activity.CorePage.CoreScenarioTemplatePage"))
local var1_0 = import("Mgr/Pool/PoolPlural")

var0_0.LINE_COLOR = {
	"75828c",
	"23343f",
	"2bc5ff"
}

function var0_0.getUIName(arg0_1)
	return "ANTTFFScenarioPage"
end

function var0_0.OnInit(arg0_2)
	var0_0.super.OnInit(arg0_2)
	setText(arg0_2.top:Find("top/deco/Text"), i18n("ANTTFFCoreActivityPtpage_title"))
	setText(arg0_2.top:Find("top/deco/Text/Text_1"), i18n("ANTTFFCoreActivityPtpage_title2"))
end

function var0_0.UpdateStory(arg0_3, arg1_3)
	var0_0.super.UpdateStory(arg0_3, arg1_3)

	local var0_3 = arg0_3.storyReadCount
	local var1_3 = arg0_3.storyReadMax
	local var2_3 = "<color=#27c5ff>" .. var0_3 .. "</color><color=#c7c7c7>/" .. var1_3 .. "</color>"

	setText(arg0_3.progressText, var2_3)
end

function var0_0.Show(arg0_4)
	setActive(arg0_4._parentTf:Find("AD/headline/VX_logo"), false)
	var0_0.super.Show(arg0_4)
end

function var0_0.Hide(arg0_5)
	setActive(arg0_5._parentTf:Find("AD/headline/VX_logo"), true)
	var0_0.super.Hide(arg0_5)
end

return var0_0
