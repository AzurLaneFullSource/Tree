local var0 = class("MainHideBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainScene.FOLD, true)
end

return var0
