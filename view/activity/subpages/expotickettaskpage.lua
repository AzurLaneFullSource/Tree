local var0_0 = class("ExpoTicketTaskPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, setColorStr(arg0_1.nday, "#70FFEC") .. "/" .. #arg0_1.taskGroup)
end

function var0_0.GetProgressColor(arg0_2)
	return "#70FFFD", "#E1FFFF"
end

return var0_0
