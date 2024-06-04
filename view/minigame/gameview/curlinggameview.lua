local var0 = class("CurlingGameView", import("..BaseMiniGameView"))
local var1 = "event:/ui/ddldaoshu2"
local var2 = "event:/ui/taosheng"
local var3 = "event:/ui/minigame_hitcake"
local var4 = "event:/ui/zhengque"
local var5 = "event:/ui/shibai"
local var6 = 1
local var7 = 2
local var8 = 3
local var9 = {
	20,
	40,
	60
}
local var10 = 4
local var11 = Vector2(-720, 0)
local var12 = {
	-250,
	250
}
local var13 = Vector2(-250, -42)
local var14 = {
	1,
	10,
	30
}
local var15 = 0.2
local var16 = false
local var17 = {
	walker = 0.1,
	miner = 0.2,
	wall = 0,
	oil = 0.2,
	cube = 0.2
}
local var18 = {
	walker = 2,
	miner = 2,
	wall = 0,
	oil = 2,
	cube = 2
}
local var19 = {
	0.5,
	5,
	10
}
local var20 = {
	0.5,
	5,
	10
}
local var21 = Vector2(400, -600)
local var22 = Vector2(400, 500)
local var23 = 1
local var24 = 2
local var25 = 3
local var26 = 4
local var27 = Vector2(617, -108)
local var28 = 0.7
local var29 = {
	111,
	222,
	333
}
local var30 = {
	3000,
	2000,
	1000
}
local var31 = 1
local var32 = 2
local var33 = 3
local var34 = 4
local var35 = {
	walker = 900,
	miner = 300,
	wall = 100,
	oil = 300,
	cube = 300
}
local var36 = 1
local var37 = {
	oil = {
		{
			appear = 0.8,
			num = 1
		},
		{
			appear = 0.1,
			num = 1
		}
	},
	cube = {
		{
			appear = 0.8,
			num = 1
		},
		{
			appear = 0.1,
			num = 1
		}
	},
	miner = {
		{
			appear = 1,
			num = 1
		},
		{
			appear = 0.1,
			num = 1
		}
	},
	walker = {
		appear = 1,
		path = {
			var23,
			var24,
			var25,
			var26
		}
	}
}
local var38 = {
	cube = 3.5,
	miner = 3.5,
	walker = 4.5,
	oil = 3.5
}
local var39 = true
local var40 = "event_push"
local var41 = "event_speed"
local var42 = "event_hit"
local var43 = "event_result"
local var44 = "event_next"
local var45 = "event_game_pause"
local var46 = "event_game_resume"
local var47 = "event_add_score"

local function var48(arg0, arg1)
	local var0 = {
		Ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
			arg0.powerTF = findTF(arg0._tf, "power")
			arg0.powerSlider = GetComponent(arg0.powerTF, typeof(Slider))

			arg0:InitPowerSlider()

			arg0.animator = GetComponent(arg0._tf, typeof(Animator))
			arg0.aniDft = GetComponent(arg0._tf, typeof(DftAniEvent))

			arg0.aniDft:SetTriggerEvent(function()
				arg0:Push()
			end)

			arg0.dragTrigger = GetOrAddComponent(arg0._tf, "EventTriggerListener")

			arg0.dragTrigger:AddPointDownFunc(function(arg0, arg1)
				if not arg0.canClick then
					return
				end

				arg0.canClick = false
				arg0.charging = true
				arg0.originScreenY = arg1.position.y
				arg0.originY = arg0._tf.anchoredPosition.y

				arg0:Charge()
			end)
			arg0.dragTrigger:AddDragFunc(function(arg0, arg1)
				if not arg0.charging then
					return
				end

				local var0 = arg1.position.y - arg0.originScreenY + arg0.originY

				var0 = var0 >= var12[1] and var0 or var12[1]
				var0 = var0 <= var12[2] and var0 or var12[2]

				setLocalPosition(arg0._tf, Vector2(arg0._tf.anchoredPosition.x, var0))
			end)
			arg0.dragTrigger:AddPointUpFunc(function(arg0, arg1)
				if not arg0.charging then
					return
				end

				arg0.charging = false

				arg0.animator:SetInteger("Throw", arg0.phase)
				arg0.animator:SetInteger("Charge", 0)
			end)
			arg0._event:bind(var43, function(arg0, arg1, arg2)
				arg0.animator:SetInteger("Result", arg1.result)
			end)
			arg0._event:bind(var44, function(arg0, arg1, arg2)
				arg0:Reset()
				arg0:Start()
			end)
			arg0:Reset()
		end,
		Start = function(arg0)
			arg0.canClick = true
		end,
		Reset = function(arg0)
			setActive(arg0.powerTF, false)
			setLocalPosition(arg0._tf, var11)
			arg0.animator:SetInteger("Charge", 0)
			arg0.animator:SetInteger("Throw", 0)
			arg0.animator:SetInteger("Result", 0)
			arg0.animator:Play("WaitA")

			arg0.power = 0
			arg0.phase = 0
			arg0.charging = false
			arg0.canClick = false
			arg0.powerSlider.value = 0
		end,
		InitPowerSlider = function(arg0)
			local var0 = 24
			local var1 = 162
			local var2 = var9[1] / var9[3] * var1

			findTF(arg0.powerTF, "progress/green").sizeDelta = Vector2(var2, var0)

			local var3 = (var9[2] - var9[1]) / var9[3] * var1

			findTF(arg0.powerTF, "progress/green/yellow").sizeDelta = Vector2(var3, var0)

			local var4 = (var9[3] - var9[2]) / var9[3] * var1

			findTF(arg0.powerTF, "progress/green/yellow/red").sizeDelta = Vector2(var4, var0)
		end,
		Charge = function(arg0)
			setActive(arg0.powerTF, true)
			setActive(findTF(arg0.powerTF, "binghu_huoyan"), false)

			arg0.phase = var6

			arg0.animator:SetInteger("Charge", arg0.phase)
			LeanTween.value(go(arg0._tf), arg0.power, var9[3], var10):setOnUpdate(System.Action_float(function(arg0)
				arg0.power = arg0
				arg0.powerSlider.value = arg0.power / var9[3]

				if arg0.phase == var6 and arg0.power >= var9[1] then
					arg0.phase = var7

					arg0.animator:SetInteger("Charge", arg0.phase)
				elseif arg0.phase == var7 and arg0.power >= var9[2] then
					arg0.phase = var8

					arg0.animator:SetInteger("Charge", arg0.phase)
					setActive(findTF(arg0.powerTF, "binghu_huoyan"), true)
				end

				if not arg0.charging then
					LeanTween.cancel(go(arg0._tf))
				end
			end))
		end,
		Push = function(arg0)
			arg0._event:emit(var40, {
				power = arg0.power
			})
			setActive(arg0.powerTF, false)
		end
	}

	var0:Ctor()

	return var0
