local var0_0 = class("EatFoodLayer", import("..base.BaseUI"))
local var1_0 = {
	"ui-mini_throw",
	"ui-paishou_qing",
	"ui-paishou"
}
local var2_0 = {
	0,
	0,
	0
}
local var3_0 = 60
local var4_0 = "ui/eatfoodgameui_atlas"
local var5_0 = 67
local var6_0
local var7_0 = 4
local var8_0 = 3
local var9_0 = {
	0,
	630
}
local var10_0 = {
	150,
	120,
	100,
	120,
	100,
	80,
	150,
	100,
	90,
	150,
	80,
	150,
	80,
	100,
	70
}
local var11_0 = {
	8,
	10,
	15,
	9,
	12,
	18,
	11,
	13,
	15,
	15,
	8,
	17,
	15,
	10,
	18,
	10,
	18,
	20
}
local var12_0 = {
	{
		-50,
		50
	},
	{
		-80,
		80
	},
	{
		-50,
		90
	},
	{
		-50,
		50
	},
	{
		-50,
		50
	},
	{
		-50,
		100
	},
	{
		-50,
		80
	},
	{
		-50,
		80
	},
	{
		-50,
		70
	},
	{
		-50,
		80
	},
	{
		-50,
		80
	},
	{
		-50,
		80
	},
	{
		-50,
		50
	},
	{
		-50,
		70
	},
	{
		-50,
		90
	}
}
local var13_0 = 400
local var14_0 = 0
local var15_0 = "event touch"
local var16_0 = {
	35,
	100
}
local var17_0 = {
	300,
	10
}
local var18_0 = {
	"add_1",
	"add_2"
}
local var19_0 = {
	1000
}
local var20_0 = {
	-100
}
local var21_0 = {
	"sub_1"
}
local var22_0 = {
	{
		126,
		530,
		2
	},
	{
		-100,
		110,
		3
	},
	{
		530,
		1000,
		3
	}
}
local var23_0 = {
	300,
	10,
	-100
}
local var24_0 = {
	"add_1",
	"add_2",
	"sub_1"
}
local var25_0 = 0.8
local var26_0 = 0.05
local var27_0 = 1.4
local var28_0 = 100

