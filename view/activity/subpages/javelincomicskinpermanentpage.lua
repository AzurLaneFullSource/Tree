local var0_0 = class("JavelinComicSkinPermanentPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)

	if arg0_1.nday < #arg0_1.taskGroup then
		setText(arg0_1.dayTF, "<color=#E75198><size=48>" .. arg0_1.nday .. "</size></color><color=#00B8FF><size=28>     " .. #arg0_1.taskGroup .. "</size></color>")
	else
		setText(arg0_1.dayTF, "<color=#00FF00><size=48>" .. arg0_1.nday .. "</size></color><color=#00B8FF><size=28>     " .. #arg0_1.taskGroup .. "</size></color>")
	end
end

return var0_0
