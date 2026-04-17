local var0_0 = class("CutFruitGamingUI")

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

	arg0_2.btnUp = findTF(arg0_2._gameUI, "up")
	arg0_2.btnDown = findTF(arg0_2._gameUI, "down")
	arg0_2.btnLeft = findTF(arg0_2._gameUI, "left")
	arg0_2.btnRight = findTF(arg0_2._gameUI, "right")

	onButton(arg0_2._event, arg0_2.btnUp, function()
		arg0_2._event:emit(CutFruitGameView.EVENT_DIRECT, CutFruitGameConst.DIRECT_UP)
	end)
	onButton(arg0_2._event, arg0_2.btnDown, function()
		arg0_2._event:emit(CutFruitGameView.EVENT_DIRECT, CutFruitGameConst.DIRECT_DOWN)
	end)
	onButton(arg0_2._event, arg0_2.btnLeft, function()
		arg0_2._event:emit(CutFruitGameView.EVENT_DIRECT, CutFruitGameConst.DIRECT_LEFT)
	end)
	onButton(arg0_2._event, arg0_2.btnRight, function()
		arg0_2._event:emit(CutFruitGameView.EVENT_DIRECT, CutFruitGameConst.DIRECT_RIGHT)
	end)
end

function var0_0.Show(arg0_9, arg1_9)
	setActive(arg0_9._gameUI, arg1_9)
end

function var0_0.Update(arg0_10)
	return
end

function var0_0.Start(arg0_11)
	arg0_11.subGameStepTime = 0

	arg0_11:Show(true)

	arg0_11._editorFlag = arg0_11._gameVo:GetEditor()

	local var0_11 = getProxy(MiniGameProxy):GetHighScore(arg0_11._gameVo:GetGameId())

	if not var0_11 or not (#var0_11 > 0) or not var0_11[1] then
		local var1_11 = 0
	end

	arg0_11._score = 0
	arg0_11._time = -1
end

function var0_0.Step(arg0_12)
	if arg0_12._time ~= arg0_12._gameVo:GetTimeInteger() then
		arg0_12._time = arg0_12._gameVo:GetTimeInteger()

		if arg0_12._time < 0 then
			arg0_12._time = 0
		end

		setText(arg0_12.timeTF, math.floor(arg0_12._time))
	end

	if arg0_12._score ~= arg0_12._gameVo:GetScore() then
		arg0_12._score = arg0_12._gameVo:GetScore()
	end
end

function var0_0.SetChildVisible(arg0_13, arg1_13, arg2_13)
	for iter0_13 = 1, arg1_13.childCount do
		local var0_13 = arg1_13:GetChild(iter0_13 - 1)

		setActive(var0_13, arg2_13)
	end
end

function var0_0.Press(arg0_14, arg1_14, arg2_14)
	return
end

return var0_0
