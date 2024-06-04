local var0 = class("DOAPPMiniGameController")

function var0.Ctor(arg0, arg1, arg2)
	arg0.binder = arg1

	arg0:InitTimer()
	arg0:InitGameUI(arg2)
end

local function var1(arg0, arg1)
	local var0 = arg0:GetComponentsInChildren(typeof(Animator), true)

	for iter0 = 0, var0.Length - 1 do
		var0[iter0].speed = arg1
	end
end

function var0.InitTimer(arg0)
	arg0.timer = Timer.New(function()
		arg0:OnTimer(DOAPPGameConfig.TIME_INTERVAL)
	end, DOAPPGameConfig.TIME_INTERVAL, -1)

	if IsUnityEditor and not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.AddDebugInput, arg0)

		UpdateBeat:AddListener(arg0.handle)
	end
end

function var0.AddDebugInput(arg0)
	local var0 = {
		"E",
		"S",
		"W",
		"N"
	}
	local var1 = {
		"D",
		"S",
		"A",
		"W"
	}

	for iter0, iter1 in ipairs(var1) do
		if Input.GetKeyDown(KeyCode[iter1]) then
			arg0.cacheInput = var0[iter0]
		end

		if Input.GetKeyUp(KeyCode[iter1]) and arg0.cacheInput == var0[iter0] then
			arg0.cacheInput = nil
		end
	end
end

local var2 = {
	"Light",
	"Heavy",
	"Dodge"
}

function var0.InitGameUI(arg0, arg1)
	arg0.rtViewport = arg1:Find("Viewport")
	arg0.rtBg = arg0.rtViewport:Find("MainContent/bg")
	arg0.rtCharacter = arg0.rtViewport:Find("MainContent/character")
	arg0.rtPlayContent = arg0.rtViewport:Find("MainContent/playContent")
	arg0.rtBtns = arg1:Find("Controller/middle/btn")

	eachChild(arg0.rtBtns, function(arg0)
		onButton(arg0.binder, arg0, function()
			arg0.selectAction = table.indexof(var2, arg0.name)

			setActive(arg0.rtBtns, false)
			arg0:AfterSelect()
		end, SFX_CONFIRM)
	end)
	setActive(arg0.rtBtns, false)

	arg0.rtFloatUI = arg1:Find("Controller/middle/targetUI")

	setActive(arg0.rtFloatUI, false)
	eachChild(arg0.rtPlayContent:Find("middle/EffectObject"), function(arg0)
		arg0:Find("Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0, false)
		end)
	end)
	eachChild(arg0.rtPlayContent:Find("middle/EffectOtherObject"), function(arg0)
		arg0:Find("Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0, false)
		end)
	end)

	arg0.rtPointShow = arg1:Find("Controller/middle/point")
	arg0.textTime = arg1:Find("Controller/top/panel/time")
	arg0.rtPoint = arg1:Find("Controller/top/self")
	arg0.rtPointOther = arg1:Find("Controller/top/others")
end

local var3 = {
	"Misaki",
	"Marie",
	"Tamaki",
	"Luna"
}

function var0.SetCharacter(arg0, arg1)
	local var0 = table.indexof(var3, arg1)

	arg0.rtTarget = cloneTplTo(arg0.rtCharacter:Find(arg1), arg0.rtPlayContent:Find("front"), arg1)

	local var1 = arg0.rtTarget:Find("Image"):GetComponent(typeof(DftAniEvent))

	var1:SetEndEvent(function()
		if math.abs(arg0.deltaMove) > 2 then
			arg0:ReadyPoint()
		else
			arg0:UpdateReady(arg0.rtTarget)
		end
	end)
	var1:SetTriggerEvent(function()
		arg0.countTarget = arg0.countTarget + 1

		eachChild(arg0.rtTarget:Find("effect"), function(arg0)
			if arg0.name == arg0.statusTarget .. "_" .. arg0.countTarget then
				setActive(arg0, true)
			end
		end)
	end)
	eachChild(arg0.rtTarget:Find("effect"), function(arg0)
		arg0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0, false)
		end)
	end)
	eachChild(arg0.rtPoint:Find("icon/mask"), function(arg0)
		setActive(arg0, arg0.name == arg1)
	end)

	local var2 = var3[(var0 + math.random(3) + 3) % 4 + 1]

	arg0.rtOtherTarget = cloneTplTo(arg0.rtCharacter:Find(var2), arg0.rtPlayContent:Find("back"), var2)

	eachChild(arg0.rtOtherTarget, function(arg0)
		setAnchoredPosition(arg0, {
			x = 5
		})
	end)
	setLocalScale(arg0.rtOtherTarget, {
		x = -1
	})

	local var3 = arg0.rtOtherTarget:Find("Image"):GetComponent(typeof(DftAniEvent))

	var3:SetEndEvent(function()
		if math.abs(arg0.deltaMove) > 2 then
			arg0:ReadyPoint()
		else
			arg0:UpdateReady(arg0.rtOtherTarget)
		end
	end)
	var3:SetTriggerEvent(function()
		arg0.countOther = arg0.countOther + 1

		eachChild(arg0.rtOtherTarget:Find("effect"), function(arg0)
			if arg0.name == arg0.statusOther .. "_" .. arg0.countOther then
				setActive(arg0, true)
			end
		end)
	end)
	eachChild(arg0.rtOtherTarget:Find("effect"), function(arg0)
		arg0:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0, false)
		end)
	end)
	eachChild(arg0.rtPointOther:Find("icon/mask"), function(arg0)
		setActive(arg0, arg0.name == var2)
	end)

	arg0.rtEffectObject = arg0.rtPlayContent:Find("middle/EffectObject")
