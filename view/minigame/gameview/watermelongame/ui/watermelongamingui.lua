local var0_0 = class("WatermelonGamingUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1._gameUI = findTF(arg0_1._tf, "ui/gamingUI")
	arg0_1.btnBack = findTF(arg0_1._gameUI, "back")
	arg0_1.btnPause = findTF(arg0_1._gameUI, "pause")
	arg0_1.gameTime = findTF(arg0_1._gameUI, "time")

	onButton(arg0_1._event, arg0_1.btnBack, function()
		if not arg0_1._gameVo.startSettlement then
			arg0_1._event:emit(WatermelonGameEvent.PAUSE_GAME, true)
			arg0_1._event:emit(WatermelonGameEvent.OPEN_LEVEL_UI)
		end
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnPause, function()
		if not arg0_1._gameVo.startSettlement then
			arg0_1._event:emit(WatermelonGameEvent.PAUSE_GAME, true)
			arg0_1._event:emit(WatermelonGameEvent.OPEN_PAUSE_UI)
		end
	end, SFX_CONFIRM)

	arg0_1.direct = Vector2(0, 0)
	arg0_1.joyStick = MiniGameJoyStick.New(findTF(arg0_1._gameUI, "joyStick"))

	arg0_1.joyStick:setActiveCallback(function(arg0_4)
		return
	end)

	arg0_1.btnDown = findTF(arg0_1._gameUI, "down")

	onButton(arg0_1._event, arg0_1.btnDown, function()
		arg0_1._event:emit(WatermelonGameEvent.CLICK_DOWN)
	end, SFX_CONFIRM)
end

function var0_0.show(arg0_6, arg1_6)
	setActive(arg0_6._gameUI, arg1_6)
end

function var0_0.update(arg0_7)
	return
end

function var0_0.start(arg0_8)
	arg0_8.subGameStepTime = 0

	arg0_8:show(true)
end

function var0_0.addScore(arg0_9, arg1_9)
	return
end

function var0_0.step(arg0_10, arg1_10)
	local var0_10 = arg0_10._gameVo.gameTime

	setText(arg0_10.gameTime, math.floor(var0_10))
	arg0_10.joyStick:step()
	arg0_10.joyStick:setDirectTarget(arg0_10.direct)
	arg0_10._gameVo:setJoyStickData(arg0_10.joyStick:getValue())
end

function var0_0.press(arg0_11, arg1_11, arg2_11)
	if arg1_11 == KeyCode.W then
		if arg2_11 then
			arg0_11.direct.y = 1
		elseif arg0_11.direct.y == 1 then
			arg0_11.direct.y = 0
		end
	elseif arg1_11 == KeyCode.S then
		if arg2_11 then
			arg0_11.direct.y = -1
		elseif arg0_11.direct.y == -1 then
			arg0_11.direct.y = 0
		end
	elseif arg1_11 == KeyCode.A then
		if arg2_11 then
			arg0_11.direct.x = -1
		elseif arg0_11.direct.x == -1 then
			arg0_11.direct.x = 0
		end
	elseif arg1_11 == KeyCode.D then
		if arg2_11 then
			arg0_11.direct.x = 1
		elseif arg0_11.direct.x == 1 then
			arg0_11.direct.x = 0
		end
	end
end

function var0_0.press(arg0_12, arg1_12, arg2_12)
	if arg1_12 == KeyCode.A then
		if arg2_12 then
			arg0_12.direct.x = -1
		elseif arg0_12.direct.x == -1 then
			arg0_12.direct.x = 0
		end
	elseif arg1_12 == KeyCode.D then
		if arg2_12 then
			arg0_12.direct.x = 1
		elseif arg0_12.direct.x == 1 then
			arg0_12.direct.x = 0
		end
	elseif arg1_12 == KeyCode.J then
		arg0_12._event:emit(WatermelonGameEvent.CLICK_DOWN)
	end
end

return var0_0
