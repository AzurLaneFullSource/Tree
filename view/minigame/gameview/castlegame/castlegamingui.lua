local var0_0 = class("CastleGamingUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameUI = findTF(arg0_1._tf, "ui/gamingUI")
	arg0_1.btnBack = findTF(arg0_1._gameUI, "back")
	arg0_1.btnPause = findTF(arg0_1._gameUI, "pause")
	arg0_1.gameTime = findTF(arg0_1._gameUI, "time")
	arg0_1.gameScore = findTF(arg0_1._gameUI, "score")
	arg0_1.joyStick = CastleGameJoyStick.New(findTF(arg0_1._gameUI, "joyStick"))

	onButton(arg0_1._event, arg0_1.btnBack, function()
		arg0_1._event:emit(CastleGameView.PAUSE_GAME, true)
		arg0_1._event:emit(CastleGameView.OPEN_LEVEL_UI)
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnPause, function()
		arg0_1._event:emit(CastleGameView.PAUSE_GAME, true)
		arg0_1._event:emit(CastleGameView.OPEN_PAUSE_UI)
	end, SFX_CONFIRM)

	arg0_1.addScoreTf = findTF(arg0_1._gameUI, "addScore")
	arg0_1.addScoreAnim = GetComponent(findTF(arg0_1._gameUI, "addScore/ad"), typeof(Animator))
end

function var0_0.show(arg0_4, arg1_4)
	setActive(arg0_4._gameUI, arg1_4)
end

function var0_0.update(arg0_5)
	return
end

function var0_0.start(arg0_6)
	setActive(arg0_6.addScoreTf, false)

	arg0_6.direct = Vector2(0, 0)
end

function var0_0.addScore(arg0_7, arg1_7)
	local var0_7 = arg1_7.num
	local var1_7 = arg1_7.pos
	local var2_7 = arg1_7.id
	local var3_7 = findTF(arg0_7.addScoreTf, "ad")
	local var4_7 = var3_7.childCount

	for iter0_7 = 0, var4_7 - 1 do
		setActive(var3_7:GetChild(iter0_7), false)
	end

	setActive(findTF(var3_7, var2_7), true)
	setText(findTF(var3_7, var2_7 .. "/txt"), "+" .. tostring(var0_7))

	arg0_7.addScoreTf.anchoredPosition = arg0_7._gameUI:InverseTransformPoint(var1_7)

	setActive(arg0_7.addScoreTf, false)
	setActive(arg0_7.addScoreTf, true)
end

function var0_0.step(arg0_8)
	arg0_8.joyStick:step()
	setText(arg0_8.gameTime, math.floor(CastleGameVo.gameTime))
	setText(arg0_8.gameScore, CastleGameVo.scoreNum)

	CastleGameVo.joyStickData = arg0_8.joyStick:getValue()

	arg0_8.joyStick:setDirectTarget(arg0_8.direct)
end

function var0_0.press(arg0_9, arg1_9, arg2_9)
	if arg1_9 == KeyCode.W then
		if arg2_9 then
			arg0_9.direct.y = 1
		elseif arg0_9.direct.y == 1 then
			arg0_9.direct.y = 0
		end
	end

	if arg1_9 == KeyCode.S then
		if arg2_9 then
			arg0_9.direct.y = -1
		elseif arg0_9.direct.y == -1 then
			arg0_9.direct.y = 0
		end
	end

	if arg1_9 == KeyCode.A then
		if arg2_9 then
			arg0_9.direct.x = -1
		elseif arg0_9.direct.x == -1 then
			arg0_9.direct.x = 0
		end
	end

	if arg1_9 == KeyCode.D then
		if arg2_9 then
			arg0_9.direct.x = 1
		elseif arg0_9.direct.x == 1 then
			arg0_9.direct.x = 0
		end
	end
end

return var0_0
