local var0 = class("RyzaMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0.OnFirstFlush(arg0)
	var0.super.OnFirstFlush(arg0)

	arg0.mountainBtn = arg0:findTF("mountain", arg0.btnList)

	onButton(arg0, arg0.mountainBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.RYZA_URBAN_AREA)
	end, SFX_PANEL)
end

return var0
