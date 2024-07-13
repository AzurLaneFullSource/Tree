local var0_0 = class("DOAPPMiniGameController")

function var0_0.Ctor(arg0_1, arg1_1, arg2_1)
	arg0_1.binder = arg1_1

	arg0_1:InitTimer()
	arg0_1:InitGameUI(arg2_1)
end

local function var1_0(arg0_2, arg1_2)
	local var0_2 = arg0_2:GetComponentsInChildren(typeof(Animator), true)

	for iter0_2 = 0, var0_2.Length - 1 do
		var0_2[iter0_2].speed = arg1_2
	end
end

function var0_0.InitTimer(arg0_3)
	arg0_3.timer = Timer.New(function()
		arg0_3:OnTimer(DOAPPGameConfig.TIME_INTERVAL)
	end, DOAPPGameConfig.TIME_INTERVAL, -1)

	if IsUnityEditor and not arg0_3.handle then
		arg0_3.handle = UpdateBeat:CreateListener(arg0_3.AddDebugInput, arg0_3)

		UpdateBeat:AddListener(arg0_3.handle)
	end
end

function var0_0.AddDebugInput(arg0_5)
	local var0_5 = {
		"E",
		"S",
		"W",
		"N"
	}
	local var1_5 = {
		"D",
		"S",
		"A",
		"W"
	}

	for iter0_5, iter1_5 in ipairs(var1_5) do
		if Input.GetKeyDown(KeyCode[iter1_5]) then
			arg0_5.cacheInput = var0_5[iter0_5]
		end

		if Input.GetKeyUp(KeyCode[iter1_5]) and arg0_5.cacheInput == var0_5[iter0_5] then
			arg0_5.cacheInput = nil
		end
	end
end

local var2_0 = {
	"Light",
	"Heavy",
	"Dodge"
}

function var0_0.InitGameUI(arg0_6, arg1_6)
	arg0_6.rtViewport = arg1_6:Find("Viewport")
	arg0_6.rtBg = arg0_6.rtViewport:Find("MainContent/bg")
	arg0_6.rtCharacter = arg0_6.rtViewport:Find("MainContent/character")
	arg0_6.rtPlayContent = arg0_6.rtViewport:Find("MainContent/playContent")
	arg0_6.rtBtns = arg1_6:Find("Controller/middle/btn")

	eachChild(arg0_6.rtBtns, function(arg0_7)
		onButton(arg0_6.binder, arg0_7, function()
			arg0_6.selectAction = table.indexof(var2_0, arg0_7.name)

			setActive(arg0_6.rtBtns, false)
			arg0_6:AfterSelect()
		end, SFX_CONFIRM)
	end)
	setActive(arg0_6.rtBtns, false)

	arg0_6.rtFloatUI = arg1_6:Find("Controller/middle/targetUI")

	setActive(arg0_6.rtFloatUI, false)
	eachChild(arg0_6.rtPlayContent:Find("middle/EffectObject"), function(arg0_9)
		arg0_9:Find("Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0_9, false)
		end)
	end)
	eachChild(arg0_6.rtPlayContent:Find("middle/EffectOtherObject"), function(arg0_11)
		arg0_11:Find("Image"):GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0_11, false)
		end)
	end)

	arg0_6.rtPointShow = arg1_6:Find("Controller/middle/point")
	arg0_6.textTime = arg1_6:Find("Controller/top/panel/time")
	arg0_6.rtPoint = arg1_6:Find("Controller/top/self")
	arg0_6.rtPointOther = arg1_6:Find("Controller/top/others")
end

local var3_0 = {
	"Misaki",
	"Marie",
	"Tamaki",
	"Luna"
}

