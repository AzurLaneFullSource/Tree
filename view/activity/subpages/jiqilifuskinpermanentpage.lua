local var0_0 = class("JiqilifuSkinPermanentPage", import(".TemplatePage.SkinTemplatePage"))

function var0_0.OnUpdateFlush(arg0_1)
	var0_0.super.OnUpdateFlush(arg0_1)
	setText(arg0_1.dayTF, setColorStr(arg0_1.nday, "#6CF7C1FF") .. "/" .. #arg0_1.taskGroup)
end

return var0_0
