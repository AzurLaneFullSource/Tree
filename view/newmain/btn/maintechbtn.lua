local var0 = class("MainTechBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.SELTECHNOLOGY)
end

return var0
