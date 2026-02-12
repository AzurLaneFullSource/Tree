local var0_0 = class("PacGamingUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1

	arg0_1:initUI()
end

function var0_0.initUI(arg0_2)
	arg0_2._gameUI = findTF(arg0_2._tf, "ui/gamingUI")
	arg0_2.btnBack = findTF(arg0_2._gameUI, "back")
	arg0_2.btnPause = findTF(arg0_2._gameUI, "pause")
	arg0_2.timeTF = findTF(arg0_2._gameUI, "top/ad/time")
	arg0_2.scoreTF = findTF(arg0_2._gameUI, "top/ad/score")

	onButton(arg0_2._event, arg0_2.btnBack, function()
		if not arg0_2._gameVo.startSettlement then
			arg0_2._event:emit(SimpleMGEvent.PAUSE_GAME, true)
			arg0_2._event:emit(SimpleMGEvent.OPEN_LEVEL_UI)
		end
	end, SFX_CONFIRM)
	onButton(arg0_2._event, arg0_2.btnPause, function()
		if not arg0_2._gameVo.startSettlement then
			arg0_2._event:emit(SimpleMGEvent.PAUSE_GAME, true)
			arg0_2._event:emit(SimpleMGEvent.OPEN_PAUSE_UI)
		end
	end, SFX_CONFIRM)

	arg0_2.direct = Vector2(0, 0)
	arg0_2.joyStick = MiniGameJoyStick.New(findTF(arg0_2._gameUI, "joyStick"))
	arg0_2.joyStick.minDeadNum = 0.25

	arg0_2.joyStick:setActiveCallback(function(arg0_5)
		return
	end)
	setText(findTF(arg0_2._gameUI, "top/ad/time_desc"), i18n("pac_game_gaming_time_desc"))
	setText(findTF(arg0_2._gameUI, "top/ad/score_desc"), i18n("pac_game_gaming_score"))
end

function var0_0.Show(arg0_6, arg1_6)
	setActive(arg0_6._gameUI, arg1_6)
end

function var0_0.Update(arg0_7)
	return
end

function var0_0.Start(arg0_8)
	arg0_8.subGameStepTime = 0

	arg0_8:Show(true)

	arg0_8._editorFlag = arg0_8._gameVo:GetEditor()

	local var0_8 = getProxy(MiniGameProxy):GetHighScore(arg0_8._gameVo:GetGameId())

	if not var0_8 or not (#var0_8 > 0) or not var0_8[1] then
		local var1_8 = 0
	end

	setText(arg0_8.scoreTF, 0)

	if arg0_8._editorFlag then
		setActive(findTF(arg0_8._gameUI, "joyStick"), false)
		setActive(findTF(arg0_8._gameUI, "top"), false)
		setActive(findTF(arg0_8._gameUI, "bg_top"), false)
	end

	arg0_8._score = 0
	arg0_8._time = -1
end

function var0_0.Step(arg0_9)
	arg0_9.joyStick:step()
	arg0_9.joyStick:setDirectTarget(arg0_9.direct)
	arg0_9._gameVo:SetJoyStickData(arg0_9.joyStick:getValue())

	if arg0_9._time ~= arg0_9._gameVo:GetStepTimeInteger() then
		arg0_9._time = arg0_9._gameVo:GetStepTimeInteger()

		setText(arg0_9.timeTF, math.floor(arg0_9._time))
	end

	if arg0_9._score ~= arg0_9._gameVo:GetScore() then
		arg0_9._score = arg0_9._gameVo:GetScore()

		setText(arg0_9.scoreTF, arg0_9._score)
	end
end

function var0_0.SetChildVisible(arg0_10, arg1_10, arg2_10)
	for iter0_10 = 1, arg1_10.childCount do
		local var0_10 = arg1_10:GetChild(iter0_10 - 1)

		setActive(var0_10, arg2_10)
	end
end

function var0_0.Press(arg0_11, arg1_11, arg2_11)
	if arg1_11 == KeyCode.A then
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
	elseif arg1_11 == KeyCode.W then
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
	end
end

return var0_0
