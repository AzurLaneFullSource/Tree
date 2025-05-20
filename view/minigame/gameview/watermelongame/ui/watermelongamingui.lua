local var0_0 = class("WatermelonGamingUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1
	arg0_1._gameUI = findTF(arg0_1._tf, "ui/gamingUI")
	arg0_1.btnBack = findTF(arg0_1._gameUI, "back")
	arg0_1.btnPause = findTF(arg0_1._gameUI, "pause")
	arg0_1.gameTime = findTF(arg0_1._gameUI, "time")
	arg0_1.touchUI = findTF(arg0_1._gameUI, "touch")
	arg0_1.touchEvent = GetComponent(arg0_1.touchUI, typeof(EventTriggerListener))
	arg0_1.uiCam = GameObject.Find("UICamera"):GetComponent("Camera")

	arg0_1.touchEvent:AddPointDownFunc(function(arg0_2, arg1_2)
		local var0_2 = arg0_1.uiCam:ScreenToWorldPoint(arg1_2.position)

		arg0_1._event:emit(WatermelonGameEvent.CLICK_MOVE, {
			pos = var0_2,
			callback = function(arg0_3)
				arg0_1.startDrag = arg0_3
			end
		})
	end)
	arg0_1.touchEvent:AddPointUpFunc(function(arg0_4, arg1_4)
		local var0_4 = arg0_1.uiCam:ScreenToWorldPoint(arg1_4.position)

		if arg0_1.startDrag then
			arg0_1._event:emit(WatermelonGameEvent.CLICK_DOWN, var0_4)
		end
	end)
	arg0_1.touchEvent:AddDragFunc(function(arg0_5, arg1_5)
		if arg0_1.startDrag then
			local var0_5 = arg0_1.uiCam:ScreenToWorldPoint(arg1_5.position)

			arg0_1._event:emit(WatermelonGameEvent.CLICK_MOVE, {
				pos = var0_5
			})
		end
	end)
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

	arg0_1.joyStick:setActiveCallback(function(arg0_8)
		return
	end)

	arg0_1.btnDown = findTF(arg0_1._gameUI, "down")

	onButton(arg0_1._event, arg0_1.btnDown, function()
		arg0_1._event:emit(WatermelonGameEvent.CLICK_DOWN)
	end, SFX_CONFIRM)

	arg0_1.scoreHigh = findTF(arg0_1._gameUI, "score/high")
	arg0_1.scoreCurrent = findTF(arg0_1._gameUI, "score/current")
	arg0_1.nextBall = findTF(arg0_1._gameUI, "next/ball")
end

function var0_0.show(arg0_10, arg1_10)
	setActive(arg0_10._gameUI, arg1_10)
end

function var0_0.update(arg0_11)
	return
end

function var0_0.start(arg0_12)
	arg0_12.subGameStepTime = 0

	arg0_12:show(true)

	local var0_12 = getProxy(MiniGameProxy):GetHighScore(arg0_12._gameVo.gameId)
	local var1_12 = var0_12 and #var0_12 > 0 and var0_12[1] or 0

	setText(arg0_12.scoreHigh, var1_12)
	setText(arg0_12.scoreCurrent, 0)
	arg0_12:setChildVisible(arg0_12.nextBall, false)
end

function var0_0.addScore(arg0_13, arg1_13)
	setText(arg0_13.scoreCurrent, arg0_13._gameVo.scoreNum)
end

function var0_0.step(arg0_14, arg1_14)
	local var0_14 = arg0_14._gameVo.gameTime

	setText(arg0_14.gameTime, math.floor(var0_14))
	arg0_14.joyStick:step()
	arg0_14.joyStick:setDirectTarget(arg0_14.direct)
	arg0_14._gameVo:setJoyStickData(arg0_14.joyStick:getValue())
end

function var0_0.updateBallId(arg0_15, arg1_15)
	arg0_15:setChildVisible(arg0_15.nextBall, false)
	setActive(findTF(arg0_15.nextBall, arg1_15), true)
end

function var0_0.setChildVisible(arg0_16, arg1_16, arg2_16)
	for iter0_16 = 1, arg1_16.childCount do
		local var0_16 = arg1_16:GetChild(iter0_16 - 1)

		setActive(var0_16, arg2_16)
	end
end

function var0_0.press(arg0_17, arg1_17, arg2_17)
	if arg1_17 == KeyCode.A then
		if arg2_17 then
			arg0_17.direct.x = -1
		elseif arg0_17.direct.x == -1 then
			arg0_17.direct.x = 0
		end
	elseif arg1_17 == KeyCode.D then
		if arg2_17 then
			arg0_17.direct.x = 1
		elseif arg0_17.direct.x == 1 then
			arg0_17.direct.x = 0
		end
	elseif arg1_17 == KeyCode.J then
		arg0_17._event:emit(WatermelonGameEvent.CLICK_DOWN)
	end
end

return var0_0
