local var0 = class("LaunchBallGamingUI")

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	arg0._gameUI = findTF(arg0._tf, "ui/gamingUI")
	arg0.btnBack = findTF(arg0._gameUI, "back")
	arg0.btnPause = findTF(arg0._gameUI, "pause")
	arg0.gameTime = findTF(arg0._gameUI, "time")
	arg0.gameScore = findTF(arg0._gameUI, "score")

	onButton(arg0._event, arg0.btnBack, function()
		arg0._event:emit(LaunchBallGameView.PAUSE_GAME, true)
		arg0._event:emit(LaunchBallGameView.OPEN_LEVEL_UI)
	end, SFX_CONFIRM)
	onButton(arg0._event, arg0.btnPause, function()
		arg0._event:emit(LaunchBallGameView.PAUSE_GAME, true)
		arg0._event:emit(LaunchBallGameView.OPEN_PAUSE_UI)
	end, SFX_CONFIRM)

	arg0.direct = Vector2(0, 0)
	arg0.skill = findTF(arg0._gameUI, "Skill")
	arg0.skillAnim = GetComponent(findTF(arg0.skill, "ad/anim"), typeof(Animator))

	onButton(arg0._event, arg0.skill, function()
		arg0._event:emit(LaunchBallGameView.PRESS_SKILL)
	end)

	arg0.skillCd = findTF(arg0.skill, "ad/black")
end

function var0.show(arg0, arg1)
	setActive(arg0._gameUI, arg1)
end

function var0.update(arg0)
	return
end

function var0.start(arg0)
	arg0.direct = Vector2(0, 0)
	arg0.subGameStepTime = 0
end

function var0.addScore(arg0, arg1)
	local var0 = arg1.num
	local var1 = arg1.pos
	local var2 = arg1.id
end

function var0.step(arg0)
	if LaunchBallGameVo.enemyStopTime and LaunchBallGameVo.enemyStopTime > 0 then
		arg0.subGameStepTime = arg0.subGameStepTime + LaunchBallGameVo.deltaTime
	end

	setText(arg0.gameTime, math.floor(LaunchBallGameVo.gameStepTime - arg0.subGameStepTime))
	setText(arg0.gameScore, LaunchBallGameVo.scoreNum)

	local var0 = LaunchBallGameVo.pressSkill

	if var0 and var0.time > 0 then
		setFillAmount(arg0.skillCd, var0.time / var0.data.cd_time)

		if not isActive(arg0.skillCd) then
			arg0.skillAnim:Play("empty")
			setActive(arg0.skillCd, true)
		end
	elseif isActive(arg0.skillCd) then
		setActive(arg0.skillCd, false)
		arg0.skillAnim:Play("Skill")
	end
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
