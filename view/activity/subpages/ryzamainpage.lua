local var0_0 = class("RyzaMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	var0_0.super.OnFirstFlush(arg0_1)

	arg0_1.mountainBtn = arg0_1:findTF("mountain", arg0_1.btnList)

	onButton(arg0_1, arg0_1.mountainBtn, function()
		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.RYZA_URBAN_AREA)
	end, SFX_PANEL)
end

return var0_0