end

local function var4(arg0, arg1)
	local var0 = arg0:Find("point")

	for iter0 = var0.childCount, 1, -1 do
		triggerToggle(var0:GetChild(iter0 - 1), iter0 <= arg1)
	end
end

function var0.UpdatePoint(arg0)
	var4(arg0.rtPoint, arg0.myPoint)
	var4(arg0.rtPointOther, arg0.otherPoint)
end

function var0.UpdateReady(arg0, arg1)
	onNextTick(function()
		if arg1 == arg0.rtTarget then
			setActive(arg0.rtBtns, true)
		elseif arg1 == arg0.rtOtherTarget then
			setAnchoredPosition(arg0.rtFloatUI, {
				x = arg0.deltaMove * 60
			})

			arg0.otherSelectAction = math.random(3)

			eachChild(arg0.rtFloatUI, function(arg0)
				setActive(arg0, arg0.name == tostring(arg0.otherSelectAction))
			end)

			arg0.selectCountdown = DOAPPGameConfig.SELECT_TIME

			setSlider(arg0.rtFloatUI:Find(arg0.otherSelectAction .. "/Slider"), 0, DOAPPGameConfig.SELECT_TIME, DOAPPGameConfig.SELECT_TIME - arg0.selectCountdown)
			setActive(arg0.rtFloatUI, true)
			arg0:AfterSelect()
		else
			assert(false)
		end

		setAnchoredPosition(arg1, {
			x = arg0.deltaMove * 10
		})
	end)
	quickPlayAnimator(arg1:Find("Image"), "Idle")
end

function var0.PlayEffect(arg0, arg1)
	setAnchoredPosition(arg0.rtEffectObject, {
		x = arg0.deltaMove * 10
	})

	arg0.effectCountdownDic[arg1] = DOAPPGameConfig.EFFECT_COUNTDOWN[arg1]
end

