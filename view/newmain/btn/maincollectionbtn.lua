local var0_0 = class("MainCollectionBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	arg0_1:emit(NewMainMediator.GO_SCENE, SCENE.COLLECTSHIP)
end

return var0_0
