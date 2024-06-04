local var0 = class("ExpoTicketTaskPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#70FFEC") .. "/" .. #arg0.taskGroup)
end

function var0.GetProgressColor(arg0)
	return "#70FFFD", "#E1FFFF"
end

return var0
