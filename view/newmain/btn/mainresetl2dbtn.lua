local var0 = class("MainResetL2dBtn", import(".MainBaseBtn"))

function var0.Ctor(arg0, arg1, arg2)
	var0.super.Ctor(arg0, arg1, arg2)
	arg0:bind(GAME.ROTATE_PAINTING_INDEX, function()
		arg0:FlushL2d()
	end)
end

function var0.OnClick(arg0)
	arg0:emit(NewMainScene.RESET_L2D)
end

function var0.Flush(arg0, arg1)
	arg0:FlushL2d()
end

function var0.FlushL2d(arg0)
	if not getProxy(SettingsProxy):ShowL2dResetInMainScene() then
		setActive(arg0._tf, false)

		return
	end

	local var0 = getProxy(PlayerProxy):getRawData():GetFlagShip()
	local var1 = MainPaintingView.GetAssistantStatus(var0) == MainPaintingView.STATE_L2D

	setActive(arg0._tf, var1)
end

return var0