end

local function var49(arg0, arg1, arg2)
	local var0 = {
		Ctor = function(arg0)
			arg0.tpls = arg0
			arg0._event = arg2
			arg0.player = arg1
			arg0.scene = arg0.player.parent

			arg0._event:bind(var40, function(arg0, arg1, arg2)
				if arg0.isPush then
					return
				end

				arg0:Push(arg1.power)
			end)
			arg0._event:bind(var44, function(arg0, arg1, arg2)
				arg0:Reset()
				arg0:Start()
			end)
			arg0._event:bind(var45, function(arg0, arg1, arg2)
				arg0:Pause()
			end)
			arg0._event:bind(var46, function(arg0, arg1, arg2)
				arg0:Resume()
			end)
			arg0:Reset()
		end,
		Start = function(arg0)
			return
		end,
		RandomRole = function(arg0)
			if arg0._tf then
				arg0._tf:SetParent(arg0.tpls, false)
				setActive(arg0._tf, false)
			end

			local var0 = math.random(1, 4)

			arg0._tf = arg0.tpls:GetChild(var0 - 1)

			setActive(arg0._tf, true)

			arg0.speedTF = findTF(arg0._tf, "speed")

			setActive(arg0.speedTF, var16)

			arg0.animator = GetComponent(arg0._tf, typeof(Animator))
			arg0.rigbody = GetComponent(arg0._tf, "Rigidbody2D")
			arg0.rigbody.velocity = Vector2.zero
			arg0.phyItem = GetComponent(arg0._tf, "Physics2DItem")

			arg0.phyItem.CollisionEnter:RemoveAllListeners()
			arg0.phyItem.CollisionEnter:AddListener(function(arg0)
				arg0:OnCollision(arg0)
			end)
		end,
		Reset = function(arg0)
			arg0:RandomRole()

			arg0.rigbody.velocity = Vector2.zero

			arg0._tf:SetParent(findTF(arg0.player, "chargePos"), false)
			setText(arg0.speedTF, 0)
			setLocalPosition(arg0._tf, Vector2.zero)
			setLocalScale(arg0._tf, Vector2.one)
			arg0.animator:Play("Neutral")
			arg0.animator:SetBool("Stop", false)
			arg0.animator:SetInteger("Result", 0)
			arg0.animator:SetInteger("SpeedPhase", 0)

			arg0.isPush = false
			arg0.isStop = true
			arg0.phase = 0
		end,
		Step = function(arg0)
			if var16 then
				setText(arg0.speedTF, arg0.rigbody.velocity:Magnitude())
			end

			if not arg0.isPush or arg0.isStop then
				return
			end

			local var0 = arg0:GetSpeed()

			arg0._event:emit(var41, {
				speed = var0
			})

			if var0 > var14[1] then
				arg0.animator:SetInteger("SpeedPhase", 1)
			elseif var0 > var14[2] then
				arg0.animator:SetInteger("SpeedPhase", 2)
			elseif var0 > var14[3] then
				arg0.animator:SetInteger("SpeedPhase", 3)
			end

			if var0 < var15 then
				arg0.animator:SetBool("Stop", true)

				arg0.isStop = true

				arg0:Result()
			end
		end,
		Push = function(arg0, arg1)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var2)

			arg0.isPush = true
			arg0.isStop = false

			arg0._tf:SetParent(arg0.scene, true)

			local var0 = Vector2(var13.x - arg0._tf.anchoredPosition.x, var13.y - arg0._tf.anchoredPosition.y)

			arg0.rigbody.velocity = var0:Normalize():Mul(arg1)

			arg0:Slip()
		end,
		Slip = function(arg0)
			arg0.animator:SetBool("Stop", false)

			arg0.isStop = false
		end,
		OnCollision = function(arg0, arg1)
			arg0.animator:SetTrigger("Hit")
			arg0._event:emit(var42)
			pg.CriMgr.GetInstance():PlaySoundEffect_V3(var3)

			local var0 = arg1.collider.gameObject.name
			local var1 = 0
			local var2 = Vector2(1, 0)
			local var3 = Vector2(arg0.rigbody.velocity.x, arg0.rigbody.velocity.y)

			if var0 == "wall" then
				var3:Mul(var17.wall)

				var1 = var35.wall

				var2:Mul(var18.wall)
			elseif var0 == "oil" then
				var3:Mul(var17.oil)

				var1 = var35.oil

				var2:Mul(var18.oil)
			elseif var0 == "cube" then
				var3:Mul(var17.cube)

				var1 = var35.cube

				var2:Mul(var18.cube)
			elseif var0 == "miner" then
				var3:Mul(var17.miner)

				var1 = var35.miner

				var2:Mul(var18.miner)
			elseif var0 == "walker" then
				var3:Mul(var17.walker)

				var1 = var35.walker

				var2:Mul(var18.walker)
			end

			arg0.rigbody.velocity = arg0.rigbody.velocity:Sub(var3)
			arg0.rigbody.velocity = arg0.rigbody.velocity:Add(var2)

			local var4 = arg0._tf.anchoredPosition

			arg0._event:emit(var47, {
				score = var1,
				pos = var4
			})
		end,
		Result = function(arg0)
			local var0 = Vector2(arg0._tf.anchoredPosition.x, arg0._tf.anchoredPosition.y / var28)
			local var1 = Vector2.Distance(var27, var0)
			local var2 = 0
			local var3 = var1 <= var29[1] and 1 or var1 <= var29[2] and 2 or var1 <= var29[3] and 3 or 4

			arg0.animator:SetInteger("Result", var3)
			arg0._event:emit(var43, {
				result = var3
			})

			if var3 == 0 or var3 == 4 then
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var5)
			else
				pg.CriMgr.GetInstance():PlaySoundEffect_V3(var4)
			end
		end,
		Pause = function(arg0)
			arg0.speedRecord = arg0.rigbody.velocity
			arg0.rigbody.velocity = Vector2.zero
			arg0.animator.speed = 0
		end,
		Resume = function(arg0)
			arg0.rigbody.velocity = arg0.speedRecord
			arg0.animator.speed = 1
		end,
		GetSpeed = function(arg0)
			return arg0.rigbody.velocity:Magnitude()
		end
	}

	var0:Ctor()

	return var0
