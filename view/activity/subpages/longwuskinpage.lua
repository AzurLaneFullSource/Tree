local var0_0 = class("LongwuSkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, setColorStr(arg0_1.nday, "#fcfbeb"))
end

function var0_0.GetProgressColor(arg0_2)
	return "#1d5073", "#1d5073"
end

return var0_0
