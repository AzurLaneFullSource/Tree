local var0_0 = class("MainHideBtn", import(".MainBaseBtn"))

function var0_0.OnClick(arg0_1)
	arg0_1:emit(NewMainScene.FOLD, true)
end

return var0_0
