local var0_0 = class("PipeGamingUI")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	var1_0 = PipeGameVo
	arg0_1._gameUI = findTF(arg0_1._tf, "ui/gamingUI")
	arg0_1.btnBack = findTF(arg0_1._gameUI, "back")
	arg0_1.btnPause = findTF(arg0_1._gameUI, "pause")
	arg0_1.gameTime = findTF(arg0_1._gameUI, "time")

	onButton(arg0_1._event, arg0_1.btnBack, function()
		if not var1_0.startSettlement then
			arg0_1._event:emit(PipeGameEvent.PAUSE_GAME, true)
			arg0_1._event:emit(PipeGameEvent.OPEN_LEVEL_UI)
		end
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnPause, function()
		if not var1_0.startSettlement then
			arg0_1._event:emit(PipeGameEvent.PAUSE_GAME, true)
			arg0_1._event:emit(PipeGameEvent.OPEN_PAUSE_UI)
		end
	end, SFX_CONFIRM)
end

function var0_0.show(arg0_4, arg1_4)
	setActive(arg0_4._gameUI, arg1_4)
end

function var0_0.update(arg0_5)
	return
end

function var0_0.start(arg0_6)
	arg0_6.subGameStepTime = 0

	arg0_6:show(true)
end

function var0_0.addScore(arg0_7, arg1_7)
	return
end

function var0_0.step(arg0_8, arg1_8)
	local var0_8 = var1_0.gameDragTime

	setText(arg0_8.gameTime, math.floor(var0_8))

	if var0_8 <= 0 then
		arg0_8:show(false)
	elseif var1_0.startSettlement and isActive(arg0_8._gameUI) then
		arg0_8:show(false)
	end
end

function var0_0.press(arg0_9, arg1_9, arg2_9)
	return
end

return var0_0
