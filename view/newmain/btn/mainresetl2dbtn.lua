local var0_0 = class("MainResetL2dBtn", import(".MainBaseBtn"))

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	var0_0.super.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1:bind(GAME.ROTATE_PAINTING_INDEX, function()
		arg0_1:FlushL2d()
	end)
end

function var0_0.OnClick(arg0_3)
	arg0_3:emit(NewMainScene.RESET_L2D)
end

function var0_0.Flush(arg0_4, arg1_4)
	arg0_4:FlushL2d()
end

function var0_0.FlushL2d(arg0_5)
	if not getProxy(SettingsProxy):ShowL2dResetInMainScene() then
		setActive(arg0_5._tf, false)

		return
	end

	local var0_5 = getProxy(PlayerProxy):getRawData():GetFlagShip()
	local var1_5 = MainPaintingView.GetAssistantStatus(var0_5) == MainPaintingView.STATE_L2D

	setActive(arg0_5._tf, var1_5)
end

return var0_0
