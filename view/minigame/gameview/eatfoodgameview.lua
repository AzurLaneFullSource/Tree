local var0 = class("EatFoodGameView", import("..BaseMiniGameView"))
local var1 = "xinnong-1"
local var2 = "event:/ui/ddldaoshu2"
local var3 = "event:/ui/zhengque"
local var4 = "event:/ui/shibai2"
local var5 = "event:/ui/deshou"
local var6 = "event:/ui/shibai"
local var7 = 60
local var8 = "ui/eatfoodgameui_atlas"
local var9 = "salvage_tips"
local var10 = 2.5
local var11 = 3.75
local var12 = {
	0,
	600
}
local var13 = {
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
local var14 = {
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
local var15 = 400
local var16 = 1
local var17 = "event touch"
local var18 = {
	15,
	25,
	40,
	75
}
local var19 = {
	500,
	300,
	150,
	50
}
local var20 = {
	-400,
	-300,
	-200,
	-100
}
local var21 = {
	20,
	40,
	60,
	100
}
local var22 = 0.8
local var23 = 0.05
local var24 = 1.4
local var25 = {
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
local var26 = 2
local var27 = {
	1,
	3
}
local var28 = 15
local var29 = {
	3,
	6,
	9,
	11,
	13,
	15
}
local var30 = 10
local var31 = {
	{
		id = 3
	}
}
local var32 = "event game over"

local function var33(arg0, arg1)
	local var0 = {
		ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1

			setActive(arg0._tf, false)

			arg0.sliderTouch = findTF(arg0._tf, "touch")

			setActive(arg0.sliderTouch, true)

			arg0.sliderRange = findTF(arg0._tf, "range")
			arg0.sliderRange.anchoredPosition = Vector2(var15, 0)
		end,
		start = function(arg0)
			arg0.sliderIndex = 1
			arg0.nextSliderTime = var11
			arg0.sliderTouchPos = Vector2(var12[1], 0)

			arg0:setSliderBarVisible(false)
		end,
		step = function(arg0)
			if arg0.nextSliderTime then
				arg0.nextSliderTime = arg0.nextSliderTime - Time.deltaTime

				if arg0.nextSliderTime <= 0 then
					arg0:setSliderBarVisible(true)
					arg0:startSliderBar()

					arg0.nextSliderTime = arg0.nextSliderTime + var10
				end
			end

			if arg0.sliderBeginning then
				arg0.sliderTouchPos.x = arg0.sliderTouchPos.x + arg0.speed
				arg0.sliderTouch.anchoredPosition = arg0.sliderTouchPos

				if arg0.sliderTouchPos.x > var12[2] then
					arg0:touch(false)
				end
			end
		end,
		setSliderBarVisible = function(arg0, arg1)
			setActive(arg0._tf, arg1)
		end,
		startSliderBar = function(arg0)
			if arg0.sliderIndex > #var13 then
				arg0.sliderIndex = 1
			end

			arg0.sliderWidth = var13[arg0.sliderIndex]
			arg0.speed = var14[arg0.sliderIndex]
			arg0.sliderTouchPos.x = var12[1]
			arg0.sliderBeginning = true
			arg0.sliderRange.sizeDelta = Vector2(arg0.sliderWidth, arg0.sliderRange.sizeDelta.y)
		end,
		touch = function(arg0, arg1)
			if not arg0.sliderBeginning then
				return
			end

			arg0.sliderBeginning = false

			arg0:setSliderBarVisible(false)

			local var0 = false
			local var1 = 0
			local var2 = math.abs(arg0.sliderTouchPos.x - var15)
			local var3

			if var2 < arg0.sliderWidth / 2 then
				var1 = arg0:getScore(var2)
				arg0.sliderIndex = arg0.sliderIndex + 1
				var3 = true
			else
				if arg0.sliderTouchPos.x < 100 or arg0.sliderTouchPos.x > var12[2] - 100 then
					var1 = arg0:getSubScore(arg0.sliderTouchPos.x)
				end

				arg0.nextSliderTime = arg0.nextSliderTime + var16
				var3 = false
			end

			if var3 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5)
			else
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var6)
			end

			if arg1 then
				arg0._event:emit(var17, {
					flag = var3,
					score = var1
				}, function()
					return
				end)
			end
		end,
		getSubScore = function(arg0, arg1)
			local var0

			if arg1 <= 100 then
				var0 = arg1
			else
				var0 = var12[2] - arg1
			end

			for iter0 = 1, #var21 do
				if var0 < var21[iter0] then
					return var20[iter0]
				end
			end

			return 0
		end,
		getScore = function(arg0, arg1)
			for iter0 = 1, #var18 do
				if arg1 < var18[iter0] then
					return var19[iter0]
				end
			end

			return 0
		end,
		destroy = function(arg0)
			return
		end
	}

	var0:ctor()

	return var0
end

local function var34(arg0, arg1, arg2, arg3)
	local var0 = {
		ctor = function(arg0)
			arg0._charTpls = arg0
			arg0._foodTpl = arg1
			arg0._container = arg2
			arg0._event = arg3
		end,
		start = function(arg0)
			arg0:clear()

			arg0.player = nil
			arg0.chars = {}
			arg0.animateSpeed = var22
			arg0.playerNextStepTimes = {}

			arg0:create()
		end,
		step = function(arg0)
			for iter0 = 1, #arg0.chars do
				local var0 = arg0.chars[iter0]

				if not var0.nextTime then
					var0.nextTime = math.random(var0.next_time[1], var0.next_time[2])
				else
					var0.nextTime = var0.nextTime - Time.deltaTime

					if var0.nextTime <= 0 then
						var0.nextTime = nil
						var0.stepIndex = var0.stepIndex + 1

						if table.contains(var29, var0.stepIndex) then
							var0.tfAnimator:SetTrigger("next")
						end

						if var0.stepIndex == var30 then
							var0.tfAnimator:SetBool("eat", false)
							var0.tfAnimator:SetBool("bite", true)
						end

						if var0.stepIndex >= var28 then
							arg0:setWinChar(var0)
						end
					end
				end
			end
		end,
		setWinChar = function(arg0, arg1)
			local var0 = false

			if arg1 then
				var0 = arg1.isPlayer
				arg1.foodState = 6

				arg1.foodTfAnimator:SetInteger("state", arg1.foodState)
			end

			if arg0.player == arg1 then
				arg0.player.tfAnimator:SetTrigger("victory")
			else
				arg0.player.tfAnimator:SetTrigger("defeat")
			end

			for iter0 = 1, #arg0.chars do
				local var1 = arg0.chars[iter0]

				if var1 == arg1 then
					var1.tfAnimator:SetTrigger("victory")
				else
					var1.tfAnimator:SetTrigger("defeat")
				end
			end

			arg0._event:emit(var32, var0, function()
				return
			end)
		end,
		onPlayerTouch = function(arg0, arg1)
			if arg0.player then
				if arg1.flag then
					arg0.player.stepIndex = arg0.player.stepIndex + 1

					if table.contains(var29, arg0.player.stepIndex) and not table.contains(arg0.playerNextStepTimes, arg0.player.stepIndex) then
						table.insert(arg0.playerNextStepTimes, arg0.player.stepIndex)
						arg0.player.tfAnimator:SetTrigger("next")
					end

					if arg0.player.stepIndex == var30 then
						arg0.player.tfAnimator:SetBool("eat", false)
						arg0.player.tfAnimator:SetBool("bite", true)
					end

					if arg0.player.stepIndex >= var28 then
						arg0:setWinChar(arg0.player)
					end

					arg0.animateSpeed = arg0.animateSpeed + var23

					if arg0.animateSpeed > var24 then
						arg0.animateSpeed = var24
					end

					arg0.player.tfAnimator.speed = arg0.animateSpeed
				else
					arg0.animateSpeed = arg0.animateSpeed - var23

					if arg0.animateSpeed < var22 then
						arg0.animateSpeed = var22
					end

					arg0.player.tfAnimator.speed = arg0.animateSpeed

					arg0.player.tfAnimator:SetTrigger("miss")
				end
			end
		end,
		create = function(arg0)
			local var0 = Clone(var31)
			local var1 = table.remove(var0, math.random(1, #var0))

			arg0.player = arg0:getCharById(var1, var26)

			local var2 = Clone(var25)

			for iter0 = 1, #var27 do
				local var3 = table.remove(var2, math.random(1, #var2))
				local var4 = arg0:getCharById(var3, var27[iter0])

				table.insert(arg0.chars, var4)
			end
		end,
		getCharById = function(arg0, arg1, arg2)
			local var0 = {}
			local var1 = tf(instantiate(findTF(arg0._charTpls, "char" .. arg1.id)))
			local var2 = tf(instantiate(arg0._foodTpl))

			setParent(var1, findTF(arg0._container, tostring(arg2)))
			setActive(var1, true)
			setParent(var2, findTF(arg0._container, tostring(arg2)))
			setActive(var2, true)

			var2.anchoredPosition = Vector2(0, -300)
			var1.anchoredPosition = Vector2(0, 0)
			var0.tf = var1
			var0.tfAnimator = GetComponent(findTF(var1, "anim"), typeof(Animator))
			var0.tfAnimator.speed = arg0.animateSpeed
			var0.foodTf = var2
			var0.foodTfAnimator = GetComponent(findTF(var2, "anim"), typeof(Animator))
			var0.foodTfAnimator.speed = var22
			var0.next_time = arg1.next_time

			if not var0.next_time then
				var0.isPlayer = true
			else
				var0.nextTime = math.random(0, arg1.next_time[2] - arg1.next_time[1]) + arg1.next_time[1] + var11
			end

			var0.foodState = 0
			var0.stepIndex = 0

			local var3 = GetComponent(findTF(var1, "anim"), typeof(DftAniEvent))

			var3:SetStartEvent(function()
				var0.foodState = var0.foodState + 1

				var0.foodTfAnimator:SetInteger("state", var0.foodState)
			end)
			var3:SetTriggerEvent(function()
				return
			end)
			var3:SetEndEvent(function()
				return
			end)

			return var0
		end,
		stop = function(arg0)
			if arg0.player then
				arg0.player.tfAnimator.speed = 0
			end

			if arg0.chars and #arg0.chars > 0 then
				for iter0 = 1, #arg0.chars do
					arg0.chars[iter0].tfAnimator.speed = 0
				end
			end
		end,
		resume = function(arg0)
			if arg0.player then
				arg0.player.tfAnimator.speed = arg0.animateSpeed
			end

			if arg0.chars and #arg0.chars > 0 then
				for iter0 = 1, #arg0.chars do
					arg0.chars[iter0].tfAnimator.speed = var22
				end
			end
		end,
		onTimeOut = function(arg0)
			local var0 = arg0.player
			local var1 = arg0.player.stepIndex or 0

			for iter0 = 1, #arg0.chars do
				if var1 < arg0.chars[iter0].stepIndex then
					var0 = arg0.chars[iter0]
					var1 = arg0.chars[iter0].stepIndex
				end
			end

			arg0:setWinChar(var0)
		end,
		clear = function(arg0)
			if arg0.player then
				destroy(arg0.player.tf)
				destroy(arg0.player.foodTf)
			end

			if arg0.chars then
				for iter0 = 1, #arg0.chars do
					destroy(arg0.chars[iter0].tf)
					destroy(arg0.chars[iter0].foodTf)
				end
			end
		end
	}

	var0:ctor()

	return var0
end

function var0.getUIName(arg0)
	return "EatFoodGameUI"
end

function var0.getBGM(arg0)
	return var1
end

function var0.didEnter(arg0)
	arg0:initEvent()
	arg0:initData()
	arg0:initUI()
	arg0:initGameUI()
	arg0:readyStart()
end

function var0.OnGetAwardDone(arg0)
	arg0:CheckGet()
end

function var0.OnSendMiniGameOPDone(arg0, arg1)
	return
end

function var0.initEvent(arg0)
	arg0:bind(var32, function(arg0, arg1, arg2)
		arg0:setGameOver(arg1)
	end)
	arg0:bind(var17, function(arg0, arg1, arg2)
		if arg1.score and arg1.score ~= 0 then
			arg0:addScore(arg1.score)
		end

		if arg0.charController then
			arg0.charController:onPlayerTouch(arg1)
		end
	end)
end

function var0.initData(arg0)
	arg0.dropData = pg.mini_game[arg0:GetMGData().id].simple_config_data.drop

	local var0 = Application.targetFrameRate or 60

	if var0 > 60 then
		var0 = 60
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()
	end, 1 / var0, -1)
end

function var0.initUI(arg0)
	arg0.backSceneTf = findTF(arg0._tf, "scene_container/scene_background")
	arg0.sceneTf = findTF(arg0._tf, "scene_container/scene")
	arg0.bgTf = findTF(arg0._tf, "bg")
	arg0.clickMask = findTF(arg0._tf, "clickMask")
	arg0.countUI = findTF(arg0._tf, "pop/CountUI")
	arg0.countAnimator = GetComponent(findTF(arg0.countUI, "count"), typeof(Animator))
	arg0.countDft = GetOrAddComponent(findTF(arg0.countUI, "count"), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)

		arg0.readyStart = false
	end)
	SetActive(arg0.countUI, false)

	arg0.leaveUI = findTF(arg0._tf, "pop/LeaveUI")

	onButton(arg0, findTF(arg0.leaveUI, "ad/btnOk"), function()
		arg0:resumeGame()

		if arg0.charController then
			arg0.charController:stop()
		end

		arg0:onGameOver(0)
	end, SFX_CANCEL)
	onButton(arg0, findTF(arg0.leaveUI, "ad/btnCancel"), function()
		arg0:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0.leaveUI, false)

	arg0.pauseUI = findTF(arg0._tf, "pop/pauseUI")

	onButton(arg0, findTF(arg0.pauseUI, "ad/btnOk"), function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_CANCEL)
	SetActive(arg0.pauseUI, false)

	arg0.resultUI = findTF(arg0._tf, "pop/resultUI")

	SetActive(arg0.resultUI, false)

	arg0.settlementUI = findTF(arg0._tf, "pop/SettleMentUI")

	onButton(arg0, findTF(arg0.settlementUI, "ad/btnOver"), function()
		setActive(arg0.settlementUI, false)
		arg0:closeView()
	end, SFX_CANCEL)
	SetActive(arg0.settlementUI, false)

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.initGameUI(arg0)
	arg0.gameUI = findTF(arg0._tf, "ui/gameUI")

	onButton(arg0, findTF(arg0.gameUI, "topRight/btnStop"), function()
		arg0:stopGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, findTF(arg0.gameUI, "btnLeave"), function()
		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end)

	arg0.dragDelegate = GetOrAddComponent(arg0.sceneTf, "EventTriggerListener")
	arg0.dragDelegate.enabled = true

	arg0.dragDelegate:AddPointDownFunc(function(arg0, arg1)
		if arg0.sliderController then
			arg0.sliderController:touch(true)
		end
	end)

	arg0.gameTimeS = findTF(arg0.gameUI, "top/time/s")
	arg0.scoreTf = findTF(arg0.gameUI, "top/score")
	arg0.sceneScoreTf = findTF(arg0.sceneTf, "score")
	arg0.sliderController = var33(findTF(arg0.sceneTf, "collider"), arg0)
	arg0.charController = var34(findTF(arg0.sceneTf, "tpls"), findTF(arg0.sceneTf, "food"), findTF(arg0.sceneTf, "container"), arg0)
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gameStop or arg0.settlementFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0.updateMenuUI(arg0)
	return
end

function var0.CheckGet(arg0)
	if arg0:getUltimate() == 0 then
		if arg0:getGameTotalTime() > arg0:getGameUsedTimes() then
			return
		end

		pg.m02:sendNotification(GAME.SEND_MINI_GAME_OP, {
			hubid = arg0:GetMGHubData().id,
			cmd = MiniGameOPCommand.CMD_ULTIMATE,
			args1 = {}
		})
	end
end

function var0.openMenuUI(arg0)
	setActive(findTF(arg0._tf, "scene_container"), false)
	setActive(findTF(arg0.bgTf, "on"), true)
	setActive(arg0.gameUI, false)
	setActive(arg0.menuUI, true)
end

function var0.clearUI(arg0)
	setActive(arg0.sceneTf, false)
	setActive(arg0.settlementUI, false)
	setActive(arg0.countUI, false)
	setActive(arg0.menuUI, false)
	setActive(arg0.gameUI, false)
end

function var0.readyStart(arg0)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2)

	arg0.readyStart = true

	arg0:gameStart()
end

function var0.getGameTimes(arg0)
	return arg0:GetMGHubData().count
end

function var0.getGameUsedTimes(arg0)
	return arg0:GetMGHubData().usedtime
end

function var0.getUltimate(arg0)
	return arg0:GetMGHubData().ultimate
end

function var0.getGameTotalTime(arg0)
	return (arg0:GetMGHubData():getConfig("reward_need"))
end

function var0.gameStart(arg0)
	setActive(findTF(arg0._tf, "scene_container"), true)
	setActive(findTF(arg0.bgTf, "on"), false)
	setActive(arg0.gameUI, true)

	arg0.gameStartFlag = true
	arg0.scoreNum = 0
	arg0.playerPosIndex = 2
	arg0.gameStepTime = 0
	arg0.gameTime = var7

	if arg0.sliderController then
		arg0.sliderController:start()
	end

	if arg0.charController then
		arg0.charController:start()
	end

	arg0:updateGameUI()
	arg0:timerStart()
end

function var0.transformColor(arg0, arg1)
	local var0 = tonumber(string.sub(arg1, 1, 2), 16)
	local var1 = tonumber(string.sub(arg1, 3, 4), 16)
	local var2 = tonumber(string.sub(arg1, 5, 6), 16)

	return Color.New(var0 / 255, var1 / 255, var2 / 255)
end

function var0.addScore(arg0, arg1, arg2)
	setActive(arg0.sceneScoreTf, false)

	if arg1 then
		arg0.scoreNum = arg0.scoreNum + arg1

		local var0 = arg1 >= 0 and "+" .. arg1 or tostring(arg1)

		setText(findTF(arg0.sceneScoreTf, "img"), var0)
		setActive(arg0.sceneScoreTf, true)
	end

	arg0:updateGameUI()
end

function var0.onTimer(arg0)
	arg0:gameStep()
end

function var0.gameStep(arg0)
	if not arg0.readyStart then
		arg0.gameTime = arg0.gameTime - Time.deltaTime
		arg0.gameStepTime = arg0.gameStepTime + Time.deltaTime
	end

	if arg0.gameTime < 0 then
		arg0.gameTime = 0
	end

	arg0:updateGameUI()

	if arg0.sliderController then
		arg0.sliderController:step()
	end

	if arg0.charController then
		arg0.charController:step()
	end

	if arg0.gameTime <= 0 then
		if arg0.charController then
			arg0.charController:onTimeOut()
		end

		return
	end
end

function var0.timerStart(arg0)
	if not arg0.timer.running then
		arg0.timer:Start()
	end
end

function var0.timerStop(arg0)
	if arg0.timer.running then
		arg0.timer:Stop()
	end
end

function var0.updateGameUI(arg0)
	setText(arg0.scoreTf, arg0.scoreNum)
	setText(arg0.gameTimeS, math.ceil(arg0.gameTime))
end

function var0.setGameOver(arg0, arg1)
	arg0:onGameOver(3.5)

	local var0
	local var1 = Application.targetFrameRate or 60

	seriesAsync({
		function(arg0)
			local var0 = 0

			var0 = Timer.New(function()
				var0 = var0 + 15

				if var0 > 1400 then
					arg0()
				end
			end, 1 / var1, -1)

			var0:Start()
		end,
		function(arg0)
			if var0 then
				var0:Stop()

				var0 = nil
			end

			if arg1 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3)
			else
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4)
			end

			setActive(findTF(arg0.resultUI, "ad/victory"), arg1)
			setActive(findTF(arg0.resultUI, "ad/defeat"), not arg1)
			setActive(arg0.resultUI, true)
			GetComponent(findTF(arg0.resultUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

			local var0 = 0

			var0 = Timer.New(function()
				var0 = var0 + 15

				if var0 > 1400 then
					setActive(arg0.resultUI, false)
					arg0()
				end
			end, 1 / var1, -1)

			var0:Start()
		end
	}, function()
		if var0 then
			var0:Stop()

			var0 = nil
		end
	end)
end

function var0.onGameOver(arg0, arg1)
	if arg0.settlementFlag then
		return
	end

	arg0:timerStop()

	arg0.settlementFlag = true

	setActive(arg0.clickMask, true)
	LeanTween.delayedCall(go(arg0._tf), arg1, System.Action(function()
		arg0.settlementFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0:showSettlement()
	end))
end

function var0.showSettlement(arg0)
	setActive(arg0.settlementUI, true)
	GetComponent(findTF(arg0.settlementUI, "ad"), typeof(Animator)):Play("settlement", -1, 0)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	setActive(findTF(arg0.settlementUI, "ad/new"), var2 < var1)

	if var2 <= var1 then
		var2 = var1

		arg0:StoreDataToServer({
			var2
		})
	end

	local var3 = findTF(arg0.settlementUI, "ad/highText")
	local var4 = findTF(arg0.settlementUI, "ad/currentText")

	setText(var3, var2)
	setText(var4, var1)

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0.sendSuccessFlag = true

		arg0:SendSuccess(0)

		local var5 = arg0:getGameTotalTime()
		local var6 = arg0:getGameUsedTimes()
	end
end

function var0.resumeGame(arg0)
	arg0.gameStop = false

	setActive(arg0.leaveUI, false)

	if arg0.charController then
		arg0.charController:resume()
	end

	arg0:timerStart()
end

function var0.stopGame(arg0)
	arg0.gameStop = true

	if arg0.charController then
		arg0.charController:stop()
	end

	arg0:timerStop()
end

function var0.onBackPressed(arg0)
	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		if arg0.settlementFlag then
			return
		end

		if isActive(arg0.pauseUI) then
			setActive(arg0.pauseUI, false)
		end

		arg0:stopGame()
		setActive(arg0.leaveUI, true)
	end
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	if arg0._tf and LeanTween.isTweening(go(arg0._tf)) then
		LeanTween.cancel(go(arg0._tf))
	end

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	Time.timeScale = 1
	arg0.timer = nil
end

return var0
