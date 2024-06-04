local var0 = class("MainCollectionBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.COLLECTSHIP)
end

return var0
