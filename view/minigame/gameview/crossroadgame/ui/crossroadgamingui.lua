local var0_0 = class("CrossRoadGamingUI")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._gameVo = arg3_1

	arg0_1:initUI()
end

function var0_0.initUI(arg0_2)
	arg0_2._gameUI = findTF(arg0_2._tf, "ui/gamingUI")
	arg0_2.btnBack = findTF(arg0_2._gameUI, "back")
	arg0_2.lifeTF = findTF(arg0_2._gameUI, "top/ad/life")
	arg0_2.scoreTF = findTF(arg0_2._gameUI, "top/ad/score")
	arg0_2.joyStick = findTF(arg0_2._gameUI, "joyStick")
	arg0_2.movebtnGroup = arg0_2.joyStick:Find("left_btn_layout/move_btn")
	arg0_2.moveLeftBtn = arg0_2.movebtnGroup:Find("left")
	arg0_2.moveRightBtn = arg0_2.movebtnGroup:Find("right")
	arg0_2.workBtn = arg0_2.joyStick:Find("right_btn_layout")
	arg0_2.goBtn = arg0_2.workBtn:Find("go/img")
	arg0_2.stopBtn = arg0_2.workBtn:Find("stop/img")
	arg0_2.time = 0
	arg0_2._life = 0
	arg0_2.joyData = {
		go = false,
		right = false,
		left = false,
		stop = false
	}

	onButton(arg0_2._event, arg0_2.btnBack, function()
		if not arg0_2._gameVo.startSettlement then
			arg0_2._event:emit(SimpleMGEvent.PAUSE_GAME, true)
			arg0_2._event:emit(CrossRoadGameView.OPEN_LEAVEL_UI)
		end
	end, SFX_CONFIRM)
	arg0_2:bindEventTrigger(arg0_2.moveLeftBtn, "left")
	arg0_2:bindEventTrigger(arg0_2.moveRightBtn, "right")
	arg0_2:bindEventTrigger(arg0_2.goBtn, "go")
	arg0_2:bindEventTrigger(arg0_2.stopBtn, "stop")
end

function var0_0.bindEventTrigger(arg0_4, arg1_4, arg2_4)
	GetOrAddComponent(arg1_4, "EventTriggerListener"):AddPointDownFunc(function()
		arg0_4:setJoyData(arg2_4, true)
	end)
	GetOrAddComponent(arg1_4, "EventTriggerListener"):AddPointUpFunc(function()
		arg0_4:setJoyData(arg2_4, false)
	end)
end

function var0_0.setJoyData(arg0_7, arg1_7, arg2_7)
	arg0_7.joyData[arg1_7] = arg2_7

	arg0_7._gameVo:SetJoyStickData(arg0_7.joyData)
end

function var0_0.Show(arg0_8, arg1_8)
	setActive(arg0_8._gameUI, arg1_8)
end

function var0_0.Start(arg0_9)
	arg0_9.subGameStepTime = 0

	arg0_9:Show(true)
	arg0_9._gameVo:SetJoyStickData(arg0_9.joyData)

	local var0_9 = getProxy(MiniGameProxy):GetHighScore(arg0_9._gameVo:GetGameId())

	if not var0_9 or not (#var0_9 > 0) or not var0_9[1] then
		local var1_9 = 0
	end

	setText(arg0_9.scoreTF, 0)

	if arg0_9._editorFlag then
		setActive(findTF(arg0_9._gameUI, "joyStick"), false)
		setActive(findTF(arg0_9._gameUI, "top"), false)
		setActive(findTF(arg0_9._gameUI, "bg_top"), false)
	end

	arg0_9._score = 0
	arg0_9._time = -1
end

function var0_0.Step(arg0_10)
	arg0_10:AddDebugInput()

	if arg0_10._score ~= arg0_10._gameVo:GetScore() then
		arg0_10._score = arg0_10._gameVo:GetScore()

		setText(arg0_10.scoreTF, arg0_10._score)
	end

	if arg0_10._life ~= arg0_10._gameVo:GetLife() then
		arg0_10._life = arg0_10._gameVo:GetLife()

		setText(arg0_10.lifeTF, "X" .. arg0_10._life)
	end
end

function var0_0.AddDebugInput(arg0_11)
	if IsUnityEditor then
		if Input.GetKeyDown(KeyCode.A) then
			arg0_11:setJoyData("left", true)
		end

		if Input.GetKeyUp(KeyCode.A) then
			arg0_11:setJoyData("left", false)
		end

		if Input.GetKeyDown(KeyCode.D) then
			arg0_11:setJoyData("right", true)
		end

		if Input.GetKeyUp(KeyCode.D) then
			arg0_11:setJoyData("right", false)
		end

		if Input.GetKeyDown(KeyCode.J) then
			arg0_11:setJoyData("go", true)
		end

		if Input.GetKeyUp(KeyCode.J) then
			arg0_11:setJoyData("go", false)
		end

		if Input.GetKeyDown(KeyCode.K) then
			arg0_11:setJoyData("stop", true)
		end

		if Input.GetKeyUp(KeyCode.K) then
			arg0_11:setJoyData("stop", false)
		end
	end
end

function var0_0.SetChildVisible(arg0_12, arg1_12, arg2_12)
	for iter0_12 = 1, arg1_12.childCount do
		local var0_12 = arg1_12:GetChild(iter0_12 - 1)

		setActive(var0_12, arg2_12)
	end
end

return var0_0