function var0.AfterSelect(arg0)
	if arg0.selectAction and arg0.otherSelectAction then
		setActive(arg0.rtFloatUI, false)
		switch((arg0.selectAction - arg0.otherSelectAction + 3) % 3, {
			[0] = function()
				quickPlayAnimator(arg0.rtTarget:Find("Image"), "Draw")
				quickPlayAnimator(arg0.rtOtherTarget:Find("Image"), "Draw")

				arg0.stopTarget = nil

				arg0:PlayEffect("Draw")

				arg0.blockMoveBg = true
			end,
			function()
				arg0.deltaMove = arg0.deltaMove + 1

				local var0 = math.abs(arg0.deltaMove) > 2 and {
					"Win_",
					"Lose_"
				} or {
					"Attack_",
					"Damage_"
				}

				setParent(arg0.rtTarget, arg0.rtPlayContent:Find("front"))
				quickPlayAnimator(arg0.rtTarget:Find("Image"), var0[1] .. var2[arg0.selectAction])

				arg0.statusTarget = var0[1] .. var2[arg0.selectAction]
				arg0.countTarget = 0

				setParent(arg0.rtOtherTarget, arg0.rtPlayContent:Find("back"))
				quickPlayAnimator(arg0.rtOtherTarget:Find("Image"), var0[2] .. var2[arg0.otherSelectAction])

				arg0.statusOther = var0[2] .. var2[arg0.otherSelectAction]
				arg0.countOther = 0
				arg0.rtEffectObject = arg0.rtPlayContent:Find("middle/EffectObject")
				arg0.stopTarget = arg0.rtOtherTarget

				arg0:PlayEffect(var2[arg0.selectAction])

				arg0.blockMoveBg = true

				if math.abs(arg0.deltaMove) > 2 then
					arg0.loseDropCountdown = DOAPPGameConfig.LOSE_SOUND_COUNTDOWN[var2[arg0.otherSelectAction]] + defaultValue(DOAPPGameConfig.EFFECT_STOP_TIME[var2[arg0.selectAction]], 0)
				end
			end,
			function()
				arg0.deltaMove = arg0.deltaMove - 1

				local var0 = math.abs(arg0.deltaMove) > 2 and {
					"Win_",
					"Lose_"
				} or {
					"Attack_",
					"Damage_"
				}

				setParent(arg0.rtTarget, arg0.rtPlayContent:Find("back"))
				quickPlayAnimator(arg0.rtTarget:Find("Image"), var0[2] .. var2[arg0.selectAction])

				arg0.statusTarget = var0[2] .. var2[arg0.selectAction]
				arg0.countTarget = 0

				setParent(arg0.rtOtherTarget, arg0.rtPlayContent:Find("front"))
				quickPlayAnimator(arg0.rtOtherTarget:Find("Image"), var0[1] .. var2[arg0.otherSelectAction])

				arg0.statusOther = var0[1] .. var2[arg0.otherSelectAction]
				arg0.countOther = 0
				arg0.rtEffectObject = arg0.rtPlayContent:Find("middle/EffectOtherObject")
				arg0.stopTarget = arg0.rtTarget

				arg0:PlayEffect(var2[arg0.otherSelectAction])

				arg0.blockMoveBg = true

				if math.abs(arg0.deltaMove) > 2 then
					arg0.loseDropCountdown = DOAPPGameConfig.LOSE_SOUND_COUNTDOWN[var2[arg0.selectAction]] + defaultValue(DOAPPGameConfig.EFFECT_STOP_TIME[var2[arg0.otherSelectAction]], 0)
				end
			end
		})

		arg0.selectAction = nil
		arg0.otherSelectAction = nil
		arg0.selectCountdown = nil
	end
end

function var0.ReadyPoint(arg0)
	if arg0.readyPointCount > 0 then
		arg0.readyPointCount = 0

		if arg0.deltaMove > 0 then
			arg0.myPoint = arg0.myPoint + 1
		else
			arg0.otherPoint = arg0.otherPoint + 1
		end

		arg0:UpdatePoint()

		if arg0.myPoint > 2 or arg0.otherPoint > 2 then
			arg0:EndGame(arg0.myPoint - arg0.otherPoint)
		else
			arg0.nextCountdown = DOAPPGameConfig.NEXT_ROUND_COUNTDOWN

			eachChild(arg0.rtPointShow:Find("left"), function(arg0)
				setActive(arg0, arg0.name == tostring(arg0.myPoint))
			end)
			eachChild(arg0.rtPointShow:Find("right"), function(arg0)
				setActive(arg0, arg0.name == tostring(arg0.otherPoint))
			end)
			setActive(arg0.rtPointShow, true)
		end
	else
		arg0.readyPointCount = arg0.readyPointCount + 1
	end
end

function var0.GetResultInfo(arg0, arg1)
	if arg1 then
		return arg0.rtOtherTarget.name, arg0.otherPoint, arg0.result * -1
	else
		return arg0.rtTarget.name, arg0.myPoint, arg0.result
	end
end

function var0.ResetGame(arg0)
	arg0.timeCount = DOAPPGameConfig.ALL_TIME

	setText(arg0.textTime, string.format("%02ds", arg0.timeCount))

	arg0.deltaMove = 0

	if not IsNil(arg0.rtTarget) then
		Destroy(arg0.rtTarget)

		arg0.rtTarget = nil
	end

	if not IsNil(arg0.rtOtherTarget) then
		Destroy(arg0.rtOtherTarget)

		arg0.rtOtherTarget = nil
	end

	setAnchoredPosition(arg0.rtViewport:Find("MainContent"), {
		x = 0
	})
	eachChild(arg0.rtViewport:Find("MainContent/bg"), function(arg0)
		setAnchoredPosition(arg0, {
			x = 0
		})
	end)

	arg0.myPoint = 0
	arg0.otherPoint = 0
	arg0.readyPointCount = 0

	setActive(arg0.rtPointShow, false)

	arg0.effectCountdownDic = {}
end

function var0.ReadyGame(arg0, arg1)
	arg0:SetCharacter(arg1.name)
	arg0:UpdatePoint()
	arg0:PauseGame()
end

