local var0_0 = class("LaunchBallGamingUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameUI = findTF(arg0_1._tf, "ui/gamingUI")
	arg0_1.btnBack = findTF(arg0_1._gameUI, "back")
	arg0_1.btnPause = findTF(arg0_1._gameUI, "pause")
	arg0_1.gameTime = findTF(arg0_1._gameUI, "time")
	arg0_1.gameScore = findTF(arg0_1._gameUI, "score")

	onButton(arg0_1._event, arg0_1.btnBack, function()
		arg0_1._event:emit(LaunchBallGameView.PAUSE_GAME, true)
		arg0_1._event:emit(LaunchBallGameView.OPEN_LEVEL_UI)
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnPause, function()
		arg0_1._event:emit(LaunchBallGameView.PAUSE_GAME, true)
		arg0_1._event:emit(LaunchBallGameView.OPEN_PAUSE_UI)
	end, SFX_CONFIRM)

	arg0_1.direct = Vector2(0, 0)
	arg0_1.skill = findTF(arg0_1._gameUI, "Skill")
	arg0_1.skillAnim = GetComponent(findTF(arg0_1.skill, "ad/anim"), typeof(Animator))

	onButton(arg0_1._event, arg0_1.skill, function()
		arg0_1._event:emit(LaunchBallGameView.PRESS_SKILL)
	end)

	arg0_1.skillCd = findTF(arg0_1.skill, "ad/black")
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
end

function var0_0.addScore(arg0_8, arg1_8)
	local var0_8 = arg1_8.num
	local var1_8 = arg1_8.pos
	local var2_8 = arg1_8.id
end

function var0_0.step(arg0_9)
	if LaunchBallGameVo.enemyStopTime and LaunchBallGameVo.enemyStopTime > 0 then
		arg0_9.subGameStepTime = arg0_9.subGameStepTime + LaunchBallGameVo.deltaTime
	end

	setText(arg0_9.gameTime, math.floor(LaunchBallGameVo.gameStepTime - arg0_9.subGameStepTime))
	setText(arg0_9.gameScore, LaunchBallGameVo.scoreNum)

	local var0_9 = LaunchBallGameVo.pressSkill

	if var0_9 and var0_9.time > 0 then
		setFillAmount(arg0_9.skillCd, var0_9.time / var0_9.data.cd_time)

		if not isActive(arg0_9.skillCd) then
			arg0_9.skillAnim:Play("empty")
			setActive(arg0_9.skillCd, true)
		end
	elseif isActive(arg0_9.skillCd) then
		setActive(arg0_9.skillCd, false)
		arg0_9.skillAnim:Play("Skill")
	end
end

function var0_0.press(arg0_10, arg1_10, arg2_10)
	if arg1_10 == KeyCode.W then
		if arg2_10 then
			arg0_10.direct.y = 1
		elseif arg0_10.direct.y == 1 then
			arg0_10.direct.y = 0
		end
	end

	if arg1_10 == KeyCode.S then
		if arg2_10 then
			arg0_10.direct.y = -1
		elseif arg0_10.direct.y == -1 then
			arg0_10.direct.y = 0
		end
	end

	if arg1_10 == KeyCode.A then
		if arg2_10 then
			arg0_10.direct.x = -1
		elseif arg0_10.direct.x == -1 then
			arg0_10.direct.x = 0
		end
	end

	if arg1_10 == KeyCode.D then
		if arg2_10 then
			arg0_10.direct.x = 1
		elseif arg0_10.direct.x == 1 then
			arg0_10.direct.x = 0
		end
	end
end

return var0_0
