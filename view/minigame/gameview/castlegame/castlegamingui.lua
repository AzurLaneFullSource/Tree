local var0 = class("CastleGamingUI")

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	arg0._gameUI = findTF(arg0._tf, "ui/gamingUI")
	arg0.btnBack = findTF(arg0._gameUI, "back")
	arg0.btnPause = findTF(arg0._gameUI, "pause")
	arg0.gameTime = findTF(arg0._gameUI, "time")
	arg0.gameScore = findTF(arg0._gameUI, "score")
	arg0.joyStick = CastleGameJoyStick.New(findTF(arg0._gameUI, "joyStick"))

	onButton(arg0._event, arg0.btnBack, function()
		arg0._event:emit(CastleGameView.PAUSE_GAME, true)
		arg0._event:emit(CastleGameView.OPEN_LEVEL_UI)
	end, SFX_CONFIRM)
	onButton(arg0._event, arg0.btnPause, function()
		arg0._event:emit(CastleGameView.PAUSE_GAME, true)
		arg0._event:emit(CastleGameView.OPEN_PAUSE_UI)
	end, SFX_CONFIRM)

	arg0.addScoreTf = findTF(arg0._gameUI, "addScore")
	arg0.addScoreAnim = GetComponent(findTF(arg0._gameUI, "addScore/ad"), typeof(Animator))
end

function var0.show(arg0, arg1)
	setActive(arg0._gameUI, arg1)
end

function var0.update(arg0)
	return
end

function var0.start(arg0)
	setActive(arg0.addScoreTf, false)

	arg0.direct = Vector2(0, 0)
end

function var0.addScore(arg0, arg1)
	local var0 = arg1.num
	local var1 = arg1.pos
	local var2 = arg1.id
	local var3 = findTF(arg0.addScoreTf, "ad")
	local var4 = var3.childCount

	for iter0 = 0, var4 - 1 do
		setActive(var3:GetChild(iter0), false)
	end

	setActive(findTF(var3, var2), true)
	setText(findTF(var3, var2 .. "/txt"), "+" .. tostring(var0))

	arg0.addScoreTf.anchoredPosition = arg0._gameUI:InverseTransformPoint(var1)

	setActive(arg0.addScoreTf, false)
	setActive(arg0.addScoreTf, true)
end

function var0.step(arg0)
	arg0.joyStick:step()
	setText(arg0.gameTime, math.floor(CastleGameVo.gameTime))
	setText(arg0.gameScore, CastleGameVo.scoreNum)

	CastleGameVo.joyStickData = arg0.joyStick:getValue()

	arg0.joyStick:setDirectTarget(arg0.direct)
end

function var0.press(arg0, arg1, arg2)
	if arg1 == KeyCode.W then
		if arg2 then
			arg0.direct.y = 1
		elseif arg0.direct.y == 1 then
			arg0.direct.y = 0
		end
	end

	if arg1 == KeyCode.S then
		if arg2 then
			arg0.direct.y = -1
		elseif arg0.direct.y == -1 then
			arg0.direct.y = 0
		end
	end

	if arg1 == KeyCode.A then
		if arg2 then
			arg0.direct.x = -1
		elseif arg0.direct.x == -1 then
			arg0.direct.x = 0
		end
	end

	if arg1 == KeyCode.D then
		if arg2 then
			arg0.direct.x = 1
		elseif arg0.direct.x == 1 then
			arg0.direct.x = 0
		end
	end
end

return var0
