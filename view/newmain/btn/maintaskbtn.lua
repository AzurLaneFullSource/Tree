local var0 = class("MainTaskBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.TASK)
end

return var0
