local var0_0 = class("TouchCakeGamingUI")
local var1_0
local var2_0
local var3_0

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1._tf = arg1_1
	arg0_1._event = arg2_1
	var1_0 = TouchCakeGameVo
	var2_0 = TouchCakeGameEvent
	var3_0 = TouchCakeGameConst
	arg0_1._gameUI = findTF(arg0_1._tf, "ui/gamingUI")
	arg0_1.btnBack = findTF(arg0_1._gameUI, "back")
	arg0_1.btnPause = findTF(arg0_1._gameUI, "pause")
	arg0_1.gameTime = findTF(arg0_1._gameUI, "time")
	arg0_1.leftTf = findTF(arg0_1._gameUI, "left")
	arg0_1.rightTf = findTF(arg0_1._gameUI, "right")
	arg0_1.leftListener = GetComponent(arg0_1.leftTf, typeof(EventTriggerListener))
	arg0_1.rightListener = GetComponent(arg0_1.rightTf, typeof(EventTriggerListener))
	arg0_1.effectTf = findTF(arg0_1._gameUI, "effect")
	arg0_1.comboEffectData = var3_0.combo_effect

	arg0_1.leftListener:AddPointDownFunc(function()
		arg0_1._event:emit(var2_0.PRESS_DIRECT, -1)
	end)
	arg0_1.rightListener:AddPointDownFunc(function()
		arg0_1._event:emit(var2_0.PRESS_DIRECT, 1)
	end)
	onButton(arg0_1._event, arg0_1.btnBack, function()
		if not var1_0.startSettlement then
			arg0_1._event:emit(TouchCakeGameEvent.PAUSE_GAME, true)
			arg0_1._event:emit(TouchCakeGameEvent.OPEN_LEVEL_UI)
		end
	end, SFX_CONFIRM)
	onButton(arg0_1._event, arg0_1.btnPause, function()
		if not var1_0.startSettlement then
			arg0_1._event:emit(TouchCakeGameEvent.PAUSE_GAME, true)
			arg0_1._event:emit(TouchCakeGameEvent.OPEN_PAUSE_UI)
		end
	end, SFX_CONFIRM)

	arg0_1.scoreTf = findTF(arg0_1._gameUI, "score")
	arg0_1.comboTf = findTF(arg0_1._gameUI, "bgCombo/combo")
end

function var0_0.show(arg0_6, arg1_6)
	setActive(arg0_6._gameUI, arg1_6)
end

function var0_0.update(arg0_7)
	return
end

function var0_0.start(arg0_8)
	arg0_8.subGameStepTime = 0

	arg0_8:updateScore()
	arg0_8:updateCombo()
	arg0_8:show(true)
end

function var0_0.updateScore(arg0_9)
	setText(arg0_9.scoreTf, var1_0.scoreNum)
end

function var0_0.updateCombo(arg0_10)
	setText(arg0_10.comboTf, var1_0.comboNum)
	GetComponent(arg0_10.comboTf, typeof(Animator)):SetTrigger("combo")

	local var0_10

	for iter0_10 = #arg0_10.comboEffectData, 1, -1 do
		if var1_0.comboNum >= arg0_10.comboEffectData[iter0_10][1] then
			var0_10 = arg0_10.comboEffectData[iter0_10][2]

			break
		end
	end

	arg0_10:setChildVisible(arg0_10.effectTf, false)

	if var0_10 then
		setActive(findTF(arg0_10.effectTf, var0_10), true)
	end
end

function var0_0.setChildVisible(arg0_11, arg1_11, arg2_11)
	for iter0_11 = 1, arg1_11.childCount do
		local var0_11 = arg1_11:GetChild(iter0_11 - 1)

		setActive(var0_11, arg2_11)
	end
end

function var0_0.step(arg0_12, arg1_12)
	local var0_12 = math.ceil(var1_0.gameTime)

	var0_12 = var0_12 <= 0 and 0 or var0_12

	local var1_12 = math.floor(var0_12 / 60)
	local var2_12 = math.floor(var0_12 % 60)
	local var3_12 = var1_12 < 10 and "0" .. tostring(var1_12) or tostring(var1_12)
	local var4_12 = var2_12 < 10 and "0" .. tostring(var2_12) or tostring(var2_12)

	setText(arg0_12.gameTime, var3_12 .. " : " .. var4_12)

	if var0_12 <= 0 then
		arg0_12:show(false)
	elseif var1_0.startSettlement and isActive(arg0_12._gameUI) then
		arg0_12:show(false)
	end
end

function var0_0.dispose(arg0_13)
	ClearEventTrigger(arg0_13.leftListener)
	ClearEventTrigger(arg0_13.rightListener)
end

function var0_0.press(arg0_14, arg1_14, arg2_14)
	return
end

return var0_0