function var0.StartGame(arg0)
	arg0.isStart = true

	arg0:UpdateReady(arg0.rtTarget)
	arg0:UpdateReady(arg0.rtOtherTarget)
	arg0:ResumeGame()
end

function var0.EndGame(arg0, arg1)
	arg0.isStart = false

	arg0:PauseGame()

	arg0.result = arg1 or 0

	arg0.binder:openUI("result")
end

function var0.ResumeGame(arg0)
	arg0.isPause = false

	arg0.timer:Start()
	var1(arg0.rtViewport, 1)
end

function var0.PauseGame(arg0)
	arg0.isPause = true

	arg0.timer:Stop()
	var1(arg0.rtViewport, 0)
end

function var0.OnTimer(arg0, arg1)
	arg0.timeCount = arg0.timeCount - arg1

	setText(arg0.textTime, string.format("%02ds", arg0.timeCount))

	if arg0.timeCount <= 0 then
		arg0:EndGame(arg0.myPoint - arg0.otherPoint)

		return
	end

	if arg0.selectCountdown then
		arg0.selectCountdown = arg0.selectCountdown - arg1

		setSlider(arg0.rtFloatUI:Find(arg0.otherSelectAction .. "/Slider"), 0, DOAPPGameConfig.SELECT_TIME, DOAPPGameConfig.SELECT_TIME - arg0.selectCountdown)
		setText(arg0.rtFloatUI:Find(arg0.otherSelectAction .. "/Text"), string.format("%2d%%", (DOAPPGameConfig.SELECT_TIME - arg0.selectCountdown) * 100 / DOAPPGameConfig.SELECT_TIME))

		if arg0.selectCountdown <= 0 then
			arg0.selectAction = (arg0.otherSelectAction + 1) % 3 + 1

			setActive(arg0.rtBtns, false)
			arg0:AfterSelect()
		end
	end

	if arg0.nextCountdown then
		arg0.nextCountdown = arg0.nextCountdown - arg1

		if arg0.nextCountdown <= 0 then
			arg0.nextCountdown = nil

			setActive(arg0.rtPointShow, false)

			arg0.deltaMove = 0

			arg0:UpdateReady(arg0.rtTarget)
			arg0:UpdateReady(arg0.rtOtherTarget)
		end
	end

	for iter0, iter1 in pairs(arg0.effectCountdownDic) do
		arg0.effectCountdownDic[iter0] = arg0.effectCountdownDic[iter0] - arg1

		if arg0.effectCountdownDic[iter0] <= 0 then
			arg0.effectCountdownDic[iter0] = nil

			setActive(arg0.rtEffectObject:Find(iter0), true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(DOAPPGameConfig.SOUND_EFFECT_PP)

			arg0.blockMoveBg = false

			if arg0.stopTarget then
				arg0.stopCount = DOAPPGameConfig.EFFECT_STOP_TIME[iter0]

				if arg0.stopCount then
					onNextTick(function()
						var1(arg0.stopTarget, 0)
					end)
				end
			end
		end
	end

	if arg0.stopCount then
		arg0.stopCount = arg0.stopCount - arg1

		if arg0.stopCount <= 0 then
			arg0.stopCount = nil

			var1(arg0.stopTarget, 1)
		end
	end

	if arg0.loseDropCountdown then
		arg0.loseDropCountdown = arg0.loseDropCountdown - arg1

		if arg0.loseDropCountdown <= 0 then
			arg0.loseDropCountdown = nil

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(DOAPPGameConfig.SOUND_EFFECT_DROP)
		end
	end

	if not arg0.blockMoveBg then
		local function var0(arg0, arg1)
			local var0 = arg0.anchoredPosition.x / arg1
			local var1 = var0 + (arg0.deltaMove - var0 > 0 and 1 or -1) * (arg1 / DOAPPGameConfig.BG_MOVE_TIME)
			local var2 = var0 < arg0.deltaMove and {
				var0,
				arg0.deltaMove
			} or {
				arg0.deltaMove,
				var0
			}
			local var3 = math.clamp(var1, unpack(var2))

			setAnchoredPosition(arg0, {
				x = var3 * arg1
			})
		end

		local var1 = arg0.rtViewport:Find("MainContent")

		if var1.anchoredPosition.x ~= arg0.deltaMove * DOAPPGameConfig.BG_DISTANCE then
			var0(var1, -1 * DOAPPGameConfig.BG_DISTANCE)

			local var2 = var1:Find("bg")
			local var3 = var2.childCount

			for iter2 = 1, var3 - 1 do
				var0(var2:GetChild(iter2 - 1), (iter2 - var3) * DOAPPGameConfig.BG_DISTANCE)
			end
		end
	end
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end
end

return var0
