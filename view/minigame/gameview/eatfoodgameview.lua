local var0_0 = class("EatFoodGameView", import("..BaseMiniGameView"))
local var1_0 = "xinnong-1"
local var2_0 = "event:/ui/ddldaoshu2"
local var3_0 = "event:/ui/zhengque"
local var4_0 = "event:/ui/shibai2"
local var5_0 = "event:/ui/deshou"
local var6_0 = "event:/ui/shibai"
local var7_0 = 60
local var8_0 = "ui/eatfoodgameui_atlas"
local var9_0 = "salvage_tips"
local var10_0 = 2.5
local var11_0 = 3.75
local var12_0 = {
	0,
	600
}
local var13_0 = {
	150,
	150,
	150,
	140,
	140,
	140,
	130,
	130,
	130,
	120,
	120,
	120,
	110,
	110,
	100
}
local var14_0 = {
	8,
	8,
	9,
	9,
	10,
	10,
	11,
	11,
	12,
	12,
	13,
	13,
	14,
	15,
	16,
	17,
	18,
	20
}
local var15_0 = 400
local var16_0 = 1
local var17_0 = "event touch"
local var18_0 = {
	15,
	25,
	40,
	75
}
local var19_0 = {
	500,
	300,
	150,
	50
}
local var20_0 = {
	-400,
	-300,
	-200,
	-100
}
local var21_0 = {
	20,
	40,
	60,
	100
}
local var22_0 = 0.8
local var23_0 = 0.05
local var24_0 = 1.4
local var25_0 = {
	{
		id = 1,
		next_time = {
			3.5,
			4
		}
	},
	{
		id = 2,
		next_time = {
			3.5,
			4
		}
	},
	{
		id = 4,
		next_time = {
			3.5,
			4
		}
	}
}
local var26_0 = 2
local var27_0 = {
	1,
	3
}
local var28_0 = 15
local var29_0 = {
	3,
	6,
	9,
	11,
	13,
	15
}
local var30_0 = 10
local var31_0 = {
	{
		id = 3
	}
}
local var32_0 = "event game over"

