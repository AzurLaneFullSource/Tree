local var0_0 = class("MainFormationBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	local var0_1 = {
		fleetId = 1
	}

	arg0_1:emit(NewMainMediator.GO_SCENE, SCENE.BIANDUI, var0_1)
end

function var0_0.IsFixed(arg0_2)
	return true
end

return var0_0
