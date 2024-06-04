local var0 = class("MainDockBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainMediator.GO_SCENE, SCENE.DOCKYARD, {
		mode = DockyardScene.MODE_OVERVIEW
	})
end

return var0