end

local function var50(arg0, arg1)
	local var0 = {
		Ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
			arg0.animator = GetComponent(arg0._tf, typeof(Animator))

			arg0._event:bind(var40, function(arg0, arg1, arg2)
				arg0:TurnLeft()
			end)
			arg0._event:bind(var42, function(arg0, arg1, arg2)
				arg0:Hit()
			end)
			arg0._event:bind(var43, function(arg0, arg1, arg2)
				arg0:Result(arg1.result)
			end)
			arg0._event:bind(var44, function(arg0, arg1, arg2)
				arg0:Reset()
				arg0:Start()
			end)
		end,
		Start = function(arg0)
			return
		end,
		Reset = function(arg0)
			arg0.animator:SetInteger("Result", 0)
			arg0.animator:Play("WaitA")
		end,
		TurnLeft = function(arg0)
			arg0.animator:SetTrigger("TurnLeft")
		end,
		Result = function(arg0, arg1)
			arg0.animator:SetInteger("Result", arg1)
		end,
		Hit = function(arg0)
			arg0.animator:SetTrigger("Hit")
		end
	}

	var0:Ctor()

	return var0
end

local function var51(arg0, arg1)
	local var0 = {
		Ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
			arg0.animator = GetComponent(arg0._tf, typeof(Animator))

			arg0._event:bind(var44, function(arg0, arg1, arg2)
				arg0:NextRound()
			end)
			arg0:Reset()
		end,
		Start = function(arg0)
			arg0:NextRound()
		end,
		Reset = function(arg0)
			arg0.animator:SetInteger("Round", 0)
			arg0.animator:Play("IdleA")

			arg0.roundNum = 1
		end,
		NextRound = function(arg0)
			arg0.animator:SetInteger("Round", arg0.roundNum)

			if arg0.roundNum == 3 then
				arg0.roundNum = 1
			else
				arg0.roundNum = arg0.roundNum + 1
			end
		end
	}

	var0:Ctor()

	return var0
end

