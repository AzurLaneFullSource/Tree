local var0 = class("JiqilifuSkinPermanentPage", import(".TemplatePage.SkinTemplatePage"))

function var0.OnUpdateFlush(arg0)
	var0.super.OnUpdateFlush(arg0)
	setText(arg0.dayTF, setColorStr(arg0.nday, "#6CF7C1FF") .. "/" .. #arg0.taskGroup)
end

return var0
