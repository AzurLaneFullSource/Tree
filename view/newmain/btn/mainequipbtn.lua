local var0_0 = class("MainEquipBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	arg0_1:emit(NewMainMediator.GO_SCENE, SCENE.EQUIPSCENE)
end

return var0_0