function var0_0.SetCharacter(arg0_13, arg1_13)
	local var0_13 = table.indexof(var3_0, arg1_13)

	arg0_13.rtTarget = cloneTplTo(arg0_13.rtCharacter:Find(arg1_13), arg0_13.rtPlayContent:Find("front"), arg1_13)

	local var1_13 = arg0_13.rtTarget:Find("Image"):GetComponent(typeof(DftAniEvent))

	var1_13:SetEndEvent(function()
		if math.abs(arg0_13.deltaMove) > 2 then
			arg0_13:ReadyPoint()
		else
			arg0_13:UpdateReady(arg0_13.rtTarget)
		end
	end)
	var1_13:SetTriggerEvent(function()
		arg0_13.countTarget = arg0_13.countTarget + 1

		eachChild(arg0_13.rtTarget:Find("effect"), function(arg0_16)
			if arg0_16.name == arg0_13.statusTarget .. "_" .. arg0_13.countTarget then
				setActive(arg0_16, true)
			end
		end)
	end)
	eachChild(arg0_13.rtTarget:Find("effect"), function(arg0_17)
		arg0_17:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0_17, false)
		end)
	end)
	eachChild(arg0_13.rtPoint:Find("icon/mask"), function(arg0_19)
		setActive(arg0_19, arg0_19.name == arg1_13)
	end)

	local var2_13 = var3_0[(var0_13 + math.random(3) + 3) % 4 + 1]

	arg0_13.rtOtherTarget = cloneTplTo(arg0_13.rtCharacter:Find(var2_13), arg0_13.rtPlayContent:Find("back"), var2_13)

	eachChild(arg0_13.rtOtherTarget, function(arg0_20)
		setAnchoredPosition(arg0_20, {
			x = 5
		})
	end)
	setLocalScale(arg0_13.rtOtherTarget, {
		x = -1
	})

	local var3_13 = arg0_13.rtOtherTarget:Find("Image"):GetComponent(typeof(DftAniEvent))

	var3_13:SetEndEvent(function()
		if math.abs(arg0_13.deltaMove) > 2 then
			arg0_13:ReadyPoint()
		else
			arg0_13:UpdateReady(arg0_13.rtOtherTarget)
		end
	end)
	var3_13:SetTriggerEvent(function()
		arg0_13.countOther = arg0_13.countOther + 1

		eachChild(arg0_13.rtOtherTarget:Find("effect"), function(arg0_23)
			if arg0_23.name == arg0_13.statusOther .. "_" .. arg0_13.countOther then
				setActive(arg0_23, true)
			end
		end)
	end)
	eachChild(arg0_13.rtOtherTarget:Find("effect"), function(arg0_24)
		arg0_24:GetComponent(typeof(DftAniEvent)):SetEndEvent(function()
			setActive(arg0_24, false)
		end)
	end)
	eachChild(arg0_13.rtPointOther:Find("icon/mask"), function(arg0_26)
		setActive(arg0_26, arg0_26.name == var2_13)
	end)

	arg0_13.rtEffectObject = arg0_13.rtPlayContent:Find("middle/EffectObject")
end

local function var4_0(arg0_27, arg1_27)
	local var0_27 = arg0_27:Find("point")

	for iter0_27 = var0_27.childCount, 1, -1 do
		triggerToggle(var0_27:GetChild(iter0_27 - 1), iter0_27 <= arg1_27)
	end
end

function var0_0.UpdatePoint(arg0_28)
	var4_0(arg0_28.rtPoint, arg0_28.myPoint)
	var4_0(arg0_28.rtPointOther, arg0_28.otherPoint)
end

function var0_0.UpdateReady(arg0_29, arg1_29)
	onNextTick(function()
		if arg1_29 == arg0_29.rtTarget then
			setActive(arg0_29.rtBtns, true)
		elseif arg1_29 == arg0_29.rtOtherTarget then
			setAnchoredPosition(arg0_29.rtFloatUI, {
				x = arg0_29.deltaMove * 60
			})

			arg0_29.otherSelectAction = math.random(3)

			eachChild(arg0_29.rtFloatUI, function(arg0_31)
				setActive(arg0_31, arg0_31.name == tostring(arg0_29.otherSelectAction))
			end)

			arg0_29.selectCountdown = DOAPPGameConfig.SELECT_TIME

			setSlider(arg0_29.rtFloatUI:Find(arg0_29.otherSelectAction .. "/Slider"), 0, DOAPPGameConfig.SELECT_TIME, DOAPPGameConfig.SELECT_TIME - arg0_29.selectCountdown)
			setActive(arg0_29.rtFloatUI, true)
			arg0_29:AfterSelect()
		else
			assert(false)
		end

		setAnchoredPosition(arg1_29, {
			x = arg0_29.deltaMove * 10
		})
	end)
	quickPlayAnimator(arg1_29:Find("Image"), "Idle")
end

