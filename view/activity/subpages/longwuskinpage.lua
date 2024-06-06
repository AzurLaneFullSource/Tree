local var0 = class("LongwuSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#fcfbeb"))
end

function var0.GetProgressColor(arg0)
	return "#1d5073", "#1d5073"
end

return var0