local function var29_0(arg0_1, arg1_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2._tf = arg0_1
			arg0_2._event = arg1_1

			setActive(arg0_2._tf, false)

			arg0_2.sliderTouch = findTF(arg0_2._tf, "touch")

			setActive(arg0_2.sliderTouch, true)

			arg0_2.sliderRange = findTF(arg0_2._tf, "range")
			arg0_2.sliderRange.anchoredPosition = Vector2(0, var13_0)
		end,
		start = function(arg0_3)
			arg0_3.sliderIndex = 1
			arg0_3.nextSliderTime = var8_0
			arg0_3.sliderTouchPos = Vector2(var9_0[1], 0)

			arg0_3:setSliderBarVisible(false)
		end,
		step = function(arg0_4)
			if arg0_4.nextSliderTime then
				arg0_4.nextSliderTime = arg0_4.nextSliderTime - var6_0

				if arg0_4.nextSliderTime <= 0 then
					arg0_4:setSliderBarVisible(true)
					arg0_4:startSliderBar()

					arg0_4.nextSliderTime = arg0_4.nextSliderTime + var7_0
				end
			end

			if arg0_4.sliderBeginning then
				arg0_4.sliderTouchPos.y = arg0_4.sliderTouchPos.y + arg0_4.speed
				arg0_4.sliderTouch.anchoredPosition = arg0_4.sliderTouchPos

				if arg0_4.sliderTouchPos.y > var9_0[2] then
					arg0_4:touch(false)
				end
			end
		end,
		setSliderBarVisible = function(arg0_5, arg1_5)
			setActive(arg0_5._tf, arg1_5)
		end,
		startSliderBar = function(arg0_6)
			if arg0_6.sliderIndex > #var10_0 then
				arg0_6.sliderIndex = #var10_0
			end

			arg0_6.sliderWidth = var10_0[arg0_6.sliderIndex]
			arg0_6.speed = var11_0[arg0_6.sliderIndex]
			arg0_6.speed = var11_0[arg0_6.sliderIndex]
			arg0_6.sliderTouchPos.y = var9_0[1]
			arg0_6.sliderBeginning = true
			arg0_6.sliderRange.sizeDelta = Vector2(arg0_6.sliderRange.sizeDelta.x, arg0_6.sliderWidth)
			arg0_6.sliderRange.anchoredPosition = Vector2(0, var13_0 + math.random(var12_0[arg0_6.sliderIndex][1], var12_0[arg0_6.sliderIndex][2]))
		end,
		touch = function(arg0_7, arg1_7)
			if not arg0_7.sliderBeginning then
				return
			end

			arg0_7.sliderBeginning = false

			arg0_7:setSliderBarVisible(false)

			local var0_7 = false
			local var1_7 = 0
			local var2_7 = 1
			local var3_7 = 1
			local var4_7 = 1
			local var5_7 = arg0_7.sliderTouchPos.y

			if math.abs(arg0_7.sliderTouchPos.y - arg0_7.sliderRange.anchoredPosition.y) < arg0_7.sliderWidth / 2 then
				var1_7, var2_7 = var23_0[1], 1
				arg0_7.sliderIndex = arg0_7.sliderIndex + 1
				var0_7 = true
			else
				for iter0_7, iter1_7 in ipairs(var22_0) do
					if var5_7 >= iter1_7[1] and var5_7 <= iter1_7[2] then
						var4_7 = iter1_7[3]
					end
				end

				var1_7, var2_7 = var23_0[var4_7], var4_7
				arg0_7.nextSliderTime = arg0_7.nextSliderTime + var14_0
				var0_7 = false
			end

			pg.CriMgr.GetInstance():PlaySE_V3(var1_0[var4_7])
			arg0_7._event:emit(var15_0, {
				flag = var0_7,
				score = var1_7,
				hit_index = var2_7,
				hit_area = var4_7
			}, function()
				return
			end)
		end,
		getSubScore = function(arg0_9, arg1_9)
			local var0_9 = var20_0[1]
			local var1_9 = 1

			for iter0_9 = #var19_0, 1, -1 do
				if arg1_9 < var19_0[iter0_9] then
					var0_9 = var20_0[iter0_9]
					var1_9 = iter0_9

					return var0_9, var1_9
				end
			end

			return var0_9, var1_9
		end,
		getScore = function(arg0_10, arg1_10)
			local var0_10 = 0
			local var1_10 = #var16_0

			for iter0_10 = 1, #var16_0 do
				if arg1_10 < var16_0[iter0_10] then
					var0_10 = var17_0[iter0_10]
					var1_10 = iter0_10

					print("hit range" .. arg1_10)

					return var0_10, var1_10
				end
			end

			return var0_10, var1_10
		end,
		destroy = function(arg0_11)
			return
		end
	}

	var0_1:ctor()

	return var0_1
end

function var0_0.getUIName(arg0_12)
	return "EatFoodLayerUI"
end

function var0_0.didEnter(arg0_13)
	arg0_13:initEvent()
	arg0_13:initData()
	arg0_13:initUI()
	arg0_13:initGameUI()
	arg0_13:readyStart()
end

function var0_0.initEvent(arg0_14)
	arg0_14:bind(var15_0, function(arg0_15, arg1_15, arg2_15)
		if arg1_15.score and arg1_15.score ~= 0 then
			arg0_14:addScore(arg1_15.score, arg1_15.hit_index, arg1_15.hit_area)
		end
	end)
end

function var0_0.initData(arg0_16)
	local var0_16 = Application.targetFrameRate or 60

	if var0_16 > 60 then
		var0_16 = 60
	end

	arg0_16.stepCount = 1 / var0_16 * 0.9
	arg0_16.realTimeStartUp = Time.realtimeSinceStartup
	arg0_16.timer = Timer.New(function()
		if Time.realtimeSinceStartup - arg0_16.realTimeStartUp > arg0_16.stepCount then
			arg0_16:onTimer()

			arg0_16.realTimeStartUp = Time.realtimeSinceStartup
		end
	end, 1 / var0_16, -1)
end

function var0_0.initUI(arg0_18)
	arg0_18.backSceneTf = findTF(arg0_18._tf, "scene_container/scene_background")
	arg0_18.sceneTf = findTF(arg0_18._tf, "scene_container/scene")
	arg0_18.bgTf = findTF(arg0_18._tf, "bg")
	arg0_18.clickMask = findTF(arg0_18._tf, "clickMask")
	arg0_18.settlementUI = findTF(arg0_18._tf, "pop/SettleMentUI")

	onButton(arg0_18, findTF(arg0_18.settlementUI, "btnOver"), function()
		arg0_18:checkGameExit()
	end, SFX_CANCEL)
	SetActive(arg0_18.settlementUI, false)

	if not arg0_18.handle then
		arg0_18.handle = UpdateBeat:CreateListener(arg0_18.Update, arg0_18)
	end

	UpdateBeat:AddListener(arg0_18.handle)