function var0_0.PlayEffect(arg0_32, arg1_32)
	setAnchoredPosition(arg0_32.rtEffectObject, {
		x = arg0_32.deltaMove * 10
	})

	arg0_32.effectCountdownDic[arg1_32] = DOAPPGameConfig.EFFECT_COUNTDOWN[arg1_32]
end

function var0_0.AfterSelect(arg0_33)
	if arg0_33.selectAction and arg0_33.otherSelectAction then
		setActive(arg0_33.rtFloatUI, false)
		switch((arg0_33.selectAction - arg0_33.otherSelectAction + 3) % 3, {
			[0] = function()
				quickPlayAnimator(arg0_33.rtTarget:Find("Image"), "Draw")
				quickPlayAnimator(arg0_33.rtOtherTarget:Find("Image"), "Draw")

				arg0_33.stopTarget = nil

				arg0_33:PlayEffect("Draw")

				arg0_33.blockMoveBg = true
			end,
			function()
				arg0_33.deltaMove = arg0_33.deltaMove + 1

				local var0_35 = math.abs(arg0_33.deltaMove) > 2 and {
					"Win_",
					"Lose_"
				} or {
					"Attack_",
					"Damage_"
				}

				setParent(arg0_33.rtTarget, arg0_33.rtPlayContent:Find("front"))
				quickPlayAnimator(arg0_33.rtTarget:Find("Image"), var0_35[1] .. var2_0[arg0_33.selectAction])

				arg0_33.statusTarget = var0_35[1] .. var2_0[arg0_33.selectAction]
				arg0_33.countTarget = 0

				setParent(arg0_33.rtOtherTarget, arg0_33.rtPlayContent:Find("back"))
				quickPlayAnimator(arg0_33.rtOtherTarget:Find("Image"), var0_35[2] .. var2_0[arg0_33.otherSelectAction])

				arg0_33.statusOther = var0_35[2] .. var2_0[arg0_33.otherSelectAction]
				arg0_33.countOther = 0
				arg0_33.rtEffectObject = arg0_33.rtPlayContent:Find("middle/EffectObject")
				arg0_33.stopTarget = arg0_33.rtOtherTarget

				arg0_33:PlayEffect(var2_0[arg0_33.selectAction])

				arg0_33.blockMoveBg = true

				if math.abs(arg0_33.deltaMove) > 2 then
					arg0_33.loseDropCountdown = DOAPPGameConfig.LOSE_SOUND_COUNTDOWN[var2_0[arg0_33.otherSelectAction]] + defaultValue(DOAPPGameConfig.EFFECT_STOP_TIME[var2_0[arg0_33.selectAction]], 0)
				end
			end,
			function()
				arg0_33.deltaMove = arg0_33.deltaMove - 1

				local var0_36 = math.abs(arg0_33.deltaMove) > 2 and {
					"Win_",
					"Lose_"
				} or {
					"Attack_",
					"Damage_"
				}

				setParent(arg0_33.rtTarget, arg0_33.rtPlayContent:Find("back"))
				quickPlayAnimator(arg0_33.rtTarget:Find("Image"), var0_36[2] .. var2_0[arg0_33.selectAction])

				arg0_33.statusTarget = var0_36[2] .. var2_0[arg0_33.selectAction]
				arg0_33.countTarget = 0

				setParent(arg0_33.rtOtherTarget, arg0_33.rtPlayContent:Find("front"))
				quickPlayAnimator(arg0_33.rtOtherTarget:Find("Image"), var0_36[1] .. var2_0[arg0_33.otherSelectAction])

				arg0_33.statusOther = var0_36[1] .. var2_0[arg0_33.otherSelectAction]
				arg0_33.countOther = 0
				arg0_33.rtEffectObject = arg0_33.rtPlayContent:Find("middle/EffectOtherObject")
				arg0_33.stopTarget = arg0_33.rtTarget

				arg0_33:PlayEffect(var2_0[arg0_33.otherSelectAction])

				arg0_33.blockMoveBg = true

				if math.abs(arg0_33.deltaMove) > 2 then
					arg0_33.loseDropCountdown = DOAPPGameConfig.LOSE_SOUND_COUNTDOWN[var2_0[arg0_33.selectAction]] + defaultValue(DOAPPGameConfig.EFFECT_STOP_TIME[var2_0[arg0_33.otherSelectAction]], 0)
				end
			end
		})

		arg0_33.selectAction = nil
		arg0_33.otherSelectAction = nil
		arg0_33.selectCountdown = nil
	end
