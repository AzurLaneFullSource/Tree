local var0_0 = class("WindFogCorridorCoreActivityUI", import("view.activity.CorePage.StarsCity.StarsCityCoreActivityUI"))

function var0_0.getResource(arg0_1, arg1_1)
	local var0_1 = {
		"coreactivityuitable/windfogcorridorcoreactivityui_subtitle_1_text",
		"coreactivityuitable/windfogcorridorcoreactivityui_subtitle_1_text_selected"
	}

	table.insertto(var0_1, var0_0.super.getResource(arg0_1, arg1_1))

	return var0_1
end

function var0_0.getUIName(arg0_2)
	return "WindFogCorridorCoreActivityUI"
end

return var0_0
