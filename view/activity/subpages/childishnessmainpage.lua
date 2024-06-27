local var0_0 = class("ChildishnessMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	arg0_1.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1:findTF("fight", arg0_1.btnList), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.KINDERGARTEN)
	end)
	onButton(arg0_1, arg0_1:findTF("shop", arg0_1.btnList), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end)
end

return var0_0