local function var52(arg0, arg1)
	local var0 = {
		Ctor = function(arg0)
			arg0._tf = arg0
			arg0._event = arg1
			arg0.config = var37.miner
			arg0.animator = GetComponent(arg0._tf, typeof(Animator))
			arg0.phyItem = GetComponent(arg0._tf, "Physics2DItem")

			arg0.phyItem.CollisionEnter:AddListener(function(arg0)
				arg0:OnCollision()
			end)

			arg0.phyGrazeItem = GetComponent(findTF(arg0._tf, "GrazeCollider"), "Physics2DItem")

			arg0.phyGrazeItem.TriggerEnter:AddListener(function(arg0)
				arg0:OnGrazeTrigger(arg0)
			end)
			arg0._event:bind(var41, function(arg0, arg1, arg2)
				arg0.hitSpeed = arg1.speed
			end)
			arg0:Reset()
		end,
		Start = function(arg0)
			return
		end,
		Reset = function(arg0)
			arg0.isClash = false
			arg0.hitSpeed = 0
		end,
		OnCollision = function(arg0)
			arg0.isClash = true

			local var0 = 0

			if arg0.hitSpeed > var19[3] then
				var0 = 3
			elseif arg0.hitSpeed > var19[2] then
				var0 = 2
			elseif arg0.hitSpeed > var19[1] then
				var0 = 1
			end

			arg0.animator:SetInteger("Speed", var0)
			arg0.animator:SetTrigger("Clash")
		end,
		OnGrazeTrigger = function(arg0, arg1)
			if arg1.gameObject.name ~= "Ayanami" then
				return
			end

			onDelayTick(function()
				if arg0.isClash then
					return
				end

				arg0.animator:SetTrigger("Graze")
			end, 0.3)
		end
	}

	var0:Ctor()

	return var0
end

local function var53(arg0, arg1)
	local var0 = {}
	local var1 = 1000

	function var0.Ctor(arg0)
		arg0._tf = arg0
		arg0._event = arg1
		arg0.config = var37.walker
		arg0.obstacleTF = arg0._tf.parent
		arg0.bgFrontTF = findTF(arg0.obstacleTF.parent.parent, "bg_front")
		arg0.animator = GetComponent(arg0._tf, typeof(Animator))
		arg0.rigbody = GetComponent(arg0._tf, "Rigidbody2D")
		arg0.phyItem = GetComponent(arg0._tf, "Physics2DItem")

		arg0.phyItem.CollisionEnter:AddListener(function(arg0)
			arg0:OnCollision(arg0)
		end)
		arg0._event:bind(var41, function(arg0, arg1, arg2)
			arg0.hitSpeed = arg1.speed
		end)
		arg0._event:bind(var45, function(arg0, arg1, arg2)
			arg0:Pause()
		end)
		arg0._event:bind(var46, function(arg0, arg1, arg2)
			arg0:Resume()
		end)
	end

	function var0.SetPath(arg0, arg1)
		arg0.pathType = arg1
	end

	function var0.Start(arg0)
		arg0:WalkPath()
	end

	function var0.Reset(arg0)
		setActive(arg0._tf, false)
		setLocalPosition(arg0._tf, Vector2(-1400, 0))

		arg0.rigbody.velocity = Vector2.zero
		arg0.isJumpDown = false
		arg0.isJumpUp = false
		arg0.isForwardNorth = false
		arg0.isForwardSouth = false
		arg0.hitSpeed = 0
		arg0.pathType = 0
	end

	function var0.OnCollision(arg0, arg1)
		arg0.animator:SetTrigger("Clash")

		local var0 = 0

		if arg0.hitSpeed > var20[3] then
			var0 = 3
		elseif arg0.hitSpeed > var20[2] then
			var0 = 2
		elseif arg0.hitSpeed > var20[1] then
			var0 = 1
		end

		arg0.animator:SetInteger("Speed", var0)

		arg0.rigbody.velocity = Vector2.zero
	end

	function var0.WalkPath(arg0)
		if arg0.pathType == var25 or arg0.pathType == var26 then
			setLocalPosition(arg0._tf, var21)
			arg0._tf:SetParent(arg0.bgFrontTF, false)

			arg0.isForwardNorth = true

			arg0.animator:SetBool("IsNorth", true)
			arg0:WalkNorth()
		elseif arg0.pathType == var23 or arg0.pathType == var24 then
			setLocalPosition(arg0._tf, var22)
			arg0._tf:SetParent(arg0.obstacleTF, false)

			arg0.isForwardSouth = true

			arg0.animator:SetBool("IsSouth", true)
			arg0:WalkSouth()
		end
	end

	function var0.WalkNorth(arg0)
		arg0.animator:SetTrigger("WalkN")

		arg0.rigbody.velocity = Vector2(0, 1.5)
	end

	function var0.JumpNorth(arg0)
		arg0.animator:SetTrigger("JumpN")

		if arg0.isJumpUp then
			arg0:WalkNorth()
		elseif arg0.pathType == var26 then
			arg0:WalkNorthwest()
		else
			arg0:WalkNorth()
		end
	end

	function var0.WalkNorthwest(arg0)
		arg0.animator:SetTrigger("WalkNW")

		arg0.rigbody.velocity = Vector2(-1.5, 1.5)
	end

	function var0.WalkSouth(arg0)
		arg0.animator:SetTrigger("WalkS")

		arg0.rigbody.velocity = Vector2(0, -1.5)
	end

	function var0.JumpSouth(arg0)
		arg0.animator:SetTrigger("JumpS")

		if arg0.isJumpDown then
			arg0:WalkSouth()
		elseif arg0.pathType == var24 then
			arg0:WalkSouthwest()
		else
			arg0:WalkSouth()
		end
	end

	function var0.WalkSouthwest(arg0)
		arg0.animator:SetTrigger("WalkSW")

		arg0.rigbody.velocity = Vector2(-1.5, -1.5)
	end

	function var0.Step(arg0)
		local var0 = arg0._tf.anchoredPosition.y

		if var0 > var1 or var0 < -var1 then
			arg0.rigbody.velocity = Vector2.zero

			return
		end

		if arg0.isForwardNorth then
			if not arg0.isJumpDown and var0 >= -470 then
				arg0.isJumpDown = true

				arg0:JumpNorth()
				onDelayTick(function()
					arg0._tf:SetParent(arg0.obstacleTF, false)
				end, 0.3)
			end

			if not arg0.isJumpUp and var0 >= 310 then
				arg0.isJumpUp = true

				arg0:JumpNorth()
			end
		end

		if arg0.isForwardSouth then
			if not arg0.isJumpUp and var0 <= 370 then
				arg0.isJumpUp = true

				arg0:JumpSouth()
			end

			if not arg0.isJumpDown and var0 <= -420 then
				arg0.isJumpDown = true

				arg0:JumpSouth()
				onDelayTick(function()
					arg0._tf:SetParent(arg0.bgFrontTF, false)
				end, 0.3)
			end
		end
	end

	function var0.Pause(arg0)
		arg0.speedRecord = arg0.rigbody.velocity
		arg0.rigbody.velocity = Vector2.zero
		arg0.animator.speed = 0
	end

	function var0.Resume(arg0)
		arg0.rigbody.velocity = arg0.speedRecord
		arg0.animator.speed = 1
	end

	var0:Ctor()

	return var0