local function var33_0(arg0_1, arg1_1)
	local var0_1 = {
		ctor = function(arg0_2)
			arg0_2._tf = arg0_1
			arg0_2._event = arg1_1

			setActive(arg0_2._tf, false)

			arg0_2.sliderTouch = findTF(arg0_2._tf, "touch")

			setActive(arg0_2.sliderTouch, true)

			arg0_2.sliderRange = findTF(arg0_2._tf, "range")
			arg0_2.sliderRange.anchoredPosition = Vector2(var15_0, 0)
		end,
		start = function(arg0_3)
			arg0_3.sliderIndex = 1
			arg0_3.nextSliderTime = var11_0
			arg0_3.sliderTouchPos = Vector2(var12_0[1], 0)

			arg0_3:setSliderBarVisible(false)
		end,
		step = function(arg0_4)
			if arg0_4.nextSliderTime then
				arg0_4.nextSliderTime = arg0_4.nextSliderTime - Time.deltaTime

				if arg0_4.nextSliderTime <= 0 then
					arg0_4:setSliderBarVisible(true)
					arg0_4:startSliderBar()

					arg0_4.nextSliderTime = arg0_4.nextSliderTime + var10_0
				end
			end

			if arg0_4.sliderBeginning then
				arg0_4.sliderTouchPos.x = arg0_4.sliderTouchPos.x + arg0_4.speed
				arg0_4.sliderTouch.anchoredPosition = arg0_4.sliderTouchPos

				if arg0_4.sliderTouchPos.x > var12_0[2] then
					arg0_4:touch(false)
				end
			end
		end,
		setSliderBarVisible = function(arg0_5, arg1_5)
			setActive(arg0_5._tf, arg1_5)
		end,
		startSliderBar = function(arg0_6)
			if arg0_6.sliderIndex > #var13_0 then
				arg0_6.sliderIndex = 1
			end

			arg0_6.sliderWidth = var13_0[arg0_6.sliderIndex]
			arg0_6.speed = var14_0[arg0_6.sliderIndex]
			arg0_6.sliderTouchPos.x = var12_0[1]
			arg0_6.sliderBeginning = true
			arg0_6.sliderRange.sizeDelta = Vector2(arg0_6.sliderWidth, arg0_6.sliderRange.sizeDelta.y)
		end,
		touch = function(arg0_7, arg1_7)
			if not arg0_7.sliderBeginning then
				return
			end

			arg0_7.sliderBeginning = false

			arg0_7:setSliderBarVisible(false)

			local var0_7 = false
			local var1_7 = 0
			local var2_7 = math.abs(arg0_7.sliderTouchPos.x - var15_0)
			local var3_7

			if var2_7 < arg0_7.sliderWidth / 2 then
				var1_7 = arg0_7:getScore(var2_7)
				arg0_7.sliderIndex = arg0_7.sliderIndex + 1
				var3_7 = true
			else
				if arg0_7.sliderTouchPos.x < 100 or arg0_7.sliderTouchPos.x > var12_0[2] - 100 then
					var1_7 = arg0_7:getSubScore(arg0_7.sliderTouchPos.x)
				end

				arg0_7.nextSliderTime = arg0_7.nextSliderTime + var16_0
				var3_7 = false
			end

			if var3_7 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5_0)
			else
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var6_0)
			end

			if arg1_7 then
				arg0_7._event:emit(var17_0, {
					flag = var3_7,
					score = var1_7
				}, function()
					return
				end)
			end
		end,
		getSubScore = function(arg0_9, arg1_9)
			local var0_9

			if arg1_9 <= 100 then
				var0_9 = arg1_9
			else
				var0_9 = var12_0[2] - arg1_9
			end

			for iter0_9 = 1, #var21_0 do
				if var0_9 < var21_0[iter0_9] then
					return var20_0[iter0_9]
				end
			end

			return 0
		end,
		getScore = function(arg0_10, arg1_10)
			for iter0_10 = 1, #var18_0 do
				if arg1_10 < var18_0[iter0_10] then
					return var19_0[iter0_10]
				end
			end

			return 0
		end,
		destroy = function(arg0_11)
			return
		end
	}

	var0_1:ctor()

	return var0_1
end

