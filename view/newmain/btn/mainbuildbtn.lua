local var0 = class("MainBuildBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.GETBOAT)
end

return var0