end

function var0.getUIName(arg0)
	return "CurlingGameUI"
end

function var0.didEnter(arg0)
	arg0:initEvent()
	arg0:initData()
	arg0:initUI()
	arg0:initGameUI()
	arg0:initController()
	arg0:updateMainUI()
	arg0:openMainUI()
	arg0:AutoFitScreen()
end

function var0.AutoFitScreen(arg0)
	local var0 = Screen.width / Screen.height
	local var1 = 1.77777777777778
	local var2 = arg0:findTF("bg_back")
	local var3 = 2331
	local var4 = var2.rect.height
	local var5

	if var1 <= var0 then
		local var6 = 1080 * var0

		var5 = math.clamp(var6 / var3, 1, 2)
	else
		local var7 = 1920 / var0

		var5 = math.clamp(var7 / var4, 1, 2)
	end

	setLocalScale(arg0._tf, {
		x = var5,
		y = var5,
		z = var5
	})
end

function var0.initEvent(arg0)
	arg0:bind(var43, function(arg0, arg1, arg2)
		if arg1.result ~= var34 then
			arg0:addScore(var30[arg1.result])
		end

		arg0:obsFadeOut()
		onDelayTick(function()
			arg0:nextRoundGame()
		end, var36)
	end)
	arg0:bind(var47, function(arg0, arg1, arg2)
		if arg1.score and arg1.score ~= 0 then
			arg0:addScore(arg1.score, arg1.pos)
		end
	end)
end

function var0.initData(arg0)
	local var0 = Application.targetFrameRate or 60

	if var0 > 60 then
		var0 = 60
	end

	if not Physics2D.autoSimulation then
		arg0.needManualSimulate = true
	end

	arg0.timer = Timer.New(function()
		arg0:onTimer()

		if arg0.needManualSimulate then
			Physics2D.Simulate(1 / var0)
		end
	end, 1 / var0, -1)
end