end

function var0_0.ReadyPoint(arg0_37)
	if arg0_37.readyPointCount > 0 then
		arg0_37.readyPointCount = 0

		if arg0_37.deltaMove > 0 then
			arg0_37.myPoint = arg0_37.myPoint + 1
		else
			arg0_37.otherPoint = arg0_37.otherPoint + 1
		end

		arg0_37:UpdatePoint()

		if arg0_37.myPoint > 2 or arg0_37.otherPoint > 2 then
			arg0_37:EndGame(arg0_37.myPoint - arg0_37.otherPoint)
		else
			arg0_37.nextCountdown = DOAPPGameConfig.NEXT_ROUND_COUNTDOWN

			eachChild(arg0_37.rtPointShow:Find("left"), function(arg0_38)
				setActive(arg0_38, arg0_38.name == tostring(arg0_37.myPoint))
			end)
			eachChild(arg0_37.rtPointShow:Find("right"), function(arg0_39)
				setActive(arg0_39, arg0_39.name == tostring(arg0_37.otherPoint))
			end)
			setActive(arg0_37.rtPointShow, true)
		end
	else
		arg0_37.readyPointCount = arg0_37.readyPointCount + 1
	end
end

function var0_0.GetResultInfo(arg0_40, arg1_40)
	if arg1_40 then
		return arg0_40.rtOtherTarget.name, arg0_40.otherPoint, arg0_40.result * -1
	else
		return arg0_40.rtTarget.name, arg0_40.myPoint, arg0_40.result
	end
end

function var0_0.ResetGame(arg0_41)
	arg0_41.timeCount = DOAPPGameConfig.ALL_TIME

	setText(arg0_41.textTime, string.format("%02ds", arg0_41.timeCount))

	arg0_41.deltaMove = 0

	if not IsNil(arg0_41.rtTarget) then
		Destroy(arg0_41.rtTarget)

		arg0_41.rtTarget = nil
	end

	if not IsNil(arg0_41.rtOtherTarget) then
		Destroy(arg0_41.rtOtherTarget)

		arg0_41.rtOtherTarget = nil
	end

	setAnchoredPosition(arg0_41.rtViewport:Find("MainContent"), {
		x = 0
	})
	eachChild(arg0_41.rtViewport:Find("MainContent/bg"), function(arg0_42)
		setAnchoredPosition(arg0_42, {
			x = 0
		})
	end)

	arg0_41.myPoint = 0
	arg0_41.otherPoint = 0
	arg0_41.readyPointCount = 0

	setActive(arg0_41.rtPointShow, false)

	arg0_41.effectCountdownDic = {}
end

function var0_0.ReadyGame(arg0_43, arg1_43)
	arg0_43:SetCharacter(arg1_43.name)
	arg0_43:UpdatePoint()
	arg0_43:PauseGame()
end

function var0_0.StartGame(arg0_44)
	arg0_44.isStart = true

	arg0_44:UpdateReady(arg0_44.rtTarget)
	arg0_44:UpdateReady(arg0_44.rtOtherTarget)
	arg0_44:ResumeGame()
end

function var0_0.EndGame(arg0_45, arg1_45)
	arg0_45.isStart = false

	arg0_45:PauseGame()

	arg0_45.result = arg1_45 or 0

	arg0_45.binder:openUI("result")
end

function var0_0.ResumeGame(arg0_46)
	arg0_46.isPause = false

	arg0_46.timer:Start()
	var1_0(arg0_46.rtViewport, 1)
end

function var0_0.PauseGame(arg0_47)
	arg0_47.isPause = true

	arg0_47.timer:Stop()
	var1_0(arg0_47.rtViewport, 0)
end