end

function var0_0.initGameUI(arg0_20)
	arg0_20.gameUI = findTF(arg0_20._tf, "ui/gameUI")

	onButton(arg0_20, findTF(arg0_20.gameUI, "btnLeave"), function()
		arg0_20:checkGameExit()
	end)

	arg0_20.dragDelegate = GetOrAddComponent(arg0_20.sceneTf, "EventTriggerListener")
	arg0_20.dragDelegate.enabled = true

	arg0_20.dragDelegate:AddPointDownFunc(function(arg0_22, arg1_22)
		if arg0_20.sliderController then
			arg0_20.sliderController:touch(true)
		end
	end)

	arg0_20.gameTimeS = findTF(arg0_20.gameUI, "top/time/s")
	arg0_20.scoreTf = findTF(arg0_20.gameUI, "top/score")
	arg0_20.scoreTextTf = findTF(arg0_20.scoreTf, "text")
	arg0_20.sceneScoreTf = findTF(arg0_20.sceneTf, "score")

	setActive(arg0_20.sceneScoreTf, false)

	arg0_20.sliderController = var29_0(findTF(arg0_20.sceneTf, "collider"), arg0_20)
end

function var0_0.Update(arg0_23)
	arg0_23:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_24)
	if arg0_24.gameStop or arg0_24.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0_0.clearUI(arg0_25)
	setActive(arg0_25.sceneTf, false)
	setActive(arg0_25.settlementUI, false)
	setActive(arg0_25.gameUI, false)
end

function var0_0.readyStart(arg0_26)
	arg0_26:gameStart()
end

function var0_0.gameStart(arg0_27)
	setActive(findTF(arg0_27._tf, "scene_container"), true)
	setActive(findTF(arg0_27.bgTf, "on"), false)
	setActive(arg0_27.gameUI, true)

	arg0_27.gameStartFlag = true
	arg0_27.scoreNum = 0
	arg0_27.playerPosIndex = 2
	arg0_27.gameStepTime = 0
	arg0_27.gameTime = var3_0

	if arg0_27.sliderController then
		arg0_27.sliderController:start()
	end

	arg0_27:updateGameUI()
	arg0_27:timerStart()
end

function var0_0.transformColor(arg0_28, arg1_28)
	local var0_28 = tonumber(string.sub(arg1_28, 1, 2), 16)
	local var1_28 = tonumber(string.sub(arg1_28, 3, 4), 16)
	local var2_28 = tonumber(string.sub(arg1_28, 5, 6), 16)

	return Color.New(var0_28 / 255, var1_28 / 255, var2_28 / 255)
end

function var0_0.addScore(arg0_29, arg1_29, arg2_29, arg3_29)
	setActive(arg0_29.sceneScoreTf, false)

	if arg1_29 then
		arg0_29.scoreNum = arg0_29.scoreNum + arg1_29

		local var0_29 = 1

		setActive(findTF(arg0_29.sceneScoreTf, "anim/add_1"), false)
		setActive(findTF(arg0_29.sceneScoreTf, "anim/add_2"), false)
		setActive(findTF(arg0_29.sceneScoreTf, "anim/sub_1"), false)

		local var1_29

		if arg1_29 >= 0 then
			setActive(findTF(arg0_29.sceneScoreTf, "anim/" .. var24_0[arg3_29]), true)

			var1_29 = true
		else
			setActive(findTF(arg0_29.sceneScoreTf, "anim/" .. var24_0[arg3_29]), true)

			var1_29 = false
		end

		arg0_29:emit(EatFoodMediator.GAME_HIT_AREA, {
			success = var1_29,
			index = arg3_29
		})
		setActive(arg0_29.sceneScoreTf, true)
	end

	arg0_29:updateGameUI()
end

function var0_0.onTimer(arg0_30)
	arg0_30:gameStep()
end

function var0_0.gameStep(arg0_31)
	var6_0 = Time.realtimeSinceStartup - arg0_31.realTimeStartUp
	arg0_31.gameTime = arg0_31.gameTime - var6_0
	arg0_31.gameStepTime = arg0_31.gameStepTime + var6_0

	if arg0_31.gameTime < 0 then
		arg0_31.gameTime = 0
	end

	arg0_31:updateGameUI()

	if arg0_31.sliderController then
		arg0_31.sliderController:step()
	end

	if arg0_31.gameTime <= 0 then
		arg0_31:onGameOver(0)

		return
	end
