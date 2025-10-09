local var0_0 = class("AEBCSStoryPage", import("view.activity.CorePage.CoreStoryTemplatePage"))

function var0_0.OnInit(arg0_1)
	var0_0.super.OnInit(arg0_1)
	setActive(arg0_1:findTF("tip", arg0_1.goBtn), PlayerPrefs.GetInt("AEBCSStoryReminder", 0) == 0)
end

function var0_0.IsShowReminder(arg0_2)
	return PlayerPrefs.GetInt("AEBCSStoryReminder", 0) == 0
end

function var0_0.ShowScenarioLayer(arg0_3, arg1_3)
	var0_0.super.ShowScenarioLayer(arg0_3, arg1_3)

	if arg1_3 then
		PlayerPrefs.SetInt("AEBCSStoryReminder", 1)
	end
end

return var0_0
