local var0_0 = class("MainSettingsBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	SettingsRedDotNode.CanUpdateCV = false

	arg0_1:emit(NewMainMediator.GO_SCENE, SCENE.SETTINGS)
end

return var0_0
