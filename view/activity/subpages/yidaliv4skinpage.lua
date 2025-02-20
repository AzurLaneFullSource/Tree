local var0_0 = class("YidaliV4SkinPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)

	if arg0_1.dayTF then
		setText(arg0_1.dayTF, setColorStr(arg0_1.nday, "#b98959") .. setColorStr("/" .. #arg0_1.taskGroup, "#5a4439"))
	end
end

function var0_0.GetProgressColor(arg0_2)
	return "#cead74"
end

return var0_0
