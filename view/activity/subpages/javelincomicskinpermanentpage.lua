local var0 = class("JavelinComicSkinPermanentPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)

	if arg0.nday < #arg0.taskGroup then
		setText(arg0.dayTF, "<color=#E75198><size=48>" .. arg0.nday .. "</size></color><color=#00B8FF><size=28>     " .. #arg0.taskGroup .. "</size></color>")
	else
		setText(arg0.dayTF, "<color=#00FF00><size=48>" .. arg0.nday .. "</size></color><color=#00B8FF><size=28>     " .. #arg0.taskGroup .. "</size></color>")
	end
end

return var0
