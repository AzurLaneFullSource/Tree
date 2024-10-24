local var0_0 = class("GhostSkinStoryActPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	arg0_1.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1:findTF("activity", arg0_1.btnList), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.GHOSTSKINPAGE)
	end)
end

function var0_0.OnUpdateFlush(arg0_3)
	local var0_3 = arg0_3:findTF("AD/redDot")

	setActive(var0_3, GhostSkinPageLayer.IsShowRed())
end

return var0_0
