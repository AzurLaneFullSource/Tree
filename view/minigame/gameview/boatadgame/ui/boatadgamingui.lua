local var0_0 = class("BoatAdGamingUI")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	var1_0 = BoatAdGameVo
	arg0_1._gameUI = findTF(arg0_1._tf, "ui/gamingUI")
	arg0_1.btnBack = findTF(arg0_1._gameUI, "back")
	arg0_1.btnPause = findTF(arg0_1._gameUI, "pause")
	arg0_1.gameTime = findTF(arg0_1._gameUI, "topRight/timeImg/time")
	arg0_1.gameScore = findTF(arg0_1._gameUI, "topRight/scoreImg/score")

	onButton(arg0_1._event, arg0_1.btnBack, function()
		arg0_1._event:emit(SimpleMGEvent.PAUSE_GAME, true)
		arg0_1._event:emit(SimpleMGEvent.OPEN_LEVEL_UI)
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnPause, function()
		arg0_1._event:emit(SimpleMGEvent.PAUSE_GAME, true)
		arg0_1._event:emit(SimpleMGEvent.OPEN_PAUSE_UI)
	end, SFX_CONFIRM)

	arg0_1.direct = Vector2(0, 0)
	arg0_1.joyStickTf = findTF(arg0_1._gameUI, "joyStick")
	arg0_1.joyStick = MiniGameJoyStick.New(arg0_1.joyStickTf)

	arg0_1.joyStick:setActiveCallback(function(arg0_4)
		return
	end)
end

function var0_0.show(arg0_5, arg1_5)
	setActive(arg0_5._gameUI, arg1_5)
end

function var0_0.update(arg0_6)
	return
end

function var0_0.start(arg0_7)
	arg0_7.direct = Vector2(0, 0)
	arg0_7.subGameStepTime = 0
	arg0_7._char = nil
end

function var0_0.step(arg0_8, arg1_8)
	if not arg0_8._char then
		arg0_8._char = var1_0.GetGameChar()
	end

	arg0_8.joyStickTf.position = arg0_8._char:getWorld()

	local var0_8 = var1_0.gameTime
	local var1_8 = var1_0.gameStepTime

	setText(arg0_8.gameScore, var1_0.scoreNum)
	setText(arg0_8.gameTime, math.floor(var1_8))

	if arg0_8.leftFlag and arg0_8.rightFlag then
		arg0_8.direct.x = arg0_8.lastDirect
	elseif arg0_8.leftFlag then
		arg0_8.direct.x = -1
	elseif arg0_8.rightFlag then
		arg0_8.direct.x = 1
	elseif not arg0_8.leftFlag and not arg0_8.rightFlag then
		arg0_8.direct.x = 0
	end

	arg0_8.joyStick:step()
	arg0_8.joyStick:setDirectTarget(arg0_8.direct)

	var1_0.joyStickData = arg0_8.joyStick:getValue()
end

function var0_0.press(arg0_9, arg1_9, arg2_9)
	if arg1_9 == KeyCode.W then
		-- block empty
	elseif arg1_9 == KeyCode.S then
		-- block empty
	elseif arg1_9 == KeyCode.A then
		arg0_9.leftFlag = arg2_9

		if arg2_9 then
			arg0_9.lastDirect = -1
		end
	elseif arg1_9 == KeyCode.D then
		arg0_9.rightFlag = arg2_9

		if arg2_9 then
			arg0_9.lastDirect = 1
		end
	end
end

return var0_0