local function var34_0(arg0_12, arg1_12, arg2_12, arg3_12)
	local var0_12 = {
		ctor = function(arg0_13)
			arg0_13._charTpls = arg0_12
			arg0_13._foodTpl = arg1_12
			arg0_13._container = arg2_12
			arg0_13._event = arg3_12
		end,
		start = function(arg0_14)
			arg0_14:clear()

			arg0_14.player = nil
			arg0_14.chars = {}
			arg0_14.animateSpeed = var22_0
			arg0_14.playerNextStepTimes = {}

			arg0_14:create()
		end,
		step = function(arg0_15)
			for iter0_15 = 1, #arg0_15.chars do
				local var0_15 = arg0_15.chars[iter0_15]

				if not var0_15.nextTime then
					var0_15.nextTime = math.random(var0_15.next_time[1], var0_15.next_time[2])
				else
					var0_15.nextTime = var0_15.nextTime - Time.deltaTime

					if var0_15.nextTime <= 0 then
						var0_15.nextTime = nil
						var0_15.stepIndex = var0_15.stepIndex + 1

						if table.contains(var29_0, var0_15.stepIndex) then
							var0_15.tfAnimator:SetTrigger("next")
						end

						if var0_15.stepIndex == var30_0 then
							var0_15.tfAnimator:SetBool("eat", false)
							var0_15.tfAnimator:SetBool("bite", true)
						end

						if var0_15.stepIndex >= var28_0 then
							arg0_15:setWinChar(var0_15)
						end
					end
				end
			end
		end,
		setWinChar = function(arg0_16, arg1_16)
			local var0_16 = false

			if arg1_16 then
				var0_16 = arg1_16.isPlayer
				arg1_16.foodState = 6

				arg1_16.foodTfAnimator:SetInteger("state", arg1_16.foodState)
			end

			if arg0_16.player == arg1_16 then
				arg0_16.player.tfAnimator:SetTrigger("victory")
			else
				arg0_16.player.tfAnimator:SetTrigger("defeat")
			end

			for iter0_16 = 1, #arg0_16.chars do
				local var1_16 = arg0_16.chars[iter0_16]

				if var1_16 == arg1_16 then
					var1_16.tfAnimator:SetTrigger("victory")
				else
					var1_16.tfAnimator:SetTrigger("defeat")
				end
			end

			arg0_16._event:emit(var32_0, var0_16, function()
				return
			end)
		end,
		onPlayerTouch = function(arg0_18, arg1_18)
			if arg0_18.player then
				if arg1_18.flag then
					arg0_18.player.stepIndex = arg0_18.player.stepIndex + 1

					if table.contains(var29_0, arg0_18.player.stepIndex) and not table.contains(arg0_18.playerNextStepTimes, arg0_18.player.stepIndex) then
						table.insert(arg0_18.playerNextStepTimes, arg0_18.player.stepIndex)
						arg0_18.player.tfAnimator:SetTrigger("next")
					end

					if arg0_18.player.stepIndex == var30_0 then
						arg0_18.player.tfAnimator:SetBool("eat", false)
						arg0_18.player.tfAnimator:SetBool("bite", true)
					end

					if arg0_18.player.stepIndex >= var28_0 then
						arg0_18:setWinChar(arg0_18.player)
					end

					arg0_18.animateSpeed = arg0_18.animateSpeed + var23_0

					if arg0_18.animateSpeed > var24_0 then
						arg0_18.animateSpeed = var24_0
					end

					arg0_18.player.tfAnimator.speed = arg0_18.animateSpeed
				else
					arg0_18.animateSpeed = arg0_18.animateSpeed - var23_0

					if arg0_18.animateSpeed < var22_0 then
						arg0_18.animateSpeed = var22_0
					end

					arg0_18.player.tfAnimator.speed = arg0_18.animateSpeed

					arg0_18.player.tfAnimator:SetTrigger("miss")
				end
			end
		end,
		create = function(arg0_19)
			local var0_19 = Clone(var31_0)
			local var1_19 = table.remove(var0_19, math.random(1, #var0_19))

			arg0_19.player = arg0_19:getCharById(var1_19, var26_0)

			local var2_19 = Clone(var25_0)

			for iter0_19 = 1, #var27_0 do
				local var3_19 = table.remove(var2_19, math.random(1, #var2_19))
				local var4_19 = arg0_19:getCharById(var3_19, var27_0[iter0_19])

				table.insert(arg0_19.chars, var4_19)
			end
		end,
		getCharById = function(arg0_20, arg1_20, arg2_20)
			local var0_20 = {}
			local var1_20 = tf(instantiate(findTF(arg0_20._charTpls, "char" .. arg1_20.id)))
			local var2_20 = tf(instantiate(arg0_20._foodTpl))

			setParent(var1_20, findTF(arg0_20._container, tostring(arg2_20)))
			setActive(var1_20, true)
			setParent(var2_20, findTF(arg0_20._container, tostring(arg2_20)))
			setActive(var2_20, true)

			var2_20.anchoredPosition = Vector2(0, -300)
			var1_20.anchoredPosition = Vector2(0, 0)
			var0_20.tf = var1_20
			var0_20.tfAnimator = GetComponent(findTF(var1_20, "anim"), typeof(Animator))
			var0_20.tfAnimator.speed = arg0_20.animateSpeed
			var0_20.foodTf = var2_20
			var0_20.foodTfAnimator = GetComponent(findTF(var2_20, "anim"), typeof(Animator))
			var0_20.foodTfAnimator.speed = var22_0
			var0_20.next_time = arg1_20.next_time

			if not var0_20.next_time then
				var0_20.isPlayer = true
			else
				var0_20.nextTime = math.random(0, arg1_20.next_time[2] - arg1_20.next_time[1]) + arg1_20.next_time[1] + var11_0
			end

			var0_20.foodState = 0
			var0_20.stepIndex = 0

			local var3_20 = GetComponent(findTF(var1_20, "anim"), typeof(DftAniEvent))

			var3_20:SetStartEvent(function()
				var0_20.foodState = var0_20.foodState + 1

				var0_20.foodTfAnimator:SetInteger("state", var0_20.foodState)
			end)
			var3_20:SetTriggerEvent(function()
				return
			end)
			var3_20:SetEndEvent(function()
				return
			end)

			return var0_20
		end,
		stop = function(arg0_24)
			if arg0_24.player then
				arg0_24.player.tfAnimator.speed = 0
			end

			if arg0_24.chars and #arg0_24.chars > 0 then
				for iter0_24 = 1, #arg0_24.chars do
					arg0_24.chars[iter0_24].tfAnimator.speed = 0
				end
			end
		end,
		resume = function(arg0_25)
			if arg0_25.player then
				arg0_25.player.tfAnimator.speed = arg0_25.animateSpeed
			end

			if arg0_25.chars and #arg0_25.chars > 0 then
				for iter0_25 = 1, #arg0_25.chars do
					arg0_25.chars[iter0_25].tfAnimator.speed = var22_0
				end
			end
		end,
		onTimeOut = function(arg0_26)
			local var0_26 = arg0_26.player
			local var1_26 = arg0_26.player.stepIndex or 0

			for iter0_26 = 1, #arg0_26.chars do
				if var1_26 < arg0_26.chars[iter0_26].stepIndex then
					var0_26 = arg0_26.chars[iter0_26]
					var1_26 = arg0_26.chars[iter0_26].stepIndex
				end
			end

			arg0_26:setWinChar(var0_26)
		end,
		clear = function(arg0_27)
			if arg0_27.player then
				destroy(arg0_27.player.tf)
				destroy(arg0_27.player.foodTf)
			end

			if arg0_27.chars then
				for iter0_27 = 1, #arg0_27.chars do
					destroy(arg0_27.chars[iter0_27].tf)
					destroy(arg0_27.chars[iter0_27].foodTf)
				end
			end
		end
	}

	var0_12:ctor()

	return var0_12
end

function var0_0.getUIName(arg0_28)
	return "EatFoodGameUI"
end

function var0_0.getBGM(arg0_29)
	return var1_0
end

function var0_0.didEnter(arg0_30)
	arg0_30:initEvent()
	arg0_30:initData()
	arg0_30:initUI()
	arg0_30:initGameUI()
	arg0_30:readyStart()
end

function var0_0.OnGetAwardDone(arg0_31)
	arg0_31:CheckGet()
end

function var0_0.OnSendMiniGameOPDone(arg0_32, arg1_32)
	return
end

function var0_0.initEvent(arg0_33)
	arg0_33:bind(var32_0, function(arg0_34, arg1_34, arg2_34)
		arg0_33:setGameOver(arg1_34)
	end)
	arg0_33:bind(var17_0, function(arg0_35, arg1_35, arg2_35)
		if arg1_35.score and arg1_35.score ~= 0 then
			arg0_33:addScore(arg1_35.score)
		end

		if arg0_33.charController then
			arg0_33.charController:onPlayerTouch(arg1_35)
		end
	end)
end

function var0_0.initData(arg0_36)
	arg0_36.dropData = pg.mini_game[arg0_36:GetMGData().id].simple_config_data.drop

	local var0_36 = Application.targetFrameRate or 60

	if var0_36 > 60 then
		var0_36 = 60
	end

	arg0_36.timer = Timer.New(function()
		arg0_36:onTimer()
	end, 1 / var0_36, -1)
end

function var0_0.initUI(arg0_38)
	arg0_38.backSceneTf = findTF(arg0_38._tf, "scene_container/scene_background")
	arg0_38.sceneTf = findTF(arg0_38._tf, "scene_container/scene")
	arg0_38.bgTf = findTF(arg0_38._tf, "bg")
	arg0_38.clickMask = findTF(arg0_38._tf, "clickMask")
	arg0_38.countUI = findTF(arg0_38._tf, "pop/CountUI")
	arg0_38.countAnimator = GetComponent(findTF(arg0_38.countUI, "count"), typeof(Animator))
	arg0_38.countDft = GetOrAddComponent(findTF(arg0_38.countUI, "count"), typeof(DftAniEvent))

	arg0_38.countDft:SetTriggerEvent(function()
		return
	end)
	arg0_38.countDft:SetEndEvent(function()
		setActive(arg0_38.countUI, false)

		arg0_38.readyStart = false
	end)
	SetActive(arg0_38.countUI, false)

	arg0_38.leaveUI = findTF(arg0_38._tf, "pop/LeaveUI")

	onButton(arg0_38, findTF(arg0_38.leaveUI, "ad/btnOk"), function()
		arg0_38:resumeGame()

		if arg0_38.charController then
			arg0_38.charController:stop()
		end

		arg0_38:onGameOver(0)
	end, SFX_CANCEL)
	onButton(arg0_38, findTF(arg0_38.leaveUI, "ad/btnCancel"), function()
		arg0_38:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0_38.leaveUI, false)

	arg0_38.pauseUI = findTF(arg0_38._tf, "pop/pauseUI")

	onButton(arg0_38, findTF(arg0_38.pauseUI, "ad/btnOk"), function()
		setActive(arg0_38.pauseUI, false)
		arg0_38:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0_38.pauseUI, false)

	arg0_38.resultUI = findTF(arg0_38._tf, "pop/resultUI")

	SetActive(arg0_38.resultUI, false)

	arg0_38.settlementUI = findTF(arg0_38._tf, "pop/SettleMentUI")

	onButton(arg0_38, findTF(arg0_38.settlementUI, "ad/btnOver"), function()
		setActive(arg0_38.settlementUI, false)
		arg0_38:closeView()
	end, SFX_CANCEL)
	SetActive(arg0_38.settlementUI, false)

	if not arg0_38.handle then
		arg0_38.handle = UpdateBeat:CreateListener(arg0_38.Update, arg0_38)
	end

	UpdateBeat:AddListener(arg0_38.handle)
end

function var0_0.initGameUI(arg0_45)
	arg0_45.gameUI = findTF(arg0_45._tf, "ui/gameUI")

	onButton(arg0_45, findTF(arg0_45.gameUI, "topRight/btnStop"), function()
		arg0_45:stopGame()
		setActive(arg0_45.pauseUI, true)
	end)
	onButton(arg0_45, findTF(arg0_45.gameUI, "btnLeave"), function()
		arg0_45:stopGame()
		setActive(arg0_45.leaveUI, true)
	end)

	arg0_45.dragDelegate = GetOrAddComponent(arg0_45.sceneTf, "EventTriggerListener")
	arg0_45.dragDelegate.enabled = true

	arg0_45.dragDelegate:AddPointDownFunc(function(arg0_48, arg1_48)
		if arg0_45.sliderController then
			arg0_45.sliderController:touch(true)
		end
	end)

	arg0_45.gameTimeS = findTF(arg0_45.gameUI, "top/time/s")
	arg0_45.scoreTf = findTF(arg0_45.gameUI, "top/score")
	arg0_45.sceneScoreTf = findTF(arg0_45.sceneTf, "score")
	arg0_45.sliderController = var33_0(findTF(arg0_45.sceneTf, "collider"), arg0_45)
	arg0_45.charController = var34_0(findTF(arg0_45.sceneTf, "tpls"), findTF(arg0_45.sceneTf, "food"), findTF(arg0_45.sceneTf, "container"), arg0_45)
end

function var0_0.Update(arg0_49)
	arg0_49:AddDebugInput()
end

function var0_0.AddDebugInput(arg0_50)
	if arg0_50.gameStop or arg0_50.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0_0.updateMenuUI(arg0_51)
	return
end

function var0_0.CheckGet(arg0_52)
	if arg0_52:getUltimate() == 0 then
		if arg0_52:getGameTotalTime() > arg0_52:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0_52:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0_0.openMenuUI(arg0_53)
	setActive(findTF(arg0_53._tf, "scene_container"), false)
	setActive(findTF(arg0_53.bgTf, "on"), true)
	setActive(arg0_53.gameUI, false)
	setActive(arg0_53.menuUI, true)
end

function var0_0.clearUI(arg0_54)
	setActive(arg0_54.sceneTf, false)
	setActive(arg0_54.settlementUI, false)
	setActive(arg0_54.countUI, false)
	setActive(arg0_54.menuUI, false)
	setActive(arg0_54.gameUI, false)
end

function var0_0.readyStart(arg0_55)
	setActive(arg0_55.countUI, true)
	arg0_55.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2_0)

	arg0_55.readyStart = true

	arg0_55:gameStart()
end

function var0_0.getGameTimes(arg0_56)
	return arg0_56:GetMGHubData().count
end

function var0_0.getGameUsedTimes(arg0_57)
	return arg0_57:GetMGHubData().usedtime
end

function var0_0.getUltimate(arg0_58)
	return arg0_58:GetMGHubData().ultimate
end

function var0_0.getGameTotalTime(arg0_59)
	return (arg0_59:GetMGHubData():getConfig("reward_need"))
end

function var0_0.gameStart(arg0_60)
	setActive(findTF(arg0_60._tf, "scene_container"), true)
	setActive(findTF(arg0_60.bgTf, "on"), false)
	setActive(arg0_60.gameUI, true)

	arg0_60.gameStartFlag = true
	arg0_60.scoreNum = 0
	arg0_60.playerPosIndex = 2
	arg0_60.gameStepTime = 0
	arg0_60.gameTime = var7_0

	if arg0_60.sliderController then
		arg0_60.sliderController:start()
	end

	if arg0_60.charController then
		arg0_60.charController:start()
	end

	arg0_60:updateGameUI()
	arg0_60:timerStart()
end

function var0_0.transformColor(arg0_61, arg1_61)
	local var0_61 = tonumber(string.sub(arg1_61, 1, 2), 16)
	local var1_61 = tonumber(string.sub(arg1_61, 3, 4), 16)
	local var2_61 = tonumber(string.sub(arg1_61, 5, 6), 16)

	return Color.New(var0_61 / 255, var1_61 / 255, var2_61 / 255)
end

function var0_0.addScore(arg0_62, arg1_62, arg2_62)
	setActive(arg0_62.sceneScoreTf, false)

	if arg1_62 then
		arg0_62.scoreNum = arg0_62.scoreNum + arg1_62

		local var0_62 = arg1_62 >= 0 and "+" .. arg1_62 or tostring(arg1_62)

		setText(findTF(arg0_62.sceneScoreTf, "img"), var0_62)
		setActive(arg0_62.sceneScoreTf, true)
	end

	arg0_62:updateGameUI()
end

function var0_0.onTimer(arg0_63)
	arg0_63:gameStep()
end

function var0_0.gameStep(arg0_64)
	if not arg0_64.readyStart then
		arg0_64.gameTime = arg0_64.gameTime - Time.deltaTime
		arg0_64.gameStepTime = arg0_64.gameStepTime + Time.deltaTime
	end

	if arg0_64.gameTime < 0 then
		arg0_64.gameTime = 0
	end

	arg0_64:updateGameUI()

	if arg0_64.sliderController then
		arg0_64.sliderController:step()
	end

	if arg0_64.charController then
		arg0_64.charController:step()
	end

	if arg0_64.gameTime <= 0 then
		if arg0_64.charController then
			arg0_64.charController:onTimeOut()
		end

		return
	end
end

function var0_0.timerStart(arg0_65)
	if not arg0_65.timer.running then
		arg0_65.timer:Start()
	end
end

function var0_0.timerStop(arg0_66)
	if arg0_66.timer.running then
		arg0_66.timer:Stop()
	end
end

function var0_0.updateGameUI(arg0_67)
	setText(arg0_67.scoreTf, arg0_67.scoreNum)
	setText(arg0_67.gameTimeS, math.ceil(arg0_67.gameTime))
end

function var0_0.setGameOver(arg0_68, arg1_68)
	arg0_68:onGameOver(3.5)

	local var0_68
	local var1_68 = Application.targetFrameRate or 60

	seriesAsync({
		function(arg0_69)
			local var0_69 = 0

			var0_68 = Timer.New(function()
				var0_69 = var0_69 + 15

				if var0_69 > 1400 then
					arg0_69()
				end
			end, 1 / var1_68, -1)

			var0_68:Start()
		end,
		function(arg0_71)
			if var0_68 then
				var0_68:Stop()

				var0_68 = nil
			end

			if arg1_68 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3_0)
			else
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4_0)
			end

			setActive(findTF(arg0_68.resultUI, "ad/victory"), arg1_68)
			setActive(findTF(arg0_68.resultUI, "ad/defeat"), not arg1_68)
			setActive(arg0_68.resultUI, true)
			GetComponent(findTF(arg0_68.resultUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

			local var0_71 = 0

			var0_68 = Timer.New(function()
				var0_71 = var0_71 + 15

				if var0_71 > 1400 then
					setActive(arg0_68.resultUI, false)
					arg0_71()
				end
			end, 1 / var1_68, -1)

			var0_68:Start()
		end
	}, function()
		if var0_68 then
			var0_68:Stop()

			var0_68 = nil
		end
	end)
end

function var0_0.onGameOver(arg0_74, arg1_74)
	if arg0_74.settlementFlag then
		return
	end

	arg0_74:timerStop()

	arg0_74.settlementFlag = true

	setActive(arg0_74.clickMask, true)
	LeanTween.delayedCall(go(arg0_74._tf), arg1_74, System.Action(function()
		arg0_74.settlementFlag = false
		arg0_74.gameStartFlag = false

		setActive(arg0_74.clickMask, false)
		arg0_74:showSettlement()
	end))
end

function var0_0.showSettlement(arg0_76)
	setActive(arg0_76.settlementUI, true)
	GetComponent(findTF(arg0_76.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0_76 = arg0_76:GetMGData():GetRuntimeData("elements")
	local var1_76 = arg0_76.scoreNum
	local var2_76 = var0_76 and #var0_76 > 0 and var0_76[1] or 0

	setActive(findTF(arg0_76.settlementUI, "ad/new"), var2_76 < var1_76)

	if var2_76 <= var1_76 then
		var2_76 = var1_76

		arg0_76:StoreDataToServer({
			var2_76
		})
	end

	local var3_76 = findTF(arg0_76.settlementUI, "ad/highText")
	local var4_76 = findTF(arg0_76.settlementUI, "ad/currentText")

	setText(var3_76, var2_76)
	setText(var4_76, var1_76)

	if arg0_76:getGameTimes() and arg0_76:getGameTimes() > 0 then
		arg0_76.sendSuccessFlag = true

		arg0_76:SendSuccess(0)

		local var5_76 = arg0_76:getGameTotalTime()
		local var6_76 = arg0_76:getGameUsedTimes()
	end
end

function var0_0.resumeGame(arg0_77)
	arg0_77.gameStop = false

	setActive(arg0_77.leaveUI, false)

	if arg0_77.charController then
		arg0_77.charController:resume()
	end

	arg0_77:timerStart()
end

function var0_0.stopGame(arg0_78)
	arg0_78.gameStop = true

	if arg0_78.charController then
		arg0_78.charController:stop()
	end

	arg0_78:timerStop()
end

function var0_0.onBackPressed(arg0_79)
	if not arg0_79.gameStartFlag then
		arg0_79:emit(var0_0.ON_BACK_PRESSED)
	else
		if arg0_79.settlementFlag then
			return
		end

		if isActive(arg0_79.pauseUI) then
			setActive(arg0_79.pauseUI, false)
		end

		arg0_79:stopGame()
		setActive(arg0_79.leaveUI, true)
	end
end

function var0_0.willExit(arg0_80)
	if arg0_80.handle then
		UpdateBeat:RemoveListener(arg0_80.handle)
	end

	if arg0_80._tf and LeanTween.isTweening(go(arg0_80._tf)) then
		LeanTween.cancel(go(arg0_80._tf))
	end

	if arg0_80.timer and arg0_80.timer.running then
		arg0_80.timer:Stop()
	end

	Time.timeScale = 1
	arg0_80.timer = nil
end

return var0_0