function var0.initUI(arg0)
	arg0.clickMask = arg0:findTF("ui/click_mask")
	arg0.mainUI = arg0:findTF("ui/main_ui")
	arg0.listScrollRect = GetComponent(findTF(arg0.mainUI, "item_list"), typeof(ScrollRect))

	onButton(arg0, arg0:findTF("skin_btn", arg0.mainUI), function()
		local var0 = pg.mini_game[arg0:GetMGData().id].simple_config_data.skin_shop_id

		pg.m02:sendNotification(GAME.GO_SCENE, SCENE.SKINSHOP, {
			skinId = var0
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("return_btn", arg0.mainUI), function()
		arg0:emit(var0.ON_BACK_PRESSED)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("help_btn", arg0.mainUI), function()
		pg.MsgboxMgr.GetInstance():ShowMsgBox({
			type = MSGBOX_TYPE_HELP,
			helps = pg.gametip.CurlingGame_tips1.tip
		})
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("start_btn", arg0.mainUI), function()
		arg0:readyStart()
	end, SFX_PANEL)

	arg0.totalTimes = arg0:getGameTotalTime()

	local var0 = arg0:getGameUsedTimes() - 4 < 0 and 0 or arg0:getGameUsedTimes() - 4

	scrollTo(arg0.listScrollRect, 0, 1 - var0 / (arg0.totalTimes - 4))
	onButton(arg0, arg0:findTF("right_panel/arrows_up", arg0.mainUI), function()
		local var0 = arg0.listScrollRect.normalizedPosition.y + 1 / (arg0.totalTimes - 4)

		if var0 > 1 then
			var0 = 1
		end

		scrollTo(arg0.listScrollRect, 0, var0)
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("right_panel/arrows_down", arg0.mainUI), function()
		local var0 = arg0.listScrollRect.normalizedPosition.y - 1 / (arg0.totalTimes - 4)

		if var0 < 0 then
			var0 = 0
		end

		scrollTo(arg0.listScrollRect, 0, var0)
	end, SFX_PANEL)

	local var1 = arg0:findTF("item_tpl", arg0.mainUI)

	arg0.itemList = {}

	local var2 = pg.mini_game[arg0:GetMGData().id].simple_config_data.drop

	for iter0 = 1, #var2 do
		local var3 = tf(instantiate(var1))

		var3.name = "item_" .. iter0

		setParent(var3, arg0:findTF("item_list/Viewport/Content", arg0.mainUI))

		local var4 = iter0

		GetSpriteFromAtlasAsync("ui/minigameui/curlinggameui_atlas", "text_" .. var4, function(arg0)
			setImageSprite(arg0:findTF("bg/text", var3), arg0, true)
		end)
		setActive(var3, true)
		table.insert(arg0.itemList, var3)

		local var5 = arg0:findTF("award", var3)
		local var6 = {
			type = var2[iter0][1],
			id = var2[iter0][2],
			count = var2[iter0][3]
		}

		updateDrop(var5, var6)
		onButton(arg0, var5, function()
			arg0:emit(BaseUI.ON_DROP, var6)
		end, SFX_PANEL)
	end

	arg0.countUI = arg0:findTF("ui/count_ui")
	arg0.countAnimator = GetComponent(arg0:findTF("count", arg0.countUI), typeof(Animator))
	arg0.countDft = GetOrAddComponent(arg0:findTF("count", arg0.countUI), typeof(DftAniEvent))

	arg0.countDft:SetTriggerEvent(function()
		return
	end)
	arg0.countDft:SetEndEvent(function()
		setActive(arg0.countUI, false)
		arg0:startGame()
	end)

	arg0.pauseUI = arg0:findTF("ui/pause_ui")

	onButton(arg0, arg0:findTF("ad/panel/sure_btn", arg0.pauseUI), function()
		setActive(arg0.pauseUI, false)
		arg0:resumeGame()
	end, SFX_PANEL)

	arg0.returnUI = arg0:findTF("ui/return_ui")

	onButton(arg0, arg0:findTF("ad/panel/sure_btn", arg0.returnUI), function()
		setActive(arg0.returnUI, false)
		arg0:resumeGame()
		arg0:endGame()
	end, SFX_PANEL)
	onButton(arg0, arg0:findTF("ad/panel/cancel_btn", arg0.returnUI), function()
		setActive(arg0.returnUI, false)
		arg0:resumeGame()
	end, SFX_PANEL)

	arg0.endUI = arg0:findTF("ui/end_ui")

	onButton(arg0, arg0:findTF("ad/panel/end_btn", arg0.endUI), function()
		setActive(arg0.endUI, false)
		arg0:openMainUI()
	end, SFX_PANEL)

	if not arg0.handle then
		arg0.handle = UpdateBeat:CreateListener(arg0.Update, arg0)
	end

	UpdateBeat:AddListener(arg0.handle)
end

function var0.initGameUI(arg0)
	arg0.gameUI = arg0:findTF("ui/game_ui")
	arg0.roundTF = arg0:findTF("score_panel/round_text", arg0.gameUI)
	arg0.scoreTF = arg0:findTF("score_panel/score_text", arg0.gameUI)

	onButton(arg0, arg0:findTF("pause_btn", arg0.gameUI), function()
		arg0:pauseGame()
		setActive(arg0.pauseUI, true)
	end)
	onButton(arg0, arg0:findTF("return_btn", arg0.gameUI), function()
		arg0:pauseGame()
		setActive(arg0.returnUI, true)
	end)

	arg0.scoreGroup = arg0:findTF("score_group", arg0.gameUI)

	setActive(arg0:findTF("bg_front/wall"), var39)
end

function var0.initController(arg0)
	arg0.scene = arg0:findTF("scene")
	arg0.gridTF = arg0:findTF("ui/grid")
	arg0.player = var48(arg0:findTF("player", arg0.scene), arg0)
	arg0.phy = arg0:findTF("Ayanami_phy", arg0.scene)
	arg0.drawDot = arg0:findTF("draw_dot", arg0.scene)
	arg0.curlingTpls = arg0:findTF("curling_Tpl", arg0.scene)
	arg0.curling = var49(arg0.curlingTpls, arg0.player._tf, arg0)
	arg0.ofunya = var50(arg0:findTF("bg_back/07_Ofunya"), arg0)
	arg0.manjuu = var51(arg0:findTF("bg_back/08_Manjuu"), arg0)
	arg0.walker = var53(arg0:findTF("obstacle/walker", arg0.scene), arg0)
	arg0.obsTF = arg0:findTF("scene/obstacle")
	arg0.obsCanvas = GetComponent(arg0.obsTF, typeof(CanvasGroup))
	arg0.obsTpl = arg0:findTF("scene/obstacle_Tpl")
	arg0.minerGroups = arg0:findTF("miner_groups", arg0.obsTF)
	arg0.oilGroups = arg0:findTF("oil_groups", arg0.obsTF)
	arg0.cubeGroups = arg0:findTF("cube_groups", arg0.obsTF)
end

function var0.updateMainUI(arg0)
	local var0 = arg0:getGameUsedTimes()
	local var1 = arg0:getGameTimes()

	for iter0 = 1, #arg0.itemList do
		setActive(arg0:findTF("lock", arg0.itemList[iter0]), false)
		setActive(arg0:findTF("finish", arg0.itemList[iter0]), false)

		if iter0 <= var0 then
			setActive(arg0:findTF("finish", arg0.itemList[iter0]), true)
		elseif iter0 == var0 + 1 and var1 >= 1 then
			-- block empty
		elseif var0 < iter0 and iter0 <= var0 + var1 then
			-- block empty
		else
			setActive(arg0:findTF("award", arg0.itemList[iter0]), false)
			setActive(arg0:findTF("lock", arg0.itemList[iter0]), true)
		end
	end

	arg0.totalTimes = arg0:getGameTotalTime()

	local var2 = 1 - (arg0:getGameUsedTimes() - 3 < 0 and 0 or arg0:getGameUsedTimes() - 3) / (arg0.totalTimes - 4)

	if var2 > 1 then
		var2 = 1
	end

	scrollTo(arg0.listScrollRect, 0, var2)
	arg0:checkGet()
end

function var0.checkGet(arg0)
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

function var0.openMainUI(arg0)
	setActive(arg0.gameUI, false)
	setActive(arg0.mainUI, true)
	arg0:updateMainUI()
end

function var0.readyStart(arg0)
	setActive(arg0.mainUI, false)
	setActive(arg0.countUI, true)
	arg0.countAnimator:Play("count")
	pg.CriMgr.GetInstance():PlaySoundEffect_V3(var1)
	arg0:resetGame()
end

function var0.resetGame(arg0)
	arg0.gameStartFlag = false
	arg0.gamePause = false
	arg0.gameEndFlag = false
	arg0.scoreNum = 0
	arg0.roundNum = 1

	arg0.player:Reset()
	arg0.curling:Reset()
	arg0.ofunya:Reset()
	arg0.manjuu:Reset()
	arg0.walker:Reset()
end

function var0.startGame(arg0)
	setActive(arg0.gameUI, true)
	arg0:CoordinateGrid(arg0.gridTF)

	arg0.gameStartFlag = true

	arg0.player:Start()
	arg0.curling:Start()
	arg0.ofunya:Start()
	arg0.manjuu:Start()
	arg0:staticObsStart()
	arg0:updateGameUI()
	arg0:timerStart()
end

function var0.staticObsStart(arg0)
	setActive(arg0.obsTF, true)

	arg0.obsCanvas.alpha = 1

	arg0.walker:Reset()

	local var0 = math.random()
	local var1 = var37.walker

	if var0 <= var1.appear then
		setActive(arg0.walker._tf, true)
		setLocalScale(arg0.walker._tf, Vector2(var38.walker, var38.walker))

		local var2 = var1.path[math.random(1, #var1.path)]

		arg0.walker:SetPath(var2)

		local var3 = {}

		if var2 == var26 then
			var3 = {
				8,
				11,
				12,
				14,
				15,
				18,
				17,
				21
			}
		elseif var2 == var24 then
			var3 = {
				5,
				9,
				10,
				14,
				15,
				19,
				20,
				24
			}
		end

		local function var4(arg0)
			for iter0, iter1 in ipairs(var3) do
				if arg0 == iter1 then
					return true
				end
			end

			return false
		end

		local var5 = {}

		for iter0, iter1 in ipairs(arg0.grids) do
			if not var4(iter0) then
				table.insert(var5, iter1)
			end
		end

		arg0.grids = var5

		arg0.walker:Start()
	end

	removeAllChildren(arg0.oilGroups)

	for iter2, iter3 in ipairs(var37.oil) do
		if math.random() <= iter3.appear then
			for iter4 = 1, iter3.num do
				local var6 = cloneTplTo(arg0:findTF("oil_Tpl", arg0.obsTpl), arg0.oilGroups, "oil")

				setActive(var6, true)

				local var7 = math.random(1, #arg0.grids)

				setLocalPosition(var6, Vector2(arg0.grids[var7].x, arg0.grids[var7].y))
				setLocalScale(var6, Vector2(var38.oil, var38.oil))
				table.remove(arg0.grids, var7)
			end
		end
	end

	removeAllChildren(arg0.cubeGroups)

	for iter5, iter6 in ipairs(var37.cube) do
		if math.random() <= iter6.appear then
			for iter7 = 1, iter6.num do
				local var8 = cloneTplTo(arg0:findTF("cube_Tpl", arg0.obsTpl), arg0.cubeGroups, "cube")

				setActive(var8, true)

				local var9 = math.random(1, #arg0.grids)

				setLocalPosition(var8, Vector2(arg0.grids[var9].x, arg0.grids[var9].y))
				setLocalScale(var8, Vector2(var38.cube, var38.cube))
				table.remove(arg0.grids, var9)
			end
		end
	end

	removeAllChildren(arg0.minerGroups)

	arg0.minerControls = {}

	for iter8, iter9 in ipairs(var37.miner) do
		if math.random() <= iter9.appear then
			for iter10 = 1, iter9.num do
				local var10 = cloneTplTo(arg0:findTF("miner_Tpl", arg0.obsTpl), arg0.minerGroups, "miner")

				setActive(var10, true)

				local var11 = var52(var10, arg0)

				table.insert(arg0.minerControls, var11)

				local var12 = math.random(1, #arg0.grids)

				setLocalPosition(var10, Vector2(arg0.grids[var12].x, arg0.grids[var12].y))
				setLocalScale(var10, Vector2(var38.miner, var38.miner))
				table.remove(arg0.grids, var12)
			end
		end
	end
end

function var0.obsFadeOut(arg0)
	arg0:managedTween(LeanTween.value, function()
		setActive(arg0.obsTF, false)
	end, go(arg0.obsTF), 1, 0, 0.5):setOnUpdate(System.Action_float(function(arg0)
		arg0.obsCanvas.alpha = arg0
	end))
end

function var0.Update(arg0)
	arg0:AddDebugInput()
end

function var0.AddDebugInput(arg0)
	if arg0.gamePause or arg0.gameEndFlag then
		return
	end

	if IsUnityEditor then
		-- block empty
	end
end

function var0.changeSpeed(arg0, arg1)
	return
end

function var0.onTimer(arg0)
	arg0.curling:Step()
	arg0.walker:Step()
	arg0:updateGameUI()
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
	setText(arg0.scoreTF, arg0.scoreNum)
	setText(arg0.roundTF, "Round " .. arg0.roundNum)
end

function var0.addScore(arg0, arg1, arg2)
	local var0 = cloneTplTo(arg0:findTF("score_tf", arg0.gameUI), arg0.scoreGroup)

	if arg2 then
		setLocalPosition(var0, arg2)
	else
		setLocalPosition(var0, Vector2(432, 144))
	end

	setActive(var0, false)
	setActive(var0, true)
	setText(var0, "+" .. arg1)

	arg0.scoreNum = arg0.scoreNum + arg1
end

function var0.pauseGame(arg0)
	arg0.gamePause = true

	arg0:timerStop()
	arg0:changeSpeed(0)
	arg0:pauseManagedTween()
	arg0:emit(var45)
end

function var0.resumeGame(arg0)
	arg0.gamePause = false

	arg0:changeSpeed(1)
	arg0:timerStart()
	arg0:resumeManagedTween()
	arg0:emit(var46)
end

function var0.nextRoundGame(arg0)
	removeAllChildren(arg0.scoreGroup)

	if arg0.roundNum == 3 then
		arg0:endGame()
	else
		arg0.roundNum = arg0.roundNum + 1

		arg0:CoordinateGrid(arg0.gridTF)
		arg0:staticObsStart()
		arg0:emit(var44)
	end
end

function var0.endGame(arg0)
	if arg0.gameEndFlag then
		return
	end

	arg0:timerStop()

	arg0.gameEndFlag = true

	setActive(arg0.clickMask, true)
	arg0:managedTween(LeanTween.delayedCall, function()
		arg0.gameEndFlag = false
		arg0.gameStartFlag = false

		setActive(arg0.clickMask, false)
		arg0:showEndUI()
	end, 0.1, nil)
end

function var0.showEndUI(arg0)
	setActive(arg0.endUI, true)

	local var0 = arg0:GetMGData():GetRuntimeData("elements")
	local var1 = arg0.scoreNum
	local var2 = var0 and #var0 > 0 and var0[1] or 0

	setActive(arg0:findTF("ad/panel/cur_score/new", arg0.endUI), var2 < var1)

	if var2 <= var1 then
		var2 = var1

		arg0:StoreDataToServer({
			var2
		})
	end

	local var3 = arg0:findTF("ad/panel/highest_score", arg0.endUI)
	local var4 = arg0:findTF("ad/panel/cur_score", arg0.endUI)

	setText(var3, var2)
	setText(var4, var1)

	if arg0:getGameTimes() and arg0:getGameTimes() > 0 then
		arg0:SendSuccess(0)
	end
end

function var0.CoordinateGrid(arg0, arg1)
	local var0 = Vector2(150, 150)
	local var1 = arg1.rect.width
	local var2 = arg1.rect.height
	local var3 = Vector2(arg1.anchoredPosition.x - var1 / 2, arg1.anchoredPosition.y - var2 / 2)
	local var4 = math.modf(var2 / var0.y)
	local var5 = var2 % var0.y / (var4 + 1)
	local var6 = math.modf(var1 / var0.x)
	local var7 = var1 % var0.x / (var6 + 1)

	arg0.grids = {}

	for iter0 = 1, var6 do
		for iter1 = 1, var4 do
			local var8 = var3.x + iter0 * (var7 + var0.x) - var0.x / 2
			local var9 = var3.y + iter1 * (var5 + var0.y) - var0.y / 2

			table.insert(arg0.grids, Vector2(var8, var9))
		end
	end
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

function var0.onBackPressed(arg0)
	if not arg0.gameStartFlag then
		arg0:emit(var0.ON_BACK_PRESSED)
	else
		if arg0.gameEndFlag then
			return
		end

		if isActive(arg0.pauseUI) then
			setActive(arg0.pauseUI, false)
		end

		arg0:pauseGame()
		setActive(arg0.returnUI, true)
	end
end

function var0.willExit(arg0)
	if arg0.handle then
		UpdateBeat:RemoveListener(arg0.handle)
	end

	arg0:cleanManagedTween()

	if arg0.timer and arg0.timer.running then
		arg0.timer:Stop()
	end

	Time.timeScale = 1
	arg0.timer = nil
end

return var0
