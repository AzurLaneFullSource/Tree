local var0 = class("MainLiveBtn", import(".MainBaseBtn"))

function var0.OnClick(arg0)
	arg0:emit(NewMainScene.OPEN_LIVEAREA)
end

return var0
