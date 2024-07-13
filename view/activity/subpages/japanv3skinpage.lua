local var0_0 = class("JapanV3SkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, setColorStr(arg0_1.nday, "#f7ecd9") .. "/" .. #arg0_1.taskGroup)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/japanv3skinpage_atlas", "bj_" .. arg0_1.nday, arg0_1:findTF("painting", arg0_1.bg))
end

function var0_0.GetProgressColor(arg0_2)
	return "#b37a4a"
end

return var0_0
