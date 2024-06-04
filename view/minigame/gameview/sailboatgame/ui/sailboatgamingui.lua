local var0 = class("SailBoatGamingUI")
local var1

function var0.Ctor(arg0, arg1, arg2)
	arg0._tf = arg1
	arg0._event = arg2
	var1 = SailBoatGameVo
	arg0._gameUI = findTF(arg0._tf, "ui/gamingUI")
	arg0.btnBack = findTF(arg0._gameUI, "back")
	arg0.btnPause = findTF(arg0._gameUI, "pause")
	arg0.gameTime = findTF(arg0._gameUI, "time")
	arg0.gameScore = findTF(arg0._gameUI, "score")
	arg0.btnSkill = findTF(arg0._gameUI, "skill")
	arg0.skillCount = findTF(arg0._gameUI, "skill/amount")
	arg0.progress = GetComponent(findTF(arg0._gameUI, "progress"), typeof(Slider))
	arg0.powerTf = findTF(arg0._gameUI, "power")

	onButton(arg0._event, arg0.btnSkill, function()
		if arg0.skillTime > 0 then
			return
		end

		if var1.UseSkill() then
			arg0._event:emit(SailBoatGameView.USE_SKILL)

			arg0.skillTime = var1.skillTime

			setActive(arg0.powerTf, false)
			setActive(arg0.powerTf, true)
		end
	end, SFX_CONFIRM)
	onButton(arg0._event, arg0.btnBack, function()
		arg0._event:emit(SailBoatGameView.PAUSE_GAME, true)
		arg0._event:emit(SailBoatGameView.OPEN_LEVEL_UI)
	end, SFX_CONFIRM)
	onButton(arg0._event, arg0.btnPause, function()
		arg0._event:emit(SailBoatGameView.PAUSE_GAME, true)
		arg0._event:emit(SailBoatGameView.OPEN_PAUSE_UI)
	end, SFX_CONFIRM)

	arg0.direct = Vector2(0, 0)
	arg0.joyStick = MiniGameJoyStick.New(findTF(arg0._gameUI, "joyStick"))

	arg0.joyStick:setActiveCallback(function(arg0)
		return
	end)

	arg0._hpTf = findTF(arg0._gameUI, "hp")
	arg0._hpSlider = GetComponent(arg0._hpTf, typeof(Slider))
	arg0._powerEnemy = findTF(arg0._gameUI, "powerEnemy")
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
	arg0.maxProgress = var1.GetRoundData().progress
	arg0.powers = Clone(var1.GetRoundData().powers)

	setText(arg0.skillCount, var1.GetSkill())

	arg0.skillTime = 0
	arg0._char = nil

	setActive(arg0._powerEnemy, false)
	setActive(arg0.powerTf, false)
end

function var0.addScore(arg0, arg1)
	local var0 = arg1.num
	local var1 = arg1.pos
	local var2 = arg1.id
end

function var0.step(arg0, arg1)
	if not arg0._char then
		arg0._char = var1.GetGameChar()
		arg0._hpSlider.minValue = 0
		arg0._hpSlider.maxValue = arg0._char:getMaxHp()
	end

	local var0 = var1.gameTime
	local var1 = var1.gameStepTime

	setText(arg0.gameScore, var1.scoreNum)
	setText(arg0.gameTime, math.floor(var0))

	arg0.progress.value = var1 / arg0.maxProgress

	arg0.joyStick:step()
	arg0.joyStick:setDirectTarget(arg0.direct)

	if arg0.skillTime > 0 then
		arg0.skillTime = arg0.skillTime - arg1
	end

	SailBoatGameVo.joyStickData = arg0.joyStick:getValue()

	setText(arg0.skillCount, var1.GetSkill())

	local var2 = arg0._char:getHpPos()

	arg0._hpTf.position = var2
	arg0.powerTf.position = var2
	arg0._hpSlider.value = arg0._char:getHp()

	for iter0 = #arg0.powers, 1, -1 do
		if var1.gameStepTime > arg0.powers[iter0] then
			table.remove(arg0.powers, iter0)
			setActive(arg0._powerEnemy, false)
			setActive(arg0._powerEnemy, true)
		end
	end
end

function var0.press(arg0, arg1, arg2)
	if arg1 == KeyCode.W then
		if arg2 then
			arg0.direct.y = 1
		elseif arg0.direct.y == 1 then
			arg0.direct.y = 0
		end
	elseif arg1 == KeyCode.S then
		if arg2 then
			arg0.direct.y = -1
		elseif arg0.direct.y == -1 then
			arg0.direct.y = 0
		end
	elseif arg1 == KeyCode.A then
		if arg2 then
			arg0.direct.x = -1
		elseif arg0.direct.x == -1 then
			arg0.direct.x = 0
		end
	elseif arg1 == KeyCode.D then
		if arg2 then
			arg0.direct.x = 1
		elseif arg0.direct.x == 1 then
			arg0.direct.x = 0
		end
	end
end

return var0