function var0_0.OnTimer(arg0_48, arg1_48)
	arg0_48.timeCount = arg0_48.timeCount - arg1_48

	setText(arg0_48.textTime, string.format("%02ds", arg0_48.timeCount))

	if arg0_48.timeCount <= 0 then
		arg0_48:EndGame(arg0_48.myPoint - arg0_48.otherPoint)

		return
	end

	if arg0_48.selectCountdown then
		arg0_48.selectCountdown = arg0_48.selectCountdown - arg1_48

		setSlider(arg0_48.rtFloatUI:Find(arg0_48.otherSelectAction .. "/Slider"), 0, DOAPPGameConfig.SELECT_TIME, DOAPPGameConfig.SELECT_TIME - arg0_48.selectCountdown)
		setText(arg0_48.rtFloatUI:Find(arg0_48.otherSelectAction .. "/Text"), string.format("%2d%%", (DOAPPGameConfig.SELECT_TIME - arg0_48.selectCountdown) * 100 / DOAPPGameConfig.SELECT_TIME))

		if arg0_48.selectCountdown <= 0 then
			arg0_48.selectAction = (arg0_48.otherSelectAction + 1) % 3 + 1

			setActive(arg0_48.rtBtns, false)
			arg0_48:AfterSelect()
		end
	end

	if arg0_48.nextCountdown then
		arg0_48.nextCountdown = arg0_48.nextCountdown - arg1_48

		if arg0_48.nextCountdown <= 0 then
			arg0_48.nextCountdown = nil

			setActive(arg0_48.rtPointShow, false)

			arg0_48.deltaMove = 0

			arg0_48:UpdateReady(arg0_48.rtTarget)
			arg0_48:UpdateReady(arg0_48.rtOtherTarget)
		end
	end

	for iter0_48, iter1_48 in pairs(arg0_48.effectCountdownDic) do
		arg0_48.effectCountdownDic[iter0_48] = arg0_48.effectCountdownDic[iter0_48] - arg1_48

		if arg0_48.effectCountdownDic[iter0_48] <= 0 then
			arg0_48.effectCountdownDic[iter0_48] = nil

			setActive(arg0_48.rtEffectObject:Find(iter0_48), true)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(DOAPPGameConfig.SOUND_EFFECT_PP)

			arg0_48.blockMoveBg = false

			if arg0_48.stopTarget then
				arg0_48.stopCount = DOAPPGameConfig.EFFECT_STOP_TIME[iter0_48]

				if arg0_48.stopCount then
					onNextTick(function()
						var1_0(arg0_48.stopTarget, 0)
					end)
				end
			end
		end
	end

	if arg0_48.stopCount then
		arg0_48.stopCount = arg0_48.stopCount - arg1_48

		if arg0_48.stopCount <= 0 then
			arg0_48.stopCount = nil

			var1_0(arg0_48.stopTarget, 1)
		end
	end

	if arg0_48.loseDropCountdown then
		arg0_48.loseDropCountdown = arg0_48.loseDropCountdown - arg1_48

		if arg0_48.loseDropCountdown <= 0 then
			arg0_48.loseDropCountdown = nil

			pg.CriMgr.GetInstance():PlaySoundEffect_V3(DOAPPGameConfig.SOUND_EFFECT_DROP)
		end
	end

	if not arg0_48.blockMoveBg then
		local function var0_48(arg0_50, arg1_50)
			local var0_50 = arg0_50.anchoredPosition.x / arg1_50
			local var1_50 = var0_50 + (arg0_48.deltaMove - var0_50 > 0 and 1 or -1) * (arg1_48 / DOAPPGameConfig.BG_MOVE_TIME)
			local var2_50 = var0_50 < arg0_48.deltaMove and {
				var0_50,
				arg0_48.deltaMove
			} or {
				arg0_48.deltaMove,
				var0_50
			}
			local var3_50 = math.clamp(var1_50, unpack(var2_50))

			setAnchoredPosition(arg0_50, {
				x = var3_50 * arg1_50
			})
		end

		local var1_48 = arg0_48.rtViewport:Find("MainContent")

		if var1_48.anchoredPosition.x ~= arg0_48.deltaMove * DOAPPGameConfig.BG_DISTANCE then
			var0_48(var1_48, -1 * DOAPPGameConfig.BG_DISTANCE)

			local var2_48 = var1_48:Find("bg")
			local var3_48 = var2_48.childCount

			for iter2_48 = 1, var3_48 - 1 do
				var0_48(var2_48:GetChild(iter2_48 - 1), (iter2_48 - var3_48) * DOAPPGameConfig.BG_DISTANCE)
			end
		end
	end
end

function var0_0.willExit(arg0_51)
	if arg0_51.handle then
		UpdateBeat:RemoveListener(arg0_51.handle)
	end
end

return var0_0
