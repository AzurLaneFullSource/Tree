local var0 = class("JapanV3SkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#f7ecd9") .. "/" .. #arg0.taskGroup)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/japanv3skinpage_atlas", "bj_" .. arg0.nday, arg0:findTF("painting", arg0.bg))
end

function var0.GetProgressColor(arg0)
	return "#b37a4a"
end

return var0
