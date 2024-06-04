local var0 = class("MainSettingsBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	SettingsRedDotNode.CanUpdateCV = false

	arg0:emit(NewMainMediator.GO_SCENE, SCENE.SETTINGS)
end

return var0
