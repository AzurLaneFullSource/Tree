local var0_0 = class("YidaliV3SkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, setColorStr(arg0_1.nday, "#af9e82") .. "/" .. #arg0_1.taskGroup)
	GetImageSpriteFromAtlasAsync("ui/activityuipage/yidaliv3skinpage_atlas", "bj_" .. arg0_1.nday, arg0_1.bg)
end

function var0_0.GetProgressColor(arg0_2)
	return "#e6d17c"
end

return var0_0
