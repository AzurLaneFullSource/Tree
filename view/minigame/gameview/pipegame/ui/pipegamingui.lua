local var0 = class("PipeGamingUI")
local var1

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	var1 = PipeGameVo
	arg0._gameUI = findTF(arg0._tf, "ui/gamingUI")
	arg0.btnBack = findTF(arg0._gameUI, "back")
	arg0.btnPause = findTF(arg0._gameUI, "pause")
	arg0.gameTime = findTF(arg0._gameUI, "time")

	onButton(arg0._event, arg0.btnBack, function()
		if not var1.startSettlement then
			arg0._event:emit(PipeGameEvent.PAUSE_GAME, true)
			arg0._event:emit(PipeGameEvent.OPEN_LEVEL_UI)
		end
	end, SFX_CONFIRM)
	onButton(arg0._event, arg0.btnPause, function()
		if not var1.startSettlement then
			arg0._event:emit(PipeGameEvent.PAUSE_GAME, true)
			arg0._event:emit(PipeGameEvent.OPEN_PAUSE_UI)
		end
	end, SFX_CONFIRM)
end

function var0.show(arg0, arg1)
	setActive(arg0._gameUI, arg1)
end

function var0.update(arg0)
	return
end

function var0.start(arg0)
	arg0.subGameStepTime = 0

	arg0:show(true)
end

function var0.addScore(arg0, arg1)
	return
end

function var0.step(arg0, arg1)
	local var0 = var1.gameDragTime

	setText(arg0.gameTime, math.floor(var0))

	if var0 <= 0 then
		arg0:show(false)
	elseif var1.startSettlement and isActive(arg0._gameUI) then
		arg0:show(false)
	end
end

function var0.press(arg0, arg1, arg2)
	return
end

return var0
