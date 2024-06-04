local var0 = class("MainFormationBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	local var0 = {
		fleetId = 1
	}

	arg0:emit(NewMainMediator.GO_SCENE, SCENE.BIANDUI, var0)
end

function var0.IsFixed(arg0)
	return true
end

return var0