end

function var0_0.timerStart(arg0_32)
	if not arg0_32.timer.running then
		arg0_32.realTimeStartUp = Time.realtimeSinceStartup

		arg0_32.timer:Start()
	end
end

function var0_0.timerStop(arg0_33)
	if arg0_33.timer.running then
		arg0_33.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_34)
	setText(arg0_34.scoreTextTf, arg0_34.scoreNum)
	setText(arg0_34.gameTimeS, math.ceil(arg0_34.gameTime))
end

function var0_0.onGameOver(arg0_35, arg1_35)
	if arg0_35.settlementFlag then
		return
	end

	arg0_35:timerStop()

	arg0_35.settlementFlag = true

	setActive(arg0_35.clickMask, true)
	setActive(findTF(arg0_35._tf, "scene_container"), false)
	setActive(arg0_35.gameUI, false)
	LeanTween.delayedCall(go(arg0_35._tf), arg1_35, System.Action(function()
		arg0_35.settlementFlag = false
		arg0_35.gameStartFlag = false

		setActive(arg0_35.clickMask, false)
		arg0_35:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_37)
	arg0_37:emit(EatFoodMediator.GAME_RESULT, {
		win = arg0_37.scoreNum >= var28_0,
		score = arg0_37.scoreNum
	})
	setActive(arg0_37.settlementUI, true)

	local var0_37 = arg0_37.scoreNum
	local var1_37 = getProxy(PlayerProxy):getPlayerId()
	local var2_37 = PlayerPrefs.GetInt("mg_score_" .. tostring(var1_37) .. "_" .. var5_0) or 0

	setActive(findTF(arg0_37.settlementUI, "ad/new"), var2_37 < var0_37)

	if var2_37 <= var0_37 then
		var2_37 = var0_37

		PlayerPrefs.SetInt("mg_score_" .. tostring(var1_37) .. "_" .. var5_0, var2_37)
	end

	local var3_37 = findTF(arg0_37.settlementUI, "ad/highText")
	local var4_37 = findTF(arg0_37.settlementUI, "ad/currentText")

	setText(var3_37, var2_37)
	setText(var4_37, var0_37)
end

function var0_0.resumeGame(arg0_38)
	arg0_38.gameStop = false

	arg0_38:timerStart()
end

function var0_0.stopGame(arg0_39)
	arg0_39.gameStop = true

	arg0_39:timerStop()
end

function var0_0.getMiniGameData(arg0_40)
	if not arg0_40._mgData then
		arg0_40._mgData = getProxy(MiniGameProxy):GetMiniGameData(var5_0)
	end

	return arg0_40._mgData
end

function var0_0.onBackPressed(arg0_41)
	arg0_41:checkGameExit()
end

function var0_0.checkGameExit(arg0_42)
	if not arg0_42.gameStartFlag then
		arg0_42:emit(EatFoodMediator.GAME_CLOSE, true)
		arg0_42:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_42.gameStop then
			return
		end

		arg0_42:stopGame()

		if arg0_42.contextData.isDorm3d then
			pg.NewStyleMsgboxMgr.GetInstance():Show(pg.NewStyleMsgboxMgr.TYPE_MSGBOX, {
				contentText = i18n("mini_game_leave"),
				onConfirm = function()
					arg0_42:emit(EatFoodMediator.GAME_CLOSE, false)
					arg0_42:emit(var0_0.ON_BACK_PRESSED)
				end,
				onClose = function()
					arg0_42:resumeGame()
				end
			})
		else
			pg.MsgboxMgr.GetInstance():ShowMsgBox({
				content = i18n("mini_game_leave"),
				onYes = function()
					arg0_42:emit(EatFoodMediator.GAME_CLOSE, false)
					arg0_42:emit(var0_0.ON_BACK_PRESSED)
				end,
				onNo = function()
					arg0_42:resumeGame()
				end
			})
		end
	end
end

function var0_0.willExit(arg0_47)
	if arg0_47.handle then
		UpdateBeat:RemoveListener(arg0_47.handle)
	end

	if arg0_47._tf and LeanTween.isTweening(go(arg0_47._tf)) then
		LeanTween.cancel(go(arg0_47._tf))
	end

	if arg0_47.timer and arg0_47.timer.running then
		arg0_47.timer:Stop()
	end

	Time.timeScale = 1
	arg0_47.timer = nil
end

return var0_0
