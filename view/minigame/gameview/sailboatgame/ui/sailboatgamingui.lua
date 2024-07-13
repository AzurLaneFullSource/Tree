local var0_0 = class("SailBoatGamingUI")
local var1_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	var1_0 = SailBoatGameVo
	arg0_1._gameUI = findTF(arg0_1._tf, "ui/gamingUI")
	arg0_1.btnBack = findTF(arg0_1._gameUI, "back")
	arg0_1.btnPause = findTF(arg0_1._gameUI, "pause")
	arg0_1.gameTime = findTF(arg0_1._gameUI, "time")
	arg0_1.gameScore = findTF(arg0_1._gameUI, "score")
	arg0_1.btnSkill = findTF(arg0_1._gameUI, "skill")
	arg0_1.skillCount = findTF(arg0_1._gameUI, "skill/amount")
	arg0_1.progress = GetComponent(findTF(arg0_1._gameUI, "progress"), typeof(Slider))
	arg0_1.powerTf = findTF(arg0_1._gameUI, "power")

	onButton(arg0_1._event, arg0_1.btnSkill, function()
		if arg0_1.skillTime > 0 then
			return
		end

		if var1_0.UseSkill() then
			arg0_1._event:emit(SailBoatGameView.USE_SKILL)

			arg0_1.skillTime = var1_0.skillTime

			setActive(arg0_1.powerTf, false)
			setActive(arg0_1.powerTf, true)
		end
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnBack, function()
		arg0_1._event:emit(SailBoatGameView.PAUSE_GAME, true)
		arg0_1._event:emit(SailBoatGameView.OPEN_LEVEL_UI)
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnPause, function()
		arg0_1._event:emit(SailBoatGameView.PAUSE_GAME, true)
		arg0_1._event:emit(SailBoatGameView.OPEN_PAUSE_UI)
	end, SFX_CONFIRM)

	arg0_1.direct = Vector2(0, 0)
	arg0_1.joyStick = MiniGameJoyStick.New(findTF(arg0_1._gameUI, "joyStick"))

	arg0_1.joyStick:setActiveCallback(function(arg0_5)
		return
	end)

	arg0_1._hpTf = findTF(arg0_1._gameUI, "hp")
	arg0_1._hpSlider = GetComponent(arg0_1._hpTf, typeof(Slider))
	arg0_1._powerEnemy = findTF(arg0_1._gameUI, "powerEnemy")
end

function var0_0.show(arg0_6, arg1_6)
	setActive(arg0_6._gameUI, arg1_6)
end

function var0_0.update(arg0_7)
	return
end

function var0_0.start(arg0_8)
	arg0_8.direct = Vector2(0, 0)
	arg0_8.subGameStepTime = 0
	arg0_8.maxProgress = var1_0.GetRoundData().progress
	arg0_8.powers = Clone(var1_0.GetRoundData().powers)

	setText(arg0_8.skillCount, var1_0.GetSkill())

	arg0_8.skillTime = 0
	arg0_8._char = nil

	setActive(arg0_8._powerEnemy, false)
	setActive(arg0_8.powerTf, false)
end

function var0_0.addScore(arg0_9, arg1_9)
	local var0_9 = arg1_9.num
	local var1_9 = arg1_9.pos
	local var2_9 = arg1_9.id
end

function var0_0.step(arg0_10, arg1_10)
	if not arg0_10._char then
		arg0_10._char = var1_0.GetGameChar()
		arg0_10._hpSlider.minValue = 0
		arg0_10._hpSlider.maxValue = arg0_10._char:getMaxHp()
	end

	local var0_10 = var1_0.gameTime
	local var1_10 = var1_0.gameStepTime

	setText(arg0_10.gameScore, var1_0.scoreNum)
	setText(arg0_10.gameTime, math.floor(var0_10))

	arg0_10.progress.value = var1_10 / arg0_10.maxProgress

	arg0_10.joyStick:step()
	arg0_10.joyStick:setDirectTarget(arg0_10.direct)

	if arg0_10.skillTime > 0 then
		arg0_10.skillTime = arg0_10.skillTime - arg1_10
	end

	SailBoatGameVo.joyStickData = arg0_10.joyStick:getValue()

	setText(arg0_10.skillCount, var1_0.GetSkill())

	local var2_10 = arg0_10._char:getHpPos()

	arg0_10._hpTf.position = var2_10
	arg0_10.powerTf.position = var2_10
	arg0_10._hpSlider.value = arg0_10._char:getHp()

	for iter0_10 = #arg0_10.powers, 1, -1 do
		if var1_0.gameStepTime > arg0_10.powers[iter0_10] then
			table.remove(arg0_10.powers, iter0_10)
			setActive(arg0_10._powerEnemy, false)
			setActive(arg0_10._powerEnemy, true)
		end
	end
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

return var0_0
