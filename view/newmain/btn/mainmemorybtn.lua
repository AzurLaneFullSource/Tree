local var0 = class("MainMemoryBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.MEDIA_COLLECTION_ENTRANCE)
end

return var0
