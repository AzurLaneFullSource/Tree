local var0_0 = class("CutFruitGameController")
local var1_0 = 0
local var2_0 = 1
local var3_0 = 2
local var4_0 = 5
local var5_0 = 2

function var0_0.Ctor(arg0_1, arg1_1, arg2_1, arg3_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	arg0_1._data = arg3_1
	arg0_1._spineChar = nil
	arg0_1._npcSpines = {}
	arg0_1._charContent = findTF(arg0_1._tf, "char")
	arg0_1._npcContent = findTF(arg0_1._tf, "npc")
	arg0_1._directPanel = findTF(arg0_1._tf, "direct")
	arg0_1._directPanelAniamtor = GetComponent(findTF(arg0_1._tf, "direct"), typeof(Animator))
	arg0_1._directPanelDftEvent = GetComponent(findTF(arg0_1._tf, "direct"), typeof(DftAniEvent))

	arg0_1._directPanelDftEvent:SetEndEvent(function()
		SetActive(arg0_1._directPanel, false)
	end)

	arg0_1._directContent = findTF(arg0_1._tf, "direct/ad/list")
	arg0_1._directGrids = {}
	arg0_1._directGridTpl = findTF(arg0_1._tf, "direct/ad/list/grid_tpl")

	setActive(arg0_1._directGridTpl, false)

	for iter0_1 = 1, var4_0 do
		local var0_1 = tf(Instantiate(arg0_1._directGridTpl))

		SetParent(var0_1, arg0_1._directContent)
		setActive(var0_1, false)
		table.insert(arg0_1._directGrids, var0_1)
	end

	arg0_1._directRandomList = {
		CutFruitGameConst.DIRECT_UP,
		CutFruitGameConst.DIRECT_DOWN,
		CutFruitGameConst.DIRECT_LEFT,
		CutFruitGameConst.DIRECT_RIGHT
	}

	setActive(arg0_1._directPanel, false)

	arg0_1.watermelonTF = findTF(arg0_1._tf, "watermelon")
	arg0_1.watermelonAnimUI = GetComponent(findTF(arg0_1.watermelonTF, "ad/spine"), typeof(SpineAnimUI))
end

function var0_0.Prepare(arg0_3)
	arg0_3:clearUI()
	setActive(arg0_3._directPanel, false)

	arg0_3._charConfig = arg0_3._data:GetChar()
	arg0_3._npcConfig = arg0_3._data:GetNpc()
	arg0_3._targetConfig = arg0_3._data:GetConfig("target")
	arg0_3._distanceConfig = arg0_3._data:GetConfig("distance")
	arg0_3._speedConfig = arg0_3._data:GetConfig("speed")

	arg0_3:prepareChar(arg0_3._charConfig, arg0_3._charContent, function(arg0_4)
		arg0_3._spineChar = arg0_4

		arg0_3:setCharAniamtion(arg0_3._spineChar, "stand", true)
	end)
	arg0_3.watermelonAnimUI:SetAction("normal", 0)

	for iter0_3 = 1, #arg0_3._npcConfig do
		local var0_3 = iter0_3

		arg0_3:prepareChar(arg0_3._npcConfig[iter0_3], findTF(arg0_3._npcContent, var0_3), function(arg0_5)
			table.insert(arg0_3._npcSpines, arg0_5)
		end)
	end

	arg0_3._stepDirectTime = var5_0
	arg0_3._inputFlag = false
	arg0_3._gameOverFlag = false
end

function var0_0.Start(arg0_6)
	for iter0_6 = 1, #arg0_6._npcSpines do
		arg0_6:setCharAniamtion(arg0_6._npcSpines[iter0_6], "cheer", true)
	end

	arg0_6._currrentPosition = 0
	arg0_6._targetPosition = 0
	arg0_6._gameOverStep = nil
end

function var0_0.Step(arg0_7, arg1_7)
	if arg0_7._gameOverStep and arg0_7._gameOverStep > 0 then
		arg0_7._gameOverStep = arg0_7._gameOverStep - arg1_7

		if arg0_7._gameOverStep <= 0 then
			arg0_7._gameOverStep = nil

			arg0_7._event:emit(SimpleMGEvent.GAME_OVER, true)
		end

		return
	end

	if arg0_7._stepDirectTime and arg0_7._stepDirectTime > 0 then
		arg0_7._stepDirectTime = arg0_7._stepDirectTime - arg1_7

		if arg0_7._stepDirectTime <= 0 then
			arg0_7._stepDirectTime = nil

			arg0_7:SetDirectData(arg0_7:getRandomDirect())
		end
	end

	if arg0_7._currrentPosition < arg0_7._targetPosition then
		local var0_7 = arg0_7._speedConfig * arg1_7

		arg0_7._currrentPosition = arg0_7._currrentPosition + var0_7

		if arg0_7._currrentPosition > arg0_7._targetPosition then
			arg0_7._currrentPosition = arg0_7._targetPosition

			arg0_7:setCharAniamtion(arg0_7._spineChar, "stand", true)
		else
			arg0_7:setCharAniamtion(arg0_7._spineChar, "walk", true)
		end

		local var1_7 = arg0_7._spineChar:GetAnchoredPosition()

		var1_7.x = var1_7.x + var0_7

		arg0_7._spineChar:SetAnchoredPosition(var1_7)
	end

	if arg0_7._currrentPosition >= arg0_7._targetConfig then
		arg0_7._event:emit(SimpleMGEvent.STOP_TIME_STEP, true)

		if not arg0_7._gameOverFlag then
			arg0_7._gameOverFlag = true
			arg0_7._gameOverStep = 2

			arg0_7:setCharAniamtion(arg0_7._spineChar, "attack", false, "cheer", function()
				return
			end)
			arg0_7.watermelonAnimUI:SetActionCallBack(function(arg0_9)
				if arg0_9 == "finish" then
					arg0_7.watermelonAnimUI:SetAction("action2", 0)
					arg0_7.watermelonAnimUI:SetActionCallBack(nil)
				end
			end)
			arg0_7.watermelonAnimUI:SetAction("action1", 0)
		end
	end
end

function var0_0.Stop(arg0_10)
	return
end

function var0_0.Clear(arg0_11)
	return
end

function var0_0.Resume(arg0_12)
	return
end

function var0_0.GameOver(arg0_13)
	if not arg0_13._gameOverFlag then
		arg0_13:setCharAniamtion(arg0_13._spineChar, "lose", true)
	end
end

function var0_0.Dispose(arg0_14)
	arg0_14.watermelonAnimUI:SetActionCallBack(nil)
	arg0_14._directPanelDftEvent:SetEndEvent(nil)
	arg0_14:clearUI()
end

function var0_0.CharMove(arg0_15)
	arg0_15._targetPosition = arg0_15._targetPosition + arg0_15._distanceConfig

	if arg0_15._targetPosition > arg0_15._targetConfig then
		arg0_15._targetPosition = arg0_15._targetConfig
	end
end

function var0_0.setCharAniamtion(arg0_16, arg1_16, arg2_16, arg3_16, arg4_16, arg5_16)
	if not arg1_16 then
		return
	end

	if arg3_16 then
		if arg1_16:GetActionName() ~= arg2_16 then
			arg1_16:SetAction(arg2_16, 0)
		end
	else
		arg1_16:SetActionOnce(arg2_16, 0, nil, function()
			if arg4_16 then
				arg1_16:SetAction(arg4_16, 0)
			end

			if arg5_16 then
				arg5_16()
			end
		end)
	end
end

function var0_0.prepareChar(arg0_18, arg1_18, arg2_18, arg3_18)
	local var0_18 = CutFruitGameConst.character_name[arg1_18]
	local var1_18 = SpineAnimChar.New()

	var1_18:SetPaint(var0_18)
	var1_18:Load(true, function()
		var1_18:SetParent(arg2_18)
		var1_18:SetLocalScale(Vector3(1, 1, 1))
		var1_18:SetAnchoredPosition(Vector2(0, 0))

		if arg3_18 then
			arg3_18(var1_18)
		end
	end)
end

function var0_0.clearUI(arg0_20)
	if arg0_20._spineChar then
		arg0_20._spineChar:Dispose()

		arg0_20._spineChar = nil
	end

	if arg0_20._npcSpines and #arg0_20._npcSpines > 0 then
		for iter0_20 = 1, #arg0_20._npcSpines do
			arg0_20._npcSpines[iter0_20]:Dispose()
		end

		arg0_20._npcSpines = {}
	end
end

function var0_0.InputDirect(arg0_21, arg1_21)
	if not arg0_21._inputFlag then
		return
	end

	arg0_21._direct = arg1_21

	local var0_21 = #arg0_21._passList + 1

	if var0_21 <= #arg0_21._inputList then
		local var1_21 = arg1_21 == arg0_21._inputList[var0_21] and var2_0 or var3_0

		table.insert(arg0_21._passList, var1_21)
	end

	arg0_21:updateDirect()
end

function var0_0.SetDirectData(arg0_22, arg1_22)
	arg0_22._inputList = arg1_22
	arg0_22._passList = {}

	for iter0_22 = 1, #arg0_22._directGrids do
		local var0_22 = arg0_22._directGrids[iter0_22]

		if iter0_22 <= #arg1_22 then
			findTF(var0_22, "ad").localEulerAngles = CutFruitGameConst.DIRECT_ROTATION[arg1_22[iter0_22]].rotation

			setActive(var0_22, true)
		else
			setActive(var0_22, false)
		end
	end

	if #arg1_22 > 0 then
		arg0_22._inputFlag = true

		setActive(arg0_22._directPanel, true)
	end

	arg0_22:updateDirect()
end

function var0_0.updateDirect(arg0_23)
	for iter0_23 = 1, #arg0_23._inputList do
		local var0_23 = arg0_23._directGrids[iter0_23]

		setActive(findTF(var0_23, "ad/" .. var1_0), false)
		setActive(findTF(var0_23, "ad/" .. var2_0), false)
		setActive(findTF(var0_23, "ad/" .. var3_0), false)

		if iter0_23 > #arg0_23._passList then
			setActive(findTF(var0_23, "ad/" .. var1_0), true)
		else
			setActive(findTF(var0_23, "ad/" .. arg0_23._passList[iter0_23]), true)
		end
	end

	for iter1_23 = 1, #arg0_23._passList do
		if arg0_23._passList[iter1_23] == 2 then
			if arg0_23._targetPosition < arg0_23._targetConfig then
				arg0_23._stepDirectTime = var5_0
			end

			arg0_23._inputFlag = false

			arg0_23:SetPanelAnimation("direct_faild")

			return
		end
	end

	if #arg0_23._passList == #arg0_23._inputList then
		arg0_23:CharMove()
		arg0_23:SetPanelAnimation("direct_success")

		arg0_23._passList = {}

		if arg0_23._targetPosition < arg0_23._targetConfig then
			arg0_23._inputFlag = false
			arg0_23._stepDirectTime = var5_0
		end
	end
end

function var0_0.SetPanelAnimation(arg0_24, arg1_24)
	arg0_24._directPanelAniamtor:Play(arg1_24)
end

function var0_0.getRandomDirect(arg0_25)
	local var0_25 = {}

	for iter0_25 = 1, var4_0 do
		table.insert(var0_25, arg0_25._directRandomList[math.random(1, #arg0_25._directRandomList)])
	end

	return var0_25
end

return var0_0
