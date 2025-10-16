local var0_0 = class("ChildishnessMainPage", import(".TemplatePage.PreviewTemplatePage"))

function var0_0.OnFirstFlush(arg0_1)
	arg0_1.super.OnFirstFlush(arg0_1)
	onButton(arg0_1, arg0_1.btnList:Find("fight"), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.KINDERGARTEN)
	end)
	onButton(arg0_1, arg0_1.btnList:Find("shop"), function()
		arg0_1:emit(ActivityMediator.EVENT_GO_SCENE, SCENE.SKINSHOP)
	end)
end

return var0_0
