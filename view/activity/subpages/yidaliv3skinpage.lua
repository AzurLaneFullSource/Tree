local var0 = class("YidaliV3SkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#af9e82") .. "/" .. #arg0.taskGroup)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/yidaliv3skinpage_atlas", "bj_" .. arg0.nday, arg0.bg)
end

function var0.GetProgressColor(arg0)
	return "#e6d17c"
end

return var0
