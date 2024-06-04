local var0 = class("MainEquipBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.EQUIPSCENE)
end

return var0
