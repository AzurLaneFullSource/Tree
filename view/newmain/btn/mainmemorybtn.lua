local var0_0 = class("MainMemoryBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	arg0_1:emit(NewMainMediator.GO_SCENE, SCENE.MEDIA_COLLECTION_ENTRANCE)
end

return var0_0
